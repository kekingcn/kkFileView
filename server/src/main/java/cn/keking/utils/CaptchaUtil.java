package cn.keking.utils;

import org.springframework.util.Assert;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.Random;

public class CaptchaUtil {

    public static final String captcha_code = "captchaCode";
    public static final String captcha_generate_time = "captchaTime";

    private static final int width = 100;// 定义图片的width
    private static final int height = 30;// 定义图片的height
    private static final int codeLength = 4;// 定义图片上显示验证码的个数
    private static final int xx = 18;
    private static final int fontHeight = 28;
    private static final int codeY = 27;
    private static final char[] codeSequence = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', '2', '3', '4', '5', '6', '7', '8', '9'};

    /**
     * 指定验证码、生成验证码图片。
     * @param captchaCode 验证码
     * @return 验证码图片
     */
    public static BufferedImage generateCaptchaPic(final String captchaCode) {
        Assert.notNull(captchaCode, "captchaCode must not be null");
        // 定义图像buffer
        BufferedImage buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics gd = buffImg.getGraphics();
        Random random = new Random();
        // 将图像填充为白色
        gd.setColor(Color.WHITE);
        gd.fillRect(0, 0, width, height);
        Font font = new Font("Times New Roman", Font.BOLD, fontHeight);
        gd.setFont(font);
        // 画边框。
        gd.setColor(Color.BLACK);
        gd.drawRect(0, 0, width - 1, height - 1);

        // 随机产生40条干扰线，使图象中的认证码不易被其它程序探测到。
        gd.setColor(Color.BLACK);
        for (int i = 0; i < 30; i++) {
            int x = random.nextInt(width);
            int y = random.nextInt(height);
            int xl = random.nextInt(12);
            int yl = random.nextInt(12);
            gd.drawLine(x, y, x + xl, y + yl);
        }
        // randomCode用于保存随机产生的验证码，以便用户登录后进行验证。
        int red, green, blue;
        // 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
        red = random.nextInt(255);
        green = random.nextInt(255);
        blue = random.nextInt(255);
        // 用随机产生的颜色将验证码绘制到图像中。
        gd.setColor(new Color(red, green, blue));
        gd.drawString(captchaCode, 18, codeY);
        return buffImg;
    }

    /**
     * 生成随机字符串。
     * @return 字符串
     */
    public static String generateCaptchaCode() {
        Random random = new Random();
        StringBuilder randomCode = new StringBuilder();
        for (int i = 0; i < codeLength; i++) {
            randomCode.append(codeSequence[random.nextInt(52)]);
        }
        return randomCode.toString();
    }
}
