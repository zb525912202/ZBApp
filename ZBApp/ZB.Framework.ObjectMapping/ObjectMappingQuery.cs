using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace ZB.Framework.ObjectMapping
{

    public class ObjectMappingQuery<T> where T : ObjectMappingBase
    {
        public ObjectMappingQuery()
        {
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
            this.TakeCount = 0;
            this.SelectSqls = new List<string>();
            this.OrderBySqls = new List<OrderItem>();
            this.WhereSqls = new List<Tuple<string, object[]>>();
        }

        internal TableMapping TableMapping { get; private set; }

        public int TakeCount { get; set; }
        public string ViewName { get; set; }
        public List<string> SelectSqls { get; private set; }
        public List<OrderItem> OrderBySqls { get; private set; }
        public List<Tuple<string,object[]>> WhereSqls { get; private set; }

        public ObjectMappingQuery<T> View(string view)
        {
            this.ViewName = view;
            return this;
        }

        public ObjectMappingQuery<T> Take(int count)
        {
            this.TakeCount = count;
            return this;
        }

        public ObjectMappingQuery<T> Select(string columns)
        {
            this.SelectSqls.Add(columns);
            return this;
        }

        public ObjectMappingQuery<T> OrderBy(string column, EnumOrderMode ordermode = EnumOrderMode.NONE)
        {
            this.OrderBySqls.Add(new OrderItem(column,ordermode));
            return this;
        }

        public ObjectMappingQuery<T> Where(string sql, params object[] args)
        {
            this.WhereSqls.Add(new Tuple<string, object[]>(sql, args));
            return this;
        }

        public T FirstOrDefault()
        {
            int topsaved = this.TakeCount;
            try
            {
                this.TakeCount = 1;
                DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
                return db.Load<T>(this).FirstOrDefault();
            }
            finally
            {
                this.TakeCount = topsaved;
            }
        }

        public List<T> ToList()
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            return db.Load<T>(this);
        }
    }
}
