using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class BuzMessage:ObjectMappingBase<BuzMessage, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int TypeId { get; set; }
        				
		[Column]
        public string Text { get; set; }
        				
		[Column]
        public int ObjectId { get; set; }
        				
		[Column]
        public string ObjectMD5 { get; set; }
        				
		[Column]
        public DateTime CreateTime { get; set; }
        				
		[Column]
        public DateTime LastUpdateTime { get; set; }
        				
		[Column]
        public DateTime? ExpirationTime { get; set; }
        				
		[Column]
        public byte[] Attachment { get; set; }
         
    }
}

