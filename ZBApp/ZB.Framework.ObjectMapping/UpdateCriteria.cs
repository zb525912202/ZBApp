using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class UpdateCriteria : ISqlCondition
    {
        public UpdateCriteria()
        {
            this.Conditions = new SqlCondition();
            this.UpdateParameters = new List<Parameter>();
            this.OtherParameters = new List<Parameter>();
            this.UpdateStatements = new List<string>();
        }

        public UpdateCriteria(string tablename) : this()
        {
            this.TableName = tablename;
        }

        public string TableName {get;set;}

        internal List<Parameter> UpdateParameters;

        public List<Parameter> OtherParameters {get;private set;}

        public List<String> UpdateStatements {get;private set;}

        public void Clear()
        {
            UpdateParameters.Clear();
            OtherParameters.Clear();
            UpdateStatements.Clear();
        }

#if !SILVERLIGHT
        public int Perform()
        {
            DatabaseEngine engine = DatabaseEngineFactory.GetDatabaseEngine();
            return engine.Update(this);
        }
#endif

        public SqlCondition Conditions { get; private set; }

        public void UpdateColumn(string column, object val)
        {
            Parameter updateparameter = new Parameter(column, val);
            this.UpdateParameters.Add(updateparameter);
        }

        public bool IsEmpty
        {
            get
            {
                return this.UpdateParameters.Count == 0 && this.UpdateStatements.Count == 0;
            }
        }

        public void UpdateStatement(string strSQL, params Parameter[] paras)
        {
            this.UpdateStatements.Add(strSQL);
            this.OtherParameters.AddRange(paras);
        }
    }
}
