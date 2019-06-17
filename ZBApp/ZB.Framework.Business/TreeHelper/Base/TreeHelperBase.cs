using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Collections;

namespace ZB.Framework.Business
{
    internal abstract partial class TreeHelperBase<T>
        where T : IParent
    {
        protected abstract IList<T> GetObjChildren(T obj);

        /// <summary>
        /// 根据指定的全路径，找到所有的父节点（包括自己）
        /// </summary>
        protected HashSet<T> FindParentNodeHashSet(IList<T> treeList, string fullPath)
        {
            HashSet<T> parentHS = new HashSet<T>();
            HashSet<string> parentFullPathHS = new HashSet<string>();

            string parentFullPath = "";
            foreach (var str in fullPath.Split('/'))
            {
                if (string.IsNullOrEmpty(parentFullPath))
                    parentFullPath = str;
                else
                    parentFullPath = parentFullPath + "/" + str;

                parentFullPathHS.Add(parentFullPath);
            }
            this.ForEachTree(treeList, (obj) =>
            {
                if (parentFullPathHS.Contains(obj.FullPath))
                    parentHS.Add(obj);
            });
            return parentHS;
        }

        public IQueryable<T> GetChildren(T obj, IEnumerable<T> source)
        {
            IQueryable<T> result = new List<T>() { obj }.AsQueryable<T>();
            if (null == source)
            {
                return result;
            }
            string filterFullPath = obj.FullPath + '/';
            return result.Union(source.Where(s => s.FullPath.StartsWith(filterFullPath)));
        }

        public IList<T> GetRootNodeList(Dictionary<int, T> objDic)
        {
            IList<T> rootTreeNodeList = new List<T>();

            foreach (T obj in objDic.Values)
            {
                //if (!objDic.ContainsKey(obj.ParentId))
                //2014-1-15邬瀚修改，隐藏了ParentDept被删除的错误数据
                if (obj.ParentId == 0)
                    rootTreeNodeList.Add(obj);
            }

            return rootTreeNodeList;
        }

        public IList<T> GenerateTree(IList<T> objList)
        {
            IList<T> rootTreeNodeList = new List<T>();
            Dictionary<int, T> dic = objList.ToDictionary(r => r.Id, r => r);

            foreach (T obj in objList)
            {
                IList<T> children = GetObjChildren(obj);

                if (children == null)
                    throw new Exception(string.Format("[{0}]的Children属性不能为空!", typeof(T).Name));
                else
                    children.Clear();
            }

            foreach (T obj in objList)
            {
                if (dic.ContainsKey(obj.ParentId))
                {
                    T parentNode = dic[obj.ParentId];
                    GetObjChildren(parentNode).Add(obj);
                }
            }

            foreach (T obj in objList)
            {
                if (!dic.ContainsKey(obj.ParentId))
                    rootTreeNodeList.Add(obj);
            }

            return rootTreeNodeList;
        }

        /// <summary>
        /// 将树形结构的对象转换成平行结构的对象,不包含根节点
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="parentNode"></param>
        /// <returns></returns>
        public IEnumerable<T> GenerateParallelStruct(T parentNode)
        {
            foreach (T item in this.GetObjChildren(parentNode))
            {
                yield return item;
                IEnumerable<T> iter = this.GenerateParallelStruct(item);
                foreach (var subNode in iter)
                {
                    yield return subNode;
                }
            }
        }

        /// <summary>
        /// 将多根树行结构对象转换成平行结构的对象，包含根节点
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="nodes">The nodes.</param>
        /// <returns></returns>
        public IEnumerable<T> GenerateParallelMultiRootStruct(IEnumerable<T> nodes)
        {
            List<T> temp = new List<T>();

            temp.AddRange(nodes);

            foreach (var node in nodes)
            {
                temp.AddRange(this.GenerateParallelStruct(node));
            }

            return temp.AsEnumerable();
        }

        /// <summary>
        /// 重新构建FullPath
        /// </summary>
        public void BuildFullPath(IList<T> treeList, string parentFullPath = "")
        {
            foreach (var node in treeList)
            {
                node.FullPath = parentFullPath + node.ObjectName;
                this.BuildFullPath(this.GetObjChildren(node), node.FullPath + "/");//递归
            }
        }

        /// <summary>
        /// 获得子节点数
        /// </summary>
        public int GetTotalChildCount(T obj)
        {
            IList<T> children = this.GetObjChildren(obj);
            int childRenCount = children.Count();
            foreach (T subObj in children)
            {
                childRenCount += this.GetTotalChildCount(subObj);
            }
            return childRenCount;
        }
    }
}
