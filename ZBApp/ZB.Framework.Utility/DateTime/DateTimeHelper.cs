using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Globalization;
using System.Runtime.InteropServices;

namespace ZB.Framework.Utility
{
    public enum PeriodEnum
    {
        /// <summary>
        /// 重置
        /// </summary>
        [AttachData("重置")]
        Replace,

        /// <summary>
        /// 昨天
        /// </summary>
        [AttachData("昨天")]
        Yesterday,

        /// <summary>
        /// 昨天之前
        /// </summary>
        [AttachData("昨天之前")]
        BeforeYesterday,

        /// <summary>
        /// 今天
        /// </summary>
        [AttachData("今天")]
        Today,

        /// <summary>
        /// 今天之前
        /// </summary>
        [AttachData("今天之前")]
        BeforeToday,

        /// <summary>
        /// 本周
        /// </summary>
        [AttachData("本周")]
        ThisWeek,

        /// <summary>
        /// 本周之前
        /// </summary>
        [AttachData("本周之前")]
        UntilThisWeek,

        /// <summary>
        /// 上周
        /// </summary>
        [AttachData("上周")]
        LastWeek,

        /// <summary>
        /// 上周之前
        /// </summary>
        [AttachData("上周之前")]
        BeforeLastWeek,

        /// <summary>
        /// 本月
        /// </summary>
        [AttachData("本月")]
        ThisMonth,

        /// <summary>
        /// 本月之前
        /// </summary>
        [AttachData("本月之前")]
        BeforeThisMonth,


        /// <summary>
        /// 下月
        /// </summary>
        [AttachData("下月")]
        NextMonth,

        /// <summary>
        /// 本季
        /// </summary>
        [AttachData("本季")]
        ThisSeason,

        /// <summary>
        /// 下季
        /// </summary>
        [AttachData("下季")]
        NextSeason,


        /// <summary>
        /// 上半年
        /// </summary>
        [AttachData("上半年")]
        FristHalfYear,

        /// <summary>
        /// 下半年
        /// </summary>
        [AttachData("下半年")]
        SecondHalfYear,


        /// <summary>
        /// 上月
        /// </summary>
        [AttachData("上月")]
        LastMonth,

        /// <summary>
        /// 去年
        /// </summary>
        [AttachData("去年")]
        LastYear,

        /// <summary>
        /// 去年或更早
        /// </summary>
        [AttachData("去年或更早")]
        LastYearOrSooner,

        /// <summary>
        /// 今年
        /// </summary>
        [AttachData("今年")]
        ThisYear,

        /// <summary>
        /// 明年
        /// </summary>
        [AttachData("明年")]
        NextYear,

        /// <summary>
        /// 明天
        /// </summary>
        [AttachData("明天")]
        Tomorrow,

        /// <summary>
        /// 今天之后
        /// </summary>
        [AttachData("今天之后")]
        FromThisDay,
        /// <summary>
        /// 一年内
        /// </summary>
        [AttachData("一年内")]
        OneYear,
        /// <summary>
        /// 两年内
        /// </summary>
        [AttachData("两年内")]
        TwoYear,
        /// <summary>
        /// 三年内
        /// </summary>
        [AttachData("三年内")]
        ThreeYear,
        /// <summary>
        /// 三年以上
        /// </summary>
        [AttachData("三年以上")]
        GreaterThreeYear,
        /// <summary>
        /// 五年内
        /// </summary>
        [AttachData("五年内")]
        FiveYear,
        /// <summary>
        /// 五年以上
        /// </summary>
        [AttachData("五年以上")]
        GreaterFiveYear
    }

    /// <summary>
    /// 时间类型
    /// </summary>
    public enum DateTypeEnum
    {
        [AttachData("年度")]
        Year = 1,

        [AttachData("半年")]
        HalfYear,

        [AttachData("季度")]
        Quarter,

        [AttachData("月度")]
        Month,
    }

