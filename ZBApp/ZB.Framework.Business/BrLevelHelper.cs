using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects;
using System.Transactions;
using ZB.Framework.Utility;
using System.Collections.ObjectModel;
using ZB.Framework.ObjectMapping;

namespace ZB.Framework.Business
{
    public static class BrLevelHelper
    {
        public static T CreateNode<T, PT>(string parentColumnName, int parentId, Action<T, PT, int> beforeCreateNode, string defaultNodeName = "新建文件夹", string condition = "")
            where T : ObjectMappingBase<T, int>, IParent
            where PT : ObjectMappingBase<PT, int>, IParent
        {
            if (!string.IsNullOrEmpty(condition))
                condition = string.Format(" AND {0}", condition);

            StoreCommand sc1 = new StoreCommand()
            {
                CommandText = string.Format("SELECT * FROM {0} WHERE Id={{0}}", typeof(PT).Name),
                Parameters = new object[] { parentId }
            };
            PT parentNode = DbHelper.ExecuteQuery<PT>(sc1).FirstOrDefault();//Id等于0为空

            StoreCommand sc2 = new StoreCommand()
            {
                CommandText = string.Format("SELECT ObjectName FROM {0} WHERE {1}={{0}} {2}", typeof(T).Name, parentColumnName, condition),
                Parameters = new object[] { parentId }
            };
            List<string> nameList = DbHelper.ExecuteQuery<string>(sc2);

            string nodeName = BrObjectNameHelper.GetNewName(nameList, defaultNodeName);

            T node = Activator.CreateInstance<T>();
            node.ObjectName = nodeName;
            if (parentNode == null)
            {
                node.FullPath = node.ObjectName;
            }
            else
            {
                node.FullPath = string.Format("{0}/{1}", parentNode.FullPath, node.ObjectName);
            }
            node.ParentId = parentId;

            if (beforeCreateNode != null)
            {
                beforeCreateNode(node, parentNode, nameList.Count + 1);
            }

            node.Create();
            return node;
        }

        public static T CreateSortableNode<T, PT>(string parentColumnName, int parentId, string defaultNodeName = "新建文件夹")
            where T : ObjectMappingBase<T, int>, IParent, ISortable
            where PT : ObjectMappingBase<PT, int>, IParent, ISortable
        {
            Action<T, PT, int> beforeCreateNode = new Action<T, PT, int>((node, parentNode, count) =>
                {
                    node.SortIndex = count;
                });
            return CreateNode<T, PT>(parentColumnName, parentId, beforeCreateNode, defaultNodeName);
        }

        public static T CreateNode<T>(string parentColumnName, int parentId, Action<T, T, int> beforeCreateNode, string defaultNodeName = "新建文件夹")
            where T : ObjectMappingBase<T, int>, IParent
        {
            return CreateNode<T, T>(parentColumnName, parentId, beforeCreateNode, defaultNodeName);
        }

        /// <summary>
        /// 更新全路径或节点名
        /// </summary>
        private static void UpdateFullPath<T>(T obj, T parentNode, string newName, Action<UpdateCriteria> updateFullPathAction = null, Action<UpdateCriteria> updateObjAction = null)
            where T : ObjectMappingBase<T, int>, IParent
        {
            string oldFullPathSql = string.Format("SELECT FullPath FROM {0} WHERE {1}={2}"
                                                , typeof(T).Name
                                                , ConstDB.__Id
                                                , obj.Id);
            string oldFullPath = DbHelper.ExecuteScalar<string>(oldFullPathSql);

            string newFullPath = string.Empty;
            if (parentNode != null)
            {
                newFullPath = parentNode.FullPath + "/" + newName;
                obj.ParentId = parentNode.Id;
            }
            else
            {
                newFullPath = newName;
                obj.ParentId = 0;
            }

            UpdateCriteria updateName = new UpdateCriteria(typeof(T).Name);
            updateName.UpdateColumn("ParentId", obj.ParentId);
            updateName.UpdateColumn(ConstDB.__ObjectName, newName);
            updateName.UpdateColumn(ConstDB.__FullPath, newFullPath);
            updateName.Conditions.AddEqualTo(ConstDB.__Id, obj.Id);
            if (updateObjAction != null)
                updateObjAction(updateName);
            updateName.Perform();

            UpdateCriteria updateFullPath = new UpdateCriteria(typeof(T).Name);
            updateFullPath.UpdateStatement("FullPath = stuff(FullPath,1,@PLength,@PNewFullPath)"
                , new Parameter("PLength", oldFullPath.Length)
                , new Parameter("PNewFullPath", newFullPath));

            updateFullPath.Conditions.AddMatchPrefix("FullPath + '/'", oldFullPath + "/");

            if (updateFullPathAction != null)
                updateFullPathAction(updateFullPath);
            updateFullPath.Perform();
        }

