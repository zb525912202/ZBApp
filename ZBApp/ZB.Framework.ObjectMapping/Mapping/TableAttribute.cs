using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    [AttributeUsage(AttributeTargets.Class)]
    public class TableAttribute : Attribute
    {
        public TableAttribute()
        {}

        public TableAttribute(string tablename)
        {
            this.Name = tablename;
        }

        public string Name {get;set;}

        /// <summary>
        /// 是否支持动态列
        /// </summary>
        public bool IsSupportExtend { get; set; }

        /// <summary>
        /// 主表实体类型
        /// </summary>
        public Type MasterType { get; set; }

        /// <summary>
        /// 外键
        /// </summary>
        public string ForeignKey { get; set; }

        public string MasterDetailView { get; set; }
    }
}
