using System;
using System.Text;

namespace ZB.AppShell.Addin
{
    public interface IAddinEventKey
    {
        void EventFire(object sender, string eventsrc, object olddata, object newdata);
    }
}
