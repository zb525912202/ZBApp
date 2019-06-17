
namespace ZB.Framework.Business
{
    /// <summary>
    /// 单选题阅题器
    /// </summary>
    public class DanXuanGrader : XuanZeTiGraderBase
    {
        #region SingleTon
        private static readonly DanXuanGrader instance = new DanXuanGrader();
        public static DanXuanGrader Instance { get { return instance; } }
        private DanXuanGrader() { }
        #endregion       

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
