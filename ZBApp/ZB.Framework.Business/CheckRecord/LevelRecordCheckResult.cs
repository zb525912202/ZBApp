using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public class LevelRecordCheckResult<T>
           where T : ObjectMappingBase<T, int>
    {
        public LevelRecordCheckResult(List<T> treeList)
        {
            this.TreeList = treeList;
        }

        public List<T> TreeList { get; private set; }

        private List<T> _CreateList = new List<T>();
        public List<T> CreateList
        {
            get { return _CreateList; }
            set { _CreateList = value; }
        }

        private List<int> _DeleteIdList = new List<int>();
        public List<int> DeleteIdList
        {
            get { return _DeleteIdList; }
            set { _DeleteIdList = value; }
        }
    }
}
