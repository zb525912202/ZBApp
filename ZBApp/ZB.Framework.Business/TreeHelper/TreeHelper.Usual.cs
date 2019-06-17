using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Collections;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 针对IParent, ILevelBase<T>的一套帮助方法
    /// </summary>
    public partial class TreeHelper
    {
        /// <summary>
        /// 处理平行结构的集合对象，将每个成员对象(实现IParent接口定义)按其属性值表达的关系形成树结构，返回最顶级的成员对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <returns>最顶级的成员对象列表</returns>
        public static IList<T> UGenerateTree<T>(this IList<T> objList, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).GenerateTree(objList);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static T UFindFirstNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).FindFirstNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到第一个符合要求的节点
        /// </summary>
        public static T UFindLastNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).FindLastNode(treeList, nodeFunc);
        }

        /// <summary>
        /// 找到下一个符合要求的节点
        /// </summary>
        public static T UFindNextNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).FindNextNode(treeList, nodeFunc, startNode);
        }

        /// <summary>
        /// 找到上一个符合要求的节点
        /// </summary>
        public static T UFindPreNode<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).FindPreNode(treeList, nodeFunc, startNode);
        }

        public static void UExcludeForEachTree<T>(this IList<T> treeList, Action<T> nodeAction, T excludeNode, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            new TreeHelper_Usual<T>(getObjChildrenFunc).ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        public static void UExcludeForEachTree<T>(this IList<T> treeList, Action<T, bool> nodeAction, T excludeNode, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            new TreeHelper_Usual<T>(getObjChildrenFunc).ExcludeForEachTree(treeList, nodeAction, excludeNode);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public static void UForEachTree<T>(this IList<T> treeList, Action<T> nodeAction, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            new TreeHelper_Usual<T>(getObjChildrenFunc).ForEachTree(treeList, nodeAction);
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        public static void UForEachTree<T>(this IList<T> treeList, Action<T, T> nodeAction, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            new TreeHelper_Usual<T>(getObjChildrenFunc).ForEachTree(treeList, nodeAction);
        }

        /// <summary>
        /// 根据指定的起始节点,找到所有满足要求的节点
        /// </summary>
        public static List<T> UFindNodeList<T>(this IList<T> treeList, Func<T, bool> nodeFunc, T startNode, Func<T, IList<T>> getObjChildrenFunc)
            where T : IParent
        {
            return new TreeHelper_Usual<T>(getObjChildrenFunc).FindNodeList(treeList, nodeFunc, startNode);
        }
    }
}
