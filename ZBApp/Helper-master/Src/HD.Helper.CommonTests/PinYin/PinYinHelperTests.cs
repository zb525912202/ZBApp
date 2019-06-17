using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace HD.Helper.Common.Tests
{
    [TestClass()]
    public class PinYinHelperTests
    {
        [TestMethod()]
        public void GetPinYinStrTest() {
            string pinyin = PinYinHelper.GetPinYinStr("张");
            Assert.AreEqual(pinyin, "ZHANG");
        }
    }
}