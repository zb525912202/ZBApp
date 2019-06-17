using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference = true)]
    public class PageAdapter : RetrieveCriteria
    {
        public PageAdapter()
        {

        }

        /// <summary>
        /// 页索引
        /// </summary>
        [DataMember]
        public int PageIndex { get; set; }

        /// <summary>
        /// 总页数(服务端未填填充，由客户端使用)
        /// </summary>
        public int PageCount { get; set; }

        /// <summary>
        /// 总记录数
        /// </summary>
        [DataMember]
        public int MaxRowCount { get; set; }

        /// <summary>
        /// 页大小
        /// </summary>
        [DataMember]
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

        [DataMember]
        public string CustomSqlString_MaxRowCount { get; set; }

        [DataMember]
        public string CustomSqlString_GetPageData { get; set; }

        public RetrieveCriteria GetRetrieveCriteria()
        {
            RetrieveCriteria query = new RetrieveCriteria();
            query.Database = Database;
            query.ViewName = ViewName;
            query.PkColumnName = PkColumnName;
            query.Orders = Orders.Clone();
            query.Conditions = Conditions.Clone();
            query.Columns = Columns.Clone();
            return query;
        }
    }
}
