using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.XPath;

namespace ZB.Tools.TableMaker
{
    public class CodeWriter_ZBMaster5
    {
        private string _TemplateFileName_Table = System.Windows.Forms.Application.StartupPath + "\\Project\\ZBMaster5\\Template\\TableTemplate.cs";

        private Dictionary<string, string> DataTypeDefine = new Dictionary<string, string>();


        public CodeWriter_ZBMaster5()
        {

            DataTypeDefine.Add("char", "string");
            DataTypeDefine.Add("nchar", "string");
            DataTypeDefine.Add("varchar", "string");
            DataTypeDefine.Add("nvarchar", "string");
            DataTypeDefine.Add("text", "string");
            DataTypeDefine.Add("int", "int");
            DataTypeDefine.Add("bigint", "long");
            DataTypeDefine.Add("float", "double");
            DataTypeDefine.Add("real", "double");
            DataTypeDefine.Add("image", "byte[]");
            DataTypeDefine.Add("varbinary", "byte[]");
            DataTypeDefine.Add("varbinary(max)", "byte[]");
            DataTypeDefine.Add("datetime", "DateTime");
            DataTypeDefine.Add("bit", "bool");
            DataTypeDefine.Add("numeric", "int");
            DataTypeDefine.Add("decimal", "decimal");
            DataTypeDefine.Add("ntext", "string");
            DataTypeDefine.Add("uniqueidentifier", "string");
        }

        public void WriteCodeFile(DBManager dbmgr, string dbName, string placeFolder, string namespacePrefix)
        {
            string s_PK = @"
            [Column(IsPK = true#IsAutoIncrease#)]
            public #DataType# #ColumnName# { get; set; }";

            string s_AutoIncreasement = @",IsAutoIncrement = true";
            string s_TableSeed = @",IsUseSeedFactory = true";

            string s_ValueType = @"
            private #DataType##AllowNull# _#ColumnName#;
                  [Column]
                  public #DataType##AllowNull# #ColumnName#
                  {
                      get { return _#ColumnName#; }
                      set
                      {
                          if (_#ColumnName# != value)
                          {
                              _#ColumnName# = value;
                              RaisePropertyChanged(""#ColumnName#"");
                          }
                      }
            }";

            string s_RefType = @"
            private #DataType# _#ColumnName#;
            [Column]
            public #DataType# #ColumnName#
            {
                get
                {
                    return this._#ColumnName#;
                }
                set
                {
                    if (!object.ReferenceEquals(this._#ColumnName#, value))
                    {
                        this._#ColumnName# = value;
                        this.RaisePropertyChanged(""#ColumnName#"");
                    }
                }
            }";


            string s_normal = @"
            [Column]
            public #DataType##AllowNull# #ColumnName# {get;set;}";


            string s_HideFieldStyle = @"
            public const string __#ColumnName# = ""#ColumnName#"";";


            if (!Directory.Exists(placeFolder)) Directory.CreateDirectory(placeFolder);
            foreach (var tableItem in  dbmgr.GetDBByName(dbName).TableList.Where(r => r.IsInclude))
            {
                StringBuilder sb = new StringBuilder(File.ReadAllText(_TemplateFileName_Table, Encoding.UTF8));
                sb.Replace("%Namespace%", namespacePrefix);
                sb.Replace("%ClassName%", tableItem.ObjectName);

                //逐个列生成Property段
                string strProperties = string.Empty;

                //主键数据类型
                string strPKDataType = "int";

                //常量双下划线
                string strDoubleDevide = string.Empty;

                foreach (var columnItem in tableItem.ColumnList)
                {
                    if (columnItem.IsHideField) continue;

                    string dataTypeStr = DataTypeDefine[columnItem.DataType];

                    string strPropItem = string.Empty;

                    if (columnItem.IsInPK)
                    {
                        strPKDataType = dataTypeStr;

                        string strIncres = columnItem.IsAutoIncreasement ? s_AutoIncreasement : s_TableSeed;
                        strPropItem = s_PK.Replace("#ColumnName#", columnItem.ObjectName);
                        strPropItem = strPropItem.Replace("#DataType#", dataTypeStr);
                        strPropItem = strPropItem.Replace("#IsAutoIncrease#", strIncres);

                        strProperties += strPropItem;
                    }
                    else
                    {
                        if (columnItem.IsPropStyle) //使用属性RaisePropertyChanged样式
                        {
                            bool isValueType = ("string,byte[]").IndexOf(dataTypeStr) < 0;
                            if (isValueType) //值类型
                            {
                                strPropItem = s_ValueType.Replace("#ColumnName#", columnItem.ObjectName);
                                strPropItem = strPropItem.Replace("#DataType#", dataTypeStr);
                                strPropItem = strPropItem.Replace("#AllowNull#", columnItem.IsAllowNull ? "?" : "");
                                strProperties += strPropItem;

                            }
                            else //引用类型
                            {
                                strPropItem = s_RefType.Replace("#ColumnName#", columnItem.ObjectName);
                                strPropItem = strPropItem.Replace("#DataType#", dataTypeStr);
                                strProperties += strPropItem;
                            }
                        }
                        else //普通get set样式
                        {
                            strPropItem = s_normal.Replace("#ColumnName#", columnItem.ObjectName);
                            strPropItem = strPropItem.Replace("#DataType#", dataTypeStr);
                            strPropItem = strPropItem.Replace("#AllowNull#", columnItem.IsAllowNull ? "?" : "");
                            strProperties += strPropItem;
                        }
                    }

                    strProperties += System.Environment.NewLine;
                }
                sb.Replace("%pkType%", strPKDataType);
                sb.Replace("%Properties%", strProperties);

                string strHideList = string.Empty;
                foreach (var columnItem in tableItem.ColumnList)
                {
                    string strhItem = string.Empty;
                    string dataTypeStr = DataTypeDefine[columnItem.DataType];
                    strhItem = s_HideFieldStyle.Replace("#ColumnName#", columnItem.ObjectName);
                    strHideList += strhItem;
                }
                sb.Replace("%Hide%", strHideList);


                ///写文件
                if (!Directory.Exists(placeFolder)) Directory.CreateDirectory(placeFolder);

                ///获取新文件名
                string CodeFileName = placeFolder + "\\" + tableItem.ObjectName + ".cs";
                if (File.Exists(CodeFileName)) File.Delete(CodeFileName);

                using (StreamWriter sw = new StreamWriter(CodeFileName))
                {
                    sw.Write(sb.ToString());
                    sw.Close();
                }
            }
        }
    }
}
