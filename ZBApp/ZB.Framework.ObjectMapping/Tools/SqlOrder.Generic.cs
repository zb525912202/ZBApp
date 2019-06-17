using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class SqlOrder<T> : SqlOrder where T : ObjectMappingBase
    {
        public SqlOrder()
        {
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        internal TableMapping TableMapping { get; private set; }

        public void AddProperty(string propertyname, EnumOrderMode ordermode)
        {
            ColumnMapping column = this.TableMapping.GetColumnMappingByPropertyName(propertyname);
            if (column == null)
                throw new ObjectMappingException("not find column");

            this.AddColumn(column.Name, ordermode);
        }
    }
}
