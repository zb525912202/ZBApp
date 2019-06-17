using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace ZB.Framework.Utility
{
    public class DateTimeParseHelper
    {
        private DateTimeParseHelper() { }

        /// <summary>
        /// 通过字符串解析出时间，默认支持以'、 ',' ';' 分割多个时间段
        /// 返回结果的Count为0时，则意味着传入的字符串未能解析出任何时间
        /// </summary>
        /// <param name="datetimeString"></param>
        /// <param name="year"></param>
        /// <returns></returns>
        public static List<Tuple<DateTime, DateTime>> Parser(string datetimeString, int year, string splitCharString = "、,，;；")
        {
            string[] timeStringList = datetimeString.Split(splitCharString.ToCharArray());
            
            List<Tuple<DateTime, DateTime>> resultList = new List<Tuple<DateTime, DateTime>>();

            foreach (var timeString in timeStringList)
            {
                Tuple<DateTime, DateTime> resultItem = null;

                resultItem = new DateRangeParser().Parser(timeString, year);
                if (resultItem == null)
                {
                    resultItem = new MonthParser().Parser(timeString, year);
                    if (resultItem == null)
                    {
                        resultItem = new QuarterParser().Parser(timeString, year);
                        if (resultItem == null)
                        {
                            resultItem = new YearParser().Parser(timeString, year);
                        }
                    }
                }

                if (resultItem != null)
                {
                    resultList.Add(resultItem);
                }
            }

            return resultList;
        }
    }

    public abstract class DateTimeParserBase
    {
        public abstract Tuple<DateTime, DateTime> Parser(string datetimeString, int year);

        protected virtual string GetNumberAppendSuffixString(string datetimeString, string suffix)
        {
            string regexString = @"[一二三四五六七八九十]+|^(0?[1-9]|1[0-2])$";

            Regex regex = new Regex(regexString);

            Match match = regex.Match(datetimeString);

            if (match.Success)
            {
                return datetimeString + suffix;
            }

            return datetimeString;
        }

        private readonly string SpecialChar = " .-/";
        protected string RemoveSpecialChar(string str)
        {
            foreach (var regexChar in SpecialChar)
            {
                str = str.Replace(regexChar.ToString(), "");
            }
            return str;
        }
    }

    /// <summary>
    /// 年度解析器，负责如：xxxx年、上半年、下半年、年初、年中、年末、xxxx上半年、xxxx下半年、xxxx年初、xxxx年中、xxxx年末
    /// </summary>
    public class YearParser : DateTimeParserBase
    {
        private Dictionary<string, string> dateRangeDicts = new Dictionary<string, string>();

        public YearParser()
        {
            dateRangeDicts.Add("全年", "01-01|12-31");
            dateRangeDicts.Add("年全年", "01-01|12-31");

            dateRangeDicts.Add("上半年", "01-01|6-30");
            dateRangeDicts.Add("年上半年", "01-01|6-30");

            dateRangeDicts.Add("下半年", "07-01|12-31");
            dateRangeDicts.Add("年下半年", "07-01|12-31");

            dateRangeDicts.Add("初", "01-01|4-30");
            dateRangeDicts.Add("年初", "01-01|4-30");

            dateRangeDicts.Add("中", "05-01|8-31");
            dateRangeDicts.Add("年中", "05-01|8-31");

            dateRangeDicts.Add("末", "09-01|12-31");
            dateRangeDicts.Add("年末", "09-01|12-31");
        }

        public override Tuple<DateTime, DateTime> Parser(string datetimeString, int year)
        {
            datetimeString = RemoveSpecialChar(datetimeString);

            string timeRegexStr = dateRangeDicts.Keys.ToList().ListToStringAppendComma("|");

            string regexString = string.Format("(?<Year>^\\d{{4}}|\\s*)(?<Split>\\s*[年]\\s*|\\s*\\s*)(?<Time>{0}|\\s*)", timeRegexStr);

            Regex regex = new Regex(regexString);

            Match match = regex.Match(datetimeString);

            if (match.Success)
            {
                string yearStr = match.Groups["Year"].Value;
                string splitStr = match.Groups["Split"].Value;
                string timeStr = match.Groups["Time"].Value;

                yearStr = year.ToString();

                if (string.IsNullOrWhiteSpace(yearStr))
                {
                    yearStr = DateTime.Now.Year.ToString();
                }
                if (string.IsNullOrWhiteSpace(timeStr) && splitStr == "年" && datetimeString.Length == 5)
                {
                    timeStr = "全年";
                }

                if (dateRangeDicts.ContainsKey(timeStr))
                {
                    DateTime startDate;
                    DateTime endDate;

                    string[] tempStr = dateRangeDicts[timeStr].Split('|');

                    if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[0]), out startDate))
                    {
                        if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[1]), out endDate))
                        {
                            return new Tuple<DateTime, DateTime>(startDate, endDate);
                        }
                    }
                }
            }

            return null;
        }
    }


    /// <summary>
    /// 季度解析器，负责如:x季度、xxxx.x季度、xxxx-x季度
    /// </summary>
    public class QuarterParser : DateTimeParserBase
    {
        private Dictionary<string, string> dateRangeDicts = new Dictionary<string, string>();

        public QuarterParser()
        {
            dateRangeDicts.Add("1季度", "01-01|3-31");
            dateRangeDicts.Add("01季度", "01-01|3-31");
            dateRangeDicts.Add("一季度", "01-01|3-31");
            dateRangeDicts.Add("第一季度", "01-01|3-31");
            dateRangeDicts.Add("第1季度", "01-01|3-31");

            dateRangeDicts.Add("2季度", "04-01|6-30");
            dateRangeDicts.Add("02季度", "04-01|6-30");
            dateRangeDicts.Add("二季度", "04-01|6-30");
            dateRangeDicts.Add("第二季度", "04-01|6-30");
            dateRangeDicts.Add("第2季度", "04-01|6-30");

            dateRangeDicts.Add("3季度", "07-01|9-30");
            dateRangeDicts.Add("03季度", "07-01|9-30");
            dateRangeDicts.Add("三季度", "07-01|9-30");
            dateRangeDicts.Add("第三季度", "07-01|9-30");
            dateRangeDicts.Add("第3季度", "07-01|9-30");

            dateRangeDicts.Add("4季度", "10-01|12-31");
            dateRangeDicts.Add("04季度", "10-01|12-31");
            dateRangeDicts.Add("四季度", "10-01|12-31");
            dateRangeDicts.Add("第四季度", "10-01|12-31");
            dateRangeDicts.Add("第4季度", "10-01|12-31");
        }

        public override Tuple<DateTime, DateTime> Parser(string datetimeString, int year)
        {
            datetimeString = RemoveSpecialChar(datetimeString);

            datetimeString = GetNumberAppendSuffixString(datetimeString, "季度");

            string timeRegexStr = dateRangeDicts.Keys.ToList().ListToStringAppendComma("|");

            string regexString = string.Format("(?<Year>^\\d{{4}}|\\s*)(?<Split>\\s*[年]\\s*|\\s*\\s*)(?<Time>{0}|\\s*)", timeRegexStr);

            Regex regex = new Regex(regexString);

            Match match = regex.Match(datetimeString);

            if (match.Success)
            {
                string yearStr = match.Groups["Year"].Value;
                string splitStr = match.Groups["Split"].Value;
                string timeStr = match.Groups["Time"].Value;


                yearStr = year.ToString();

                if (string.IsNullOrWhiteSpace(yearStr))
                {
                    yearStr = DateTime.Now.Year.ToString();
                }

                if (dateRangeDicts.ContainsKey(timeStr))
                {
                    DateTime startDate;
                    DateTime endDate;

                    string[] tempStr = dateRangeDicts[timeStr].Split('|');

                    if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[0]), out startDate))
                    {
                        if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[1]), out endDate))
                        {
                            return new Tuple<DateTime, DateTime>(startDate, endDate);
                        }
                    }
                }
            }

            return null;
        }
    }

    /// <summary>
    /// 月度解析器，负责如：x月、xxxx.x月、xxxx-x月、x月上旬、x月下旬、x月中旬、x月初、x月中、x月末
    /// </summary>
    public class MonthParser : DateTimeParserBase
    {
        private Dictionary<string, int> dateRangeDicts = new Dictionary<string, int>();

        private List<string> timeList = new List<string>() { "月上旬", "月中旬", "月下旬", "月初", "月中", "月末", "月底", "月" };

        public MonthParser()
        {
            Dictionary<int, string> chineseMonthDicts = new Dictionary<int, string>();
            chineseMonthDicts.Add(1, "一");
            chineseMonthDicts.Add(2, "二");
            chineseMonthDicts.Add(3, "三");
            chineseMonthDicts.Add(4, "四");
            chineseMonthDicts.Add(5, "五");
            chineseMonthDicts.Add(6, "六");
            chineseMonthDicts.Add(7, "七");
            chineseMonthDicts.Add(8, "八");
            chineseMonthDicts.Add(9, "九");
            chineseMonthDicts.Add(10, "十");
            chineseMonthDicts.Add(11, "十一");
            chineseMonthDicts.Add(12, "十二");

            foreach (int month in chineseMonthDicts.Keys)
            {
                foreach (var time in timeList)
                {
                    dateRangeDicts.Add(string.Format("{0}{1}", month, time), month);
                    if (month < 10)
                    {
                        dateRangeDicts.Add(string.Format("0{0}{1}", month, time), month);
                    }
                    dateRangeDicts.Add(string.Format("{0}{1}", chineseMonthDicts[month], time), month);
                }
            }
        }

        private string GetTimeRangeString(int month, string time, int year)
        {
            int lastDay = new DateTime(year, month, 1).AddMonths(1).AddDays(-1).Day;
            if (time == "月")
            {
                return string.Format("{0}-01|{0}-{1}", month, lastDay);
            }
            else if (time == "月上旬" || time == "月初")
            {
                return string.Format("{0}-01|{0}-10", month);
            }
            else if (time == "月中旬" || time == "月中")
            {
                return string.Format("{0}-11|{0}-20", month);
            }
            else if (time == "月下旬" || time == "月末" || time == "月底")
            {
                return string.Format("{0}-21|{0}-{1}", month, lastDay);
            }

            return "";
        }


        public override Tuple<DateTime, DateTime> Parser(string datetimeString, int year)
        {
            datetimeString = RemoveSpecialChar(datetimeString);

            datetimeString = GetNumberAppendSuffixString(datetimeString, "月");

            string timeRegexStr = timeList.ListToStringAppendComma("|");

            string regexString = string.Format("(?<Year>^\\d{{4}}|\\s*)(?<Split>\\s*[年]\\s*|\\s*\\s*)(?<Month>[一二三四五六七八九十]+|\\d{{1,2}})(?<Time>{0}|\\s*)", timeRegexStr);

            Regex regex = new Regex(regexString);

            Match match = regex.Match(datetimeString);

            if (match.Success)
            {
                string yearStr = match.Groups["Year"].Value;
                string splitStr = match.Groups["Split"].Value;
                string monthStr = match.Groups["Month"].Value;
                string timeStr = match.Groups["Time"].Value;

                yearStr = year.ToString();

                if (string.IsNullOrWhiteSpace(yearStr))
                {
                    yearStr = DateTime.Now.Year.ToString();
                }

                if (timeList.Contains(timeStr))
                {
                    if (dateRangeDicts.ContainsKey(monthStr + timeStr))
                    {
                        int month = dateRangeDicts[monthStr + timeStr];
                        string timeRangerString = GetTimeRangeString(month, timeStr, int.Parse(yearStr));

                        DateTime startDate;
                        DateTime endDate;

                        var tempStr = timeRangerString.Split('|');

                        if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[0]), out startDate))
                        {
                            if (DateTime.TryParse(string.Format("{0}-{1}", yearStr, tempStr[1]), out endDate))
                            {
                                return new Tuple<DateTime, DateTime>(startDate, endDate);
                            }
                        }
                    }
                }
            }

            return null;
        }
    }

    /// <summary>
    /// 时间区间解析器，负责如：xxxx.xx.xx-xxxx.xx.xx，xxxx.xx-xxxx.xx，xx.xx-xx.xx
    /// 区间分割仅支持'-', '至', '到'
    /// </summary>
    public class DateRangeParser : DateTimeParserBase
    {
        public override Tuple<DateTime, DateTime> Parser(string datetimeString, int year)
        {
            string[] rangeStr = datetimeString.Split('-', '至', '到');

            if (rangeStr.Length != 2) return null;

            string regexString = @"(?<Year>^\d{4}\/|^\s*)(?<Month>\d{1,2})(\/)(?<Day>\d{1,2})";

            string startTemp = rangeStr[0].Replace('.', '/');
            string endTemp = rangeStr[1].Replace('.', '/');

            Regex regex = new Regex(regexString);
            Match startMatch = regex.Match(startTemp);
            Match endMatch = regex.Match(endTemp);

            if (startMatch.Success && endMatch.Success)
            {
                string sMonth = startMatch.Groups["Month"].Value;
                string sDay = startMatch.Groups["Day"].Value;
                string eMonth = endMatch.Groups["Month"].Value;
                string eDay = endMatch.Groups["Day"].Value;

                DateTime startTime;
                DateTime endTime;
                if (DateTime.TryParse(string.Format("{0}-{1}-{2}", year, sMonth, sDay), out startTime))
                {
                    if (DateTime.TryParse(string.Format("{0}-{1}-{2}", year, eMonth, eDay), out endTime))
                    {
                        if ((endTime - startTime).Days >= 0)
                            return new Tuple<DateTime, DateTime>(startTime, endTime);
                    }
                }
            }

            Tuple<DateTime, DateTime> startMonth = new MonthParser().Parser(startTemp, year);
            Tuple<DateTime, DateTime> endMonth = new MonthParser().Parser(endTemp, year);
            if (startMonth != null && endMonth != null)
            {
                if ((endMonth.Item2 - startMonth.Item1).Days >= 0)
                    return new Tuple<DateTime, DateTime>(startMonth.Item1, endMonth.Item2);
            }

            Tuple<DateTime, DateTime> startQuarter = new QuarterParser().Parser(startTemp, year);
            Tuple<DateTime, DateTime> endQuarter = new QuarterParser().Parser(endTemp, year);
            if (startQuarter != null && endQuarter != null)
            {
                if ((endQuarter.Item2 - startQuarter.Item1).Days >= 0)
                    return new Tuple<DateTime, DateTime>(startQuarter.Item1, endQuarter.Item2);
            }

            return null;
        }
    }
}



