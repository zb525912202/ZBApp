using System;
using System.Net;
using System.Windows;

using System.Linq;
using ZB.AppShell.Addin;
using System.Runtime.Serialization;
using System.Collections.Generic;

namespace ZB.Framework.Business
{
    [CodonName("DbDataSource")]
    public class DbDataSourceCodon : AbstractCodon
    {
        [XmlMemberAttribute("database", IsRequired = true)]
        public string DataBaseName { get; set; }

        [XmlMemberAttribute("table", IsRequired = true)]
        public string TableName { get; set; }

        [XmlMemberAttribute("idcolumn", IsRequired = true)]
        public string IDColumn { get; set; }

        [XmlMemberAttribute("textcolumn", IsRequired = true)]
        public string TextColumn { get; set; }

        [XmlMemberAttribute("sortcolumn")]
        public string SortColumn { get; set; }

        [XmlMemberAttribute("parentcolumn")]
        public string ParentColumn { get; set; }

        [XmlMemberAttribute("fullpathcolumn")]
        public string FullPathColumn { get; set; }

        [XmlMemberAttribute("filter")]
        public string FilterCondition { get; set; }

        public override object BuildItem(object caller, object parent)
        {
            DbDataSource ds = new DbDataSource();
            ds.Name = this.ID;
            ds.DataBaseName = this.DataBaseName;
            ds.TableName = this.TableName;
            ds.IDColumn = this.IDColumn;
            ds.TextColumn = this.TextColumn;
            ds.SortColumn = this.SortColumn;
            ds.FilterCondition = this.FilterCondition;
            ds.ParentColumn = this.ParentColumn;
            ds.FullPathColumn = this.FullPathColumn;
            return ds;
        }
    }

    [DataContract(IsReference = true)]
    public class DbDataSource : SmartDataSource
    {
        /// <summary>
        /// 数据库
        /// </summary>
        public string DataBaseName { get; set; }

        /// <summary>
        /// 表名
        /// </summary>
        public string TableName { get; set; }

        /// <summary>
        /// 关键列
        /// </summary>
        public string IDColumn { get; set; }

        /// <summary>
        /// 显示文本列
        /// </summary>
        public string TextColumn { get; set; }

        /// <summary>
        /// 排序列
        /// </summary>
        public string SortColumn { get; set; }

        /// <summary>
        /// 父节点列
        /// </summary>
        public string ParentColumn { get; set; }

        /// <summary>
        /// 全路径
        /// </summary>
        public string FullPathColumn { get; set; }

        /// <summary>
        /// 过滤条件
        /// </summary>
        public string FilterCondition { get; set; }

        /// <summary>
        /// 是否已加载数据
        /// </summary>
        public bool IsDataLoaded { get; set; }

        public DataSourceItem FindItemByFullPath(string fullpath)
        {
            if (string.IsNullOrEmpty(this.ParentColumn))
                throw new NotSupportedException();

            if (string.IsNullOrWhiteSpace(fullpath))
                return null;

            DataSourceItem resultItem = null;

            resultItem = ForEachTree(DataSourceItems, fullpath);

            return resultItem;

            //var paths = fullpath.Split('/');
            //DataSourceItem tempDataItem = null;
            //foreach (var temp in paths)
            //{
            //    var path = temp.Trim();
            //    if (string.IsNullOrEmpty(path) || path == "/")
            //        continue;
            //    if (tempDataItem == null)
            //        tempDataItem = DataSourceItems.FirstOrDefault(o => o.Text == path);
            //    else
            //        tempDataItem = tempDataItem.DataSourceItems.FirstOrDefault(o => o.Text == path);

            //    if(tempDataItem == null)
            //        break;
            //}
            // return tempDataItem;
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public DataSourceItem ForEachTree(List<DataSourceItem> itemList, string fullPath)
        {
            foreach (DataSourceItem item in itemList)
            {
                if (item.FullPath == fullPath)
                {
                    return item;
                }
                var result = ForEachTree(item.DataSourceItems, fullPath);
                if (result != null)
                    return result;
            }
            return null;
        }
    }
}
