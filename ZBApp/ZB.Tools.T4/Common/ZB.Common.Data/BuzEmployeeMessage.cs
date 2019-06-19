using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class BuzEmployeeMessage:ObjectMappingBase<BuzEmployeeMessage, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int BuzMessageId { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int EmployeeTypeId { get; set; }
        				
		[Column]
        public DateTime? MarkedTime { get; set; }
        				
		[Column]
        public DateTime LastUpdateTime { get; set; }
        				
		[Column]
        public string Text { get; set; }
        				
		[Column]
        public byte[] Attachment { get; set; }
         
    }
}

