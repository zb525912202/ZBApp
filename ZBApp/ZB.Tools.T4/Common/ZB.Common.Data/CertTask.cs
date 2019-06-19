using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class CertTask:ObjectMappingBase<CertTask, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public DateTime FinishDate { get; set; }
        				
		[Column]
        public int CreatorId { get; set; }
        				
		[Column]
        public string CreatorName { get; set; }
         
    }
}

