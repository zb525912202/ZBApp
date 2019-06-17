using System;
using System.Collections.Generic;

namespace ZB.Framework.Business
{
    /// <summary>
    /// 阅题基类
    /// </summary>
    public abstract class QuestionGraderBase
    {
        protected const char GroupSplitChar = '|';
        protected const char AnswerSplitChar = ',';

        //每个答案字符所对应的字符组
        protected Dictionary<char, List<char>> AnswerCharGroupDic = new Dictionary<char, List<char>>();
        //答案组集合
        private List<List<char>> _AnswerCharGroupList = new List<List<char>>();
        public List<List<char>> AnswerCharGroupList
        {
            get { return _AnswerCharGroupList; }
        }

        public QuestionGraderBase()
        {
            string answerTextGroup = this.GetAnswerTextGroup();
            string[] answerGroups = answerTextGroup.Split(QuestionGraderBase.GroupSplitChar);

            int answerTextLength = 0;
            for (int i = 0; i < answerGroups.Length; i++)
            {
                string[] answerTexts = answerGroups[i].Split(QuestionGraderBase.AnswerSplitChar);

                if (answerTextLength == 0)
                {
                    answerTextLength = answerTexts.Length;
                }
                else
                {
                    if (answerTextLength != answerTexts.Length)
                        throw new ArgumentException("答案项的长度必须一致");
                }

                List<char> answerTextList = new List<char>();

                for (int j = 0; j < answerTexts.Length; j++)
                {
                    if (answerTexts[j].Length != 1) throw new ArgumentException(string.Format("错误的答案项[{0}]", answerTexts[j]));

                    char answerChar = answerTexts[j][0];

                    if (this.AnswerCharGroupList.Count < j + 1)
                        this.AnswerCharGroupList.Add(new List<char>());

                    this.AnswerCharGroupList[j].Add(answerChar);

                    answerTextList.Add(answerChar);
                    this.AnswerCharGroupDic.Add(answerChar, answerTextList);
                }
            }
        }

        /// <summary>
        /// 获得答案的内容组
        /// </summary>        
        protected abstract string GetAnswerTextGroup();

        /// <summary>
        /// 根据答案获得标准答案(选择题答案为"个A好"的标准答案为"A")
        /// </summary>
        public abstract string GetStdAnswerText(string answerText);

        /// <summary>
        /// 检查答案是否标准答案
        /// </summary>
        public virtual bool CheckAnswer(string answerText)
        {
            if (!string.IsNullOrEmpty(answerText))
            {
                foreach (char answerChar in answerText)
                {
                    if (this.AnswerCharGroupDic.ContainsKey(answerChar))
                        return true;
                }
            }
            return false;
        }

        private bool GradeText(string text1, string text2)
        {
            foreach (var char1 in text1)
            {
                if (this.AnswerCharGroupDic.ContainsKey(char1))
                {
                    List<char> answerCharGroup = this.AnswerCharGroupDic[char1];
                    bool isContains = false;
                    foreach (var char2 in text2)
                    {
                        if (answerCharGroup.Contains(char2))//两个字符在同组就认为是正确
                        {
                            isContains = true;
                            break;
                        }
                    }
                    if (!isContains)
                        return false;
                }
            }

            return true;
        }

        /// <summary>
        /// 阅题,判断对错
        /// </summary>
        public virtual bool Grade(string rightAnswerText, string userAnswerText)
        {
            if (string.IsNullOrEmpty(rightAnswerText) || string.IsNullOrEmpty(userAnswerText))
                return false;

            return this.GradeText(rightAnswerText, userAnswerText) && this.GradeText(userAnswerText, rightAnswerText);
        }

