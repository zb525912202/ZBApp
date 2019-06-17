using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class Sql2005DatabaseEngine : SqlServerDatabaseEngine
    {
        public override string GetSqlString<TElement>(PageAdapter<TElement> adapter, ParameterCollection paras)
        {
            string strSQL = "select [COLUMNS] from (select row_number() over ([ORDER]) as rownum,[COLUMNS] from [TABLE] [CONDITION]) as temptable where rownum > [MINROWNUM] and rownum <= [MAXROWNUM]";

            string order = this.GetSqlString(adapter.Orders);
            if (string.IsNullOrEmpty(order))
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + adapter.TableMapping.ColumnPK.Name);
            else
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + order);

            string columns = this.GetSqlString(adapter.Columns);
            if (string.IsNullOrEmpty(columns))
                strSQL = strSQL.Replace(ConstSql.Columns, " * ");
            else
                strSQL = strSQL.Replace(ConstSql.Columns, columns);

            string condition = this.GetSqlString(adapter.Conditions,paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            string table = this.GetTableName(adapter.TableMapping.Name);
            if (!string.IsNullOrEmpty(adapter.ViewName))
                table = adapter.ViewName;

            strSQL = strSQL.Replace(ConstSql.Table, table);
            strSQL = strSQL.Replace(ConstSql.MinRownum, adapter.MinRownum.ToString());
            strSQL = strSQL.Replace(ConstSql.MaxRownum, adapter.MaxRownum.ToString());

            return strSQL;
        }

        public override string GetSqlString(PageAdapter adapter, ParameterCollection paras)
        {
            string strSQL = "select [COLUMNS] from (select row_number() over ([ORDER]) as rownum,[COLUMNS] from [TABLE] [CONDITION]) as temptable where rownum > [MINROWNUM] and rownum <= [MAXROWNUM]";

            //--------------------------------------------------------------------------
            if (!string.IsNullOrEmpty(adapter.CustomSqlString_GetPageData))
                strSQL = adapter.CustomSqlString_GetPageData;
            //--------------------------------------------------------------------------

            string order = this.GetSqlString(adapter.Orders);
            if (string.IsNullOrEmpty(order))
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + adapter.PkColumnName);
            else
                strSQL = strSQL.Replace(ConstSql.Order, " order by " + order);

            string columns = this.GetSqlString(adapter.Columns,adapter.PkColumnName);
            if (string.IsNullOrEmpty(columns))
                strSQL = strSQL.Replace(ConstSql.Columns, " * ");
            else
                strSQL = strSQL.Replace(ConstSql.Columns, columns);

            string condition = this.GetSqlString(adapter.Conditions, paras);
            if (string.IsNullOrEmpty(condition))
                strSQL = strSQL.Replace(ConstSql.Condition, " ");
            else
                strSQL = strSQL.Replace(ConstSql.Condition, " where " + condition);

            strSQL = strSQL.Replace(ConstSql.Table, adapter.ViewName);
            strSQL = strSQL.Replace(ConstSql.MinRownum, adapter.MinRownum.ToString());
            strSQL = strSQL.Replace(ConstSql.MaxRownum, adapter.MaxRownum.ToString());

            return strSQL;
        }
    }
}
