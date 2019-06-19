using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class AbilityItemLevel:ObjectMappingBase<AbilityItemLevel, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ItemId { get; set; }
        				
		[Column]
        public int LevelId { get; set; }
        				
		[Column]
        public string LevelDesc { get; set; }
         
    }
}