        /// <summary>
        /// 重命名
        /// </summary>
        /// <param name="node"></param>
        /// <param name="newQFolderName"></param>
        public static bool Rename<T>(Dictionary<int, T> sameLevelObjDic, int id, string newName, Action<UpdateCriteria> updateAction = null)
            where T : ObjectMappingBase<T, int>, IParent
        {
            if (sameLevelObjDic.ContainsKey(id))
            {
                T node = sameLevelObjDic[id];
                //同级节点不允许重名
                foreach (T nodeTemp in sameLevelObjDic.Values)
                {
                    if (nodeTemp.Id != node.Id)
                    {
                        if (nodeTemp.ParentId == node.ParentId && nodeTemp.ObjectName == newName)
                        {
                            return false;
                        }
                    }
                }

                StoreCommand sc1 = new StoreCommand()
                {
                    CommandText = string.Format("SELECT * FROM {0} WHERE Id={{0}}", typeof(T).Name),
                    Parameters = new object[] { node.ParentId }
                };
                T parentNode = DbHelper.ExecuteQuery<T>(sc1).FirstOrDefault();

                UpdateFullPath<T>(node, parentNode, newName, updateAction);

                return true;
            }

            return false;
        }

        /// <summary>
        /// 拖动更新
        /// </summary>
        public static void UpdateForDrag<T>(T dragNode, T parentNode, IList<T> sortNodeList, Action<UpdateCriteria> updateFullPathAction = null, Action<UpdateCriteria> updateObjAction = null)
            where T : ObjectMappingBase<T, int>, IParent, ISortable
        {
            UpdateFullPath<T>(dragNode, parentNode, dragNode.ObjectName, updateFullPathAction, updateObjAction);
            BrSortableHelper.UpdateSortIndex<T>(sortNodeList);
        }

        /// <summary>
        /// 拖动更新
        /// </summary>
        public static void UpdateForDrag<T>(Dictionary<int, T> objDic, T dragNode, IList<T> sortNodeList)
            where T : ObjectMappingBase<T, int>, IParent, ISortable
        {
            if (sortNodeList.Count == 0)
                throw new ApplicationException("拖动更新的排序列表不能为空!");

            T parentNode = null;
            if (objDic.ContainsKey(dragNode.ParentId))
            {
                parentNode = objDic[dragNode.ParentId];
            }
            UpdateFullPath<T>(dragNode, parentNode, dragNode.ObjectName);
            BrSortableHelper.UpdateSortIndex<T>(objDic, sortNodeList);
        }

        /// <summary>
        /// 删除一个文件夹及其所有子文件
        /// </summary>
        /// <param name="folderId">文件夹ID</param>
        public static void DeleteNode<T>(T obj)
            where T : ObjectMappingBase<T, int>, IParent
        {
            DeleteCriteria delete = new DeleteCriteria(typeof(T).Name);
            delete.Conditions.AddMatchPrefix("FullPath + '/'", obj.FullPath + "/");
            delete.Perform();
        }

        /// <summary>
        /// 删除一个文件夹及其所有子文件
        /// </summary>
        /// <param name="folderId">文件夹ID</param>
        public static void DeleteSubByParentId<PT, ST>(DBCacheBase<int, ST> subDBCache, PT parent, string parentIdName)
            where PT : ObjectMappingBase<PT, int>, IParent
            where ST : ObjectMappingBase<ST, int>
        {
            DatabaseEngine db = DatabaseEngineFactory.GetDatabaseEngine();
            string likeString = db.GetSqlString_LikeCondition(parent.FullPath + "/", "", "%");
            string strSQL = string.Format("DELETE FROM {0} WHERE {1} in (SELECT id FROM {2} WHERE FullPath + '/' {3})", typeof(ST).Name, parentIdName, typeof(PT).Name, likeString);
            db.ExecuteNonQuery(strSQL);
        }
    }
}
