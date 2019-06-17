using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
#if !SILVERLIGHT
    internal static class SqlHelper
#else
    public static class SqlHelper
#endif
    {
        public static string CorrectLikeParameterValue(object val)
        {
            string strval = val as string;
            if (strval == null)
                strval = string.Empty;
            strval = strval.Replace("~", "~~");
            strval = strval.Replace("%", "~%");
            strval = strval.Replace("[", "~[");
            strval = strval.Replace("]", "~]");
            return strval;
        }
    }
}
