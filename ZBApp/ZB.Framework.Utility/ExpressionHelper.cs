using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Reflection;

namespace ZB.Framework.Utility
{
    public static class ExpressionHelper
    {
        /// <summary>
        /// 返回类似 "o => o.PropertyName" 的表达式
        /// </summary>
        public static LambdaExpression GetExpression_Func_Type_Property(Type t, string propname)
        {
            ParameterExpression exp1 = Expression.Parameter(t, "o");
            Expression exp2 = Expression.Property(exp1, propname);
            return Expression.Lambda(exp2, exp1);
        }

        /// <summary>
        /// 解析表达式"o => new {o.Prop1,o.Prop2,o.Prop3.....}" 的MemberName
        /// </summary>
        public static HashSet<string> GetExpression_PropertyList<T>(Expression<Func<T>> source)
        {
            HashSet<string> updateproplist = new HashSet<string>();

            if (source.Body is MemberInitExpression)
            {
                MemberInitExpression memberInitExpression = source.Body as MemberInitExpression;
                foreach (MemberBinding memberBinding in memberInitExpression.Bindings)
                {
                    updateproplist.Add(memberBinding.Member.Name);
                }
            }

            return updateproplist;
        }

        /// <summary>
        /// 解析表达式"o => o.PropertyName" 的MemberName
        /// </summary>
        public static string GetMemberName(LambdaExpression expression)
        {
            var ret = GetMemberInfo(expression);
            return (ret != null) ? ret.Name : null;
        }

        /// <summary>
        /// 解析表达式"o => o.PropertyName" 的MemberInfo
        /// </summary>
        public static MemberInfo GetMemberInfo(LambdaExpression expression)
        {
            var memberExpression = expression.Body as MemberExpression;
            return memberExpression.Member;
        }
    }
}
