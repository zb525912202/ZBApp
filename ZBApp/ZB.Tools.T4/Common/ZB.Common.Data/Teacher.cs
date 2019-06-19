using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class Teacher:ObjectMappingBase<Teacher, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int TeacherLevelId { get; set; }
        				
		[Column]
        public bool IsOutSideTeacher { get; set; }
         
    }
}

