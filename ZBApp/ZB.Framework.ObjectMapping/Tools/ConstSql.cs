using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.ObjectMapping
{
    public static class ConstSql
    {
        public const string Table = "[TABLE]";

        public const string Condition = "[CONDITION]";

        public const string Order = "[ORDER]";

        public const string SelectTop = "[TOPCOUNT]";

        public const string Columns = "[COLUMNS]";

        public const string MinRownum = "[MINROWNUM]";

        public const string MaxRownum = "[MAXROWNUM]";

        /// <summary>
        /// 列占位符定义前缀
        /// </summary>
        public const char Column_Define_Prefix = '$';

        /// <summary>
        /// 参数定义前缀
        /// </summary>
        public const char Argument_Define_Prefix = '$';
    }
}
