using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

namespace ZB.Framework.ObjectMapping
{
    public class RetrieveCriteria<T> : ISqlCondition<T>, ISqlSelectColumns<T>, ISqlOrder<T> where T : ObjectMappingBase
    {
        public RetrieveCriteria()
        {
            this.Conditions = new SqlCondition<T>();
            this.Columns = new SqlSelectColumns<T>();
            this.Orders = new SqlOrder<T>();
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        internal TableMapping TableMapping { get; private set; }

        public SqlCondition<T> Conditions { get; set; }

        public SqlSelectColumns<T> Columns { get; private set; }

        public SqlOrder<T> Orders { get; private set; }

        public string ViewName { get; set; }

        public int Top { get; set; }

        public void Clear()
        {
            this.Top = 0;
            this.ViewName = string.Empty;
            this.Conditions.Clear();
            this.Orders.Clear();
            this.Columns.Clear();
        }

        public T FirstOrDefault()
        {
            int topsaved = this.Top;
            try
            {
                this.Top = 1;
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                return db.Load<T>(this).FirstOrDefault();
            }
            finally
            {
                this.Top = topsaved;
            }
        }

        public List<T> ToList()
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            return db.Load<T>(this);
        }
    }
}
