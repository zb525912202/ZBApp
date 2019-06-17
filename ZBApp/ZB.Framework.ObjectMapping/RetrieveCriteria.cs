using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference = true)]
    public class RetrieveCriteria : ISqlCondition, ISqlSelectColumns, ISqlOrder
    {
        public RetrieveCriteria()
        {
            this.Conditions = new SqlCondition();
            this.Columns = new SqlSelectColumns();
            this.Orders = new SqlOrder();
            this.ViewName = string.Empty;
            this.AttachCriteria = new List<RetrieveCriteria>();
        }

        [DataMember]
        public SqlCondition Conditions { get; set; }

        [DataMember]
        public SqlSelectColumns Columns { get; set; }

        [DataMember]
        public SqlOrder Orders { get; set; }

        [DataMember]
        public string ViewName { get; set; }

        [DataMember]
        public string PkColumnName { get; set; }

        [DataMember]
        public string Database { get; set; }

        [DataMember]
        public int Top { get; set; }


        [DataMember]
        public string PropertyName { get; set; }

        [DataMember]
        public string PropertyTypeName { get; set; }

        [DataMember]
        public string FkColumnName { get; set; }

        [DataMember]
        public List<RetrieveCriteria> AttachCriteria { get; set; }

        /// <summary>
        /// 除AttachCriteria其他都清除
        /// </summary>
        public void Clear()
        {
            this.Top = 0;
            this.ViewName = string.Empty;
            this.Conditions.Clear();
            this.Orders.Clear();
            this.Columns.Clear();
        }

        public void ClearAll()
        {
            this.Clear();
            this.AttachCriteria.Clear();
        }

    }
}
