using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class EmployeeInEmployeeGroup:ObjectMappingBase<EmployeeInEmployeeGroup, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeGroupId { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
         
    }
}

