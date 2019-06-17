using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using System.Transactions;
using System.Data.Objects;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    /// <summary>
    /// ILevel接口的对象缓存
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class LevelDBCacheBase<T> : LevelPropertyDBCacheBase<T>
        where T : ObjectMappingBase<T, int>, ILevel<T>
    {
        public override void ResetCache()
        {
            base.ResetCache();
            this.Values.ToList().GenerateTreeStruct(false);//生成树结构
        }

        public override void RefCache()
        {
            base.RefCache();
            this.Values.ToList().GenerateTreeStruct(false);//生成树结构
        }
        
        /// <summary>
        /// 获得树结构
        /// </summary>
        /// <returns></returns>
        public IList<T> GetAllTreeList()
        {
            this.GetOrCreateRootQfolder();
            return this.ObjectDict.GetRootNodeList<T>();
        }       

        /// <summary>
        /// 查询一个对象及其所有子对象，指定是否包含子对象的子对象
        /// </summary>
        public List<T> GetChildListByParentId(int id, bool IsIncludeChildDept = true)
        {
            if (!this.ObjectDict.ContainsKey(id)) return new List<T>();

            if (!IsIncludeChildDept)
            {
                return this.ObjectDict[id].Children.ToList<T>();
            }
            else
            {
                IList<T> allTreeList = this.GetAllTreeList();
                List<T> treeList = new List<T>();
                treeList.Add(this.ObjectDict[id]);
                TreeHelper.ForEachTree<T>(this.ObjectDict[id].Children, new Action<T>((t) => { treeList.Add(t); }));
                return treeList;
            }
        }

        /// <summary>
        /// 创建节点
        /// </summary>
        public T CreateNode(int parentId, string defaultNodeName)
        {
            return this.CreateNode(ConstDB.__ParentId, parentId, defaultNodeName);
        }

        /// <summary>
        /// 查询子对象数量
        /// </summary>
        public int SelectILevelSubCount<ST>(string parentIdColumnName, string fullPath)
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            string likeString = db.GetSqlString_LikeCondition(fullPath + "/", "", "%");

            string strSql = string.Format("SELECT count(*) FROM {0} WHERE {1} in (SELECT Id FROM {2} WHERE FullPath + '/' {3})"
                , typeof(ST).Name, parentIdColumnName, typeof(T).Name, likeString);
            List<int> result = DbHelper.ExecuteQuery<int>(strSql);
            int count = result.FirstOrDefault<int>();

            return count;
        }       

        /// <summary>
        /// 查询子对象数量
        /// </summary>
        public int SelectILevelSubCount<ST>(string parentIdColumnName, int id)
        {
            if (this.ObjectDict.ContainsKey(id))
            {
                return SelectILevelSubCount<ST>(parentIdColumnName, this.ObjectDict[id].FullPath);
            }
            else
            {
                return 0;
            }
        }
    }
}
