using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace ZB.Tools.DbBuilder
{
    public static class RtfInfoHelper
    {
        private static void AddInfo(RichTextBox rtbInfo, string info, Color color)
        {
            rtbInfo.SelectionColor = color;

            string newInfo = "";
            if (!string.IsNullOrEmpty(rtbInfo.Text))
            {
                newInfo = "\r\n" + (rtbInfo.Lines.Length + 1).ToString() + "、" + info;
            }
            else
            {
                newInfo = (rtbInfo.Lines.Length + 1).ToString() + "、" + info;
            }

            rtbInfo.AppendText(newInfo);

            rtbInfo.SelectionStart = rtbInfo.Text.Length;
            rtbInfo.ScrollToCaret();

            Application.DoEvents();
        }

        public static void AddSuccessInfo(RichTextBox rtbInfo, string info)
        {
            AddInfo(rtbInfo, info, Color.Blue);
        }

        public static void AddErrorInfo(RichTextBox rtbInfo, string info)
        {
            AddInfo(rtbInfo, info, Color.Red);
        }

        public static void AddWarning(RichTextBox rtbInfo, string info)
        {
            AddInfo(rtbInfo, info, Color.Green);
        }
    }
}
