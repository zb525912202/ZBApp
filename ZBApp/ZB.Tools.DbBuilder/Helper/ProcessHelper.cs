using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;

namespace ZB.Tools.DbBuilder
{
    public static class ProcessHelper
    {
        public static string RunDosCommand(params string[] cmds)
        {
            using (Process process = new Process())
            {
                process.StartInfo.FileName = "cmd.exe";
                process.StartInfo.UseShellExecute = false;
                process.StartInfo.RedirectStandardInput = true;
                process.StartInfo.RedirectStandardOutput = true;
                process.StartInfo.RedirectStandardError = true;
                process.StartInfo.CreateNoWindow = true;

                process.Start();
                foreach (var cmd in cmds)
                {
                    process.StandardInput.WriteLine(cmd);
                }

                process.StandardInput.WriteLine("exit");

                string output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();
                return output;
            }
        }

        public static string StopSQLServer(string sqlServerVersion)
        {
            string stopSQLAgent = string.Format("net stop SQLAgent${0}", sqlServerVersion);
            string stopMSSQL = string.Format("net stop MSSQL${0}", sqlServerVersion);
            return ProcessHelper.RunDosCommand(new string[] { stopSQLAgent, stopMSSQL });
        }

        public static string StartSQLServer(string sqlServerVersion)
        {
            string startSQLAgent = string.Format("net start SQLAgent${0}", sqlServerVersion);
            string startMSSQL = string.Format("net start MSSQL${0}", sqlServerVersion);
            return ProcessHelper.RunDosCommand(new string[] { startMSSQL, startSQLAgent });
        }

        public static string StopIIS()
        {
            return ProcessHelper.RunDosCommand(new string[] { "net stop w3svc" });
        }

        public static string StartIIS()
        {
            return ProcessHelper.RunDosCommand(new string[] { "net start w3svc" });
        }
    }
}
