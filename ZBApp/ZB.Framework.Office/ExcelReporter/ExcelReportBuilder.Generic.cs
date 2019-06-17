using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using NPOI.HSSF.UserModel;
using System.IO;
using NPOI.SS.UserModel;
using System.Diagnostics;
using System.Text.RegularExpressions;

namespace ZB.Framework.Utility
{
    public partial class ExcelReportBuilder<T> : ExcelReportBuilder
    {
        public event Action BeforeFillDatas;

        public ExcelReportBuilder()
        {
            this.PropertyInfoDict = new Dictionary<string, PropertyInfo>();
            this.Columns = new Dictionary<string, ExcelReportDataColumn<T>>();
            this.Groups = new List<ExcelReportGroupSection<T>>();
            this.GroupsDict = new Dictionary<string, ExcelReportGroupSection<T>>();
        }

        public ExcelReportGroupDataCollection<T> GroupDataSource { get; set; }

        private Dictionary<string, PropertyInfo> PropertyInfoDict;
        private Dictionary<string, ExcelReportDataColumn<T>> Columns;
        private Dictionary<string, ExcelReportDataColumn<T>> Columns_Sorted;

        public List<ExcelReportGroupSection<T>> Groups;
        private Dictionary<string, ExcelReportGroupSection<T>> GroupsDict;

        public IList<T> DataSource { get; set; }

        public HSSFWorkbook Workbook { get; private set; }
        private Sheet Sheet { get; set; }
        private List<Tuple<string, Cell>> TemplateGlobalDatas { get; set; }

        internal int FirstRowIndex;
        internal short FirstRowHeight;
        internal CellStyle FirstRowStyle;
        internal int FirstColIndex;

        /// <summary>
        /// Excel有最大字体数限制，应在填充数据前，先把字体创建出来
        /// </summary>
        public CellStyle CreateCellStyle(Action<Font> setCellFontAction)
        {
            var newCellStyle = this.Workbook.CreateCellStyle();

            newCellStyle.BorderTop = newCellStyle.BorderBottom = newCellStyle.BorderLeft = newCellStyle.BorderRight = CellBorderType.THIN;
            newCellStyle.FillBackgroundColor = newCellStyle.FillForegroundColor = 64;
            newCellStyle.FillPattern = FillPatternType.NO_FILL;
            newCellStyle.LeftBorderColor = newCellStyle.RightBorderColor = newCellStyle.TopBorderColor = newCellStyle.BottomBorderColor = 64;
            newCellStyle.VerticalAlignment = VerticalAlignment.CENTER;

            Font oldFont = this.FirstRowStyle.GetFont(this.Workbook);
            Font newFont = this.Workbook.CreateFont();
            newFont.Boldweight = oldFont.Boldweight;
            newFont.Charset = oldFont.Charset;
            newFont.Color = oldFont.Color;
            newFont.FontHeight = oldFont.FontHeight;
            newFont.FontHeightInPoints = oldFont.FontHeightInPoints;
            newFont.FontName = oldFont.FontName;
            newFont.IsItalic = oldFont.IsItalic;
            newFont.TypeOffset = oldFont.TypeOffset;
            newFont.Underline = oldFont.Underline;

            setCellFontAction(newFont);

            newCellStyle.SetFont(newFont);
            return newCellStyle;
        }      

        #region GetPropertyInfo
        public PropertyInfo GetPropertyInfo(string name)
        {
            PropertyInfo prop = null;
            if (PropertyInfoDict.ContainsKey(name))
                prop = PropertyInfoDict[name];
            else
            {
                prop = typeof(T).GetProperty(name);
                if (prop == null)
                    throw new ArgumentException(string.Format("HtmlReportBuilder.GetPropertyInfo not find property \"{0}\"", name));
                PropertyInfoDict[name] = prop;
            }

            return prop;
        }
        #endregion

        #region GetColumn
        public ExcelReportDataColumn<T> GetColumn(string header)
        {
            if (Columns.ContainsKey(header))
                return Columns[header];
            else
                return null;
        }
        #endregion

