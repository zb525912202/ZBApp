using System;
using System.Net;
using System.Windows;

using ZB.AppShell.Addin;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [CodonName("SimpleDataSource")]
    public class SimpleDataSourceCodon : AbstractCodon
    {
        public override object BuildItem(object caller, object parent)
        {
            SimpleDataSource ds = new SimpleDataSource();
            ds.Name = this.ID;
            return ds;
        }
    }

    [DataContract(IsReference = true)]
    public class SimpleDataSource : SmartDataSource 
    { 
    }
}
