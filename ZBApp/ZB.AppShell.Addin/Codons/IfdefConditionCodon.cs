using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [CodonName("Ifdef")]
    public class IfdefConditionCodon : AbstractConditionCodon
    {
        [XmlMemberArray("key")]
        public string[] Key { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            foreach(string k in Key)
            {
                if(AddinService.Instance.Definitions.ContainsKey(k))
                    return true;
            }

            return false;
        }
    }
}
