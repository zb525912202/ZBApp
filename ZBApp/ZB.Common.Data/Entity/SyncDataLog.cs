using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class SyncDataLog:ObjectMappingBase<SyncDataLog, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ErrorType { get; set; }
        				
		[Column]
        public string ErrorInfo { get; set; }
        				
		[Column]
        public DateTime ErrorDate { get; set; }
        				
		[Column]
        public byte[] ErrorData { get; set; }
         
    }
}

