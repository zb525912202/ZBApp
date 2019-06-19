using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class Notice:ObjectMappingBase<Notice, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public string Title { get; set; }
        				
		[Column]
        public int CreatorId { get; set; }
        				
		[Column]
        public string CreatorName { get; set; }
        				
		[Column]
        public byte[] Content { get; set; }
        				
		[Column]
        public int HoldDays { get; set; }
        				
		[Column]
        public DateTime CreateDate { get; set; }
        				
		[Column]
        public DateTime StartDate { get; set; }
        				
		[Column]
        public DateTime EndDate { get; set; }
         
    }
}

