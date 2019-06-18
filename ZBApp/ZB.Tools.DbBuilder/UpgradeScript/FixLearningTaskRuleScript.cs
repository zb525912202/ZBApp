using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public class FixLearningTaskRuleScript : UpgradeScriptBase
    {
        public override bool ExcuteUpgradeScript()
        {
            if (!this.CheckDbExist())
                return true;

            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3};Connect Timeout=600", this.DbManager.SqlScript.Server, this.DbName, this.DbManager.SqlScript.UID, this.DbManager.SqlScript.PWD);
            var conn = this.DbManager.CreateConnection(connStr);
            SqlTransaction tran = null;

            try
            {
                conn.Open();
                tran = conn.BeginTransaction();
                SqlCommand cmd = new SqlCommand("SELECT TaskRule FROM LearningTask WHERE TaskRule IS NOT NULL", conn, tran);
                var dr = cmd.ExecuteReader();
                List<byte[]> ruleDataList = new List<byte[]>();
                while (dr.Read())
                {
                    var data = dr["TaskRule"];
                    if (data != DBNull.Value)
                        ruleDataList.Add((byte[])data);
                }

                tran.Commit();

                RtfInfoHelper.AddSuccessInfo(this.DbManager.RtbInfo, "脚本[FixLearningTaskRuleScript]执行成功!");
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[FixLearningTaskRuleScript]执行失败!");
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
