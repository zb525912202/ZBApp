using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class sysdiagrams:ObjectMappingBase<sysdiagrams, int>
    {
						
		[Column]
        public object name { get; set; }
        				
		[Column]
        public int principal_id { get; set; }
        				
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int diagram_id { get; set; }
        				
		[Column]
        public int? version { get; set; }
        				
		[Column]
        public byte[] definition { get; set; }
         
    }
}

