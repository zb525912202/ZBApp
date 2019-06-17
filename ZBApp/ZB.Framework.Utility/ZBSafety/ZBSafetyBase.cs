using System;
using System.Net;
using System.Text;

namespace ZB.Framework.Utility
{
    public abstract class ZBSafetyBase<T>
        where T : CustomerInfoBase
    {
        public abstract T ReadCustomerInfo(int ZBSystemType, out string error);
        public abstract T ReadCustomerInfo(out string error);

        public abstract void WriteCustomerInfo(T info, out string error);
    }
}
