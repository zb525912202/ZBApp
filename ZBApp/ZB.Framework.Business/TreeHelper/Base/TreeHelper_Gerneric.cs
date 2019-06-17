using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace ZB.Framework.Business
{
    internal class TreeHelper_Gerneric<T> : TreeHelper_LevelProperty<T>
        where T : ILevel<T>
    {
        protected override IList<T> GetObjChildren(T obj)
        {
            return obj.Children;
        }
    }
}
