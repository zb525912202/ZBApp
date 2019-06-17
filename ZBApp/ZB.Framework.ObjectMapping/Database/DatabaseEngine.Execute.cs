using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Common;
using System.Data;
using System.IO;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region SelectCount(string strSQL)
        public virtual int SelectCount(string strSQL)
        {
            return this.ExecuteScalar<int>(strSQL);
        }
        #endregion

        #region GetMaxSeed(TableMapping table)
        public virtual int? GetMaxSeed(TableMapping table)
        {
            object obj = this.ExecuteScalar(string.Format("select max({0}) from {1}", table.ColumnPK.Name, this.GetTableName(table.Name)));
            return (obj == DBNull.Value) ? null : (int?)obj;
        }

        public int GetMaxSeed(TableMapping table, int defaultValue)
        {
            int? val = GetMaxSeed(table);
            if (val.HasValue)
            {
                if (val.Value < 0)
                    return 0;
                else
                    return val.Value;
            }
            else
                return defaultValue;
        }
        #endregion



        #region ExecuteQuery<TElement>(DbCommand command)
        public virtual List<TElement> ExecuteQuery<TElement>(DbCommand command)
        {
            return Load<List<TElement>, TElement>(command);
        }
        #endregion

        #region ExecuteQuery<TElement>(CommandType commandType, string commandText)
        public virtual List<TElement> ExecuteQuery<TElement>(CommandType commandType, string commandText)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            cmd.CommandType = commandType;
            return this.ExecuteQuery<TElement>(cmd);
        }
        #endregion

        #region ExecuteQuery<TElement>(string commandText)
        public virtual List<TElement> ExecuteQuery<TElement>(string commandText, int timeoutSecond)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            cmd.CommandTimeout = timeoutSecond;
            return this.ExecuteQuery<TElement>(cmd);
        }
        #endregion

        #region ExecuteQuery<TElement>(string commandText, params Parameter[] paras)
        public virtual List<TElement> ExecuteQuery<TElement>(string commandText, params Parameter[] paras)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            this.AddParameter(cmd, paras);
            return this.ExecuteQuery<TElement>(cmd);
        }
        #endregion

        #region ExecuteNonQueryFromFile(string sqlscriptfile)
        public int ExecuteNonQueryFromFile(string sqlscriptfile)
        {
            string strSQL = File.ReadAllText(sqlscriptfile);
            return this.ExecuteNonQuery(strSQL);
        }
        #endregion

        #region ExecuteNonQuery(DbCommand command)
        public int ExecuteNonQuery(DbCommand command)
        {
            return DatabaseSession.Database.ExecuteNonQuery(command);
        }
        #endregion

        #region ExecuteNonQuery(CommandType commandType, string commandText)
        public int ExecuteNonQuery(CommandType commandType, string commandText)
        {
            return DatabaseSession.Database.ExecuteNonQuery(commandType, commandText);
        }
        #endregion

        #region ExecuteNonQuery(string commandText,int timeoutSecond)
        public int ExecuteNonQuery(string commandText, int timeoutSecond)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            cmd.CommandTimeout = timeoutSecond;
            return ExecuteNonQuery(cmd);
        }
        #endregion

        #region ExecuteNonQuery(string commandText, params Parameter[] paras)
        public int ExecuteNonQuery(string commandText, params Parameter[] paras)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            this.AddParameter(cmd, paras);
            return this.ExecuteNonQuery(cmd);
        }
        #endregion

        #region ExecuteScalar<TElement>(CommandType commandType, string commandText)
        public TElement ExecuteScalar<TElement>(CommandType commandType, string commandText)
        {
            return (TElement)DatabaseSession.Database.ExecuteScalar(commandType, commandText);
        }
        #endregion

        #region ExecuteScalar<TElement>(string commandText)
        public TElement ExecuteScalar<TElement>(string commandText)
        {
            return ExecuteScalar<TElement>(CommandType.Text, commandText);
        }
        #endregion

        #region ExecuteScalar(string commandText)
        public object ExecuteScalar(string commandText)
        {
            return DatabaseSession.Database.ExecuteScalar(CommandType.Text, commandText);
        }
        #endregion

        #region ExecuteScalar<TElement>(string commandText, params Parameter[] paras)
        public TElement ExecuteScalar<TElement>(string commandText, params Parameter[] paras)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            this.AddParameter(cmd, paras);
            return this.ExecuteScalar<TElement>(cmd);
        }
        #endregion

        #region ExecuteScalar<TElement>(DbCommand command)
        public TElement ExecuteScalar<TElement>(DbCommand command)
        {
            return (TElement)DatabaseSession.Database.ExecuteScalar(command);
        }
        #endregion


        #region ExecuteReader(DbCommand command)
        public IDataReader ExecuteReader(DbCommand command)
        {
            return DatabaseSession.Database.ExecuteReader(command);
        }
        #endregion

        #region ExecuteReader(CommandType commandType, string commandText)
        public IDataReader ExecuteReader(CommandType commandType, string commandText)
        {
            return DatabaseSession.Database.ExecuteReader(commandType, commandText);
        }
        #endregion

        #region ExecuteReader(string commandText)
        public IDataReader ExecuteReader(string commandText)
        {
            return ExecuteReader(CommandType.Text, commandText);
        }
        #endregion

        #region ExecuteReader(string commandText, params Parameter[] paras)
        public IDataReader ExecuteReader(string commandText, params Parameter[] paras)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            this.AddParameter(cmd, paras);
            return this.ExecuteReader(cmd);
        }
        #endregion


        #region ExecuteDataSet(DbCommand command)
        public DataSet ExecuteDataSet(DbCommand command)
        {
            return DatabaseSession.Database.ExecuteDataSet(command);
        }
        #endregion

        #region ExecuteDataSet(CommandType commandType, string commandText)
        public DataSet ExecuteDataSet(CommandType commandType, string commandText)
        {
            return DatabaseSession.Database.ExecuteDataSet(commandType, commandText);
        }
        #endregion

        #region ExecuteDataSet(string commandText)
        public DataSet ExecuteDataSet(string commandText)
        {
            return ExecuteDataSet(CommandType.Text, commandText);
        }
        #endregion

        #region ExecuteDataSet(string commandText, params Parameter[] paras)
        public DataSet ExecuteDataSet(string commandText, params Parameter[] paras)
        {
            DbCommand cmd = this.GetSqlStringCommand(commandText);
            this.AddParameter(cmd, paras);
            return this.ExecuteDataSet(cmd);
        }
        #endregion
    }
}
