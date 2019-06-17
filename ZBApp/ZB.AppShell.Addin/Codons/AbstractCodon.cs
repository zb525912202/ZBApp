using System;
using System.Net;

namespace ZB.AppShell.Addin
{
    public abstract class AbstractCodon
    {
        public string Name
        {
            get
            {
                string name = null;
                CodonNameAttribute codonName = (CodonNameAttribute)Attribute.GetCustomAttribute(GetType(), typeof(CodonNameAttribute));
                if (codonName != null)
                {
                    name = codonName.Name;
                }
                return name;
            }
        }

        [XmlMemberAttribute("id")]
        public string ID { get; set; }

        [XmlMemberAttribute("parameter")]
        public string Parameter { get; set; }

        /// <summary>
        /// 表示ID是否是随机生成
        /// </summary>
        public bool IsRandomID { get; internal set; }

        [XmlMemberArray("eventkey")]
        public string[] EventKey { get; set; }

        [XmlMemberAttribute("class")]
        public string Class { get; set; }

        [XmlMemberAttribute("description")]
        public string Description { get; set; }

        [XmlMemberAttribute("share")]
        public bool Share { get; set; }

        public virtual object BuildItem(object caller,object parent)
        {
            return null;
        }
    }
}
