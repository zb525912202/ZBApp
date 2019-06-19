using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class ProfessionCategory:ObjectMappingBase<ProfessionCategory, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int Level { get; set; }
        				
		[Column]
        public string Code { get; set; }
        				
		[Column]
        public int SystemId { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
        				
		[Column]
        public int LockStatus { get; set; }
        				
		[Column]
        public int ProCategoryType { get; set; }
         
    }
}

