using ZB.Framework.Utility;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Xml;
using System.Text.RegularExpressions;

namespace ZB.Tools.DbBuilder
{
    public partial class ZBDbManager
    {
        public RichTextBox RtbInfo { get; private set; }
        private string ScriptDir, Server, UID, PWD, Dbs, DbPath;

        public ZBSqlScript SqlScript { get; set; }

        public ZBDbManager(RichTextBox rtbInfo, string scriptDir, string server, string uid, string pwd, string dbs, string dbPath)
        {
            this.RtbInfo = rtbInfo;
            this.ScriptDir = scriptDir;

            this.Server = server;
            this.UID = uid;
            this.PWD = pwd;
            this.Dbs = dbs;
            this.DbPath = dbPath;
        }

        public SqlConnection CreateConnection(string connStr)
        {
            SqlConnection conn = new SqlConnection(connStr);
            conn.InfoMessage += (s, e) =>
            {
                RtfInfoHelper.AddSuccessInfo(this.RtbInfo, e.Message);
            };
            return conn;
        }

        /// <summary>
        /// 执行一个.sql文件
        /// </summary>        
        private void ExecuteCommand(ZBDbScript script, string sqlFileFullPath, SqlConnection conn, SqlTransaction tran = null)
        {
            if (!File.Exists(sqlFileFullPath))
                throw new Exception(string.Format("没有找到文件[{0}]!", sqlFileFullPath));

            string sqlText = File.ReadAllText(sqlFileFullPath, Encoding.Default);
            sqlText = sqlText.Trim().Trim(new char[] { '\r', '\n' });
            string[] sqls = Regex.Split(sqlText, "\r\nGO", RegexOptions.IgnoreCase);

            foreach (var sql in sqls)
            {
                string sqlTemp = sql.Trim().Trim(new char[] { '\r', '\n' });
                sqlTemp = sqlTemp.Replace("$(DatabaseName)", script.DbFullName);
                sqlTemp = sqlTemp.Replace("$(DbPath)", script.DbPath);

                foreach (var scriptTemp in this.SqlScript.DbScriptList)
                {
                    sqlTemp = sqlTemp.Replace(string.Format("$({0}DatabaseName)", scriptTemp.DbName), scriptTemp.DbFullName);
                }

                if (!string.IsNullOrEmpty(sqlTemp))
                {
                    SqlCommand cmd = new SqlCommand(sqlTemp, conn);
                    if (tran != null)
                        cmd.Transaction = tran;

                    try
                    {
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
            }
        }

        /// <summary>
        /// 执行一个.sql文件
        /// </summary>        
        public void ExecuteCommand(ZBSqlScript script, string sqlFileFullPath, SqlConnection conn, SqlTransaction tran = null)
        {
            if (!File.Exists(sqlFileFullPath))
                throw new Exception(string.Format("没有找到文件[{0}]!", sqlFileFullPath));

            string sqlText = File.ReadAllText(sqlFileFullPath, Encoding.Default);
            sqlText = sqlText.Trim().Trim(new char[] { '\r', '\n' });
            string[] sqls = Regex.Split(sqlText, "\r\nGO", RegexOptions.IgnoreCase);

            foreach (var sql in sqls)
            {
                string sqlTemp = sql.Trim().Trim(new char[] { '\r', '\n' });

                foreach (var scriptTemp in script.DbScriptList)
                {
                    sqlTemp = sqlTemp.Replace(string.Format("$({0}DatabaseName)", scriptTemp.DbName), scriptTemp.DbFullName);
                }

                if (!string.IsNullOrEmpty(sqlTemp))
                {
                    SqlCommand cmd = new SqlCommand(sqlTemp, conn);
                    cmd.CommandTimeout = 10 * 60;//10分钟超时时间
                    if (tran != null)
                        cmd.Transaction = tran;

                    try
                    {
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }
                }
            }
        }

        //判断是否存在该数据库
        public bool ExistsDb(string dbName)
        {
            string connStr = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}", this.Server, this.UID, this.PWD);
            SqlConnection conn = this.CreateConnection(connStr);
            string sql = string.Format(@"SELECT dbCount=COUNT(*) FROM master.dbo.sysdatabases WHERE name = '{0}'", dbName);

            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    if (((int)dr["dbCount"]) > 0)
                        return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
