using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public enum EnumSqlConditionType
    {
        EqualTo,
        EqualToProp,
        GreaterThan,
        GreaterThanProp,
        GreaterThanAndEqualTo,
        GreaterThanAndEqualToProp,
        NotEqualTo,
        NotEqualToProp,
        LessThan,
        LessThanProp,
        LessThanAndEqualTo,
        LessThanAndEqualToProp,
        Match,
        MatchPrefix,
        In,
        NotMatch,
        NotMatchPrefix,
        NotIn,
        MatchSuffix,
        NotMatchSuffix,
        MatchFullText,
        Custom
    }
}
