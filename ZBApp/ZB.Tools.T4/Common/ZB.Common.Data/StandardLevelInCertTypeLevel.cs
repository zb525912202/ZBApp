using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class StandardLevelInCertTypeLevel:ObjectMappingBase<StandardLevelInCertTypeLevel, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int CategoryId { get; set; }
        				
		[Column]
        public int StandardLevel { get; set; }
        				
		[Column]
        public int CertTypeId { get; set; }
        				
		[Column]
        public int CertTypeLevel { get; set; }
         
    }
}

