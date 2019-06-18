using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Xml;

namespace ZB.Tools.DbBuilder
{
    public partial class FrmDbBuilder : Form
    {
        private const string ScriptConfigFileName = "ScriptConfig.xml";

        public ZBDbManager DbManager;
        public FrmDbBuilder()
        {
            InitializeComponent();

            this.dgDbObjList.AutoGenerateColumns = false;
            //设置不许手动调整列的宽度
            this.dgDbObjList.AllowUserToResizeColumns = false;
            this.dgDbObjList.RowTemplate.MinimumHeight = 40;
            this.dgDbObjList.Columns[1].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            this.dgDbObjList.Columns[2].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;

            this.Load += (s, e) =>
            {
#if DEBUG
                DirectoryInfo dir = new DirectoryInfo(System.AppDomain.CurrentDomain.BaseDirectory);
                this.tbScriptDir.Text = Path.Combine(dir.Parent.Parent.FullName, "SqlScripts");
#else
                DirectoryInfo dir = new DirectoryInfo(System.Windows.Forms.Application.ExecutablePath);
                this.tbScriptDir.Text = Path.Combine(dir.Parent.FullName, "SqlScripts");
#endif

                string filePath = Path.Combine(this.tbScriptDir.Text, ScriptConfigFileName);
                //如果文件存在，就读取数据
                if (File.Exists(filePath))
                {
                    string scriptConfigXmlFullPath = Path.Combine(this.tbScriptDir.Text, ScriptConfigFileName);
                    XmlDocument doc = new XmlDocument();
                    doc.Load(scriptConfigXmlFullPath);
                    XmlElement connEle = doc["ScriptConfig"];

                    this.ReadConfigValue(connEle, "Server", this.tbServer);
                    this.ReadConfigValue(connEle, "UID", this.tbUID);
                    this.ReadConfigValue(connEle, "PWD", this.tbPWD);
                    this.ReadConfigValue(connEle, "Dbs", this.tbDbs);
                    this.ReadConfigValue(connEle, "DbPath", this.tbDbPath);
                }
                else
                {
                    MessageBox.Show("没有找到配置文件!");
                    return;
                }
            };
        }

        private bool ReadConfigValue(XmlElement ele, string str, TextBox tb)
        {
            var subEleList = ele.GetElementsByTagName(str);
            if (subEleList.Count == 1)
            {
                tb.Text = subEleList.Item(0).Attributes["Value"].Value;
                return true;
            }
            else
            {
                RtfInfoHelper.AddErrorInfo(this.rtbInfo, string.Format("文件[ScriptConfig.xml]内的节点{0}必须有且只有一个!", str));
                return false;
            }
        }

        private void btnSelectScriptDir_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dialog = new FolderBrowserDialog();
            dialog.SelectedPath = this.tbScriptDir.Text;
            if (dialog.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                this.tbScriptDir.Text = dialog.SelectedPath;
                string scriptConfigXmlFullPath = Path.Combine(this.tbScriptDir.Text, ScriptConfigFileName);
                //如果文件存在，就读取数据
                if (File.Exists(scriptConfigXmlFullPath))
                {
                    XmlDocument doc = new XmlDocument();
                    doc.Load(scriptConfigXmlFullPath);
                    XmlElement connEle = doc["ScriptConfig"];

                    this.ReadConfigValue(connEle, "Server", this.tbServer);
                    this.ReadConfigValue(connEle, "UID", this.tbUID);
                    this.ReadConfigValue(connEle, "PWD", this.tbPWD);
                    this.ReadConfigValue(connEle, "Dbs", this.tbDbs);
                    this.ReadConfigValue(connEle, "DbPath", this.tbDbPath);
                }
                else
                {
                    MessageBox.Show("没有找到配置文件!");
                    return;
                }
            }
        }

        public void ReConnect(bool isClearInfo)
        {
            if (isClearInfo)
            {
                this.rtbInfo.Clear();
                Application.DoEvents();
            }

            this.DbManager = new ZBDbManager(this.rtbInfo,
                                            this.tbScriptDir.Text,
                                            this.tbServer.Text,
                                            this.tbUID.Text,
                                            this.tbPWD.Text,
                                            this.tbDbs.Text,
                                            this.tbDbPath.Text);

            if (this.DbManager.ConnectDb())
            {
                string scriptUpgradeDir = Path.Combine(this.DbManager.SqlScript.ScriptDirFullPath, ZBDbManager.ScriptUpgradeDir);
                this.btnUpgrade.Enabled = Directory.Exists(scriptUpgradeDir);

                this.dgDbObjList.DataSource = this.DbManager.SqlScript.DbScriptList;
            }
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            this.ReConnect(true);
        }

