using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class CertTypeLevel:ObjectMappingBase<CertTypeLevel, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int CertTypeId { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
         
    }
}

