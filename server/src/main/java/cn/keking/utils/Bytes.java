package cn.keking.utils;

import java.io.IOException;

public class Bytes {

    @FunctionalInterface
    public interface BytesReader {

        int read(byte[] buffer) throws IOException;
    }

    public static byte[] read(int bufferSize, BytesReader reader) throws IOException {
        byte[] content = new byte[0];
        byte[] buffer = new byte[bufferSize];
        int size;
        do {
            size = reader.read(buffer);
            if (size > 0) {
                byte[] newContent = new byte[content.length + size];
                System.arraycopy(content, 0, newContent, 0, content.length);
                System.arraycopy(buffer, 0, newContent, content.length, size);
                content = newContent;
            }
        } while (size != -1);
        return content;
    }
}