        private void RebuildDb(ZBDbScript script, RebuildDbGroup rebuildDbGroup)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            this.DbManager.RebuildDb(script, rebuildDbGroup);
        }

        private void RebuildDb(ZBDbScript script)
        {
            RebuildDbGroup rebuildDbGroup = null;

            if (script.DbConfig.RebuildDbGroupList.Count == 1)
            {
                rebuildDbGroup = script.DbConfig.RebuildDbGroupList.First();

                if (MessageBox.Show(string.Format("确定要创建数据库{0}吗?", script.DbFullName), "提示信息", MessageBoxButtons.OKCancel, MessageBoxIcon.Information) == DialogResult.OK)
                {
                    if (DbManager.ExistsDb(script.DbFullName) && !(MessageBox.Show(string.Format("已经存在数据库{0}，还要重建吗?", script.DbFullName), "提示信息", MessageBoxButtons.OKCancel) == DialogResult.OK))
                        return;
                }
                else
                {
                    return;
                }
            }
            else if (script.DbConfig.RebuildDbGroupList.Count > 1)
            {
                FrmCreateDb frm = new FrmCreateDb(script);

                if (frm.ShowDialog() == DialogResult.OK)
                {
                    if (DbManager.ExistsDb(script.DbFullName) && !(MessageBox.Show(string.Format("已经存在数据库{0}，还要重建吗?", script.DbFullName), "提示信息", MessageBoxButtons.OKCancel) == DialogResult.OK))
                        return;
                    else
                        rebuildDbGroup = frm.SelectRebuildDbGroup;
                }
                else
                    return;
            }
            else
            {
                RtfInfoHelper.AddErrorInfo(this.rtbInfo, string.Format("没有找到[{0}]下面的建库脚本!", script.DbFullName));
                return;
            }

            this.RebuildDb(script, rebuildDbGroup);
            this.ReConnect(false);
        }

        private void dgDbObjList_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int createDbColumnIndex = 3;
            var row = this.dgDbObjList.Rows[e.RowIndex];

            ZBDbScript script = row.DataBoundItem as ZBDbScript;

            if (e.ColumnIndex == createDbColumnIndex)//创建数据库
            {
                this.RebuildDb(script);
            }
            else if (e.ColumnIndex == createDbColumnIndex + 1)//创建视图
            {
                this.rtbInfo.Clear();
                Application.DoEvents();
                this.DbManager.RebuildView(script);
            }
            else if (e.ColumnIndex == createDbColumnIndex + 2)//收缩
            {
                this.rtbInfo.Clear();
                Application.DoEvents();

                if (!DbManager.ExistsDb(script.DbFullName))
                {
                    RtfInfoHelper.AddErrorInfo(this.rtbInfo, string.Format("数据库{0}不存在,不能收缩!", script.DbFullName));
                }
                else
                {
                    this.DbManager.Shrink(script.DbFullName);
                    this.ReConnect(false);
                }
            }
        }

        private void btnExport_Click(object sender, EventArgs e)
        {
            string strDir = "";
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.Filter = "文本文档(*.txt)|*.txt";
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                for (int i = 0; i < this.rtbInfo.Lines.Count(); i++)
                {
                    strDir += this.rtbInfo.Lines[i] + "\r\n";
                }
                File.WriteAllText(dialog.FileName, strDir);
            }
        }

        private void btnUpgrade_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            this.DbManager.Upgrade();
        }

        private void btnStopSQLServer_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            RtfInfoHelper.AddSuccessInfo(this.rtbInfo, ProcessHelper.StopSQLServer("SQL2008"));
        }

        private void btnStartSQLServer_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            RtfInfoHelper.AddSuccessInfo(this.rtbInfo, ProcessHelper.StartSQLServer("SQL2008"));
        }

        private void btnStopIIS_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            RtfInfoHelper.AddSuccessInfo(this.rtbInfo, ProcessHelper.StopIIS());
        }

        private void btnStartIIS_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            RtfInfoHelper.AddSuccessInfo(this.rtbInfo, ProcessHelper.StartIIS());
        }

        private void btnCheckConfig_Click(object sender, EventArgs e)
        {
            this.rtbInfo.Clear();
            Application.DoEvents();
            SqlScriptConfigChecker checker = new SqlScriptConfigChecker(this.rtbInfo);
            checker.Check();
        }
    }
}
