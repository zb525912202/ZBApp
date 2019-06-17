using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects;
using ZB.Framework.Utility;
using System.Threading;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// DataEntry类型的对象缓存
    /// </summary>
    public abstract class DBCacheBase<TKey, TValue>
    {
        private ReaderWriterLockSlim _ReadWriteLocker = new ReaderWriterLockSlim();

        public int Version { get; private set; }

        /// <summary>
        /// 读写锁
        /// </summary>
        public ReaderWriterLockSlim ReadWriteLocker
        {
            get { return _ReadWriteLocker; }
            set { _ReadWriteLocker = value; }
        }

        /// <summary>
        /// 在写锁释放的时候执行
        /// </summary>
        public virtual void AfterWriteLockerDispose()
        {
            //默认写锁关闭前刷新所有数据
            this.ResetCache();

            this.UpdateVersion();
        }

        private void UpdateVersion()
        {
            //缓存版本号累加
            if (this.Version == int.MaxValue)
                this.Version = 0;
            else
                this.Version++;
        }

        /// <summary>
        ///获得读锁 
        /// </summary>
        public ReadCacheTransaction<TKey, TValue> ReadLocker()
        {
            return new ReadCacheTransaction<TKey, TValue>(this);
        }

        /// <summary>
        /// 获得写锁
        /// </summary>
        public WriteCacheTransaction<TKey, TValue> WriteLocker(bool isResetCache = true)
        {
            return new WriteCacheTransaction<TKey, TValue>(this, isResetCache);
        }

        protected Dictionary<TKey, TValue> ObjectDict = new Dictionary<TKey, TValue>();//以DIC来进行对象缓存

        /// <summary>
        /// 加载所有的缓存对象
        /// </summary>
        protected abstract void LoadAllObject();

        /// <summary>
        /// 刷新分布式缓存
        /// </summary>
        protected abstract void RefDistributedCached();

        public Dictionary<TKey, TValue>.ValueCollection Values
        {
            get { return this.ObjectDict.Values; }
        }

        public TValue this[TKey key]
        {
            get
            {
                return ObjectDict[key];
            }
            set
            {
                ObjectDict[key] = value;
            }
        }

        private bool IsInit = true;
        public DBCacheBase()
        {
            try
            {
                this.IsInit = true;
                this.ResetCache();
                this.IsInit = false;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// 重置缓存,重置缓存的同时通知其他分布式缓存刷新
        /// </summary>
        public virtual void ResetCache()
        {
            this.ObjectDict.Clear();
            this.LoadAllObject();

            try
            {
                if (!this.IsInit)
                {
                    //初次加载时，并不通知分布式缓存刷新
                    this.RefDistributedCached();
                }
            }
            catch
            {
                //忽略刷新分布式缓存的异常
            }
        }

        /// <summary>
        /// 分布式缓存接收到刷新通知时，调用刷新方法
        /// </summary>
        public virtual void RefCache()
        {
            this.ObjectDict.Clear();
            this.LoadAllObject();
            this.UpdateVersion();
        }

        public TValue GetObjectById(TKey key)
        {
            if (this.ObjectDict.ContainsKey(key))
                return this.ObjectDict[key];
            else
                return default(TValue);
        }

        public bool ContainsId(TKey key)
        {
            return this.ObjectDict.ContainsKey(key);
        }

        protected void Add(TKey key, TValue val)
        {
            this.ObjectDict.Add(key, val);
        }

        protected void Remove(TKey key)
        {
            this.ObjectDict.Remove(key);
        }

        public List<TKey> GetIdList()
        {
            return this.ObjectDict.Keys.ToList<TKey>();
        }

        /// <summary>
        /// 获得对象集合
        /// </summary>
        public virtual List<TValue> GetAllObjectList()
        {
            return this.ObjectDict.Values.ToList();
        }

        /// <summary>
        /// 获得对象字典
        /// </summary>
        public virtual Dictionary<TKey, TValue> GetAllObjectDic()
        {
            return this.ObjectDict;
        }
    }

    public class ReadCacheTransaction<TKey, TValue> : IDisposable
    {
        private DBCacheBase<TKey, TValue> Cache;

        public ReadCacheTransaction(DBCacheBase<TKey, TValue> cache)
        {
            Cache = cache;
            Cache.ReadWriteLocker.EnterReadLock();//进入读锁
        }

        public void Dispose()
        {
            Cache.ReadWriteLocker.ExitReadLock();//关闭读锁
        }
    }

    public class WriteCacheTransaction<TKey, TValue> : IDisposable
    {
        private DBCacheBase<TKey, TValue> Cache;
        private bool IsDoAfterDispose = false;//是否执行AfterDispose方法

        public WriteCacheTransaction(DBCacheBase<TKey, TValue> cache, bool isDoAfterDispose)
        {
            this.Cache = cache;
            this.IsDoAfterDispose = isDoAfterDispose;
            this.Cache.ReadWriteLocker.EnterWriteLock();//进入写锁
        }

        public void Dispose()
        {
            if (this.IsDoAfterDispose)
            {
                this.Cache.AfterWriteLockerDispose();
            }

            this.Cache.ReadWriteLocker.ExitWriteLock();//关闭写锁
        }
    }
}