using ZB.AppShell.Addin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    [CodonName("TableExtend")]
    public class TableExtendCodon : AbstractCodon
    {
        public override object BuildItem(object caller, object parent)
        {
            TableExtend tableextend = new TableExtend();
            tableextend.ObjectType = AddinService.Instance.CreateClassType(this.Class);
            tableextend.Id = this.ID;
            return tableextend;
        }
    }

    public class TableExtend
    {
        public string Id { get; set; }

        public Type ObjectType { get; set; }

        public List<TableExtendColumn> Columns { get; private set; }

        public Dictionary<string, TableExtendColumn> ColumnDict { get; private set; }

        public Dictionary<string, TableExtendColumn> NameDict { get; private set; }

        public TableExtend()
        {
            this.Columns = new List<TableExtendColumn>();
            this.NameDict = new Dictionary<string, TableExtendColumn>();
            this.ColumnDict = new Dictionary<string, TableExtendColumn>();
        }

        public void AddColumn(TableExtendColumn column)
        {
            this.NameDict.Add(column.Name, column);
            this.ColumnDict.Add(column.ColumnName, column);
            this.Columns.Add(column);
        }
    }
}