        #region AddColumn
        public ExcelReportDataColumn<T> AddColumn(string header)
        {
            ExcelReportDataColumn<T> datacolumn = new ExcelReportDataColumn<T>();
            datacolumn.Header = header;
            Columns.Add(header, datacolumn);
            return datacolumn;
        }
        #endregion

        #region AddGroup
        public ExcelReportGroupSection<T> AddGroup(string groupname, ExcelReportGroupMode mode)
        {
            ExcelReportGroupSection<T> group = new ExcelReportGroupSection<T>();
            group.GroupName = groupname;
            group.GroupMode = mode;
            this.Groups.Add(group);
            this.GroupsDict.Add(group.GroupName, group);
            return group;
        }
        #endregion

        public override void Export(Stream output)
        {
            foreach (var col in Columns)
            {
                ExcelReportDataColumn<T> datacolumn = col.Value;
                if (string.IsNullOrEmpty(datacolumn.BindingProperty) == false)
                    datacolumn.BindingPropertyInfo = GetPropertyInfo(datacolumn.BindingProperty);
            }
            //----------------------------------------------------------------------------------------------------------
            using (Stream s = File.OpenRead(this.TemplatePath))
            {
                using (Workbook = new HSSFWorkbook(s))
                {
                    this.VerticalGroupCellStyle = Workbook.CreateCellStyle();
                    this.VerticalGroupCellStyle.FillForegroundColor = IndexedColors.LIGHT_BLUE.Index;
                    this.VerticalGroupCellStyle.FillPattern = FillPatternType.SOLID_FOREGROUND;
                    this.VerticalGroupCellStyle.BorderBottom = CellBorderType.THIN;
                    this.VerticalGroupCellStyle.BorderLeft = CellBorderType.THIN;
                    this.VerticalGroupCellStyle.BorderTop = CellBorderType.THIN;
                    this.VerticalGroupCellStyle.BorderRight = CellBorderType.THIN;
                    this.VerticalGroupCellStyle.VerticalAlignment = VerticalAlignment.CENTER;


                    this.HorizontalGroupCellStyle = Workbook.CreateCellStyle();
                    this.HorizontalGroupCellStyle.FillForegroundColor = IndexedColors.LIGHT_ORANGE.Index;
                    this.HorizontalGroupCellStyle.FillPattern = FillPatternType.SOLID_FOREGROUND;
                    this.HorizontalGroupCellStyle.BorderBottom = CellBorderType.THIN;
                    this.HorizontalGroupCellStyle.BorderLeft = CellBorderType.THIN;
                    this.HorizontalGroupCellStyle.BorderTop = CellBorderType.THIN;
                    this.HorizontalGroupCellStyle.BorderRight = CellBorderType.THIN;
                    this.HorizontalGroupCellStyle.VerticalAlignment = VerticalAlignment.CENTER;

                    using (Sheet = Workbook.GetSheetAt(0))
                    {
                        this.TemplateGlobalDatas = new List<Tuple<string, Cell>>();
                        this.Columns_Sorted = new Dictionary<string, ExcelReportDataColumn<T>>();

                        this.ParserTemplate();

                        var FirstColumn = this.Columns.FirstOrDefault().Value;
                        FirstRowIndex = FirstColumn.RowIndex;
                        FirstColIndex = FirstColumn.ColumnIndex;

                        Row FirstRow = Sheet.GetRow(FirstRowIndex);
                        this.FirstRowHeight = FirstRow.Height;
                        this.FirstRowStyle = FirstRow.RowStyle;
                        if (this.FirstRowStyle == null)
                            this.FirstRowStyle = Workbook.CreateCellStyle();

                        if (this.BeforeFillDatas != null)
                            this.BeforeFillDatas();

                        this.FillGlobalDatas();

                        if (this.Groups.Count > 0)
                            this.FillBodyData_Group(this.GroupDataSource);
                        else
                            this.FillBodyData(this.DataSource);

                        Workbook.Write(output);
                    }
                }
            }
        }

