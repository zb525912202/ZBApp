using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ZB.Framework.ObjectMapping
{
    public class MappingHelper
    {
        public static string GetPKColumnName<T>()
        {
            string PKColumnName = string.Empty;
            Type t = typeof(T);
            foreach (PropertyInfo p in t.GetProperties())
            {
                ColumnAttribute attr = (ColumnAttribute)p.GetCustomAttributes(typeof(ColumnAttribute), false).FirstOrDefault();
                if (attr != null && attr.IsPK)
                {
                    PKColumnName = p.Name;
                    break;
                }
            }
            return PKColumnName;
        }
    }
}
