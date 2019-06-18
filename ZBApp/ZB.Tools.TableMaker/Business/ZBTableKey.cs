using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ZB.Tools.TableMaker
{
    public class ZBTableKey
    {
        public string DatabaseName { get; set; }
        public string ConstraintName { get; set; }
        public string TableName { get; set; }
        public string ColumnName { get; set; }

        public override string ToString()
        {
            return ConstraintName;
        }
    }
}
