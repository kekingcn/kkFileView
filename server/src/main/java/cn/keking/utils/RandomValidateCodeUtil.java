package cn.keking.utils;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class RandomValidateCodeUtil {

    private static final int width = 100;// 定义图片的width
    private static final int height = 30;// 定义图片的height
    private static final int codeCount = 4;// 定义图片上显示验证码的个数
    private static final int xx = 18;
    private static final int fontHeight = 28;
    private static final int codeY = 27;
    private static final char[] codeSequence = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R','T', 'U', 'V', 'W', 'X', 'Y', 'Z',
            'a','b','c','d','e','f','g','h','j','k','m','n','p','q','r','s','t','u','v','w','x','y', '2', '3', '4','5', '6', '7', '8', '9' };

    /**
     * 生成一个map集合
     * code为生成的验证码
     * codePic为生成的验证码BufferedImage对象
     */
    public static Map<String,Object> generateCodeAndPic(String ip, String sessionCode, int lx) {
        // 定义图像buffer
        BufferedImage buffImg = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        // Graphics2D gd = buffImg.createGraphics();
        // Graphics2D gd = (Graphics2D) buffImg.getGraphics();
        Graphics gd = buffImg.getGraphics();
        // 创建一个随机数生成器类
        Random random = new Random();
        // 将图像填充为白色
        gd.setColor(Color.WHITE);
        gd.fillRect(0, 0, width, height);

        // 创建字体，字体的大小应该根据图片的高度来定。
        Font font = new Font("Times New Roman", Font.BOLD, fontHeight);
        // 设置字体。
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
        StringBuffer randomCode = new StringBuffer();
        Map<String,Object> map  = new HashMap<>();
        // randomCode用于保存随机产生的验证码，以便用户登录后进行验证。
        int red, green, blue;
        if (lx ==1){
            // 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
            red = random.nextInt(255);
            green = random.nextInt(255);
            blue = random.nextInt(255);
            // 用随机产生的颜色将验证码绘制到图像中。
            gd.setColor(new Color(red, green, blue));
            gd.drawString(sessionCode, 18, codeY);
            randomCode.append(sessionCode);
        }else {
            // 随机产生codeCount数字的验证码。
            for (int i = 0; i < codeCount; i++) {
                // 得到随机产生的验证码数字。
                String code = String.valueOf(codeSequence[random.nextInt(52)]);
                // 产生随机的颜色分量来构造颜色值，这样输出的每位数字的颜色值都将不同。
                red = random.nextInt(255);
                green = random.nextInt(255);
                blue = random.nextInt(255);
                // 用随机产生的颜色将验证码绘制到图像中。
                gd.setColor(new Color(red, green, blue));
                gd.drawString(code, (i + 1) * xx, codeY);
                // 将产生的四个随机数组合在一起。
                randomCode.append(code);
            }
        }
        //存放验证码
        map.put("code", randomCode);
        //存放生成的验证码BufferedImage对象
        map.put("codePic", buffImg);
        return map;
    }
}
