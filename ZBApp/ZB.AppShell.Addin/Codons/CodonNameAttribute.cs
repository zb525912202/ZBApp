using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [AttributeUsage(AttributeTargets.Class, Inherited = false, AllowMultiple = false)]
    public class CodonNameAttribute : Attribute
    {
        public CodonNameAttribute(string name)
        {
            this.Name = name;
        }

        /// <summary>
        /// Returns the name of the codon.
        /// </summary>
        public string Name {get;set;}
    }
}
