using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    internal class TreeHelper_Usual<T> : TreeHelperBase<T>
        where T : IParent
    {
        private Func<T, IList<T>> GetObjChildrenFunc = null;

        public TreeHelper_Usual(Func<T, IList<T>> getObjChildrenFunc)
        {
            this.GetObjChildrenFunc = getObjChildrenFunc;
        }

        protected override IList<T> GetObjChildren(T obj)
        {
            if (GetObjChildrenFunc != null)
                return GetObjChildrenFunc(obj);
            else
                return null;
        }
    }
}
