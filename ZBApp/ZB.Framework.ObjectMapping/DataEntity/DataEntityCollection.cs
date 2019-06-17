using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Collections.ObjectModel;
using System.Collections;
using System.Reflection;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public class AttachDataEntity
    {
        public string PropertyName { get; set; }
        public Type ListType { get; set; }
        public Type EntityType { get; set; }
    }


    [DataContract(IsReference = true)]
    public class DataEntityCollection
    {
        public DataEntityCollection()
        {
            Columns = new ObservableCollection<DataEntityColumn>();
            AttachColumns = new ObservableCollection<DataEntityColumn>();
            Rows = new ObservableCollection<DataEntity>();
        }


        [DataMember]
        public ObservableCollection<DataEntityColumn> Columns { get; set; }

        [DataMember]
        public ObservableCollection<DataEntityColumn> AttachColumns { get; set; }


        private ObservableCollection<DataEntity> _Rows;
        [DataMember]
        public ObservableCollection<DataEntity> Rows
        {
            get
            {
#if SILVERLIGHT
                if (this.RowsBinaryData != null)
                    this.ToRows();
#endif
                return _Rows;
            }
            set { _Rows = value; }
        }

        [DataMember]
        public byte[] RowsBinaryData { get; set; }

        public void AddItem(DataEntity item)
        {
            Rows.Add(item);
        }

        public List<DataEntity> FindDataEntityList(string key, object value)
        {
            List<DataEntity> entityList = new List<DataEntity>();

            foreach (var entity in Rows)
            {
                if (entity[key].Equals(value))
                    entityList.Add(entity);
            }
            return entityList;
        }


        public void ToRowsBinary()
        {
            this.RowsBinaryData = SmartSerializeHelper.SerializeObjectList(_Rows, (serializer, dataEntity) =>
            {
                foreach (var column in Columns)
                {
                    object val = dataEntity[column.Column];
                    serializer.Write(val != null);

                    if (val != null)
                        serializer.Write(column.GetDataType(), dataEntity[column.Column]);
                }

                foreach (var column in AttachColumns)
                {
                    object val = dataEntity[column.Column];
                    serializer.Write(val != null);

                    if (val != null)
                    {
                        byte[] tempByte = SerializeHelper.ObjectToDataContractByte(val, typeof(IList<DataEntity>));
                        serializer.Write(tempByte);
                    }
                }

            });

            this._Rows = null;

        }

        private void ToRows()
        {
            this.Rows = new ObservableCollection<DataEntity>(SmartSerializeHelper.DeserializeObjectList<DataEntity>(this.RowsBinaryData, (deserializer, dataEntity) =>
            {
                foreach (var column in Columns)
                {
                    bool isNotNull = deserializer.ReadBool();
                    if (isNotNull)
                        dataEntity[column.Column] = deserializer.ReadObj(column.GetDataType());
                    else
                        dataEntity[column.Column] = null;
                }

                foreach (var column in AttachColumns)
                {
                    bool isNotNull = deserializer.ReadBool();
                    if (isNotNull)
                    {
                        byte[] tempBytes = deserializer.ReadBytes();

                        var obj = SerializeHelper.DataContractByteToObject(tempBytes, typeof(IList<DataEntity>));

                        dataEntity[column.Column] = obj;
                    }
                    else
                    {
                        dataEntity[column.Column] = null;
                    }
                }


            }));

            this.RowsBinaryData = null;
        }

        [DataMember]
        public int TotalCount { get; set; }
    }

    public static class DataEntityCollectionExtend
    {
        public static ObservableCollection<T> ConvertToList<T>(this DataEntityCollection collection) where T : class
        {
            return collection.ConvertToList(typeof(ObservableCollection<T>), typeof(T)) as ObservableCollection<T>;
        }

        public static T ConvertToList<T>(this DataEntityCollection collection, string columnname) where T : IList, new()
        {
            T llistobj = new T();
            if (llistobj == null) return default(T);

            foreach (var row in collection.Rows)
            {
                if (row.Datas.ContainsKey(columnname))
                {
                    llistobj.Add(row.Datas[columnname]);
                }
            }

            return llistobj;
        }

        public static IList ConvertToList(this DataEntityCollection collection, Type listtype, Type objecttype, List<AttachDataEntity> attachDataEntityList = null)
        {
            IList llistobj = Activator.CreateInstance(listtype) as IList;
            if (llistobj == null) return null;

            Dictionary<string, PropertyInfo> PropertyDict = new Dictionary<string, PropertyInfo>();
            foreach (var column in collection.Columns)
            {
                PropertyInfo prop = objecttype.GetProperty(column.Column);
                if (prop != null)
                    PropertyDict.Add(column.Column, prop);
            }

            foreach (var row in collection.Rows)
            {
                DataEntry entityobj = Activator.CreateInstance(objecttype) as DataEntry;

                if (entityobj == null) return llistobj;
                foreach (var column in collection.Columns)
                {
                    if (row.Datas.ContainsKey(column.Column))
                    {
                        if (PropertyDict.ContainsKey(column.Column))
                        {
                            PropertyInfo prop = PropertyDict[column.Column];
                            prop.SetValue(entityobj, row[column.Column], null);
                        }
                        else
                            entityobj[column.Column] = row[column.Column];
                    }
                }

                if (attachDataEntityList != null)
                {
                    foreach (var attachDataEntity in attachDataEntityList)
                    {
                        IList attachDataList = Activator.CreateInstance(attachDataEntity.ListType) as IList;

                        if (row.Datas.ContainsKey(attachDataEntity.PropertyName))
                        {
                            IList<DataEntity> attachRows = row.Datas[attachDataEntity.PropertyName] as IList<DataEntity>;

                            Dictionary<string, PropertyInfo> aPropertyDict = new Dictionary<string, PropertyInfo>();

                            foreach (var itemRow in attachRows)
                            {
                                DataEntry attachEntity = Activator.CreateInstance(attachDataEntity.EntityType) as DataEntry;

                                foreach (var key in itemRow.Keys)
                                {
                                    if (!aPropertyDict.ContainsKey(key))
                                    {
                                        PropertyInfo prop = attachDataEntity.EntityType.GetProperty(key);
                                        if (prop != null)
                                            aPropertyDict.Add(key, prop);
                                    }

                                    if (aPropertyDict.ContainsKey(key))
                                    {
                                        aPropertyDict[key].SetValue(attachEntity, itemRow[key], null);
                                    }
                                    else
                                        attachEntity[key] = itemRow[key];
                                }

                                attachDataList.Add(attachEntity);
                            }
                        }

                        PropertyInfo tempProp = entityobj.GetType().GetProperty(attachDataEntity.PropertyName);
                        if (tempProp != null)
                            tempProp.SetValue(entityobj, attachDataList, null);
                    }
                }


                llistobj.Add(entityobj);
            }
            return llistobj;
        }
    }
}
