using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace ZB.Framework.ObjectMapping
{
    public class SqlCondition<T> : SqlCondition where T : ObjectMappingBase
    {
        public SqlCondition()
        {
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        internal TableMapping TableMapping { get; set; }

        public override void AddConditionItem(EnumSqlConditionType type, string propname, object val)
        {
            if (type == EnumSqlConditionType.Custom)
                base.AddConditionItem(type, propname, val);
            else
            {
                if (string.IsNullOrEmpty(propname))
                    throw new ObjectMappingException("propname");

                ColumnMapping column = TableMapping.GetColumnMappingByPropertyName(propname);

                if (column != null)
                    base.AddConditionItem(type, column.Name, val);
                else
                    throw new ObjectMappingException("not find column");
            }
        }

        public override void AddConditionItem_MultiValues(EnumSqlConditionType type, string propname, object[] vals)
        {
            if (string.IsNullOrEmpty(propname))
                throw new ObjectMappingException("propname");

            ColumnMapping column = TableMapping.GetColumnMappingByPropertyName(propname);

            if (column != null)
                base.AddConditionItem_MultiValues(type,column.Name,vals);
            else
                throw new ObjectMappingException("not find column");
        }

        public override void AddConditionItem_Property(EnumSqlConditionType type, string propname1, string propname2)
        {
            if (string.IsNullOrEmpty(propname1))
                throw new ObjectMappingException("propname1");

            if (string.IsNullOrEmpty(propname2))
                throw new ObjectMappingException("propname2");

            ColumnMapping column1 = TableMapping.GetColumnMappingByPropertyName(propname1);
            ColumnMapping column2 = TableMapping.GetColumnMappingByPropertyName(propname2);

            if ((column1 != null) && (column2 != null))
                base.AddConditionItem(type,column1.Name,column2.Name);
            else
                throw new ObjectMappingException("not find column");
        }
    }
}
