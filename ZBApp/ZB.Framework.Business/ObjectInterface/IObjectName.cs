using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public interface IObjectName : IObjectId
    {
        string ObjectName { get; set; }
    }
}
