using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    public class ParameterCollection : ObservableCollection<Parameter>
    {
        public string GenerateParameter(object val)
        {
            string ret = string.Format("SmartPID_{0}", this.Count + 1);
            this.Add(new Parameter(ret, val));
            return ret;
        }
    }
}
