using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace ZB.Tools.DbBuilder
{
    public partial class FrmCreateDb : Form
    {
        public RebuildDbGroup SelectRebuildDbGroup { get; private set; }

        public FrmCreateDb(ZBDbScript script)
        {
            InitializeComponent();

            this.Load += (s, e) =>
            {
                this.tbPanel.RowCount = script.DbConfig.RebuildDbGroupList.Count;

                for (int i = 0; i < tbPanel.RowStyles.Count; i++)
                {
                    tbPanel.RowStyles[i].SizeType = SizeType.Percent;
                    tbPanel.RowStyles[i].Height = 100;
                    
                    Panel panel = new Panel();
                    panel.Dock = DockStyle.Fill;

                    this.tbPanel.Controls.Add(panel);
                    this.tbPanel.SetRow(panel, i);

                    var rebuildDb = script.DbConfig.RebuildDbGroupList[i];
                    Button btn = new Button();
                    btn.Text = rebuildDb.Description;
                    btn.Width = 200;
                    btn.Height = 40;
                    btn.Click += (s1, e1) =>
                    {
                        this.SelectRebuildDbGroup = rebuildDb;
                        this.DialogResult = DialogResult.OK;
                        this.Close();
                    };

                    btn.Location = new Point((this.tbPanel.Width - btn.Width) / 2, (this.tbPanel.Height / tbPanel.RowCount - btn.Height) / 2);
                    panel.Controls.Add(btn);
                }


                //int btnWidth = 150;
                //for (int i = 0; i < script.DbConfig.RebuildDbGroupList.Count; i++)
                //{
                //    var rebuildDb = script.DbConfig.RebuildDbGroupList[i];
                //    Button btn = new Button();
                //    btn.Text = rebuildDb.Description;
                //    btn.Width = btnWidth;
                //    int x = (this.Width - btn.Width) / 2;
                //    int y = (this.Height / script.DbConfig.RebuildDbGroupList.Count + 1) * (i + 1);
                //    btn.Location = new System.Drawing.Point(x, y);
                //    btn.Click += (s1, e1) =>
                //    {
                //        this.SelectRebuildDbGroup = rebuildDb;
                //        this.DialogResult = DialogResult.OK;
                //        this.Close();
                //    };
                //    this.Controls.Add(btn);
                //}

            };
        }
    }
}
