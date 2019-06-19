using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingSectionInSubject:ObjectMappingBase<TrainingSectionInSubject, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int SectionId { get; set; }
        				
		[Column]
        public int SubjectId { get; set; }
        				
		[Column]
        public int SectionIndex { get; set; }
         
    }
}

