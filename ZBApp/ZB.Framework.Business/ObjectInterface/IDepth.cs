using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Business
{
    public interface IDepth
    {
        int Depth { get; set; }
    }

    public interface IDepthCheck : IDepth, ICheck
    {

    }

    public interface IExamState
    {
        int ExamStateStr { get; set; }
    }

    public interface IExamStateCheck : IExamState, ICheck
    {

    }
}
