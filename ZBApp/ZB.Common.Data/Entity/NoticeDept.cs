using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class NoticeDept:ObjectMappingBase<NoticeDept, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int NoticeId { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
         
    }
}

