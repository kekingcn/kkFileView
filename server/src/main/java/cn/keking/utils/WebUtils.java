package cn.keking.utils;

import io.mola.galimatias.GalimatiasParseException;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * @author : kl
 * create : 2020-12-27 1:30 上午
 **/
public class WebUtils {

    /**
     * 获取标准的URL
     * @param urlStr url
     * @return 标准的URL
     */
    public static URL normalizedURL(String urlStr) throws GalimatiasParseException, MalformedURLException {
        return io.mola.galimatias.URL.parse(urlStr).toJavaURL();
    }

    /**
     * 获取url中的参数
     *
     * @param url  url
     * @param name 参数名
     * @return 参数值
     */
    public static String getUrlParameterReg(String url, String name) {
        Map<String, String> mapRequest = new HashMap<>();
        String strUrlParam = truncateUrlPage(url);
        if (strUrlParam == null) {
            return "";
        }
        //每个键值为一组
        String[] arrSplit = strUrlParam.split("[&]");
        for (String strSplit : arrSplit) {
            String[] arrSplitEqual = strSplit.split("[=]");
            //解析出键值
            if (arrSplitEqual.length > 1) {
                //正确解析
                mapRequest.put(arrSplitEqual[0], arrSplitEqual[1]);
            } else if (!arrSplitEqual[0].equals("")) {
                //只有参数没有值，不加入
                mapRequest.put(arrSplitEqual[0], "");
            }
        }
        return mapRequest.get(name);
    }


    /**
     * 去掉url中的路径，留下请求参数部分
     *
     * @param strURL url地址
     * @return url请求参数部分
     */
    private static String truncateUrlPage(String strURL) {
        String strAllParam = null;
        strURL = strURL.trim();
        String[] arrSplit = strURL.split("[?]");
        if (strURL.length() > 1) {
            if (arrSplit.length > 1) {
                if (arrSplit[1] != null) {
                    strAllParam = arrSplit[1];
                }
            }
        }
        return strAllParam;
    }

    /**
     * 从url中剥离出文件名
     *
     * @param url 格式如：http://www.com.cn/20171113164107_月度绩效表模板(新).xls?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=I D1NOFtAJSPT16E6imv6JWuq0k=
     * @return 文件名
     */
    public static String getFileNameFromURL(String url) {
        if (url.toLowerCase().startsWith("file:")) {
            try {
                URL urlObj = new URL(url);
                url = urlObj.getPath().substring(1);
            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }
        // 因为url的参数中可能会存在/的情况，所以直接url.lastIndexOf("/")会有问题
        // 所以先从？处将url截断，然后运用url.lastIndexOf("/")获取文件名
        String noQueryUrl = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        return noQueryUrl.substring(noQueryUrl.lastIndexOf("/") + 1);
    }


    /**
     * 从url中获取文件后缀
     *
     * @param url url
     * @return 文件后缀
     */
    public static String suffixFromUrl(String url) {
        String nonPramStr = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        return KkFileUtils.suffixFromFileName(fileName);
    }

    /**
     * 对url中的文件名进行UTF-8编码
     *
     * @param url url
     * @return 文件名编码后的url
     */
    public static String encodeUrlFileName(String url) {
        String noQueryUrl = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        int fileNameStartIndex = noQueryUrl.lastIndexOf('/') + 1;
        int fileNameEndIndex = noQueryUrl.lastIndexOf('.');
        String encodedFileName;
        try {
            encodedFileName = URLEncoder.encode(noQueryUrl.substring(fileNameStartIndex, fileNameEndIndex), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return null;
        }
        return url.substring(0, fileNameStartIndex) + encodedFileName + url.substring(fileNameEndIndex);
    }
}
