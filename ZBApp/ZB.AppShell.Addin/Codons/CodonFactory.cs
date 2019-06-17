using System;
using System.Net;
using System.Collections.Generic;
using System.Reflection;

namespace ZB.AppShell.Addin
{
    public class CodonFactory
    {
        public CodonFactory()
        {
            LoadedCodons = new Dictionary<string, Type>();
        }

        public Dictionary<string, Type> LoadedCodons { get; set; }

        public void LoadAssemblyCodons(Assembly assembly)
        {
            var types = assembly.GetTypes();
            foreach (Type type in types)
            {
                CodonNameAttribute atr = Attribute.GetCustomAttribute(type, typeof(CodonNameAttribute)) as CodonNameAttribute;
                if (atr != null)
                {
                    this.AddCodonType(atr.Name, type);
                }
            }
        }

        public AbstractCodon CreateCodon(string codonname)
        {
            if (this.LoadedCodons.ContainsKey(codonname))
            {
                Type tcodon = this.LoadedCodons[codonname];
                AbstractCodon codon = Activator.CreateInstance(tcodon) as AbstractCodon;
                if (codon != null)
                    return codon;
            }
            throw new AddinException(string.Format("创建 Codon \"{0}\" 失败", codonname));
        }

        public void AddCodonType(string codonname, Type type)
        {
            if (this.LoadedCodons.ContainsKey(codonname))
                throw new AddinException(string.Format("加载 Codon 错误，不能有两个相同的 Codon \"{0}\"", codonname));
            else
                this.LoadedCodons.Add(codonname, type);
        }

        public Type GetCodonType(string codonname)
        {
            if(this.LoadedCodons.ContainsKey(codonname))
                return this.LoadedCodons[codonname] as Type;
            else
                return null;
        }
    }
}
