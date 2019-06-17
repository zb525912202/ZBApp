using System;
using System.Net;
using System.Windows;

using ZB.AppShell.Addin;

namespace ZB.Framework.Business
{
    [CodonName("ExcelImportColumn")]
    public class ExcelImportColumnCodon : AbstractCodon
    {
        [XmlMemberAttribute("header", IsRequired = true)]
        public string ColumnHeader { get; set; }

        [XmlMemberAttribute("type", IsRequired = false)]
        public string DataType { get; set; }

        [XmlMemberAttribute("customertype")]
        public string CustomerDataType { get; set; }

        [XmlMemberAttribute("excelrequired")]
        public string CustomerRequired { get; set; }


        [XmlMemberAttribute("datasource")]
        public string DataSourceAddinPath { get; set; }

        [XmlMemberAttribute("property")]
        public string BindingPropertyName { get; set; }

        [XmlMemberAttribute("required")]
        public string IsRequired { get; set; }

        [XmlMemberAttribute("pk")]
        public string IsPrimaryKey { get; set; }

        [XmlMemberAttribute("width")]
        public string Width { get; set; }

        [XmlMemberAttribute("min")]
        public string Min { get; set; }

        [XmlMemberAttribute("max")]
        public string Max { get; set; }

        [XmlMemberAttribute("regex")]
        public string Regex { get; set; }

        [XmlMemberAttribute("regex-errormessage")]
        public string RegexErrorMessage { get; set; }

        [XmlMemberAttribute("mappingkey")]
        public string MappingKey { get; set; }

        [XmlMemberAttribute("showtooltip")]
        public string ShowToolTip { get; set; }

        [XmlMemberAttribute("showsingleline")]
        public string ShowSingleLine { get; set; }

        [XmlMemberAttribute("defaultvalue")]
        public string DefaultValue { get; set; }

        public override object BuildItem(object caller, object _parent)
        {
            ExcelImportColumn column = new ExcelImportColumn();
            column.BindingPropertyName = this.ID;
            column.ColumnHeader = this.ColumnHeader;
            column.DataTypeName = this.DataType;

            if (string.IsNullOrWhiteSpace(this.CustomerDataType))
            {
                if (this.DataType == "int")
                    column.DataType = typeof(int);
                else if (this.DataType == "string")
                    column.DataType = typeof(string);
                else if (this.DataType == "bool")
                    column.DataType = typeof(bool);
                else if (this.DataType == "datetime" || this.DataType == "date")
                    column.DataType = typeof(DateTime);
                else if (this.DataType == "decimal")
                    column.DataType = typeof(decimal);
                else
                    throw new AddinException("未知的值 ExcelImportColumn.DataType");
            }
            else
            {
                column.CustomerDataType = this.CustomerDataType;
            }


            if (!string.IsNullOrWhiteSpace(this.DefaultValue))
                column.DefaultValue = this.DefaultValue;

            if (!string.IsNullOrWhiteSpace(this.CustomerRequired))
                column.CustomerRequired = bool.Parse(this.CustomerRequired);

            if (!string.IsNullOrWhiteSpace(this.DataSourceAddinPath))
                column.DataSource = AddinService.Instance.GetAddinTreeNode(this.DataSourceAddinPath).BuildItem() as SmartDataSource;

            if (!string.IsNullOrWhiteSpace(this.IsPrimaryKey))
                column.IsPrimaryKey = bool.Parse(this.IsPrimaryKey);

            if (!string.IsNullOrWhiteSpace(this.Width))
                column.Width = int.Parse(this.Width);

            column.MappingKey = this.MappingKey;


            if (!string.IsNullOrWhiteSpace(this.IsRequired) && bool.Parse(this.IsRequired))
                column.ValidateItems.Add(new ExcelImportValidateRequired());

            if (!string.IsNullOrWhiteSpace(this.ShowToolTip) && bool.Parse(this.ShowToolTip))
                column.ShowToolTip = true;
            if (!string.IsNullOrWhiteSpace(this.ShowSingleLine) && bool.Parse(this.ShowSingleLine))
                column.ShowSingleLine = true;

            column.ValidateItems.Add(new ExcelImportValidateFormat());

            if (!string.IsNullOrWhiteSpace(this.Min) || !string.IsNullOrWhiteSpace(this.Max))
            {
                ExcelImportValidateRange validateitem = new ExcelImportValidateRange();
                if (column.DataType == typeof(int))
                {
                    if (!string.IsNullOrWhiteSpace(this.Min))
                        validateitem.Min_Int = int.Parse(this.Min);
                    if (!string.IsNullOrWhiteSpace(this.Max))
                        validateitem.Max_Int = int.Parse(this.Max);
                }
                else if (column.DataType == typeof(string))
                {
                    if (!string.IsNullOrWhiteSpace(this.Min))
                        validateitem.Min_String = int.Parse(this.Min);
                    if (!string.IsNullOrWhiteSpace(this.Max))
                        validateitem.Max_String = int.Parse(this.Max);
                }
                else if (column.DataType == typeof(decimal))
                {
                    if (!string.IsNullOrWhiteSpace(this.Min))
                        validateitem.Min_Decimal = decimal.Parse(this.Min);
                    if (!string.IsNullOrWhiteSpace(this.Max))
                        validateitem.Max_Decimal = decimal.Parse(this.Max);
                }
                column.ValidateItems.Add(validateitem);
            }

            if (column.DataType == typeof(DateTime))
            {
                ExcelImportValidateRange validateitem = new ExcelImportValidateRange();

                if (!string.IsNullOrWhiteSpace(this.Min))
                    validateitem.Min_DateTime = DateTime.Parse(this.Min);
                if (!string.IsNullOrWhiteSpace(this.Max))
                    validateitem.Max_DateTime = DateTime.Parse(this.Max);

                column.ValidateItems.Add(validateitem);
            }

            if (!string.IsNullOrEmpty(this.Regex))
            {
                ExcelImportValidateRegex validateitem = new ExcelImportValidateRegex();
                validateitem.Pattern = this.Regex;
                if (!string.IsNullOrEmpty(this.RegexErrorMessage))
                    validateitem.ErrorMessage = this.RegexErrorMessage;

                column.ValidateItems.Add(validateitem);
            }



            ExcelImport parent = _parent as ExcelImport;
            parent.AddColumn(column);

            return column;
        }
    }
}
