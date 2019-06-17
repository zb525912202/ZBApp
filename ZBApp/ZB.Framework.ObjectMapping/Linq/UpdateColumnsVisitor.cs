using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;

namespace ZB.Framework.ObjectMapping
{
    public class UpdateColumnsVisitor : ExpressionVisitor
    {
        public UpdateColumnsVisitor()
        {
            UpdatePropertys = new HashSet<string>();
        }

        public HashSet<string> UpdatePropertys {get;private set;}

        protected override Expression VisitNew(NewExpression node)
        {
            foreach (var member in node.Members)
            {
                UpdatePropertys.Add(member.Name);
            }
            return base.VisitNew(node);
        }

        protected override Expression VisitMember(MemberExpression node)
        {
            UpdatePropertys.Add(node.Member.Name);

            return base.VisitMember(node);
        }
    }
}
