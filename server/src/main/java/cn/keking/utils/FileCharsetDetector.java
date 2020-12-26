package cn.keking.utils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.mozilla.intl.chardet.nsDetector;
import org.mozilla.intl.chardet.nsICharsetDetectionObserver;

/**
 * 文本文件编码探测工具类
 *
 * @author HWliao
 * @date 2017-12-24
 */
public class FileCharsetDetector {

  /**
   * 传入一个文件(File)对象，检查文件编码
   *
   * @param file File对象实例
   * @return 文件编码，若无，则返回null
   * @throws FileNotFoundException
   * @throws IOException
   */
  public static Observer guessFileEncoding(File file)
      throws FileNotFoundException, IOException {
    return guessFileEncoding(file, new nsDetector());
  }

  /**
   * <pre>
   * 获取文件的编码
   * @param file
   *            File对象实例
   * @param languageHint
   *            语言提示区域代码 @see #nsPSMDetector ,取值如下：
   *             1 : Japanese
   *             2 : Chinese
   *             3 : Simplified Chinese
   *             4 : Traditional Chinese
   *             5 : Korean
   *             6 : Dont know(default)
   * </pre>
   *
   * @return 文件编码，eg：UTF-8,GBK,GB2312形式(不确定的时候，返回可能的字符编码序列)；若无，则返回null
   * @throws FileNotFoundException
   * @throws IOException
   */
  public static Observer guessFileEncoding(File file, int languageHint)
      throws FileNotFoundException, IOException {
    return guessFileEncoding(file, new nsDetector(languageHint));
  }

  /**
   * 获取文件的编码
   *
   * @param file
   * @param det
   * @return
   * @throws FileNotFoundException
   * @throws IOException
   */
  private static Observer guessFileEncoding(File file, nsDetector det)
      throws FileNotFoundException, IOException {
    // new Observer
    Observer observer = new Observer();
    // set Observer
    // The Notify() will be called when a matching charset is found.
    det.Init(observer);

    BufferedInputStream imp = new BufferedInputStream(new FileInputStream(
        file));
    byte[] buf = new byte[1024];
    int len;
    boolean done = false;
    boolean isAscii = false;

    while ((len = imp.read(buf, 0, buf.length)) != -1) {
      // Check if the stream is only ascii.
      isAscii = det.isAscii(buf, len);
      if (isAscii) {
        break;
      }
      // DoIt if non-ascii and not done yet.
      done = det.DoIt(buf, len, false);
      if (done) {
        break;
      }
    }
    imp.close();
    det.DataEnd();

    if (isAscii) {
      observer.encoding = "ASCII";
      observer.found = true;
    }

    if (!observer.isFound()) {
      String[] prob = det.getProbableCharsets();
      // // 这里将可能的字符集组合起来返回
      // for (int i = 0; i < prob.length; i++) {
      // if (i == 0) {
      // encoding = prob[i];
      // } else {
      // encoding += "," + prob[i];
      // }
      // }
      if (prob.length > 0) {
        // 在没有发现情况下,去第一个可能的编码
        observer.encoding = prob[0];
      } else {
        observer.encoding = null;
      }
    }
    return observer;
  }

  /**
   * @author liaohongwei
   * @Description: 文件字符编码观察者, 但判断出字符编码时候调用
   * @date 2016年6月20日 下午2:27:06
   */
  public static class Observer implements nsICharsetDetectionObserver {

    /**
     * @Fields encoding : 字符编码
     */
    private String encoding = null;
    /**
     * @Fields found : 是否找到字符集
     */
    private boolean found = false;

    @Override
    public void Notify(String charset) {
      this.encoding = charset;
      this.found = true;
    }

    public String getEncoding() {
      return encoding;
    }

    public boolean isFound() {
      return found;
    }

    @Override
    public String toString() {
      return "Observer [encoding=" + encoding + ", found=" + found + "]";
    }
  }

}
