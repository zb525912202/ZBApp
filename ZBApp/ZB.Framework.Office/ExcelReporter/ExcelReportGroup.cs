using System;
using System.Linq;
using System.Collections.Generic;

namespace ZB.Framework.Utility
{
    public enum ExcelReportGroupMode
    {
        Vertical,
        Horizontal
    }

    public class ExcelReportGroupSection<T>
    {
        public string GroupName { get; set; }

        public ExcelReportGroupMode GroupMode { get; set; }

        public object GroupKeySelector { get; set; }

        public Type GroupKeyType {get;set;}

        public Func<object,string> OnGetGroupText {get;set;}

        public ExcelReportGroupSection<T> GroupBy<TKey>(Func<T, TKey> keyselector)
        {
            this.GroupKeySelector = keyselector;
            this.GroupKeyType = typeof(TKey);
            return this;
        }
    }

    public class ExcelReportGroupDataCollection<T> : List<ExcelReportGroupData<T>>
    {
        public ExcelReportGroupData<T> Add(ExcelReportGroupSection<T> group, string title, IList<T> datas)
        {
            ExcelReportGroupData<T> groupdata = new ExcelReportGroupData<T>(group, title, datas);
            return this.Add(groupdata);
        }

        public new ExcelReportGroupData<T> Add(ExcelReportGroupData<T> item)
        {
            base.Add(item);
            return item;
        }
    }

    public class ExcelReportGroupData<T>
    {
        public ExcelReportGroupData(ExcelReportGroupSection<T> group, string title, IList<T> datas)
        {
            this.SubGroupDataList = new ExcelReportGroupDataCollection<T>();
            this.Group = group;
            this.GroupTitle = title;
            this.GroupDataList = datas;
        }

        public ExcelReportGroupSection<T> Group { get; set; }

        public IList<T> GroupDataList { get; set; }

        public string GroupTitle { get; set; }

        public ExcelReportGroupDataCollection<T> SubGroupDataList { get; set; }

        internal int StartRowIndex;
        internal int StartColumnIndex;
        internal int EndRowIndex;
        internal int EndColumnIndex;

        /// <summary>
        /// 最末级分组
        /// </summary>
        public bool IsLeafGroup { get { return this.SubGroupDataList.Count == 0; } }

        public int GetSubHorizontalGroupCount()
        {
            return GetSubHorizontalGroupCount_Helper(SubGroupDataList);
        }

        private int GetSubHorizontalGroupCount_Helper(ExcelReportGroupDataCollection<T> data)
        {
            int cnt = data.Count(o => o.Group.GroupMode == ExcelReportGroupMode.Horizontal);
            foreach (var item in data)
            {
                cnt += this.GetSubHorizontalGroupCount_Helper(item.SubGroupDataList);
            }
            return cnt;
        }
    }
}
