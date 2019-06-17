using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class DeleteCriteria<T> : ISqlCondition<T> where T : ObjectMappingBase
    {
        public DeleteCriteria()
        {
            this.Conditions = new SqlCondition<T>();
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        internal TableMapping TableMapping { get; set; }

        public SqlCondition<T> Conditions { get; private set; }

#if !SILVERLIGHT
        public int Perform()
        {
            DatabaseEngine engine = DatabaseEngineFactory.GetDatabaseEngine();
            return engine.Delete(this);
        }
#endif

    }
}
