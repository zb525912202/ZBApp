using System;
using System.Net;
using System.Collections.Generic;
using System.Collections;

namespace ZB.AppShell.Addin
{
    public class AddinTreeNode
    {
        public AddinTreeNode()
        {
            this.ChildNodesDict = new Dictionary<string, AddinTreeNode>();
            this.ChildNodes = new List<AddinTreeNode>();
        }

        public AddinTreeNode ParentNode { get; internal set; }

        public Dictionary<string, AddinTreeNode> ChildNodesDict { get; private set; }

        public List<AddinTreeNode> ChildNodes { get; private set; }

        public void AddChildNode(AddinTreeNode childnode)
        {
            this.ChildNodesDict.Add(childnode.PathNodeName, childnode);
            this.ChildNodes.Add(childnode);
        }

        public void ClearChildNodes()
        {
            this.ChildNodesDict.Clear();
            this.ChildNodes.Clear();
        }

        public AddinTreeNode GetChildNode(string pathNodeName)
        {
            return this.ChildNodesDict[pathNodeName];
        }

        public bool IsContainNode(string pathNodeName)
        {
            return this.ChildNodesDict.ContainsKey(pathNodeName);
        }

        public string PathNodeName { get; set; }

        public string AddinFullPath {get;set;}

        public AbstractCodon Codon { get; set; }

        public string TreeRootName
        {
            get { return TreeRootNode.PathNodeName; }
        }

        public AddinTreeNode TreeRootNode
        {
            get
            {
                AddinTreeNode temp = this;
                while (temp.ParentNode != null)
                {
                    temp = temp.ParentNode;
                }
                return temp;
            }
        }

        public object BuildItem()
        {
            return BuildItem(null, null);
        }

        public object BuildItem(object caller, object parent)
        {
            if (this.Codon == null)
                return null;
            else
            {
                object obj = AddinShareService.Instance.BuildNodeItem(this, caller, parent);
                if (ChildNodes.Count > 0)
                    this.BuildItems(caller, obj);

                if (obj is IAddinRuntime_ChildNodesBuilded)
                {
                    if (!((IAddinRuntime_ChildNodesBuilded)obj).AddinRuntime_ChildNodesBuilded())
                        return null;
                }

                return obj;
            }
        }

        public IList BuildItems(object caller, object parent, Type type)
        {
            IList list = Activator.CreateInstance(typeof(List<>).MakeGenericType(type)) as IList;
            foreach (AddinTreeNode item in ChildNodes)
            {
                object o = AddinShareService.Instance.BuildNodeItem(item,caller, parent);
                if (o == null)
                    continue;

                if (item.Codon is AbstractConditionCodon)
                {
                    bool isvalid = (bool)o;
                    if (isvalid)
                    {
                        IList sublist = item.BuildItems(caller, parent);
                        foreach(var subitem in sublist)
                        {
                            list.Add(subitem);
                        }
                    }
                    else
                        continue;
                }
                else
                {
                    item.BuildItems(caller, o);

                    if (o is IAddinRuntime_ChildNodesBuilded)
                    {
                        var obj2 = o as IAddinRuntime_ChildNodesBuilded;
                        if (obj2.AddinRuntime_ChildNodesBuilded())
                            list.Add(o);
                    }
                    else
                        list.Add(o);
                }
            }
            return list;
        }

        public IList BuildItems()
        {
            return BuildItems(null, null);
        }

        public IList BuildItems(object caller, object parent)
        {
            return BuildItems(caller, parent, typeof(object));
        }

        public override string ToString()
        {
            return this.AddinFullPath;
        }
    }
}