        #region ParserTemplate
        private void ParserTemplate()
        {
            bool IsFindDataHeader = false;
            for (int r = 0; r <= Sheet.LastRowNum; r++)
            {
                Row row = Sheet.GetRow(r);
                if (row == null)
                    continue;
                for (int c = 0; c <= row.LastCellNum; c++)
                {
                    Cell cell = row.GetCell(c);
                    if (cell == null)
                        continue;

                    string cellval = cell.StringCellValue;
                    //Debug.WriteLine("[{0}][{1}]{2}", r, c, cellval);

                    if ((cellval.Length > 2) && (cellval.IndexOf("{") != -1) && (cellval.IndexOf("}") != -1))                      //全局字段
                        this.TemplateGlobalDatas.Add(new Tuple<string, Cell>(cellval, cell));
                    else if ((cellval.Length > 2) && cellval.StartsWith("[") && cellval.EndsWith("]"))              //列头
                    {
                        if (IsFindDataHeader)
                            continue;

                        IsFindDataHeader = true;

                        for (int c1 = c; c1 <= row.LastCellNum; c1++)
                        {
                            cell = row.GetCell(c1);
                            if (cell == null)
                                break;
                            cellval = cell.StringCellValue;
                            if (!((cellval.Length > 2) && cellval.StartsWith("[") && cellval.EndsWith("]")))
                                break;

                            string colkey = cellval.Substring(1, cellval.Length - 2);

                            ExcelReportDataColumn<T> column = this.GetColumn(colkey);
                            if (column == null)
                                throw new ApplicationException(string.Format("没有找到报表列\"{0}\"", colkey));

                            column.RowIndex = r;
                            column.ColumnIndex = c1;
                            column.CellStyle = cell.CellStyle;

                            cell.SetCellValue("");
                            if (cell.CellStyle != null)
                                cell.CellStyle = Workbook.CreateCellStyle();

                            Columns_Sorted.Add(colkey, column);
                        }
                    }
                }
            }
        }
        #endregion

        private void FillGlobalDatas()
        {
            foreach (var g in this.TemplateGlobalDatas)
            {
                string data = g.Item1;
                foreach (var entry in this.GlobalDatas)
                {
                    data = data.Replace(string.Format("{{{0}}}", entry.Key), entry.Value);
                }
                g.Item2.SetCellValue(data);
            }
        }

        private void ShiftFooter(int DataRowCount)
        {
            if (Sheet.LastRowNum == FirstRowIndex)
                return;

            if (DataRowCount == 0)
                return;

            int startrow = FirstRowIndex + 1;
            int endrow = Sheet.LastRowNum;
            int distance = DataRowCount - 1;
            Sheet.ShiftRows(startrow, endrow, distance);

            for (int b = startrow; b <= endrow; b++)
            {
                Row src_row = Sheet.GetRow(b);
                if (src_row == null)
                    continue;

                Row dst_row = Sheet.GetRow(b + distance);

                if (src_row.RowStyle != null)
                    dst_row.RowStyle = src_row.RowStyle;
                dst_row.Height = src_row.Height;
            }
        }

        private void FillBodyData(IList<T> datalist)
        {
            int CurrentSheetRow = FirstRowIndex;

            if (datalist == null) { return; }

            this.ShiftFooter(datalist.Count);

            for (int r = 0; r < datalist.Count; r++)
            {
                T item = datalist[r];

                Row row = Sheet.CreateRow(CurrentSheetRow++);
                row.Height = FirstRowHeight;
                row.RowStyle = FirstRowStyle;

                foreach (var c in this.Columns)
                {
                    ExcelReportDataColumn<T> column = c.Value;
                    Cell cell = row.CreateCell(column.ColumnIndex);
                    cell.CellStyle = column.CellStyle;
                    column.SetCellValue(this, item, cell);
                }
            }
        }
    }
}
