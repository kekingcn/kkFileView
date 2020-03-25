package cn.keking.utils;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.StringUtils;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

abstract class FilenameGetter {

    final static String filenameJoint = "@";

    abstract String get(URL url, HashMap<String, String> queryMap);
}

/**
 * 从 filename 参数中获取
 */
class GetterFromFilename extends FilenameGetter {
    String get(URL url, HashMap<String, String> queryMap) {
        String filename = queryMap.get("fullfilename");
        if (StringUtils.isNotEmpty(filename)) {
            return UrlUtils.digest(url, queryMap) + filenameJoint + filename;
        }
        return null;
    }
}

/**
 * 从url路径中获取
 */
class GetterFromRawUrl extends FilenameGetter {
    String get(URL urlObj, HashMap<String, String> queryMap) {
        // 因为url的参数中可能会存在/的情况，所以直接url.lastIndexOf("/")会有问题
        // 所以先从？处将url截断，然后运用url.lastIndexOf("/")获取文件名
        String url = urlObj.toString();
        String noQueryUrl = url.substring(0, url.indexOf("?") != -1 ? url.indexOf("?"): url.length());
        String filename = noQueryUrl.substring(noQueryUrl.lastIndexOf("/") + 1);
        return StringUtils.isNotEmpty(filename)
                ? UrlUtils.digest(urlObj, queryMap) + filenameJoint + filename : null;
    }
}

public class UrlUtils {

    private static ArrayList<FilenameGetter> filenameGetters;
    static {
        filenameGetters = new ArrayList<>();
        filenameGetters.add(new GetterFromFilename());
        filenameGetters.add(new GetterFromRawUrl());
    }

    public static String getFilenameFromUrl(String url) {
        String filename = null;
        URL urlObj;
        try {
            urlObj = new URL(url);
        } catch (MalformedURLException e) {
            return null;
        }
        HashMap<String, String> queryMap = getQueryMap(url);
        for (FilenameGetter getter : filenameGetters) {
            filename = getter.get(urlObj, queryMap);
            if (StringUtils.isNotEmpty(filename)) {
                return filename;
            }
        }
        return filename;
    }

    public static HashMap<String, String> getQueryMap(String url) {
        HashMap<String, String> mapRequest = new HashMap<>();
        String strUrlParam = getQueryString(url);
        if (strUrlParam == null) {
            return mapRequest;
        }
        //每个键值为一组
        String[] arrSplit=strUrlParam.split("[&]");
        for(String strSplit:arrSplit) {
            String[] arrSplitEqual= strSplit.split("[=]");
            //解析出键值
            if(arrSplitEqual.length > 1) {
                //正确解析
                mapRequest.put(arrSplitEqual[0], arrSplitEqual[1]);
            } else if (!arrSplitEqual[0].equals("")) {
                //只有参数没有值，不加入
                mapRequest.put(arrSplitEqual[0], "");
            }
        }
        return mapRequest;
    }

    public static String getQueryString(String strURL) {
        String queryStr = null;

        try {
            queryStr = (new URL(strURL)).getQuery();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }

        return queryStr;
    }

    /**
     * URL签名：排序后取md5
     * @param url
     * @return
     */
    public static String digest(String url) {
        return DigestUtils.md5Hex(sortURL(url));
    }

    public static String digest(URL url) {
        return DigestUtils.md5Hex(sortURL(url));
    }

    public static String digest(URL url, HashMap<String, String> queryMap) {
        return DigestUtils.md5Hex(sortURL(url, queryMap));
    }

    /**
     * 将URL中的请求参数按key排序后重组
     * @param url
     * @return
     */
    public static String sortURL(String url) {
        try {
            URL urlObj = new URL(url);
            return sortQuery(urlObj, null);
        } catch (MalformedURLException e) {
            return url;
        }
    }

    public static String sortURL(URL url) {
        return sortQuery(url, null);
    }

    public static String sortURL(URL url, HashMap<String, String> queryMap) {
        return sortQuery(url, queryMap);
    }

    private static String sortQuery(URL url, HashMap<String, String> queryMap) {
        if (queryMap == null) {
            queryMap = getQueryMap(url.toString());
        }
        Object[] keys = queryMap.keySet().toArray();
        Arrays.sort(keys);
        String baseUrl = url.getProtocol() + "://" + url.getHost() + url.getPath();
        if (keys.length > 0) {
            baseUrl += "?";
        }
        for (Object k: keys) {
            baseUrl += (String)k + '=' + queryMap.get(k) + "&";
        }

        return baseUrl;
    }
}
