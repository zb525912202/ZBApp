using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class CertRejectInfo:ObjectMappingBase<CertRejectInfo, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public int SortIndex { get; set; }
         
    }
}
