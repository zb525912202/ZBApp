using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region Truncate<TElement>()
        public virtual int Truncate<TElement>() where TElement : ObjectMappingBase
        {
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(typeof(TElement));
            string strSQL = string.Format("truncate table {0}", this.GetTableName(tablemapping.Name));
            return this.ExecuteNonQuery(strSQL);
        }
        #endregion

        public virtual bool IsTableExsit(string tablename) 
        {
            throw new ObjectMappingException("DatabaseEngine not support IsTableExsit");
        }

        public virtual void DropTable(string tablename)
        {
            throw new ObjectMappingException("DatabaseEngine not support DropTable");
        }
    }
}
