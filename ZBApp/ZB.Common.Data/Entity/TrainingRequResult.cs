using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingRequResult:ObjectMappingBase<TrainingRequResult, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int RequId { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public string EmployeeName { get; set; }
        				
		[Column]
        public int StandardId { get; set; }
        				
		[Column]
        public string StandarName { get; set; }
        				
		[Column]
        public int StandarLevel { get; set; }
        				
		[Column]
        public string StandarLevelName { get; set; }
        				
		[Column]
        public bool IsUpLevel { get; set; }
        				
		[Column]
        public DateTime RequSubmitTime { get; set; }
         
    }
}

