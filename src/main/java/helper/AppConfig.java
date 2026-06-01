package helper;

import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {

    private static final Properties PROPS = new Properties();

    static {
        try (InputStream input = AppConfig.class.getClassLoader()
                .getResourceAsStream("app.properties")) {
            if (input != null) {
                PROPS.load(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private AppConfig() {
    }

    public static String get(String key, String defaultValue) {
        String value = PROPS.getProperty(key);
        return value == null || value.isBlank() ? defaultValue : value.trim();
    }

    public static String getBaseUrl() {
        return get("app.base.url", "http://localhost:8080/swp391");
    }
}
