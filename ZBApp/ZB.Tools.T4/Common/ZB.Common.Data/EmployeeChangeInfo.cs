using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class EmployeeChangeInfo:ObjectMappingBase<EmployeeChangeInfo, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public DateTime ChangeDate { get; set; }
        				
		[Column]
        public int BeforeDeptId { get; set; }
        				
		[Column]
        public int BeforePostId { get; set; }
        				
		[Column]
        public int AfterDeptId { get; set; }
        				
		[Column]
        public int AfterPostId { get; set; }
        				
		[Column]
        public int AuditDeptId { get; set; }
        				
		[Column]
        public int AuditStatus { get; set; }
        				
		[Column]
        public int? CreatorId { get; set; }
        				
		[Column]
        public string CreatorName { get; set; }
         
    }
}