    public static class DateTimeHelper
    {
        /// <summary>
        /// 判断两个时间段之间是否存在交集
        /// </summary>
        /// <param name="firstStartTime"></param>
        /// <param name="firstEndTiem"></param>
        /// <param name="secondStartTime"></param>
        /// <param name="secondEndTime"></param>
        /// <returns></returns>
        public static bool IsMixed(DateTime firstStartTime, DateTime firstEndTiem, DateTime secondStartTime, DateTime secondEndTime)
        {
            double startTimeSpan = (secondStartTime - firstStartTime).TotalMinutes;
            if (startTimeSpan > 0)
            {
                double span2 = (secondStartTime - firstEndTiem).TotalMinutes;
                return span2 >= 0 ? false : true;
            }
            else
            {
                double span2 = (firstStartTime - secondEndTime).TotalMinutes;
                return span2 >= 0 ? false : true;
            }
        }

        public static string ToTimeSpanString(DateTime startTime, DateTime endTime)
        {
            TimeSpan span = endTime - startTime;

            StringBuilder builder = new StringBuilder();

            if (span.Days > 0)
            {
                builder.AppendFormat("{0}天", span.Days);
            }
            else if (span.Hours > 0)
            {
                builder.AppendFormat("{0}小时", span.Hours);
            }
            else if (span.Minutes > 0)
            {
                builder.AppendFormat("{0}分钟", span.Minutes);
            }

            return builder.ToString();
        }

        public static string ToSqlDateString(this DateTime dt)
        {
            return dt.ToString("yyyy-MM-dd");
        }

        public static string ToSqlTimeString(this DateTime dt)
        {
            return dt.ToString("yyyy-MM-dd HH:mm:ss");
        }

        public static bool IsHaveSameTimeSpan(DateTime dtStart1, DateTime dtEnd1, DateTime dtStart2, DateTime dtEnd2)
        {
            return dtStart1 <= dtEnd2 && dtEnd1 >= dtStart2;
        }

        public static int GetDaysInMonth(int year, int month)
        {
            DateTime firstDay = new DateTime(year, month, 1);
            return firstDay.AddMonths(1).AddDays(-1).Day;
        }

        /// <summary>
        /// 获取该时间当前月的第一天
        /// </summary>
        public static DateTime GetMonthFirstDay(DateTime dt)
        {
            return new DateTime(dt.Year, dt.Month, 1);
        }

        /// <summary>
        /// 获取该时间当前月的最后一天
        /// </summary>
        public static DateTime GetMonthLastDay(DateTime dt)
        {
            DateTime date = new DateTime(dt.Year, dt.Month, 1);
            return date.AddMonths(1).AddDays(-1);
        }

        /// <summary>
        /// 获取两个时间之间的间隔(分钟)
        /// </summary>
        /// <param name="fisrtDateTime"></param>
        /// <param name="lastDateTime"></param>
        /// <returns></returns>
        public static int DateTimeDiffAsMinutes(DateTime? firstDateTime, DateTime? lastDateTime)
        {
            if (firstDateTime == null || lastDateTime == null)
            {
                return 0;
            }

            TimeSpan timespan = firstDateTime.Value - lastDateTime.Value;

            return Math.Abs((int)timespan.TotalMinutes);
        }


        public static int DateTimeDiffAsDay(DateTime? firstDateTime, DateTime? lastDateTime, bool isAbs = false)
        {
            if (firstDateTime == null || lastDateTime == null)
            {
                return 0;
            }

            TimeSpan timespan = firstDateTime.Value - lastDateTime.Value;


            int days = (int)timespan.TotalDays;

            if (isAbs)
            {
                return Math.Abs(days);
            }

            return days;
        }




        /// <summary>
        /// 获取两个时间之间的间隔(秒)
        /// </summary>
        /// <param name="fisrtDateTime"></param>
        /// <param name="lastDateTime"></param>
        /// <returns></returns>
        public static int DateTimeDiffAsSeconds(DateTime? firstDateTime, DateTime? lastDateTime)
        {
            if (firstDateTime == null || lastDateTime == null)
            {
                return 0;
            }

            TimeSpan timespan = firstDateTime.Value - lastDateTime.Value;

            return Math.Abs((int)timespan.TotalSeconds);
        }


