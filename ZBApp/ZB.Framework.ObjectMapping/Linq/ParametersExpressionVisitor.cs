using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Reflection;
using System.Data.Objects;

namespace ZB.Framework.ObjectMapping
{
    public class ParametersExpressionVisitor : ExpressionVisitor
    {
        public ParametersExpressionVisitor()
        {
            Arguments = new List<object>();
        }

        public List<object> Arguments { get; private set; }

        public override Expression Visit(Expression node)
        {
            return base.Visit(node);
        }

        protected override Expression VisitMember(MemberExpression node)
        {
            if(node.NodeType == ExpressionType.MemberAccess)
            {
                if ((node.Expression == null)
                    || (node.Expression.NodeType == ExpressionType.Constant)
                    || (node.Expression.NodeType == ExpressionType.MemberAccess))
                {
                    Expression tempnode = node.Expression;
                    while (tempnode != null)
                    {
                        if (tempnode.NodeType == ExpressionType.Parameter)
                            return base.VisitMember(node);

                        if (tempnode.NodeType == ExpressionType.Constant)
                            break;
                        else if (tempnode.NodeType == ExpressionType.MemberAccess)
                            tempnode = (tempnode as MemberExpression).Expression;
                        else
                            break;
                    }

                    Delegate d = Expression.Lambda(node).Compile();
                    object ret = d.DynamicInvoke();
                    Type ret_type = ret.GetType();

                    if (ret_type.BaseType == typeof(ObjectQuery))
                    {
                        IQueryable query = ret as IQueryable;
                        ParametersExpressionVisitor visitor = new ParametersExpressionVisitor();
                        visitor.Arguments = this.Arguments;
                        visitor.Visit(query.Expression);
                    }
                    else if (ret_type == typeof(int)
                        || ret_type == typeof(string)
                        || ret_type == typeof(bool)
                        || ret_type == typeof(double)
                        || ret_type == typeof(float)
                        || ret_type == typeof(decimal)
                        || ret_type == typeof(DateTime))
                        this.Arguments.Add(ret);
                }    
            }
            return base.VisitMember(node);
        }
    }
}
