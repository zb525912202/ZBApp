using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class ModuleLevel:ObjectMappingBase<ModuleLevel, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ModuleId { get; set; }
        				
		[Column]
        public int MasteryLevel { get; set; }
        				
		[Column]
        public int? Level { get; set; }
         
    }
}