        /// <summary>
        /// 获取指定时间段内的所有日期的集合,精确到天,时间按ASC排序
        /// </summary>
        /// <param name="startDate"></param>
        /// <param name="endDate"></param>
        /// <returns></returns>
        public static IEnumerable<DateTime> GetDateRange(DateTime startDate, DateTime endDate)
        {
            TimeSpan span = (endDate.Date - startDate.Date);
            int range = span.Days;

            List<DateTime> dtList = new List<DateTime>();

            for (int i = 0; i <= Math.Abs(range); i++)
            {
                if (range < 0)
                {
                    dtList.Add(startDate.AddDays((0 - i)));
                }
                else
                {
                    dtList.Add(startDate.AddDays((i)));
                }
            }

            return dtList.OrderBy(s => s).ToList();
        }

        /// <summary>
        /// 获取某年某月的开始时间和结束时间(从当前月的00:00:00-月末的23:59:59)
        /// </summary>
        /// <param name="year">年</param>
        /// <param name="month">月</param>
        /// <param name="beginDateTime"></param>
        /// <param name="endDateTime"></param>
        public static void GetMonthSpan(int year, int month, out DateTime beginDateTime, out DateTime endDateTime)
        {
            beginDateTime = new DateTime(year, month, 1);
            endDateTime = beginDateTime.AddMonths(1).AddSeconds(-1);
        }

        /// <summary>
        /// 获取某年某一季度的开始时间和结束时间(从当前季度的00:00:00-该季度末的23:59:59)
        /// 该方法接收一个月份，自动计算季度
        /// </summary>
        /// <param name="year"></param>
        /// <param name="month"></param>
        /// <param name="beginDateTime"></param>
        /// <param name="endDateTime"></param>
        public static void GetQuarterSpan(int year, int month, out DateTime beginDateTime, out DateTime endDateTime)
        {
            DateTime dt = new DateTime(year, month, 1);

            beginDateTime = dt.AddMonths(0 - (dt.Month - 1) % 3).AddDays(1 - dt.Day);
            endDateTime = beginDateTime.AddMonths(3).AddSeconds(-1);
        }

        /// <summary>
        /// 获取某一年的开始时间和结束时间(从当前年的00:00:00-年末的23:59:59)
        /// </summary>
        /// <param name="year"></param>
        /// <param name="beginDateTime"></param>
        /// <param name="endDateTime"></param>
        public static void GetYearSpan(int year, out DateTime beginDateTime, out DateTime endDateTime)
        {
            beginDateTime = new DateTime(year, 1, 1);
            endDateTime = beginDateTime.AddYears(1).AddSeconds(-1);
        }


        /// <summary>
        /// 获取某一年的某一周的日期
        /// </summary>
        /// <param name="year"></param>
        /// <param name="week"></param>
        /// <returns></returns>
        public static List<DateTime> GetCurrentWeekRang(int year, int week)
        {
            DateTime firstDate;
            DateTime lastDate;

            List<DateTime> dates = new List<DateTime>();

            if (GetDaysOfWeeks(year, week, CalendarWeekRule.FirstFullWeek, out firstDate, out lastDate))
            {
                dates.Add(firstDate);
                dates.Add(firstDate.AddDays(1));
                dates.Add(firstDate.AddDays(2));
                dates.Add(firstDate.AddDays(3));
                dates.Add(firstDate.AddDays(4));
                dates.Add(firstDate.AddDays(5));
                dates.Add(firstDate.AddDays(6));
            }

            return dates;
        }

        /// <summary>
        /// 获取一年有多少个周
        /// </summary>
        /// <param name="year"></param>
        /// <returns></returns>
        public static int GetWeekAmount(int year)
        {
            DateTime date = new DateTime(year, 12, 31);

            GregorianCalendar calendar = new GregorianCalendar();

            return calendar.GetWeekOfYear(date, CalendarWeekRule.FirstDay, DayOfWeek.Monday);
        }


