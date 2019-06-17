using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public static class DbHelper
    {
        public static ObjectMappingQuery<T> Query<T>() where T : ObjectMappingBase
        {
            return new ObjectMappingQuery<T>();
        }

        public static int DeleteById<T>(object id) where T : ObjectMappingBase
        {
            return DatabaseEngineFactory.GetDatabaseEngine().DeleteById<T>(id);
        }

        public static int DeleteByIds<T>(string column, IList<int> ids) where T : ObjectMappingBase
        {
            return DatabaseEngineFactory.GetDatabaseEngine().DeleteByIds<T>(column, ids);
        }

        public static int DeleteByIds<T>(string column, string ids) where T : ObjectMappingBase
        {
            return DatabaseEngineFactory.GetDatabaseEngine().DeleteByIds<T>(column, ids);
        }

        public static int ExecuteNonQuery(string commandText, int timeoutSecond = 30)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteNonQuery(commandText, timeoutSecond);
        }

        public static TElement ExecuteScalar<TElement>(string commandText, params Parameter[] parameters)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteScalar<TElement>(commandText, parameters);
        }

        public static object ExecuteScalar(string commandText)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteScalar(commandText);
        }

        public static int ExecuteStoreCommand(string storeCommandText, params object[] parameters)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteStoreCommand(storeCommandText, parameters);
        }

        public static int ExecuteStoreCommand(params StoreCommand[] storeCommands)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteStoreCommand(storeCommands);
        }

        public static List<TElement> ExecuteQuery<TElement>(string commandText, int timeoutSecond = 30)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteQuery<TElement>(commandText, timeoutSecond);
        }

        public static List<TElement> ExecuteQuery<TElement>(string commandText, params Parameter[] paras)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteQuery<TElement>(commandText, paras);
        }

        public static List<TElement> ExecuteQuery<TElement>(StoreCommand sc)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().ExecuteQuery<TElement>(sc);
        }

        public static void BulkCopy<T>(IList<T> list, Dictionary<string, object> bulkCopyConfig = null) where T : ObjectMappingBase
        {
            DatabaseEngineFactory.GetDatabaseEngine().BulkCopy<T>(list, bulkCopyConfig);
        }

        public static string CorrectLikeConditionValue(object val, string StrPrefix, string StrSuffix)
        {
            return DatabaseEngineFactory.GetDatabaseEngine().CorrectLikeConditionValue(val, StrPrefix, StrSuffix);
        }
    }
}
