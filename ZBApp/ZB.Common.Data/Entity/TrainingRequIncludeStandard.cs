using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingRequIncludeStandard:ObjectMappingBase<TrainingRequIncludeStandard, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int RequId { get; set; }
        				
		[Column]
        public int CategoryId { get; set; }
        				
		[Column]
        public int? SubjectId { get; set; }
        				
		[Column]
        public int? StandardId { get; set; }
         
    }
}

