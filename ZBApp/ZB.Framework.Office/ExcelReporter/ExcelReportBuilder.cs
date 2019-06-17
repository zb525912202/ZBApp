using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace ZB.Framework.Utility
{
    public abstract partial class ExcelReportBuilder
    {
        public ExcelReportBuilder()
        {
            this.GlobalDatas = new Dictionary<string, string>();
        }

        protected Dictionary<string, string> GlobalDatas { get; set; }

        public string TemplatePath { get; set; }

        public abstract void Export(Stream output);

        public void Export(string filepath)
        {
            using (Stream s = File.Create(filepath))
            {
                this.Export(s);
            }
        }

        public byte[] Export()
        {
            using (MemoryStream ms = new MemoryStream())
            {
                this.Export(ms);
                return ms.ToArray();
            }
        }

        public string this[string key]
        {
            get
            {
                if (GlobalDatas.ContainsKey(key))
                    return GlobalDatas[key];
                else
                    return null;
            }
            set
            {
                if (GlobalDatas.ContainsKey(key))
                    GlobalDatas[key] = value;
                else
                    GlobalDatas.Add(key, value);
            }
        }
    }
}
