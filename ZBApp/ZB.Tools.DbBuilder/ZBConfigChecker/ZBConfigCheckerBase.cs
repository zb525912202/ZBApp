using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace ZB.Tools.DbBuilder
{
    public abstract class ZBConfigCheckerBase
    {
        public RichTextBox RtbInfo { get; private set; }

        public ZBConfigCheckerBase(RichTextBox rtbInfo)
        {
            this.RtbInfo = rtbInfo;
        }

        public abstract void Check();

        public string CheckFileExists(string filePath)
        {
            DirectoryInfo dir = new DirectoryInfo(System.AppDomain.CurrentDomain.BaseDirectory);
            string configFile = Path.Combine(dir.Parent.Parent.FullName, filePath);

            if (!File.Exists(configFile))
            {
                RtfInfoHelper.AddErrorInfo(this.RtbInfo, string.Format("没有在找到配置文件【{0}】！", configFile));
                return null;
            }

            return configFile;
        }
    }

    public class SqlScriptConfigChecker : ZBConfigCheckerBase
    {
        public SqlScriptConfigChecker(RichTextBox rtbInfo)
            : base(rtbInfo)
        {
        }

        public override void Check()
        {
            RtfInfoHelper.AddSuccessInfo(this.RtbInfo, "开始检查【ScriptConfig.xml】");

            string configFile = this.CheckFileExists("SqlScripts\\ScriptConfig.xml");
            if (!string.IsNullOrEmpty(configFile))
            {

            }
        }
    }
}