        /// <summary>
        /// 获取某一年某一周的开始时间和结束时间
        /// </summary>
        /// <param name="year"></param>
        /// <param name="week"></param>
        /// <param name="weekrule"></param>
        /// <param name="first"></param>
        /// <param name="last"></param>
        /// <returns></returns>
        public static bool GetDaysOfWeeks(int year, int week, CalendarWeekRule weekrule, out DateTime first, out DateTime last)
        {
            first = DateTime.MinValue;
            last = DateTime.MinValue;

            if (year < 1 || year > 9999 || week < 1 || week > 53) { return false; }


            DateTime firstCurr = new DateTime(year, 1, 1);
            DateTime firstNext = new DateTime(year + 1, 1, 1);


            int dayOfWeekFirst = (int)firstCurr.DayOfWeek;
            if (dayOfWeekFirst == 0) { dayOfWeekFirst = 7; }


            first = firstCurr.AddDays((week - 1) * 7 - dayOfWeekFirst + 1);

            if (first.Year < year)
            {
                switch (weekrule)
                {
                    case CalendarWeekRule.FirstDay:
                        first = firstCurr;
                        break;
                    case CalendarWeekRule.FirstFourDayWeek:
                        first = first.AddDays(7);
                        break;
                    case CalendarWeekRule.FirstFullWeek:
                        if (firstCurr.Subtract(first).Days > 3)
                        {
                            first = first.AddDays(7);
                        }
                        break;
                    default:
                        break;
                }
            }


            last = first.AddDays(7).AddSeconds(-1);

            if (last.Year > year)
            {
                switch (weekrule)
                {
                    case CalendarWeekRule.FirstDay:
                        last = firstNext.AddSeconds(-1);
                        break;
                    case CalendarWeekRule.FirstFullWeek:
                        break;
                    case CalendarWeekRule.FirstFourDayWeek:
                        if (firstNext.Subtract(first).Days < 4)
                        {
                            first = first.AddDays(-7);
                            last = last.AddDays(-7);
                        }
                        break;
                    default:
                        break;
                }
            }
            return true;
        }

