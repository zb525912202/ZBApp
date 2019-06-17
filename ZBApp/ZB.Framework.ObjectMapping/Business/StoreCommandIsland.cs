using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;

namespace ZB.Framework.ObjectMapping
{
    public class StoreCommandIsland
    {
        internal DatabaseEngine Database {get;private set;}

        public StoreCommandIsland()
        {
            CommandList = new List<StoreCommand>();
            Database = DatabaseEngineFactory.GetDatabaseEngine();
        }

        private List<StoreCommand> CommandList { get; set; }

        public void Clear()
        {
            CommandList.Clear();
        }

        public void AppendCommand(StoreCommand command)
        {
            CommandList.Add(command);
        }

        public void AppendCommands(IEnumerable<StoreCommand> commands)
        {
            foreach (var cmd in commands)
            {
                CommandList.Add(cmd);
            }
        }

        public void BatchCommit()
        {
            Database.ExecuteStoreCommand(CommandList.ToArray());
        }
    }
}
