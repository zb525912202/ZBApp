using Emgu.CV;
using Emgu.CV.Structure;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;

namespace ZB.Framework.Utility
{
    public class FaceDetector
    {
        private string dataFilePath;
        public FaceDetector(string filePath)
        {
            this.dataFilePath = filePath;
        }

        public Rectangle[] GetFaces(Bitmap bitmap)
        {
            //如果支持用显卡,则用显卡运算
            CvInvoke.UseOpenCL = CvInvoke.HaveOpenCLCompatibleGpuDevice;

            //构建级联分类器,利用已经训练好的数据,识别人脸
            CascadeClassifier detector = new CascadeClassifier(this.dataFilePath);

            //加载要识别的图片
            var img = new Image<Bgr, byte>(bitmap);
            var img2 = new Image<Gray, byte>(img.ToBitmap());

            try
            {
                //把图片从彩色转灰度
                CvInvoke.CvtColor(img, img2, Emgu.CV.CvEnum.ColorConversion.Bgr2Gray);

                //亮度增强
                CvInvoke.EqualizeHist(img2, img2);

                //在这一步就已经识别出来了,返回的是人脸所在的位置和大小
                //var facesDetected = detector.DetectMultiScale(img2);
                Rectangle[] facesDetected = detector.DetectMultiScale(img2, 1.1, 3, new Size(20, 20));

                //循环把人脸部分切出来并保存
                //int count = 0;
                //var b = img.ToBitmap();
                //释放资源退出
                //b.Dispose();

                return facesDetected;

            }
            catch (System.AccessViolationException ex)
            {
                return null;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);

                return null;
            }
            finally
            {
                img.Dispose();
                img2.Dispose();
                detector.Dispose();
                detector = null;
            }
        }

    }
}
