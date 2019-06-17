using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public static class RecordCheckHelper
    {
        /// <summary>
        /// 比较新、旧记录，获得一个表中需要增、删、改的检查结果,并执行相应的修改
        /// </summary>
        public static void CheckExecute<T>(List<T> objList, string parentIdColumn, int parentId, Func<T, T, bool> isSameObj)
            where T : ObjectMappingBase<T, int>
        {
            var checker = new RecordChecker<T>();
            checker.CheckExecute(objList, parentIdColumn, parentId, isSameObj);
        }

        /// <summary>
        /// 比较新、旧记录，获得一个表中需要增、删、改的检查结果,并执行相应的修改
        /// </summary>
        public static void CheckExecute<T>(List<T> objList, string parentIdColumn, int parentId)
            where T : ObjectMappingBase<T, int>
        {
            var checker = new RecordChecker<T>();
            checker.CheckExecute(objList, parentIdColumn, parentId);
        }
    }
}
