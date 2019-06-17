using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data;

namespace ZB.Framework.ObjectMapping
{
    public static class DatabaseEngineFactory
    {
        private static Dictionary<string, EnumDatabaseEngineType> DBTypeDict = new Dictionary<string, EnumDatabaseEngineType>();
        private static object LockedObject = new object();

        public static DatabaseEngine GetDatabaseEngine(bool isIgnoreDatabaseName = true)
        {
            return GetDatabaseEngine(string.Empty, isIgnoreDatabaseName);
        }

        public static DatabaseEngine GetNewDatabaseEngine(string databasename)
        {
            lock (LockedObject)
            {
                DatabaseEngine engine = null;
                EnumDatabaseEngineType enginetype = GetDatabaseEngineType(databasename);
                switch (enginetype)
                {
                    case EnumDatabaseEngineType.Sql2005: engine = new Sql2005DatabaseEngine(); break;
                    case EnumDatabaseEngineType.Sql2008: engine = new Sql2008DatabaseEngine(); break;
                    case EnumDatabaseEngineType.Sql2012: engine = new Sql2012DatabaseEngine(); break;
                    case EnumDatabaseEngineType.GenericDatabase: engine = new GenericDatabaseEngine(); break;
                }
                DatabaseSession session = new DatabaseSession(databasename);
                engine.DatabaseSession = session;

                return engine;
            }
        }

        public static DatabaseEngine GetDatabaseEngine(string databasename,bool isIgnoreDatabaseName = true)
        {
            lock (LockedObject)
            {
                if (string.IsNullOrWhiteSpace(databasename))
                    databasename = string.Empty;

                DatabaseSession session = null;
                if(isIgnoreDatabaseName == true)
                    session = DatabaseScopeManager.Instance.GetCurrentDatabaseSession();
                else
                    session = DatabaseScopeManager.Instance.GetCurrentDatabaseSession(databasename);
                DatabaseEngine engine = null;
                EnumDatabaseEngineType enginetype = GetDatabaseEngineType(databasename);
                switch (enginetype)
                {
                    case EnumDatabaseEngineType.Sql2005:engine = new Sql2005DatabaseEngine();break;
                    case EnumDatabaseEngineType.Sql2008: engine = new Sql2008DatabaseEngine(); break;
                    case EnumDatabaseEngineType.Sql2012: engine = new Sql2012DatabaseEngine(); break;
                    case EnumDatabaseEngineType.GenericDatabase:engine = new GenericDatabaseEngine();break;
                }

                if (engine != null)
                {
                    if (session == null)
                        session = new DatabaseSession(databasename);
                    engine.DatabaseSession = session;
                }
                else
                    throw new ObjectMappingException("not find database engine");

                return engine;
            }
        }

        internal static EnumDatabaseEngineType GetDatabaseEngineType(string databasename)
        {
            lock (LockedObject)
            {
                if (string.IsNullOrWhiteSpace(databasename))
                    databasename = string.Empty;

                EnumDatabaseEngineType databasetype = EnumDatabaseEngineType.GenericDatabase;
                if (DBTypeDict.ContainsKey(databasename))
                    return DBTypeDict[databasename];
                else
                {
                    Database database = null;
                    if (string.IsNullOrWhiteSpace(databasename))
                        database = DatabaseFactory.CreateDatabase();
                    else
                        database = DatabaseFactory.CreateDatabase(databasename);

                    if (database is SqlDatabase)
                    {
                        string version = (string)database.ExecuteScalar(CommandType.Text, "select @@version");
                        if (version.IndexOf("Microsoft SQL Server 2008") == 0)
                        {
                            databasetype = EnumDatabaseEngineType.Sql2008;
                            DBTypeDict.Add(databasename, databasetype);
                        }
                        else if (version.IndexOf("Microsoft SQL Server 2005") == 0)
                        {
                            databasetype = EnumDatabaseEngineType.Sql2005;
                            DBTypeDict.Add(databasename, databasetype);
                        }
                        else if (version.IndexOf("Microsoft SQL Server 2012") == 0)
                        {
                            databasetype = EnumDatabaseEngineType.Sql2012;
                            DBTypeDict.Add(databasename, databasetype);
                        }
                        else
                            throw new ObjectMappingException("not support sqlserver version -> " + version);
                    }
                    else if (database is GenericDatabase)
                    {
                        databasetype = EnumDatabaseEngineType.GenericDatabase;
                        DBTypeDict.Add(databasename, databasetype);
                    }
                }
                return databasetype;
            }
        }
    }
}
