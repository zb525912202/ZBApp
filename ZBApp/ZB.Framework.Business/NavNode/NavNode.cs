using System;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.Threading;
using System.Linq;
using ZB.Framework.Utility;
using System.Text;

using System.IO;

namespace ZB.Framework.Business
{
    public interface INavNodeControler
    {
        bool IsVaildNavNode(NavNode node);
    }

    public class NavNode : IParent, ILevelBase<NavNode>
    {
        public const int NavNode_Root = 1;

        public const string __NodeType = "NodeType";

        public int Id { get; set; }
        public int ParentId { get; set; }
        public string ObjectName { get; set; }
        public string FullPath { get; set; }
        public int NodeType { get; set; }

        //====Start Extend====

        public int Depth { get; set; }
        public string ParentNodeFullPathName { get; set; }
        //====End=============

        private ObservableCollection<NavNode> _Children = new ObservableCollection<NavNode>();
        public ObservableCollection<NavNode> Children
        {
            get { return _Children; }
            set { _Children = value; }
        }

        public NavNode()
        {

        }

        public NavNode(string fullPathName, char splitChar)
        {
            string[] strArray = fullPathName.Split(splitChar);

            FullPath = fullPathName;
            Depth = strArray.Length;
            ObjectName = strArray[Depth - 1];
            ParentNodeFullPathName = Depth == 1 ? string.Empty : fullPathName.Substring(0, fullPathName.Length - ObjectName.Length - splitChar.ToString().Length);
        }

        private static long UniqueIDSeed = 0;

        private static object LockObj = new object();

        private long? _UniqueID = null;
        public long UniqueID
        {
            get
            {
                lock (LockObj)
                {
                    if (_UniqueID == null)
                    {
                        _UniqueID = UniqueIDSeed++;
                    }
                }
                return _UniqueID.Value;
            }
        }

        public bool IsChildren(string text)
        {
            return this.Children.Any(r => r.ObjectName == text);
        }

        public NavNode GetChildNode(INavNodeControler controler, string text)
        {
            if (this.Children != null)
            {
                foreach (var item in this.Children)
                {
                    if (controler.IsVaildNavNode(item) && item.ObjectName == text)
                        return item;
                }
            }

            return null;
        }

        public ObservableCollection<NavNode> SearchNodes(INavNodeControler controler, string queryText, int findMaxCount = 0)
        {
            queryText = queryText.Trim();
            ObservableCollection<NavNode> tempResult = new ObservableCollection<NavNode>();
            HashSet<long> resultDic = new HashSet<long>();
            this.SearchNodes_StartsWith(controler, queryText, tempResult, resultDic, findMaxCount);
            this.SearchNodes_Contains(controler, queryText, tempResult, resultDic, findMaxCount);

            //return new ObservableCollection<Node>(tempResult.Reverse());
            return tempResult;
        }

        private void SearchNodes_StartsWith(INavNodeControler controler, string text, ObservableCollection<NavNode> result, HashSet<long> resultDic, int findMaxCount)
        {
            if (controler.IsVaildNavNode(this) && (this.ObjectName == text))
            {
                result.Add(this);
                resultDic.Add(this.UniqueID);
            }

            if ((this.Children != null) && controler.IsVaildNavNode(this))
            {
                foreach (var child in this.Children)
                {
                    child.SearchNodes_StartsWith(controler, text, result, resultDic, findMaxCount);
                }
            }

            if ((findMaxCount > 0) && (result.Count >= findMaxCount))
                return;

            if ((!resultDic.Contains(this.UniqueID)) && controler.IsVaildNavNode(this) && this.ObjectName.StartsWith(text))
            {
                result.Add(this);
                resultDic.Add(this.UniqueID);
            }
        }

        private void SearchNodes_Contains(INavNodeControler controler, string text, ObservableCollection<NavNode> result, HashSet<long> resultDic, int findMaxCount)
        {
            if ((findMaxCount > 0) && (result.Count >= findMaxCount))
                return;

            if ((this.Children != null) && controler.IsVaildNavNode(this))
            {
                foreach (var child in this.Children)
                {
                    child.SearchNodes_Contains(controler, text, result, resultDic, findMaxCount);
                }
            }

            if (resultDic.Contains(this.UniqueID) == false)
            {
                if (controler.IsVaildNavNode(this) && this.ObjectName.Contains(text))
                {
                    result.Add(this);
                    resultDic.Add(this.UniqueID);
                }
            }
        }

        internal static void LoadBytes(SmartObjectSerializer serializer, NavNode node)
        {
            serializer.Write(node.Id);
            serializer.Write(node.ParentId);
            serializer.Write(node.ObjectName);
            serializer.Write(node.FullPath);
            serializer.Write(node.NodeType);
            serializer.Write(node.Depth);
        }

        internal static void LoadObj(SmartObjectDeserializer deserializer, NavNode node)
        {
            node.Id = deserializer.ReadInt32();
            node.ParentId = deserializer.ReadInt32();
            node.ObjectName = deserializer.ReadString();
            node.FullPath = deserializer.ReadString();
            node.NodeType = deserializer.ReadInt32();
            node.Depth = deserializer.ReadInt32();
        }

        public static void SerializerObject(SmartObjectSerializer serializer, NavNode node)
        {
            NavNode.LoadBytes(serializer, node);
            serializer.WriteObjectList(node.Children, NavNode.SerializerObject);
        }

        public static void DeserializerObject(SmartObjectDeserializer deserializer, NavNode node)
        {
            NavNode.LoadObj(deserializer, node);
            node.Children = new ObservableCollection<NavNode>(deserializer.ReadObjectList<NavNode>(NavNode.DeserializerObject));
        }

        /// <summary>
        /// 方便监视
        /// </summary>
        public override string ToString()
        {
            return string.Format("Id:{0},FullPath:{1}", this.Id, this.FullPath);
        }
    }
}
