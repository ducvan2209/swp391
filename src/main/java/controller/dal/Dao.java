package controller.dal;

import java.sql.Connection;
import java.sql.SQLException;

public abstract class Dao {
    protected Connection getConnection() throws SQLException {
        return DBContext.getConnection();
    }
}
