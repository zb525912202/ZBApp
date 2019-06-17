using System;
using System.Net;
using System.Collections.Generic;

namespace ZB.AppShell.Addin
{
    public class AppSettingGroup
    {
        public AppSettingGroup()
        {
            ConfigDatas = new Dictionary<string, byte[]>();
        }

        public string GroupName { get; set; }

        public Dictionary<string, byte[]> ConfigDatas { get; private set; }
    }

    [CodonName("AppSettingGroup")]
    public class AppSettingGroupCodon : AbstractCodon
    {
        public override object BuildItem(object caller, object parent)
        {
            return new AppSettingGroup() { GroupName = this.ID };
        }
    }
}
