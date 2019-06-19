using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class AbilityItemCategory:ObjectMappingBase<AbilityItemCategory, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int StandardId { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public string ItemKind { get; set; }
        				
		[Column]
        public string Number { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
         
    }
}

