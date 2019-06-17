using System;
using System.Net;
using System.Windows;

using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [DataContract(IsReference = true)]
    public class ExcelImport
    {
        public ExcelImport()
        {
            this.Columns = new List<ExcelImportColumn>();
            this.ColumnsDict = new Dictionary<string, ExcelImportColumn>();
            this.PkColumns = new List<ExcelImportColumn>();
        }

        /// <summary>
        /// 名称
        /// </summary>
        [DataMember]
        public string Name { get; set; }

        /// <summary>
        /// 需要导入的实体类型
        /// </summary>
        public Type EntityType { get; set; }

        [DataMember]
        public List<ExcelImportColumn> Columns { get; set; }

        [DataMember]
        public Dictionary<string, ExcelImportColumn> ColumnsDict { get; set; }

        [DataMember]
        public List<ExcelImportColumn> PkColumns { get; set; }

        public void AddColumn(ExcelImportColumn column)
        {
            this.Columns.Add(column);

            this.ColumnsDict.Add(column.ColumnHeader, column);

            if (column.IsPrimaryKey)
                this.PkColumns.Add(column);
        }
    }
}
