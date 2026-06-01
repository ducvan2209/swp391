package dal;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBContext {

    private static final String URL;
    private static final String USER;
    private static final String PASS;

    static {
        Properties props = new Properties();
        try (InputStream input = DBContext.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input != null) {
                props.load(input);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        URL = props.getProperty("db.url",
                "jdbc:mysql://localhost:3306/hrm?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        USER = props.getProperty("db.user", "root");
        PASS = props.getProperty("db.password", "mysql");
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException e) {
            throw new SQLException(e);
        }
    }
}
