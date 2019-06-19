using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class IPBlackList:ObjectMappingBase<IPBlackList, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public string StartIP { get; set; }
        				
		[Column]
        public string EndIP { get; set; }
         
    }
}

