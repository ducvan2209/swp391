package controller.dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/hrm_db"
            + "?useUnicode=true"
            + "&characterEncoding=UTF-8"
            + "&serverTimezone=Asia/Ho_Chi_Minh"
            + "&useSSL=false"
            + "&allowPublicKeyRetrieval=true";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "12345";

    private static final String URL = readConfig("HRM_DB_URL", DEFAULT_URL);
    private static final String USER = readConfig("HRM_DB_USER", DEFAULT_USER);
    private static final String PASSWORD = readConfig("HRM_DB_PASSWORD", DEFAULT_PASSWORD);

    private DBContext() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException exception) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC driver was not found.", exception);
            throw new SQLException("MySQL JDBC driver was not found.", exception);
        } catch (SQLException exception) {
            LOGGER.log(Level.SEVERE, "Could not connect to MySQL database: " + URL, exception);
            throw exception;
        }
    }

    public static boolean testConnection() {
        try (Connection ignored = getConnection()) {
            return true;
        } catch (SQLException exception) {
            LOGGER.log(Level.SEVERE, "Database connection test failed.", exception);
            return false;
        }
    }

    private static String readConfig(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }
}
