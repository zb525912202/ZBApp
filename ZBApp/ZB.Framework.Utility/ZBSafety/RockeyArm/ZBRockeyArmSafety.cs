using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace ZB.Framework.Utility
{
    public class ZBCertRockeyArmSafety : ZBRockeyArmSafetyBase
    {
        public static readonly ZBCertRockeyArmSafety Instance = new ZBCertRockeyArmSafety();
        private ZBCertRockeyArmSafety() { }


        public CertCustomerInfo ReadCustomerInfo(out string error)
        {
            var result = this.ReadCustomerInfo((int)ZBSystemTypeEnum.Cert, out error);
            if (!string.IsNullOrEmpty(error)) return null;

            var rockeyArm = SmartSerializeHelper.DeserializeObject<ZBCertRockeyArm>(result.ObjDatas, ZBCertRockeyArm.LoadObj);

            return new CertCustomerInfo()
            {
                CustomerKey = rockeyArm.CustomerKey,
                CustomerName = rockeyArm.CustomerName,
                ZBSystemType = (int)ZBSystemTypeEnum.Cert,
                EmpowerDate = rockeyArm.EmpowerDate,
                HId = RockeyArmHelper.GetHIdStr(result.PDongleInfo),
                OperatorLimit = rockeyArm.OperatorLimit
            };
        }

        public string WriteCustomerInfo(CertCustomerInfo info, out string error)
        {
            ZBCertRockeyArm rockeyArm = new ZBCertRockeyArm()
            {
                CustomerKey = info.CustomerKey,
                CustomerName = info.CustomerName,
                EmpowerDate = info.EmpowerDate,
                OperatorLimit = info.OperatorLimit
            };
            byte[] bytes = SmartSerializeHelper.SerializeObject(rockeyArm, ZBCertRockeyArm.LoadBytes);
            info.HId = this.WriteCustomerInfo((int)ZBSystemTypeEnum.Cert, bytes, out error);
            return info.HId;
        }
    }

    public class ZBPQRockeyArmSafety : ZBRockeyArmSafetyBase
    {
        public static readonly ZBPQRockeyArmSafety Instance = new ZBPQRockeyArmSafety();
        private ZBPQRockeyArmSafety() { }

        public PQCustomerInfo ReadCustomerInfo(out string error)
        {
            var result = this.ReadCustomerInfo((int)ZBSystemTypeEnum.PQ, out error);
            ZBPQRockeyArm ZBPQRockeyArm = SmartSerializeHelper.DeserializeObject<ZBPQRockeyArm>(result.ObjDatas, ZBPQRockeyArm.LoadObj);
            return new PQCustomerInfo()
            {
                CustomerKey = ZBPQRockeyArm.CustomerKey,
                CustomerName = ZBPQRockeyArm.CustomerName,
                ZBSystemType = (int)ZBSystemTypeEnum.PQ,
                EmpowerDate = ZBPQRockeyArm.EmpowerDate,
                HId = RockeyArmHelper.GetHIdStr(result.PDongleInfo)
            };
        }

        public string WriteCustomerInfo(PQCustomerInfo info, out string error)
        {
            ZBPQRockeyArm rockeyArm = new ZBPQRockeyArm()
            {
                CustomerKey = info.CustomerKey,
                CustomerName = info.CustomerName,
                EmpowerDate = info.EmpowerDate,
            };
            byte[] bytes = SmartSerializeHelper.SerializeObject(rockeyArm, ZBPQRockeyArm.LoadBytes);
            info.HId = this.WriteCustomerInfo((int)ZBSystemTypeEnum.PQ, bytes, out error);
            return info.HId;
        }
    }

    public class ZBPQEXRockeyArmSafety : ZBRockeyArmSafetyBase
    {
        public static readonly ZBPQEXRockeyArmSafety Instance = new ZBPQEXRockeyArmSafety();
        private ZBPQEXRockeyArmSafety() { }

        public PQEXCustomerInfo ReadCustomerInfo(out string error)
        {
            var result = this.ReadCustomerInfo((int)ZBSystemTypeEnum.PQEX, out error);
            ZBPQEXRockeyArm ZBPQEXRockeyArm = SmartSerializeHelper.DeserializeObject<ZBPQEXRockeyArm>(result.ObjDatas, ZBPQEXRockeyArm.LoadObj);
            return new PQEXCustomerInfo()
            {
                CustomerKey = ZBPQEXRockeyArm.CustomerKey,
                CustomerName = ZBPQEXRockeyArm.CustomerName,
                ZBSystemType = (int)ZBSystemTypeEnum.PQEX,
                EmpowerDate = ZBPQEXRockeyArm.EmpowerDate,
                HId = RockeyArmHelper.GetHIdStr(result.PDongleInfo)
            };
        }

        public string WriteCustomerInfo(PQEXCustomerInfo info, out string error)
        {
            ZBPQEXRockeyArm rockeyArm = new ZBPQEXRockeyArm()
            {
                CustomerKey = info.CustomerKey,
                CustomerName = info.CustomerName,
                EmpowerDate = info.EmpowerDate,
            };
            byte[] bytes = SmartSerializeHelper.SerializeObject(rockeyArm, ZBPQEXRockeyArm.LoadBytes);
            info.HId = this.WriteCustomerInfo((int)ZBSystemTypeEnum.PQEX, bytes, out error);
            return info.HId;
        }
    }

    public class ZBRockeyArmSafetyBase
    {
        private const uint DefaultPid = 4294967295;
        private const uint ZBMasterPid = 4069330466;
        private byte[] DefaultAdminPin = new byte[16] { 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70 }; //默认的开发商密码
        private byte[] ZBMasterPin = new byte[] { 50, 66, 70, 48, 53, 70, 48, 56, 49, 57, 67, 51, 49, 56, 48, 65, 0 };//佳腾Pin   

        public class ReadCustomerInfoResult
        {
            public DONGLE_INFO PDongleInfo { get; set; }
            public byte[] ObjDatas { get; set; }
        }

        public static string ReadCustomerInfoStr(out string error)
        {
            try
            {
                ushort pCount = 0;
                var pt = RockeyArmHelper.EnumRockeyArm(out pCount);

                string strInfo = string.Format("共找到{0}个加密锁.", pCount);
                for (int i = 0; i < pCount; i++)
                {
                    DONGLE_INFO pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)((UInt32)pt + i * Marshal.SizeOf(typeof(DONGLE_INFO))), typeof(DONGLE_INFO));

                    if (pDongleInfo.m_PID == ZBMasterPid)//只读取ZBMaster初始化过的加密锁
                    {
                        uint hDongle = 0;
                        RockeyArmHelper.OpenRockey(ref hDongle, i);
                        byte[] datas = RockeyArmHelper.ReadData(hDongle, 0, 4);
                        int systemType = BitConverter.ToInt32(datas, 0);

                        byte[] objDatas = RockeyArmHelper.ReadData(hDongle, 4);

                        if (systemType == (int)ZBSystemTypeEnum.PQ)
                        {
                            var rockeyArm = SmartSerializeHelper.DeserializeObject<ZBPQRockeyArm>(objDatas, ZBPQRockeyArm.LoadObj);
                            strInfo += string.Format("\r\n----------第{0}个----------\r\n{1}", i + 1, rockeyArm.GetInfo());
                        }
                        else if (systemType == (int)ZBSystemTypeEnum.Cert)
                        {
                            var rockeyArm = SmartSerializeHelper.DeserializeObject<ZBCertRockeyArm>(objDatas, ZBCertRockeyArm.LoadObj);
                            strInfo += string.Format("\r\n----------第{0}个----------\r\n{1}", i + 1, rockeyArm.GetInfo());
                        }

                        RockeyArmHelper.CloseRockey(hDongle);
                    }
                }

                error = string.Empty;
                return strInfo;
            }
            catch (Exception ex)
            {
                error = ex.Message;
                return null;
            }
        }

        /// <summary>
        /// 读取指定ZB系统类型的加密锁
        /// </summary>
        internal ReadCustomerInfoResult ReadCustomerInfo(int ZBSystemType, out string error)
        {
            try
            {
                ushort pCount = 0;
                var pt = RockeyArmHelper.EnumRockeyArm(out pCount);

                for (int i = 0; i < pCount; i++)
                {
                    DONGLE_INFO pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)((UInt32)pt + i * Marshal.SizeOf(typeof(DONGLE_INFO))), typeof(DONGLE_INFO));

                    if (pDongleInfo.m_PID == ZBMasterPid)//只读取ZBMaster初始化过的加密锁
                    {
                        uint hDongle = 0;
                        RockeyArmHelper.OpenRockey(ref hDongle, i);
                        byte[] datas = RockeyArmHelper.ReadData(hDongle, 0, 4);
                        int systemType = BitConverter.ToInt32(datas, 0);

                        if (systemType == ZBSystemType)
                        {
                            byte[] objDatas = RockeyArmHelper.ReadData(hDongle, 4);

                            error = string.Empty;
                            RockeyArmHelper.CloseRockey(hDongle);
                            return new ReadCustomerInfoResult()
                            {
                                PDongleInfo = pDongleInfo,
                                ObjDatas = objDatas
                            };
                        }
                        else
                        {
                            RockeyArmHelper.CloseRockey(hDongle);
                        }
                    }
                }

                error = "没有找到针对此系统的加密锁!";
                return null;
            }
            catch (Exception ex)
            {
                error = ex.Message;
                return null;
            }
        }

        private void Init()
        {
            byte[] ZBMasterSeed = Encoding.Unicode.GetBytes("ZBMasterRockeySeed");

            ushort pCount = 0;
            var pt = RockeyArmHelper.EnumRockeyArm(out pCount);

            if (pCount > 1)
            {
                throw new Exception("加密锁不止一个!");
            }
            else if (pCount == 0)
            {
                throw new Exception("没有找到加密锁!");
            }
            else
            {
                DONGLE_INFO pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)(UInt32)pt, typeof(DONGLE_INFO));
                if (pDongleInfo.m_PID != DefaultPid)
                    throw new Exception("加密锁已被初始化!");
            }

            uint hDongle = 0;
            RockeyArmHelper.OpenRockey(ref hDongle, 0);
            RockeyArmHelper.VerifyPIN(hDongle, DefaultAdminPin);
            RockeyArmHelper.GenUniqueKey(hDongle, ZBMasterSeed);

            RockeyArmHelper.CloseRockey(hDongle);
        }

        private DONGLE_INFO WriteData(byte[] datas)
        {
            DONGLE_INFO pDongleInfo;

            ushort pCount = 0;
            IntPtr pt = RockeyArmHelper.EnumRockeyArm(out pCount);

            if (pCount > 1)
            {
                throw new Exception("加密锁不止一个!");
            }
            else if (pCount == 0)
            {
                throw new Exception("没有找到加密锁!");
            }
            else
            {
                pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)(UInt32)pt, typeof(DONGLE_INFO));
                if (pDongleInfo.m_PID != ZBMasterPid)
                    this.Init();
            }

            uint hDongle = 0;
            RockeyArmHelper.OpenRockey(ref hDongle, 0);
            RockeyArmHelper.VerifyPIN(hDongle, ZBMasterPin);
            RockeyArmHelper.WriteData(hDongle, datas);

            RockeyArmHelper.CloseRockey(hDongle);
            return pDongleInfo;
        }

        public string WriteCustomerInfo(int ZBSystemType, byte[] infoBytes, out string error)
        {
            //byte[] datas = SmartSerializeHelper.SerializeObject(obj, ZBPQRockeyArm.LoadBytes, false);
            List<byte> byteList = new List<byte>();
            byteList.AddRange(BitConverter.GetBytes(ZBSystemType));
            byteList.AddRange(BitConverter.GetBytes(infoBytes.Length));
            byteList.AddRange(infoBytes);

            try
            {
                DONGLE_INFO pDongleInfo = this.WriteData(byteList.ToArray());
                string hId = RockeyArmHelper.GetHIdStr(pDongleInfo);//回写设备Id

                error = string.Empty;
                return hId;
            }
            catch (Exception ex)
            {
                error = ex.Message;
                return string.Empty;
            }
        }
    }

    //public class ZBRockeyArmSafety : ZBSafetyBase<PQCustomerInfo>
    //{




    //    public override PQCustomerInfo ReadCustomerInfo(out string error)
    //    {
    //        try
    //        {
    //            ushort pCount = 0;
    //            var pt = RockeyArmHelper.EnumRockeyArm(out pCount);

    //            if (pCount > 1)
    //            {
    //                error = "加密锁不止一个!";
    //                return null; ;
    //            }
    //            else if (pCount == 0)
    //            {
    //                error = "没有找到加密锁!";
    //                return null; ;
    //            }

    //            DONGLE_INFO pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)((UInt32)pt), typeof(DONGLE_INFO));

    //            if (pDongleInfo.m_PID == ZBMasterPid)//只读取ZBMaster初始化过的加密锁
    //            {
    //                uint hDongle = 0;
    //                RockeyArmHelper.OpenRockey(ref hDongle, 0);
    //                byte[] datas = RockeyArmHelper.ReadData(hDongle, 0, 4);
    //                int systemType = BitConverter.ToInt32(datas, 0);

    //                byte[] pqDatas = RockeyArmHelper.ReadData(hDongle, 4);
    //                var ZBPQRockeyArm = SmartSerializeHelper.DeserializeObject<ZBPQRockeyArm>(pqDatas, ZBPQRockeyArm.LoadObj);

    //                RockeyArmHelper.CloseRockey(hDongle);

    //                error = string.Empty;
    //                return new PQCustomerInfo()
    //                {
    //                    CustomerKey = ZBPQRockeyArm.CustomerKey,
    //                    CustomerName = ZBPQRockeyArm.CustomerName,
    //                    ZBSystemType = systemType,
    //                    EmpowerDate = ZBPQRockeyArm.EmpowerDate,
    //                    HId = RockeyArmHelper.GetHIdStr(pDongleInfo)
    //                };
    //            }
    //            else
    //            {
    //                error = "加密锁没有初始化!";
    //                return null;
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            error = ex.Message;
    //            return null;
    //        }
    //    }

    //    private void Init()
    //    {
    //        byte[] ZBMasterSeed = Encoding.Unicode.GetBytes("ZBMasterRockeySeed");

    //        ushort pCount = 0;
    //        var pt = RockeyArmHelper.EnumRockeyArm(out pCount);

    //        if (pCount > 1)
    //        {
    //            throw new Exception("加密锁不止一个!");
    //        }
    //        else if (pCount == 0)
    //        {
    //            throw new Exception("没有找到加密锁!");
    //        }
    //        else
    //        {
    //            DONGLE_INFO pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)(UInt32)pt, typeof(DONGLE_INFO));
    //            if (pDongleInfo.m_PID != DefaultPid)
    //                throw new Exception("加密锁已被初始化!");
    //        }

    //        uint hDongle = 0;
    //        RockeyArmHelper.OpenRockey(ref hDongle, 0);
    //        RockeyArmHelper.VerifyPIN(hDongle, DefaultAdminPin);
    //        RockeyArmHelper.GenUniqueKey(hDongle, ZBMasterSeed);

    //        RockeyArmHelper.CloseRockey(hDongle);
    //    }

    //    private DONGLE_INFO WriteData(byte[] datas)
    //    {
    //        DONGLE_INFO pDongleInfo;

    //        ushort pCount = 0;
    //        IntPtr pt = RockeyArmHelper.EnumRockeyArm(out pCount);

    //        if (pCount > 1)
    //        {
    //            throw new Exception("加密锁不止一个!");
    //        }
    //        else if (pCount == 0)
    //        {
    //            throw new Exception("没有找到加密锁!");
    //        }
    //        else
    //        {
    //            pDongleInfo = (DONGLE_INFO)Marshal.PtrToStructure((IntPtr)(UInt32)pt, typeof(DONGLE_INFO));
    //            if (pDongleInfo.m_PID != ZBMasterPid)
    //                this.Init();
    //        }

    //        uint hDongle = 0;
    //        RockeyArmHelper.OpenRockey(ref hDongle, 0);
    //        RockeyArmHelper.VerifyPIN(hDongle, ZBMasterPin);
    //        RockeyArmHelper.WriteData(hDongle, datas);

    //        RockeyArmHelper.CloseRockey(hDongle);
    //        return pDongleInfo;
    //    }

    //    public override void WriteCustomerInfo(PQCustomerInfo info, out string error)
    //    {
    //        ZBPQRockeyArm obj = new ZBPQRockeyArm()
    //        {
    //            CustomerKey = info.CustomerKey,
    //            CustomerName = info.CustomerName,
    //            EmpowerDate = info.EmpowerDate,
    //        };
    //        byte[] datas = SmartSerializeHelper.SerializeObject(obj, ZBPQRockeyArm.LoadBytes, false);
    //        List<byte> byteList = new List<byte>();
    //        byteList.AddRange(BitConverter.GetBytes(info.ZBSystemType));
    //        byteList.AddRange(BitConverter.GetBytes(datas.Length));
    //        byteList.AddRange(datas);

    //        try
    //        {
    //            DONGLE_INFO pDongleInfo = this.WriteData(byteList.ToArray());
    //            info.HId = RockeyArmHelper.GetHIdStr(pDongleInfo);//回写设备Id

    //            error = string.Empty;
    //            return;
    //        }
    //        catch (Exception ex)
    //        {
    //            error = ex.Message;
    //            return;
    //        }
    //    }
    //}
}
