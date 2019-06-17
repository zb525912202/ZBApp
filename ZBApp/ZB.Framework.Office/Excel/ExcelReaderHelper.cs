using System;
using System.Net;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.OleDb;

namespace ZB.Framework.Utility
{
    public class ExcelReaderHelper : IDisposable
    {
        public ExcelReaderHelper(string filePath)
        {
            DataSet ds = GetImportDataSet(filePath);
            DataTableData = ds.Tables[0];
            FillContent();
        }

        private DataTable DataTableData = null;
        private List<string> _Header;

        private int rowIndex = -1;
        public bool Reader()
        {
            rowIndex += 1;
            if (rowIndex >= RowCount) { return false; }
            return true;
        }

        public int RowCount { get; set; }

        public int ColumnCount { get; set; }

        public int Index
        {
            get
            {
                return rowIndex;
            }
        }

        public string GetValue(string columnName)
        {
            return DataTableData.Rows[rowIndex][columnName].ToString();
        }

        public bool ColumnsContains(string columnName)
        {
            if (string.IsNullOrEmpty(columnName))
            {
                throw new ArgumentException("列名不允许为空");
            }

            return _Header.Any(s => s.Equals(columnName));
        }

        private void FillContent()
        {
            RowCount = DataTableData.Rows.Count;
            ColumnCount = DataTableData.Columns.Count;
            _Header = new List<string>();
            for (int i = 0; i < ColumnCount; i++)
            {
                _Header.Add(DataTableData.Columns[i].ColumnName);
            }
        }

        private DataSet GetImportDataSet(string filePath)
        {
            string strConn = "Provider=Microsoft.ZB.OLEDB.4.0;" + "Data Source=" + filePath + ";" + "Extended Properties=Excel 8.0;";
            OleDbConnection conn = new OleDbConnection(strConn);
            conn.Open();
            string strExcel = "";
            OleDbDataAdapter myCommand = null;
            DataSet ds = null;
            strExcel = "select * from [sheet1$]";
            myCommand = new OleDbDataAdapter(strExcel, strConn);
            ds = new DataSet();
            myCommand.Fill(ds, "table1");
            conn.Close();
            return ds;
        }

        public void Dispose()
        {
            DataTableData = null;
        }
    }
}
