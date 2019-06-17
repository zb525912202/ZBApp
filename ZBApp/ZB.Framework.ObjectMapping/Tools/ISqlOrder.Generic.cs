using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public interface ISqlOrder<T> where T : ObjectMappingBase
    {
        SqlOrder<T> Orders
        {
            get;
        }
    }
}
