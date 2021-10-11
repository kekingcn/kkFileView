package cn.keking.utils;

import okhttp3.Headers;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import java.io.IOException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

/**
 * @Author: Zy
 * @Date: 2021/10/9 15:48
 * okhttpclient工具类
 */
public class OkHttpClientUtils {
    private static OkHttpClient client = null;

    public static OkHttpClient instance() {
        if(client==null){
            client = new OkHttpClient.Builder()
                    .connectTimeout(30, TimeUnit.SECONDS)
                    .readTimeout(30, TimeUnit.SECONDS)
                    .callTimeout(30, TimeUnit.SECONDS)
                    .writeTimeout(30, TimeUnit.SECONDS)
                    .build();
        }
        return client;
    }

    /**
     * 发送get请求,传入headers
     * @author Zy
     * @date 2021/10/9
     * @param url
     * @param headers
     * @return okhttp3.Response
     */
    public static Response executeGet(URL url, Headers headers) throws IOException {
        Request request = new Request.Builder()
                .get()
                .url(url)
                .headers(headers)
                .build();
        return instance().newCall(request).execute();
    }

}
