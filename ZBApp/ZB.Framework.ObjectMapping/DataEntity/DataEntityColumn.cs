using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference=true)]
    public class DataEntityColumn
    {
        public DataEntityColumn()
        {
            DataType = typeof(string).ToString();
        }

        [DataMember]
        public string Column{ get; set; }

        [DataMember]
        public string DataType { get; set; }

        public Type GetDataType()
        {
            return Type.GetType(DataType);
        }
    }
}
