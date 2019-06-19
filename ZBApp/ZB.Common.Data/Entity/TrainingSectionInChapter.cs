using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class TrainingSectionInChapter:ObjectMappingBase<TrainingSectionInChapter, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int SectionId { get; set; }
        				
		[Column]
        public int ChapterId { get; set; }
         
    }
}

