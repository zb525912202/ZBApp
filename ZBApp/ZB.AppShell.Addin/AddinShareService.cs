using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.AppShell.Addin
{
    public class AddinShareService
    {
        private AddinShareService()
        {
            this.SharedObjectDict = new Dictionary<string, object>();
        }

        public static readonly AddinShareService Instance = new AddinShareService();

        private Dictionary<string, object> SharedObjectDict;

        public object BuildNodeItem(AddinTreeNode node,object caller, object parent)
        {
            if (node.Codon.Share)
            {
                if(SharedObjectDict.ContainsKey(node.AddinFullPath))
                    return SharedObjectDict[node.AddinFullPath];
                else
                {
                    object obj = node.Codon.BuildItem(caller, parent);
                    SharedObjectDict[node.AddinFullPath] = obj;
                    return obj;
                }
            }
            else
                return node.Codon.BuildItem(caller, parent);
        }
    }
}
