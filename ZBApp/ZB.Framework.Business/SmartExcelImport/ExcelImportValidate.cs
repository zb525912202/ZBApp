using ZB.Framework.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;

namespace ZB.Framework.Business
{
    [DataContract(IsReference = true)]
    public class ExcelImportValidateBase
    {
        public virtual string IsValid(ExcelImportColumn col, string data)
        {
            throw new Exception("IsValid Unrealized");
        }
    }

    /// <summary>
    /// 验证输入格式
    /// </summary>
    [DataContract(IsReference = true)]
    public class ExcelImportValidateFormat : ExcelImportValidateBase
    {
        public override string IsValid(ExcelImportColumn col, string str)
        {
            if (col.CustomerRequired && str.Length == 0)
            {
                return "输入项不允许为空";
            }

            if (str.Length == 0)
                return string.Empty;

            if (col.DataSource != null)
            {
                if ((col.DataSource is DbDataSource)
                    && !string.IsNullOrEmpty(((DbDataSource)col.DataSource).ParentColumn))
                {
                    DbDataSource ds = (DbDataSource)col.DataSource;
                    DataSourceItem tempDataItem = ds.FindItemByFullPath(str);
                    if (tempDataItem == null)
                        return "输入不正确!";
                }
                else
                {
                    List<string> texts = col.DataSource.DataSourceItems.Select(o => o.Text).ToList();
                    if (!texts.Contains(str))
                    {
                        if (!col.MappingDatas.ContainsKey(str))
                            return string.Format("输入不正确! （{0}）", string.Join(",", texts));
                    }
                }
            }
            else if (col.DataType == typeof(DateTime))
            {
                DateTime val;
                if (!DateTime.TryParse(str, out val))
                    return "请输入有效的日期时间!";
            }
            else if (col.DataType == typeof(Decimal))
            {
                decimal val;
                if (!decimal.TryParse(str, out val))
                    return "请输入有效的数字(如500.00)!";
            }
            else if (col.DataType == typeof(int))
            {
                int val = 0;
                if (!int.TryParse(str, out val))
                    return "请输入有效的整数!";
            }

            return string.Empty;
        }
    }

    /// <summary>
    /// 验证区间要求
    /// </summary>
    [DataContract(IsReference = true)]
    public class ExcelImportValidateRange : ExcelImportValidateBase
    {
        public ExcelImportValidateRange()
        {
            this.Min_String = -1;
            this.Max_String = -1;
            this.Min_DateTime = SqlCommon.SqlDateTime_Min;
            this.Max_DateTime = SqlCommon.SqlDateTime_Max;
        }

        [DataMember]
        public int Min_String { get; set; } //字符串最小长度（-1：忽略此限制）

        [DataMember]
        public int Max_String { get; set; } //字符串最大长度（-1：忽略此限制）

        [DataMember]
        public int? Min_Int { get; set; }

        [DataMember]
        public int? Max_Int { get; set; }

        [DataMember]
        public Decimal? Min_Decimal { get; set; }

        [DataMember]
        public Decimal? Max_Decimal { get; set; }

        [DataMember]
        public DateTime Min_DateTime { get; set; }

        [DataMember]
        public DateTime Max_DateTime { get; set; }

        [DataMember]
        public string SmallErrorMessage { get; set; }

        [DataMember]
        public string BigErrorMessage { get; set; }

