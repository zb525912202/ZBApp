using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Collections;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 针对ILevel的一套帮助方法
    /// </summary>
    public static partial class TreeHelper
    {
        public static ILevel NGetParentNode(this IList<ILevel> treeList, ILevel obj)
        {
            return TreeHelper_Normal.Instance.GetParentNode(treeList, obj);
        }

        /// <summary>
        /// 计算得到指定节点的子节点数
        /// </summary>
        public static int NGetTotalChildCount(this ILevel obj)
        {
            return TreeHelper_Normal.Instance.GetTotalChildCount(obj);
        }

        /// <summary>
        /// 获得指定节点自身以及所有子节点(至少包含自身)
        /// </summary>
        public static IQueryable NGetChildren(this ILevel obj, IEnumerable<ILevel> source)
        {
            return TreeHelper_Normal.Instance.GetChildren(obj, source);
        }

        /// <summary>
        /// 计算指定节点的SumRecord
        /// </summary>
        public static void NComputeSumRecord(ILevel node)
        {
            TreeHelper_Normal.Instance.ComputeSumRecord(node);
        }

        /// <summary>
        /// 计算树的SumRecord
        /// </summary>
        public static void NComputeSumRecord(this IList<ILevel> treeList)
        {
            TreeHelper_Normal.Instance.ComputeSumRecord(treeList);
        }

        /// <summary>
        /// 处理平行结构的集合对象，将每个成员对象(实现ILevel接口定义)按其属性值表达的关系形成树结构，返回最顶级的成员对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <returns>最顶级的成员对象列表</returns>
        public static IList<ILevel> NGenerateTreeStruct(this IList<ILevel> treeList, bool isComputeSumRecord = true)
        {
            return TreeHelper_Normal.Instance.GenerateTreeStruct(treeList, isComputeSumRecord);
        }

        /// <summary>
        /// 将树形结构的对象转换成平行结构的对象,不包含根节点
        /// </summary>
        public static IEnumerable<ILevel> NGenerateParallelStruct(this ILevel parentNode)
        {
            return TreeHelper_Normal.Instance.GenerateParallelStruct(parentNode);
        }

        /// <summary>
        /// 将多根树行结构对象转换成平行结构的对象，包含根节点
        /// </summary>
        public static IEnumerable<ILevel> NGenerateParallelMultiRootStruct(this IEnumerable<ILevel> nodes)
        {
            return TreeHelper_Normal.Instance.GenerateParallelMultiRootStruct(nodes);
        }

        /// <summary>
        /// 遍历节点的子节点
        /// </summary>
        public static void NForEachChildren(this ILevel obj, Action<ILevel> nodeAction)
        {
            TreeHelper_Normal.Instance.ForEachChildren(obj, nodeAction);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public static void NForEachTree(this IList<ILevel> treeList, Action<ILevel> nodeAction)
        {
            TreeHelper_Normal.Instance.ForEachTree(treeList, nodeAction);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        public static void NForEachTree(this IList<ILevel> treeList, Action<ILevel, ILevel> nodeAction)
        {
            TreeHelper_Normal.Instance.ForEachTree(treeList, nodeAction);
        }

        public static void NExcludeForEachTree(this IList<ILevel> treeList, Action<ILevel> nodeAction, ILevel excludeNode)
        {
            TreeHelper_Normal.Instance.ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        public static void NExcludeForEachTree(this IList<ILevel> treeList, Action<ILevel, bool> nodeAction, ILevel excludeNode)
        {
            TreeHelper_Normal.Instance.ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static ILevel NFindFirstNode(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc)            
        {
            return TreeHelper_Normal.Instance.FindFirstNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static ILevel NFindLastNode(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc)
        {
            return TreeHelper_Normal.Instance.FindLastNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到下一个符合要求的节点
        /// </summary>
        public static ILevel NFindNextNode(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc, ILevel startNode = null)
        {
            return TreeHelper_Normal.Instance.FindNextNode(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 找到上一个符合要求的节点
        /// </summary>
        public static ILevel NFindPreNode(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc, ILevel startNode = null)
        {
            return TreeHelper_Normal.Instance.FindPreNode(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        public static int NFindNodeCount(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc, ILevel startNode = null)
        {
            return TreeHelper_Normal.Instance.FindNodeCount(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点数量
        /// </summary>
        public static List<ILevel> NFindNodeList(this IList<ILevel> treeList, Func<ILevel, bool> nodeFunc, ILevel startNode = null)
        {
            return TreeHelper_Normal.Instance.FindNodeList(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 根据ParentId将subObjDic的元素添加parentObjDic的相应元素的NChildren里
        /// </summary>
        public static void NUnitTowDicByParentId<T1, T2>(this Dictionary<int, T1> parentObjDic, Dictionary<int, T2> subObjDic)
            where T1 : ILevel
            where T2 : ILevel
        {
            foreach (var subObj in subObjDic.Values)
            {
                if (parentObjDic.ContainsKey(subObj.ParentId))
                {
                    subObj.FullPath = parentObjDic[subObj.ParentId].FullPath + "/" + subObj.ObjectName;
                    parentObjDic[subObj.ParentId].NChildren.Add(subObj);
                }
            }
        }

        /// <summary>
        /// 根据ParentId将subObjList的元素添加parentObjList的相应元素的NChildren里
        /// </summary>
        public static void NUnitTowListByParentId<T1, T2>(this IList<T1> parentObjList, IList<T2> subObjList)
            where T1 : ILevel
            where T2 : ILevel
        {
            Dictionary<int, T1> parentObjDic = parentObjList.ToDictionary(obj => obj.Id, obj => obj);
            Dictionary<int, T2> subObjDic = subObjList.ToDictionary(obj => obj.Id, obj => obj);
            NUnitTowDicByParentId<T1, T2>(parentObjDic, subObjDic);
        }
    }
}
