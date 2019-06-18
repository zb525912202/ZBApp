using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public class ReBuildUpgradeScript : UpgradeScriptBase
    {
        public string RebuildDbGroupDescription { get; set; }

        public override void LoadValue(XmlElement ele)
        {
            this.RebuildDbGroupDescription = ele.GetAttribute("RebuildDbGroupDescription");
        }

        public override bool ExcuteUpgradeScript()
        {
            //根据参数得到需要创建的数据库的名称
            string dbName = string.Format("{0}{1}", Enum.GetName(typeof(ZBDbEnum), this.ZBDb), this.DbManager.SqlScript.Dbs);
            //判断该数据库是否存在
            bool IsExist = this.CheckDbExist(dbName);
            //如果不存在该数据库，即创建
            if (!IsExist)
            {
                var ZBDbScript = this.DbManager.SqlScript.DbScriptList.FirstOrDefault(r => r.DbName == Enum.GetName(typeof(ZBDbEnum), this.ZBDb));

                RebuildDbGroup rebuildDbGroup = null;
                if (string.IsNullOrEmpty(this.RebuildDbGroupDescription))
                    rebuildDbGroup = ZBDbScript.DbConfig.RebuildDbGroupList.FirstOrDefault();
                else
                    rebuildDbGroup = ZBDbScript.DbConfig.RebuildDbGroupList.FirstOrDefault(r => r.Description == this.RebuildDbGroupDescription);

                return this.DbManager.RebuildDb(ZBDbScript, rebuildDbGroup);
            }
            return true;
        }
    }
}
