using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using System.Data.Common;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Data.Entity.ModelConfiguration;
using System.Reflection;
using System.Linq.Expressions;
using System.Data.Entity.ModelConfiguration.Configuration;
using System.IO;
using System.Collections;

namespace ZB.Framework.ObjectMapping
{
    public class ObjectMappingDbContext : DbContext
    {
        public ObjectMappingDbContext(DbConnection dbcon)
            : base(dbcon,true)
        {
            this.Configuration.ProxyCreationEnabled = false;
            this.Configuration.AutoDetectChangesEnabled = false;
            this.Configuration.LazyLoadingEnabled = false;
            this.Configuration.ValidateOnSaveEnabled = false;
        }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            List<Type> omlist = new List<Type>();
            //var AssemblyList = AppDomain.CurrentDomain.GetAssemblies();
            //foreach (var AssemblyItem in AssemblyList)
            //{
            //    var TypeList = AssemblyItem.GetTypes();
            //    foreach (var TypeItem in TypeList)
            //    {
            //        TableAttribute tableattribute = Attribute.GetCustomAttribute(TypeItem, typeof(TableAttribute), true) as TableAttribute;
            //        if (tableattribute != null)
            //        {
            //            omlist.Add(TypeItem);
            //        }
            //    }
            //}

            //var AssemblyList = Directory.GetFiles(AppDomain.CurrentDomain.RelativeSearchPath, "*.dll");
            var AssemblyList = AppDomain.CurrentDomain.GetAssemblies();
            //foreach (var AssemblyPath in AssemblyList)
            foreach (var AssemblyItem in AssemblyList)
            {
                try
                {
                    //var AssemblyItem = Assembly.LoadFile(AssemblyPath);
                    var TypeList = AssemblyItem.GetTypes();
                    foreach (var TypeItem in TypeList)
                    {
                        TableAttribute tableattribute = Attribute.GetCustomAttribute(TypeItem, typeof(TableAttribute), false) as TableAttribute;
                        if (tableattribute != null)
                        {
                            omlist.Add(TypeItem);
                        }
                    }

                }
                catch{}
            }

            Type T_EntityFrameworkService = typeof(EntityFrameworkService);
            MethodInfo M_CreateEntityTypeConfiguration = T_EntityFrameworkService.GetMethod("CreateEntityTypeConfiguration");

            Type T_ModelBuilder_Configurations = modelBuilder.Configurations.GetType();
            MethodInfo M_Add = T_ModelBuilder_Configurations.GetMethods().Where(o => o.Name == "Add" && o.GetGenericArguments()[0].Name == "TEntityType").First();
            
            foreach(Type tItem in omlist)
            {
                if (tItem.ContainsGenericParameters == false)
                {
                    object EntityTypeConfigItem = M_CreateEntityTypeConfiguration.MakeGenericMethod(tItem).Invoke(EntityFrameworkService.Instance, new object[] { });
                    if (EntityTypeConfigItem == null)
                        continue;
                    M_Add.MakeGenericMethod(tItem).Invoke(modelBuilder.Configurations, new object[] { EntityTypeConfigItem });
                }
            }
            //Discriminator
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}
