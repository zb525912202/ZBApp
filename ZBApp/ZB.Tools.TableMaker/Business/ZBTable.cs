using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;

namespace ZB.Tools.TableMaker
{
    public class ZBTable : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public virtual void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public ZBTable()
        {
            ColumnList = new ObservableCollection<ZBColumn>();
        }

        public string ObjectName { get; set; }

        private ObservableCollection<ZBColumn> _ColumnList;
        public ObservableCollection<ZBColumn> ColumnList
        {
            get { return (_ColumnList ?? new ObservableCollection<ZBColumn>()); }
            set
            {
                if (!object.Equals(_ColumnList, value))
                {
                    _ColumnList = value;
                    this.RaisePropertyChanged("ColumnList");
                }
            }
        }


        private bool _IsInclude;
        public bool IsInclude
        {
            get { return _IsInclude; }
            set
            {
                _IsInclude = value;
                this.RaisePropertyChanged("IsInclude");
            }
        }
    }
}
