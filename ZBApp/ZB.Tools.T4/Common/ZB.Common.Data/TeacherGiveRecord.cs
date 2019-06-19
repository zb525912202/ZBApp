using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TeacherGiveRecord:ObjectMappingBase<TeacherGiveRecord, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public string GiveInfo { get; set; }
        				
		[Column]
        public DateTime StartDate { get; set; }
        				
		[Column]
        public DateTime? EndDate { get; set; }
        				
		[Column]
        public decimal CiveHour { get; set; }
         
    }
}

