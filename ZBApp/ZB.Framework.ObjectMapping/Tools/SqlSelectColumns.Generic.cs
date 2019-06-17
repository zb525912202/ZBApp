using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;

namespace ZB.Framework.ObjectMapping
{
    public class SqlSelectColumns<T> : SqlSelectColumns where T : ObjectMappingBase
    {
        public SqlSelectColumns()
        {
            this.NotSelectColumns = new ObservableCollection<string>();
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        public ObservableCollection<string> NotSelectColumns { get; private set; }

        internal TableMapping TableMapping { get; private set; }

        public void AddSelectProperty(string propertyname)
        {
            ColumnMapping column = this.TableMapping.GetColumnMappingByPropertyName(propertyname);
            if (column == null)
                throw new ObjectMappingException("not find column");
            this.AddSelectColumn(column.Name);
        }

        public void AddNotSelectProperty(string propertyname)
        {
            ColumnMapping column = this.TableMapping.GetColumnMappingByPropertyName(propertyname);
            if (column == null)
                throw new ObjectMappingException("not find column");
            this.AddNotSelectColumn(column.Name);
        }

        public void AddNotSelectColumn(string column)
        {
            this.NotSelectColumns.Add(column);
        }

        public override void Clear()
        {
            base.Clear();
            this.NotSelectColumns.Clear();
        }
    }
}
