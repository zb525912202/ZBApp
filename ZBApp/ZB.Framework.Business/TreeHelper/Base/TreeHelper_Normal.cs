using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;

namespace ZB.Framework.Business
{
    internal class TreeHelper_Normal : TreeHelper_LevelProperty<ILevel>
    {
        #region SingleTon
        private static readonly TreeHelper_Normal instance = new TreeHelper_Normal();
        public static TreeHelper_Normal Instance { get { return instance; } }
        private TreeHelper_Normal() { }
        #endregion

        protected override IList<ILevel> GetObjChildren(ILevel obj)
        {
            return obj.NChildren;
        }
    }
}
