using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    internal abstract partial class TreeHelperBase<T>
    {
        public void ForEachChildren(T obj, Action<T> nodeAction)
        {
            foreach (T node in this.GetObjChildren(obj))
            {
                nodeAction(obj);
                ForEachChildren(node, nodeAction);
            }
        }

        /// <summary>
        /// 遍历树,排除指定的节点及其父节点
        /// </summary>
        private void ExcludeForEachTree(IList<T> treeList, Action<T> nodeAction, HashSet<T> excludeHs)
        {
            foreach (T node in treeList)
            {
                if (!excludeHs.Contains(node))
                {
                    nodeAction(node);
                }
                ExcludeForEachTree(this.GetObjChildren(node), nodeAction, excludeHs);
            }
        }

        /// <summary>
        /// 遍历树,排除指定的节点及其父节点
        /// </summary>
        public void ExcludeForEachTree(IList<T> treeList, Action<T> nodeAction, T excludeNode)
        {
            if (excludeNode != null)
            {
                HashSet<T> excludeHs = this.FindParentNodeHashSet(treeList, excludeNode.FullPath);
                this.ExcludeForEachTree(treeList, nodeAction, excludeHs);
            }
        }

        /// <summary>
        /// 遍历树,排除指定的节点及其父节点
        /// </summary>
        private void ExcludeForEachTree(IList<T> treeList, Action<T, bool> nodeAction, HashSet<T> excludeHs)
        {
            foreach (T node in treeList)
            {
                nodeAction(node, excludeHs.Contains(node));
                ExcludeForEachTree(this.GetObjChildren(node), nodeAction, excludeHs);
            }
        }

        /// <summary>
        /// 遍历树,排除指定的节点及其父节点
        /// </summary>
        public void ExcludeForEachTree(IList<T> treeList, Action<T, bool> nodeAction, T excludeNode)
        {
            if (excludeNode != null)
            {
                HashSet<T> excludeHs = this.FindParentNodeHashSet(treeList, excludeNode.FullPath);
                this.ExcludeForEachTree(treeList, nodeAction, excludeHs);
            }
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        private void ForEachTree(IList<T> treeList, Action<T, T> nodeAction, T parentObj)
        {
            foreach (T node in treeList)
            {
                nodeAction(parentObj, node);
                ForEachTree(this.GetObjChildren(node), nodeAction, node);
            }
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        public void ForEachTree(IList<T> treeList, Action<T, T> nodeAction)
        {
            this.ForEachTree(treeList, nodeAction, default(T));
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public void ForEachTree(IList<T> treeList, Action<T> nodeAction)
        {
            foreach (T node in treeList)
            {
                nodeAction(node);
                ForEachTree(this.GetObjChildren(node), nodeAction);
            }
        }

        /// <summary>
        /// 根据parentId查找父节点
        /// </summary>
        public T GetParentNode(IList<T> treeList, T obj)
        {
            foreach (T node in treeList)
            {
                IList<T> children = this.GetObjChildren(node);
                foreach (T subNode in children)
                {
                    if (subNode.Equals(obj))
                        return node;
                }

                T nodeTemp = GetParentNode(children, obj);
                if (nodeTemp != null)
                    return nodeTemp;
            }

            return default(T);
        }

        /// <summary>
        /// 获得一个节点的所有上级节点
        /// </summary>
        public List<T> GetParentNodeList(Dictionary<int, T> treeDic, T obj)
        {
            List<T> parentNodeList = new List<T>();
            int parentId = obj.ParentId;
            while (treeDic.ContainsKey(parentId))
            {
                T parentNode = treeDic[parentId];
                parentNodeList.Add(parentNode);
                parentId = parentNode.ParentId;
            }
            return parentNodeList;
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public T FindFirstNode(IList<T> treeList, Func<T, bool> nodeFunc)
        {
            bool isFindStartNode = true;
            return this.FindNextNode(treeList, default(T), nodeFunc, ref isFindStartNode);
        }

        /// <summary>
        /// 找到最后一个符合要求的节点
        /// </summary>
        public T FindLastNode(IList<T> treeList, Func<T, bool> nodeFunc)
        {
            bool isFindStartNode = true;
            return this.FindPreNode(treeList, default(T), nodeFunc, ref isFindStartNode);
        }

        /// <summary>
        /// 顺序遍历树，根据制定的起始节点,找到第一个符合要求的节点
        /// </summary>
        private T FindNextNode(IList<T> treeList, T startNode, Func<T, bool> nodeFunc, ref bool isFindStartNode)
        {
            foreach (T node in treeList)
            {
                if (isFindStartNode)
                {
                    if (nodeFunc(node))
                        return node;
                }
                else
                {
                    if (node.Equals(startNode))
                        isFindStartNode = true;
                }

                T fildNode = FindNextNode(this.GetObjChildren(node), startNode, nodeFunc, ref isFindStartNode);
                if (fildNode != null)
                    return fildNode;
            }

            return default(T);
        }

        /// <summary>
        /// 找到下一个符合要求的节点
        /// </summary>
        public T FindNextNode(IList<T> treeList, Func<T, bool> nodeFunc, T startNode)
        {
            bool isFindStartNode = (startNode == null);
            return this.FindNextNode(treeList, startNode, nodeFunc, ref isFindStartNode);
        }

        /// <summary>
        /// 根据制定的起始节点,找到前一个符合要求的节点
        /// </summary>
        private T FindPreNode(IList<T> treeList, T startNode, Func<T, bool> nodeFunc, ref bool isFindStartNode)
        {
            for (int i = treeList.Count - 1; i > -1; i--)
            {
                T node = treeList[i];

                T fildNode = FindPreNode(this.GetObjChildren(node), startNode, nodeFunc, ref isFindStartNode);
                if (fildNode != null)
                    return fildNode;

                if (isFindStartNode)
                {
                    if (nodeFunc(node))
                        return node;
                }
                else
                {
                    if (node.Equals(startNode))
                        isFindStartNode = true;
                }
            }

            return default(T);
        }

        /// <summary>
        /// 找到上一个符合要求的节点
        /// </summary>
        public T FindPreNode(IList<T> treeList, Func<T, bool> nodeFunc, T startNode)
        {
            bool isFindStartNode = (startNode == null);
            return this.FindPreNode(treeList, startNode, nodeFunc, ref isFindStartNode);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        private int FindNodeCount(IList<T> treeList, T startNode, Func<T, bool> nodeFunc, ref bool isFindStartNode)
        {
            int count = 0;
            foreach (T node in treeList)
            {
                if (isFindStartNode)
                {
                    if (nodeFunc(node))
                        count++;
                }
                else
                {
                    if (node.Equals(startNode))
                        isFindStartNode = true;
                }

                count += FindNodeCount(this.GetObjChildren(node), startNode, nodeFunc, ref isFindStartNode);
            }

            return count;
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        public int FindNodeCount(IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
        {
            bool isFindStartNode = (startNode == null);
            return this.FindNodeCount(treeList, startNode, nodeFunc, ref isFindStartNode);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        private List<T> FindNodeList(IList<T> treeList, T startNode, Func<T, bool> nodeFunc, ref bool isFindStartNode)
        {
            List<T> list = new List<T>();
            foreach (T node in treeList)
            {
                if (isFindStartNode)
                {
                    if (nodeFunc(node))
                        list.Add(node);
                }
                else
                {
                    if (node.Equals(startNode))
                        isFindStartNode = true;
                }

                list.AddRange(FindNodeList(this.GetObjChildren(node), startNode, nodeFunc, ref isFindStartNode).ToArray());
            }

            return list;
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        public List<T> FindNodeList(IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
        {
            bool isFindStartNode = (startNode == null);
            return this.FindNodeList(treeList, startNode, nodeFunc, ref isFindStartNode);
        }
    }
}
