using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.AppShell.Addin
{
    [CodonName("Ifndef")]
    public class IfndefConditionCodon : AbstractConditionCodon
    {
        [XmlMemberArray("key")]
        public string[] Key { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            foreach (string k in Key)
            {
                if (!AddinService.Instance.Definitions.ContainsKey(k))
                    return true;
            }

            return false;
        }
    }
}
