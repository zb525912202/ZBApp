using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public class FileUpgradeScript : UpgradeScriptBase
    {
        public string ScriptFileName;

        public override void LoadValue(XmlElement ele)
        {
            this.ScriptFileName = ele.GetAttribute("ScriptFileName");
        }

        public override bool ExcuteUpgradeScript()
        {
            if (!this.CheckDbExist())
                return true;

            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3};Connect Timeout=6000", this.DbManager.SqlScript.Server, this.DbName, this.DbManager.SqlScript.UID, this.DbManager.SqlScript.PWD);
            var conn = this.DbManager.CreateConnection(connStr);
            SqlTransaction tran = null;

            try
            {
                conn.Open();
                tran = conn.BeginTransaction();
                string sqlFilePath = Path.Combine(this.DbManager.SqlScript.ScriptDirFullPath, ZBDbManager.ScriptUpgradeDir, this.ScriptFileName);
                this.DbManager.ExecuteCommand(this.DbManager.SqlScript, sqlFilePath, conn, tran);
                tran.Commit();

                RtfInfoHelper.AddSuccessInfo(this.DbManager.RtbInfo, string.Format("脚本[{0}]执行成功!", this.ScriptFileName));
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, string.Format("脚本[{0}]执行失败!", this.ScriptFileName));
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, ex.Message);
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
