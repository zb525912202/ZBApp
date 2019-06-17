using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace ZB.Framework.ObjectMapping
{
    public class MappingService
    {
        public static readonly MappingService Instance = new MappingService();
        private static object LockedObject = new object();

        private List<TableMapping> Tables;
        private Dictionary<Type, TableMapping> TableDict;

        private MappingService()
        {
            Tables = new List<TableMapping>();
            TableDict = new Dictionary<Type, TableMapping>();
        }

        public TableMapping GetTableMapping(object obj)
        {
            return GetTableMapping(obj.GetType());
        }

        public TableMapping GetTableMapping(Type type)
        {
            lock (LockedObject)
            {
                TableMapping tablemapping = null;

                if (this.TableDict.ContainsKey(type))
                    tablemapping = this.TableDict[type];
                else
                {
                    TableMapping table = CreateTableMapping(type);

                    if (table != null)
                    {
                        this.Tables.Add(table);
                        this.TableDict.Add(type, table);
                    }

                    tablemapping = table;
                }

                if (tablemapping == null)
                    throw new ObjectMappingException("not find tablemapping define");

                return tablemapping;
            }
        }

        private void GetProperties(TableMapping table,Type type,List<PropertyInfo> list)
        {
            if (type.BaseType != null)
            {
                TableAttribute tableattribute = Attribute.GetCustomAttribute(type.BaseType, typeof(TableAttribute), false) as TableAttribute;
                if (tableattribute != null)
                    table.BaseTableMapping = this.GetTableMapping(type.BaseType);
                else
                    GetProperties(table, type.BaseType, list);
            }

            list.AddRange(type.GetProperties(BindingFlags.DeclaredOnly | BindingFlags.Instance | BindingFlags.Public));
        }

        private TableMapping CreateTableMapping(Type type)
        {
            TableAttribute tableattribute = Attribute.GetCustomAttribute(type, typeof(TableAttribute), false) as TableAttribute;
            if (tableattribute == null)
                throw new ObjectMappingException("not find objectmapping TableMapping attribute");

            TableMapping table = new TableMapping();
            table.Name = tableattribute.Name;
            table.ObjectType = type;
            table.IsSupportExtend = tableattribute.IsSupportExtend;
            table.ForeignKey = tableattribute.ForeignKey;
            table.MasterDetailView = tableattribute.MasterDetailView;

            if (string.IsNullOrEmpty(table.Name))
                table.Name = table.ObjectType.Name;

            List<PropertyInfo> props = new List<PropertyInfo>();
            GetProperties(table, type, props);

            foreach (PropertyInfo prop in props)
            {
                ColumnAttribute columnattribute = Attribute.GetCustomAttribute(prop, typeof(ColumnAttribute)) as ColumnAttribute;
                if (columnattribute == null)
                    table.OtherPropertys.Add(prop);
                else
                {
                    ColumnMapping column = new ColumnMapping();
                    column.Name = columnattribute.Name;
                    column.PropertyInfo = prop;

                    if (string.IsNullOrEmpty(column.Name))
                    {
                        column.Name = prop.Name;
                    }

                    column.IsAutoIncrement = columnattribute.IsAutoIncrement;
                    column.IsPK = columnattribute.IsPK;
                    column.IsUseSeedFactory = columnattribute.IsUseSeedFactory;
                    //--------------------------------------------------------------------------------------------------------------------
                    Attribute[] attrs = Attribute.GetCustomAttributes(prop);
                    foreach (Attribute attr in attrs)
                    {
                        if (attr is DataInterceptAttribute)
                        {
                            if (column.DataIntercept == null)
                            {
                                DataInterceptAttribute dataintercept = attr as DataInterceptAttribute;
                                dataintercept.ColumnMapping = column;
                                column.DataIntercept = dataintercept;
                            }
                            else
                                throw new ObjectMappingException("Property have more DataInterceptAttribute define");
                        }
                    }
                    //--------------------------------------------------------------------------------------------------------------------
                    table.AddColumnMapping(column);
                }
            }

            if (table.BaseTableMapping != null && table.ColumnPK == null)
            {
                var pkcol = table.BaseTableMapping.ColumnPK.Clone();
                pkcol.IsAutoIncrement = false;
                pkcol.IsUseSeedFactory = false;
                pkcol.Name = table.ForeignKey;
                table.AddColumnMapping(pkcol);
            }

            if (table.ColumnPK == null)
                throw new ObjectMappingException("not find primary key");

            if (table.BaseTableMapping != null && table.MasterType == null)
                table.MasterType = table.BaseTableMapping.ObjectType;

            return table;
        }
    }
}
