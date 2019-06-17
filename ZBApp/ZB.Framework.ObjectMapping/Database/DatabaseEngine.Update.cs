using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Collections;
using System.Data.Entity;
using System.Linq.Expressions;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region Update(DataEntityTableDefine t,DataEntity obj)
        public virtual int Update(DataEntityTableDefine t, DataEntity obj)
        {
            ParameterCollection paras = new ParameterCollection();
            paras.Add(new Parameter(t.PkColumn, obj[t.PkColumn]));
            string strSQL = string.Format("update [{0}] set ", t.Table);
            foreach (string prop in obj.Keys)
            {
                if (prop != t.PkColumn)
                {
                    paras.Add(new Parameter(prop, obj[prop]));
                    strSQL += "[" + prop + "] = " + this.BuildParameterName(prop) + ",";
                }
            }
            strSQL = strSQL.Substring(0, strSQL.Length - 1);
            strSQL += " where [" + t.PkColumn + "]=" + this.BuildParameterName(t.PkColumn);
            return this.ExecuteNonQuery(strSQL, paras.ToArray());
        }
        #endregion

        #region UpdateDataEntitiesSortIndex(DataEntityTableDefine t,IList idlist)
        public virtual int UpdateDataEntitiesSortIndex(DataEntityTableDefine t, IList idlist)
        {
            List<StoreCommand> storecommands = new List<StoreCommand>();

            for (int index = 1; index <= idlist.Count; index++)
            {
                StoreCommand sc = new StoreCommand(string.Format("update [{0}] set [{1}]={{0}} where [{2}]={{1}}", t.Table, t.SortColumn, t.PkColumn), index, idlist[index - 1]);
                storecommands.Add(sc);
            }

            return this.ExecuteStoreCommand(storecommands.ToArray());
        }
        #endregion

        #region Update(UpdateCriteria updatecriteria)
        public virtual int Update(UpdateCriteria updatecriteria)
        {
            if (updatecriteria == null)
                throw new ObjectMappingException("updatecriteria");
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString(updatecriteria, paras);

            DbCommand cmd = this.GetSqlStringCommand(strSQL);
            this.AddParameter(cmd, paras.ToArray());

            return this.ExecuteNonQuery(cmd);
        }
        #endregion

        public StoreCommand[] GetUpdateCommand<TElement, TElementKey>(ObjectMappingBase<TElement, TElementKey> obj, HashSet<string> updateprops) where TElement : ObjectMappingBase
        {
            List<StoreCommand> cmds = new List<StoreCommand>();

            TableMapping table = MappingService.Instance.GetTableMapping(obj);
            while (table != null)
            {
                UpdateCriteria<TElement> updatecriteria = GetUpdateCriteria<TElement, TElementKey>(table, obj, updateprops);
                if (!updatecriteria.IsEmpty)
                {
                    ParameterCollection paras = new ParameterCollection();
                    string strSQL = this.GetSqlString(updatecriteria, paras);
                    cmds.Add(GetStoreCommand(strSQL, paras));
                }
                table = table.BaseTableMapping;
            }

            return cmds.ToArray();
        }

        public int Update<TElement>(UpdateCriteria<TElement> updatecriteria) where TElement : ObjectMappingBase
        {
            if (updatecriteria == null)
                throw new ObjectMappingException("updatecriteria");
            if (!updatecriteria.IsEmpty)
            {
                ParameterCollection paras = new ParameterCollection();
                string strSQL = this.GetSqlString(updatecriteria, paras);
                return this.ExecuteNonQuery(strSQL, paras.ToArray());
            }
            return 0;
        }

        public int Update<TElement, TElementKey>(ObjectMappingBase<TElement, TElementKey> obj, HashSet<string> updateprops) where TElement : ObjectMappingBase
        {
            if (obj == null)
                throw new ObjectMappingException("obj");
            TableMapping table = MappingService.Instance.GetTableMapping(obj.GetType());
            if (table == null)
                throw new ObjectMappingException("TableMapping is not found");

            return Update(table, obj, updateprops);
        }

        public int Update<TElement, TElementKey>(TableMapping table, ObjectMappingBase<TElement, TElementKey> obj, HashSet<string> updateprops) where TElement : ObjectMappingBase
        {
            int ret = 0;
            if (table.BaseTableMapping != null)
                ret += Update(table.BaseTableMapping, obj, updateprops);

            UpdateCriteria<TElement> updatecriteria = GetUpdateCriteria<TElement, TElementKey>(table, obj, updateprops);
            ret += this.Update(updatecriteria);
            return ret;
        }

        public virtual UpdateCriteria<TElement> GetUpdateCriteria<TElement, TElementKey>(TableMapping table, ObjectMappingBase<TElement, TElementKey> obj, HashSet<string> updateprops) where TElement : ObjectMappingBase
        {
            UpdateCriteria<TElement> criteria = new UpdateCriteria<TElement>();
            criteria.Conditions.TableMapping = criteria.TableMapping = table;
            criteria.Conditions.Conditions.Add(new SqlConditionItem()
            {
                Type = EnumSqlConditionType.EqualTo,
                ColumnName = criteria.TableMapping.ColumnPK.Name,
                ConditionValue = criteria.TableMapping.ColumnPK.GetValue(obj)
            });

            if ((updateprops != null) && (updateprops.Count > 0))
            {
                foreach (string propname in updateprops)
                {
                    ColumnMapping column = criteria.TableMapping.GetColumnMappingByPropertyName(propname);
                    if (column == null)
                        continue;

                    if ((column.IsPK == false) && (column.IsAutoIncrement == false))
                        criteria.UpdateColumn(column.Name, column.GetValue(obj));
                    else
                        throw new ObjectMappingException(propname);
                }
            }
            else
            {
                foreach (ColumnMapping column in criteria.TableMapping.Columns)
                {
                    if ((column.IsPK == false) && (column.IsAutoIncrement == false))
                    {
                        criteria.UpdateColumn(column.Name, column.GetValue(obj));
                    }
                }

                //处理扩展列---------------------------------------------------------------------------------
                if (criteria.TableMapping.IsSupportExtend)
                {
                    TableExtend tableextend = TableExtendService.Instance.GetTableExtend(criteria.TableMapping.ObjectType);
                    if (tableextend != null && tableextend.Columns.Count > 0)
                    {
                        foreach (var col in tableextend.Columns)
                        {
                            object val = obj[col.Name];
                            if (val == null && col.IsNotNull)
                                throw new ObjectMappingException(string.Format("{0} 扩展字段 {1} 不能为空!", tableextend.ObjectType.Name, col.Name));

                            criteria.UpdateColumn(col.ColumnName, val);
                        }
                    }
                }
                //---------------------------------------------------------------------------------------------
            }
            return criteria;
        }

        #region GetSqlString<TElement>(UpdateCriteria<TElement> updatecriteria, ParameterCollection paras)
        public virtual string GetSqlString<TElement>(UpdateCriteria<TElement> updatecriteria, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            if (updatecriteria == null)
                throw new ObjectMappingException("updatecriteria");

            string strSQL = string.Format("update {0} set ", this.GetTableName(updatecriteria.TableMapping.Name));

            foreach (Parameter para in updatecriteria.UpdateParameters)
            {
                if (para.Value == null)
                    strSQL += para.Name + "=NULL ,";
                else
                {
                    strSQL += para.Name + "=" + this.BuildParameterName(para.Name) + " ,";
                    paras.Add(para);
                }
            }

            foreach (Parameter para in updatecriteria.OtherParameters)
            {
                paras.Add(para);
            }

            strSQL = strSQL.Substring(0, strSQL.Length - 1);

            string condition = this.GetSqlString(updatecriteria.Conditions, paras);

            if (!string.IsNullOrEmpty(condition))
                strSQL += " where " + condition;

            return strSQL;
        }
        #endregion

        #region GetSqlString(UpdateCriteria updatecriteria, ParameterCollection paras)
        public virtual string GetSqlString(UpdateCriteria updatecriteria, ParameterCollection paras)
        {
            if (updatecriteria == null)
                throw new ObjectMappingException("updatecriteria");

            string strSQL = string.Format("update {0} set ", updatecriteria.TableName);

            foreach (Parameter para in updatecriteria.UpdateParameters)
            {
                if (para.Value == null)
                    strSQL += para.Name + "=NULL,";
                else
                {
                    strSQL += para.Name + "=" + this.BuildParameterName(para.Name) + ",";
                    paras.Add(para);
                }
            }

            foreach (string customstatement in updatecriteria.UpdateStatements)
                strSQL += customstatement + ",";

            foreach (Parameter para in updatecriteria.OtherParameters)
                paras.Add(para);

            strSQL = strSQL.Substring(0, strSQL.Length - 1);

            string condition = this.GetSqlString(updatecriteria.Conditions, paras);

            if (!string.IsNullOrEmpty(condition))
                strSQL += " where " + condition;

            return strSQL;
        }
        #endregion
    }
}
