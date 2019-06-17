using System;
using System.Net;
using System.IO;
using System.Runtime.Serialization;
using System.Collections.Generic;

using ZB.Framework.Utility;

namespace ZB.AppShell.Addin
{
    public abstract class BaseTypeCodon<T> : AbstractCodon where T : IConvertible
    {
        [XmlMemberAttribute("value")]
        public string Value { get; set; }

        [XmlMemberCDATA]
        public string ValueEx { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            object obj = Convert.ChangeType(this.Value != null ? this.Value : this.ValueEx, typeof(T), null);

            if (parent is AppSettingGroup)
            {
#if SILVERLIGHT
                (parent as AppSettingGroup).ConfigDatas[this.ID] = SerializeHelper.ObjectToDataContractByte<T>((T)obj);
#else                
                (parent as AppSettingGroup).ConfigDatas[this.ID] = SerializeHelper.ObjectToByte(obj);
#endif
            }

            return obj;
        }
    }

    [CodonName("Int")]
    public class IntCodon : BaseTypeCodon<int> {  }

    [CodonName("Double")]
    public class DoubleCodon : BaseTypeCodon<double> { }

    [CodonName("Decimal")]
    public class DecimalCodon : BaseTypeCodon<decimal> { }

    [CodonName("Bool")]
    public class BoolCodon : BaseTypeCodon<bool> { }

    [CodonName("String")]
    public class StringCodon : BaseTypeCodon<string> { }

    [CodonName("DateTime")]
    public class DateTimeCodon : BaseTypeCodon<DateTime> { }
}
