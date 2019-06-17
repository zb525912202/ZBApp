using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Collections;
using System.Data.Common;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        public virtual int DeleteAll<TElement>() where TElement : ObjectMappingBase
        {
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(TElement));
            string strSQL = string.Format("delete from {0}", this.GetTableName(tablemapping.Name));
            return this.ExecuteNonQuery(strSQL);
        }

        public int DeleteByIds<TElement>(string column, IList<int> ids) where TElement : ObjectMappingBase
        {
            return this.DeleteByIds<TElement>(column, ids.ListToStringAppendComma());
        }

        public virtual int DeleteByIds<TElement>(string column, string strids) where TElement : ObjectMappingBase
        {
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(TElement));
            string tableName = this.GetTableName(tablemapping.Name);
            string strSQL = string.Format("delete from {0} where {1}", tableName, SqlCommon.SqlIn(tableName, column, strids));
            return this.ExecuteNonQuery(strSQL);
        }

        #region DeleteDataEntities(DataEntityTableDefine t,IList idlist)
        public virtual int DeleteDataEntities(DataEntityTableDefine t, IList idlist)
        {
            List<StoreCommand> storecommands = new List<StoreCommand>();

            for (int index = 0; index < idlist.Count; index++)
            {
                StoreCommand sc = new StoreCommand(string.Format("delete from [{0}] where [{1}]={{0}}", t.Table, t.PkColumn), idlist[index]);
                storecommands.Add(sc);
            }
            return this.ExecuteStoreCommand(storecommands.ToArray());
        }
        #endregion


        #region Delete(DeleteCriteria deletecriteria)
        public int Delete(DeleteCriteria deletecriteria)
        {
            if (deletecriteria == null)
                throw new ObjectMappingException("deletecriteria");
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(deletecriteria, paras);
            return this.ExecuteNonQuery(strSQL, paras.ToArray());
        }
        #endregion

        public int Delete<TElement, TElementKey>(ObjectMappingBase<TElement, TElementKey> obj) where TElement : ObjectMappingBase
        {
            if (obj == null)
                throw new ObjectMappingException("obj");
            TableMapping table = MappingService.Instance.GetTableMapping(obj.GetType());
            if (table == null)
                throw new ObjectMappingException("TableMapping is not found");

            object id = table.ColumnPK.GetValue(obj);
            return this.DeleteById<TElement>(table, id);
        }

        public int DeleteById<TElement>(object id) where TElement : ObjectMappingBase
        {
            if (id == null)
                throw new ObjectMappingException("id");
            TableMapping table = MappingService.Instance.GetTableMapping(typeof(TElement));
            if (table == null)
                throw new ObjectMappingException("TableMapping is not found");

            return this.DeleteById<TElement>(table, id);
        }


        public int DeleteById<TElement>(TableMapping table, object id) where TElement : ObjectMappingBase
        {
            //先删除子表数据，再删除主表数据
            DeleteCriteria<TElement> criteria = GetDeleteCriteria<TElement>(table, id);
            int ret = this.Delete(criteria);
            if (table.BaseTableMapping != null)
                ret += this.DeleteById<TElement>(table.BaseTableMapping, id);
            return ret;
        }

        public int Delete<TElement>(DeleteCriteria<TElement> deletecriteria) where TElement : ObjectMappingBase
        {
            if (deletecriteria == null)
                throw new ObjectMappingException("deletecriteria");
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(deletecriteria, paras);
            return this.ExecuteNonQuery(strSQL, paras.ToArray());
        }

        public virtual DeleteCriteria<TElement> GetDeleteCriteria<TElement>(TableMapping table, object id) where TElement : ObjectMappingBase
        {
            DeleteCriteria<TElement> criteria = new DeleteCriteria<TElement>();
            criteria.Conditions.TableMapping = criteria.TableMapping = table;
            criteria.Conditions.Conditions.Add(new SqlConditionItem()
            {
                Type = EnumSqlConditionType.EqualTo,
                ColumnName = criteria.TableMapping.ColumnPK.Name,
                ConditionValue = id
            });
            return criteria;
        }

        public StoreCommand[] GetDeleteCommand<TElement, TElementKey>(ObjectMappingBase<TElement, TElementKey> obj) where TElement : ObjectMappingBase
        {
            List<StoreCommand> cmds = new List<StoreCommand>();

            TableMapping table = MappingService.Instance.GetTableMapping(obj);
            while (table != null)
            {
                object id = table.ColumnPK.GetValue(obj);
                DeleteCriteria<TElement> deletecriteria = GetDeleteCriteria<TElement>(table,id);
                ParameterCollection paras = new ParameterCollection();
                string strSQL = this.GetSqlString(deletecriteria, paras);
                cmds.Add(GetStoreCommand(strSQL, paras));
                table = table.BaseTableMapping;
            }
            

            return cmds.ToArray();
        }

        #region GetSqlString<TElement>(DeleteCriteria<TElement> deletecriteria, ParameterCollection paras)
        public virtual string GetSqlString<TElement>(DeleteCriteria<TElement> deletecriteria, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            if (deletecriteria == null)
                throw new ObjectMappingException("deletecriteria");

            string strSQL = string.Format("delete from {0} [CONDITION]", this.GetTableName(deletecriteria.TableMapping.Name));
            string condition = this.GetSqlString(deletecriteria.Conditions, paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            return strSQL;
        }
        #endregion

        #region GetSqlString(DeleteCriteria deletecriteria, ParameterCollection paras)
        public virtual string GetSqlString(DeleteCriteria deletecriteria, ParameterCollection paras)
        {
            if (deletecriteria == null)
                throw new ObjectMappingException("deletecriteria");

            string strSQL = string.Format("delete from {0} [CONDITION]", this.GetTableName(deletecriteria.TableName));
            string condition = this.GetSqlString(deletecriteria.Conditions, paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            return strSQL;
        }
        #endregion
    }
}
