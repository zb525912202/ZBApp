using System;
using System.Net;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Collections.Generic;
using System.Linq;
using System.Xml;
using System.Reflection;
using System.IO;

namespace ZB.AppShell.Addin
{
    public class AddinFile
    {
        public AddinFile()
        {

        }

        public AddinFile(string path)
        {
            this.Path = path;
        }

        public string Path { get; set; }
    }

    public partial class AddinService
    {
        public static readonly AddinService Instance = new AddinService();

        public Dictionary<string, string> AddinXmlDic { get; set; }

        private AddinService()
        {
            this.AddinXmlDic = new Dictionary<string, string>();
            this.CodonFactory = new CodonFactory();
            this.AddinTreeNodeList = new Dictionary<string, AddinTreeNode>();
            this.AddinTreeFiles = new List<AddinFile>();
            this.Definitions = new Dictionary<string, int>();
            this.IsIgnoreUnknownCodon = false;
        }

        public void AddAddinFile(AddinFile file)
        {
            this.AddinTreeFiles.Add(file);
        }

        public void AddAddinFile(string file)
        {
            this.AddAddinFile(new AddinFile(file));
        }

#if !SILVERLIGHT
        public void AddAddinDirectory(string directory)
        {
            if (!Directory.Exists(directory))
                return;

            var files = Directory.GetFiles(directory, "*.xml");
            foreach (var file in files)
            {
                this.AddAddinFile(file);
            }

            files = Directory.GetFiles(directory, "*.sxml");
            foreach (var file in files)
            {
                this.AddAddinFile(file);
            }
        }
#endif

        public List<AddinFile> AddinTreeFiles { get; private set; }

        public Dictionary<string, int> Definitions { get; private set; }

        /// <summary>
        /// 插件加载完毕
        /// </summary>
        public event Action LoadedComplete_Addin;

        /// <summary>
        /// 系统加载错误
        /// </summary>
        public bool IsLoadingError { get; set; }

        public CodonFactory CodonFactory { get; private set; }

        public Dictionary<string, AddinTreeNode> AddinTreeNodeList { get; private set; }

        public bool IsIgnoreUnknownCodon { get; set; }

        #region ProcessExtensionNode
        private void ProcessExtensionNode(XDocument AddinTreeDoc)
        {
            List<XElement> ExtensionNodes = AddinTreeDoc.XPathSelectElements("/Jet.AppShell.AddinTree/Extension").ToList();
            foreach (XElement ExtensionNode in ExtensionNodes)
            {
                string path = ExtensionNode.Attribute("path").Value;

                var addin_mergemode = ExtensionNode.Attribute("addin-mergemode");
                if (addin_mergemode != null && addin_mergemode.Value.ToLower() == "removechildren")
                {
                    AddinTreeNode addinnode = GetAddinTreeNode(path);
                    addinnode.ClearChildNodes();
                }

                foreach (XElement CodonNode in ExtensionNode.Elements())
                {
                    if (CodonNode.NodeType == XmlNodeType.Comment)
                        continue;
                    ProcessCodonNode(path, CodonNode);
                }
            }
        }
        #endregion

