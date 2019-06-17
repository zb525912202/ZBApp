using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class DeleteCriteria : ISqlCondition
    {
        public DeleteCriteria()
        {
            this.Conditions = new SqlCondition();
        }

        public DeleteCriteria(string tablename) : this()
        {
            this.TableName = tablename;
        }

        public string TableName {get;set;}

        public SqlCondition Conditions {get;private set;}

#if !SILVERLIGHT
        public int Perform()
        {
            DatabaseEngine engine = DatabaseEngineFactory.GetDatabaseEngine();
            return engine.Delete(this);
        }
#endif

    }
}
