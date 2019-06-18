using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class EmployeeCertPhoto:ObjectMappingBase<EmployeeCertPhoto, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int EmployeeCertId { get; set; }
        				
		[Column]
        public int EmployeeCertPhotoType { get; set; }
        				
		[Column]
        public byte[] Photo { get; set; }
         
    }
}

