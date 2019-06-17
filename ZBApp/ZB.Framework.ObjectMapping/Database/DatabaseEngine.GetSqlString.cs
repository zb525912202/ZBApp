using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {

        #region GetSqlString(SqlCondition sqlcondition, ParameterCollection paras)
        public virtual string GetSqlString(SqlCondition sqlcondition, ParameterCollection paras)
        {
            if (sqlcondition == null)
                throw new ObjectMappingException("sqlcondition");

            if (sqlcondition.Conditions.Count > 0)
            {
                string[] strsqls = new string[sqlcondition.Conditions.Count];
                for (int i = 0; i < sqlcondition.Conditions.Count; i++)
                {
                    strsqls[i] = GetSqlString(sqlcondition.Conditions[i], paras);
                }
                return string.Join(" and ", strsqls);
            }
            else
                return string.Empty;
        }
        #endregion

        public virtual string GetSqlString_LikeCondition(object val, string StrPrefix, string StrSuffix)
        {
            return string.Format(" like '{0}' ESCAPE N'~' ", CorrectLikeConditionValue(val, StrPrefix, StrSuffix));
        }

        public virtual string CorrectFullTextConditionValue(object val)
        {
            string strval = val as string;
            if (strval == null)
                strval = string.Empty;
            strval = strval.Replace("\"", "〞");
            strval = strval.Replace("\'", "ˊ");
            return strval;
        }

        public virtual string CorrectLikeConditionValue(object val, string StrPrefix, string StrSuffix)
        {
            string strval = SqlHelper.CorrectLikeParameterValue(val);
            strval = StrPrefix + strval + StrSuffix;
            return strval;
        }

        #region GetSqlString(SqlConditionItem condition, ParameterCollection paras)
        public virtual string GetSqlString(SqlConditionItem condition, ParameterCollection paras)
        {
            string strSQL = string.Empty;
            switch (condition.Type)
            {
                case EnumSqlConditionType.EqualTo:
                    if (condition.ConditionValue == null)
                        strSQL = condition.ColumnName + " is null ";
                    else
                        strSQL = string.Format("{0} = {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.NotEqualTo:
                    if (condition.ConditionValue == null)
                        strSQL = condition.ColumnName + " is not null ";
                    else
                        strSQL = string.Format("{0} <> {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.GreaterThan:
                    strSQL = string.Format("{0} > {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.GreaterThanAndEqualTo:
                    strSQL = string.Format("{0} >= {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.LessThan:
                    strSQL = string.Format("{0} < {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.LessThanAndEqualTo:
                    strSQL = string.Format("{0} <= {1}", condition.ColumnName, this.BuildParameterName(paras.GenerateParameter(condition.ConditionValue)));
                    break;
                case EnumSqlConditionType.Match:
                    strSQL = string.Format("{0} like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "%", "%"))));
                    break;
                case EnumSqlConditionType.MatchFullText:
                    strSQL = string.Format("CONTAINS({0},'\"{1}\"')", condition.ColumnName, CorrectFullTextConditionValue(condition.ConditionValue));
                    break;
                case EnumSqlConditionType.MatchPrefix:
                    strSQL = string.Format("{0} like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "", "%"))));
                    break;
                case EnumSqlConditionType.MatchSuffix:
                    strSQL = string.Format("{0} like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "%", ""))));
                    break;
                case EnumSqlConditionType.NotMatch:
                    strSQL = string.Format("{0} not like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "%", "%"))));
                    break;
                case EnumSqlConditionType.NotMatchPrefix:
                    strSQL = string.Format("{0} not like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "", "%"))));
                    break;
                case EnumSqlConditionType.NotMatchSuffix:
                    strSQL = string.Format("{0} not like {1} ESCAPE N'~'", condition.ColumnName,
                    this.BuildParameterName(paras.GenerateParameter(CorrectLikeConditionValue(condition.ConditionValue, "%", ""))));
                    break;
                case EnumSqlConditionType.In:
                    strSQL = condition.ColumnName + " in (" + string.Join(" , ", this.GetSqlStringArrayForValue(condition.ConditionValues)) + ") ";
                    break;
                case EnumSqlConditionType.NotIn:
                    strSQL = condition.ColumnName + " not in (" + string.Join(" , ", this.GetSqlStringArrayForValue(condition.ConditionValues)) + ") ";
                    break;
                case EnumSqlConditionType.Custom:
                    strSQL = (string)condition.ConditionValue;
                    if ((condition.ParameterCollection != null) && (condition.ParameterCollection.Count > 0))
                    {
                        foreach (var pitem in condition.ParameterCollection)
                        {
                            paras.Add(pitem);
                        }
                    }
                    break;

                #region Property 相关条件
                case EnumSqlConditionType.EqualToProp:
                    strSQL = (string)condition.ConditionValues[0] + "=" + (string)condition.ConditionValues[1];
                    break;
                case EnumSqlConditionType.GreaterThanAndEqualToProp:
                    strSQL = (string)condition.ConditionValues[0] + ">=" + (string)condition.ConditionValues[1];
                    break;
                case EnumSqlConditionType.GreaterThanProp:
                    strSQL = (string)condition.ConditionValues[0] + ">" + (string)condition.ConditionValues[1];
                    break;
                case EnumSqlConditionType.LessThanAndEqualToProp:
                    strSQL = (string)condition.ConditionValues[0] + "<=" + (string)condition.ConditionValues[1];
                    break;
                case EnumSqlConditionType.LessThanProp:
                    strSQL = (string)condition.ConditionValues[0] + "<" + (string)condition.ConditionValues[1];
                    break;
                case EnumSqlConditionType.NotEqualToProp:
                    strSQL = (string)condition.ConditionValues[0] + "<>" + (string)condition.ConditionValues[1];
                    break;
                #endregion

                default:
                    break;
            }
            return strSQL;
        }
        #endregion

        #region GetSqlStringArrayForValue(IList vals)
        public virtual string[] GetSqlStringArrayForValue(IList vals)
        {
            string[] list = new string[vals.Count];

            for (int i = 0; i < vals.Count; i++)
            {
                list[i] = this.GetSqlStringForValue(vals[i]);
            }

            return list;
        }
        #endregion

        #region GetSqlStringForValue(object val)
        public virtual string GetSqlStringForValue(object val)
        {
            Type t = val.GetType();

            if (t == typeof(string))
                return "'" + val.ToString() + "'";
            else if (t == typeof(DateTime))
                return "'" + val.ToString() + "'";
            else if (t == typeof(bool))
                return (bool)val ? "1" : "0";
            else
                return val.ToString();
        }
        #endregion

        #region GetSqlString(SqlOrder sqlorder)
        public virtual string GetSqlString(SqlOrder sqlorder)
        {
            if (sqlorder == null)
                throw new ObjectMappingException("sqlorder is null!");

            if (sqlorder.OrderItems.Count > 0)
            {
                string[] orderitems = new string[sqlorder.OrderItems.Count];
                for (int i = 0; i < sqlorder.OrderItems.Count; i++)
                {
                    OrderItem item = sqlorder.OrderItems[i];

                    if (item.OrderMode != EnumOrderMode.NONE)
                        orderitems[i] = item.Column + " " + item.OrderMode.ToString();
                    else
                        orderitems[i] = item.Column + " ";
                }

                return string.Join(",", orderitems);
            }
            else
                return string.Empty;
        }
        #endregion

        #region GetSqlString<TElement>(SqlSelectColumns<TElement> sqlselectcolumns)
        public virtual string GetSqlString<TElement>(SqlSelectColumns<TElement> sqlselectcolumns) where TElement : ObjectMappingBase
        {
            if (sqlselectcolumns == null)
                throw new ObjectMappingException("sqlselectcolumns is null!");

            if (sqlselectcolumns.SelectColumns.Count > 0)
            {
                string[] columns = sqlselectcolumns.SelectColumns.ToArray();
                string columnstr = string.Join(",", columns);

                string pkcolumn = sqlselectcolumns.TableMapping.ColumnPK.Name;
                if (!sqlselectcolumns.SelectColumns.Contains(pkcolumn))
                    columnstr = pkcolumn + "," + columnstr;

                return columnstr;
            }
            else if (sqlselectcolumns.NotSelectColumns.Count > 0)
            {

                List<string> selectcolumns = new List<string>();

                foreach (ColumnMapping column in sqlselectcolumns.TableMapping.Columns)
                {
                    if (!sqlselectcolumns.NotSelectColumns.Contains(column.Name))
                        selectcolumns.Add(column.Name);
                }

                return string.Join(",", selectcolumns.ToArray());
            }
            else
                return string.Empty;
        }
        #endregion

        #region GetSqlString(SqlSelectColumns sqlselectcolumns,string pkColumnName)
        public virtual string GetSqlString(SqlSelectColumns sqlselectcolumns, string pkColumnName)
        {
            if (sqlselectcolumns == null)
                throw new ObjectMappingException("sqlselectcolumns is null!");

            if (sqlselectcolumns.SelectColumns.Count > 0)
            {
                string[] columns = sqlselectcolumns.SelectColumns.ToArray();
                string columnstr = string.Join(",", columns);

                if (columnstr.IndexOf(pkColumnName) == -1)
                    columnstr = pkColumnName + "," + columnstr;

                return columnstr;
            }
            else
                return string.Empty;
        }
        #endregion
    }
}
