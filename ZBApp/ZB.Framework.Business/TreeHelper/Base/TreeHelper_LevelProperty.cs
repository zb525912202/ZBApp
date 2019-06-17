using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace ZB.Framework.Business
{
    internal abstract class TreeHelper_LevelProperty<T> : TreeHelperBase<T>
        where T : ILevelProperty, ISortable
    {
        public void ComputeSumRecord(T node)
        {
            node.SumRecord = node.Record;

            foreach (T subNode in this.GetObjChildren(node))
            {
                ComputeSumRecord(subNode);

                node.SumRecord += subNode.SumRecord;
            }
        }

        public void ComputeSumRecord(IList<T> objList)
        {
            foreach (var node in objList)
            {
                ComputeSumRecord(node);
            }
        }

        public void SortChildren(IList<T> objList)
        {
            List<ObservableCollection<T>> childrenList = new List<ObservableCollection<T>>();

            foreach (T obj in objList)
            {
                IList<T> children = this.GetObjChildren(obj);
                IOrderedEnumerable<T> iter = children.OrderBy(f => f.SortIndex);
                List<T> sortList = iter.ToList<T>();
                children.Clear();
                foreach (T objTemp in sortList)
                {
                    children.Add(objTemp);
                }
            }
        }

        public IList<T> GenerateTreeStruct(IList<T> objList, bool isComputeSumRecord = true)
        {
            IList<T> treeList = this.GenerateTree(objList);

            foreach (var obj in treeList)
            {
                obj.IsExpanded = true;
            }

            if (isComputeSumRecord)
            {
                this.ComputeSumRecord(treeList);
            }

            this.SortChildren(treeList);

            return treeList;
        }
    }
}
