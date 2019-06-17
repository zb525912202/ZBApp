using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 有深度接口的ILevel对象缓存(如部门)
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class DepthLevelDBCacheBase<T> : LevelDBCacheBase<T>
        where T : ObjectMappingBase<T, int>, ILevel<T>, IDepth
    {
        /// <summary>
        /// 检查更新指定节点及其子节点的深度（根据父节点）
        /// </summary>
        private void CheckUpateDepth(T obj, T parentObj, StoreCommandIsland island, HashSet<string> updateprops, Func<T, T, int> getDepthFunc)
        {
            if (parentObj == null)
            {
                if (obj.Depth != 1)//根部门深度为1
                {
                    obj.Depth = 1;
                    obj.IslandUpdate(island, updateprops);
                }
            }
            else
            {
                int newDepth = getDepthFunc(obj, parentObj);

                if (obj.Depth != newDepth)
                {
                    obj.Depth = newDepth;
                    obj.IslandUpdate(island, updateprops);
                }
            }

            foreach (T subObj in obj.Children)
            {
                this.CheckUpateDepth(subObj, obj, island, updateprops, getDepthFunc);
            }
        }

        /// <summary>
        /// 检查更新所有的深度
        /// </summary>        
        protected void CheckAllDepth(Func<T, T, int> getDepthFunc)
        {
            StoreCommandIsland island = new StoreCommandIsland();
            HashSet<string> updateprops = new HashSet<string>();
            updateprops.Add("Depth");

            T rootObj = this.GetOrCreateRootQfolder();

            this.CheckUpateDepth(rootObj, null, island, updateprops, getDepthFunc);
            island.BatchCommit();
        }

        /// <summary>
        /// 检查更新所有的深度(在缓存修改后调用)
        /// </summary>
        public abstract void CheckAllDepth();
    }
}
