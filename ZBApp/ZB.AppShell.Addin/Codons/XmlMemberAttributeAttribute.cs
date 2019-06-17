using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [AttributeUsage(AttributeTargets.Property, Inherited = true)]
    public class XmlMemberAttributeAttribute : Attribute
    {
        public XmlMemberAttributeAttribute(string name)
        {
            this.Name = name;
            this.IsRequired = false;
        }

        public XmlMemberAttributeAttribute(string name, bool isRequired)
        {
            this.Name = name;
            this.IsRequired = isRequired;
        }

        public string Name { get;set; }

        public bool IsRequired {get;set;}
    }
}
