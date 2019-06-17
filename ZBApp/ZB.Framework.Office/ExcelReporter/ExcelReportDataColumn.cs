using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Linq.Expressions;
using NPOI.SS.UserModel;

namespace ZB.Framework.Utility
{
    public class ExcelReport_OnSetCellValueArgs<T> : EventArgs
    {
        public ExcelReportBuilder ReportBuilder { get; set; }

        public ExcelReportDataColumn<T> DataColumn { get; set; }

        public T DataItem { get; set; }

        public Cell Cell {get;set;}
    }

    public class ExcelReportDataColumn<T>
    {
        public string Header { get; set; }

        public string BindingProperty { get; internal set; }

        public PropertyInfo BindingPropertyInfo { get; internal set; }

        public CellStyle CellStyle {get;internal set;}

        public int RowIndex {get;set;}

        public int ColumnIndex {get;set;}

        public object Tag { get; set; }

        public ExcelReportDataColumn<T> SetTag(object tag)
        {
            this.Tag = tag;
            return this;
        }

        public ExcelReportDataColumn<T> SetBinding(string prop)
        {
            this.BindingProperty = prop;
            return this;
        }

        public ExcelReportDataColumn<T> SetBinding<TProperty>(Expression<Func<T, TProperty>> expression)
        {
            this.SetBinding(ExpressionHelper.GetMemberName(expression));
            return this;
        }

        public Action<ExcelReport_OnSetCellValueArgs<T>> OnSetCellValue { get; set; }

        internal void SetCellValue(ExcelReportBuilder builder, T item,Cell cell)
        {
            if (OnSetCellValue == null)
            {
                object cellval = BindingPropertyInfo.GetValue(item, null);
                if (cellval == null)
                    cellval = string.Empty;
                cell.SetCellValue(cellval.ToString());
            }
            else
                OnSetCellValue(new ExcelReport_OnSetCellValueArgs<T>()
                {
                    ReportBuilder = builder,
                    DataColumn = this,
                    DataItem = item,
                    Cell = cell,
                });
        }
    }
}
