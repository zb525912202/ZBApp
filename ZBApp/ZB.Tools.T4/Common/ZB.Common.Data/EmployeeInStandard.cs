using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class EmployeeInStandard:ObjectMappingBase<EmployeeInStandard, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int StandardId { get; set; }
        				
		[Column]
        public int LevelId { get; set; }
        				
		[Column]
        public bool IsMian { get; set; }
         
    }
}

