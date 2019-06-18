using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZB.Common.DAL;
using ZB.Common.Data;
using ZB.Framework.Utility;

namespace ZB.App.Console
{
    class Program
    {
        static void Main(string[] args)
        {
            var obj = EmployeeDAL.Instance.Find(1);
            string str = ReflectionHelper.GetPropertyInfo<Employee>(obj);
            System.Console.WriteLine(str);
            System.Console.ReadKey();
        }
    }
}
