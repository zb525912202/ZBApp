using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Reflection;

namespace ZB.Framework.Utility
{
    public static class ReflectionHelper
    {
        public static readonly MethodInfo MethodInfo_GroupBy_Source_KeySelector;

        static ReflectionHelper()
        {
            MethodInfo_GroupBy_Source_KeySelector = typeof(Enumerable).GetMethods(BindingFlags.Static | BindingFlags.Public)
                    .Where(o => o.Name == "GroupBy" && o.GetGenericArguments().Length == 2 && o.GetParameters().Length == 2)
                    .Single();
        }

        public static IEnumerable GroupBy(Type t, Type k, object datalist, object keyselector)
        {
            return MethodInfo_GroupBy_Source_KeySelector.MakeGenericMethod(t, k).Invoke(null, new object[] { datalist, keyselector }) as IEnumerable;
        }

        /// <summary>
        /// 获取所有属性
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <returns></returns>
        public static PropertyInfo[] getProperties<T>(T t)
        {
            PropertyInfo[] props = null;

            if (t == null)
            {
                return props;
            }
            props = t.GetType().GetProperties(BindingFlags.Instance | BindingFlags.Public);

            return props;
        }

        /// <summary>
        /// 获得字符串形式的属性列表
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="t"></param>
        /// <returns></returns>
        public static string GetPropertyInfo<T>(T t)
        {
            StringBuilder sb = new StringBuilder();
            var props = getProperties(t);
            foreach (var item in props)
            {
                string name = item.Name;
                try
                {
                    object value = item.GetValue(t, null);
                    if (item.PropertyType.IsValueType || item.PropertyType.Name.StartsWith("String"))
                    {
                        sb.AppendLine(string.Format("{0}:{1}", name, value));
                    }
                    else
                    {
                        GetPropertyInfo(value);
                    }
                }
                catch (Exception ex)
                {


                }
            }
            return sb.ToString();
        }

        public static PropertyInfo[] GetPropertyInfoArray<T>()
        {
            PropertyInfo[] props = null;
            try
            {
                Type type = typeof(T);
                object obj = Activator.CreateInstance(type);
                props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            }
            catch (Exception ex)
            { }
            return props;
        }


    }
}
