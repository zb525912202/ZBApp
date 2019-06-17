using ZB.AppShell.Addin;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 判断题阅题器
    /// </summary>
    public class PanDuanGrader : QuestionGraderBase
    {
        #region SingleTon
        private static readonly PanDuanGrader instance = new PanDuanGrader();
        public static PanDuanGrader Instance { get { return instance; } }
        private PanDuanGrader() { }
        #endregion

        protected override string GetAnswerTextGroup()
        {
            return AppSettingService.Instance.GetData<string>("PanDuanAnswerTextGroup");
        }

        public override string GetStdAnswerText(string answerText)
        {
            string stdAnswerText = string.Empty;
            foreach (char answerChar in answerText)
            {
                if (this.AnswerCharGroupDic.ContainsKey(answerChar))
                {
                    if (stdAnswerText != string.Empty)//只允许一个答案
                        return string.Empty;
                    else
                        stdAnswerText = answerChar.ToString();
                }
            }

            return stdAnswerText;
        }
    }
}
