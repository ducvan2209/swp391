package helper;

import java.io.InputStream;
import java.util.Properties;

public final class MessageUtil {

    private static final Properties MESSAGES = new Properties();

    static {
        try (InputStream input = MessageUtil.class.getClassLoader()
                .getResourceAsStream("messages.properties")) {
            if (input != null) {
                MESSAGES.load(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private MessageUtil() {
    }

    public static String get(String code) {
        return MESSAGES.getProperty(code, code);
    }
}
