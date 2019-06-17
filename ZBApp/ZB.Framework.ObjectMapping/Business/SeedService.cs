using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Transactions;

namespace ZB.Framework.ObjectMapping
{
    public class SeedPool
    {
        public SeedPool() { }

        public TableMapping Table { get; internal set; }

        public int SeedValue { get; internal set; }

        public int MaxSeedValue { get; internal set; }
    }

    public class SeedService
    {
        public static readonly SeedService Instance = new SeedService();

        private SeedService()
        {
            SeedPoolDict = new Dictionary<string, SeedPool>();
        }

        private Dictionary<string, SeedPool> SeedPoolDict;

        private int? GetFactorySeed(DatabaseEngine db, TableMapping table)
        {
            object seed = db.ExecuteScalar(string.Format("select top 1  seed from tableseed where tablename='{0}'", db.GetTableName(table.Name)));
            return (seed == DBNull.Value) ? null : (int?)seed;
        }

        public void ClearSeed(TableMapping table)
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            string PoolName = string.Format("{0}_{1}", db.DatabaseSession.DatabaseName, db.GetTableName(table.Name));
            lock(this)
            {
                using (DatabaseScope ds = new DatabaseScope().BeginTransaction(TransactionScopeOption.RequiresNew))
                {
                    DatabaseEngine newdb = DatabaseEngineFactory.GetNewDatabaseEngine(db.DatabaseSession.DatabaseName);
                    newdb.DatabaseSession.MappingTable = db.DatabaseSession.MappingTable;
                    newdb.ExecuteNonQuery(string.Format("delete from tableseed where tablename='{0}'", db.GetTableName(table.Name)));

                    if (SeedPoolDict.ContainsKey(PoolName))
                        SeedPoolDict.Remove(PoolName);

                    ds.Complete();
                }
            }
        }

        public int GetSeed(TableMapping table, int SeedPoolSize = 100)
        {

            SeedPool pool = null;
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            lock (this)
            {
                string PoolName = string.Format("{0}_{1}", db.DatabaseSession.DatabaseName, db.GetTableName(table.Name));
                if (SeedPoolDict.ContainsKey(PoolName))
                    pool = SeedPoolDict[PoolName];      //从种子缓存加载种子值
                else
                {
                    //初始化种子缓存
                    int SeedValue = 0;
                    int CurTableMaxSeed = db.GetMaxSeed(table, 0);  //从数据库表中获取当前记录中已使用的最大种子值，如果没有记录则使用默认种子值(0)

                    using (DatabaseScope ds = new DatabaseScope().BeginTransaction(TransactionScopeOption.RequiresNew))
                    {
                        DatabaseEngine newdb = DatabaseEngineFactory.GetNewDatabaseEngine(db.DatabaseSession.DatabaseName);
                        newdb.DatabaseSession.MappingTable = db.DatabaseSession.MappingTable;
                        int? FactorySeed = GetFactorySeed(newdb, table);
                        if (FactorySeed.HasValue) 
                            SeedValue = FactorySeed.Value;
                        else
                        {
                            SeedValue = CurTableMaxSeed;
                            newdb.ExecuteNonQuery(string.Format("insert into tableseed values('{0}',{1})", db.GetTableName(table.Name), SeedValue));
                        }
                            
                        ds.Complete();
                    }

                    pool = new SeedPool();
                    pool.Table = table;
                    pool.SeedValue = pool.MaxSeedValue = SeedValue;
                    SeedPoolDict[PoolName] = pool;
                }
            }

            lock (pool)
            {
                if (pool.SeedValue >= pool.MaxSeedValue)
                {
                    using (DatabaseScope ds = new DatabaseScope().BeginTransaction(TransactionScopeOption.RequiresNew))
                    {
                        DatabaseEngine newdb = DatabaseEngineFactory.GetNewDatabaseEngine(db.DatabaseSession.DatabaseName);
                        newdb.DatabaseSession.MappingTable = db.DatabaseSession.MappingTable;
                        string strSQL = string.Format("update tableseed set seed=seed+{0} where tablename='{1}'", SeedPoolSize, newdb.GetTableName(table.Name));

                        int ret = newdb.ExecuteNonQuery(strSQL);
                        if (ret != 1)
                            throw new ObjectMappingException(string.Format("GetSeed Failed -> \"{0}\"", strSQL));
                        pool.MaxSeedValue = GetFactorySeed(newdb, table).Value;
                        ds.Complete();
                    }
                    pool.SeedValue = pool.MaxSeedValue - SeedPoolSize;
                }

                return ++pool.SeedValue;
            }

        }
    }
}
