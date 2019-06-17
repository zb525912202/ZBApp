using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    public interface IAddinAsyncCommand : IAddinCommand
    {
        Action OnComplete { get; set; }
    }
}