        public override string IsValid(ExcelImportColumn col, string str)
        {
            if (col.DataType == typeof(string))
            {
                if (this.Min_String != -1 && str.Length < this.Min_String)
                    return string.Format(SmallErrorMessage ?? "文本长度不能小于{0}!", this.Min_String);
                else if (this.Max_String != -1 && str.Length > this.Max_String)
                    return string.Format(BigErrorMessage ?? "文本长度不能大于{0}!", this.Max_String);
            }
            else if (str.Length > 0 && col.DataType == typeof(DateTime))
            {
                DateTime val;
                if (DateTime.TryParse(str, out val))
                {
                    if (val < Min_DateTime)
                        return string.Format(SmallErrorMessage ?? "输入日期不能小于 {0}!", Min_DateTime);
                    else if (val > Max_DateTime)
                        return string.Format(BigErrorMessage ?? "输入日期不能大于 {0}!", Max_DateTime);
                }
            }
            else if (str.Length > 0 && col.DataType == typeof(Decimal))
            {
                decimal val;
                if (decimal.TryParse(str, out val))
                {
                    if (this.Min_Decimal.HasValue && val < this.Min_Decimal)
                        return string.Format(SmallErrorMessage ?? "不能小于{0}!", this.Min_Decimal);
                    else if (this.Max_Decimal.HasValue && val > this.Max_Decimal)
                        return string.Format(BigErrorMessage ?? "不能大于{0}!", this.Max_Decimal);
                }
            }
            else if (str.Length > 0 && col.DataSource == null && col.DataType == typeof(int))
            {
                int val = 0;
                if (int.TryParse(str, out val))
                {
                    if (this.Min_Int.HasValue && val < this.Min_Int)
                        return string.Format(SmallErrorMessage ?? "不能小于{0}!", this.Min_Int);
                    else if (this.Max_Int.HasValue && val > this.Max_Int)
                        return string.Format(BigErrorMessage ?? "不能大于{0}!", this.Max_Int);
                }
            }

            return string.Empty;
        }
    }

    /// <summary>
    /// 验证必填项
    /// </summary>
    [DataContract(IsReference = true)]
    public class ExcelImportValidateRequired : ExcelImportValidateBase
    {
        [DataMember]
        public string ErrorMessage { get; set; }

        public ExcelImportValidateRequired()
        {
            this.ErrorMessage = "不能为空!";
        }

        public override string IsValid(ExcelImportColumn col, string str)
        {
            if (string.IsNullOrEmpty(str))
                return this.ErrorMessage;

            return string.Empty;
        }
    }

    /// <summary>
    /// 正则表达式验证
    /// </summary>
    [DataContract(IsReference = true)]
    public class ExcelImportValidateRegex : ExcelImportValidateBase
    {
        [DataMember]
        public string ErrorMessage { get; set; }

        [DataMember]
        public string Pattern { get; set; }

        public ExcelImportValidateRegex()
        {
            this.ErrorMessage = "格式不正确!";
        }

        public override string IsValid(ExcelImportColumn col, string str)
        {
            Regex regex = new Regex(Pattern);
            bool isMatch = regex.IsMatch(str);
            return isMatch ? string.Empty : this.ErrorMessage;
        }
    }




    /// <summary>
    /// 哎，没办法咯...
    /// </summary>
    [DataContract(IsReference = true)]
    public partial class SponsorDeptValidate : ExcelImportValidateBase
    {
        protected string DeptFullPath;

        public SponsorDeptValidate(string deptFullPath)
        {
            this.DeptFullPath = deptFullPath;
        }

        /// <summary>
        /// 1，主办部门只能是自己 主管的部门 或者 主管部门的直属下级部门
        /// 2，在输入的时候支持不输入主办部门的全路径，所以在判断该部门是否存在时，全路径会做如下处理
        /// 3，全路径和主管部门相同，不做处理。
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static string getPath(string data, string managerDeptFullPath)
        {
            //string managerDeptFullPath = AppShellService.Instance.CurrentEmployee.ManageDeptFullPath;
            string path = data;

            if (managerDeptFullPath != path)
            {
                managerDeptFullPath = managerDeptFullPath.Replace("/" + data, "");
                path = data.Replace(managerDeptFullPath + "/", "");
                path = managerDeptFullPath + "/" + path;
            }

            return path;
        }

        public override string IsValid(ExcelImportColumn col, string data)
        {
            string path = getPath(data, this.DeptFullPath);

            DbDataSource ds = (DbDataSource)col.DataSource;
            DataSourceItem tempDataItem = ds.FindItemByFullPath(path);
            if (tempDataItem == null)
            {
                return "输入的单位不存在!";
            }

            return string.Empty;
        }
    }
}
