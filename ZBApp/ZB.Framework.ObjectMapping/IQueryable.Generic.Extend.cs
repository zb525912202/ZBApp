using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;
using System.Data.Common;
using System.Text.RegularExpressions;


namespace ZB.Framework.ObjectMapping
{
    public static class IQueryableGenericExtend
    {
        #region OM_ToList

        public static List<TElement> OM_ToList<TElement>(this IQueryable<TElement> source)
        {
            return OM_ToList<TElement>((IQueryable)source);
        }

        public static List<TElement> OM_ToList<TElement>(this IQueryable source)
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            DbCommand command = db.GetLinqCommand(source);
            return db.Load<TElement>(command);
        }

        #endregion

        #region OM_ToDictionary

        internal static Dictionary<TKey, TElement> OM_ToDictionary<TElement, TKey>(this IQueryable<object> source, Expression<Func<TElement, TKey>> keySelector) where TElement : ObjectMappingBase
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            DbCommand command = db.GetLinqCommand(source);
            List<TElement> list = db.Load<TElement>(command);
            return list.ToDictionary(keySelector.Compile());
        }

        public static Dictionary<string, TElement> OM_ToDictionary<TElement>(this IQueryable<object> source, Expression<Func<TElement, string>> keySelector) where TElement : ObjectMappingBase
        {
            return OM_ToDictionary<TElement, string>(source, keySelector);
        }

        public static Dictionary<int, TElement> OM_ToDictionary<TElement>(this IQueryable<object> source, Expression<Func<TElement, int>> keySelector) where TElement : ObjectMappingBase
        {
            return OM_ToDictionary<TElement, int>(source, keySelector);
        }

        public static Dictionary<TKey, TSource> OM_ToDictionary<TSource, TKey>(this IQueryable<TSource> source, Expression<Func<TSource, TKey>> keySelector) where TSource : ObjectMappingBase
        {
            return OM_ToDictionary<TSource, TKey>((IQueryable<object>)source, keySelector);
        }

        #endregion

        #region OM_First

        public static TSource OM_First<TSource>(this IQueryable<TSource> source) where TSource : ObjectMappingBase
        {
            return OM_First(source, null);
        }

        public static TSource OM_First<TSource>(this IQueryable<TSource> source, Expression<Func<TSource, bool>> predicate) where TSource : ObjectMappingBase
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            IQueryable<TSource> query;
            if (predicate == null)
                query = source.Take(1);
            else
                query = source.Where(predicate).Take(1);
            DbCommand command = db.GetLinqCommand(query);
            List<TSource> list = db.Load<TSource>(command);
            return list.First();
        }

        #endregion

        #region OM_FirstOrDefault

        public static TSource OM_FirstOrDefault<TSource>(this IQueryable<TSource> source)
        {
            return OM_FirstOrDefault(source, null);
        }

        public static TSource OM_FirstOrDefault<TSource>(this IQueryable<TSource> source,Expression<Func<TSource, bool>> predicate)
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            IQueryable<TSource> query;
            if(predicate == null)
                query = source.Take(1);
            else
                query = source.Where(predicate).Take(1);

            DbCommand command = db.GetLinqCommand((IQueryable<object>)query);
            List<TSource> list = db.Load<TSource>(command);
            return list.FirstOrDefault();
        }

        #endregion
    }
}
