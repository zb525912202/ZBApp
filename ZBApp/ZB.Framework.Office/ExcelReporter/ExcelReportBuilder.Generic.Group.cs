using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using NPOI.HSSF.UserModel;
using System.IO;
using NPOI.SS.UserModel;
using System.Diagnostics;
using System.Collections;
using NPOI.SS.Util;
using System.Drawing;

namespace ZB.Framework.Utility
{
    public partial class ExcelReportBuilder<T>
    {
        private List<ExcelReportGroupData<T>> CurrentGroupDataList;
        private HashSet<ExcelReportGroupData<T>> CurrentMakedGroupList;

        private int CurrentCreateRowIndex;
        private CellStyle VerticalGroupCellStyle;
        private CellStyle HorizontalGroupCellStyle;

        /// <summary>
        /// 估算模式
        /// </summary>
        private bool IsVirtualComputeMode;

        #region GetHorizontalGroupColSpanOffset
        private int GetHorizontalGroupColSpanOffset(ExcelReportGroupSection<T> group)
        {
            int ret = 0;
            for (int i = this.Groups.IndexOf(group) + 1; i < this.Groups.Count; i++)
            {
                if (this.Groups[i].GroupMode == ExcelReportGroupMode.Vertical)
                    ret++;
            }
            return ret;
        }
        #endregion

        #region GetVerticalGroupColSpanOffset
        private int GetVerticalGroupColSpanOffset(ExcelReportGroupSection<T> group)
        {
            int ret = 0;
            for (int i = this.Groups.IndexOf(group); i < this.Groups.Count; i++)
            {
                if (this.Groups[i].GroupMode == ExcelReportGroupMode.Vertical)
                    ret++;
            }
            return ret;
        }
        #endregion

        private void FillBodyData_Group(ExcelReportGroupDataCollection<T> datalist)
        {
            if (datalist == null)
            {
                datalist = new ExcelReportGroupDataCollection<T>();
                this.Build_DataGroupList(datalist, 0, this.DataSource);
            }

            //估算模式
            //---------------------------------------------------------------------------------------------------------------------
            this.IsVirtualComputeMode = true;
            this.CurrentCreateRowIndex = this.FirstRowIndex;
            this.CurrentGroupDataList = new List<ExcelReportGroupData<T>>();
            this.CurrentMakedGroupList = new HashSet<ExcelReportGroupData<T>>();
            foreach (var item in datalist)
            {
                this.FillBodyData_GroupItem(item);
            }

            int totalDataRowCount = this.CurrentCreateRowIndex - this.FirstRowIndex;
            this.ShiftFooter(totalDataRowCount);

            //最终生成模式
            this.IsVirtualComputeMode = false;
            this.CurrentCreateRowIndex = this.FirstRowIndex;
            this.CurrentGroupDataList = new List<ExcelReportGroupData<T>>();
            this.CurrentMakedGroupList = new HashSet<ExcelReportGroupData<T>>();
            foreach (var item in datalist)
            {
                this.FillBodyData_GroupItem(item);
            }
            //---------------------------------------------------------------------------------------------------------------------
        }

