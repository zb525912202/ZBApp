using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class DataEntityTableDefine
    {
        public DataEntityTableDefine()
        {
            IsAutoIncrementPK = true;
        }

        public string Table { get; set; }
        public bool IsAutoIncrementPK { get; set; }
        public bool IsUseSeedFactoryPK { get; set; }

        public string DataEntityTypeName { get; set; }

        public string PkColumn { get; set; }
        public string SortColumn { get; set; }

        public string FullPathColumn { get; set; }
        public string ParentColumn { get; set; }
        public bool IsAutoCreateDefaultChild { get; set; }

        public string TypeColumn { get; set; }
        public int TypeColumnValue { get; set; }


        public int MaxDepth { get; set; }

        public string TextColumn { get; set; }

        public string Database { get; set; }

        public string FilterCondition { get; set; }
    }
}
