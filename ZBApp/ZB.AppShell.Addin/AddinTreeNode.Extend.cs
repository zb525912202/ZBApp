using System;
using System.Net;
using System.Collections.Generic;

namespace ZB.AppShell.Addin
{
    public static class AddinTreeNodeExtend
    {
        public static void BuildCommandItems(this AddinTreeNode addinNode,Action OnComplete = null)
        {
            List<IAddinCommand> CmdList = (List<IAddinCommand>)addinNode.BuildItems(null, null, typeof(IAddinCommand));
            Action CmdAction = null;
            CmdAction = () =>
            {
                if (CmdList.Count > 0)
                {
                    IAddinCommand cmd = CmdList[0];
                    CmdList.Remove(cmd);
                    if (cmd is IAddinAsyncCommand)
                    {
                        IAddinAsyncCommand asynccmd = cmd as IAddinAsyncCommand;
                        asynccmd.OnComplete = () =>
                        {
                            if (AddinService.Instance.IsLoadingError == false)
                                CmdAction();
                        };
                        asynccmd.Run(null, null);
                    }
                    else
                    {
                        cmd.Run(null, null);
                        if (AddinService.Instance.IsLoadingError == false)
                            CmdAction();
                    }
                }
                else
                {
                    if (OnComplete != null)
                        OnComplete();
                }
            };
            CmdAction();
        }
    }
}
