using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Linq.Expressions;

namespace ZB.Framework.ObjectMapping
{
    public static class StoreCommandIsland_ObjectMappingBaseExtend
    {

        public static void IslandUpdate<T, PK>(this ObjectMappingBase<T, PK> source, StoreCommandIsland island, HashSet<string> props = null) where T : ObjectMappingBase
        {
            island.AppendCommands(island.Database.GetUpdateCommand(source, props));
        }

        /// <summary>
        /// 更新对象(完全更新)
        /// </summary>
        public static void IslandUpdate<T, PK>(this ObjectMappingBase<T, PK> source, StoreCommandIsland island, params string[] updatePropertys) where T : ObjectMappingBase
        {
            HashSet<string> props = new HashSet<string>();
            foreach (var p in updatePropertys)
            {
                props.Add(p);
            }
            island.AppendCommands(island.Database.GetUpdateCommand(source, props));
        }

        /// <summary>
        /// 更新对象(支持部分更新)
        /// </summary>
        public static void IslandUpdate<T, PK>(this ObjectMappingBase<T, PK> source, StoreCommandIsland island, Expression<Func<T, object>> updateExpression) where T : ObjectMappingBase
        {
            UpdateColumnsVisitor Visitor = new UpdateColumnsVisitor();
            Visitor.Visit(updateExpression);
            if (Visitor.UpdatePropertys.Count == 0)
                throw new ObjectMappingException("Visitor.UpdatePropertys.Count is zero!");
            island.AppendCommands(island.Database.GetUpdateCommand(source, Visitor.UpdatePropertys));
        }

        /// <summary>
        /// 删除对象
        /// </summary>
        public static void IslandDelete<T, PK>(this ObjectMappingBase<T, PK> source, StoreCommandIsland island) where T : ObjectMappingBase
        {
            island.AppendCommands(island.Database.GetDeleteCommand(source));
        }
    }
}
