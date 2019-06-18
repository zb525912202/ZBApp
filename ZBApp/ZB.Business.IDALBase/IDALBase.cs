using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZB.Framework.ObjectMapping;

namespace ZB.Common.IDAL
{
    public interface IDALBase< T, PK>
    {

        DatabaseScope GetDatabaseScope();

        IEnumerable<T> LoadAll();

        T Find(PK id);

        void Delete(PK id);

        void Create(T t);

        void Update(T t);

        void BulkCopy(IEnumerable<T> objList);
    }
}
