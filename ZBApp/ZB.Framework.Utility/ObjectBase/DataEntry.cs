using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.Utility
{
#if !SILVERLIGHT
    [Serializable]
#endif
    [DataContract(IsReference = true)]
    public class DataEntry : NotifyBase
    {
        private Dictionary<string, object> _Datas = null;
        [DataMember]
        public Dictionary<string, object> Datas
        {
            get { return _Datas ?? (_Datas = new Dictionary<string, object>()); }
        }

        public void SetData(string column, object data)
        {
            Datas[column] = data;
        }

        public object GetData(string column)
        {
            return Datas[column];
        }

        public void RemoveData(string column)
        {
            if (Datas.ContainsKey(column))
                Datas.Remove(column);
            else
                throw new KeyNotFoundException(column);
        }

        public object this[string column]
        {
            get
            {
                if (!Datas.ContainsKey(column))
                    Datas[column] = null;
                return Datas[column];
            }
            set
            {
                Datas[column] = value;
                RaisePropertyChanged(null);
            }
        }

        public IEnumerable<string> Keys { get { return Datas.Keys; } }

        #region 脚本扩展方法
        public bool has_key(string key)
        {
            return this.Datas.ContainsKey(key);
        }
        #endregion
    }
}
