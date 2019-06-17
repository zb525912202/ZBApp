using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public interface ISqlCondition<T> where T : ObjectMappingBase
    {
        SqlCondition<T> Conditions
        {
            get;
        }
    }
}
