using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Entity;
using System.Collections;
using System.Data.Common;
using System.Data.OleDb;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using System.IO;
using System.Collections.ObjectModel;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        public DatabaseSession DatabaseSession { get; internal set; }

        #region GetTableName(string tablename)
        public string GetTableName(string tablename)
        {
            return DatabaseSession.GetMappingTable(tablename);
        }
        #endregion

        #region GetSqlStringCommand(string query)
        public DbCommand GetSqlStringCommand(string query)
        {
            return DatabaseSession.Database.GetSqlStringCommand(query);
        }
        #endregion

        #region GetSqlStringCommandFromFile(string sqlscriptfile)
        public DbCommand GetSqlStringCommandFromFile(string sqlscriptfile)
        {
            string strSQL = File.ReadAllText(sqlscriptfile);
            return this.GetSqlStringCommand(strSQL);
        }
        #endregion

        #region GetPageAdapterMaxRowCount<TElement>(PageAdapter<TElement> adapter)
        public virtual int GetPageAdapterMaxRowCount<TElement>(PageAdapter<TElement> adapter) where TElement : ObjectMappingBase
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString_PageAdapterMaxRowCount(adapter, paras);
            return this.ExecuteScalar<int>(strSQL, paras.ToArray());
        }
        #endregion

        #region GetPageAdapterMaxRowCount(PageAdapter adapter)
        public virtual int GetPageAdapterMaxRowCount(PageAdapter adapter)
        {
            ParameterCollection paras = new ParameterCollection();
            string strSQL = this.GetSqlString_PageAdapterMaxRowCount(adapter, paras);
            return this.ExecuteScalar<int>(strSQL, paras.ToArray());
        }
        #endregion

        /// <summary>
        /// 获取列占位符
        /// </summary>
        public static HashSet<string> GetColumnPlaceholder(string str)
        {
            //$ABC123__M,xxxx$BBB()asdklf xa$ABC123___
            HashSet<string> columns = new HashSet<string>();
            if (!string.IsNullOrEmpty(str))
            {
                Regex regex = new Regex(@"\" + ConstSql.Column_Define_Prefix + @"[A-Za-z_]\w+");
                var matchs = regex.Matches(str);
                foreach (Match match in matchs)
                {
                    string col = match.Value.TrimStart(ConstSql.Column_Define_Prefix);
                    if (!columns.Contains(col))
                        columns.Add(col);
                }
            }
            return columns;
        }

        /// <summary>
        /// 替换列占位符
        /// </summary>
        public static string ReplaceColumnPlaceholder(TableMapping table,string str)
        {
            HashSet<string> columns = GetColumnPlaceholder(str);

            foreach (var col in columns)
            {
                string dstcol = null;
                ColumnMapping columnMapping = table.GetColumnMappingByPropertyName(col);
                if (columnMapping != null)
                    dstcol = columnMapping.Name;
                else if(table.IsSupportExtend)
                {
                    TableExtend tableextend = TableExtendService.Instance.GetTableExtend(table.ObjectType);
                    if (tableextend != null)
                    {
                        if (tableextend.NameDict.ContainsKey(col))
                            dstcol = tableextend.NameDict[col].ColumnName;
                    }
                }

                if (string.IsNullOrEmpty(dstcol))
                    throw new ObjectMappingException("未知的列名占位符 " + col);

                str = str.Replace(ConstSql.Column_Define_Prefix + col, dstcol);
            }

            return str;
        }
    }
}
