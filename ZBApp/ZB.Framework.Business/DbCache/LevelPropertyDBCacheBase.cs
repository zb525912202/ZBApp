using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using System.Data.Objects;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// ILevelProperty接口的对象缓存
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class LevelPropertyDBCacheBase<T> : SortableDBCacheBase<T>
        where T : ObjectMappingBase<T, int>, IParent, ISortable
    {
        public virtual T CreateRootNode()
        {
            return default(T);
        }

        private bool IsContainsFullPath(HashSet<string> parentFullPathHS, T obj)
        {
            foreach (string fullPath in parentFullPathHS)
            {
                if ((obj.FullPath + "/").StartsWith(fullPath + "/"))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 获得一组父节点及其子对象集合
        /// </summary>
        /// <returns></returns>
        private List<T> GetAllObjectListByParentFullPaths(HashSet<string> parentFullPathHS)
        {
            return this.GetAllObjectList().Where(r => this.IsContainsFullPath(parentFullPathHS, r)).ToList();
        }

        /// <summary>
        /// 获得一组父节点及其子对象集合
        /// </summary>
        /// <returns></returns>
        public List<T> GetAllObjectListByParentIds(params int[] parentIds)
        {
            HashSet<string> parentFullPathHS = new HashSet<string>();
            foreach (var parentId in parentIds)
            {
                if (this.ContainsId(parentId))
                {
                    parentFullPathHS.Add(this[parentId].FullPath);
                }
            }
            return this.GetAllObjectListByParentFullPaths(parentFullPathHS);
        }

        /// <summary>
        /// 获取最顶层试题文件夹，如果没有则创建并加入到缓存.
        /// </summary>
        /// <returns></returns>
        protected T GetOrCreateRootQfolder()
        {
            T rootNode = this.ObjectDict.Values.FirstOrDefault(q => q.ParentId == 0);
            if (rootNode != null) return rootNode;

            rootNode = this.ObjectDict.Values.FirstOrDefault(q => q.ParentId == 0);

            if (rootNode == null)
            {
                rootNode = this.CreateRootNode();

                if (rootNode == null)
                {
                    this.ObjectDict.Add(rootNode.Id, rootNode);
                }
            }
            return rootNode;
        }

        public T GetParentNode(T node)
        {
            if (this.ContainsId(node.ParentId))
                return this[node.ParentId];
            else
                return null;
        }

        public List<T> GetParentNodes(int nodeId)
        {
            if (this.ContainsId(nodeId))
            {
                return GetParentNodes(this[nodeId]);
            }
            return new List<T>();
        }

        public List<T> GetParentNodes(T node)
        {
            List<T> parList = new List<T>();

            int parentId = node.ParentId;
            while (this.ContainsId(parentId))
            {
                T pnode = this[parentId];
                parList.Add(pnode);
                parentId = pnode.ParentId;
            }

            return parList;
        }



        public T CreateNode(string parentColumnName, int parentId, string defaultNodeName)
        {
            if (this.ContainsId(parentId))
            {
                return BrLevelHelper.CreateSortableNode<T, T>(parentColumnName, parentId, defaultNodeName);
            }

            throw new ApplicationException(string.Format("[{0}]不存在ParnetId={1}", typeof(T).Name, parentId));
        }

        public T CreateNode<PT>(string parentColumnName, int parentId, string defaultNodeName)
            where PT : ObjectMappingBase<PT, int>, ILevelProperty
        {
            return BrLevelHelper.CreateSortableNode<T, PT>(parentColumnName, parentId, defaultNodeName);
        }

        public T CreateNode<PT>(string parentColumnName, int parentId, string defaultNodeName, Action<T, PT, int> beforeCreateNode)
            where PT : ObjectMappingBase<PT, int>, ILevelProperty
        {
            return BrLevelHelper.CreateNode<T, PT>(parentColumnName, parentId, beforeCreateNode, defaultNodeName);
        }

        public bool RenameILevel(int id, string newName, bool isAllowSameName = false)
        {
            return BrLevelHelper.Rename<T>(this.ObjectDict, id, newName);
        }

       


        public void UpdateForDrag(T dragNode, IList<T> sortNodeList)
        {
            BrLevelHelper.UpdateForDrag<T>(this.ObjectDict, dragNode, sortNodeList);
        }

        public void DeleteNode(int id)
        {
            if (this.ContainsId(id))
                BrLevelHelper.DeleteNode<T>(this[id]);
        }

        public T GetRootNode()
        {            
            T rootNode = GetRootNodeWhetherNull();
            if (rootNode == null)
            {
                rootNode = this.CreateRootNode();
            }
            return rootNode;
        }

        public T GetRootNodeWhetherNull()
        {            
            return this.Values.FirstOrDefault(r => r.ParentId == 0);
        }

        public Dictionary<string, int> GetAllFullPathDic()
        {
            Dictionary<string, int> deptDict = new Dictionary<string, int>();

            foreach (var item in this.Values)
            {
                deptDict.Add(item.FullPath, item.Id);
            }

            return deptDict;
        }
    }
}
