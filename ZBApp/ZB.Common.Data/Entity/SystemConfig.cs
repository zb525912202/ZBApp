using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class SystemConfig:ObjectMappingBase<SystemConfig, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public string GroupName { get; set; }
        				
		[Column]
        public string ItemName { get; set; }
        				
		[Column]
        public byte[] ItemValue { get; set; }
         
    }
}

