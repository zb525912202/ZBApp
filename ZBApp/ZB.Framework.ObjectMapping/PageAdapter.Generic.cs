using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class PageAdapter<T> : RetrieveCriteria<T> where T : ObjectMappingBase
    {
        public PageAdapter()
        {
            PageSize = 15;
        }

        /// <summary>
        /// 页索引
        /// </summary>
        public int PageIndex { get; set; }

        /// <summary>
        /// 总页数
        /// </summary>
        public int PageCount { get; set; }

        /// <summary>
        /// 总记录数
        /// </summary>
        public int MaxRowCount { get; set; }

        /// <summary>
        /// 页大小
        /// </summary>
        public int PageSize { get; set; }

        public int MinRownum
        {
            get
            {
                return this.PageSize * this.PageIndex;
            }
        }

        public int MaxRownum
        {
            get
            {
                int maxRownum = this.PageSize * (this.PageIndex + 1);
                return this.MaxRowCount < maxRownum ? this.MaxRowCount : maxRownum;
            }
        }
    }
}
