using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Text.RegularExpressions;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        private const int MaxParameterCount = 1800;//最大参数数量

        public DbCommand ConvertStoreCommandToDbCommand(StoreCommand storeCommand)
        {
            Regex regex = new Regex(@"\{(\d+)\}");
            string cmdText = regex.Replace(storeCommand.CommandText, this.GetParameterPrefix() + "Para$1");
            DbCommand dbCmd = this.GetSqlStringCommand(cmdText);
            for (int i = 0; i < storeCommand.Parameters.Length; i++)
            {
                Parameter par = new Parameter("Para" + i.ToString(), storeCommand.Parameters[i]);
                this.AddParameter(dbCmd, par);
            }
            return dbCmd;
        }

        protected int ExecuteBatchStoreCommand(StoreCommand[] storeCommandList, int maxExecuteCount = 100)
        {
            int totalCount = 0;//总影响记录数
            if (maxExecuteCount <= 1)
            {
                foreach(var item in storeCommandList)
                {
                    totalCount += this.ExecuteStoreCommand(item.CommandText, item.Parameters);
                }
            }
            else
            {
                List<StoreCommand> storeCommandListTemp = new List<StoreCommand>();   
                int paramerCount = 0;//参数数量
                for (int i = 0; i < storeCommandList.Length; i++)
                {
                    storeCommandListTemp.Add(storeCommandList[i]);
                    paramerCount += storeCommandList[i].Parameters.Length;

                    if (i == (storeCommandList.Length - 1) || storeCommandListTemp.Count == maxExecuteCount || paramerCount >= MaxParameterCount)
                    {
                        StoreCommand sc = StoreCommandHelper.UnitStoreCommand(storeCommandListTemp);
                        DbCommand dbCmd = ConvertStoreCommandToDbCommand(sc);
                        totalCount += this.ExecuteNonQuery(dbCmd);
                        storeCommandListTemp.Clear();
                        paramerCount = 0;
                    }
                }
            }

            return totalCount;            
        }

        public StoreCommand GetStoreCommand(string strSQL,ParameterCollection paras)
        {
            StoreCommand storecommand = new StoreCommand();
            storecommand.Parameters = new object[paras.Count];

            List<Parameter> tempparas = paras.OrderByDescending(o => o.Name.Length).ToList();

            for (int i = 0; i < tempparas.Count; i++)
            {
                strSQL = strSQL.Replace(string.Format("@{0}", tempparas[i].Name), string.Format("{{{0}}}", i));
                storecommand.Parameters[i] = tempparas[i].Value;
            }
            storecommand.CommandText = strSQL;
            return storecommand;
        }

        public int ExecuteStoreCommand(string storeCommandText, params object[] parameters)
        {
            DbCommand dbCmd = ConvertStoreCommandToDbCommand(new StoreCommand(storeCommandText, parameters));
            return this.ExecuteNonQuery(dbCmd);
        }

        public int ExecuteStoreCommand(params StoreCommand[] storeCommands)
        {
            if (storeCommands.Length == 0)
                return 0;
            else if (storeCommands.Length > 1)
                return ExecuteBatchStoreCommand(storeCommands);
            else
                return ExecuteStoreCommand(storeCommands[0].CommandText, storeCommands[0].Parameters);
        }

        public List<TElement> ExecuteQuery<TElement>(StoreCommand storeCommand)
        {
            DbCommand dbCmd = ConvertStoreCommandToDbCommand(storeCommand);
            return this.ExecuteQuery<TElement>(dbCmd);
        }
    }
}
