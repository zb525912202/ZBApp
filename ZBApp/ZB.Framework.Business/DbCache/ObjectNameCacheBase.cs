using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using System.Data.Objects;
using System.Transactions;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// IObjectName接口的对象缓存
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class ObjectNameCacheBase<T> : DBCacheBase<int,T>
        where T : ObjectMappingBase<T, int>, IObjectName
    {
        protected bool IsHaveSameName(int id, string name)
        {
            foreach (T objTemp in this.ObjectDict.Values)
            {
                if (objTemp.Id != id && objTemp.ObjectName == name)
                {
                    return true;
                }
            }
            return false;
        }

        public bool Rename(int id, string newName, bool isAllowSameName = false)
        {
            if (this.ObjectDict.ContainsKey(id) && this.ObjectDict[id].ObjectName != newName)
            {
                if (!isAllowSameName)
                {
                    if (this.IsHaveSameName(id, newName))
                    {
                        return false;
                    }
                }
                UpdateCriteria<T> updater = new UpdateCriteria<T>();
                updater.UpdateColumn(ConstDB.__ObjectName, newName);
                updater.Conditions.AddEqualTo(ConstDB.__Id, id);
                updater.Perform();
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
