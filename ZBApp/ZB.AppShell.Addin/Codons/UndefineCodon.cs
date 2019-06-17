using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [CodonName("Undefine")]
    public class UndefineCodon : AbstractCodon
    {
        [XmlMemberAttribute("key")]
        public string Key { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            if (AddinService.Instance.Definitions.ContainsKey(this.Key))
                AddinService.Instance.Definitions.Remove(this.Key);
            return null;
        }
    }
}