        public static void FillPeriodByPeriodEnumIntVal(int periodEnumIntVal, out DateTime? startTime, out DateTime? endTime)
        {
            DateTime now = DateTime.Now.Date;

            int weekIntVal = (int)now.DayOfWeek;
            if (0 == weekIntVal)
            {
                weekIntVal = 7;
            }

            switch (periodEnumIntVal)
            {
                case (int)PeriodEnum.Yesterday:
                    {
                        startTime = now.AddDays(-1);
                        endTime = now.AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.BeforeYesterday:
                    {
                        startTime = null;
                        endTime = now.AddDays(-1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.Today:
                    {
                        startTime = now;
                        endTime = now.AddDays(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.BeforeToday:
                    {
                        startTime = null;
                        endTime = now.AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.ThisWeek:
                    {
                        DateTime firstDayOfWeek = now.AddDays(1 - weekIntVal);
                        startTime = firstDayOfWeek;
                        endTime = firstDayOfWeek.AddDays(7).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.UntilThisWeek:
                    {
                        startTime = null;
                        endTime = now.AddDays(1 - weekIntVal).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.LastWeek:
                    {
                        DateTime firstDayOfPreWeek = now.AddDays(1 - weekIntVal - 7);
                        startTime = firstDayOfPreWeek;
                        endTime = firstDayOfPreWeek.AddDays(7).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.BeforeLastWeek:
                    {
                        startTime = null;
                        endTime = now.AddDays(1 - weekIntVal - 7).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.ThisMonth:
                    {
                        DateTime firstDayOfMonth = now.AddDays(1 - now.Day);
                        startTime = firstDayOfMonth;
                        endTime = firstDayOfMonth.AddMonths(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.BeforeThisMonth:
                    {
                        startTime = null;
                        endTime = now.AddDays(1 - now.Day).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.LastMonth:
                    {
                        //DateTime firstDayOfPreMonth = now.AddDays(1 - now.Day).AddMonths(-1);
                        //startTime = firstDayOfPreMonth;
                        //endTime = now.AddDays(1 - now.Day).AddSeconds(-1);
                        var tempTime = now.AddMonths(-1);
                        startTime = new DateTime(tempTime.Year, tempTime.Month, 1);
                        endTime = startTime.Value.AddMonths(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.LastYear:
                    {
                        DateTime last = new DateTime(now.Year - 1, 1, 1);

                        startTime = last;
                        endTime = last.AddYears(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.LastYearOrSooner:
                    {
                        DateTime thisdata = new DateTime(now.Year, 1, 1);

                        startTime = null;
                        endTime = thisdata.AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.ThisYear:
                    {
                        DateTime thisdata = new DateTime(now.Year, 1, 1);

                        startTime = thisdata;
                        endTime = thisdata.AddYears(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.Tomorrow:
                    {
                        startTime = now.AddDays(1);
                        endTime = now.AddDays(2).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.FromThisDay:
                    {
                        startTime = now;
                        endTime = null;
                        break;
                    }
                case (int)PeriodEnum.NextMonth:
                    {
                        var tempTime = now.AddMonths(1);
                        startTime = new DateTime(tempTime.Year, tempTime.Month, 1);
                        endTime = startTime.Value.AddMonths(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.ThisSeason:
                    {
                        var date = now.AddMonths(0 - (now.Month - 1) % 3);
                        startTime = new DateTime(date.Year, date.Month, 1);
                        endTime = startTime.Value.AddMonths(3).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.NextSeason:
                    {
                        var date = now.AddMonths(3 - (now.Month - 1) % 3);
                        startTime = new DateTime(date.Year, date.Month, 1);
                        endTime = startTime.Value.AddMonths(3).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.FristHalfYear:
                    {
                        startTime = new DateTime(now.Year, 1, 1);
                        endTime = startTime.Value.AddMonths(6).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.SecondHalfYear:
                    {
                        startTime = new DateTime(now.Year, 7, 1);
                        endTime = startTime.Value.AddMonths(6).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.NextYear:
                    {
                        startTime = new DateTime(now.Year + 1, 1, 1);
                        endTime = startTime.Value.AddYears(1).AddSeconds(-1);
                        break;
                    }
                case (int)PeriodEnum.OneYear:
                    {
                        startTime = now.AddYears(-1);
                        endTime = now;
                        break;
                    }
                case (int)PeriodEnum.TwoYear:
                    {
                        startTime = now.AddYears(-2);
                        endTime = now;
                        break;
                    }
                case (int)PeriodEnum.ThreeYear:
                    {
                        startTime = now.AddYears(-3);
                        endTime = now;
                        break;
                    }
                case (int)PeriodEnum.GreaterThreeYear:
                    {
                        startTime = null;
                        endTime = now.AddYears(-3);
                        break;
                    }
                case (int)PeriodEnum.FiveYear:
                    {
                        startTime = now.AddYears(-5);
                        endTime = now;
                        break;
                    }
                case (int)PeriodEnum.GreaterFiveYear:
                    {
                        startTime = null;
                        endTime = now.AddYears(-5);
                        break;
                    }
                default:
                    {
                        startTime = null;
                        endTime = null;
                        break;
                    }
            }
        }



        /// <summary>
        /// 获取时间段内包含的年,Tuple(年，年)
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <returns></returns>
        public static List<Tuple<int, int>> GetDateTimeIncludeYear(DateTime startTime, DateTime endTime)
        {
            if (startTime == null || endTime == null)
                throw new ArgumentException("开始时间和结束时间不允许为null");

            if (startTime > endTime)
                throw new ArgumentException("开始时间大于结束时间");

            List<Tuple<int, int>> resultList = new List<Tuple<int, int>>();

            int diffYear = startTime.Year - endTime.Year;
            int minYear = startTime.Year;

            for (int i = 0; i <= diffYear; i++)
            {
                int year = minYear + i;
                resultList.Add(new Tuple<int, int>(year, year));
            }

            return resultList;
        }

        /// <summary>
        /// 获取时间段内包含的半年,Tuple(年,半年)
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <returns></returns>
        public static List<Tuple<int, int>> GetDateTimeIncludeHalfYear(DateTime startTime, DateTime endTime)
        {
            List<Tuple<int, int>> includeMonth = GetDateTimeIncludeMonth(startTime, endTime);

            //Dictionary<年,月列表>
            Dictionary<int, List<int>> yearDicts = new Dictionary<int, List<int>>();

            foreach (var month in includeMonth)
            {
                if (!yearDicts.ContainsKey(month.Item1))
                {
                    yearDicts.Add(month.Item1, new List<int>());
                }
                yearDicts[month.Item1].Add(month.Item2);
            }

            List<Tuple<int, int>> resultList = new List<Tuple<int, int>>();

            foreach (var year in yearDicts.Keys)
            {
                if (yearDicts[year].Any(r => r <= 6))
                {
                    resultList.Add(new Tuple<int, int>(year, 1));
                }
                if (yearDicts[year].Any(r => r > 6))
                {
                    resultList.Add(new Tuple<int, int>(year, 2));
                }
            }

            return resultList;
        }

        /// <summary>
        /// 获取时间段内包含的季度,Tuple（年，季度）
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <returns></returns>
        public static List<Tuple<int, int>> GetDateTimeIncludeQuarter(DateTime startTime, DateTime endTime)
        {
            List<Tuple<int, int>> includeMonth = GetDateTimeIncludeMonth(startTime, endTime);

            //Dictionary<年,月列表>
            Dictionary<int, List<int>> yearDicts = new Dictionary<int, List<int>>();

            foreach (var month in includeMonth)
            {
                if (!yearDicts.ContainsKey(month.Item1))
                {
                    yearDicts.Add(month.Item1, new List<int>());
                }
                yearDicts[month.Item1].Add(month.Item2);
            }

            List<Tuple<int, int>> resultList = new List<Tuple<int, int>>();

            foreach (var year in yearDicts.Keys)
            {
                if (yearDicts[year].Any(r => r <= 3))
                {
                    resultList.Add(new Tuple<int, int>(year, 1));
                }
                if (yearDicts[year].Any(r => r > 3 && r <= 6))
                {
                    resultList.Add(new Tuple<int, int>(year, 2));
                }
                if (yearDicts[year].Any(r => r > 6 && r <= 9))
                {
                    resultList.Add(new Tuple<int, int>(year, 3));
                }
                if (yearDicts[year].Any(r => r > 9 && r <= 12))
                {
                    resultList.Add(new Tuple<int, int>(year, 4));
                }
            }

            return resultList;
        }

        /// <summary>
        /// 获取时间段内包含的月度,Tuple(年，月度)
        /// </summary>
        /// <param name="startTime"></param>
        /// <param name="endTime"></param>
        /// <returns></returns>
        public static List<Tuple<int, int>> GetDateTimeIncludeMonth(DateTime startTime, DateTime endTime)
        {
            if (startTime == null || endTime == null)
                throw new ArgumentException("开始时间和结束时间不允许为null");

            if (startTime > endTime)
                throw new ArgumentException("开始时间大于结束时间");

            int diffMonth = (endTime.Month - startTime.Month) + (12 * (endTime.Year - startTime.Year));

            int minYear = startTime.Year;
            int minMonth = startTime.Month;

            List<Tuple<int, int>> resultList = new List<Tuple<int, int>>();

            for (int i = minMonth; i <= (minMonth + diffMonth); i++)
            {
                //因为每一年都有一个12月，而12/12等于1，但12月并不是新的一年，所以该处计算的时候减去1个月
                int yearSpan = (i - 1) / 12;

                int year = minYear + yearSpan;
                int month = i - (12 * yearSpan);

                resultList.Add(new Tuple<int, int>(year, month));
            }

            return resultList;
        }

        /// <summary>
        /// 得到随机日期
        /// </summary>
        /// <param name="time1">起始日期</param>
        /// <param name="time2">结束日期</param>
        /// <returns>间隔日期之间的 随机日期</returns>
        public static DateTime GetRandomTime(DateTime time1, DateTime time2)
        {
            Random random = new Random();
            DateTime minTime = new DateTime();
            DateTime maxTime = new DateTime();

            System.TimeSpan ts = new System.TimeSpan(time1.Ticks - time2.Ticks);

            // 获取两个时间相隔的秒数
            double dTotalSecontds = ts.TotalSeconds;
            int iTotalSecontds = 0;

            if (dTotalSecontds > System.Int32.MaxValue)
            {
                iTotalSecontds = System.Int32.MaxValue;
            }
            else if (dTotalSecontds < System.Int32.MinValue)
            {
                iTotalSecontds = System.Int32.MinValue;
            }
            else
            {
                iTotalSecontds = (int)dTotalSecontds;
            }


            if (iTotalSecontds > 0)
            {
                minTime = time2;
                maxTime = time1;
            }
            else if (iTotalSecontds < 0)
            {
                minTime = time1;
                maxTime = time2;
            }
            else
            {
                return time1;
            }

            int maxValue = iTotalSecontds;

            if (iTotalSecontds <= System.Int32.MinValue)
                maxValue = System.Int32.MinValue + 1;

            int i = random.Next(System.Math.Abs(maxValue));

            return minTime.AddSeconds(i);
        }




    }
}
