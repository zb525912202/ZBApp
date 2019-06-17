using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference=true)]
    public class SqlConditionItem
    {
        public SqlConditionItem()
        {
        }

        /// <summary>
        /// 条件类型
        /// </summary>
        [DataMember]
        public EnumSqlConditionType Type{get;set;}

        /// <summary>
        /// 列名
        /// </summary>
        [DataMember]
        public string ColumnName { get; set; }

        /// <summary>
        /// 条件数值
        /// </summary>
        [DataMember]
        public object ConditionValue { get; set; }

        /// <summary>
        /// 条件数值2    (Between需要两个条件参数)
        /// </summary>
        [DataMember]
        public object ConditionValue2 { get; set; }

        /// <summary>
        /// 条件数值集合
        /// </summary>
        [DataMember]
        public ObservableCollection<object> ConditionValues { get; set; }

        /// <summary>
        /// 参数集合
        /// </summary>
        [DataMember]
        public ParameterCollection ParameterCollection { get; set; }
    }
}
