package com.example.backend_development;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class StudentRecordDao {
    private static final String INSERT_SQL = """
            INSERT INTO student_form_records
            (student_no, student_name, gender, age, birthday, phone, department, major, class_name, email, interests, introduction)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """;

    private static final String SELECT_ALL_SQL = """
            SELECT id, student_no, student_name, gender, age, birthday, phone, department, major, class_name, email, interests, introduction, created_at
            FROM student_form_records
            ORDER BY id DESC
            """;

    private static final String DELETE_BY_ID_SQL = """
            DELETE FROM student_form_records
            WHERE id = ?
            """;

    private static final String SELECT_BY_ID_SQL = """
            SELECT id, student_no, student_name, gender, age, birthday, phone, department, major, class_name, email, interests, introduction, created_at
            FROM student_form_records
            WHERE id = ?
            """;

    private static final String UPDATE_SQL = """
            UPDATE student_form_records
            SET student_no = ?, student_name = ?, gender = ?, age = ?, birthday = ?, phone = ?, department = ?, major = ?, class_name = ?, email = ?, interests = ?, introduction = ?
            WHERE id = ?
            """;

    public StudentRecordDao() throws SQLException {
        DatabaseUtil.initializeDatabase();
    }

    public long insert(StudentRecordVO record) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, record.getStudentId());
            statement.setString(2, record.getStudentName());
            statement.setString(3, record.getGender());
            if (record.getAge() == null) {
                statement.setNull(4, java.sql.Types.INTEGER);
            } else {
                statement.setInt(4, record.getAge());
            }
            if (record.getBirthday() == null) {
                statement.setNull(5, java.sql.Types.DATE);
            } else {
                statement.setDate(5, Date.valueOf(record.getBirthday()));
            }
            statement.setString(6, record.getPhone());
            statement.setString(7, record.getDepartment());
            statement.setString(8, record.getMajor());
            statement.setString(9, record.getClassName());
            statement.setString(10, record.getEmail());
            statement.setString(11, record.getInterests());
            statement.setString(12, record.getIntroduction());
            statement.executeUpdate();

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }

        throw new SQLException("Insert succeeded but no generated key was returned");
    }

    public List<StudentRecordVO> queryAllRecords() throws SQLException {
        List<StudentRecordVO> records = new ArrayList<>();

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT_ALL_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                StudentRecordVO record = new StudentRecordVO();
                record.setId(resultSet.getLong("id"));
                record.setStudentId(resultSet.getString("student_no"));
                record.setStudentName(resultSet.getString("student_name"));
                record.setGender(resultSet.getString("gender"));
                int age = resultSet.getInt("age");
                record.setAge(resultSet.wasNull() ? null : age);
                Date birthday = resultSet.getDate("birthday");
                if (birthday != null) {
                    record.setBirthday(birthday.toLocalDate());
                }
                record.setPhone(resultSet.getString("phone"));
                record.setDepartment(resultSet.getString("department"));
                record.setMajor(resultSet.getString("major"));
                record.setClassName(resultSet.getString("class_name"));
                record.setEmail(resultSet.getString("email"));
                record.setInterests(resultSet.getString("interests"));
                record.setIntroduction(resultSet.getString("introduction"));
                Timestamp createdAt = resultSet.getTimestamp("created_at");
                if (createdAt != null) {
                    record.setCreatedAt(createdAt.toLocalDateTime());
                }
                records.add(record);
            }
        }

        return records;
    }

    public List<StudentRecordVO> findAll() throws SQLException {
        return queryAllRecords();
    }

    public StudentRecordVO findById(long id) throws SQLException {
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

    public boolean update(StudentRecordVO record) throws SQLException {
        if (record.getId() == null) {
            throw new SQLException("Cannot update a record without id");
        }

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_SQL)) {
            statement.setString(1, record.getStudentId());
            statement.setString(2, record.getStudentName());
            statement.setString(3, record.getGender());
            if (record.getAge() == null) {
                statement.setNull(4, java.sql.Types.INTEGER);
            } else {
                statement.setInt(4, record.getAge());
            }
            if (record.getBirthday() == null) {
                statement.setNull(5, java.sql.Types.DATE);
            } else {
                statement.setDate(5, Date.valueOf(record.getBirthday()));
            }
            statement.setString(6, record.getPhone());
            statement.setString(7, record.getDepartment());
            statement.setString(8, record.getMajor());
            statement.setString(9, record.getClassName());
            statement.setString(10, record.getEmail());
            statement.setString(11, record.getInterests());
            statement.setString(12, record.getIntroduction());
            statement.setLong(13, record.getId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean deleteById(long id) throws SQLException {
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_BY_ID_SQL)) {
            statement.setLong(1, id);
            return statement.executeUpdate() > 0;
        }
    }

    private StudentRecordVO mapRecord(ResultSet resultSet) throws SQLException {
        StudentRecordVO record = new StudentRecordVO();
        record.setId(resultSet.getLong("id"));
        record.setStudentId(resultSet.getString("student_no"));
        record.setStudentName(resultSet.getString("student_name"));
        record.setGender(resultSet.getString("gender"));
        int age = resultSet.getInt("age");
        record.setAge(resultSet.wasNull() ? null : age);
        Date birthday = resultSet.getDate("birthday");
        if (birthday != null) {
            record.setBirthday(birthday.toLocalDate());
        }
        record.setPhone(resultSet.getString("phone"));
        record.setDepartment(resultSet.getString("department"));
        record.setMajor(resultSet.getString("major"));
        record.setClassName(resultSet.getString("class_name"));
        record.setEmail(resultSet.getString("email"));
        record.setInterests(resultSet.getString("interests"));
        record.setIntroduction(resultSet.getString("introduction"));
        Timestamp createdAt = resultSet.getTimestamp("created_at");
        if (createdAt != null) {
            record.setCreatedAt(createdAt.toLocalDateTime());
        }
        return record;
    }
}
