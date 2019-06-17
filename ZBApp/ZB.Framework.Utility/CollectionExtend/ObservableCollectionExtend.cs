using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace ZB.Framework.Utility
{
    public static class ObservableCollectionExtend
    {
        /// <summary>
        /// 根据条件删除所有满足的项
        /// </summary>
        public static ObservableCollection<T> RemoveObjList<T>(this ObservableCollection<T> list, IList<T> removeObjList)
        {
            List<T> newObjList = new List<T>();
            HashSet<T> removeHs = new HashSet<T>(removeObjList);

            foreach (var obj in list)
            {
                if (!removeHs.Contains(obj))
                    newObjList.Add(obj);
            }

            return new ObservableCollection<T>(newObjList);
        }

        /// <summary>
        /// 循环ObservableCollection
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="list"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public static ObservableCollection<T> ForEach<T>(this ObservableCollection<T> list, Action<T> action)
        {
            foreach (var item in list)
            {
                action(item);
            }

            return list;
        }
        public static ObservableCollection<T> AddRange<T>(this ObservableCollection<T> list, IEnumerable<T> newList)
        {
            foreach (var item in newList)
            {
                list.Add(item);
            }
            return list;
        }


    }
}
