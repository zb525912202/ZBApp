using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class MappingData:ObjectMappingBase<MappingData, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public string GroupKey { get; set; }
        				
		[Column]
        public string Source { get; set; }
        				
		[Column]
        public string Target { get; set; }
         
    }
}

