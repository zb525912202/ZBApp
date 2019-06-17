using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;

namespace ZB.Framework.ObjectMapping
{
    public class UpdateCriteria<T> : ISqlCondition<T> where T : ObjectMappingBase
    {
        public UpdateCriteria()
        {
            this.Conditions = new SqlCondition<T>();
            this.UpdateParameters = new List<Parameter>();
            this.OtherParameters = new List<Parameter>();
            this.TableMapping = MappingService.Instance.GetTableMapping(typeof(T));
        }

        internal TableMapping TableMapping { get; set; }

        internal List<Parameter> UpdateParameters;

        internal List<Parameter> OtherParameters;

        public bool IsEmpty
        {
            get
            {
                return this.UpdateParameters.Count == 0;
            }
        }

        public void Clear()
        {
            UpdateParameters.Clear();
            OtherParameters.Clear();
        }

        public int Perform()
        {
            DatabaseEngine engine = DatabaseEngineFactory.GetDatabaseEngine();
            return engine.Update(this);
        }

        public SqlCondition<T> Conditions { get; private set; }

        public void UpdateProperty(string propname, object val)
        {
            ColumnMapping column = TableMapping.GetColumnMappingByPropertyName(propname);
            if (column == null)
                throw new ObjectMappingException("not find propname");

            this.UpdateColumn(column.Name, val);
        }

        public void UpdateColumn(string column, object val)
        {
            Parameter updateparameter = new Parameter(column, val);
            this.UpdateParameters.Add(updateparameter);
        }
    }
}
