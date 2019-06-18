using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using ZB.Framework.Utility;

namespace ZB.AppShell.Addin
{
    public partial class AppSettingService
    {
        private static AppSettingService _Instance;
        public static AppSettingService Instance
        {
            get
            {
                if (_Instance == null)
                    _Instance = new AppSettingService();
                return _Instance;
            }
        }

        public const string __DefaultGroup = "DefaultGroup";

        public Dictionary<string, AppSettingGroup> ConfigGroup { get; private set; }

        private Dictionary<string, AppSettingGroup> BuildConfigGroup()
        {
            Dictionary<string, AppSettingGroup> temp = new Dictionary<string, AppSettingGroup>();

            var AppSettingNode = AddinService.Instance.GetAddinTreeNode("/ZB/AppSetting",true);
            if (AppSettingNode != null)
            {
                var grouplist = AppSettingNode.BuildItems();
                foreach (AppSettingGroup group in grouplist)
                {
                    temp[group.GroupName] = group;
                }
            }
            return temp;
        }

#if !SILVERLIGHT
        private AppSettingService()
        {
            this.ConfigGroup = this.BuildConfigGroup();
        }
#endif

        #region GetData
        public T GetData<T>(string key)
        {
            return this.GetData<T>(__DefaultGroup, key);
        }

        public T GetData<T>(string group, string key)
        {
            if (!ConfigGroup.ContainsKey(group))
                return default(T);

            AppSettingGroup tempgroup = ConfigGroup[group];

            if (!tempgroup.ConfigDatas.ContainsKey(key))
                return default(T);

#if SILVERLIGHT
            return SerializeHelper.DataContractByteToObject<T>(tempgroup.ConfigDatas[key]);
#else
            return (T)SerializeHelper.ByteToObject(tempgroup.ConfigDatas[key]);
#endif
        }
        #endregion
    }
}
