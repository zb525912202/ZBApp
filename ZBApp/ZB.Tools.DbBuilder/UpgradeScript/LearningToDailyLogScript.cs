using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using System.Data;
using System.Transactions;

namespace ZB.Tools.DbBuilder
{
    public class LearningToDailyLogScript : UpgradeScriptBase
    {
        #region 全局属性字段
        private const string SQLSTRING =
@"IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[{0}].[dbo].[{1}]') AND type in (N'U'))
BEGIN
	SELECT 
	{2}
	FROM [{0}].[dbo].[{1}]
END";
        #endregion

        public override bool ExcuteUpgradeScript()
        {
            string dbNameLearning = string.Format("{0}{1}", Enum.GetName(typeof(ZBDbEnum), ZBDbEnum.ZBLearning), this.DbManager.SqlScript.Dbs);
            string dbNameDailyLog = string.Format("{0}{1}", Enum.GetName(typeof(ZBDbEnum), ZBDbEnum.ZBDailyLog), this.DbManager.SqlScript.Dbs);

            if (!this.CheckDbExist(dbNameLearning))
            {
                RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("数据库{0}不存在,升级步骤[LearningToDailyLogScript]已跳过!", dbNameLearning));
                return true;
            }

            //Learning数据库存在时一定存在DailyLog数据库
            if (!this.CheckDbExist(dbNameDailyLog))
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, string.Format("数据库{0}不存在,升级步骤[LearningToDailyLogScript]已停止,请先创建数据库 {0}", dbNameDailyLog));
                return false;
            }

            string connLearningString = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3}"
                                                        , this.DbManager.SqlScript.Server
                                                        , dbNameLearning
                                                        , this.DbManager.SqlScript.UID
                                                        , this.DbManager.SqlScript.PWD);

            string connDailyLogString = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3}"
                                                        , this.DbManager.SqlScript.Server
                                                        , dbNameDailyLog
                                                        , this.DbManager.SqlScript.UID
                                                        , this.DbManager.SqlScript.PWD);


            SqlConnection connLearning = this.DbManager.CreateConnection(connLearningString);
            SqlConnection connDailyLog = this.DbManager.CreateConnection(connDailyLogString);

            SqlTransaction dailyLogTransaction = null;

            try
            {
                SqlCommand command = new SqlCommand("SELECT TOP 1 Id FROM DeptStat", connDailyLog);
                connDailyLog.Open();
                object result = command.ExecuteScalar();
                if (result != null)
                {
                    RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("数据库{0}已迁移过数据，升级步骤[LearningToDailyLogScript]已跳过!", dbNameDailyLog));
                    return true;
                }

                dailyLogTransaction = connDailyLog.BeginTransaction();

                RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, "======================开始迁移日结数据======================");

                ProcessData(connLearning, connDailyLog, dailyLogTransaction, "DeptStat", "StatId");

                ProcessData(connLearning, connDailyLog, dailyLogTransaction, "EmployeeGroupStat", "StatId");

                ProcessData(connLearning, connDailyLog, dailyLogTransaction, "EmployeeInEmployeeGroupStat", "StatId");

                ProcessData(connLearning, connDailyLog, dailyLogTransaction, "EmployeeStudyDetailStat", "Id");

                ProcessData(connLearning, connDailyLog, dailyLogTransaction, "EmployeeStudyDetailStatLog", "Id");

                dailyLogTransaction.Commit();

                RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, "======================完成迁移日结数据======================");
                RtfInfoHelper.AddSuccessInfo(this.DbManager.RtbInfo, "升级步骤[LearningToDailyLogScript]执行成功!");

                return true;
            }
            catch (Exception ex)
            {
                dailyLogTransaction.Rollback();

                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, string.Format("升级步骤[LearningToDailyLogScript]执行失败:{0}!", ex.ToString()));
                return false;
            }
            finally
            {
                connLearning.Close();
                connDailyLog.Close();
            }
        }

        private void ProcessData(SqlConnection learningConnection, SqlConnection dailyLogConnection, SqlTransaction dailyLogTrans, string tableName, string orderByColumn)
        {
            RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("开始迁移{0}数据", tableName));

            SqlCommand learningCommand = new SqlCommand();
            learningCommand.Connection = learningConnection;
            if (learningConnection.State != ConnectionState.Open)
            {
                learningConnection.Open();
            }

            learningCommand.CommandText = string.Format("SELECT name FROM sys.tables WHERE object_id = OBJECT_ID('{0}')", tableName);
            object count = learningCommand.ExecuteScalar();
            if (count == null)
            {
                RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("Learning数据库不存在{0}表，请人工验证......", tableName));
                return;
            }

            DataTable table = new DataTable();
            learningCommand.CommandText = string.Format("SELECT Top 1 * FROM {0}", tableName);

            using (IDataReader columnReader = learningCommand.ExecuteReader())
            {
                for (int i = 0; i < columnReader.FieldCount; i++)
                {
                    DataColumn column = new DataColumn();
                    column.DataType = columnReader.GetFieldType(i);
                    column.ColumnName = columnReader.GetName(i);
                    table.Columns.Add(column);
                }
            }

            RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("正在获取{0}需迁移的数据........", tableName));

            int pageIndex = 1, pageSize = 50000;
            while (true)
            {
                table.Clear();

                learningCommand.CommandText = string.Format(@"SELECT * FROM(
                                                SELECT *,ROW_NUMBER() OVER(ORDER BY {3}) AS RowNumber FROM {0}
                                                ) AS A WHERE RowNumber BETWEEN {1} AND {2}", tableName, (pageIndex - 1) * pageSize + 1, pageIndex * pageSize, orderByColumn);


                using (IDataReader reader = learningCommand.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        DataRow newRow = table.NewRow();

                        foreach (DataColumn column in table.Columns)
                        {
                            newRow[column.ColumnName] = reader[column.ColumnName];
                        }

                        table.Rows.Add(newRow);
                    }
                }

                pageIndex += 1;

                if (table.Rows.Count == 0)
                {
                    break;
                }

                DataToData(table, dailyLogConnection, dailyLogTrans, tableName);
            }

            DropTable(learningConnection, tableName);

            RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("迁移{0}数据完成", tableName));
        }

        private void DataToData(DataTable table, SqlConnection dailyLogConnection, SqlTransaction dailyLogTrans, string tableName)
        {
            if (table != null && table.Rows.Count > 0)
            {
                SqlBulkCopyOptions options = SqlBulkCopyOptions.CheckConstraints;

                SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(dailyLogConnection, options, dailyLogTrans);

                sqlBulkCopy.DestinationTableName = tableName;
                sqlBulkCopy.BulkCopyTimeout = 600;
                sqlBulkCopy.NotifyAfter = 0;
                sqlBulkCopy.BatchSize = 100000;

                sqlBulkCopy.WriteToServer(table);
            }
        }

        private void DropTable(SqlConnection connection, string tableName)
        {
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }

            string dropSqlString = string.Format("DROP TABLE {0}", tableName);
            SqlCommand command = new SqlCommand(dropSqlString, connection);
            command.ExecuteNonQuery();
        }
    }
}
