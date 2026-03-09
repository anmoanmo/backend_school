package com.example.backend_development;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FileUploadRecordDao {
    private static final String CREATE_TABLE_SQL = """
            CREATE TABLE IF NOT EXISTS uploaded_file_records (
                id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                original_file_name VARCHAR(255) NOT NULL,
                stored_file_name VARCHAR(255) NOT NULL,
                storage_path VARCHAR(600) NOT NULL,
                content_type VARCHAR(200),
                file_size BIGINT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """;

    private static final String INSERT_SQL = """
            INSERT INTO uploaded_file_records
            (original_file_name, stored_file_name, storage_path, content_type, file_size)
            VALUES (?, ?, ?, ?, ?)
            """;

    private static final String SELECT_ALL_SQL = """
            SELECT id, original_file_name, stored_file_name, storage_path, content_type, file_size, created_at
            FROM uploaded_file_records
            ORDER BY id DESC
            """;

    private static final String SELECT_BY_ID_SQL = """
            SELECT id, original_file_name, stored_file_name, storage_path, content_type, file_size, created_at
            FROM uploaded_file_records
            WHERE id = ?
            """;

    public FileUploadRecordDao() throws SQLException {
        DatabaseUtil.initializeDatabase();
        ensureTable();
    }

    public long insert(FileUploadRecordVO record) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, record.getOriginalFileName());
            statement.setString(2, record.getStoredFileName());
            statement.setString(3, record.getStoragePath());
            statement.setString(4, record.getContentType());
            statement.setLong(5, record.getFileSize() == null ? 0L : record.getFileSize());
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }

        throw new SQLException("Insert succeeded but no generated key was returned");
    }

    public List<FileUploadRecordVO> findAll() throws SQLException {
        List<FileUploadRecordVO> records = new ArrayList<>();

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                FileUploadRecordVO record = new FileUploadRecordVO();
                record.setId(resultSet.getLong("id"));
                record.setOriginalFileName(resultSet.getString("original_file_name"));
                record.setStoredFileName(resultSet.getString("stored_file_name"));
                record.setStoragePath(resultSet.getString("storage_path"));
                record.setContentType(resultSet.getString("content_type"));
                record.setFileSize(resultSet.getLong("file_size"));
                Timestamp createdAt = resultSet.getTimestamp("created_at");
                if (createdAt != null) {
                    record.setCreatedAt(createdAt.toLocalDateTime());
                }
                records.add(record);
            }
        }

        return records;
    }

    public FileUploadRecordVO findById(long id) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_BY_ID_SQL)) {
            statement.setLong(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapRecord(resultSet);
                }
            }
        }

        return null;
    }

    private void ensureTable() throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             Statement statement = connection.createStatement()) {
            statement.execute(CREATE_TABLE_SQL);
        }
    }

    private FileUploadRecordVO mapRecord(ResultSet resultSet) throws SQLException {
        FileUploadRecordVO record = new FileUploadRecordVO();
        record.setId(resultSet.getLong("id"));
        record.setOriginalFileName(resultSet.getString("original_file_name"));
        record.setStoredFileName(resultSet.getString("stored_file_name"));
        record.setStoragePath(resultSet.getString("storage_path"));
        record.setContentType(resultSet.getString("content_type"));
        record.setFileSize(resultSet.getLong("file_size"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            record.setCreatedAt(createdAt.toLocalDateTime());
        }
        return record;
    }
}
