using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [CodonName("Define")]
    public class DefineCodon : AbstractCodon
    {
        public DefineCodon()
        {
            this.Value = "0";
        }

        [XmlMemberAttribute("key")]
        public string Key { get; set; }

        [XmlMemberAttribute("value")]
        public string Value { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            int val = 0;
            int.TryParse(this.Value, out val);
            AddinService.Instance.Definitions[this.Key] = val;
            return null;
        }
    }
}
