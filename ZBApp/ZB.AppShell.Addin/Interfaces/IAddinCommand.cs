using System;
using System.Text;

namespace ZB.AppShell.Addin
{
    public interface IAddinCommand
    {
        object Owner { get; set; }

        void Run(object sender, System.EventArgs e);
    }
}
