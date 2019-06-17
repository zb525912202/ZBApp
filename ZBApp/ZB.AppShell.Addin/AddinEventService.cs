using System;
using System.Net;
using System.Collections.Generic;

namespace ZB.AppShell.Addin
{
    [CodonName("GlobalEvent")]
    public class GlobalEventCodon : AbstractCodon
    {
        public override object BuildItem(object caller, object parent)
        {
            HashSet<string> temp = caller as HashSet<string>;
            temp.Add(this.ID);
            return this.ID;
        }
    }

    public class AddinEventService
    {
        public static readonly AddinEventService Instance = new AddinEventService();

        private static object LockedObject = new object();

        private AddinEventService()
        {
            this.GlobalEvents = new Dictionary<string, List<DelegateEventFire>>();
            this.GlobalEventDatas = new Dictionary<string, object>();
            this.RegisteredGlobalEvents = new HashSet<string>();
        }

        public event Action<string> AddinLoadingEvent;

        internal HashSet<string> RegisteredGlobalEvents;

        internal void Init()
        {
            AddinTreeNode addinnode = AddinService.Instance.GetAddinTreeNode("/Jet/RegisteredGlobalEvents",true);
            if(addinnode != null)
                addinnode.BuildItems(RegisteredGlobalEvents, null);
        }

        public void AddinLoading(string message)
        {
            if (AddinLoadingEvent != null)
                AddinLoadingEvent(message);
        }

        public delegate void DelegateEventFire(object sender, string eventsrc, object olddata, object newdata);

        private Dictionary<string, List<DelegateEventFire>> GlobalEvents;

        private Dictionary<string, object> GlobalEventDatas;

        /// <summary>
        /// 注册全局事件  Action<sender,newdata,olddata>
        /// </summary>
        public void RegisterGlobalEvent(string EventKey, DelegateEventFire action)
        {
            lock (LockedObject)
            {
                if (!this.RegisteredGlobalEvents.Contains(EventKey))
                    throw new AddinException(string.Format("全局事件\"{0}\"没有在Addin中注册", EventKey));

                List<DelegateEventFire> eventActions = null;
                if (!GlobalEvents.ContainsKey(EventKey))
                {
                    eventActions = new List<DelegateEventFire>();
                    GlobalEvents.Add(EventKey, eventActions);
                    GlobalEventDatas.Add(EventKey, null);
                }
                else
                    eventActions = GlobalEvents[EventKey];

                if (eventActions.Contains(action))
                    throw new AddinException(string.Format("重复注册全局事件\"{0}\"",EventKey));

                eventActions.Add(action);
            }
        }

        public void UnRegisterAllGlobalEvent()
        {
            this.GlobalEvents.Clear();
            this.GlobalEventDatas.Clear();
        }

        /// <summary>
        /// 注销全局事件  Action<sender,newdata,olddata>
        /// </summary>
        public void UnRegisterGlobalEvent(string EventKey, DelegateEventFire action)
        {
            lock (LockedObject)
            {
                if (!this.RegisteredGlobalEvents.Contains(EventKey))
                    throw new AddinException(string.Format("全局事件\"{0}\"没有在Addin中注册", EventKey));
                
                if (GlobalEvents.ContainsKey(EventKey))
                {
                    List<DelegateEventFire> eventActions = GlobalEvents[EventKey]; 
                    if(eventActions.Contains(action))
                        eventActions.Remove(action);
                }
            }
        }

        /// <summary>
        /// 触发全局事件
        /// </summary>
        public void FireGlobalEvent(object sender,string EventKey, object data = null)
        {
            lock (LockedObject)
            {
                if (!this.RegisteredGlobalEvents.Contains(EventKey))
                    throw new AddinException(string.Format("全局事件\"{0}\"没有在Addin中注册", EventKey));

                if (!GlobalEvents.ContainsKey(EventKey)) 
                    return;

                object olddata = GlobalEventDatas[EventKey];

                List<DelegateEventFire> eventActions = GlobalEvents[EventKey];
                foreach(var actionitem in eventActions)
                {
                    actionitem(sender,EventKey,olddata,data);
                }

                GlobalEventDatas[EventKey] = data;
            }
        }
    }
}
