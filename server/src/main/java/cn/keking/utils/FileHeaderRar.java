package cn.keking.utils;

public class FileHeaderRar {

  private String fileNameW;
  private Boolean isDirectory;

  public FileHeaderRar(String fileNameW, Boolean isDirectory) {
    this.fileNameW = fileNameW;
    this.isDirectory = isDirectory;
  }

  public String getFileNameW() {
    return fileNameW;
  }

  public void setFileNameW(String fileNameW) {
    this.fileNameW = fileNameW;
  }

  public Boolean getDirectory() {
    return isDirectory;
  }

  public void setDirectory(Boolean directory) {
    isDirectory = directory;
  }
}
