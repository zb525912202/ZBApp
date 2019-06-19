using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class Employee:ObjectMappingBase<Employee, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public string EmployeeNO { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int StatusId { get; set; }
        				
		[Column]
        public int PostId { get; set; }
        				
		[Column]
        public decimal? PostRank { get; set; }
        				
		[Column]
        public int Sex { get; set; }
        				
		[Column]
        public DateTime? Birthday { get; set; }
        				
		[Column]
        public string IdCard { get; set; }
        				
		[Column]
        public DateTime JoinTime { get; set; }
        				
		[Column]
        public int? EmployeeType { get; set; }
        				
		[Column]
        public string OutsideDeptFullPath { get; set; }
        				
		[Column]
        public int ManageEmployeeGroupId { get; set; }
        				
		[Column]
        public string Mobile { get; set; }
        				
		[Column]
        public string Email { get; set; }
        				
		[Column]
        public int IsSync { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
        				
		[Column]
        public string PMSUserId { get; set; }
         
    }
}

