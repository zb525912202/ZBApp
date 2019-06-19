using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingRequ:ObjectMappingBase<TrainingRequ, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public DateTime StartTime { get; set; }
        				
		[Column]
        public DateTime EndTime { get; set; }
        				
		[Column]
        public DateTime? DataStartTime { get; set; }
        				
		[Column]
        public DateTime? DataEndTime { get; set; }
        				
		[Column]
        public int RequLevel { get; set; }
        				
		[Column]
        public bool IncludeUpLevel { get; set; }
         
    }
}

