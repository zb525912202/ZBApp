using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingSubject:ObjectMappingBase<TrainingSubject, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public string Number { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int SubjectCategory { get; set; }
        				
		[Column]
        public int TrainingMode { get; set; }
        				
		[Column]
        public decimal TrainingPeriod { get; set; }
        				
		[Column]
        public string TrainingGoal { get; set; }
        				
		[Column]
        public string AddInfo1 { get; set; }
        				
		[Column]
        public string AddInfo2 { get; set; }
        				
		[Column]
        public string AssessMode { get; set; }
         
    }
}

