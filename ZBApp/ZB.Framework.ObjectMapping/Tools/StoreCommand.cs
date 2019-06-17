using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects;
using System.Text.RegularExpressions;

namespace ZB.Framework.ObjectMapping
{
    public class StoreCommand
    {
        public StoreCommand()
        {
            this.CommandText = string.Empty;
        }

        public StoreCommand(string commandText, params object[] parameters)
        {
            this.CommandText = commandText;
            this.Parameters = parameters;
        }

        
        public string CommandText {get;set;}


        public object[] Parameters { get; set; }

        public string SqlString
        {
            get { return this.ToString(); }
        }

        public override string ToString()
        {
            List<string> strList = new List<string>();

            foreach (object obj in this.Parameters)
            {
                if (obj == null || obj is byte[])
                {
                    strList.Add(string.Empty);
                    continue;
                }

                if (obj is string)
                    strList.Add(string.Format("'{0}'", obj));

                else
                    strList.Add(obj.ToString());
            }

            return string.Format(this.CommandText, strList.ToArray());
        }
    }

    internal static class StoreCommandHelper
    {  
        internal static void UnitSbCommand(StringBuilder sbCommand, string commandText, Dictionary<int, int> indexDic)
        {
            List<int> indexList = new List<int>();
            indexList.AddRange(indexDic.Keys.ToArray());
            indexList.Sort((index1, index2) => index2 - index1);
            foreach (int index in indexList)
            {
                string oldIndexStr = string.Format("{{{0}}}", index);
                string newIndexStr = string.Format("{{{0}}}", indexDic[index]);
                commandText = commandText.Replace(oldIndexStr, newIndexStr);
            }

            sbCommand.Append(commandText);

            if (!commandText.EndsWith(";"))
                sbCommand.Append(";\n");
        }

        /// <summary>
        /// 将多个StoreCommand合并成一个StoreCommand
        /// </summary>
        /// <param name="storeCommandList"></param>
        /// <returns></returns>
        internal static StoreCommand UnitStoreCommand(List<StoreCommand> storeCommandList)
        {
            StoreCommand scTotal = new StoreCommand();
            StringBuilder sbCommand = new StringBuilder();
            List<object> paramterList = new List<object>();
            //Regex regex = new Regex(@"(?<=\{)(\d+)(?=\})");//"{"用的是反向正声明，"}"用的是正向声明
            Regex regex = new Regex(@"(?<=\{)(\d+)(?=\})");//"{"用的是反向正声明，"}"用的是正向声明

            int currentIndex = 0;
            Dictionary<int, int> indexDic = new Dictionary<int, int>();
            foreach (StoreCommand sc in storeCommandList)
            {
                indexDic.Clear();
                Match match = regex.Match(sc.CommandText);

                while (match.Success)
                {
                    int index = int.Parse(sc.CommandText.Substring(match.Index, match.Length));
                    if (!indexDic.ContainsKey(index))
                    {
                        indexDic.Add(index, index + currentIndex);
                    }
                    match = match.NextMatch();
                }

                UnitSbCommand(sbCommand, sc.CommandText, indexDic);
                paramterList.AddRange(sc.Parameters);
                currentIndex += indexDic.Count;
            }

            scTotal.CommandText = sbCommand.ToString();
            scTotal.Parameters = paramterList.ToArray();
            return scTotal;
        }
    }
}
