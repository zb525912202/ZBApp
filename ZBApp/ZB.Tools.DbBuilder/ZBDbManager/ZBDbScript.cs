using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public class ZBSqlScript
    {
        public string Server { get; set; }
        public string UID { get; set; }
        public string PWD { get; set; }
        public string Dbs { get; set; }
        public string ScriptDirFullPath { get; set; }

        private List<ZBDbScript> _DbScriptList = new List<ZBDbScript>();
        public List<ZBDbScript> DbScriptList
        {
            get { return _DbScriptList; }
            set { _DbScriptList = value; }
        }
    }

    public class ZBDbScript
    {
        public const string DbConfigXmlFileName = "0.DbConfig.Xml";

        public string ScriptDirFullPath { get; set; }
        public string DbName { get; set; }

        public string Server { get; set; }
        public string UID { get; set; }
        public string PWD { get; set; }
        public string Dbs { get; set; }
        public string DbPath { get; set; }

        /// <summary>
        /// 数据库大小(K)
        /// </summary>
        public int DbSize_mdf { get; set; }
        public int DbSize_ldf { get; set; }


        public string DbSizeStr_mdf
        {
            get
            {
                if (DbSize_mdf == 0)
                    return "不存在";

                int k = 1;
                int m = 1024 * k;
                int g = 1024 * m;

                if (this.DbSize_mdf > g)
                    return string.Format("{0}G", ((decimal)DbSize_mdf / g).ToString("0.#"));
                else if (this.DbSize_mdf > m)
                    return string.Format("{0}M", ((decimal)DbSize_mdf / m).ToString("0.#"));
                else
                    return string.Format("{0}K", ((decimal)DbSize_mdf / k).ToString("0.#"));
            }
        }

        public string DbSizeStr_ldf
        {
            get
            {
                if (DbSize_ldf == 0)
                    return "不存在";

                int k = 1;
                int m = 1024 * k;
                int g = 1024 * m;

                if (this.DbSize_ldf > g)
                    return string.Format("{0}G", ((decimal)DbSize_ldf / g).ToString("0.#"));
                else if (this.DbSize_ldf > m)
                    return string.Format("{0}M", ((decimal)DbSize_ldf / m).ToString("0.#"));
                else
                    return string.Format("{0}K", ((decimal)DbSize_ldf / k).ToString("0.#"));
            }
        }

        public string DbFullName
        {
            get { return string.Format("{0}{1}", this.DbName, this.Dbs); }
        }

        /// <summary>
        /// 是否已经创建了数据库
        /// </summary>
        public bool IsExistDb { get; set; }

        public ZBDbConfig DbConfig { get; set; }

        public override string ToString()
        {
            return string.Format("DbFullName:{0}", this.DbFullName);
        }

        /// <summary>
        /// 加载DbConfig.Xml
        /// </summary>
        public void LoadDbConfig()
        {
            string dbConfigXmlFullPath = Path.Combine(this.ScriptDirFullPath, ZBDbScript.DbConfigXmlFileName);
            XmlDocument doc = new XmlDocument();
            doc.Load(dbConfigXmlFullPath);
            XmlElement connEle = doc["SQL"];

            this.DbConfig = new ZBDbConfig();
            foreach (var item1 in connEle)
            {
                XmlElement rebuildEle = item1 as XmlElement;

                if (rebuildEle.Name == "ReBuildDB")
                {
                    RebuildDbGroup dbgroup = new RebuildDbGroup();
                    if (rebuildEle.HasAttribute("description"))
                        dbgroup.Description = "创建数据库" + "(" + rebuildEle.Attributes["description"].Value + ")";
                    else
                        dbgroup.Description = "创建数据库";
                    foreach (var item2 in rebuildEle)
                    {
                        XmlElement tranEle = item2 as XmlElement;

                        if (tranEle.Name == "Transaction")
                        {
                            foreach (XmlElement ele in tranEle)
                            {
                                string fileName = ele.Attributes["FileName"].Value;
                                string fileFullPath = Path.Combine(this.ScriptDirFullPath, fileName);
                                dbgroup.RebuildDbFilePathList.Add(fileFullPath);
                            }
                        }
                        else if (tranEle.Name == "NoTransaction")
                        {
                            foreach (XmlElement ele in tranEle)
                            {
                                string fileName = ele.Attributes["FileName"].Value;
                                string fileFullPath = Path.Combine(this.ScriptDirFullPath, fileName);
                                dbgroup.RebuildDbFilePathList_NoTran.Add(fileFullPath);
                            }
                        }
                    } this.DbConfig.RebuildDbGroupList.Add(dbgroup);
                }
                else if (rebuildEle.Name == "ReBuildView")
                {
                    foreach (XmlElement ele in rebuildEle)
                    {
                        string fileName = ele.Attributes["FileName"].Value;
                        string fileFullPath = Path.Combine(this.ScriptDirFullPath, fileName);
                        this.DbConfig.RebuildViewFilePathList.Add(fileFullPath);
                    }
                }
            }
        }
    }


    public class RebuildDbGroup
    {
        public string Description { get; set; }

        private List<string> _RebuildDbFilePathList = new List<string>();
        public List<string> RebuildDbFilePathList
        {
            get { return _RebuildDbFilePathList; }
            set { _RebuildDbFilePathList = value; }
        }

        private List<string> _RebuildDbFilePathList_NoTran = new List<string>();
        public List<string> RebuildDbFilePathList_NoTran
        {
            get { return _RebuildDbFilePathList_NoTran; }
            set { _RebuildDbFilePathList_NoTran = value; }
        }
    }

    public class ZBDbConfig
    {
        private List<RebuildDbGroup> _RebuildDbGroupList = new List<RebuildDbGroup>();
        public List<RebuildDbGroup> RebuildDbGroupList
        {
            get { return _RebuildDbGroupList; }
            set { _RebuildDbGroupList = value; }
        }

        private List<string> _RebuildViewFilePathList = new List<string>();
        public List<string> RebuildViewFilePathList
        {
            get { return _RebuildViewFilePathList; }
            set { _RebuildViewFilePathList = value; }
        }
    }
}
