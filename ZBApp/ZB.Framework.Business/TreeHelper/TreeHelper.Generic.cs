using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.ComponentModel;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 针对ILevel<T>的一套帮助方法
    /// </summary>
    public static partial class TreeHelper
    {
        public static IList<T> GetParentNodeList<T>(this IList<T> treeList, Dictionary<int, T> treeDic, T obj)
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).GetParentNodeList(treeDic, obj);
        }

        public static T GetParentNode<T>(this IList<T> treeList, T obj)
           where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).GetParentNode(treeList, obj);
        }

        /// <summary>
        /// 计算得到指定节点的子节点数
        /// </summary>
        public static int GetTotalChildCount<T>(T obj)
            where T : ILevel<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).GetTotalChildCount(obj);
        }

        /// <summary>
        /// 获得指定节点自身以及所有子节点(至少包含自身)
        /// </summary>
        public static IQueryable<T> GetChildren<T>(this T obj, IEnumerable<T> source)
            where T : ILevel<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).GetChildren(obj, source);
        }

        /// <summary>
        /// 计算指定节点的SumRecord
        /// </summary>
        public static void ComputeSumRecord<T>(T obj) where T : ILevel<T>
        {
            new TreeHelper_Gerneric<T>().ComputeSumRecord(obj);
        }

        /// <summary>
        /// 计算树的SumRecord
        /// </summary>
        public static void ComputeSumRecord<T>(this IList<T> treeList) where T : ILevel<T>
        {
            new TreeHelper_Gerneric<T>().ComputeSumRecord(treeList);
        }

        public static IList<T> GetRootNodeList<T>(this Dictionary<int, T> objDic)
            where T : ILevel<T>
        {
            return new TreeHelper_Gerneric<T>().GetRootNodeList(objDic);
        }

        /// <summary>
        /// 处理平行结构的集合对象，将每个成员对象(实现ILevel接口定义)按其属性值表达的关系形成树结构，返回最顶级的成员对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <returns>最顶级的成员对象列表</returns>
        public static IList<T> GenerateTreeStruct<T>(this IList<T> objList, bool isComputeSumRecord = true)
            where T : ILevel<T>
        {
            return new TreeHelper_Gerneric<T>().GenerateTreeStruct(objList, isComputeSumRecord);
        }

        /// <summary>
        /// 将树形结构的对象转换成平行结构的对象,不包含根节点
        /// </summary>
        public static IEnumerable<T> GenerateParallelStruct<T>(this T parentNode) where T : ILevel<T>
        {
            return new TreeHelper_Gerneric<T>().GenerateParallelStruct(parentNode);
        }

        /// <summary>
        /// 将多根树行结构对象转换成平行结构的对象，包含根节点
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="nodes">The nodes.</param>
        /// <returns></returns>
        public static IEnumerable<T> GenerateParallelMultiRootStruct<T>(this IEnumerable<T> nodes)
            where T : ILevel<T>
        {
            return new TreeHelper_Gerneric<T>().GenerateParallelMultiRootStruct(nodes);
        }

        /// <summary>
        /// 遍历节点的子节点
        /// </summary>
        public static void ForEachChildren<T>(this T obj, Action<T> nodeAction)
            where T : IParent, ILevelBase<T>
        {
            new TreeHelper_Usual<T>(r => r.Children).ForEachChildren(obj, nodeAction);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public static void ForEachTree<T>(this IList<T> treeList, Action<T> nodeAction)
            where T : IParent, ILevelBase<T>
        {
            new TreeHelper_Usual<T>(r => r.Children).ForEachTree(treeList, nodeAction);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        public static void ForEachTree<T>(this IList<T> treeList, Action<T, T> nodeAction)
            where T : IParent, ILevelBase<T>
        {
            new TreeHelper_Usual<T>(r => r.Children).ForEachTree(treeList, nodeAction);
        }

        public static void ExcludeForEachTree<T>(this IList<T> treeList, Action<T> nodeAction, T excludeNode)
            where T : IParent, ILevelBase<T>
        {
            new TreeHelper_Usual<T>(r => r.Children).ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        public static void ExcludeForEachTree<T>(this IList<T> treeList, Action<T, bool> nodeAction, T excludeNode)
            where T : IParent, ILevelBase<T>
        {
            new TreeHelper_Usual<T>(r => r.Children).ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static T FindFirstNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc)
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindFirstNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static T FindLastNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc)
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindLastNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到下一个符合要求的节点
        /// </summary>
        public static T FindNextNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindNextNode(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 找到上一个符合要求的节点
        /// </summary>
        public static T FindPreNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindPreNode(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        public static int FindNodeCount<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindNodeCount(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 找到所有满足要求的节点数量
        /// </summary>
        public static int FindNodeCount<T>(this IList<T> treeList, Func<T, bool> nodeFunc)
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindNodeCount(treeList, nodeFunc);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点
        /// </summary>
        public static List<T> FindNodeList<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode = default(T))
            where T : IParent, ILevelBase<T>
        {
            return new TreeHelper_Usual<T>(r => r.Children).FindNodeList(treeList, nodeFunc, startNode);
        }

        public static void BuildFullPath<T>(this IList<T> objList, T parentObj = default(T))
           where T : IParent, ILevelBase<T>
        {
            foreach (T subObj in objList)
            {
                if (parentObj != null)
                    subObj.FullPath = parentObj.FullPath + "/" + subObj.ObjectName;
                else
                    subObj.FullPath = subObj.ObjectName;

                BuildFullPath<T>(subObj.Children, subObj);
            }
        }

        /// <summary>
        /// 在树中同级节点存在同名的情况时，修改节点的名称，在节点名称后依次加上1.2.3....
        /// </summary>
        /// <param name="objList"></param>
        public static void RenameTreeNode<T>(this IList<T> objList)
            where T : IParent, ILevelBase<T>
        {
            Dictionary<string, int> dict = new Dictionary<string, int>();

            var orderList = objList.OrderByDescending(s => s.ObjectName);

            foreach (T subObj in orderList)
            {
                if (!dict.ContainsKey(subObj.ObjectName))
                {
                    dict.Add(subObj.ObjectName, 0);
                }
                else
                {
                    int index = dict[subObj.ObjectName] + 1;

                    string name = string.Format("{0}_{1}", subObj.ObjectName, index);

                    while (dict.ContainsKey(name))
                    {
                        index = index + 1;
                        name = string.Format("{0}_{1}", subObj.ObjectName, index);
                    }

                    //subObj.ObjectName = string.Format("{0}_{1}", subObj.ObjectName, index);
                    subObj.ObjectName = name;
                    dict.Add(subObj.ObjectName, index);
                }

                RenameTreeNode(subObj.Children);
            }
        }


        /// <summary>
        /// 根据ParentId将subObjDic的元素添加parentObjDic的相应元素的Children里
        /// </summary>
        public static void UnitTowDicByParentId<T>(this Dictionary<int, T> parentObjDic, Dictionary<int, T> subObjDic)
            where T : IParent, ILevelBase<T>
        {
            foreach (var subObj in subObjDic.Values)
            {
                if (parentObjDic.ContainsKey(subObj.ParentId))
                {
                    T parentObj = parentObjDic[subObj.ParentId];
                    subObj.FullPath = parentObj.FullPath + "/" + subObj.ObjectName;
                    parentObj.Children.Add(subObj);
                }
            }
        }

        /// <summary>
        /// 根据ParentId将subObjList的元素添加parentObjList的相应元素的NChildren里
        /// </summary>
        public static void UnitTowListByParentId<T>(this IList<T> parentObjList, IList<T> subObjList)
            where T : IParent, ILevelBase<T>
        {
            Dictionary<int, T> parentObjDic = parentObjList.ToDictionary(obj => obj.Id, obj => obj);
            Dictionary<int, T> subObjDic = subObjList.ToDictionary(obj => obj.Id, obj => obj);
            UnitTowDicByParentId<T>(parentObjDic, subObjDic);
        }

        public static List<T> GetTotalObjList<T>(this List<T> treeList)
            where T : IParent, ILevelBase<T>
        {
            List<T> totalObjList = new List<T>();

            ForEachTree(treeList, (parentObj, obj) =>
            {
                totalObjList.Add(obj);
            });

            return totalObjList;
        }
    }
}