using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class FriendLink:ObjectMappingBase<FriendLink, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public string FriendLinkTitle { get; set; }
        				
		[Column]
        public string FriendLinkUrl { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
        				
		[Column]
        public bool IsLoginShow { get; set; }
         
    }
}

