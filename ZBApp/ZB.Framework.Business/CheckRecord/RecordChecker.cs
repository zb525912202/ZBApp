using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public class RecordChecker<T>
        where T : ObjectMappingBase<T, int>
    {
        private class RecordObj<ObjT>
           where ObjT : ObjectMappingBase<ObjT, int>
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

        public Action<RecordCheckResult<T>> DeleteAction { get; set; }
        public Action<RecordCheckResult<T>> UpdateAction { get; set; }
        public Action<RecordCheckResult<T>> CreateAction { get; set; }


        /// <summary>
        /// 比较新、旧记录，获得一个表中需要增、删、改的检查结果
        /// </summary>
        private RecordCheckResult<T> CheckRecord(IList<T> recordList, string parentIdColumn, int parentId, Func<T, T, bool> isSameObj)
        {
            string sql = string.Format("SELECT * FROM {0} WHERE {1}={2}"
                                        , typeof(T).Name
                                        , parentIdColumn
                                        , parentId);
            List<T> oldRecordList = DbHelper.ExecuteQuery<T>(sql);

            RecordCheckResult<T> result = new RecordCheckResult<T>();

            foreach (var record in recordList)
            {
                bool isContains = false;

                foreach (var oldRecord in oldRecordList)
                {
                    if (isSameObj(record, oldRecord))
                    {
                        isContains = true;
                        break;
                    }
                }

                if (isContains)
                    result.UpdateList.Add(record);
                else
                    result.CreateList.Add(record);
            }

            var tableMapping = MappingService.Instance.GetTableMapping(typeof(T));

            foreach (var oldRecord in oldRecordList)
            {
                bool isContains = false;

                foreach (var obj in recordList)
                {
                    if (isSameObj(obj, oldRecord))
                    {
                        isContains = true;
                        break;
                    }
                }

                if (!isContains)
                {
                    int oldId = (int)tableMapping.ColumnPK.GetValue(oldRecord);
                    result.DeleteIdList.Add(oldId);
                }
            }

            return result;
        }

        /// <summary>
        /// 比较新、旧记录，获得一个表中需要增、删、改的检查结果
        /// </summary>
        private RecordCheckResult<T> CheckRecord(IList<T> recordList, string parentIdColumn, int parentId)
        {
            string sql = string.Format("SELECT {0} FROM {1} WHERE {2}={3}"
                                        , this.IdColumnName
                                        , typeof(T).Name
                                        , parentIdColumn
                                        , parentId);
            List<int> oldIdList = DbHelper.ExecuteQuery<int>(sql);
            var oldIdHs = new HashSet<int>(oldIdList);

            RecordCheckResult<T> result = new RecordCheckResult<T>();

            List<RecordObj<T>> objList = new List<RecordObj<T>>();

            PropertyInfo idProperty = typeof(T).GetProperty(this.IdColumnName);
            HashSet<int> idHsTemp = new HashSet<int>();
            foreach (var record in recordList)
            {
                int recordId = (int)idProperty.GetValue(record, null);
                if (recordId > 0)
                    idHsTemp.Add(recordId);

                objList.Add(new RecordObj<T>() { Id = recordId, Record = record });
            }

            foreach (var obj in objList)
            {
                if (obj.Id == 0)
                {
                    result.CreateList.Add(obj.Record);
                }
                else
                {
                    if (oldIdHs.Contains(obj.Id))
                        result.UpdateList.Add(obj.Record);
                    else
                        result.CreateList.Add(obj.Record);
                }
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
        private void Execute(RecordCheckResult<T> result)
        {
            if (this.DeleteAction == null)
                DbHelper.DeleteByIds<T>(this.IdColumnName, result.DeleteIdList);
            else
                this.DeleteAction(result);

            if (this.UpdateAction == null)
                result.UpdateList.ForEach(updateObj => updateObj.Update());
            else
                this.UpdateAction(result);

            if (this.CreateAction == null)
                DbHelper.BulkCopy(result.CreateList);
            else
                this.CreateAction(result);
        }

        /// <summary>
        /// 执行检查结果
        /// </summary>
        public void CheckExecute(IList<T> recordList, string parentIdColumn, int parentId, Func<T, T, bool> isSameObj)
        {
            var result = this.CheckRecord(recordList, parentIdColumn, parentId);
            this.Execute(result);
        }

        /// <summary>
        /// 执行检查结果
        /// </summary>
        public void CheckExecute(IList<T> recordList, string parentIdColumn, int parentId)
        {
            var result = this.CheckRecord(recordList, parentIdColumn, parentId);
            this.Execute(result);
        }
    }
}
