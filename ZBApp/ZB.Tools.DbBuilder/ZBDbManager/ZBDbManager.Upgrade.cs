using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public partial class ZBDbManager
    {
        public const string ScriptUpgradeDir = "ScriptUpgrade";
        public const string UpgradeConfigFileName = "0.UpgradeConfig.xml";

        /// <summary>
        /// 升级数据库
        /// </summary>        
        public void Upgrade()
        {
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "=====开始升级数据库!=====");

            string upgradeConfigXmlFullPath = Path.Combine(this.ScriptDir, ZBDbManager.ScriptUpgradeDir, ZBDbManager.UpgradeConfigFileName);
            XmlDocument doc = new XmlDocument();
            doc.Load(upgradeConfigXmlFullPath);

            XmlElement configEle = doc["UpgradeConfig"];

            List<UpgradeScriptBase> scriptList = new List<UpgradeScriptBase>();
            foreach (var child in configEle.ChildNodes)
            {
                XmlElement ele = child as XmlElement;
                string upgradeConfigClassName = string.Format("ZB.Tools.DbBuilder.{0}", ele.Name);

                Type t = Type.GetType(upgradeConfigClassName);
                UpgradeScriptBase script = (UpgradeScriptBase)Activator.CreateInstance(t);
                script.DbManager = this;
                script.ZBDb = (ZBDbEnum)Enum.Parse(typeof(ZBDbEnum), ele.GetAttribute("ZBDb"));
                script.LoadValue(ele);
                script.XmlElementObj = ele;

                if (script.ZBDb == ZBDbEnum.Master)
                    script.DbName = Enum.GetName(typeof(ZBDbEnum), script.ZBDb);
                else
                    script.DbName = string.Format("{0}{1}", Enum.GetName(typeof(ZBDbEnum), script.ZBDb), script.DbManager.SqlScript.Dbs);

                scriptList.Add(script);
            }

            foreach (var script in scriptList)
            {
                if (!script.ExcuteUpgradeScript())
                {
                    RtfInfoHelper.AddErrorInfo(this.RtbInfo, "=====数据库升级失败!=====");
                    return;
                }
            }

            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "-*-*-*-*-*-开始重新生成所有数据库的视图-*-*-*-*-*-");
            foreach (var dbScript in this.SqlScript.DbScriptList)
            {
                if (this.ExistsDb(dbScript.DbFullName))
                {
                    if (!this.RebuildView(dbScript))
                    {
                        RtfInfoHelper.AddErrorInfo(this.RtbInfo, "=====数据库升级失败!=====");
                        return;
                    }
                }
            }
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "-*-*-*-*-*-重新生成所有数据库的视图成功-*-*-*-*-*-");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "");


            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "=====数据库升级成功!=====");
        }
    }
}
