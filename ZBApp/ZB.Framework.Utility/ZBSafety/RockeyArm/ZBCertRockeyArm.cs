using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Utility
{
    public class ZBCertRockeyArm : ZBSecrecyObjBase
    {
        /// <summary>
        /// 过期日期
        /// </summary>
        public DateTime? EmpowerDate { get; set; }

        /// <summary>
        /// 最大培训员数量
        /// </summary>
        public int OperatorLimit { get; set; }

        public static void LoadBytes(SmartObjectSerializer serializer, ZBCertRockeyArm obj)
        {
            ZBSecrecyObjBase.LoadBytes(serializer, obj);
            
            serializer.Write(obj.EmpowerDate);
            serializer.Write(obj.OperatorLimit);
        }

        public static void LoadObj(SmartObjectDeserializer deserializer, ZBCertRockeyArm obj)
        {
            ZBSecrecyObjBase.LoadObj(deserializer, obj);
            
            obj.EmpowerDate = deserializer.ReadNullableDateTime();
            obj.OperatorLimit = deserializer.ReadInt32();
        }

        public override string GetInfo()
        {
            return string.Format("客户Id:{0}\r\n客户:{1}\r\n过期时间:{2}\r\n最大培训员数量:{3}",
                                this.CustomerKey,
                                this.CustomerName,
                                this.EmpowerDate.HasValue ? this.EmpowerDate.Value.ToLongDateString() : "无限期",
                                this.OperatorLimit);
        }        
    }
}
