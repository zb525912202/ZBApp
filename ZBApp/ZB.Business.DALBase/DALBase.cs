using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZB.Common.IDAL;
using ZB.Framework.ObjectMapping;

namespace ZB.Business.DALBase
{
    public class DALBase<T, PK> : IDALBase<T, PK>
        where T : ObjectMappingBase<T, PK>
    {
        protected bool IsIgnoreDatabaseName { get; }
        protected string DBName { get; private set; }

        public DALBase(string dBName = "CommonModelContainer", bool isIgnoreDatabaseName=true)
        {
            this.IsIgnoreDatabaseName = isIgnoreDatabaseName;
            this.DBName = dBName;
        }

        public DatabaseScope GetDatabaseScope()
        {
            var scope =new DatabaseScope(this.DBName, IsIgnoreDatabaseName);
          
            return scope;
        }

        public virtual void BulkCopy(IEnumerable<T> objList)
        {
            using (var ts = this.GetDatabaseScope().BeginTransaction())
            {
                DbHelper.BulkCopy<T>(objList.ToList());
                ts.Complete();
            }
        }

        public virtual void Create(T t)
        {
            using (var ts = GetDatabaseScope().BeginTransaction())
            {
                t.Create();
                ts.Complete();
            }
        }

        public virtual void Delete(PK id)
        {
            using (var ts = GetDatabaseScope().BeginTransaction())
            {
                DbHelper.DeleteById<T>(id);
                ts.Complete();
            }
        }

        public virtual void DeleteByIds(IEnumerable<int> ids)
        {
            using (var ts = GetDatabaseScope().BeginTransaction())
            {
                string pk = MappingHelper.GetPKColumnName<T>();
                if (ids.Count() > 0)
                {
                    DbHelper.DeleteByIds<T>(pk, ids.ToList());
                }
                ts.Complete();
            }
        }

        public virtual T Find(PK id)
        {
            using (GetDatabaseScope())
            {
                return DbHelper.ExecuteQuery<T>(string.Format(@"SELECT * FROM {0} WHERE Id={1}", typeof(T).Name, id)).FirstOrDefault();
            }
        }



        public virtual IEnumerable<T> LoadAll()
        {
            using (GetDatabaseScope())
            {
                return DbHelper.ExecuteQuery<T>(string.Format(@"SELECT * FROM {0}", typeof(T).Name));
            }
        }

        public virtual void Update(T t)
        {
            using (var ts = GetDatabaseScope().BeginTransaction())
            {
                t.Update();
                ts.Complete();
            }
        }


    }
}
