using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;

namespace ZB.Framework.ObjectMapping
{
    [DataContract(IsReference=true)]
    public class SqlSelectColumns
    {
        public SqlSelectColumns()
        {
            this.SelectColumns = new ObservableCollection<string>();
            
        }

        [DataMember]
        public ObservableCollection<string> SelectColumns { get; set; }

        public SqlSelectColumns Clone()
        {
            SqlSelectColumns obj = new SqlSelectColumns();
            foreach (var item in this.SelectColumns)
                obj.SelectColumns.Add(item);
            return obj;
        }
        
        public virtual void Clear()
        {
            this.SelectColumns.Clear();
        }

        public void AddSelectColumn(string column)
        {
            this.SelectColumns.Add(column);
        }
    }
}
