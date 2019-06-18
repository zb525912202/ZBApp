using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.ObjectMapping;
namespace ZB.Common.Data
{
	[Table]
    public  partial class UserAccount:ObjectMappingBase<UserAccount, int>
    {
						
		[Column(IsPK=true,IsAutoIncrement = true)]
        public int Id { get; set; }
        				
		[Column]
        public int EmployeeId { get; set; }
        				
		[Column]
        public string ObjectName { get; set; }
        				
		[Column]
        public string Password { get; set; }
        				
		[Column]
        public DateTime LastLogin { get; set; }
        				
		[Column]
        public DateTime LastChangePassword { get; set; }
        				
		[Column]
        public byte[] Profile { get; set; }
         
    }
}