        /// <summary>
        /// 获得标准答案组
        /// </summary>
        public List<char> GetAllStdAnswerTextGroup(string contentText, string answerText)
        {
            //*******************选择用哪一组答案*****************{
            List<char> answerTextList = null;
            foreach (var answerCharGroupTemp in this.AnswerCharGroupList)
            {
                foreach (var answerChar in answerCharGroupTemp)
                {
                    if (contentText.Contains(answerChar.ToString()) || answerText.Contains(answerChar.ToString()))
                    {
                        answerTextList = new List<char>(answerCharGroupTemp);//复制内容
                        break;
                    }
                }
                if (answerTextList != null)
                    break;
            }

            if (answerTextList == null)
                answerTextList = new List<char>(this.AnswerCharGroupList[0]);
            //*******************选择用哪一组答案*****************}

            #region Old.

            ////*******************计算答案数量*****************{
            //int maxCharCount = 2; //至少保留两个
            //bool isHaveAnswerChar = false;//是否包含一个答案组中的字符
            //foreach (var answerCharGroupTemp in this.AnswerCharGroupList)
            //{
            //    //至少保留两个，所以循环i > 1
            //    for (int i = answerCharGroupTemp.Count - 1; i > maxCharCount - 1; i--)
            //    {
            //        string answerStr = answerCharGroupTemp[i].ToString();
            //        if (contentText.Contains(answerStr) || answerText.Contains(answerStr))
            //        {
            //            isHaveAnswerChar = true;
            //            maxCharCount = i + 1;
            //            break;
            //        }
            //    }
            //}

            //if (isHaveAnswerChar)//一个都没有则返回默认答案组中所有的答案项
            //{
            //    for (int i = answerTextList.Count - 1; i > maxCharCount - 1; i--)
            //    {
            //        answerTextList.RemoveAt(i);
            //    }
            //}
            ////*******************计算答案数量*****************}

            //return answerTextList;

            #endregion

            //*******************计算答案数量*****************
            List<char> charList = new List<char>();
            foreach (var answerCharGroupTemp in AnswerCharGroupList)
            {
                foreach (var answerStr in answerCharGroupTemp)
                {
                    //这里不考虑答案在试题内容里面不存在的情况，如果不存在，则不显示该答案
                    if (contentText.Contains(answerStr.ToString()))
                    {
                        charList.Add(answerStr);
                    }
                }
            }

            List<char> resultAnswerTextList = new List<char>();

            int length = answerTextList.Count;
            for (int i = 0; i < length; i++)
            {
                var answerStr = answerTextList[i];
                var lastAnswerStr = answerTextList[i + 1 < length ? i + 1 : i];

                resultAnswerTextList.Add(answerStr);

                bool exTag = false;

                if (this.AnswerCharGroupDic.ContainsKey(lastAnswerStr))
                {
                    foreach (var aChar in charList)
                    {
                        exTag = this.AnswerCharGroupDic[lastAnswerStr].Contains(aChar);
                        if (exTag)
                        {
                            break;
                        }
                    }
                }

                if (exTag == false)
                {
                    if (resultAnswerTextList.Count == 1)
                    {
                        resultAnswerTextList.Add(lastAnswerStr);
                    }
                    break;
                }
            }

            return resultAnswerTextList;
        }


        ///// <summary>
        ///// 获得标准答案组
        ///// </summary>
        //public List<char> GetAllStdAnswerTextGroup(string contentText, string answerText)
        //{
        //    int maxContainsCount = 0;//最大包含内容字符的答案组所包含的字符
        //    int maxAnswerCharIndex = 1;//最大匹配答案字符索引,最少2个
        //    List<char> answerCharGroup = null;
        //    foreach (var answerCharGroupTemp in this.AnswerCharGroupList)
        //    {
        //        int containsCount = 0;
        //        for (int i = answerCharGroupTemp.Count - 1; i > -1; i--)
        //        {
        //            char answerChar = answerCharGroupTemp[i];
        //            if (contentText.Contains(answerChar.ToString()))
        //            {
        //                containsCount++;
        //                if (i > maxAnswerCharIndex)
        //                {
        //                    maxAnswerCharIndex = i;
        //                }
        //            }
        //        }

        //        if (containsCount > maxContainsCount)
        //        {
        //            maxContainsCount = containsCount;
        //            answerCharGroup = answerCharGroupTemp;
        //        }
        //    }

        //    if (answerCharGroup == null)
        //    {
        //        answerCharGroup = this.AnswerCharGroupList[0];
        //        List<char> answerCharGroupTemp = new List<char>();
        //        for (int i = 0; i < answerCharGroup.Count; i++)
        //        {
        //            answerCharGroupTemp.Add(answerCharGroup[i]);
        //        }
        //        return answerCharGroupTemp;
        //    }
        //    else
        //    {
        //        List<char> answerCharGroupTemp = new List<char>();
        //        for (int i = 0; i <= maxAnswerCharIndex; i++)
        //        {
        //            answerCharGroupTemp.Add(answerCharGroup[i]);
        //        }
        //        return answerCharGroupTemp;
        //    }
        //}

        /// <summary>
        /// 根据答案获得对应的标准答案组
        /// </summary>
        public List<char> GetStdAnswerTextGroup(string answerText)
        {
            List<char> stdCharList = new List<char>();
            foreach (char answerChar in answerText)
            {
                if (this.AnswerCharGroupDic.ContainsKey(answerChar))
                {
                    List<char> charList = this.AnswerCharGroupDic[answerChar];

                    if (charList.Count == 0)
                        throw new ArgumentException(string.Format("题型缺少标准答案组!"));

                    if (!stdCharList.Contains(charList[0]))
                        stdCharList.Add(charList[0]);
                }
            }

            return stdCharList;
        }
    }
}
