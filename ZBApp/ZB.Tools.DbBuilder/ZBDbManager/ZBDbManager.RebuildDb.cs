using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;

namespace ZB.Tools.DbBuilder
{
    public partial class ZBDbManager
    {
        public const string ClearAllFileName = "x.ClearAll.sql";

        private bool CreateDb(ZBDbScript script)
        {
            string connStr = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}", script.Server, script.UID, script.PWD);
            string clearAllFilePath = Path.Combine(this.ScriptDir, ZBDbManager.ClearAllFileName);

            var conn = this.CreateConnection(connStr);
            try
            {
                conn.Open();
                this.ExecuteCommand(script, clearAllFilePath, conn);
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("=====数据库{0}创建失败!=====", script.DbFullName));
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        private bool ExcuteSqlInTran(ZBDbScript script, RebuildDbGroup rebuildDbGroup)
        {
            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3}", script.Server, script.DbFullName, script.UID, script.PWD);

            var conn = this.CreateConnection(connStr);
            SqlTransaction tran = null;
            try
            {
                conn.Open();
                tran = conn.BeginTransaction();

                foreach (var sqlFilePath in rebuildDbGroup.RebuildDbFilePathList)
                {
                    this.ExecuteCommand(script, sqlFilePath, conn, tran);
                }

                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("=====数据库{0}创建失败!=====", script.DbFullName));

                if (tran != null)
                    tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        private bool ExcuteSqlNoTran(ZBDbScript script, RebuildDbGroup rebuildDbGroup)
        {
            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3}", script.Server, script.DbFullName, script.UID, script.PWD);

            var conn = this.CreateConnection(connStr);
            try
            {
                conn.Open();

                foreach (var sqlFilePath in rebuildDbGroup.RebuildDbFilePathList_NoTran)
                {
                    this.ExecuteCommand(script, sqlFilePath, conn);
                }
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("=====数据库{0}创建失败!=====", script.DbFullName));
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        /// <summary>
        /// 创建数据库
        /// </summary>
        public bool RebuildDb(ZBDbScript script, RebuildDbGroup rebuildDbGroup)
        {
#if !DEBUG
            //int dbCount = 0;
            //try
            //{
            //    conn.Open();
            //    string sql = string.Format("SELECT COUNT(*) FROM SysDatabases WHERE name = '{0}'", script.DbFullName);
            //    SqlCommand cmd = new SqlCommand(sql, conn);

            //    dbCount = (int)cmd.ExecuteScalar();
            //}
            //catch (Exception ex)
            //{
            //    RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
            //    return;
            //}
            //finally
            //{
            //    conn.Close();
            //}

            //if (dbCount > 0)
            //{
            //    RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("=====数据库{0}已经存在!=====", script.DbFullName));
            //    return;
            //}
#endif
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, string.Format("=====开始创建数据库{0}=====", script.DbFullName));

            if (this.CreateDb(script))
            {
                if (this.ExcuteSqlInTran(script, rebuildDbGroup))
                {
                    if (this.ExcuteSqlNoTran(script, rebuildDbGroup))
                    {
                        RtfInfoHelper.AddSuccessInfo(this.RtbInfo, string.Format("=====数据库{0}创建成功!=====", script.DbFullName));
                        return true;
                    }
                }
            }
            return false;
        }
    }
}
