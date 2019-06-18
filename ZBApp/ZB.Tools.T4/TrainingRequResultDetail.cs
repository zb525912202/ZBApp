using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingRequResultDetail:ObjectMappingBase<TrainingRequResultDetail, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int ResultId { get; set; }
        				
		[Column]
        public int RequId { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int TrainingSectionId { get; set; }
        				
		[Column]
        public int ProficiencyLevel { get; set; }
         
    }
}

