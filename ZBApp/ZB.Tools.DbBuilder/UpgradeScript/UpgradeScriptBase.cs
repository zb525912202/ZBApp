using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public abstract class UpgradeScriptBase
    {
        public string DbName { get; set; }
        public XmlElement XmlElementObj { get; set; }
        public ZBDbManager DbManager { get; set; }
        public ZBDbEnum ZBDb { get; set; }

        /// <summary>
        /// 读取XML节点信息
        /// </summary>        
        public virtual void LoadValue(XmlElement ele)
        {

        }

        public abstract bool ExcuteUpgradeScript();

        protected bool CheckDbExist()
        {
            if (!this.CheckDbExist(this.DbName))
            {
                RtfInfoHelper.AddWarning(this.DbManager.RtbInfo, string.Format("数据库{0}不存在,脚本[{1}]已跳过!", this.DbName, this.XmlElementObj.OuterXml));
                return false;
            }
            else
            {
                return true;
            }
        }

        protected bool CheckDbExist(string dbName)
        {
            return this.DbManager.ExistsDb(dbName);
        }
    }
}
