using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public class RecordCheckResult<T>
           where T : ObjectMappingBase<T, int>
    {
        private List<T> _CreateList = new List<T>();
        public List<T> CreateList
        {
            get { return _CreateList; }
            set { _CreateList = value; }
        }

        private List<T> _UpdateList = new List<T>();
        public List<T> UpdateList
        {
            get { return _UpdateList; }
            set { _UpdateList = value; }
        }

        private List<int> _DeleteIdList = new List<int>();
        public List<int> DeleteIdList
        {
            get { return _DeleteIdList; }
            set { _DeleteIdList = value; }
        }
    }
}
