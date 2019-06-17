using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects;
using ZB.Framework.Utility;
using System.Transactions;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public class BrSortableHelper
    {
        public static void UpdateSortIndex<T>(string tableName, IList<T> objList)
            where T : ObjectMappingBase<T, int>, ISortable
        {
            if (objList.Count > 0)
            {
                string commandText = string.Format("UPDATE [{0}] SET SortIndex={{0}} WHERE Id={{1}}", tableName);

                List<StoreCommand> scList = new List<StoreCommand>();
                foreach (ISortable obj in objList)
                {
                    scList.Add(new StoreCommand(commandText, obj.SortIndex, obj.Id));
                }

                DbHelper.ExecuteStoreCommand(scList.ToArray());
            }
        }

        public static void UpdateSortIndex<T>(IList<T> objList)
            where T : ObjectMappingBase<T, int>, ISortable
        {
            UpdateSortIndex(typeof(T).Name, objList);
        }

        public static void UpdateSortIndex<T>(Dictionary<int, T> objDic, IList<T> objList)
            where T : ObjectMappingBase<T, int>, ISortable
        {
            List<T> changeObjList = new List<T>();

            for (int i = 0; i < objList.Count; i++)
            {
                T obj = objList[i];
                if (objDic.ContainsKey(obj.Id))
                {
                    if (objDic[obj.Id].SortIndex != obj.SortIndex)
                    {
                        changeObjList.Add(obj);
                    }
                }
            }

            UpdateSortIndex<T>(changeObjList);
        }
    }
}
