using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Caching;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 时效性缓存基类
    /// </summary>
    public abstract class PeriodCacheManagerBase<Key, Value>        
    {
        protected CacheManager CacheManagerInstance;
        protected IEqualityComparer<Key> KeyComparer;

        public PeriodCacheManagerBase(string cacheManagerName, IEqualityComparer<Key> keyComparer = null)
        {
            this.CacheManagerInstance = CacheFactory.GetCacheManager(cacheManagerName) as CacheManager;
            this.KeyComparer = keyComparer;
        }

        /// <summary>
        /// 从数据库中获得对象
        /// </summary>
        protected abstract Value GetObjFromDB(Key key);

        /// <summary>
        /// 从数据库中获得一批对象
        /// </summary>
        protected abstract Dictionary<Key, Value> GetObjListFromDB(List<Key> keyList);

        public Value GetObj(Key key)
        {
            string keyStr = key.ToString();
            if (this.CacheManagerInstance.Contains(keyStr))
            {
                return (Value)this.CacheManagerInstance.GetData(keyStr);
            }
            else
            {
                Value val = this.GetObjFromDB(key);
                this.CacheManagerInstance.Add(keyStr, val);                
                return val;
            }
        }

        public void ReloadObj(Key key)
        {
            string keyStr = key.ToString();
            if (this.CacheManagerInstance.Contains(keyStr))            
                this.CacheManagerInstance.Remove(keyStr);

            this.GetObj(key);
        }

        public List<Value> GetObjList(List<Key> keyList)
        {
            Dictionary<Key, Value> cacheValDic = this.GetObjDic(keyList);

            List<Value> valList = new List<Value>();//按keyList的顺序返回值列表
            foreach (Key key in keyList)
            {
                if (cacheValDic.ContainsKey(key))
                {
                    valList.Add(cacheValDic[key]);
                }
            }

            return valList;
        }

        /// <summary>
        /// 注意,键值对和传入的顺序是不相同的,如果要相同,请用GetObjList().ToDictionary（）
        /// </summary>
        public Dictionary<Key, Value> GetObjDic(List<Key> keyList)
        {
            Dictionary<Key, Value> cacheValDic;
            if (this.KeyComparer == null)            
                cacheValDic = new Dictionary<Key, Value>();
            else
                cacheValDic = new Dictionary<Key, Value>(this.KeyComparer);

            List<Key> dbKeyList = new List<Key>();
            var keySet = keyList.Distinct(this.KeyComparer);//去除重复元素
            foreach (Key key in keySet)
            {
                string keyStr = key.ToString();
                if (this.CacheManagerInstance.Contains(keyStr))
                {
                    Value val = (Value)this.CacheManagerInstance.GetData(keyStr);
                    cacheValDic.Add(key, val);
                }
                else
                {
                    dbKeyList.Add(key);
                }
            }
            Dictionary<Key, Value> dbValDic = this.GetObjListFromDB(dbKeyList);

            if (dbValDic.Count == dbKeyList.Count)
            {
                foreach (var obj in dbValDic)
                {
                    string keyStr = obj.Key.ToString();
                    this.CacheManagerInstance.Add(keyStr, obj.Value);
                    cacheValDic.Add(obj.Key, obj.Value);
                }

                return cacheValDic;
            }
            else
            {
                throw new ApplicationException("没有查找到所有的值,dbValDic.Count != dbKeyList.Count");
            }
        }

        public void Remove(Key key)
        {
            this.CacheManagerInstance.Remove(key.ToString());
        }
    }
}

//asdfasd