using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    [CodonName("Class")]
    public class ClassCodon : AbstractCodon
    {
        public override object BuildItem(object caller,object parent)
        {
            return AddinService.Instance.CreateClassInstance(this.Class, this.EventKey);
        }
    }
}
