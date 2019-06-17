using ZB.AppShell.Addin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    [CodonName("TableExtendColumn")]
    public class TableExtendColumnCodon : AbstractCodon
    {
        [XmlMemberAttribute("isnotnull")]
        public string IsNotNull { get; set; }

        [XmlMemberAttribute("alias")]
        public string Alias { get; set; }

        [XmlMemberAttribute("datatype", true)]
        public string DataType { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            TableExtend tableextend = parent as TableExtend;

            TableExtendColumn extendcolumn = new TableExtendColumn();
            extendcolumn.Name = this.ID;
            extendcolumn.ColumnName = string.Format("DYN_{0}_{1}", tableextend.ObjectType.Name, this.ID);

            if (!string.IsNullOrEmpty(IsNotNull))
                extendcolumn.IsNotNull = bool.Parse(IsNotNull);

            if (!string.IsNullOrEmpty(Alias))
                extendcolumn.AliasName = Alias;
            else
                extendcolumn.AliasName = this.ID;

            this.DataType = this.DataType == null ? "" : this.DataType.ToLower();

            switch (DataType)
            {
                case "int": extendcolumn.DataType = typeof(int); break;
                case "long": extendcolumn.DataType = typeof(long); break;
                case "bool": extendcolumn.DataType = typeof(bool); break;
                case "double": extendcolumn.DataType = typeof(double); break;
                case "string": extendcolumn.DataType = typeof(string); break;
                default:
                    throw new ObjectMappingException("ExtendColumnCodon 未知的 DataType -> " + DataType);
            }


            tableextend.AddColumn(extendcolumn);
            return extendcolumn;
        }
    }

    public class TableExtendColumn
    {
        /// <summary>
        /// 列名
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// 数据库列名
        /// </summary>
        public string ColumnName { get; set; }

        /// <summary>
        /// 别名
        /// </summary>
        public string AliasName { get; set; }

        /// <summary>
        /// 是否不能为空
        /// </summary>
        public bool IsNotNull { get; set; }

        /// <summary>
        /// 数据类型
        /// </summary>
        public Type DataType { get; set; }

    }
}
