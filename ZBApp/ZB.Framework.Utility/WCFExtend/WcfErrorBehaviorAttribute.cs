﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Utility
{
    public sealed class  WcfErrorBehaviorAttribute:WcfBehaviorAttributeBase
    {
        public WcfErrorBehaviorAttribute() : base(typeof(WcfErrorBehavior))
        {

        }

    }
}
