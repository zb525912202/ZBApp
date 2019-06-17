using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public partial class DataSourceItem
    {
        private bool _IsVisibility;
        public bool IsVisibility
        {
            get { return _IsVisibility; }
            set
            {
                if (_IsVisibility != value)
                {
                    _IsVisibility = value;
                    this.RaisePropertyChanged("IsVisibility");
                }
            }
        }
    }
}
