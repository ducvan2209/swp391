package controller.dal;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private DBConnection() {
    }

    public static Connection getJDBCConnection() throws SQLException {
        return DBContext.getConnection();
    }

    public static Connection getConnection() throws SQLException {
        return DBContext.getConnection();
    }

    public static boolean testConnection() {
        return DBContext.testConnection();
    }

    public static void main(String[] args) {
        System.out.println(testConnection() ? "Check: Connection created successfully." : "Check: Connection not created.");
    }
}
