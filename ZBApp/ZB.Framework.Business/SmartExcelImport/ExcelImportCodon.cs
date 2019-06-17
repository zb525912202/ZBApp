using System;
using System.Net;
using System.Windows;

using ZB.AppShell.Addin;

namespace ZB.Framework.Business
{
    [CodonName("ExcelImport")]
    public class ExcelImportCodon : AbstractCodon
    {
        [XmlMemberAttribute("entityclass")]
        public string EntityClass { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            ExcelImport obj = new ExcelImport();
            obj.EntityType = AddinService.Instance.CreateClassType(this.EntityClass);
            obj.Name = this.ID;
            return obj;
        }
    }
}
