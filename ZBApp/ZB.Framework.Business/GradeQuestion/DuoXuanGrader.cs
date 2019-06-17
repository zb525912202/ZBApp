
namespace ZB.Framework.Business
{
    public class DuoXuanGrader : XuanZeTiGraderBase
    {
        #region SingleTon
        private static readonly DuoXuanGrader instance = new DuoXuanGrader();
        public static DuoXuanGrader Instance { get { return instance; } }
        private DuoXuanGrader() { }
        #endregion

        public override string GetStdAnswerText(string answerText)
        {
            string stdAnswerText = string.Empty;
            foreach (char answerChar in answerText)
            {
                if (this.AnswerCharGroupDic.ContainsKey(answerChar))
                {
                    stdAnswerText += answerChar.ToString();
                }
            }

            return stdAnswerText;
        }
    }
}
