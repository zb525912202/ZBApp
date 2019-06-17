using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;

namespace ZB.Framework.Utility
{
    public class ZBMutexHelper
    {
        /// <summary>
        /// 运行一个同步基元
        /// </summary>
        public static void RunMutex(string mutexName, Action action)
        {
            using (Mutex mutex = new Mutex(false, mutexName))
            {
                mutex.WaitOne();
                try
                {
                    if (action != null)
                        action();
                }
                finally
                {
                    mutex.ReleaseMutex();
                }
            }
        }
    }
}
