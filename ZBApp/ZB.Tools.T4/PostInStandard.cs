using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class PostInStandard:ObjectMappingBase<PostInStandard, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int PostId { get; set; }
        				
		[Column]
        public int StandardId { get; set; }
         
    }
}

