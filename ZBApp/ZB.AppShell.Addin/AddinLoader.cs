using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Net;
using System.IO;

namespace ZB.AppShell.Addin
{
    public partial class AddinLoader
    {
        public static readonly AddinLoader Instance = new AddinLoader();

        private AddinLoader()
        {
            this.LoadedAssemblys = new List<Assembly>();
        }

        public void LoadAddins(List<AddinFile> addinfiles, CodonFactory CodonFactory, Action<XDocument> OnAddinComplete = null, Action OnComplete = null)
        {
            int index = 0;
            Action LoadAddinAction = null;
            LoadAddinAction = () =>
            {
                if (addinfiles.Count > index)
                {
                    AddinFile addinfile = addinfiles[index++];
                    this.LoadAddin(addinfile, CodonFactory, (xmldoc) =>
                    {
                        if (OnAddinComplete != null)
                            OnAddinComplete(xmldoc);
                        //------------------------------------------------------------
                        LoadAddinAction();
                    });
                }
                else
                {
                    if (OnComplete != null)
                        OnComplete();
                }
            };
            LoadAddinAction();            
        }

#if !SILVERLIGHT
        public void LoadAddin(AddinFile addinfile, CodonFactory CodonFactory, Action<XDocument> OnComplete = null)
        {
            if (!File.Exists(addinfile.Path))
            {
                AddinEventService.Instance.AddinLoading(string.Format("没有找到插件文件----{0}", addinfile.Path));

                if (OnComplete != null)
                    OnComplete(null);
                return;
            }

            XDocument AddinTreeDoc = XDocument.Load(addinfile.Path);

            List<XElement> ImportNodes = AddinTreeDoc.XPathSelectElements("/Jet.AppShell.AddinTree/Runtime/Import").ToList();

            List<Assembly> tempLoadedAssemblys = new List<Assembly>();

            foreach (XElement ImportNode in ImportNodes)
            {
                if (ImportNode.Attribute("type").Value == "Assembly")
                {
                    string dllfile = ImportNode.Attribute("source").Value;
                    AddinEventService.Instance.AddinLoading(string.Format("正在加载程序集\"{0}\"", dllfile));

                    Assembly assembly = null;
                    try
                    {
                        assembly = Assembly.Load(dllfile);
                    }
                    catch { }

                    if((assembly!=null) && (!this.LoadedAssemblys.Contains(assembly)))
                    {
                        this.LoadedAssemblys.Add(assembly);
                        tempLoadedAssemblys.Add(assembly);
                    }
                }
            }

            foreach (var assembly in tempLoadedAssemblys)
            {
                CodonFactory.LoadAssemblyCodons(assembly);
            }

            if (OnComplete != null)
                OnComplete(AddinTreeDoc);
        }
#endif

        private List<Assembly> LoadedAssemblys { get; set; }
    }
}
