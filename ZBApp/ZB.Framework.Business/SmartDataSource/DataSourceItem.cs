using System;
using System.Net;
using System.Windows;

using ZB.AppShell.Addin;
using System.Collections.Generic;
using ZB.Framework.Utility;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [CodonName("DataSourceItem")]
    public class DataSourceItemCodon : AbstractCodon
    {
        [XmlMemberAttribute("text", IsRequired = true)]
        public string Text { get; set; }

        [XmlMemberAttribute("data-role")]
        public string DataRole { get; set; }

        [XmlMemberAttribute("checked")]
        public string Checked { get; set; }

        public override object BuildItem(object caller, object _parent)
        {
            DataSourceItem item = new DataSourceItem();
            item.Id = int.Parse(this.ID);
            item.Text = this.Text;

            if (!string.IsNullOrWhiteSpace(this.DataRole))
                item.DataRole = (EDataRole)Enum.Parse(typeof(EDataRole), this.DataRole, true);
            if (!string.IsNullOrWhiteSpace(this.Checked))
                item.IsChecked = bool.Parse(this.Checked);

            if (_parent is SmartDataSource)
            {
                SmartDataSource parent = _parent as SmartDataSource;
                parent.Add(item);
            }
            else if (_parent is DataSourceItem)
            {
                DataSourceItem parent = _parent as DataSourceItem;
                parent.Add(item);
            }

            return item;
        }
    }


    public enum EDataRole
    {
        Normal = 0,
        Ignore
    }

    [DataContract(IsReference = true)]
    public partial class DataSourceItem : NotifyBase
    {
        public DataSourceItem()
        {
            this.DataRole = EDataRole.Normal;
        }

        public DataSourceItem(int id, string text)
            : this()
        {
            this.Id = id;
            this.Text = text;
        }

        [DataMember]
        public int Id { get; set; }

        [DataMember]
        public int ParentId { get; set; }

        [DataMember]
        public string FullPath { get; set; }

        [DataMember]
        public string Text { get; set; }

        [DataMember]
        public string GroupName { get; set; }

        private bool? _IsChecked = false;
        [DataMember]
        public bool? IsChecked
        {
            get { return _IsChecked; }
            set
            {
                if (_IsChecked != value)
                {
                    _IsChecked = value;
                    this.RaisePropertyChanged("IsChecked");
                }
            }
        }

        private bool _IsThreeState = false;
        [DataMember]
        public bool IsThreeState
        {
            get { return _IsThreeState; }
            set
            {
                if (_IsThreeState != value)
                {
                    _IsThreeState = value;
                    this.RaisePropertyChanged("IsThreeState");
                }
            }
        }

        [DataMember]
        public EDataRole DataRole { get; set; }

        public void Add(DataSourceItem item)
        {
            this.DataSourceItemsDict.Add(item.Id, item);
            this.DataSourceItems.Add(item);
        }

        private List<DataSourceItem> _DataSourceItems;
        [DataMember]
        public List<DataSourceItem> DataSourceItems
        {
            get { return _DataSourceItems ?? (_DataSourceItems = new List<DataSourceItem>()); }
        }

        private Dictionary<int, DataSourceItem> _DataSourceItemsDict = null;
        [DataMember]
        public Dictionary<int, DataSourceItem> DataSourceItemsDict
        {
            get { return _DataSourceItemsDict ?? (_DataSourceItemsDict = new Dictionary<int, DataSourceItem>()); }
        }
    }
}
