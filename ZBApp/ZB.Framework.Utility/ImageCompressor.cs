using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace ZB.Framework.Utility
{
    public class ImageCompressor
    {
        //无论是原图的高度或者宽度大于指定值的，都压缩成这个指定值，另外一个就按这个比例缩小.
        public const double MAXSIZE = 320;

        public static System.Drawing.Image GetThumbnail(System.Drawing.Image originalImage)
        {
            double oW = originalImage.Width;
            double oH = originalImage.Height;

            double rate = oW > oH ? MAXSIZE / oW : MAXSIZE / oH; //宽度较大压缩宽度,高度较大压缩高度.

            return GetThumbnail(originalImage, (int)(oW * rate), (int)(oH * rate));
        }

        public static byte[] GetThumbnail(byte[] imgBytes)
        {
            //byte to image
            Image img = Image.FromStream(new MemoryStream(imgBytes));

            //压缩
            img = GetThumbnail(img);

            //image to byte.
            MemoryStream ms = new MemoryStream();
            img.Save(ms, ImageFormat.Jpeg);

            return ms.ToArray();
        }

        public static Image ByteToThumbnailImage(byte[] imgBytes)
        {
            Image img = Image.FromStream(new MemoryStream(imgBytes));
            return GetThumbnail(img);
        }

        /// <summary>
        /// 为图片生成缩略图  
        /// </summary>
        /// <param name="phyPath">原图片的路径</param>
        /// <param name="width">缩略图宽</param>
        /// <param name="height">缩略图高</param>
        /// <returns></returns>
        public static System.Drawing.Image GetThumbnail(System.Drawing.Image image, int width, int height)
        {
            Bitmap bmp = new Bitmap(width, height);
            //从Bitmap创建一个System.Drawing.Graphics
            System.Drawing.Graphics gr = System.Drawing.Graphics.FromImage(bmp);
            //设置 
            gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            //下面这个也设成高质量
            gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
            //下面这个设成High
            gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            //把原始图像绘制成上面所设置宽高的缩小图
            System.Drawing.Rectangle rectDestination = new System.Drawing.Rectangle(0, 0, width, height);

            gr.DrawImage(image, rectDestination, 0, 0, image.Width, image.Height, GraphicsUnit.Pixel);
            return bmp;
        }

    }
}