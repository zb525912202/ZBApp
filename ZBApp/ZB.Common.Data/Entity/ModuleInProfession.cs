using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class ModuleInProfession:ObjectMappingBase<ModuleInProfession, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int ModuleId { get; set; }
        				
		[Column]
        public int ProfessionId { get; set; }
         
    }
}

