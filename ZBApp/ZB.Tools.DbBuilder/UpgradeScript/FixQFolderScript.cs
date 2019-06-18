using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public class FixQFolderScript : UpgradeScriptBase
    {
        private class QFolder
        {
            public int Id { get; set; }
            public int ParentId { get; set; }
            public string ObjectName { get; set; }
            public string FullPath { get; set; }
            public int DeptId { get; set; }

            public QFolder Parent { get; set; }
            public int OldDeptId { get; set; }
            public string OldFullPath { get; set; }

            private List<QFolder> _Children = new List<QFolder>();
            public List<QFolder> Children
            {
                get { return _Children; }
                set { _Children = value; }
            }

            public override string ToString()
            {
                return string.Format("Id:{0},PId:{1},Name:{2},FullPath:{3}", this.Id, this.ParentId, this.ObjectName, this.FullPath);
            }
        }

        public string TableName { get; private set; }

        /// <summary>
        /// 遍历树
        /// </summary>
        /// <param name="treeList"></param>
        /// <param name="nodeAction">第一个是Parent,第二个是当前Obj</param>
        private void ForEachTree(List<QFolder> treeList, Action<QFolder, QFolder> nodeAction, QFolder parentObj)
        {
            foreach (QFolder node in treeList)
            {
                nodeAction(parentObj, node);
                ForEachTree(node.Children, nodeAction, node);
            }
        }

        /// <summary>
        /// 查询所有的QFolder
        /// </summary>
        private List<QFolder> GetAllQFolderList(SqlConnection conn)
        {
            string sql = string.Format(@"SELECT Id,DeptId,ObjectName,ParentId,FullPath FROM QFolder");
            SqlCommand cmd = new SqlCommand(sql, conn);
            SqlDataReader dr = cmd.ExecuteReader();
            List<QFolder> qfolderList = new List<QFolder>();
            while (dr.Read())
            {
                QFolder qfolder = new QFolder()
                {
                    Id = (int)dr["Id"],
                    DeptId = (int)dr["DeptId"],
                    ObjectName = (string)dr["ObjectName"],
                    ParentId = (int)dr["ParentId"],
                    FullPath = (string)dr["FullPath"],
                };
                qfolder.OldDeptId = qfolder.DeptId;
                qfolder.OldFullPath = qfolder.FullPath;
                qfolderList.Add(qfolder);
            }
            dr.Close();
            return qfolderList;
        }

        /// <summary>
        /// 重新计算每个节点的DeptId和FullPath
        /// </summary>
        private void RecomputeDeptIdAndFullPath(List<QFolder> qfolderList)
        {
            var qfolderDic = qfolderList.ToDictionary(r => r.Id);
            foreach (QFolder qfolder in qfolderList)
            {
                if (qfolderDic.ContainsKey(qfolder.ParentId))
                {
                    var parent = qfolderDic[qfolder.ParentId];
                    qfolder.Parent = parent;
                    parent.Children.Add(qfolder);
                }
            }

            var folderTreeList = qfolderList.Where(r => r.ParentId == 0).ToList();
            this.ForEachTree(folderTreeList, (parentQFolder, qfolder) =>
            {
                if (parentQFolder == null)
                {
                    qfolder.FullPath = qfolder.ObjectName;
                }
                else
                {
                    qfolder.DeptId = parentQFolder.DeptId;
                    qfolder.FullPath = string.Format("{0}/{1}", parentQFolder.FullPath, qfolder.ObjectName);
                }
            }, null);

            //检查新的树结构数据
            HashSet<string> hs = new HashSet<string>();
            for (int i = 0; i < qfolderList.Count; i++)
            {
                var qfolder = qfolderList[i];
                string key = string.Format("{0}_{1}", qfolder.DeptId, qfolder.FullPath);

                if (!hs.Contains(key))
                    hs.Add(key);
                else
                    throw new Exception(string.Format("存在重复的DeptId_QFolderFullPath:{0}_{1}", qfolder.DeptId, qfolder.FullPath));
            }
        }

        public override bool ExcuteUpgradeScript()
        {
            if (!this.CheckDbExist())
                return true;

            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3};Connect Timeout=600", this.DbManager.SqlScript.Server, this.DbName, this.DbManager.SqlScript.UID, this.DbManager.SqlScript.PWD);
            var conn = this.DbManager.CreateConnection(connStr);
            SqlTransaction tran = null;

            try
            {
                conn.Open();

                List<QFolder> qfolderList = this.GetAllQFolderList(conn);
                this.RecomputeDeptIdAndFullPath(qfolderList);

                tran = conn.BeginTransaction();
                //去掉唯一索引
                SqlCommand dropIndexcmd = new SqlCommand(@"IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[QFolder]') AND name = N'IDX_QFolder_DeptIdFullPath')
                                                            DROP INDEX [IDX_QFolder_DeptIdFullPath] ON [QFolder]", conn, tran);
                dropIndexcmd.ExecuteNonQuery();

                //判断Dept或FullPath发生改变的，就执行更新
                for (int i = 0; i < qfolderList.Count; i++)
                {
                    var qfolder = qfolderList[i];
                    if (qfolder.DeptId != qfolder.OldDeptId || qfolder.FullPath != qfolder.OldFullPath)
                    {
                        string updateSql = string.Format("UPDATE QFolder SET DeptId={0},FullPath='{1}' WHERE Id={2}", qfolder.DeptId, qfolder.FullPath, qfolder.Id);
                        SqlCommand updateCmd = new SqlCommand(updateSql, conn, tran);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                //创建唯一索引
                SqlCommand createIndexcmd = new SqlCommand(@"CREATE UNIQUE NONCLUSTERED INDEX [IDX_QFolder_DeptIdFullPath] ON [dbo].[QFolder] 
                                                            (
	                                                            [DeptId] ASC,
	                                                            [FullPath] ASC
                                                            )", conn, tran);
                createIndexcmd.ExecuteNonQuery();

                tran.Commit();

                RtfInfoHelper.AddSuccessInfo(this.DbManager.RtbInfo, "脚本[FixQFolderScript]执行成功!");
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[FixQFolderScript]执行失败!");
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, ex.Message);
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
