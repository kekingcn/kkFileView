package cn.keking;

import org.springframework.boot.builder.SpringApplicationBuilder;

/** Lets tests outside the cn.keking package build the application exactly as main() does. */
public final class ServerMainTestAccess {

    private ServerMainTestAccess() {
    }

    public static SpringApplicationBuilder applicationBuilder() {
        return ServerMain.applicationBuilder();
    }
}
