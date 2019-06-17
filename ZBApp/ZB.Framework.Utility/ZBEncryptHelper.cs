using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace ZB.Framework.Utility
{
    public class ZBEncryptHelper
    {
        public static string MD5Base64(string str)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] data = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
            return Convert.ToBase64String(data);
        }

        public static string HMACSha1(string data, string key)
        {
            HMACSHA1 myhmacsha1 = new HMACSHA1(Encoding.UTF8.GetBytes(key));
            byte[] byteArray = Encoding.UTF8.GetBytes(data);
            return Convert.ToBase64String(myhmacsha1.ComputeHash(byteArray));
        }

        /// <summary>
        /// 简单加密函数
        /// </summary>
        /// <param name="str">要加密的字符串</param>
        /// <returns>返回加密后的字符串</returns>
        /// 
        public static string Simple_Encode(string str)
        {
            string s = "";
            try
            {
                for (int i = 0; i < str.Length; i++)
                {
                    s += (char)(str[i] + 10 - 1 * 2);
                }
                byte[] b = System.Text.Encoding.UTF8.GetBytes(s);
                return Convert.ToBase64String(b);
            }
            catch
            {
                return str;
            }
        }

        /// <summary>
        /// 简单解密函数
        /// </summary>
        /// <param name="str">要解密的字符串</param>
        /// <returns>返回解密后的字符串</returns>
        /// 
        public static string Simple_Decode(string str)
        {
            byte[] bb = Convert.FromBase64String(str);
            string ss = Encoding.UTF8.GetString(bb);

            string s = "";
            try
            {
                for (int i = 0; i < ss.Length; i++)
                {
                    s += (char)(ss[i] - 10 + 1 * 2);
                }

                return s;
            }
            catch
            {
                return str;
            }
        }
    }
}
