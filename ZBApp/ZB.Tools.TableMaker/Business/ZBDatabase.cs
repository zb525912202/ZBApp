using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;

namespace ZB.Tools.TableMaker
{
    public class ZBDatabase : INotifyPropertyChanged
    {
        public override string ToString()
        {
            return ObjectName;
        }


        public string ObjectName { get; set; }
        public List<ZBTableKey> KeyList { get; set; }

        public ZBDatabase()
        {
            this.TableList = new ObservableCollection<ZBTable>();
        }

        public event PropertyChangedEventHandler PropertyChanged;
        public virtual void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        private ObservableCollection<ZBTable> _TableList;

        public ObservableCollection<ZBTable> TableList
        {
            get { return (_TableList ?? new ObservableCollection<ZBTable>()); }
            set
            {
                if (!object.Equals(_TableList, value))
                {
                    _TableList = value;
                    this.RaisePropertyChanged("TableList");
                }
            }
        }
    }
}
