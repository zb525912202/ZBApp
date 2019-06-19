using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class Trainer:ObjectMappingBase<Trainer, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int DeptId { get; set; }
        				
		[Column]
        public int LeaderType { get; set; }
        				
		[Column]
        public bool IsTrainer { get; set; }
        				
		[Column]
        public bool IsManageTrain { get; set; }
        				
		[Column]
        public int ManageType { get; set; }
         
    }
}

