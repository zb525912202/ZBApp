using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region Create(DataEntityTableDefine t,DataEntity obj)
        public virtual int Create(DataEntityTableDefine t, DataEntity obj)
        {
            string strSQL = string.Format("insert into [{0}]", t.Table);
            string columnsSQL = string.Empty;
            string valuesSQL = string.Empty;

            if (!string.IsNullOrWhiteSpace(t.SortColumn))
            {
                obj[t.SortColumn] = this.ExecuteScalar<int>(string.Format("select isnull(max([{0}]),0)+1 from [{1}]", t.SortColumn, t.Table));

                if (!string.IsNullOrWhiteSpace(t.TextColumn) && obj[t.TextColumn] != null)
                {
                    if (string.IsNullOrWhiteSpace(obj[t.TextColumn].ToString()))
                        obj[t.SortColumn] = 0;
                }
            }

            if (t.IsUseSeedFactoryPK)
            {
                if (string.IsNullOrEmpty(t.DataEntityTypeName))
                    throw new ObjectMappingException("使用种子工厂时 DataEntityTypeName 不能为空");

                //obj[t.PkColumn] = this.ExecuteScalar<int>(string.Format("select isnull(max([{0}]),0)+1 from [{1}]", t.PkColumn, t.Table));

                Type entityType = Type.GetType(t.DataEntityTypeName);
                TableMapping tableMapping = MappingService.Instance.GetTableMapping(entityType);
                obj[t.PkColumn] = SeedService.Instance.GetSeed(tableMapping);
            }

            ParameterCollection paras = new ParameterCollection();
            foreach (string prop in obj.Keys)
            {
                if ((prop == t.PkColumn) && t.IsAutoIncrementPK)
                    continue;

                paras.Add(new Parameter(prop, obj[prop]));
                columnsSQL += string.Format("[{0}],", prop);
                valuesSQL += this.BuildParameterName(prop) + ",";
            }
            columnsSQL = columnsSQL.Substring(0, columnsSQL.Length - 1);
            valuesSQL = valuesSQL.Substring(0, valuesSQL.Length - 1);
            strSQL += "(" + columnsSQL + ") values(" + valuesSQL + ")";

            return this.ExecuteNonQuery(strSQL, paras.ToArray());
        }
        #endregion


        public virtual int Create<TElement, TElementKey>(ObjectMappingBase<TElement, TElementKey> obj) where TElement : ObjectMappingBase
        {
            if (obj == null)
                throw new ObjectMappingException("Create object is null");
            TableMapping table = MappingService.Instance.GetTableMapping(obj.GetType());
            if (table == null)
                throw new ObjectMappingException("TableMapping is not found");
            return Create(table, obj);
        }

        public virtual int Create<TElement, TElementKey>(TableMapping table, ObjectMappingBase<TElement, TElementKey> obj) where TElement : ObjectMappingBase
        {
            //先插入主表数据，再插入从表数据
            if (table.BaseTableMapping != null)
                Create(table.BaseTableMapping, obj);

            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetCreateSqlString(table, obj, paras);
            return this.ExecuteNonQuery(strSQL, paras.ToArray());
        }


        public virtual string GetCreateSqlString<TElement, TElementKey>(TableMapping table, ObjectMappingBase<TElement, TElementKey> obj, ParameterCollection paras) where TElement : ObjectMappingBase
        {
            //使用种子工厂--------------------------------------------------------------------------------
            if (table.ColumnPK.IsUseSeedFactory)
            {
                int tempid = (int)table.ColumnPK.PropertyInfo.GetValue(obj, null);
                if (tempid == 0)
                {
                    tempid = SeedService.Instance.GetSeed(table);
                    table.ColumnPK.PropertyInfo.SetValue(obj, tempid, null);
                }
            }
            //----------------------------------------------------------------------------------------------

            StringBuilder strSQL = new StringBuilder();
            StringBuilder columnsSQL = new StringBuilder();
            StringBuilder valuesSQL = new StringBuilder();

            foreach (ColumnMapping column in table.Columns)
            {
                if (!column.IsAutoIncrement)
                {
                    columnsSQL.Append(column.Name);
                    columnsSQL.Append(',');

                    object val = column.GetValue(obj);
                    if ((val == null) && (column.ColumnType == typeof(byte[])))
                        valuesSQL.Append("NULL,");
                    else
                    {
                        valuesSQL.Append(this.BuildParameterName(column.Name));
                        valuesSQL.Append(',');
                        paras.Add(new Parameter(column.Name, val));
                    }
                }
            }

            //处理扩展列---------------------------------------------------------------------------------
            if (table.IsSupportExtend)
            {
                TableExtend tableextend = TableExtendService.Instance.GetTableExtend(table.ObjectType);
                if (tableextend != null && tableextend.Columns.Count > 0)
                {
                    foreach (var col in tableextend.Columns)
                    {
                        object val = obj[col.Name];
                        if (val == null && col.IsNotNull)
                            throw new ObjectMappingException(string.Format("{0} 扩展字段 {1} 不能为空!", tableextend.ObjectType.Name, col.Name));

                        columnsSQL.Append(col.ColumnName);
                        columnsSQL.Append(",");

                        if ((val == null) && (col.DataType == typeof(byte[])))
                            valuesSQL.Append("NULL,");
                        else
                        {
                            valuesSQL.Append(this.BuildParameterName(col.ColumnName));
                            valuesSQL.Append(',');
                            paras.Add(new Parameter(col.ColumnName, val));
                        }
                    }
                }
            }

            strSQL.AppendFormat("insert into {0}({1}) values({2})", this.GetTableName(table.Name), columnsSQL.ToString(0, columnsSQL.Length - 1), valuesSQL.ToString(0, valuesSQL.Length - 1));
            return strSQL.ToString();
        }
    }
}
