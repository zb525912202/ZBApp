using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace ZB.Framework.ObjectMapping
{
    public class ColumnMapping
    {
        public string Name {get;set;}

        public bool IsPK {get;set;}

        public bool IsAutoIncrement {get;set;}

        public bool IsUseSeedFactory {get;set;}

        public PropertyInfo PropertyInfo { get; set; }

        public Type ColumnType
        {
            get{    return PropertyInfo.PropertyType;   }
        }

        public string PropertyName
        {
            get{    return PropertyInfo.Name;   }
        }

        public DataInterceptAttribute DataIntercept {get;set;}

        public ColumnMapping Clone()
        {
            ColumnMapping col = new ColumnMapping();
            col.Name = this.Name;
            col.IsPK = this.IsPK;
            col.IsAutoIncrement = this.IsAutoIncrement;
            col.IsUseSeedFactory = this.IsUseSeedFactory;
            col.PropertyInfo = this.PropertyInfo;
            return col;
        }

        public void SetValue(object obj,object val)
        {
            if (DataIntercept != null)
            {
                val = DataIntercept.SetValue(obj, val);
            }
            
            if (val != DBNull.Value)
            {

                object tempval;

                if (this.ColumnType.IsEnum)
                    tempval = Enum.ToObject(this.ColumnType, val);
                else if (this.ColumnType.IsValueType && (this.ColumnType.IsGenericType == false))
                    tempval = Convert.ChangeType(val, this.ColumnType);
                else
                    tempval = val;

                PropertyInfo.SetValue(obj, tempval, null);
            }
        }

        public object GetValue(object obj)
        {
            object val = PropertyInfo.GetValue(obj, null);
            if (DataIntercept != null)
                val = DataIntercept.GetValue(obj, val);

            if (val != null)
            {
                if (val is DateTime)
                {
                    if ((DateTime)val == DateTime.MinValue)
                        return null;
                }
            }
            return val;
        }
    }
}