        #region ProcessCodonNode
        private void ProcessCodonNode(string AddInPath, XElement CodonNode)
        {
            if (CodonNode.Attribute("id") != null)
                AddinEventService.Instance.AddinLoading(string.Format("正在加载模块 \"{0}\"......", AddInPath + "/" + CodonNode.Attribute("id").Value));

            Type codonType = this.CodonFactory.GetCodonType(CodonNode.Name.LocalName);
            if (codonType == null)
            {
                if (IsIgnoreUnknownCodon)
                {
                    AddinEventService.Instance.AddinLoading(string.Format("忽略未知Codon \"{0}\"", CodonNode.Name.LocalName));
                    return;
                }

                throw new AddinException("加载 Codon 实例异常,没有找到 Codon 定义" + CodonNode.Name.LocalName);
            }
            AbstractCodon codonInstance = this.CodonFactory.CreateCodon(CodonNode.Name.LocalName);

            PropertyInfo[] props = codonType.GetProperties();
            foreach (PropertyInfo prop in props)
            {
                XmlMemberAttributeAttribute atr1 = Attribute.GetCustomAttribute(prop, typeof(XmlMemberAttributeAttribute)) as XmlMemberAttributeAttribute;
                if (atr1 != null)
                {
                    XAttribute xmlatr = CodonNode.Attribute(atr1.Name);
                    if (xmlatr == null)
                    {
                        if (atr1.IsRequired)
                            throw new AddinException(string.Format("没有找到 Codon:{0} 的 Attribute:{1}", CodonNode.Name.LocalName, atr1.Name));
                    }
                    else
                    {
                        object val = Convert.ChangeType(xmlatr.Value, prop.PropertyType, null);
                        prop.SetValue(codonInstance, val, null);
                    }
                    continue;
                }

                XmlMemberArrayAttribute atr2 = Attribute.GetCustomAttribute(prop, typeof(XmlMemberArrayAttribute)) as XmlMemberArrayAttribute;
                if (atr2 != null)
                {
                    XAttribute xmlatr = CodonNode.Attribute(atr2.Name);
                    if (xmlatr == null)
                    {
                        if (atr2.IsRequired)
                            throw new AddinException(string.Format("没有找到 Codon:{0} 的 Attribute:{1}", CodonNode.Name.LocalName, atr2.Name));
                    }
                    else
                        prop.SetValue(codonInstance, xmlatr.Value.Split(atr2.Separator), null);
                    continue;
                }

                XmlMemberCDATAAttribute atr3 = Attribute.GetCustomAttribute(prop, typeof(XmlMemberCDATAAttribute)) as XmlMemberCDATAAttribute;
                if (atr3 != null)
                {
                    if (string.IsNullOrEmpty(CodonNode.Value))
                    {
                        if (atr3.IsRequired)
                            throw new AddinException(string.Format("没有找到 Codon:{0} 的 CDATA 数据", CodonNode.Name.LocalName));
                    }
                    else
                        prop.SetValue(codonInstance, CodonNode.Value, null);
                    continue;
                }
            }

            if (string.IsNullOrWhiteSpace(codonInstance.ID))
            {
                codonInstance.ID = "TEMP_" + Guid.NewGuid();
                codonInstance.IsRandomID = true;
            }

            AddinTreeNode newnode = GetAddinTreeNode(AddInPath + "/" + codonInstance.ID, false);
            newnode.Codon = codonInstance;
            //---------------------------------------------------------------------------------------------------------
            var addin_mergemode = CodonNode.Attribute("addin-mergemode");
            if (addin_mergemode != null && addin_mergemode.Value.ToLower() == "removechildren")
                newnode.ClearChildNodes();
            //---------------------------------------------------------------------------------------------------------
            foreach (XElement subCodonNode in CodonNode.Elements())
            {
                if (subCodonNode.NodeType == XmlNodeType.Comment)
                    continue;

                string path = AddInPath + "/" + codonInstance.ID;
                this.ProcessCodonNode(path, subCodonNode);
            }
        }
        #endregion

        #region GetAddinTreeNode
        /// <summary>
        /// 仅供外部调用
        /// </summary>
        public AddinTreeNode GetAddinTreeNode(string path)
        {
            AddinTreeNode treenode = this.GetAddinTreeNode(path, true);
            if (treenode == null)
                throw new AddinException(string.Format("没有找到路径为\"{0}\"的插件节点", path));
            return treenode;
        }

