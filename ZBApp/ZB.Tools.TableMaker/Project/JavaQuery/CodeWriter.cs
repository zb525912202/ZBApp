using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.XPath;

namespace ZB.Tools.TableMaker
{
    public class CodeWriter_JavaQuery
    {
        private string _TemplateFileName_Table = System.Windows.Forms.Application.StartupPath + "\\Project\\Java\\Template\\TableTemplate.cs";

        private Dictionary<string, string> DataTypeDefine_CS = new Dictionary<string, string>();

        public DBManager Dbmgr;

        public ZBDatabase CurrentDatabase;

        public CodeWriter_JavaQuery(DBManager dbmgr)
        {
            this.Dbmgr = dbmgr;

            //CS
            DataTypeDefine_CS.Add("char", "string");
            DataTypeDefine_CS.Add("nchar", "string");
            DataTypeDefine_CS.Add("varchar", "string");
            DataTypeDefine_CS.Add("nvarchar", "string");
            DataTypeDefine_CS.Add("text", "string");
            DataTypeDefine_CS.Add("int", "int");
            DataTypeDefine_CS.Add("bigint", "int");
            DataTypeDefine_CS.Add("float", "float");
            DataTypeDefine_CS.Add("real", "float");
            DataTypeDefine_CS.Add("datetime", "DateTime");
            DataTypeDefine_CS.Add("bit", "bool");
            DataTypeDefine_CS.Add("numeric", "int");
            DataTypeDefine_CS.Add("decimal", "float");
            DataTypeDefine_CS.Add("ntext", "string");
            DataTypeDefine_CS.Add("uniqueidentifier", "string");
            DataTypeDefine_CS.Add("image", "byte[]");
            DataTypeDefine_CS.Add("varbinary", "byte[]");
            DataTypeDefine_CS.Add("varbinary(max)", "byte[]");

        }

        public void WriteCodeFile(string placeFolder, string namespacePrefix)
        {
            //sb1=cs
            //sb2=js

            string s_AutoIncreasement = @",IsAutoIncrement = true";

            string s_sb1_PK = @"
            [Column(IsPK = true#IsAutoIncrease#)]
            public #DataType# #ColumnName# { get; set; }";

            string s_sb1_normal = @"
            [Column]
            public #DataType##AllowNull# #ColumnName# { get;set; }";

            string s_sb1_HideFieldStyle = @"
            public const string __#ColumnName# = ""#ColumnName#"";";

            string s_sb2_normal = @"{ name: '#ColumnName#', type: '#DataType#' },";


            if (!Directory.Exists(placeFolder)) Directory.CreateDirectory(placeFolder);
            foreach (var tableItem in CurrentDatabase.TableList.Where(r => r.IsInclude))
            {
                StringBuilder sb1 = new StringBuilder(File.ReadAllText(_TemplateFileName_Table, Encoding.UTF8)); //sb1=cs
                sb1.Replace("%Namespace%", namespacePrefix);
                sb1.Replace("%ClassName%", tableItem.ObjectName);


                //逐个列生成Property段
                string strProperties_sb1 = string.Empty;

                //主键数据类型
                string strPKDataType = "int";

                //常量双下划线
                string strDoubleDevide = string.Empty;

                foreach (var columnItem in tableItem.ColumnList)
                {
                    string dataTypeStrCS = DataTypeDefine_CS[columnItem.DataType];

                    string strPropItem_sb1 = string.Empty;

                    if (columnItem.IsInPK)
                    {
                        strPKDataType = dataTypeStrCS;

                        string strIncres = columnItem.IsAutoIncreasement ? s_AutoIncreasement : "";
                        strPropItem_sb1 = s_sb1_PK.Replace("#ColumnName#", columnItem.ObjectName);
                        strPropItem_sb1 = strPropItem_sb1.Replace("#DataType#", dataTypeStrCS);
                        strPropItem_sb1 = strPropItem_sb1.Replace("#IsAutoIncrease#", strIncres);

                        strProperties_sb1 += strPropItem_sb1;
                    }
                    else
                    {
                        bool isValueType = ("string,byte[]").IndexOf(dataTypeStrCS) < 0;

                        strPropItem_sb1 = s_sb1_normal.Replace("#ColumnName#", columnItem.ObjectName);
                        strPropItem_sb1 = strPropItem_sb1.Replace("#DataType#", dataTypeStrCS);

                        if (isValueType)
                        {
                            strPropItem_sb1 = strPropItem_sb1.Replace("#AllowNull#", columnItem.IsAllowNull ? "?" : "");
                        }
                        else
                        {
                            strPropItem_sb1 = strPropItem_sb1.Replace("#AllowNull#", "");
                        }

                        strProperties_sb1 += strPropItem_sb1;
                    }

                    strProperties_sb1 += System.Environment.NewLine;
                }
                sb1.Replace("%pkType%", strPKDataType);
                strProperties_sb1 = strProperties_sb1.Trim(System.Environment.NewLine.ToArray());
                sb1.Replace("%Properties%", strProperties_sb1);

                string strHideList = string.Empty;
                foreach (var columnItem in tableItem.ColumnList)
                {
                    string strhItem = string.Empty;
                    string dataTypeStr = DataTypeDefine_CS[columnItem.DataType];
                    strhItem = s_sb1_HideFieldStyle.Replace("#ColumnName#", columnItem.ObjectName);
                    strHideList += strhItem;
                }
                strHideList = strHideList.Trim(System.Environment.NewLine.ToArray());
                sb1.Replace("%Hide%", strHideList);


                ///写文件
                if (!Directory.Exists(placeFolder)) Directory.CreateDirectory(placeFolder);

                ///获取新文件名
                string CodeFileName_sb1 = placeFolder + "\\" + tableItem.ObjectName + ".cs";
     
                if (File.Exists(CodeFileName_sb1)) File.Delete(CodeFileName_sb1);

                using (StreamWriter sw = new StreamWriter(CodeFileName_sb1))
                {
                    sw.Write(sb1.ToString());
                    sw.Close();
                }

              
            }
        }
    }
}
