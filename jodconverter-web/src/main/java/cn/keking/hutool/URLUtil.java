package cn.keking.hutool;

import java.nio.charset.StandardCharsets;

/**
 * 统一资源定位符相关工具类
 *
 * @author xiaoleilu
 *
 */
public class URLUtil {

	/**
	 * 标准化URL字符串，包括：
	 *
	 * <pre>
	 * 1. 多个/替换为一个
	 * </pre>
	 *
	 * @param url URL字符串
	 * @return 标准化后的URL字符串
	 */
	public static String normalize(String url) {
		return normalize(url, false, false);
	}

	/**
	 * 标准化URL字符串，包括：
	 *
	 * <pre>
	 * 1. 多个/替换为一个
	 * </pre>
	 *
	 * @param url URL字符串
	 * @param isEncodeBody 是否对URL中body部分的中文和特殊字符做转义（不包括http:和/）
	 * @param isEncodeParam 是否对URL中参数部分的中文和特殊字符做转义
	 * @return 标准化后的URL字符串
	 * @since 4.4.1
	 */
	public static String normalize(String url, boolean isEncodeBody, boolean isEncodeParam) {
		if (StrUtil.isBlank(url)) {
			return url;
		}
		final int sepIndex = url.indexOf("://");
		String pre;
		String body;
		if (sepIndex > 0) {
			pre = StrUtil.subPre(url, sepIndex + 3);
			body = StrUtil.subSuf(url, sepIndex + 3);
		} else {
			pre = "http://";
			body = url;
		}

		final int paramsSepIndex = StrUtil.indexOf(body, '?');
		String params = null;
		if (paramsSepIndex > 0) {
			params = StrUtil.subSuf(body, paramsSepIndex + 1);
			body = StrUtil.subPre(body, paramsSepIndex);
		}

		// 去除开头的\或者/
		body = body.replaceAll("^[\\\\/]+", StrUtil.EMPTY);
		// 替换多个\或/为单个/
		body = body.replace("\\", "/").replaceAll("//+", "/");
		if (isEncodeBody) {
			body = URLEncoder.DEFAULT.encode(body, StandardCharsets.UTF_8);
			if (params != null) {
				params = "?" + URLEncoder.DEFAULT.encode(params, StandardCharsets.UTF_8);
			}
		}
		return pre + body + StrUtil.nullToEmpty(params);
	}
}