        private void FillBodyData_GroupDataItem_Helper(ExcelReportGroupData<T> groupitem, Row row,int rowIndex, T item, ref bool FlagContinue)
        {
            foreach (ExcelReportGroupData<T> groupdata in CurrentGroupDataList)
            {
                if (this.CurrentMakedGroupList.Contains(groupdata))
                    continue;

                this.CurrentMakedGroupList.Add(groupdata);

                if (groupdata.Group.GroupMode == ExcelReportGroupMode.Vertical)
                {
                    if(this.IsVirtualComputeMode)
                    {
                        int rowspan_offset = groupdata.GroupDataList.Count + groupdata.GetSubHorizontalGroupCount();
                        int colspan_offset = GetVerticalGroupColSpanOffset(groupdata.Group);
                        groupdata.StartRowIndex = rowIndex;
                        groupdata.StartColumnIndex = groupdata.EndColumnIndex = FirstColIndex - colspan_offset;
                        groupdata.EndRowIndex = rowIndex + rowspan_offset - 1;
                    }
                    else
                    {
                        Cell cell = row.CreateCell(groupdata.StartColumnIndex);
                        cell.SetCellValue(groupdata.GroupTitle);
                        Sheet.AddMergedRegion(new CellRangeAddress(groupdata.StartRowIndex, groupdata.EndRowIndex, groupdata.StartColumnIndex , groupdata.EndColumnIndex));
                        for (int rr = groupdata.StartRowIndex; rr <= groupdata.EndRowIndex; rr++)
                        {
                            Row temprow = Sheet.GetRow(rr) ?? Sheet.CreateRow(rr);
                            (temprow.GetCell(cell.ColumnIndex) ?? temprow.CreateCell(cell.ColumnIndex)).CellStyle = this.VerticalGroupCellStyle;
                        }
                    }
                }
                else if (groupdata.Group.GroupMode == ExcelReportGroupMode.Horizontal)
                {
                    if(this.IsVirtualComputeMode)
                    {
                        int colspan_offset = GetHorizontalGroupColSpanOffset(groupdata.Group);
                        int col_index = FirstColIndex - colspan_offset;
                        groupdata.StartRowIndex = groupdata.EndRowIndex = rowIndex;
                        groupdata.StartColumnIndex = col_index;
                        groupdata.EndColumnIndex = col_index + colspan_offset + this.Columns.Count - 1;
                    }
                    else
                    {
                        Cell cell = row.GetCell(groupdata.StartColumnIndex) ?? row.CreateCell(groupdata.StartColumnIndex);
                        cell.SetCellValue(groupdata.GroupTitle);
                        Sheet.AddMergedRegion(new CellRangeAddress(groupdata.StartRowIndex, groupdata.EndRowIndex, groupdata.StartColumnIndex, groupdata.EndColumnIndex));
                        for (int cc = groupdata.StartColumnIndex; cc <= groupdata.EndColumnIndex; cc++)
                            (row.GetCell(cc) ?? row.CreateCell(cc)).CellStyle = this.HorizontalGroupCellStyle;
                    }

                    //------------------------------------------------------------------------------------------------------
                    FlagContinue = true;
                    break;
                }
            }
        }

        private void FillBodyData_LeafGroupItem_Helper(ExcelReportGroupData<T> groupitem)
        {
            for (int r = 0; r < groupitem.GroupDataList.Count; r++)
            {
                T item = groupitem.GroupDataList[r];

                int rowindex = this.CurrentCreateRowIndex++;

                Row row = this.IsVirtualComputeMode ? null : (Sheet.GetRow(rowindex) ?? Sheet.CreateRow(rowindex));
                if(row != null)
                {
                    row.Height = FirstRowHeight;
                    row.RowStyle = FirstRowStyle;
                }

                bool FlagContinue = false;
                this.FillBodyData_GroupDataItem_Helper(groupitem, row,rowindex,item, ref FlagContinue);
                if (FlagContinue)
                {
                    r--;
                    continue;
                }

                if(this.IsVirtualComputeMode == false)
                {
                    //生成主体数据--------------------------------------------------------------------------------------------------
                    foreach (var c in this.Columns_Sorted)
                    {
                        ExcelReportDataColumn<T> column = c.Value;
                        Cell cell = row.GetCell(column.ColumnIndex) ?? row.CreateCell(column.ColumnIndex);
                        cell.CellStyle = column.CellStyle;
                        column.SetCellValue(this, item, cell);
                    }
                }
            }
        }

        private void FillBodyData_GroupItem(ExcelReportGroupData<T> groupitem)
        {
            CurrentGroupDataList.Add(groupitem);
            //-----------------------------------------------------------------------------------------------------
            if (groupitem.IsLeafGroup)
            {
                this.FillBodyData_LeafGroupItem_Helper(groupitem);
                CurrentGroupDataList.RemoveAt(CurrentGroupDataList.Count - 1);
            }
            else
            {
                foreach (var subitem in groupitem.SubGroupDataList)
                {
                    this.FillBodyData_GroupItem(subitem);
                }
            }
        }

        #region Build_DataGroupList
        private void Build_DataGroupList(ExcelReportGroupDataCollection<T> parent, int groupindex, IList<T> datalist)
        {
            ExcelReportGroupSection<T> groupitem = this.Groups[groupindex];
            IEnumerable ret = ReflectionHelper.GroupBy(typeof(T), groupitem.GroupKeyType, datalist, groupitem.GroupKeySelector);
            var T_IGrouping = typeof(IGrouping<,>).MakeGenericType(groupitem.GroupKeyType, typeof(T));
            foreach (var gitem in ret)
            {
                object key = T_IGrouping.GetProperty("Key").GetValue(gitem, null);
                List<T> datas = (gitem as IEnumerable).ToBaseList<T>();
                string grouptitle = (groupitem.OnGetGroupText == null) ? key.ToString() : groupitem.OnGetGroupText(key);
                parent.Add(groupitem, grouptitle, datas);
            }
            groupindex++;
            if (groupindex < this.Groups.Count)
            {
                foreach (var subitem in parent)
                {
                    this.Build_DataGroupList(subitem.SubGroupDataList, groupindex, subitem.GroupDataList);
                }
            }
        }
        #endregion
    }
}
