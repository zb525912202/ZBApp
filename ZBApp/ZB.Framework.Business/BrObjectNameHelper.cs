using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public static class BrObjectNameHelper
    {
        public static string GetNewName(List<string> nameList,string defaultName)
        {
            string nodeName = defaultName;
            int exName = 0;

            while (true)
            {
                bool isContainsName = false;
                foreach (string name in nameList)
                {
                    if (name == nodeName)
                    {
                        isContainsName = true;
                        break;
                    }
                }

                if (!isContainsName) break;

                nodeName = defaultName + (++exName).ToString();
            }

            return nodeName;
        }
    }
}
