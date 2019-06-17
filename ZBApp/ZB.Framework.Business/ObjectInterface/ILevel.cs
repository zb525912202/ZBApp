using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Collections;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    public interface ILevelTreeViewBase
    {
        void Checked(object sender);
    }

    public interface IParent : IObjectName
    {
        int ParentId { get; set; }
        string FullPath { get; set; }
    }



    public interface ICheck
    {
        bool? IsChecked { get; set; }
    }

    public interface ILevelProperty : ISortable, IParent, ICheck
    {
        /// <summary>
        /// 该节点下包含的资源数量
        /// </summary>
        int Record { get; set; }

        /// <summary>
        /// 该节点及子节点说包含的资源数量
        /// </summary>
        int SumRecord { get; set; }

        /// <summary>
        /// 表示该对象是否是正被拖动的当前对象
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is drop item; otherwise, <c>false</c>.
        /// </value>
        bool IsDropItem { get; set; }

        /// <summary>
        /// 节点是否进入编辑状态
        /// </summary>
        bool IsInEditMode { get; set; }

        /// <summary>
        /// 是否虚拟加载
        /// </summary>
        bool IsLoadOnDemandEnabled { get; set; }

        bool IsExpanded { get; set; }

        bool IsEnabled { get; set; }

        /// <summary>
        /// 是否高亮关键字
        /// </summary>
        bool IsHighLight { get; set; }

        bool IsContainsKeyWord { get; set; }

        bool IsHidden { get; set; }

        int SharedMode { get; set; }

        bool IsExistParent { get; set; }
    }

    public interface ILevelBase<T>
    {
        ObservableCollection<T> Children { get; set; }
    }

    public interface ILevelBase
    {
        ObservableCollection<ILevel> NChildren { get; set; }
    }

    public interface ILevel<T> : ILevelBase<T>, ILevelProperty 
        where T : ILevel<T>
    {
    }

    public interface ILevel : ILevelBase, ILevelProperty
    {
        int NodeType { get; set; }
    }
}
