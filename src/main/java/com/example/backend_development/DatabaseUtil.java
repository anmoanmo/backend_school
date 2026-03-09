package com.example.backend_development;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public final class DatabaseUtil {
    private static final Object INIT_LOCK = new Object();
    private static volatile boolean initialized = false;
    private static final String CONFIG_RESOURCE = "/db/mysql.local.properties";
    private static final DbConfig DB_CONFIG = loadDbConfig();

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL driver not found", e);
        }
    }

    private DatabaseUtil() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_CONFIG.url(), DB_CONFIG.user(), DB_CONFIG.password());
    }

    public static void initializeDatabase() throws SQLException {
        if (initialized) {
            return;
        }

        synchronized (INIT_LOCK) {
            if (initialized) {
                return;
            }

            String script = loadSchemaScript();
            try (Connection connection = getConnection()) {
                for (String statement : script.split(";")) {
                    String sql = statement.trim();
                    if (!sql.isEmpty()) {
                        try (Statement jdbcStatement = connection.createStatement()) {
                            jdbcStatement.execute(sql);
                        }
                    }
                }
            }
            initialized = true;
        }
    }

    private static String loadSchemaScript() {
        try (InputStream inputStream = DatabaseUtil.class.getResourceAsStream("/db/student_form.sql")) {
            if (inputStream == null) {
                throw new IllegalStateException("Schema file /db/student_form.sql not found");
            }
            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load schema script", e);
        }
    }

    private static DbConfig loadDbConfig() {
        Properties properties = new Properties();

        try (InputStream inputStream = DatabaseUtil.class.getResourceAsStream(CONFIG_RESOURCE)) {
            if (inputStream != null) {
                properties.load(inputStream);
            }
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load database config from " + CONFIG_RESOURCE, e);
        }

        String url = firstNonBlank(
                System.getProperty("app.db.url"),
                System.getenv("APP_DB_URL"),
                properties.getProperty("db.url"));
        String user = firstNonBlank(
                System.getProperty("app.db.user"),
                System.getenv("APP_DB_USER"),
                properties.getProperty("db.user"));
        String password = firstNonBlank(
                System.getProperty("app.db.password"),
                System.getenv("APP_DB_PASSWORD"),
                properties.getProperty("db.password"));

        if (isBlank(url) || isBlank(user) || password == null) {
            throw new IllegalStateException(
                    "Database configuration is missing. Provide app.db.* system properties, APP_DB_* environment variables, or "
                            + CONFIG_RESOURCE + " on the classpath.");
        }

        return new DbConfig(url, user, password);
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (!isBlank(value)) {
                return value.trim();
            }
        }
        return null;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private record DbConfig(String url, String user, String password) {
    }
}
