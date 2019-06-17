using System;
using System.Net;
using System.Windows;

using ZB.AppShell.Addin;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [DataContract(IsReference = true)]
    public abstract class SmartDataSource
    {
        public SmartDataSource()
        {
            this.DataSourceItems = new List<DataSourceItem>();
            this.DataSourceItemsDict = new Dictionary<int, DataSourceItem>();
        }

        [DataMember]
        public string Name { get;set; }

        public void Clear()
        {
            this.DataSourceItemsDict.Clear();
            this.DataSourceItems.Clear();
        }

        public void Add(DataSourceItem item)
        {
            this.DataSourceItemsDict.Add(item.Id, item);
            this.DataSourceItems.Add(item);
        }

        public bool IsContain(int id)
        {
            return this.DataSourceItemsDict.ContainsKey(id);
        }

        public void Remove(int id)
        {
            if (IsContain(id))
            {
                var item = this.DataSourceItemsDict[id];
                this.DataSourceItemsDict.Remove(id);
                this.DataSourceItems.Remove(item);
            }
        }

        public List<DataSourceItem> DataSourceItems { get; set; }

        public Dictionary<int, DataSourceItem> DataSourceItemsDict { get; set; }
    }   
}
