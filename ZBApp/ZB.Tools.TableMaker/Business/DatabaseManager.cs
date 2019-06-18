//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Text;
//using Microsoft.SqlServer;
//using Microsoft.SqlServer.Server;
//using SQLDMO;

//namespace ZB.Tools.TableMaker
//{
//    public class DatabaseManager
//    {
//        public SQLDMO.Application sqlApp = new SQLDMO.Application();
//        public SQLDMO.SQLServer oServer = new SQLDMO.SQLServer();
//        public SQLDMO._Database CurrentDb { get; set; }

//        public string ServerName { get; set; }

//        public string UserName { get; set; }

//        public string Pwd { get; set; }

//        private bool _TrustedConnection;

//        public DatabaseManager(string ServerName, string UserName, string Pwd)
//        {
//            this.ServerName = ServerName;
//            this.UserName = UserName;
//            this.Pwd = Pwd;
//        }

//        public DatabaseManager(string ServerName)
//        {
//            this.ServerName = ServerName;
//            _TrustedConnection = true;
//        }


//        public void Connect()
//        {
//            if (_TrustedConnection)
//            {
//                oServer.LoginSecure = true;
//                oServer.Connect(ServerName, System.Threading.Thread.CurrentPrincipal.Identity.Name, "");
//            }
//            else
//            {
//                oServer.Connect(ServerName, UserName, Pwd);
//            }
//        }

//        /// <summary>
//        /// 当前选取的数据库
//        /// </summary>
//        /// <param name="DatabaseName"></param>
//        /// <returns></returns>
//        public SQLDMO._Database GetCurrentDB(string DatabaseName)
//        {
//            foreach (SQLDMO.Database db in oServer.Databases)
//            {
//                if ((db.Name != null) && (db.Name == DatabaseName))
//                {
//                    return db;
//                }
//            }
//            return null;
//        }

//        /// <summary>
//        /// 获取数据库的集合
//        /// </summary>
//        /// <returns></returns>
//        public List<String> GetDataBaseList()
//        {
//            List<String> list = new List<string>();
//            foreach (SQLDMO.Database db in oServer.Databases)
//            {
//                if ((db.Name != null) && (db.SystemObject == false) && db.Status == SQLDMO_DBSTATUS_TYPE.SQLDMODBStat_Normal)
//                    list.Add(db.Name);

//            }
//            return list;
//        }

//        /// <summary>
//        /// 得到当前数据库所包含的数据表的列表
//        /// </summary>
//        /// <returns></returns>
//        public List<SQLDMO.Table> GetTableList()
//        {
//            List<SQLDMO.Table> ListTable = new List<SQLDMO.Table>();
//            foreach (SQLDMO.Table tbl in CurrentDb.Tables)
//            {


//                if (tbl.TypeOf == SQLDMO.SQLDMO_OBJECT_TYPE.SQLDMOObj_UserTable)
//                {
//                    Console.WriteLine(tbl.Name);
//                    ListTable.Add(tbl);
//                }


//                //tbl.Keys.Item(0).ReferencedTable

//            }
//            return ListTable;
//        }

//        /// <summary>
//        /// 得到当前数据库所包含的试图列表
//        /// </summary>
//        /// <returns></returns>
//        public List<SQLDMO.View> GetViewList()
//        {
//            List<SQLDMO.View> objList = new List<SQLDMO.View>();
//            foreach (SQLDMO.View viewItem in CurrentDb.Views)
//            {
//                if (viewItem.TypeOf == SQLDMO.SQLDMO_OBJECT_TYPE.SQLDMOObj_View)
//                {
//                    objList.Add(viewItem);
//                }
//            }
//            return objList;
//        }

//        /// <summary>
//        /// 得到一个表所包含的所有列
//        /// </summary>
//        /// <param name="Table"></param>
//        /// <returns></returns>
//        public List<SQLDMO.Column> GetColumns(SQLDMO.Table Table)
//        {
//            List<SQLDMO.Column> ListColumn = new List<SQLDMO.Column>();
//            foreach (SQLDMO.Column col in Table.Columns)
//            {
//                ListColumn.Add(col);
//            }
//            return ListColumn;
//        }

//        /// <summary>
//        /// 得到一个表对应的外键表的集合
//        /// </summary>
//        /// <param name="Table"></param>
//        /// <returns></returns>
//        public List<SQLDMO.Table> GetReferencedTables(SQLDMO.Table Table)
//        {
//            List<SQLDMO.Table> tableList = new List<SQLDMO.Table>();

//            SQLDMO.QueryResults ItemList = Table.EnumReferencedTables();

//            return tableList;
//        }

//        /// <summary>
//        /// 根据表名称查找指定的表
//        /// </summary>
//        /// <param name="tableName"></param>
//        /// <returns></returns>
//        public SQLDMO.Table GetTableByName(string tableName)
//        {
//            foreach (SQLDMO.Table tbl in CurrentDb.Tables)
//            {
//                if (tbl.TypeOf == SQLDMO.SQLDMO_OBJECT_TYPE.SQLDMOObj_UserTable && tbl.Name.Equals(tableName))
//                {
//                    return tbl;
//                }
//            }
//            return null;
//        }

//        /// <summary>
//        /// 根据名称查找指定的视图
//        /// </summary>
//        /// <param name="tableName"></param>
//        /// <returns></returns>
//        public SQLDMO.View GetViewByName(string viewName)
//        {
//            foreach (SQLDMO.View tbl in CurrentDb.Views)
//            {
//                if (tbl.TypeOf == SQLDMO.SQLDMO_OBJECT_TYPE.SQLDMOObj_View && tbl.Name.Equals(viewName))
//                {
//                    return tbl;
//                }
//            }
//            return null;
//        }

//        /// <summary>
//        /// 查找指定列是否是外键列
//        /// </summary>
//        /// <param name="table"></param>
//        /// <param name="columnName"></param>
//        /// <returns></returns>
//        public bool IsColumnFK(SQLDMO.Table table, String columnName)
//        {
//            Boolean isFKCol = false;

//            foreach (Key key in table.Keys)
//            {
//                if (key.Type == SQLDMO_KEY_TYPE.SQLDMOKey_Foreign)
//                {
//                    try
//                    {
//                        if (key.KeyColumns.FindName(columnName) != 0)
//                        {
//                            isFKCol = true;
//                            break;
//                        }
//                    }
//                    catch { }
//                }
//            }

//            return isFKCol;
//        }

//    }
//}
