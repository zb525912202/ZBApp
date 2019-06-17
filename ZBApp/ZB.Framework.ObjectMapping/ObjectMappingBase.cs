using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

#if !SILVERLIGHT
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
#endif

using System.Linq.Expressions;
using System.Runtime.Serialization;

using ZB.Framework.Utility;


namespace ZB.Framework.ObjectMapping
{
#if !SILVERLIGHT
    [Serializable]
#endif
    [DataContract(IsReference = true)]
    public abstract class ObjectMappingBase : DataEntry { }

#if !SILVERLIGHT
    [Serializable]
#endif    
    [DataContract(IsReference = true, Name = "ObjectMappingBase_Generic{0}")]
    public class ObjectMappingBase<T, PK> : ObjectMappingBase where T : ObjectMappingBase
    {
        public T ObjectClone()
        {
            return this.MemberwiseClone() as T;
        }

#if !SILVERLIGHT
        public static DbQuery<T> DbSet
        {
            get
            {
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                return db.DbSet<T>();
            }
        }

        public static DbSet<T> DbSetTracking
        {
            get
            {
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                return db.DbSetTracking<T>();
            }
        }

        public static IOrderedQueryable<T> DbSetRandom
        {
            get
            {
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                DbQuery<T> dbSet = db.DbSet<T>();
                return dbSet.OrderBy(o => Guid.NewGuid());
            }
        }

        public static IOrderedQueryable<T> DbSetRandomTracking
        {
            get
            {
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                DbSet<T> dbSet = db.DbSetTracking<T>();
                return dbSet.OrderBy(o => Guid.NewGuid());
            }
        }

        /// <summary>
        /// 清空表
        /// </summary>
        public static int Truncate()
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            return db.Truncate<T>();
        }

        /// <summary>
        /// 批量删除
        /// </summary>
        public static int Delete(Expression<Func<T, bool>> condition)
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            DbQuery<T> DbSet = db.DbSet<T>();
            return db.Delete(DbSet, condition);
        }

        /// <summary>
        /// 批量更新
        /// </summary>
        public static int Update(Expression<Func<T>> source, Expression<Func<T, bool>> condition)
        {
            HashSet<string> updateproplist = ExpressionHelper.GetExpression_PropertyList(source);

            if (updateproplist.Count == 0)
                throw new ObjectMappingException("not any property updated!");

            Func<T> fun = source.Compile();
            T updateobj = fun();
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            DbQuery<T> DbSet = db.DbSet<T>();
            return db.Update(DbSet, updateobj, condition, updateproplist);
        }

        public static int NewId(int SeedPoolSize = 100)
        {
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(T));
            if (tablemapping.ColumnAutoIncrement != null)
                throw new ObjectMappingException(string.Format("the type of {0} not support NewId()", typeof(T).Name));

            return SeedService.Instance.GetSeed(tablemapping, SeedPoolSize);
        }
#endif
    }
}
