using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using ZB.Framework.Utility;
using System.Data.SqlClient;

namespace ZB.Framework.ObjectMapping
{
    public class SqlServerDatabaseEngine : DatabaseEngine
    {
        public override int Create<TElement, TElementKey>(TableMapping table, ObjectMappingBase<TElement, TElementKey> obj)
        {
            int ret = base.Create(table, obj);
            if (table.ColumnAutoIncrement != null)  
                table.ColumnAutoIncrement.SetValue(obj, GetLastInsertedIdentity());
            return ret;
        }

        public override int Create(DataEntityTableDefine t, DataEntity obj)
        {
            int ret = base.Create(t, obj);
            if (t.IsAutoIncrementPK)
                obj[t.PkColumn] = this.GetLastInsertedIdentity();
            return ret;
        }

        /// <summary>
        /// 获得最后一次插入的自动增长值
        /// </summary>
        private int GetLastInsertedIdentity()
        {
            string strSQL = "select @@IDENTITY";
            object max = this.ExecuteScalar<object>(CommandType.Text, strSQL);
            if (max == DBNull.Value)
                throw new ObjectMappingException("select @@IDENTITY Failed!");
            return Convert.ToInt32(max);
        }

        public override void BulkCopy<T>(TableMapping tablemapping, IList<T> list, Dictionary<string, object> bulkCopyConfig)
        {
            this.PrepareBulkCopy<T>(tablemapping,list);
            DataTable dataTable = this.GetFillTable<T>(tablemapping,list);

            SqlBulkCopyOptions options = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.FireTriggers;

            if (bulkCopyConfig.ContainsKey("BulkCopyOptions"))
                options = (SqlBulkCopyOptions)bulkCopyConfig["BulkCopyOptions"];

            SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(DatabaseSession.Database.ConnectionString, options);
            using (sqlBulkCopy)
            {
                SqlRowsCopiedEventHandler evtHandler = bulkCopyConfig.GetKeyValue<SqlRowsCopiedEventHandler>("SqlRowsCopied");
                if (null != evtHandler)
                {
                    sqlBulkCopy.SqlRowsCopied += evtHandler;
                }
                sqlBulkCopy.DestinationTableName = this.GetTableName(tablemapping.Name);
                sqlBulkCopy.BulkCopyTimeout = bulkCopyConfig.GetKeyValue<int>("BulkCopyTimeout", 600);
                sqlBulkCopy.NotifyAfter = bulkCopyConfig.GetKeyValue<int>("NotifyAfter", 0);
                sqlBulkCopy.BatchSize = bulkCopyConfig.GetKeyValue<int>("BatchSize", 0);

                sqlBulkCopy.WriteToServer(dataTable);

                if (null != evtHandler)
                {
                    evtHandler.Invoke(null, new SqlRowsCopiedEventArgs(list.Count));
                }
            }
        }

        /// <summary>
        /// 表是否存在于当前数据库上下文中
        /// </summary>
        public override bool IsTableExsit(string tablename)
        {
            string strSQL = string.Format("select count(*) from sysobjects where type='u' and [name]='{0}'", tablename);
            int ret = this.ExecuteScalar<int>(strSQL);
            return ret > 0;
        }

        /// <summary>
        /// 删除表
        /// </summary>
        public override void DropTable(string tablename)
        {
            string strSQL = string.Format("drop table {0}", tablename);
            this.ExecuteNonQuery(strSQL);
        }
    }
}
