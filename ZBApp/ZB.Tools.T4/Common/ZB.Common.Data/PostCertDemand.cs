using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class PostCertDemand:ObjectMappingBase<PostCertDemand, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int PostId { get; set; }
        				
		[Column]
        public int CertTypeId { get; set; }
        				
		[Column]
        public int? CertTypeLevelId { get; set; }
        				
		[Column]
        public int CertTypeKindId { get; set; }
         
    }
}

