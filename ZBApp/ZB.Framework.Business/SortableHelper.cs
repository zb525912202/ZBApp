using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public static class SortableHelper
    {
        /// <summary>
        /// 获得SortIndex最大的一个
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <returns>如果项数为0，返回null；如果存在多个满足条件的对象，返回第一个</returns>
        public static T GetTopSortIndexObj<T>(this IEnumerable<T> objList, Func<T, bool> predicate = null)
            where T : ISortable
        {
            return objList.Where(s => ((null == predicate) ? true : predicate.Invoke(s)) && (s.SortIndex == objList.Max(t => t.SortIndex))).FirstOrDefault();
        }

        /// <summary>
        /// 获得SortIndex最小的一个
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="objList"></param>
        /// <returns>如果项数为0，返回null；如果存在多个满足条件的对象，返回第一个</returns>
        public static T GetBottomSortIndexObj<T>(this IEnumerable<T> objList)
            where T : ISortable
        {
            return objList.Where(s => s.SortIndex == objList.Min(t => t.SortIndex)).FirstOrDefault();
        }

        /// <summary>
        /// 根据SortIndex从objList中找到下一个对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        /// <param name="objList"></param>
        /// <returns>如果没有满足条件的对象，返回null；如果有相同SortIndex的对象存在，则根据其Id是否大于当前对象自身来决定是否有资格返回；如果存在多个满足条件的对象，返回第一个</returns>
        public static T GetNextSortIndexObj<T>(this T obj, IEnumerable<T> objList)
            where T : ISortable
        {
            return objList.Where(s => (s.Id != obj.Id) && (s.Id > obj.Id && s.SortIndex >= obj.SortIndex)).FirstOrDefault();
        }

        /// <summary>
        /// 根据SortIndex从objList中找到上一个对象
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="obj"></param>
        /// <param name="objList"></param>
        /// <returns>如果没有满足条件的对象，返回null；如果有相同SortIndex的对象存在，则根据其Id是否小于当前对象自身来决定是否有资格返回；如果存在多个满足条件的对象，返回第一个</returns>
        public static T GetPreviousSortIndexObj<T>(this T obj, IEnumerable<T> objList)
            where T : ISortable
        {
            return objList.Where(s => (s.Id != obj.Id) && (s.Id < obj.Id && s.SortIndex <= obj.SortIndex)).FirstOrDefault();
        }
    }
}