/*
 //测试方法

static void Main(string[] args)
        {
            YearParserTest();
            QuarterParserTest();
            MonthParserTest();
            DateRangeParserTest();

            var time1 = DateTimeParseHelper.Parser("全年", 2016);
            var time2 = DateTimeParseHelper.Parser("上半年", 2016);
            var time3 = DateTimeParseHelper.Parser("下半年", 2016);
            var time4 = DateTimeParseHelper.Parser("年初", 2016);
            var time5 = DateTimeParseHelper.Parser("年中", 2016);
            var time6 = DateTimeParseHelper.Parser("年末", 2016);

            var time7 = DateTimeParseHelper.Parser("1季度", 2016);
            var time8 = DateTimeParseHelper.Parser("01季度", 2016);
            var time9 = DateTimeParseHelper.Parser("第1季度", 2016);
            var time10 = DateTimeParseHelper.Parser("一季度", 2016);
            var time11 = DateTimeParseHelper.Parser("第一季度", 2016);
            
            var time12 = DateTimeParseHelper.Parser("1月", 2016);
            var time13 = DateTimeParseHelper.Parser("01月", 2016);
            var time14 = DateTimeParseHelper.Parser("1月上旬", 2016);
            var time15 = DateTimeParseHelper.Parser("1月中旬", 2016);
            var time16 = DateTimeParseHelper.Parser("1月下旬", 2016);
            var time17 = DateTimeParseHelper.Parser("1月初", 2016);
            var time18 = DateTimeParseHelper.Parser("1月中", 2016);
            var time19 = DateTimeParseHelper.Parser("1月末", 2016);
            var time20 = DateTimeParseHelper.Parser("1月底", 2016);
            var time21 = DateTimeParseHelper.Parser("一月", 2016);
            var time22 = DateTimeParseHelper.Parser("第一月", 2016);


            var time23 = DateTimeParseHelper.Parser("2016.1.1-2016.2.15", 2016);
            var time24 = DateTimeParseHelper.Parser("2016/1/1-2016/9/29", 2016);
            var time25 = DateTimeParseHelper.Parser("2016.1.1到2016.5.3", 2016);
            var time255 = DateTimeParseHelper.Parser("2016.1.1至2016.5.3", 2016);
            var time26 = DateTimeParseHelper.Parser("1.1-5.6", 2016);
            var time27 = DateTimeParseHelper.Parser("1-3月", 2016);
            var time28 = DateTimeParseHelper.Parser("5-9月", 2016);
            var time29 = DateTimeParseHelper.Parser("2-3季度", 2016);
            var time30 = DateTimeParseHelper.Parser("1月初-5月末", 2016);
            var time31 = DateTimeParseHelper.Parser("3月中旬-4月中旬", 2016);


            var time32 = DateTimeParseHelper.Parser("3、4月", 2016);
            var time33 = DateTimeParseHelper.Parser("1月中旬、6月下旬", 2016);
            var time34 = DateTimeParseHelper.Parser("1季度、3季度", 2016);
            var time35 = DateTimeParseHelper.Parser("1,2,5,8,10月", 2016);
            var time36 = DateTimeParseHelper.Parser("1,3季度", 2016);
            var time37 = DateTimeParseHelper.Parser("1-2月,7-8月", 2016);
            var time38 = DateTimeParseHelper.Parser("1.1-1.15,3.15-3.18", 2016);
        }

        public static void YearParserTest()
        {
            YearParser parser = new YearParser();

            Assert(DateTimeParseHelper.Parser("2016年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016年", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016年上半年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 6, 30));
            Assert(DateTimeParseHelper.Parser("2016下半年", 2016), new DateTime(2016, 7, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016年年初", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 4, 30));
            Assert(DateTimeParseHelper.Parser("2016年初", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 4, 30));
            Assert(DateTimeParseHelper.Parser("2016年中", 2016), new DateTime(2016, 5, 1), new DateTime(2016, 8, 31));
            Assert(DateTimeParseHelper.Parser("2016年末", 2016), new DateTime(2016, 9, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016上半年", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 6, 30));
            Assert(DateTimeParseHelper.Parser("2016下半年", 2015), new DateTime(2015, 7, 1), new DateTime(2015, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016年初", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 4, 30));
            Assert(DateTimeParseHelper.Parser("2016年中", 2015), new DateTime(2015, 5, 1), new DateTime(2015, 8, 31));
            Assert(DateTimeParseHelper.Parser("2016年末", 2015), new DateTime(2015, 9, 1), new DateTime(2015, 12, 31));
            Assert(DateTimeParseHelper.Parser("上半年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 6, 30));
            Assert(DateTimeParseHelper.Parser("下半年", 2016), new DateTime(2016, 7, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("年初", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 4, 30));
            Assert(DateTimeParseHelper.Parser("年中", 2016), new DateTime(2016, 5, 1), new DateTime(2016, 8, 31));
            Assert(DateTimeParseHelper.Parser("年末", 2016), new DateTime(2016, 9, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("上半年", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 6, 30));
            Assert(DateTimeParseHelper.Parser("下半年", 2015), new DateTime(2015, 7, 1), new DateTime(2015, 12, 31));
            Assert(DateTimeParseHelper.Parser("年初", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 4, 30));
            Assert(DateTimeParseHelper.Parser("年中", 2015), new DateTime(2015, 5, 1), new DateTime(2015, 8, 31));
            Assert(DateTimeParseHelper.Parser("年末", 2015), new DateTime(2015, 9, 1), new DateTime(2015, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016.年末", 2016), new DateTime(2016, 9, 1), new DateTime(2016, 12, 31));
            Assert(DateTimeParseHelper.Parser("2016.上半年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 6, 30));
            Assert(DateTimeParseHelper.Parser("2016年.上半年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 6, 30));
            Assert(DateTimeParseHelper.Parser("2016年的上半年", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 6, 30));

            Console.WriteLine("《2016年的上半年》无法识别的格式");

            Console.WriteLine("------------------------------------------------------------------");
        }



        public static void QuarterParserTest()
        {
            QuarterParser parser = new QuarterParser();

            Assert(DateTimeParseHelper.Parser("20161季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("201601季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016第一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));

            Assert(DateTimeParseHelper.Parser("2016.1季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016.01季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016.一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016.第一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));

            Assert(DateTimeParseHelper.Parser("2016-1季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016-01季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016-一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("2016第-一季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));

            Assert(DateTimeParseHelper.Parser("20161季度", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 3, 31));


            Assert(DateTimeParseHelper.Parser("1季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));
            Assert(DateTimeParseHelper.Parser("1季度", 2015), new DateTime(2015, 1, 1), new DateTime(2015, 3, 31));


            Console.WriteLine("------------------------------------------------------------------");
        }


        public static void MonthParserTest()
        {
            MonthParser parser = new MonthParser();

            Assert(DateTimeParseHelper.Parser("1月", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 1, 31));
            Assert(DateTimeParseHelper.Parser("01月", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 1, 31));
            Assert(DateTimeParseHelper.Parser("一月", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 1, 31));

            Assert(DateTimeParseHelper.Parser("二月", 2016), new DateTime(2016, 2, 1), new DateTime(2016, 2, 29));
            Assert(DateTimeParseHelper.Parser("二月上旬", 2016), new DateTime(2016, 2, 1), new DateTime(2016, 2, 10));
            Assert(DateTimeParseHelper.Parser("二月中旬", 2016), new DateTime(2016, 2, 11), new DateTime(2016, 2, 20));
            Assert(DateTimeParseHelper.Parser("二月下旬", 2016), new DateTime(2016, 2, 21), new DateTime(2016, 2, 29));

            Assert(DateTimeParseHelper.Parser("二月初", 2016), new DateTime(2016, 2, 1), new DateTime(2016, 2, 10));
            Assert(DateTimeParseHelper.Parser("二月中", 2016), new DateTime(2016, 2, 11), new DateTime(2016, 2, 20));
            Assert(DateTimeParseHelper.Parser("二月末", 2016), new DateTime(2016, 2, 21), new DateTime(2016, 2, 29));

            Assert(DateTimeParseHelper.Parser("4月", 2016), new DateTime(2016, 4, 1), new DateTime(2016, 4, 30));
            Assert(DateTimeParseHelper.Parser("04月上旬", 2016), new DateTime(2016, 4, 1), new DateTime(2016, 4, 10));
            Assert(DateTimeParseHelper.Parser("4月中旬", 2016), new DateTime(2016, 4, 11), new DateTime(2016, 4, 20));
            Assert(DateTimeParseHelper.Parser("04月下旬", 2016), new DateTime(2016, 4, 21), new DateTime(2016, 4, 30));


            Console.WriteLine("------------------------------------------------------------------");
        }


        private static void DateRangeParserTest()
        {

            DateRangeParser parser = new DateRangeParser();

            Assert(DateTimeParseHelper.Parser("2016.01.01-2016.3.5", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));
            Assert(DateTimeParseHelper.Parser("2016/1/01-2016/03/05", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));
            Assert(DateTimeParseHelper.Parser("2016.01.01至2016.3.5", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));

            Assert(DateTimeParseHelper.Parser("01.01-3.5", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));
            Assert(DateTimeParseHelper.Parser("1/01-03/05", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));
            Assert(DateTimeParseHelper.Parser("01.01至3.5", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 5));

            Assert(DateTimeParseHelper.Parser("1月初-2月底", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 2, 29));
            Assert(DateTimeParseHelper.Parser("1季度-3季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 9, 30));

            Assert(DateTimeParseHelper.Parser("1-2月", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 2, 29));
            Assert(DateTimeParseHelper.Parser("1-3季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 9, 30));

            Assert(DateTimeParseHelper.Parser("2016.1月-2016.3月", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 3, 31));

            Assert(DateTimeParseHelper.Parser("2016.1月中-2016.3月底", 2016), new DateTime(2016, 1, 11), new DateTime(2016, 3, 31));

            Assert(DateTimeParseHelper.Parser("2016.1季度-2016.3季度", 2016), new DateTime(2016, 1, 1), new DateTime(2016, 9, 30));

            Console.WriteLine("------------------------------------------------------------------");

        }

        public static void Assert(List<Tuple<DateTime, DateTime>> testDate, DateTime startDate, DateTime endDate)
        {
            if (testDate.Count == 0)
                Console.WriteLine("Error......................");
            else
                Console.WriteLine((testDate[0].Item1 == startDate && testDate[0].Item2 == endDate));
        }
*/
