using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Collections;
using System.Data;
using System.Data.Common;
using System.Reflection;

namespace ZB.Framework.ObjectMapping
{
    public abstract partial class DatabaseEngine
    {
        #region FillData(IList list, IDataReader dr, TableMapping table)
        protected virtual void FillData(IList list, IDataReader dr, TableMapping table)
        {
            TableExtend tableextend = null;
            if (table.IsSupportExtend)
                tableextend = TableExtendService.Instance.GetTableExtend(table.ObjectType);

            int fieldcount = dr.FieldCount;
            List<string> fieldnames = new List<string>();
            for (int i = 0; i < fieldcount; i++)
            {
                fieldnames.Add(dr.GetName(i));
            }

            while (dr.Read())
            {
                ObjectMappingBase obj = Activator.CreateInstance(table.ObjectType) as ObjectMappingBase;
                if (obj != null)
                {
                    foreach (string fieldname in fieldnames)
                    {
                        object val = dr[fieldname];
                        ColumnMapping column = table.GetColumnMappingByColumnName(fieldname);
                        if (column != null)
                            column.SetValue(obj, val);
                        else if(val != DBNull.Value)
                        {
                            PropertyInfo prop = table.ObjectType.GetProperty(fieldname);
                            if (prop == null)
                            {
                                if (tableextend != null && tableextend.ColumnDict.ContainsKey(fieldname))
                                    obj.SetData(tableextend.ColumnDict[fieldname].Name, val);
                                else
                                    obj.SetData(fieldname, val);
                            }
                            else if (prop != null)
                                prop.SetValue(obj, val, null);
                        }
                    }
                    list.Add(obj);
                }
            }
        }
        #endregion

        #region FillData(IList list, string strsql, TableMapping table, params Parameter[] paras)
        protected virtual void FillData(IList list, string strsql, TableMapping table, params Parameter[] paras)
        {
            using (IDataReader dr = this.ExecuteReader(strsql, paras))
            {
                FillData(list, dr, table);
            }
        }
        #endregion

        #region FillData(IList list, DbCommand command, TableMapping table)
        protected virtual void FillData(IList list, DbCommand command, TableMapping table)
        {
            using (IDataReader dr = this.ExecuteReader(command))
            {
                FillData(list, dr, table);
            }
        }
        #endregion
    }
}
