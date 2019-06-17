using System;
using System.Net;
using System.Windows;

using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Collections.ObjectModel;

namespace ZB.Framework.Business
{
    [DataContract(IsReference = true)]
    [KnownType(typeof(EnumDataSource))]
    [KnownType(typeof(DbDataSource))]
    [KnownType(typeof(SimpleDataSource))]
    [KnownType(typeof(ExcelImportValidateRequired))]
    [KnownType(typeof(ExcelImportValidateFormat))]
    [KnownType(typeof(ExcelImportValidateRange))]
    [KnownType(typeof(ExcelImportValidateRegex))]
    [KnownType(typeof(SponsorDeptValidate))]
    public class ExcelImportColumn
    {
        public ExcelImportColumn()
        {
            this.MappingDatas = new Dictionary<string, string>();
        }

        [DataMember]
        public string DefaultValue { get; set; }

        /// <summary>
        /// 绑定的属性名
        /// </summary>
        [DataMember]
        public string BindingPropertyName { get; set; }

        /// <summary>
        /// 界面显示列头
        /// </summary>
        [DataMember]
        public string ColumnHeader { get; set; }

        /// <summary>
        /// 数据类型
        /// </summary>
        public Type DataType { get; set; }

        /// <summary>
        /// 自定义数据类型
        /// </summary>
        public string CustomerDataType { get; set; }

        /// <summary>
        /// 生成Excel时的必填项
        /// </summary>
        [DataMember]
        public bool CustomerRequired { get; set; }


        [DataMember]
        public string DataTypeName { get; set; }

        /// <summary>
        /// 是否为主键
        /// </summary>
        [DataMember]
        public bool IsPrimaryKey { get; set; }

        /// <summary>
        /// 是否显示ToolTip
        /// </summary>
        [DataMember]
        public bool ShowToolTip { get; set; }

        /// <summary>
        /// 是否替换换行符，以单行显示
        /// </summary>
        [DataMember]
        public bool ShowSingleLine { get; set; }

        /// <summary>
        /// 列宽
        /// </summary>
        [DataMember]
        public int? Width { get; set; }

        /// <summary>
        /// 映射组
        /// </summary>
        [DataMember]
        public string MappingKey { get; set; }

        [DataMember]
        public Dictionary<string, string> MappingDatas { get; set; }

        [DataMember]
        public SmartDataSource DataSource { get; set; }

        private ObservableCollection<ExcelImportValidateBase> _ValidateItems = new ObservableCollection<ExcelImportValidateBase>();
        [DataMember]
        public ObservableCollection<ExcelImportValidateBase> ValidateItems
        {
            get { return _ValidateItems; }
            set { _ValidateItems = value; }
        }
    }
}
