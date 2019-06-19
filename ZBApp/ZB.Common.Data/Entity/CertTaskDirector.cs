using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class CertTaskDirector:ObjectMappingBase<CertTaskDirector, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int CertTaskId { get; set; }
        				
		[Column]
        public int DirectorId { get; set; }
        				
		[Column]
        public string DirectorName { get; set; }
         
    }
}

