using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [AttributeUsage(AttributeTargets.Property, Inherited = true)]
    public class XmlMemberCDATAAttribute : Attribute
    {
        public XmlMemberCDATAAttribute()
        {

        }

        public XmlMemberCDATAAttribute(bool isRequired)
        {
            this.IsRequired = isRequired;
        }

        public bool IsRequired {get;set;}
    }
}
