using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using ZB.Framework.Utility;
using System.Collections.ObjectModel;

namespace ZB.Framework.Business
{
    public interface IStringTree<T>
    {
        string ObjectName { get; set; }
        string FullPath { get; set; }
        string ParentFullPath { get; set; }

        ObservableCollection<T> Children { get; set; }
    }

    public class StringTreeNode : NotifyBase, IStringTree<StringTreeNode>
    {
        private string _ObjectName;
        public string ObjectName
        {
            get { return _ObjectName; }
            set
            {
                _ObjectName = value;
                this.RaisePropertyChanged("ObjectName");
            }
        }

        private string _FullPath;
        public string FullPath
        {
            get { return _FullPath; }
            set
            {
                _FullPath = value;
                this.RaisePropertyChanged("FullPath");
            }
        }

        private string _ParentFullPath;
        public string ParentFullPath
        {
            get { return _ParentFullPath; }
            set
            {
                _ParentFullPath = value;
                this.RaisePropertyChanged("ParentFullPath");
            }
        }

        private ObservableCollection<StringTreeNode> _Children;
        public ObservableCollection<StringTreeNode> Children
        {
            get { return _Children ?? (_Children = new ObservableCollection<StringTreeNode>()); }
            set
            {
                _Children = value;
                this.RaisePropertyChanged("Children");
            }
        }

        private bool _IsExpanded;
        public bool IsExpanded
        {
            get { return _IsExpanded; }
            set
            {
                _IsExpanded = value;
                this.RaisePropertyChanged("IsExpanded");
            }
        }
    }

    public class StringTreeHelper
    {
        public static ObservableCollection<StringTreeNode> GetStringTree(IEnumerable<string> stringList, char splitChar, Action<Dictionary<string, StringTreeNode>> nodeDicAction = null)
        {
            return GetStringTree<StringTreeNode>(stringList, splitChar, nodeDicAction);
        }

        /// <summary>
        /// 一组字符串生成树结构
        /// </summary>
        public static ObservableCollection<T> GetStringTree<T>(IEnumerable<string> stringList, char splitChar, Action<Dictionary<string, T>> folderDicAction = null)
            where T : IStringTree<T>, new()
        {
            ObservableCollection<T> folderList = new ObservableCollection<T>();

            Dictionary<string, int> folderFullPathdic = stringList.Distinct().ToDictionary(r => r, r => 0);
            Dictionary<string, T> folderDic = new Dictionary<string, T>();

            foreach (var folderFullPath in folderFullPathdic.Keys)
            {
                Dictionary<string, string> dic = folderFullPath.StringSplit(splitChar);

                IOrderedEnumerable<KeyValuePair<string, string>> descLengthList = dic.OrderByDescending(s => s.Key.Length);
                int descLengthListCount = descLengthList.Count();
                for (int j = 0; j < descLengthListCount; j++)
                {
                    string curFullPath = descLengthList.ElementAt(j).Key;
                    var tmpfullpath = curFullPath + splitChar.ToString();
                    if (folderDic.ContainsKey(tmpfullpath))
                    {
                        break;
                    }
                    else
                    {
                        T folder = new T()
                        {
                            ObjectName = dic[curFullPath],
                            FullPath = curFullPath,
                        };
                        folder.ParentFullPath = (descLengthListCount - 1 == j) ? string.Empty : descLengthList.ElementAt(j + 1).Key + splitChar.ToString();
                        folderDic[tmpfullpath] = folder;
                    }
                }
            }

            foreach (var item in folderDic.Values)
            {
                string parentFullPath = item.ParentFullPath;
                if (folderDic.ContainsKey(parentFullPath))
                {
                    folderDic[parentFullPath].Children.Add(item);
                }
                else
                {
                    folderList.Add(item);
                }
            }
            if (folderDicAction != null)
                folderDicAction(folderDic);

            return folderList;
        }

        /// <summary>
        /// 将树形结构的对象转换成平行结构的对象,不包含根节点
        /// </summary>
        public static IEnumerable<T> GenerateParallelStruct<T>(T parentNode) where T : IStringTree<T>
        {
            foreach (T item in parentNode.Children)
            {
                yield return item;
                foreach (var subNode in GenerateParallelStruct<T>(item))
                {
                    yield return subNode;
                }
            }
        }

        /// <summary>
        /// 将多根树行结构对象转换成平行结构的对象，包含根节点
        /// </summary>
        public static IEnumerable<T> GenerateParallelMultiRootStruct<T>(IEnumerable<T> nodes) where T : IStringTree<T>
        {
            List<T> temp = new List<T>();

            temp.AddRange(nodes);

            foreach (var node in nodes)
            {
                temp.AddRange(GenerateParallelStruct(node));
            }

            return temp.AsEnumerable();
        }

        /// <summary>
        /// 遍历树
        /// </summary>
        public static void ForEachTree<T>(IEnumerable<T> treeList, Action<T> nodeAction) where T : IStringTree<T>
        {
            foreach (T node in treeList)
            {
                nodeAction(node);
                ForEachTree(node.Children, nodeAction);
            }
        }


    }
}