using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data.OleDb;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region SetParameterValue(DbCommand command, string parameterName, object value)
        public void SetParameterValue(DbCommand command, string parameterName, object value)
        {
            DatabaseSession.Database.SetParameterValue(command, parameterName, value);
        }
        #endregion

        #region SetParameterValue(DbCommand command, Parameter para)
        public void SetParameterValue(DbCommand command, Parameter para)
        {
            DatabaseSession.Database.SetParameterValue(command, para.Name, para.Value);
        }
        #endregion

        #region GetParameterValue(DbCommand command, string name)
        public object GetParameterValue(DbCommand command, string name)
        {
            return DatabaseSession.Database.GetParameterValue(command, name);
        }
        #endregion

        #region AddParameter(DbCommand command, string name,object val)
        public void AddParameter(DbCommand command, string name, object val)
        {
            if (val == null)
                val = DBNull.Value;

            DbParameter para = DatabaseSession.Database.DbProviderFactory.CreateParameter();
            para.ParameterName = name;
            para.Value = val;
            this.CorrectDbParameter(para);

            command.Parameters.Add(para);
        }
        #endregion

        private void CorrectDbParameter(DbParameter para)
        {
            if (para.Value is DateTime)
            {
                if ((DateTime)para.Value == DateTime.MinValue)
                    para.Value = DBNull.Value;

                if (this.DatabaseSession.Database.DbProviderFactory is OleDbFactory)
                    ((OleDbParameter)para).OleDbType = OleDbType.Date;
            }
        }

        #region AddParameter(DbCommand command, Parameter para)
        public void AddParameter(DbCommand command, Parameter para)
        {
            this.AddParameter(command, para.Name, para.Value);
        }
        #endregion

        #region AddParameter(DbCommand command, params Parameter[] paras)
        public void AddParameter(DbCommand command, params Parameter[] paras)
        {
            foreach (Parameter para in paras)
            {
                this.AddParameter(command, para);
            }
        }
        #endregion

        #region BuildParameterName(string name)
        public virtual string BuildParameterName(string name)
        {
            return "@" + name;
        }
        #endregion

        #region GetParameterPrefix()
        public virtual string GetParameterPrefix()
        {
            string pname = this.BuildParameterName("ParameterPrefix");
            return pname[0].ToString();
        }
        #endregion
    }
}
