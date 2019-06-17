using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace ZB.Framework.Business
{
    [DataContract]
    public class ExcelImportResult
    {
        public ExcelImportResult()
        {
            this.ErrorList = new Dictionary<int, Dictionary<string, string>>();
        }

        [DataMember]
        public Dictionary<int, Dictionary<string, string>> ErrorList { get; set; }

        public void SetError(int Index, string PropertyName, string error)
        {
            if (!this.ErrorList.ContainsKey(Index))
                this.ErrorList.Add(Index, new Dictionary<string, string>());

            this.ErrorList[Index][PropertyName] = error;
        }

#if SILVERLIGHT
        public Exception ImportException {get;set;}
#endif

        public bool HasError
        {
            get
            {
                return ErrorList.Count > 0;
            }
        }
    }
}
