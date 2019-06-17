using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Entity;
using System.Linq.Expressions;
using System.Transactions;

namespace ZB.Framework.ObjectMapping
{
    public static class ObjectMappingBaseExtend
    {
        /// <summary>
        /// 创建对象
        /// </summary>
        public static int Create<T, PK>(this ObjectMappingBase<T, PK> source) where T : ObjectMappingBase
        {
            return DatabaseEngineFactory.GetDatabaseEngine().Create(source);
        }

        /// <summary>
        /// 删除对象
        /// </summary>
        public static int Delete<T, PK>(this ObjectMappingBase<T, PK> source) where T : ObjectMappingBase
        {
            return DatabaseEngineFactory.GetDatabaseEngine().Delete(source);
        }

        /// <summary>
        /// 更新对象(完全更新)
        /// </summary>
        public static int Update<T, PK>(this ObjectMappingBase<T, PK> source, params string[] updatePropertys) where T : ObjectMappingBase
        {
            HashSet<string> props = new HashSet<string>();
            foreach (var p in updatePropertys)
            {
                props.Add(p);
            }
            return DatabaseEngineFactory.GetDatabaseEngine().Update(source,props);
        }

        /// <summary>
        /// 更新对象(支持部分更新)
        /// </summary>
        public static int Update<T, PK>(this ObjectMappingBase<T, PK> source, Expression<Func<T, object>> updateExpression) where T : ObjectMappingBase
        {
            UpdateColumnsVisitor Visitor = new UpdateColumnsVisitor();
            Visitor.Visit(updateExpression);
            if (Visitor.UpdatePropertys.Count == 0)
                throw new ObjectMappingException("Visitor.UpdatePropertys.Count is zero!");
            return DatabaseEngineFactory.GetDatabaseEngine().Update(source, Visitor.UpdatePropertys);
        }

    }
}
