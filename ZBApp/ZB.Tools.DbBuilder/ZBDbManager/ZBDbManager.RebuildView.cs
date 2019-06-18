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
        /// <summary>
        /// 创建数据库
        /// </summary>
        public bool RebuildView(ZBDbScript script)
        {
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, string.Format("=====开始重建数据库{0}的视图=====", script.DbFullName));

            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3}", script.Server, script.DbFullName, script.UID, script.PWD);
            var conn = this.CreateConnection(connStr);

            try
            {
                conn.Open();

                foreach (var sqlFilePath in script.DbConfig.RebuildViewFilePathList)
                {
                    this.ExecuteCommand(script, sqlFilePath, conn);
                }

                RtfInfoHelper.AddSuccessInfo(this.RtbInfo, string.Format("=====数据库{0}的视图创建成功!=====", script.DbFullName));
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, ex.Message);
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("=====数据库{0}的视图创建失败!=====", script.DbFullName));
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