        public AddinTreeNode GetAddinTreeNode(string path, bool isOnlyFind)
        {
            string[] templist = path.Split('/');
            Stack<string> PathNodeStack = new Stack<string>();
            for (int i = templist.Length - 1; i >= 0; i--)
            {
                string str = templist[i];
                if (!string.IsNullOrEmpty(str))
                    PathNodeStack.Push(str);
            }
            AddinTreeNode node = GetAddinTreeNode(null, this.AddinTreeNodeList, PathNodeStack, isOnlyFind);
            if (node != null)
                node.AddinFullPath = path;
            return node;
        }

        private AddinTreeNode GetAddinTreeNode(AddinTreeNode parent, Dictionary<string, AddinTreeNode> parentChildNodes, Stack<string> PathNodeStack, bool isOnlyFind)
        {
            string currentNodeName = PathNodeStack.Pop();
            AddinTreeNode tempNode = null;
            if (parentChildNodes.ContainsKey(currentNodeName))
                tempNode = parentChildNodes[currentNodeName];
            else if (isOnlyFind)
                return null;
            else
            {
                tempNode = new AddinTreeNode();
                tempNode.ParentNode = parent;
                tempNode.PathNodeName = currentNodeName;
                if (parent == null)
                    parentChildNodes.Add(currentNodeName, tempNode);
                else
                    parent.AddChildNode(tempNode);
            }

            if (PathNodeStack.Count == 0)
                return tempNode;
            else
                return this.GetAddinTreeNode(tempNode, tempNode.ChildNodesDict, PathNodeStack, isOnlyFind);
        }
        #endregion

        #region CreateClassType
        public Type CreateClassType(string FullClassName)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(FullClassName))
                    throw new AddinException("FullClassName 为空");

#if SILVERLIGHT
            if (FullClassName.LastIndexOf(",version=") == -1)
                FullClassName += ",version=1.0.0.0";
#else
                if (FullClassName.EndsWith(".Silverlight"))
                    FullClassName = FullClassName.Remove(FullClassName.LastIndexOf(".Silverlight"));
#endif

                Type t = Type.GetType(FullClassName);
                if (t == null)
                    throw new AddinException(string.Format("没有找到类\"{0}\"", FullClassName));
                return t;
            }
            catch (Exception ex)
            {
                throw new AddinException(string.Format("获取类型失败 -> {0}", FullClassName), ex);
            }
        }
        #endregion

        #region CreateClassInstance
        public object CreateClassInstance(string FullClassName, string[] EventKeyList)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(FullClassName))
                    return null;

                Type t = CreateClassType(FullClassName);
                object obj = Activator.CreateInstance(t);

                if ((EventKeyList != null) && (EventKeyList.Length != 0))
                {
                    IAddinEventKey eventkey = obj as IAddinEventKey;
                    if (eventkey != null)
                    {
                        foreach (string streventkey in EventKeyList)
                        {
                            AddinEventService.Instance.RegisterGlobalEvent(streventkey, eventkey.EventFire);
                        }
                    }
                }
                return obj;
            }
            catch (Exception ex)
            {
                throw new AddinException(string.Format("构造类失败 -> {0}", FullClassName), ex);
            }
        }
        #endregion

        public void Start()
        {
            try
            {
                AddinEventService.Instance.AddinLoading("正在初始化系统......");

                AddinLoader.Instance.LoadAddins(AddinTreeFiles, CodonFactory, AddinTreeDoc =>
                {
                    if (AddinTreeDoc != null)
                        this.ProcessExtensionNode(AddinTreeDoc);
                }, () =>
                {
                    //AddinTreeNode definenode = AddinService.Instance.GetAddinTreeNode("/Jet/Definitions", true);
                    //if (definenode != null)
                    //    definenode.BuildItems();

                    AddinEventService.Instance.Init();
                    AddinEventService.Instance.AddinLoading("程序加载完成，正在启动中......");
                    if (LoadedComplete_Addin != null)
                        LoadedComplete_Addin();
                });
            }
            catch (Exception ex)
            {
                throw new AddinException("初始化系统失败", ex);
            }
        }
    }
}
