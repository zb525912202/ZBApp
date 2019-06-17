using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public interface ISqlSelectColumns<T> where T : ObjectMappingBase
    {
        SqlSelectColumns<T> Columns
        {
            get;
        }
    }
}
