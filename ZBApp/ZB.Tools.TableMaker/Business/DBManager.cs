using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data.SqlClient;
using System.Collections.ObjectModel;


namespace ZB.Tools.TableMaker
{
    public class DBManager
    {
        public Action<string> MsgWriter { get; set; }
        public string ConnectionString { get; set; }
        public List<ZBDatabase> DatabaseList { get; private set; }


        public DBManager()
        {
            DatabaseList = new List<ZBDatabase>();
        }

        public List<ZBDatabase> LoadDatabaseList()
        {
            string sql = "SELECT [Name] FROM master.dbo.sysdatabases WHERE dbid >4 ORDER BY [Name]"; //TODO:有待确认
            DatabaseList = new List<ZBDatabase>(from o in GetItemSet<string>(sql)
                                                 select new ZBDatabase
                                                 {
                                                     ObjectName = o.ToString()
                                                 });
            int i = 1;
            DatabaseList.ForEach(r =>
            {
                MsgWriter(string.Format("load db:{0}，{1}/{2}", r.ObjectName, i++, DatabaseList.Count()));
                LoadDBInfo(r);
            });

            return null;
        }

        public ZBDatabase GetDBByName(string dbName)
        {
            return DatabaseList.First(r => r.ObjectName.Equals(dbName));
        }

        public bool IsColumnFK(ZBTable table, string colName)
        {
            return true;
        }

        internal List<ZBTable> GetTableList(string dbName)
        {
            return DatabaseList.First(r => r.ObjectName.Equals(dbName)).TableList.ToList();
        }

        internal List<ZBColumn> GetColumns(string dbName, string tableName)
        {
            return DatabaseList.First(r => r.ObjectName.Equals(dbName)).TableList.First(r => r.ObjectName.Equals(tableName)).ColumnList.ToList();
        }


        #region sql query
        private void LoadDBInfo(ZBDatabase db)
        {
            //加载表
            string sql = string.Format("SELECT [TABLE_NAME] FROM {0}.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE=N'BASE TABLE' ORDER BY [TABLE_NAME] ", db.ObjectName);
            db.TableList = new ObservableCollection<ZBTable>(from o in GetItemSet<string>(sql)
                                                              select new ZBTable
                                                              {
                                                                  ObjectName = o.ToString()
                                                              });

            //加载主键和外键，一次性加载一个数据库的所有主外键(和约束)
            sql = string.Format(@"SELECT [TABLE_CATALOG],[TABLE_NAME],[COLUMN_NAME],[CONSTRAINT_NAME] FROM {0}.INFORMATION_SCHEMA.KEY_COLUMN_USAGE", db.ObjectName);
            db.KeyList = new List<ZBTableKey>();

            string masterConnStr = this.ConnectionString;
            SqlConnection conn = new SqlConnection(masterConnStr);

            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                cmd.Connection.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ZBTableKey obj = new ZBTableKey()
                    {
                        DatabaseName = dr["TABLE_CATALOG"].ToString(),
                        TableName = dr["TABLE_NAME"].ToString(),
                        ColumnName = dr["COLUMN_NAME"].ToString(),
                        ConstraintName = dr["CONSTRAINT_NAME"].ToString(),
                    };

                    db.KeyList.Add(obj);
                }
            }
            finally
            {
                cmd.Connection.Close();
            }

            //加载列
            foreach (var tabItem in db.TableList)
            {
                LoadColumns(db, tabItem, conn);
            }

        }

        private void LoadColumns(ZBDatabase db, ZBTable table, SqlConnection conn)
        {
            if (table.ObjectName.Equals("BuzEmployeeMessage"))
            {
                Console.WriteLine("adfs");
            }

            //加载表结构
            string sql = string.Format(
                    @"USE {0};
                      SELECT 
                        C.name AS ColumnName,
                        C.is_identity AS IsIdentity,
                        S.name AS DataType,
                        C.is_nullable AS IsNullable
	                FROM [{0}].[sys].all_columns C
	                JOIN sys.systypes S ON S.xusertype = C.user_type_id
                    WHERE C.object_id = OBJECT_ID(N'[dbo].[{1}]')", db.ObjectName, table.ObjectName);

            List<ZBColumn> cList = new List<ZBColumn>();

            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                cmd.Connection.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ZBColumn obj = new ZBColumn()
                    {
                        ObjectName = dr["ColumnName"].ToString(),
                        IsAutoIncreasement = (bool)dr["IsIdentity"],
                        IsAllowNull = (bool)dr["IsNullable"],
                        DataType = dr["DataType"].ToString(),
                    };

                    obj.IsInPK = this.IsInPK(db, table.ObjectName, obj.ObjectName);
                    obj.IsInFK = this.IsInFK(db, table.ObjectName, obj.ObjectName);

                    if (!obj.IsInPK && !obj.IsInFK)
                    {
                        obj.IsPropStyle = true;
                    }

                    cList.Add(obj);
                }
                table.ColumnList = new ObservableCollection<ZBColumn>(cList);
            }
            finally
            {
                cmd.Connection.Close();
            }

        }

        private bool IsInPK(ZBDatabase db, string tbName, string colName)
        {
            string tb = tbName.Length > 8 ? tbName.Substring(0, 8) : tbName;

            return db.KeyList.Any(r =>
                    r.TableName.Equals(tbName) &&
                    r.ColumnName.Equals(colName) &&
                    r.ConstraintName.StartsWith("PK__" + tb + "__")
                );
        }

        private bool IsInFK(ZBDatabase db, string tbName, string colName)
        {
            //string tb = tbName.Length > 8 ? tbName.Substring(0, 8) : tbName;
            return db.KeyList.Any(r =>
                  r.TableName.Equals(tbName) &&
                  r.ColumnName.Equals(colName) &&
                  r.ConstraintName.StartsWith("FK_" + tbName + "_")
              );
        }

        //只查询一列的数据并返回
        private ISet<T> GetItemSet<T>(string sql)
        {
            HashSet<T> objList = new HashSet<T>();
            string masterConnStr = this.ConnectionString;
            SqlConnection conn = new SqlConnection(masterConnStr);

            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                cmd.Connection.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    objList.Add((T)dr[0]);
                }
                return objList;
            }
            finally
            {
                cmd.Connection.Close();
            }
        }
        #endregion




    }
}
