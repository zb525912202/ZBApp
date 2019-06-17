using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        private Dictionary<Type, DataTable> DataTableDict = new Dictionary<Type, DataTable>();

        public virtual DataTable GetTableSchema(TableMapping tablemapping)
        {
            Type t = tablemapping.ObjectType;
            DataTable dt;
            if (this.DataTableDict.ContainsKey(t))
                dt = this.DataTableDict[t];
            else
            {
                string strSQL = string.Format("select top 1 * from {0} where 1 <> 1", this.GetTableName(tablemapping.Name));
                dt = this.ExecuteDataSet(strSQL).Tables[0];
                this.DataTableDict.Add(t, dt);
            }

            return SerializeHelper.DeepClone(dt);//因为使用中会修改这个DataTable,所以返回克隆对象
        }

        public virtual DataTable GetFillTable<TElement>(TableMapping tablemapping, IList<TElement> objlist) where TElement : ObjectMappingBase
        {
            Dictionary<string, string> ExtendColumnsConfig = null;
            if (tablemapping.IsSupportExtend)
            {
                TableExtend tableextend = TableExtendService.Instance.GetTableExtend(tablemapping.ObjectType);
                ExtendColumnsConfig = tableextend.Columns.ToDictionary(o => o.ColumnName, o => o.Name);
            }

            DataTable dataTable = GetTableSchema(tablemapping);
            object[] values = new object[dataTable.Columns.Count];
            dataTable.BeginInit();
            dataTable.BeginLoadData();
            foreach (TElement obj in objlist)
            {
                for (int i = 0; i < dataTable.Columns.Count; i++)
                {
                    var ColumnName = dataTable.Columns[i].ColumnName;
                    var col = tablemapping.GetColumnMappingByColumnName(ColumnName);
                    if (col != null)
                        values[i] = col.GetValue(obj);
                    else if (tablemapping.IsSupportExtend && ExtendColumnsConfig.ContainsKey(ColumnName))
                        values[i] = obj[ExtendColumnsConfig[ColumnName]];
                    else
                        values[i] = obj[ColumnName];
                }

                dataTable.LoadDataRow(values, false);
            }
            dataTable.EndLoadData();
            dataTable.EndInit();
            return dataTable;
        }

        public void BulkCopy<T>(IList<T> list, Dictionary<string, object> bulkCopyConfig = null) where T : ObjectMappingBase
        {
            if (list.Count == 0)
                return;

            if (bulkCopyConfig == null)
                bulkCopyConfig = new Dictionary<string, object>();

            TableMapping table = MappingService.Instance.GetTableMapping(typeof(T));

            if (table.BaseTableMapping != null)
                this.BulkCopy<T>(table.BaseTableMapping, list, bulkCopyConfig);

            this.BulkCopy<T>(table, list, bulkCopyConfig);
        }

        public virtual void BulkCopy<T>(TableMapping table, IList<T> list, Dictionary<string, object> bulkCopyConfig) where T : ObjectMappingBase
        {
            throw new ObjectMappingException("Current database not support BulkCopy!");
        }

        public virtual void PrepareBulkCopy<T>(TableMapping table, IList<T> list)
        {
            //使用种子工厂--------------------------------------------------------------------------------
            if (table.ColumnPK.IsUseSeedFactory == false)
                return;

            int SeedPoolSize = Math.Max(100, list.Count);

            foreach (var obj in list)
            {
                int tempid = (int)table.ColumnPK.GetValue(obj);
                if (tempid == 0)
                {
                    tempid = SeedService.Instance.GetSeed(table, SeedPoolSize);
                    table.ColumnPK.PropertyInfo.SetValue(obj, tempid, null);
                }
            }
        }
    }
}
