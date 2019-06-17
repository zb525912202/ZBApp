using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ZB.AppShell.Addin;

namespace ZB.Framework.Business
{
    public abstract class XuanZeTiGraderBase : QuestionGraderBase
    {
        protected override string GetAnswerTextGroup()
        {
            return AppSettingService.Instance.GetData<string>("XuanZeAnswerTextGroup");
        }      
    }
}
