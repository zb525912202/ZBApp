using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.AppShell.Addin;
using ZB.Framework.Utility;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [CodonName("EnumDataSource")]
    public class EnumDataSourceCodon : AbstractCodon
    {
        public override object BuildItem(object caller, object parent)
        {
            EnumDataSource ds = new EnumDataSource();
            ds.EnumType = AddinService.Instance.CreateClassType(this.Class);
            return ds;
        }
    }

    [DataContract(IsReference = true)]
    public class EnumDataSource : SmartDataSource, IAddinRuntime_ChildNodesBuilded
    {
        public Type EnumType { get; set; }

        public void Load()
        {
            List<string> texts = EnumType.GetTexts();
            List<int> values = EnumType.GetValues();

            for (int i = 0; i < texts.Count; i++)
            {
                DataSourceItem item = new DataSourceItem()
                {
                    Id = values[i],
                    Text = texts[i]
                };

                this.DataSourceItems.Add(item);
                this.DataSourceItemsDict.Add(item.Id, item);
            }
        }

        bool IAddinRuntime_ChildNodesBuilded.AddinRuntime_ChildNodesBuilded()
        {
            this.Load();
            return true;
        }
    }
}
