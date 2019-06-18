using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;

namespace ZB.Tools.DbBuilder
{
    public partial class ZBDbManager
    {
        /// <summary>
        /// 收缩数据库
        /// </summary>        
        public void Shrink(string dbName)
        {
            string masterConnStr = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}", this.Server, this.UID, this.PWD);
            SqlConnection conn = this.CreateConnection(masterConnStr);
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "开始收缩数据库");
            string sql = string.Format(@"IF exists(select * from master.dbo.sysdatabases where name = '{0}')
                                        Begin
                                        USE [{0}]
                                        PRINT '------设置简单恢复模式------'
                                        ALTER DATABASE [{0}] SET RECOVERY SIMPLE

                                        PRINT '------开始收缩数据库------'
                                        DBCC SHRINKFILE ([{0}])
                                        PRINT '------收缩数据库完成------'

                                        PRINT '------恢复为完全模式------'
                                        ALTER DATABASE [{0}] SET RECOVERY FULL
                                        End", dbName);

            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.ExecuteNonQuery();
                RtfInfoHelper.AddSuccessInfo(this.RtbInfo, string.Format("数据库[{0}]收缩成功!", dbName));
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                return;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}