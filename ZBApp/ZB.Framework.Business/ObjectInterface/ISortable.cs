using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public interface ISortable : IObjectName
    {
        /// <summary>
        /// 序号
        /// </summary>
        int SortIndex { get; set; }
    }

    public interface IEditMode
    {
        bool IsInEdit { get; set; }
    }
}
