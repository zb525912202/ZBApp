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
    /// ISortable接口的对象缓存
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class SortableDBCacheBase<T> : ObjectNameCacheBase<T>
        where T : ObjectMappingBase<T, int>, ISortable
    {
        /// <summary>
        /// 获得对象集合
        /// </summary>
        /// <returns></returns>
        public override List<T> GetAllObjectList()
        {
            return this.ObjectDict.Values.OrderBy(t => t.SortIndex).ToList();
        }

        public void UpdateSortIndex(IList<T> objList)
        {
            BrSortableHelper.UpdateSortIndex<T>(this.ObjectDict, objList);
        }
    }
}
