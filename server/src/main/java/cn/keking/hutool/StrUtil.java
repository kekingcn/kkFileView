package cn.keking.hutool;

import java.nio.charset.Charset;

/**
 * 字符串工具类
 * 
 * @author xiaoleilu
 *
 */
public class StrUtil {

	public static final String EMPTY = "";

	/**
	 * 是否空白符<br>
	 * 空白符包括空格、制表符、全角空格和不间断空格<br>
	 *
	 * @see Character#isWhitespace(int)
	 * @see Character#isSpaceChar(int)
	 * @param c 字符
	 * @return 是否空白符
	 * @since 4.0.10
	 */
	public static boolean isBlankChar(int c) {
		return Character.isWhitespace(c) || Character.isSpaceChar(c) || c == '\ufeff' || c == '\u202a';
	}

	/**
	 * 是否空白符<br>
	 * 空白符包括空格、制表符、全角空格和不间断空格<br>
	 *
	 * @param c 字符
	 * @return 是否空白符
	 * @see Character#isWhitespace(int)
	 * @see Character#isSpaceChar(int)
	 * @since 4.0.10
	 */
	public static boolean isBlankChar(char c) {
		return isBlankChar((int) c);
	}

	/**
	 * 字符串是否为空白 空白的定义如下： <br>
	 * 1、为null <br>
	 * 2、为不可见字符（如空格）<br>
	 * 3、""<br>
	 *
	 * @param str 被检测的字符串
	 * @return 是否为空
	 */
	public static boolean isBlank(CharSequence str) {
		int length;

		if ((str == null) || ((length = str.length()) == 0)) {
			return true;
		}

		for (int i = 0; i < length; i++) {
			// 只要有一个非空字符即为非空字符串
			if (false == isBlankChar(str.charAt(i))) {
				return false;
			}
		}

		return true;
	}

	/**
	 * 字符串是否为空，空的定义如下:<br>
	 * 1、为null <br>
	 * 2、为""<br>
	 * 
	 * @param str 被检测的字符串
	 * @return 是否为空
	 */
	public static boolean isEmpty(CharSequence str) {
		return str == null || str.length() == 0;
	}

	/**
	 * 编码字符串
	 *
	 * @param str 字符串
	 * @param charset 字符集，如果此字段为空，则解码的结果取决于平台
	 * @return 编码后的字节码
	 */
	public static byte[] bytes(CharSequence str, Charset charset) {
		if (str == null) {
			return null;
		}

		if (null == charset) {
			return str.toString().getBytes();
		}
		return str.toString().getBytes(charset);
	}

	/**
	 * {@link CharSequence} 转为字符串，null安全
	 *
	 * @param cs {@link CharSequence}
	 * @return 字符串
	 */
	public static String str(CharSequence cs) {
		return null == cs ? null : cs.toString();
	}

	/**
	 * 解码字节码
	 *
	 * @param data 字符串
	 * @param charset 字符集，如果此字段为空，则解码的结果取决于平台
	 * @return 解码后的字符串
	 */
	public static String str(byte[] data, Charset charset) {
		if (data == null) {
			return null;
		}

		if (null == charset) {
			return new String(data);
		}
		return new String(data, charset);
	}

