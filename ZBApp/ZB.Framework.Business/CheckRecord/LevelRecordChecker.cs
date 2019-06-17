using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public class LevelRecordChecker<T>
        where T : ObjectMappingBase<T, int>, ILevel<T>
    {
        private class RecordObj<ObjT>
            where ObjT : ObjectMappingBase<ObjT, int>, ILevel<ObjT>
        {
            public int Id { get; set; }
            public ObjT Record { get; set; }
        }

        private string _IdColumnName = "Id";
        public string IdColumnName
        {
            get { return _IdColumnName; }
            set { _IdColumnName = value; }
        }

        public Action<LevelRecordCheckResult<T>> DeleteAction { get; set; }
        public Action<LevelRecordCheckResult<T>> UpdateAction { get; set; }

        private LevelRecordCheckResult<T> CheckRecord(List<T> recordTreeList, string parentIdColumn, int parentId)
        {
            var recordList = recordTreeList.GetTotalObjList();

            List<int> oldIdList;

            if (string.IsNullOrEmpty(parentIdColumn))
            {
                oldIdList = ObjectMappingBase<T, int>.DbSet.Select(r => r.Id).ToList();
            }
            else
            {
                string sql = string.Format("SELECT Id FROM {0} WHERE {1}={2}"
                                        , typeof(T).Name
                                        , parentIdColumn
                                        , parentId);
                oldIdList = DbHelper.ExecuteQuery<int>(sql);
            }
            var oldIdHs = new HashSet<int>(oldIdList);

            LevelRecordCheckResult<T> result = new LevelRecordCheckResult<T>(recordTreeList);

            List<RecordObj<T>> objList = new List<RecordObj<T>>();

            HashSet<int> idHsTemp = new HashSet<int>();
            foreach (var record in recordList)
            {
                if (record.Id > 0)
                    idHsTemp.Add(record.Id);

                objList.Add(new RecordObj<T>() { Id = record.Id, Record = record });
            }

            foreach (var obj in objList)
            {
                if (obj.Id == 0 || !oldIdHs.Contains(obj.Id))
                    result.CreateList.Add(obj.Record);
            }

            foreach (var id in oldIdHs)
            {
                if (!idHsTemp.Contains(id))
                    result.DeleteIdList.Add(id);
            }

            return result;
        }

        /// <summary>
        /// 执行检查结果
        /// </summary>
        private void Execute(LevelRecordCheckResult<T> result)
        {
            //重新生成所有节点的FullPath
            result.TreeList.ForEachTree((parentObj, obj) =>
            {
                if (parentObj == null)
                    obj.FullPath = obj.ObjectName;
                else
                    obj.FullPath = string.Format("{0}/{1}", parentObj.FullPath, obj.ObjectName);
            });

            if (this.DeleteAction == null)
                DbHelper.DeleteByIds<T>(this.IdColumnName, result.DeleteIdList);
            else
                this.DeleteAction(result);

            DbHelper.BulkCopy(result.CreateList);

            //重新计算所有节点的ParentId
            result.TreeList.ForEachTree((parentObj, obj) =>
            {
                if (parentObj == null)
                    obj.ParentId = 0;
                else
                    obj.ParentId = parentObj.Id;
            });

            //重新计算所有节点的SortIndex
            for (int i = 0; i < result.TreeList.Count; i++)
            {
                result.TreeList[i].SortIndex = i + 1;
            }
            result.TreeList.ForEachTree((parentObj, obj) =>
            {
                for (int i = 0; i < obj.Children.Count; i++)
                {
                    var child = obj.Children[i];
                    child.SortIndex = i + 1;
                }
            });

            //更新树上的所有节点
            if (this.UpdateAction == null)
            {
                result.TreeList.ForEachTree((parentObj, obj) =>
                {
                    obj.Update();
                });
            }
            else
            {
                this.UpdateAction(result);
            }
        }

        public void CheckExecute(List<T> recordTreeList, string parentIdColumn, int parentId)
        {
            LevelRecordCheckResult<T> result = this.CheckRecord(recordTreeList, parentIdColumn, parentId);
            this.Execute(result);
        }
    }
}
