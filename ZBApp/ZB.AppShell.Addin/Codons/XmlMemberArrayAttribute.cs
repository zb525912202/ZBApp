using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [AttributeUsage(AttributeTargets.Property, Inherited = true)]
    public class XmlMemberArrayAttribute : Attribute
    {
        public XmlMemberArrayAttribute(string name)
        {
            this.Name = name;
            this.IsRequired = false;
        }

        public XmlMemberArrayAttribute(string name, bool isRequired)
        {
            this.Name = name;
            this.IsRequired = isRequired;
        }

        private char[] _Separator = new char[] {','};
        public char[] Separator
        {
            get { return _Separator; }
            set { _Separator = value; }
        }

        public string Name {get;set;}

        public bool IsRequired {get;set;}
    }
}