	/**
	 * 改进JDK subString<br>
	 * index从0开始计算，最后一个字符为-1<br>
	 * 如果from和to位置一样，返回 "" <br>
	 * 如果from或to为负数，则按照length从后向前数位置，如果绝对值大于字符串长度，则from归到0，to归到length<br>
	 * 如果经过修正的index中from大于to，则互换from和to example: <br>
	 * abcdefgh 2 3 =》 c <br>
	 * abcdefgh 2 -3 =》 cde <br>
	 *
	 * @param str String
	 * @param fromIndex 开始的index（包括）
	 * @param toIndex 结束的index（不包括）
	 * @return 字串
	 */
	public static String sub(CharSequence str, int fromIndex, int toIndex) {
		if (isEmpty(str)) {
			return str(str);
		}
		int len = str.length();

		if (fromIndex < 0) {
			fromIndex = len + fromIndex;
			if (fromIndex < 0) {
				fromIndex = 0;
			}
		} else if (fromIndex > len) {
			fromIndex = len;
		}

		if (toIndex < 0) {
			toIndex = len + toIndex;
			if (toIndex < 0) {
				toIndex = len;
			}
		} else if (toIndex > len) {
			toIndex = len;
		}

		if (toIndex < fromIndex) {
			int tmp = fromIndex;
			fromIndex = toIndex;
			toIndex = tmp;
		}

		if (fromIndex == toIndex) {
			return EMPTY;
		}

		return str.toString().substring(fromIndex, toIndex);
	}

	/**
	 * 切割指定位置之前部分的字符串
	 *
	 * @param string 字符串
	 * @param toIndex 切割到的位置（不包括）
	 * @return 切割后的剩余的前半部分字符串
	 */
	public static String subPre(CharSequence string, int toIndex) {
		return sub(string, 0, toIndex);
	}

	/**
	 * 切割指定位置之后部分的字符串
	 *
	 * @param string 字符串
	 * @param fromIndex 切割开始的位置（包括）
	 * @return 切割后后剩余的后半部分字符串
	 */
	public static String subSuf(CharSequence string, int fromIndex) {
		if (isEmpty(string)) {
			return null;
		}
		return sub(string, fromIndex, string.length());
	}

	/**
	 * 指定范围内查找指定字符
	 *
	 * @param str 字符串
	 * @param searchChar 被查找的字符
	 * @param start 起始位置，如果小于0，从0开始查找
	 * @param end 终止位置，如果超过str.length()则默认查找到字符串末尾
	 * @return 位置
	 */
	public static int indexOf(final CharSequence str, char searchChar, int start, int end) {
		final int len = str.length();
		if (start < 0 || start > len) {
			start = 0;
		}
		if (end > len || end < 0) {
			end = len;
		}
		for (int i = start; i < end; i++) {
			if (str.charAt(i) == searchChar) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * 指定范围内查找指定字符
	 *
	 * @param str 字符串
	 * @param searchChar 被查找的字符
	 * @param start 起始位置，如果小于0，从0开始查找
	 * @return 位置
	 */
	public static int indexOf(final CharSequence str, char searchChar, int start) {
		if (str instanceof String) {
			return ((String) str).indexOf(searchChar, start);
		} else {
			return indexOf(str, searchChar, start, -1);
		}
	}

	/**
	 * 指定范围内查找指定字符
	 *
	 * @param str 字符串
	 * @param searchChar 被查找的字符
	 * @return 位置
	 */
	public static int indexOf(final CharSequence str, char searchChar) {
		return indexOf(str, searchChar, 0);
	}

	/**
	 * 如果字符串是<code>null</code>，则返回指定默认字符串，否则返回字符串本身。
	 *
	 * <pre>
	 * nullToDefault(null, &quot;default&quot;)  = &quot;default&quot;
	 * nullToDefault(&quot;&quot;, &quot;default&quot;)    = &quot;&quot;
	 * nullToDefault(&quot;  &quot;, &quot;default&quot;)  = &quot;  &quot;
	 * nullToDefault(&quot;bat&quot;, &quot;default&quot;) = &quot;bat&quot;
	 * </pre>
	 *
	 * @param str 要转换的字符串
	 * @param defaultStr 默认字符串
	 *
	 * @return 字符串本身或指定的默认字符串
	 */
	public static String nullToDefault(CharSequence str, String defaultStr) {
		return (str == null) ? defaultStr : str.toString();
	}

	/**
	 * 当给定字符串为null时，转换为Empty
	 *
	 * @param str 被转换的字符串
	 * @return 转换后的字符串
	 */
	public static String nullToEmpty(CharSequence str) {
		return nullToDefault(str, EMPTY);
	}
}
