using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Data.Common;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Data.Entity.Infrastructure;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        public DbQuery<T> DbSet<T>() where T : ObjectMappingBase
        {
            return DatabaseSession.DbContext.Set<T>().AsNoTracking();
        }

        public DbSet<T> DbSetTracking<T>() where T : ObjectMappingBase
        {
            return DatabaseSession.DbContext.Set<T>();
        }
        

        #region PaserLinqSqlStatement_Condition(string strSQL)
        public virtual string PaserLinqSqlStatement_Condition(string strSQL)
        {
            strSQL = ParserLinqMappingTable(strSQL);

            //strSQL = strSQL.Replace("\r\n", " ");
            strSQL = strSQL.Replace("\r\n", "\r\n ");
            int index = strSQL.IndexOf(" FROM ");
            strSQL = strSQL.Remove(0, index);

            Dictionary<string, List<string>> nameDic = new Dictionary<string, List<string>>();
            Regex regex = new Regex(@"(\[[^\[\]]+\]) AS (\[Extent\d+\])");
            Match match = regex.Match(strSQL);

            while (match.Success && match.Groups.Count == 3)
            {
                string name =match.Groups[1].Value;
                List<string> vallist;
                if (nameDic.ContainsKey(name))
                    vallist = nameDic[name];
                else
                {
                    vallist = new List<string>();
                    nameDic.Add(name, vallist);
                }

                vallist.Add(match.Groups[2].Value);

                match = match.NextMatch();
            }

            foreach (KeyValuePair<string, List<string>> keyValue in nameDic)
            {
                foreach(var valitem in keyValue.Value)
                {
                    string strAs = string.Format(" AS {0}", valitem);
                    strSQL = strSQL.Replace(strAs, "").Replace(valitem, keyValue.Key);
                }
            }

            const string strwhere = " WHERE ";
            index = strSQL.IndexOf(strwhere);
            strSQL = strSQL.Remove(0, index + strwhere.Length);
            return strSQL;
        }
        #endregion

        private string ParserLinqMappingTable(string strSQL)
        {
            Regex regex = new Regex(@"(?<=\[dbo\]\.\[)[^\[\]]+");
            Match match = regex.Match(strSQL);
            HashSet<string> tablehash = new HashSet<string>();
            while (match.Success)
            {
                if (!tablehash.Contains(match.Value))
                    tablehash.Add(match.Value);
                match = match.NextMatch();
            }

            foreach(var table in tablehash)
            {
                strSQL = strSQL.Replace(string.Format("[dbo].[{0}]", table), string.Format("[dbo].[{0}]", DatabaseSession.GetMappingTable(table)));
            }
            return strSQL;
        }

        #region GetSqlString(IQueryable<object> query, ParameterCollection paras)
        public virtual string GetSqlString(IQueryable query, ParameterCollection paras)
        {
            string strSQL = ParserLinqMappingTable(query.ToString());

            //----------------------------------------------------------------------------------------------------------
            //通过正则获得参数名称
            List<string> parameternames = new List<string>();
            Regex r = new Regex("(?<=@)p__linq__\\d");
            Match mc = r.Match(strSQL);
            while (mc.Success)
            {
                if(!parameternames.Contains(mc.Value))
                    parameternames.Add(mc.Value);
                mc = mc.NextMatch();
            }

            ParametersExpressionVisitor visitor = new ParametersExpressionVisitor();
            visitor.Visit(query.Expression);

            if (visitor.Arguments.Count != parameternames.Count)
                throw new ObjectMappingException("Parameter not matched!");

            for (int i = 0; i < parameternames.Count; i++)
            {
                paras.Add(new Parameter(parameternames[i],visitor.Arguments[i]));
            }

            return strSQL;
        }
        #endregion

        #region GetLinqCommand(IQueryable<object> query)
        public DbCommand GetLinqCommand(IQueryable query)
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = GetSqlString(query, paras);
            DbCommand command = GetSqlStringCommand(strSQL);
            this.AddParameter(command, paras.ToArray());
            return command;
        }
        #endregion

        #region Delete<TElement>(DbQuery<TElement> DbSet, Expression<Func<TElement, bool>> condition)
        public virtual int Delete<TElement>(DbQuery<TElement> DbSet, Expression<Func<TElement, bool>> condition) where TElement : ObjectMappingBase
        {
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(TElement));

            IQueryable<TElement> query = DbSet.Where(condition);
            string strSQL = query.ToString();

            strSQL = string.Format("delete from {0} where {1}", this.GetTableName(tablemapping.Name), this.PaserLinqSqlStatement_Condition(strSQL));

            ParameterCollection paras = new ParameterCollection();
            GetSqlString(query, paras);
            
            return this.ExecuteNonQuery(strSQL,paras.ToArray());
        }
        #endregion

        #region Update<TElement>(DbQuery<TElement> DbSet, TElement obj, Expression<Func<TElement, bool>> condition, HashSet<string> updateprops)
        public virtual int Update<TElement>(DbQuery<TElement> DbSet, TElement obj, Expression<Func<TElement, bool>> condition, HashSet<string> updateprops)
            where TElement : ObjectMappingBase
        {
            if (obj == null)
                throw new ObjectMappingException("obj");

            UpdateCriteria<TElement> criteria = new UpdateCriteria<TElement>();
            foreach (string propname in updateprops)
            {
                ColumnMapping column = criteria.TableMapping.GetColumnMappingByPropertyName(propname);
                if (column == null)
                    throw new ObjectMappingException("column");

                if ((column.IsPK == false) && (column.IsAutoIncrement == false))
                    criteria.UpdateColumn(column.Name, column.GetValue(obj));
                else
                    throw new ObjectMappingException(propname);
            }

            IQueryable<TElement> query = DbSet.Where(condition);
            string strSQL = PaserLinqSqlStatement_Condition(query.ToString());

            ParameterCollection paras = new ParameterCollection();
            GetSqlString(query, paras);
            foreach (Parameter p in paras)
            {
                criteria.OtherParameters.Add(p);
            }

            criteria.Conditions.AddCustom(strSQL);

            return this.Update(criteria);
        }
        #endregion
    }
}
