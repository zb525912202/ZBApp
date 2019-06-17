using ZB.AppShell.Addin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    [CodonName("SqlScript")]
    public class SqlScriptCodon : AbstractCodon
    {
        [XmlMemberAttribute("database")]
        public string Database { get; set; }

        [XmlMemberCDATA]
        public string ScriptCode { get; set; }

#if !SILVERLIGHT
        public override object BuildItem(object caller, object parent)
        {
            SqlScript sql = new SqlScript();
            sql.Database = this.Database;
            sql.ScriptCode = this.ScriptCode;
            sql.Id = this.ID;
            return sql;
        }
#endif
    }

#if !SILVERLIGHT

    public class SqlScript
    {
        public string Database { get; set; }

        public string ScriptCode { get; set; }

        public string Id { get; set; }

        public void Execute()
        {
            using (var ds = new DatabaseScope(this.Database, false))
            {
                DbHelper.ExecuteNonQuery(this.ScriptCode);
            }
        }
    }
#endif
}
