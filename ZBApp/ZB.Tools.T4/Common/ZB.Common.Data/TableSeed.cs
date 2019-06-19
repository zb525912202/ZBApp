using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TableSeed:ObjectMappingBase<TableSeed, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public string TableName { get; set; }
        				
		[Column]
        public int Seed { get; set; }
         
    }
}

