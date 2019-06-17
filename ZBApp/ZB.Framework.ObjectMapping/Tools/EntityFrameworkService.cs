using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity.ModelConfiguration;
using System.Linq.Expressions;
using System.Data.Entity.ModelConfiguration.Configuration;
using System.Reflection;
using Microsoft.Practices.EnterpriseLibrary.Data;
using ZB.Framework.Utility;

namespace ZB.Framework.ObjectMapping
{
    public class EntityFrameworkService
    {
        public static readonly EntityFrameworkService Instance = new EntityFrameworkService();

        private EntityFrameworkService()
        {

        }

        public EntityTypeConfiguration<T> CreateEntityTypeConfiguration<T>() where T : ObjectMappingBase
        {
            Type T_Type = typeof(T);
            TableMapping tablemapping = MappingService.Instance.GetTableMapping(T_Type);
            if (tablemapping.BaseTableMapping != null)
                return null;

            EntityTypeConfiguration<T> entityconfig = new EntityTypeConfiguration<T>();
            Type T_EntityTypeConfiguration = typeof(EntityTypeConfiguration<T>);
            
            entityconfig.ToTable(tablemapping.Name);

            T_EntityTypeConfiguration.GetMethod("HasKey").MakeGenericMethod(tablemapping.ColumnPK.ColumnType)
                .Invoke(entityconfig, new object[] { ExpressionHelper.GetExpression_Func_Type_Property(T_Type, tablemapping.ColumnPK.PropertyName) });

            foreach (ColumnMapping column in tablemapping.Columns)
            {
                LambdaExpression exp_property = ExpressionHelper.GetExpression_Func_Type_Property(T_Type, column.PropertyName);
                PrimitivePropertyConfiguration propcfg = null;

                if (column.ColumnType == typeof(string))
                    propcfg = entityconfig.Property((Expression<Func<T, string>>)exp_property);
                else if (column.ColumnType == typeof(int))
                    propcfg = entityconfig.Property((Expression<Func<T, int>>)exp_property);
                else if (column.ColumnType == typeof(int?))
                    propcfg = entityconfig.Property((Expression<Func<T, int?>>)exp_property);
                else if (column.ColumnType == typeof(long))
                    propcfg = entityconfig.Property((Expression<Func<T, long>>)exp_property);
                else if (column.ColumnType == typeof(long?))
                    propcfg = entityconfig.Property((Expression<Func<T, long?>>)exp_property);
                else if (column.ColumnType == typeof(bool))
                    propcfg = entityconfig.Property((Expression<Func<T, bool>>)exp_property);
                else if (column.ColumnType == typeof(bool?))
                    propcfg = entityconfig.Property((Expression<Func<T, bool?>>)exp_property);
                else if (column.ColumnType == typeof(double))
                    propcfg = entityconfig.Property((Expression<Func<T, double>>)exp_property);
                else if (column.ColumnType == typeof(double?))
                    propcfg = entityconfig.Property((Expression<Func<T, double?>>)exp_property);
                else if (column.ColumnType == typeof(float))
                    propcfg = entityconfig.Property((Expression<Func<T, float>>)exp_property);
                else if (column.ColumnType == typeof(float?))
                    propcfg = entityconfig.Property((Expression<Func<T, float?>>)exp_property);
                else if (column.ColumnType == typeof(decimal))
                    propcfg = entityconfig.Property((Expression<Func<T, decimal>>)exp_property);
                else if (column.ColumnType == typeof(decimal?))
                    propcfg = entityconfig.Property((Expression<Func<T, decimal?>>)exp_property);
                else if (column.ColumnType == typeof(DateTime))
                    propcfg = entityconfig.Property((Expression<Func<T, DateTime>>)exp_property);
                else if (column.ColumnType == typeof(DateTime?))
                    propcfg = entityconfig.Property((Expression<Func<T, DateTime?>>)exp_property);
                else if (column.ColumnType == typeof(byte[]))
                    propcfg = entityconfig.Property((Expression<Func<T, byte[]>>)exp_property);

                if (propcfg != null)
                    propcfg.HasColumnName(column.Name);
                else
                    throw new ObjectMappingException("Convert To Entity Framework Mapping Error!");
            }

            foreach (PropertyInfo otherprop in tablemapping.OtherPropertys)
            {
                LambdaExpression exp_property = ExpressionHelper.GetExpression_Func_Type_Property(T_Type, otherprop.Name);
                T_EntityTypeConfiguration.GetMethod("Ignore").MakeGenericMethod(otherprop.PropertyType).Invoke(entityconfig, new object[] { exp_property });
            }

            return entityconfig;
        }
    }
}
