using ZB.AppShell.Addin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public class TableExtendService
    {
        public static readonly TableExtendService Instance = new TableExtendService();

        private List<TableExtend> Tables;
        private Dictionary<Type, TableExtend> TableDict;
        private Dictionary<string, TableExtend> TableIdDict;

        private TableExtendService()
        {
            this.Tables = new List<TableExtend>();
            this.TableDict = new Dictionary<Type, TableExtend>();
            this.TableIdDict = new Dictionary<string, TableExtend>();
        }

        public TableExtend GetTableExtend(Type t)
        {
            if (this.TableDict.ContainsKey(t))
                return this.TableDict[t];
            else
                return null;
        }

        public void LoadConfg()
        {
            this.Tables.Clear();
            this.TableDict.Clear();
            this.TableIdDict.Clear();

            IList<TableExtend> list = (IList<TableExtend>)AddinService.Instance.GetAddinTreeNode("/ZB/TableExtend/Config").BuildItems(null, null, typeof(TableExtend));

            foreach (var item in list)
            {
                this.TableDict.Add(item.ObjectType, item);
                this.Tables.Add(item);
                this.TableIdDict.Add(item.Id, item);
            }
        }

        public void UpgradeDatabase()
        {
            using (var ds = new DatabaseScope().BeginTransaction())
            {
                IList<SqlScript> list = (IList<SqlScript>)AddinService.Instance.GetAddinTreeNode("/ZB/TableExtend/DatabaseUpgradeScript").BuildItems(null, null, typeof(SqlScript));

                foreach (var item in list)
                {
                    if (this.TableIdDict.ContainsKey(item.Id))
                    {
                        TableExtend extend = this.TableIdDict[item.Id];
                        TableMapping tablemapping = MappingService.Instance.GetTableMapping(extend.ObjectType);
                        item.ScriptCode = DatabaseEngine.ReplaceColumnPlaceholder(tablemapping,item.ScriptCode);
                    }

                    item.Execute();
                }

                ds.Complete();
            }
        }
    }
}
