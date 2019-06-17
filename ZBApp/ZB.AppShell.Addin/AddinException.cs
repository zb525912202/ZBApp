using System;
using System.Net;

namespace ZB.AppShell.Addin
{
#if !SILVERLIGHT
    [Serializable]
#endif
    public class AddinException : Exception
    {
        public AddinException(string message) : base(message)
        {

        }

        public AddinException(string message, Exception innerException) : base(message,innerException)
        {

        }
    }
}
