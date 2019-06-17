using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.Practices.EnterpriseLibrary.Data;
using System.Data.Common;

namespace ZB.Framework.ObjectMapping
{
    public class DatabaseSession
    {
        public DatabaseSession(string databasename)
        {
            this.DatabaseName = databasename;

            if (string.IsNullOrEmpty(databasename))
                Database = DatabaseFactory.CreateDatabase();
            else
                Database = DatabaseFactory.CreateDatabase(databasename);

            DbContext = new ObjectMappingDbContext(Database.CreateConnection());
        }

        public string DatabaseName {get; private set;}

        public Database Database {get;private set;}

        public ObjectMappingDbContext DbContext {get;private set;}

        //-----------------------------------------------------------------------------------------------------------------------------------------
        internal Dictionary<string, string> MappingTable = new Dictionary<string, string>();

        public string GetMappingTable(string tablename)
        {
            if (MappingTable.ContainsKey(tablename))
                return MappingTable[tablename];
            else
                return tablename;
        }

        public void SetMappingTable<TElement>(string tablename) where TElement : ObjectMappingBase
        {
            TableMapping table = MappingService.Instance.GetTableMapping(typeof(TElement));
            MappingTable[table.Name] = tablename;
        }

        public void SetMappingTable(string SrcTableName, string DstTableName)
        {
            MappingTable[SrcTableName] = DstTableName;
        }
        //-----------------------------------------------------------------------------------------------------------------------------------------
    }
}
