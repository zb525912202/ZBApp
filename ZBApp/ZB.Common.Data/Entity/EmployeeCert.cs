using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class EmployeeCert:ObjectMappingBase<EmployeeCert, int>
    {
						
		[Column(IsPK=true,IsUseSeedFactory = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public int? CertTaskId { get; set; }
        				
		[Column]
        public string CertNO { get; set; }
        				
		[Column]
        public int CertTypeId { get; set; }
        				
		[Column]
        public int? CertTypeLevelId { get; set; }
        				
		[Column]
        public int CertTypeKindId { get; set; }
        				
		[Column]
        public DateTime GetCertDate { get; set; }
        				
		[Column]
        public DateTime ExpiredDate { get; set; }
        				
		[Column]
        public int? CertPublisherId { get; set; }
        				
		[Column]
        public int ReporterId { get; set; }
        				
		[Column]
        public string ReporterName { get; set; }
        				
		[Column]
        public int AuditState { get; set; }
        				
		[Column]
        public string Remark { get; set; }
        				
		[Column]
        public DateTime CreateTime { get; set; }
         
    }
}

