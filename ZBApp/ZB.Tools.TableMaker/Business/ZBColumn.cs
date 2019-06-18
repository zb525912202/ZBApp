using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;

namespace ZB.Tools.TableMaker
{
    public class ZBColumn : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        public virtual void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }


        private string _ObjectName;
        public string ObjectName
        {
            get { return _ObjectName; }
            set
            {
                _ObjectName = value;
                this.RaisePropertyChanged("ObjectName");
            }
        }

        public string DataType { get; set; }
        public bool IsInPK { get; set; }
        public bool IsInFK { get; set; }
        public bool IsAutoIncreasement { get; set; }

        public bool IsAllowNull { get; set; }

        private bool _IsPropStyle;
        public bool IsPropStyle
        {
            get { return _IsPropStyle; }
            set
            {
                _IsPropStyle = value;
                this.RaisePropertyChanged("IsPropStyle");
            }
        }

        private bool _IsHideField;
        public bool IsHideField
        {
            get { return _IsHideField; }
            set
            {
                _IsHideField = value;
                this.RaisePropertyChanged("IsHideField");
            }
        }
    }
}
