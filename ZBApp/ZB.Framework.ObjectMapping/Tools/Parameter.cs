using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference=true)]
    public class Parameter
    {
        public Parameter()
        {
        }

        public Parameter(string name, object value)
        {
            this.Name = name;
            this.Value = value;
        }

        [DataMember]
        public string Name {get;set;}

        [DataMember]
        public object Value {get;set;}
    }
}
