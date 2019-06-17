using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference = true)]
    public class SqlCondition
    {
        public SqlCondition()
        {
            this.Conditions = new ObservableCollection<SqlConditionItem>();
        }

        [DataMember]
        public ObservableCollection<SqlConditionItem> Conditions { get; set; }

        public SqlCondition Clone()
        {
            SqlCondition obj = new SqlCondition();
            foreach (var item in this.Conditions)
                obj.Conditions.Add(item);
            return obj;
        }

        public void Clear()
        {
            Conditions.Clear();
        }

        public virtual void AddConditionItems(IList<SqlConditionItem> items)
        {
            if (items == null) { return; }
            foreach (var item in items)
            {
                AddConditionItem(item);
            }
        }

        public virtual void AddConditionItem(SqlConditionItem item)
        {
            this.Conditions.Add(item);
        }

        public virtual void AddConditionItem(EnumSqlConditionType type, string propname, object val)
        {
            if ((type != EnumSqlConditionType.Custom) && string.IsNullOrEmpty(propname))
                throw new ObjectMappingException("propname");

            this.Conditions.Add(new SqlConditionItem()
            {
                Type = type,
                ColumnName = propname,
                ConditionValue = val
            });
        }

        public virtual void AddConditionItem_MultiValues(EnumSqlConditionType type, string propname, object[] vals)
        {
            if (string.IsNullOrEmpty(propname))
                throw new ObjectMappingException("propname");

            this.Conditions.Add(new SqlConditionItem()
            {
                Type = type,
                ColumnName = propname,
                ConditionValues = new ObservableCollection<object>(vals)
            });
        }

        public virtual void AddConditionItem_Property(EnumSqlConditionType type, string propname1, string propname2)
        {
            if (string.IsNullOrEmpty(propname1))
                throw new ObjectMappingException("propname1");

            if (string.IsNullOrEmpty(propname2))
                throw new ObjectMappingException("propname2");

            this.Conditions.Add(new SqlConditionItem()
            {
                Type = type,
                ConditionValues = new ObservableCollection<object>() { propname1, propname2 }
            });
        }

        #region AddEqualTo
        public void AddEqualTo(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.EqualTo, propname, val);
        }
        #endregion

        #region AddNotEqualTo
        public void AddNotEqualTo(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.NotEqualTo, propname, val);
        }
        #endregion

        #region AddEqualToProp
        public void AddEqualToProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.EqualToProp, propname1, propname2);
        }
        #endregion

        #region AddNotEqualToProp
        public void AddNotEqualToProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.NotEqualToProp, propname1, propname2);
        }
        #endregion

        #region AddGreaterThan
        public void AddGreaterThan(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.GreaterThan, propname, val);
        }
        #endregion

        #region AddLessThan
        public void AddLessThan(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.LessThan, propname, val);
        }
        #endregion

        #region AddGreaterThanProp
        public void AddGreaterThanProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.GreaterThanProp, propname1, propname2);
        }
        #endregion

        #region AddLessThanProp
        public void AddLessThanProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.LessThanProp, propname1, propname2);
        }
        #endregion

        #region AddGreaterThanAndEqualTo
        public void AddGreaterThanEqualTo(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.GreaterThanAndEqualTo, propname, val);
        }
        #endregion

        #region AddLessThanAndEqualTo
        public void AddLessThanAndEqualTo(string propname, object val)
        {
            this.AddConditionItem(EnumSqlConditionType.LessThanAndEqualTo, propname, val);
        }
        #endregion

        #region AddGreaterThanAndEqualToProp
        public void AddGreaterThanAndEqualToProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.GreaterThanAndEqualToProp, propname1, propname2);
        }
        #endregion

        #region AddLessThanAndEqualToProp
        public void AddLessThanAndEqualToProp(string propname1, string propname2)
        {
            this.AddConditionItem(EnumSqlConditionType.LessThanAndEqualToProp, propname1, propname2);
        }
        #endregion

        #region AddMatch
        public void AddMatch(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.Match, propname, (object)val);
        }
        #endregion

        #region AddMatchFullText
        public void AddMatchFullText(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.MatchFullText, propname, (object)val);
        }
        #endregion

        #region AddMatchPrefix
        public void AddMatchPrefix(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.MatchPrefix, propname, (object)val);
        }
        #endregion

        #region AddMatchSuffix
        public void AddMatchSuffix(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.MatchSuffix, propname, (object)val);
        }
        #endregion

        #region AddNotMatch
        public void AddNotMatch(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.NotMatch, propname, (object)val);
        }
        #endregion

        #region AddNotMatchPrefix
        public void AddNotMatchPrefix(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.NotMatchPrefix, propname, (object)val);
        }
        #endregion

        #region AddNotMatchSuffix
        public void AddNotMatchSuffix(string propname, string val)
        {
            this.AddConditionItem(EnumSqlConditionType.NotMatchSuffix, propname, (object)val);
        }
        #endregion

        #region AddIn
        public void AddIn(string propname, object[] vals)
        {
            this.AddConditionItem_MultiValues(EnumSqlConditionType.In, propname, vals);
        }
        #endregion

        #region AddNotIn
        public void AddNotIn(string propname, object[] vals)
        {
            this.AddConditionItem_MultiValues(EnumSqlConditionType.NotIn, propname, vals);
        }
        #endregion

        #region AddCustom
        public void AddCustom(string condtion)
        {
            if (string.IsNullOrEmpty(condtion))
                throw new ObjectMappingException("condition");
            this.AddConditionItem(EnumSqlConditionType.Custom, null, (object)condtion);
        }
        #endregion
    }
}
