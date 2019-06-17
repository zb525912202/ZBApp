using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Data.Common;
using System.Data;
using System.Reflection;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region List<TElement> Load<TElement>(RetrieveCriteria<TElement> query)
        public List<TElement> Load<TElement>(RetrieveCriteria<TElement> query) where TElement : ObjectMappingBase
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(query, paras);
            return Load<List<TElement>, TElement>(strSQL, paras.ToArray());
        }
        #endregion

        #region Load<TElement>(ObjectMappingQuery<TElement> query)
        public List<TElement> Load<TElement>(ObjectMappingQuery<TElement> query) where TElement : ObjectMappingBase
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(query, paras);
            return Load<List<TElement>, TElement>(strSQL, paras.ToArray());
        }
        #endregion

        #region Load(RetrieveCriteria query)
        public DataEntityCollection Load(RetrieveCriteria query)
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(query, paras);
            return Load(strSQL, paras.ToArray());
        }
        #endregion

        #region Load(PageAdapter query)
        public DataEntityCollection Load(PageAdapter query)
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(query, paras);
            return Load(strSQL, paras.ToArray());
        }
        #endregion

        #region Load(string strsql, params Parameter[] paras)
        public DataEntityCollection Load(string strsql, params Parameter[] paras)
        {
            DataEntityCollection list = new DataEntityCollection();
            using (IDataReader dr = this.ExecuteReader(strsql, paras))
            {
                for (int i = 0; i < dr.FieldCount; i++)
                {
                    DataEntityColumn item = new DataEntityColumn();
                    item.Column = dr.GetName(i);
                    item.DataType = dr.GetFieldType(i).ToString();
                    list.Columns.Add(item);
                }

                while (dr.Read())
                {
                    DataEntity entity = new DataEntity();
                    for (int i = 0; i < dr.FieldCount; i++)
                    {
                        object val = dr[i];
                        if (val != DBNull.Value)
                        {
                            entity[list.Columns[i].Column] = val;
                        }
                    }
                    list.AddItem(entity);
                }
            }
            return list;
        }
        #endregion

        #region List<TElement> Load<TElement>(PageAdapter<TElement> adapter)
        public List<TElement> Load<TElement>(PageAdapter<TElement> adapter) where TElement : ObjectMappingBase
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(adapter, paras);
            return Load<List<TElement>, TElement>(strSQL, paras.ToArray());
        }
        #endregion

        #region List<TElement> Load<TElement>(string strsql, params Parameter[] paras)
        public List<TElement> Load<TElement>(string strsql, params Parameter[] paras) where TElement : ObjectMappingBase
        {
            return Load<List<TElement>, TElement>(strsql, paras);
        }
        #endregion

        #region List<TElement> Load<TElement>(DbCommand command)
        public List<TElement> Load<TElement>(DbCommand command)
        {
            return Load<List<TElement>, TElement>(command);
        }
        #endregion

        #region TList Load<TList,TElement>(string strsql, params Parameter[] paras)
        TList Load<TList, TElement>(string strsql, params Parameter[] paras)
            where TList : IList, new()
            where TElement : ObjectMappingBase
        {
            TList list = new TList();
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(TElement));
            this.FillData(list, strsql, tablemapping, paras);
            return list;
        }
        #endregion

        #region TList Load<TList, TElement>(DbCommand command)
        TList Load<TList, TElement>(DbCommand command)
            where TList : IList, new()
        {
            TList list = new TList();
            Type t = typeof(TElement);

            if(t.IsPrimitive || (t == typeof(string)))
            {
                using (IDataReader dr = this.ExecuteReader(command))
                {
                    while (dr.Read())
                    {
                        object val = dr[0];
                        if (val == DBNull.Value)
                            list.Add(default(TElement));
                        else
                            list.Add((TElement)val);
                    }
                }
            }
            else if (t.IsSubclassOf(typeof(ObjectMappingBase)))
            {
                TableMapping tablemapping = MappingService.Instance.GetTableMapping(t);
                this.FillData(list, command, tablemapping);
            }
            else
            {
                using (IDataReader dr = this.ExecuteReader(command))
                {
                    int fieldcount = dr.FieldCount;
                    List<string> fieldnames = new List<string>();
                    for (int i = 0; i < fieldcount; i++)
                    {
                        fieldnames.Add(dr.GetName(i));
                    }

                    while (dr.Read())
                    {
                        TElement obj = (TElement)Activator.CreateInstance(t);
                        foreach (string fieldname in fieldnames)
                        {
                            object val = dr[fieldname];
                            PropertyInfo prop = t.GetProperty(fieldname);
                            if ((prop != null) && (val != DBNull.Value))
                                prop.SetValue(obj, val, null);
                        }
                        list.Add(obj);
                    }
                }
            }
            return list;
        }
        #endregion



        #region GetSqlString<TElement>(PageAdapter<TElement> adapter, ParameterCollection paras)
        public virtual string GetSqlString<TElement>(PageAdapter<TElement> adapter, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            throw new ObjectMappingException("current database engine not support GetSqlString(PageAdapter) method!");
        }
        #endregion

        #region GetSqlString(PageAdapter adapter, ParameterCollection paras)
        public virtual string GetSqlString(PageAdapter adapter, ParameterCollection paras)
        {
            throw new ObjectMappingException("current database engine not support GetSqlString(PageAdapter) method!");
        }
        #endregion

        #region GetSqlString_PageAdapterMaxRowCount<TElement>(PageAdapter<TElement> adapter,ParameterCollection paras)
        public virtual string GetSqlString_PageAdapterMaxRowCount<TElement>(PageAdapter<TElement> adapter, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            if (adapter == null)
                throw new ObjectMappingException("adapter is null!");

            string strSQL = "select count(*) from [TABLE] [CONDITION]";
            if (string.IsNullOrEmpty(adapter.ViewName))
                strSQL = strSQL.Replace(ConstSql.Table, this.GetTableName(adapter.TableMapping.Name));
            else
                strSQL = strSQL.Replace(ConstSql.Table, adapter.ViewName);

            string condition = this.GetSqlString(adapter.Conditions, paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            return strSQL;
        }
        #endregion

        #region GetSqlString_PageAdapterMaxRowCount(PageAdapter adapter, ParameterCollection paras)
        public virtual string GetSqlString_PageAdapterMaxRowCount(PageAdapter adapter, ParameterCollection paras)
        {
            if (adapter == null)
                throw new ObjectMappingException("adapter is null!");

            string strSQL = "select count(*) from [TABLE] [CONDITION]";

            //-----------------------------------------------------------------------------------
            if (!string.IsNullOrEmpty(adapter.CustomSqlString_MaxRowCount))
                strSQL = adapter.CustomSqlString_MaxRowCount;
            //-----------------------------------------------------------------------------------

            strSQL = strSQL.Replace(ConstSql.Table, adapter.ViewName);

            string condition = this.GetSqlString(adapter.Conditions, paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            return strSQL;
        }
        #endregion

        #region GetSqlString<TElement>(ObjectMappingQuery<TElement> query, ParameterCollection paras)
        public virtual string GetSqlString<TElement>(ObjectMappingQuery<TElement> query, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            if (query == null)
                throw new ObjectMappingException("query is null!");

            string strSQL = "select [TOPCOUNT] [COLUMNS] from [TABLE] [CONDITION] [ORDER]";

            #region [TABLE]
            string tablename = this.GetTableName(query.TableMapping.Name);
            if (!string.IsNullOrEmpty(query.ViewName))
                tablename = query.ViewName;
            else if(!string.IsNullOrEmpty(query.TableMapping.MasterDetailView))
                tablename = query.TableMapping.MasterDetailView;

            strSQL = strSQL.Replace(ConstSql.Table, tablename);
            #endregion

            #region [TOPCOUNT]
            if (query.TakeCount > 0)
                strSQL = strSQL.Replace(ConstSql.SelectTop, " top " + query.TakeCount.ToString());
            else
                strSQL = strSQL.Replace(ConstSql.SelectTop, " ");
            #endregion

            #region [COLUMNS]
            if (query.SelectSqls.Count > 0)
            {
                string[] selectitems = new string[query.SelectSqls.Count];
                for (int i = 0; i < query.SelectSqls.Count; i++)
                {
                    string item = query.SelectSqls[i];
                    selectitems[i] = ReplaceColumnPlaceholder(query.TableMapping, item);
                }
                string strselects = string.Join(",", selectitems);
                strSQL = strSQL.Replace(ConstSql.Columns, strselects);
            }
            else
                strSQL = strSQL.Replace(ConstSql.Columns, " * ");
            #endregion

            #region [CONDITION]
            if (query.WhereSqls.Count > 0)
            {
                string[] whereitems = new string[query.WhereSqls.Count];
                
                for (int i = 0; i < query.WhereSqls.Count; i++)
                {
                    var item = query.WhereSqls[i];
                    string strwhere = ReplaceColumnPlaceholder(query.TableMapping, item.Item1);
                    for (int a = 0; a < item.Item2.Length; a++)
                    {
                        string paraname = this.BuildParameterName(paras.GenerateParameter(item.Item2[a]));
                        strwhere = strwhere.Replace(string.Format("{0}{1}",ConstSql.Argument_Define_Prefix.ToString(),a + 1), paraname);
                    }
                    whereitems[i] = strwhere;
                }
                string strwheres = string.Join(" and ", whereitems);
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + strwheres);
            }
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            #endregion

            #region [ORDER]
            if (query.OrderBySqls.Count > 0)
            {
                string[] orderitems = new string[query.OrderBySqls.Count];
                for (int i = 0; i < query.OrderBySqls.Count; i++)
                {
                    OrderItem item = query.OrderBySqls[i];
                    string strColumn = ReplaceColumnPlaceholder(query.TableMapping, item.Column);
                    if (item.OrderMode != EnumOrderMode.NONE)
                        orderitems[i] = strColumn + " " + item.OrderMode.ToString();
                    else
                        orderitems[i] = strColumn + " ";
                }
                string strorders = string.Join(",", orderitems);
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + strorders);
            }
            else
                strSQL = strSQL.Replace(ConstSql.Order, " ");
            #endregion

            return strSQL;
        }
        #endregion

        #region GetSqlString<TElement>(RetrieveCriteria<TElement> query,ParameterCollection paras)
        public virtual string GetSqlString<TElement>(RetrieveCriteria<TElement> query, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            if (query == null)
                throw new ObjectMappingException("query is null!");

            string strSQL = "select [TOPCOUNT] [COLUMNS] from [TABLE] [CONDITION] [ORDER]";

            string tablename = this.GetTableName(query.TableMapping.Name);
            if (!string.IsNullOrEmpty(query.ViewName))
                tablename = query.ViewName;

            strSQL = strSQL.Replace(ConstSql.Table, tablename);

            if (query.Top > 0)
                strSQL = strSQL.Replace(ConstSql.SelectTop, " top " + query.Top.ToString());
            else
                strSQL = strSQL.Replace(ConstSql.SelectTop, " ");

            string condition = this.GetSqlString(query.Conditions, paras);
            if (condition == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            string columns = this.GetSqlString(query.Columns);

            if (columns == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Columns, " * ");
            else
                strSQL = strSQL.Replace(ConstSql.Columns, columns);

            string order = this.GetSqlString(query.Orders);
            if (order == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Order, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + order);

            return strSQL;
        }
        #endregion

        #region GetSqlString(RetrieveCriteria query, ParameterCollection paras)
        public virtual string GetSqlString(RetrieveCriteria query, ParameterCollection paras)
        {
            if (query == null)
                throw new ObjectMappingException("query is null!");

            string strSQL = "select [TOPCOUNT] [COLUMNS] from [TABLE] [CONDITION] [ORDER]";

            strSQL = strSQL.Replace(ConstSql.Table, query.ViewName);

            if (query.Top > 0)
                strSQL = strSQL.Replace(ConstSql.SelectTop, " top " + query.Top.ToString());
            else
                strSQL = strSQL.Replace(ConstSql.SelectTop, " ");

            string condition = this.GetSqlString(query.Conditions, paras);
            if (condition == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            string columns = this.GetSqlString(query.Columns, query.PkColumnName);

            if (columns == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Columns, " * ");
            else
                strSQL = strSQL.Replace(ConstSql.Columns, columns);

            string order = this.GetSqlString(query.Orders);
            if (order == string.Empty)
                strSQL = strSQL.Replace(ConstSql.Order, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + order);

            return strSQL;
        }
        #endregion
    }
}
