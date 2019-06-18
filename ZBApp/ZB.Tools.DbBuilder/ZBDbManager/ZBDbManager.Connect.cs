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
        private List<ZBDbScript> LoadDbScriptList(HashSet<string> dbNameHs)
        {
            List<ZBDbScript> ZBDbConfigList = new List<ZBDbScript>();

            DirectoryInfo dir = new DirectoryInfo(this.ScriptDir);
            DirectoryInfo[] subDirs = dir.GetDirectories();
            foreach (var subDir in subDirs)
            {
                string[] strs = subDir.Name.Split('.');
                int index = 0;
                if (strs.Length == 2 && int.TryParse(strs[0], out index))
                {
                    ZBDbScript script = new ZBDbScript()
                    {
                        ScriptDirFullPath = subDir.FullName,
                        Server = this.Server,
                        UID = this.UID,
                        PWD = this.PWD,
                        Dbs = this.Dbs,
                        DbPath = this.DbPath,
                        DbName = strs[1],
                    };
                    string masterConnStr = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}", this.Server, this.UID, this.PWD);
                    SqlConnection conn = this.CreateConnection(masterConnStr);
                    string sql = string.Format("SELECT d.name,f.filename,DbSize=ISNULL([size]*8,0) from master..sysaltfiles f,master..sysdatabases d where f.dbid=d.dbid and d.name='{0}'", script.DbFullName);
                    SqlCommand cmd = new SqlCommand(sql, conn);

                    try
                    {
                        cmd.Connection.Open();
                        SqlDataReader dr = cmd.ExecuteReader();
                        while (dr.Read())
                        {
                            string name = (string)dr["name"];
                            int dbSize = (int)dr["DbSize"];
                            if (name == script.DbFullName)
                            {
                                string fileName = (string)dr["filename"];
                                if (fileName.ToLower().EndsWith(".mdf"))
                                    script.DbSize_mdf = dbSize;
                                else if (fileName.ToLower().EndsWith(".ldf"))
                                    script.DbSize_ldf = dbSize;
                            }
                            else
                                throw new Exception(string.Format("未知的数据库文件[{0}]", name));
                        }
                    }
                    catch (Exception ex)
                    {
                        RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                    }
                    finally
                    {
                        cmd.Connection.Close();
                    }
                    script.LoadDbConfig();

                    ZBDbConfigList.Add(script);
                }
            }
            return ZBDbConfigList;
        }

        /// <summary>
        /// 获取数据库的集合
        /// </summary>
        public bool ConnectDb()
        {
            HashSet<string> dbNameHs = new HashSet<string>();
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "开始连接数据库");

            string masterConnStr = string.Format("Data Source={0};Initial Catalog=master;UID={1};PWD={2}", this.Server, this.UID, this.PWD);
            SqlConnection conn = this.CreateConnection(masterConnStr);


            string sql = "SELECT Name FROM master.dbo.sysdatabases";
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                cmd.Connection.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    dbNameHs.Add(dr["Name"].ToString());
                }
                RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "数据库连接成功!");
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                return false;
            }
            finally
            {
                cmd.Connection.Close();
            }

            try
            {
                var sqlScript = new ZBSqlScript()
                {
                    ScriptDirFullPath = this.ScriptDir,
                    Server = this.Server,
                    UID = this.UID,
                    PWD = this.PWD,
                    Dbs = this.Dbs,
                };
                sqlScript.DbScriptList = this.LoadDbScriptList(dbNameHs);
                this.SqlScript = sqlScript;

                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                return false;
            }
        }
    }
}
