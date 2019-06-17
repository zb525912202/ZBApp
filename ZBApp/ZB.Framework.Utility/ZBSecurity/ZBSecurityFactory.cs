using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Utility
{
    public static class ZBSecurityFactory
    {
        /// <summary>
        /// 根据版本号创建加(解)密器
        /// </summary>
        public static ZBSecurityBase CreateZBSecurity(byte version)
        {
            if (version == ZBSecurityHelper.VersionNO1)
            {
                return new ZBSecurity_1();
            }

            throw new Exception("无法获得相应的加密器");
        }
    }
}
