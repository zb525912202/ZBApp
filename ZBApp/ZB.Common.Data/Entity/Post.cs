using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class Post:ObjectMappingBase<Post, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
        				
		[Column]
        public int CategoryId { get; set; }
        				
		[Column]
        public int IsSync { get; set; }
        				
		[Column]
        public int PCategoryId { get; set; }
         
    }
}

