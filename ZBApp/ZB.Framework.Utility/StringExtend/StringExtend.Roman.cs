using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ZB.Framework.Utility
{
    //罗马数字与int类型互相转换
    public static partial class StringExtend
    {
        static readonly Dictionary<char, int> dict = new Dictionary<char, int>
        {
            {'I', 1},
            {'V', 5},
            {'X', 10},
            {'L', 50},
            {'C', 100},
            {'D', 500},
            {'M', 1000}
        };

        public static int RomanToInt(this string s)
        {
            int sum = 0;
            for (int i = 0; i < s.Length; i++)
            {
                int currentValue = dict[s[i]];
                if (i == s.Length - 1 || dict[s[i + 1]] <= currentValue)
                    sum += currentValue;
                else
                    sum -= currentValue;
            }
            return sum;
        }

        public static string IntToRoman(this int num, string zeroMappingStr = "空层")
        {
            if (num == 0)
            {
                return zeroMappingStr;
            }
            string res = String.Empty;
            List<int> val = new List<int> { 1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1 };
            List<string> str = new List<string> { "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I" };
            for (int i = 0; i < val.Count; ++i)
            {
                while (num >= val[i])
                {
                    num -= val[i];
                    res += str[i];
                }
            }
            return res;
        }
    }
}
