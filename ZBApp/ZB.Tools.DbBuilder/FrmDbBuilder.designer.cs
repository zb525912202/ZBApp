namespace ZB.Tools.DbBuilder
{
    partial class FrmDbBuilder
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle();
            this.label1 = new System.Windows.Forms.Label();
            this.tbScriptDir = new System.Windows.Forms.TextBox();
            this.btnSelectScriptDir = new System.Windows.Forms.Button();
            this.tbServer = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.tbUID = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.tbPWD = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.tbDbs = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.tbDbPath = new System.Windows.Forms.TextBox();
            this.btnUpgrade = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.btnExport = new System.Windows.Forms.Button();
            this.rtbInfo = new System.Windows.Forms.RichTextBox();
            this.btnConnect = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.dgDbObjList = new System.Windows.Forms.DataGridView();
            this.DbNameColumn = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DbSize_mdf = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DbSize_ldf = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CreateDbColumns = new System.Windows.Forms.DataGridViewButtonColumn();
            this.CreateViewColumn = new System.Windows.Forms.DataGridViewButtonColumn();
            this.DbShrink = new System.Windows.Forms.DataGridViewButtonColumn();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel();
            this.panel2 = new System.Windows.Forms.Panel();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnStartIIS = new System.Windows.Forms.Button();
            this.btnStopIIS = new System.Windows.Forms.Button();
            this.btnStartSQLServer = new System.Windows.Forms.Button();
            this.btnStopSQLServer = new System.Windows.Forms.Button();
            this.dataGridViewButtonColumn1 = new System.Windows.Forms.DataGridViewButtonColumn();
            this.btnCheckConfig = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDbObjList)).BeginInit();
            this.tableLayoutPanel1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.tableLayoutPanel2.SuspendLayout();
            this.panel2.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(9, 6);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(53, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "脚本目录";
            // 
            // tbScriptDir
            // 
            this.tbScriptDir.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tbScriptDir.Location = new System.Drawing.Point(68, 3);
            this.tbScriptDir.Name = "tbScriptDir";
            this.tbScriptDir.ReadOnly = true;
            this.tbScriptDir.Size = new System.Drawing.Size(752, 21);
            this.tbScriptDir.TabIndex = 1;
            // 
            // btnSelectScriptDir
            // 
            this.btnSelectScriptDir.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSelectScriptDir.Location = new System.Drawing.Point(826, 1);
            this.btnSelectScriptDir.Name = "btnSelectScriptDir";
            this.btnSelectScriptDir.Size = new System.Drawing.Size(75, 23);
            this.btnSelectScriptDir.TabIndex = 2;
            this.btnSelectScriptDir.Text = "浏览";
            this.btnSelectScriptDir.UseVisualStyleBackColor = true;
            this.btnSelectScriptDir.Click += new System.EventHandler(this.btnSelectScriptDir_Click);
            // 
            // tbServer
            // 
            this.tbServer.Font = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbServer.ForeColor = System.Drawing.SystemColors.Highlight;
            this.tbServer.Location = new System.Drawing.Point(71, 20);
            this.tbServer.Name = "tbServer";
            this.tbServer.ReadOnly = true;
            this.tbServer.Size = new System.Drawing.Size(469, 23);
            this.tbServer.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(28, 25);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(41, 12);
            this.label2.TabIndex = 3;
            this.label2.Text = "Server";
            // 
            // tbUID
            // 
            this.tbUID.Font = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbUID.ForeColor = System.Drawing.SystemColors.Highlight;
            this.tbUID.Location = new System.Drawing.Point(71, 55);
            this.tbUID.Name = "tbUID";
            this.tbUID.ReadOnly = true;
            this.tbUID.Size = new System.Drawing.Size(469, 23);
            this.tbUID.TabIndex = 6;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(45, 59);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(23, 12);
            this.label3.TabIndex = 5;
            this.label3.Text = "UID";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(45, 94);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(23, 12);
            this.label4.TabIndex = 7;
            this.label4.Text = "PWD";
            // 
            // tbPWD
            // 
            this.tbPWD.Font = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbPWD.ForeColor = System.Drawing.SystemColors.Highlight;
            this.tbPWD.Location = new System.Drawing.Point(71, 89);
            this.tbPWD.Name = "tbPWD";
            this.tbPWD.ReadOnly = true;
            this.tbPWD.Size = new System.Drawing.Size(469, 23);
            this.tbPWD.TabIndex = 8;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(46, 130);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(23, 12);
            this.label5.TabIndex = 9;
            this.label5.Text = "Dbs";
            // 
            // tbDbs
            // 
            this.tbDbs.Font = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbDbs.ForeColor = System.Drawing.SystemColors.Highlight;
            this.tbDbs.Location = new System.Drawing.Point(71, 125);
            this.tbDbs.Name = "tbDbs";
            this.tbDbs.ReadOnly = true;
            this.tbDbs.Size = new System.Drawing.Size(469, 23);
            this.tbDbs.TabIndex = 10;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(27, 168);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(41, 12);
            this.label6.TabIndex = 11;
            this.label6.Text = "DbPath";
            // 
            // tbDbPath
            // 
            this.tbDbPath.Font = new System.Drawing.Font("宋体", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.tbDbPath.ForeColor = System.Drawing.SystemColors.Highlight;
            this.tbDbPath.Location = new System.Drawing.Point(71, 163);
            this.tbDbPath.Name = "tbDbPath";
            this.tbDbPath.ReadOnly = true;
            this.tbDbPath.Size = new System.Drawing.Size(469, 23);
            this.tbDbPath.TabIndex = 12;
            // 
            // btnUpgrade
            // 
            this.btnUpgrade.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnUpgrade.Enabled = false;
            this.btnUpgrade.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnUpgrade.Location = new System.Drawing.Point(462, 328);
            this.btnUpgrade.Name = "btnUpgrade";
            this.btnUpgrade.Size = new System.Drawing.Size(75, 23);
            this.btnUpgrade.TabIndex = 15;
            this.btnUpgrade.Text = "升级";
            this.btnUpgrade.UseVisualStyleBackColor = true;
            this.btnUpgrade.Click += new System.EventHandler(this.btnUpgrade_Click);
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
            | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox1.Controls.Add(this.btnExport);
            this.groupBox1.Controls.Add(this.rtbInfo);
            this.groupBox1.Location = new System.Drawing.Point(555, 93);
            this.groupBox1.Name = "groupBox1";
            this.tableLayoutPanel1.SetRowSpan(this.groupBox1, 2);
            this.groupBox1.Size = new System.Drawing.Size(358, 601);
            this.groupBox1.TabIndex = 16;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "消息";
            // 
            // btnExport
            // 
            this.btnExport.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnExport.Location = new System.Drawing.Point(274, 19);
            this.btnExport.Name = "btnExport";
            this.btnExport.Size = new System.Drawing.Size(75, 23);
            this.btnExport.TabIndex = 3;
            this.btnExport.Text = "导出";
            this.btnExport.UseVisualStyleBackColor = true;
            this.btnExport.Click += new System.EventHandler(this.btnExport_Click);
            // 
            // rtbInfo
            // 
            this.rtbInfo.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
            | System.Windows.Forms.AnchorStyles.Left)
            | System.Windows.Forms.AnchorStyles.Right)));
            this.rtbInfo.Location = new System.Drawing.Point(3, 59);
            this.rtbInfo.Name = "rtbInfo";
            this.rtbInfo.ReadOnly = true;
            this.rtbInfo.Size = new System.Drawing.Size(352, 501);
            this.rtbInfo.TabIndex = 0;
            this.rtbInfo.Text = "";
            this.rtbInfo.WordWrap = false;
            // 
            // btnConnect
            // 
            this.btnConnect.Font = new System.Drawing.Font("宋体", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(134)));
            this.btnConnect.Location = new System.Drawing.Point(465, 192);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(75, 23);
            this.btnConnect.TabIndex = 18;
            this.btnConnect.Text = "连接";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.tbServer);
            this.groupBox2.Controls.Add(this.btnConnect);
            this.groupBox2.Controls.Add(this.label2);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Controls.Add(this.tbDbPath);
            this.groupBox2.Controls.Add(this.tbPWD);
            this.groupBox2.Controls.Add(this.tbUID);
            this.groupBox2.Controls.Add(this.tbDbs);
            this.groupBox2.Controls.Add(this.label6);
            this.groupBox2.Controls.Add(this.label4);
            this.groupBox2.Location = new System.Drawing.Point(3, 93);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(546, 221);
            this.groupBox2.TabIndex = 19;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "数据库配置";
            // 
            // dgDbObjList
            // 
            this.dgDbObjList.AllowUserToAddRows = false;
            this.dgDbObjList.AllowUserToDeleteRows = false;
            this.dgDbObjList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgDbObjList.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.dgDbObjList.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.DbNameColumn,
            this.DbSize_mdf,
            this.DbSize_ldf,
            this.CreateDbColumns,
            this.CreateViewColumn,
            this.DbShrink});
            this.dgDbObjList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.dgDbObjList.Location = new System.Drawing.Point(3, 3);
            this.dgDbObjList.Name = "dgDbObjList";
            this.dgDbObjList.ReadOnly = true;
            this.dgDbObjList.RowTemplate.Height = 23;
            this.dgDbObjList.Size = new System.Drawing.Size(534, 319);
            this.dgDbObjList.TabIndex = 14;
            this.dgDbObjList.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgDbObjList_CellContentClick);
            // 
            // DbNameColumn
            // 
            this.DbNameColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.DbNameColumn.DataPropertyName = "DbName";
            this.DbNameColumn.Frozen = true;
            this.DbNameColumn.HeaderText = "数据库名称";
            this.DbNameColumn.Name = "DbNameColumn";
            this.DbNameColumn.ReadOnly = true;
            this.DbNameColumn.Width = 80;
            // 
            // DbSize_mdf
            // 
            this.DbSize_mdf.DataPropertyName = "DbSizeStr_mdf";
            this.DbSize_mdf.HeaderText = "mdf大小";
            this.DbSize_mdf.Name = "DbSize_mdf";
            this.DbSize_mdf.ReadOnly = true;
            // 
            // DbSize_ldf
            // 
            this.DbSize_ldf.DataPropertyName = "DbSizeStr_ldf";
            this.DbSize_ldf.HeaderText = "ldf大小";
            this.DbSize_ldf.Name = "DbSize_ldf";
            this.DbSize_ldf.ReadOnly = true;
            // 
            // CreateDbColumns
            // 
            this.CreateDbColumns.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            this.CreateDbColumns.HeaderText = "数据库";
            this.CreateDbColumns.Name = "CreateDbColumns";
            this.CreateDbColumns.ReadOnly = true;
            this.CreateDbColumns.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.CreateDbColumns.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.CreateDbColumns.Text = "创建数据库";
            this.CreateDbColumns.UseColumnTextForButtonValue = true;
            this.CreateDbColumns.Width = 90;
            // 
            // CreateViewColumn
            // 
            this.CreateViewColumn.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            dataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle3.SelectionBackColor = System.Drawing.Color.White;
            this.CreateViewColumn.DefaultCellStyle = dataGridViewCellStyle3;
            this.CreateViewColumn.HeaderText = "视图";
            this.CreateViewColumn.Name = "CreateViewColumn";
            this.CreateViewColumn.ReadOnly = true;
            this.CreateViewColumn.Text = "创建视图";
            this.CreateViewColumn.UseColumnTextForButtonValue = true;
            this.CreateViewColumn.Width = 90;
            // 
            // DbShrink
            // 
            this.DbShrink.HeaderText = "收缩";
            this.DbShrink.Name = "DbShrink";
            this.DbShrink.ReadOnly = true;
            this.DbShrink.Text = "收缩数据库";
            this.DbShrink.UseColumnTextForButtonValue = true;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 2;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Controls.Add(this.groupBox3, 0, 3);
            this.tableLayoutPanel1.Controls.Add(this.panel2, 0, 1);
            this.tableLayoutPanel1.Controls.Add(this.groupBox2, 0, 2);
            this.tableLayoutPanel1.Controls.Add(this.groupBox1, 1, 2);
            this.tableLayoutPanel1.Controls.Add(this.panel1, 0, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 4;
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(916, 697);
            this.tableLayoutPanel1.TabIndex = 23;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.tableLayoutPanel2);
            this.groupBox3.Dock = System.Windows.Forms.DockStyle.Fill;
            this.groupBox3.Location = new System.Drawing.Point(3, 320);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(546, 374);
            this.groupBox3.TabIndex = 24;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "数据库";
            // 
            // tableLayoutPanel2
            // 
            this.tableLayoutPanel2.ColumnCount = 1;
            this.tableLayoutPanel2.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.Controls.Add(this.dgDbObjList, 0, 0);
            this.tableLayoutPanel2.Controls.Add(this.btnUpgrade, 0, 1);
            this.tableLayoutPanel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel2.Location = new System.Drawing.Point(3, 17);
            this.tableLayoutPanel2.Name = "tableLayoutPanel2";
            this.tableLayoutPanel2.RowCount = 2;
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel2.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel2.Size = new System.Drawing.Size(540, 354);
            this.tableLayoutPanel2.TabIndex = 16;
            // 
            // panel2
            // 
            this.tableLayoutPanel1.SetColumnSpan(this.panel2, 2);
            this.panel2.Controls.Add(this.tbScriptDir);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Controls.Add(this.btnSelectScriptDir);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel2.Location = new System.Drawing.Point(3, 57);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(910, 30);
            this.panel2.TabIndex = 24;
            // 
            // panel1
            // 
            this.tableLayoutPanel1.SetColumnSpan(this.panel1, 2);
            this.panel1.Controls.Add(this.btnCheckConfig);
            this.panel1.Controls.Add(this.btnStartIIS);
            this.panel1.Controls.Add(this.btnStopIIS);
            this.panel1.Controls.Add(this.btnStartSQLServer);
            this.panel1.Controls.Add(this.btnStopSQLServer);
            this.panel1.Location = new System.Drawing.Point(3, 3);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(910, 48);
            this.panel1.TabIndex = 25;
            // 
            // btnStartIIS
            // 
            this.btnStartIIS.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStartIIS.Location = new System.Drawing.Point(555, 9);
            this.btnStartIIS.Name = "btnStartIIS";
            this.btnStartIIS.Size = new System.Drawing.Size(98, 23);
            this.btnStartIIS.TabIndex = 6;
            this.btnStartIIS.Text = "启动IIS";
            this.btnStartIIS.UseVisualStyleBackColor = true;
            this.btnStartIIS.Click += new System.EventHandler(this.btnStartIIS_Click);
            // 
            // btnStopIIS
            // 
            this.btnStopIIS.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStopIIS.Location = new System.Drawing.Point(437, 9);
            this.btnStopIIS.Name = "btnStopIIS";
            this.btnStopIIS.Size = new System.Drawing.Size(98, 23);
            this.btnStopIIS.TabIndex = 5;
            this.btnStopIIS.Text = "停止IIS";
            this.btnStopIIS.UseVisualStyleBackColor = true;
            this.btnStopIIS.Click += new System.EventHandler(this.btnStopIIS_Click);
            // 
            // btnStartSQLServer
            // 
            this.btnStartSQLServer.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStartSQLServer.Location = new System.Drawing.Point(281, 9);
            this.btnStartSQLServer.Name = "btnStartSQLServer";
            this.btnStartSQLServer.Size = new System.Drawing.Size(98, 23);
            this.btnStartSQLServer.TabIndex = 4;
            this.btnStartSQLServer.Text = "启动SQL服务";
            this.btnStartSQLServer.UseVisualStyleBackColor = true;
            this.btnStartSQLServer.Click += new System.EventHandler(this.btnStartSQLServer_Click);
            // 
            // btnStopSQLServer
            // 
            this.btnStopSQLServer.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStopSQLServer.Location = new System.Drawing.Point(168, 9);
            this.btnStopSQLServer.Name = "btnStopSQLServer";
            this.btnStopSQLServer.Size = new System.Drawing.Size(98, 23);
            this.btnStopSQLServer.TabIndex = 3;
            this.btnStopSQLServer.Text = "停止SQL服务";
            this.btnStopSQLServer.UseVisualStyleBackColor = true;
            this.btnStopSQLServer.Click += new System.EventHandler(this.btnStopSQLServer_Click);
            // 
            // dataGridViewButtonColumn1
            // 
            this.dataGridViewButtonColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            dataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle4.SelectionBackColor = System.Drawing.Color.White;
            this.dataGridViewButtonColumn1.DefaultCellStyle = dataGridViewCellStyle4;
            this.dataGridViewButtonColumn1.HeaderText = "创建视图";
            this.dataGridViewButtonColumn1.Name = "dataGridViewButtonColumn1";
            this.dataGridViewButtonColumn1.Text = "创建视图";
            this.dataGridViewButtonColumn1.UseColumnTextForButtonValue = true;
            this.dataGridViewButtonColumn1.Width = 141;
            // 
            // btnCheckConfig
            // 
            this.btnCheckConfig.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCheckConfig.Location = new System.Drawing.Point(11, 9);
            this.btnCheckConfig.Name = "btnCheckConfig";
            this.btnCheckConfig.Size = new System.Drawing.Size(98, 23);
            this.btnCheckConfig.TabIndex = 7;
            this.btnCheckConfig.Text = "检查系统配置";
            this.btnCheckConfig.UseVisualStyleBackColor = true;
            this.btnCheckConfig.Click += new System.EventHandler(this.btnCheckConfig_Click);
            // 
            // FrmDbBuilder
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(916, 697);
            this.Controls.Add(this.tableLayoutPanel1);
            this.Name = "FrmDbBuilder";
            this.Text = "佳腾数据库部署工具";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.groupBox1.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgDbObjList)).EndInit();
            this.tableLayoutPanel1.ResumeLayout(false);
            this.groupBox3.ResumeLayout(false);
            this.tableLayoutPanel2.ResumeLayout(false);
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox tbScriptDir;
        private System.Windows.Forms.Button btnSelectScriptDir;
        private System.Windows.Forms.TextBox tbServer;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox tbUID;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox tbPWD;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox tbDbs;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox tbDbPath;
        private System.Windows.Forms.Button btnUpgrade;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button btnConnect;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel1;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel2;
        private System.Windows.Forms.Button btnExport;
        public System.Windows.Forms.RichTextBox rtbInfo;
        public System.Windows.Forms.DataGridView dgDbObjList;

        private System.Windows.Forms.DataGridViewButtonColumn dataGridViewButtonColumn1;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Button btnStartIIS;
        private System.Windows.Forms.Button btnStopIIS;
        private System.Windows.Forms.Button btnStartSQLServer;
        private System.Windows.Forms.Button btnStopSQLServer;
        private System.Windows.Forms.DataGridViewTextBoxColumn DbNameColumn;
        private System.Windows.Forms.DataGridViewTextBoxColumn DbSize_mdf;
        private System.Windows.Forms.DataGridViewTextBoxColumn DbSize_ldf;
        private System.Windows.Forms.DataGridViewButtonColumn CreateDbColumns;
        private System.Windows.Forms.DataGridViewButtonColumn CreateViewColumn;
        private System.Windows.Forms.DataGridViewButtonColumn DbShrink;
        private System.Windows.Forms.Button btnCheckConfig;
    }
}