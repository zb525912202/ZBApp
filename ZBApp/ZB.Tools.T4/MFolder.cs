using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class MFolder:ObjectMappingBase<MFolder, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ParentId { get; set; }
        				
		[Column]
        public int ProCategoryId { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public string FullPath { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public string Comment { get; set; }
        				
		[Column]
        public DateTime? CreateTime { get; set; }
        				
		[Column]
        public int? CreatorId { get; set; }
        				
		[Column]
        public string CreatorName { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
         
    }
}

