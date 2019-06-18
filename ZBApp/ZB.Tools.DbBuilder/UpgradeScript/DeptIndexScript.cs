using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using ZB.Framework.Utility;
using ZB.Framework.ObjectMapping;

namespace ZB.Tools.DbBuilder
{
    public class DeptIndexScript : UpgradeScriptBase
    {
        private class Dept
        {
            public const int OutsideDeptId = -10000000;

            public int Id { get; set; }
            public int ParentId { get; set; }
            public string ObjectName { get; set; }
            public int SortIndex { get; set; }
            public int DeptIndex { get; set; }

            private List<Dept> _Children = new List<Dept>();
            public List<Dept> Children
            {
                get { return _Children; }
                set { _Children = value; }
            }
        }

        /// <summary>
        /// 检查DeptIndex列是否存在
        /// </summary>
        private void CheckDeptIndex(SqlConnection conn)
        {
            try
            {
                conn.Open();
                SqlCommand selectIndexcmd = new SqlCommand(@"SELECT COUNT(*) FROM syscolumns WHERE id = object_id('Dept') AND name='DeptIndex'", conn);
                int count = (int)selectIndexcmd.ExecuteScalar();
                if (count == 0)
                {
                    //添加DeptIndex列
                    SqlCommand addIndexcmd = new SqlCommand(@"ALTER TABLE [Dept] ADD DeptIndex INT NOT NULL DEFAULT 0", conn);
                    addIndexcmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[DeptIndexScript]--CheckDeptIndex方法异常!");
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, ex.Message);
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        /// <summary>
        /// 获得Dept树集合
        /// </summary>
        private List<Dept> GetDeptRootList(SqlConnection conn)
        {
            SqlDataReader dr = null;
            try
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(string.Format("SELECT Id,ObjectName,ParentId,SortIndex FROM Dept WHERE Id<>{0} ORDER BY SortIndex", Dept.OutsideDeptId), conn);
                dr = cmd.ExecuteReader();
                List<Dept> deptList = new List<Dept>();
                while (dr.Read())
                {
                    Dept dept = new Dept()
                    {
                        Id = (int)dr["Id"],
                        ParentId = (int)dr["ParentId"],
                        ObjectName = dr["ObjectName"].ToString(),
                        SortIndex = (int)dr["SortIndex"]
                    };
                    deptList.Add(dept);
                }

                List<Dept> rootTreeList = new List<Dept>();
                Dictionary<int, Dept> dic = deptList.ToDictionary(r => r.Id, r => r);
                foreach (var dept in deptList)
                {
                    if (dic.ContainsKey(dept.ParentId))
                        dic[dept.ParentId].Children.Add(dept);
                }

                foreach (Dept dept in deptList)
                {
                    if (!dic.ContainsKey(dept.ParentId))
                        rootTreeList.Add(dept);
                }
                return rootTreeList;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[DeptIndexScript]--GetDeptRootList方法异常!");
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, ex.Message);
                throw ex;
            }
            finally
            {
                if (dr != null)
                    dr.Close();
                conn.Close();
            }
        }

        /// <summary>
        /// 更新DeptIndex字段
        /// </summary>
        private void UpdateDeptIndex(SqlConnection conn, List<Dept> rootTreeList)
        {
            SqlTransaction tran = null;
            try
            {
                conn.Open();
                tran = conn.BeginTransaction();

                List<string> updateSqlList = new List<string>();

                int deptIndex = 1;
                rootTreeList.ForeachTree(r => r.Children, r =>
                {
                    r.DeptIndex = deptIndex++;
                    updateSqlList.Add(string.Format("UPDATE Dept SET DeptIndex={0} WHERE Id={1}", r.DeptIndex, r.Id));
                });

                while (updateSqlList.Count > 0)
                {
                    int updateCount = 100;
                    if (updateSqlList.Count < 100)
                        updateCount = updateSqlList.Count;

                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < updateCount; i++)
                    {
                        sb.Append(updateSqlList[i] + ";");
                    }

                    updateSqlList.RemoveRange(0, updateCount);

                    SqlCommand updateCmd = new SqlCommand(sb.ToString(), conn, tran);
                    updateCmd.ExecuteNonQuery();
                }

                tran.Commit();
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[DeptIndexScript]--UpdateDeptIndex方法异常!");
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, ex.Message);
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        public override bool ExcuteUpgradeScript()
        {
            if (!this.CheckDbExist())
                return true;

            string connStr = string.Format("Data Source={0};Initial Catalog={1};UID={2};PWD={3};Connect Timeout=600", this.DbManager.SqlScript.Server, this.DbName, this.DbManager.SqlScript.UID, this.DbManager.SqlScript.PWD);
            var conn = this.DbManager.CreateConnection(connStr);

            try
            {
                //判断列是否存在，存在就返回，不存在就创建列
                CheckDeptIndex(conn);
                //得到部门树,计算每个部门的DeptIndex
                var rootTreeList = GetDeptRootList(conn);
                //批量更新部门的DeptIndex    
                UpdateDeptIndex(conn, rootTreeList);

                RtfInfoHelper.AddSuccessInfo(this.DbManager.RtbInfo, "脚本[DeptIndexScript]执行成功!");
                return true;
            }
            catch (Exception ex)
            {
                RtfInfoHelper.AddErrorInfo(this.DbManager.RtbInfo, "脚本[DeptIndexScript]执行失败!");
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
