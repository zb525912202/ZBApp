using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class AttachFileLibary:ObjectMappingBase<AttachFileLibary, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ObjectType { get; set; }
        				
		[Column]
        public int ObjectId { get; set; }
        				
		[Column]
        public string AttachName { get; set; }
        				
		[Column]
        public string SourceFileName { get; set; }
        				
		[Column]
        public string DisplayFileName { get; set; }
        				
		[Column]
        public bool IsPreview { get; set; }
         
    }
}

