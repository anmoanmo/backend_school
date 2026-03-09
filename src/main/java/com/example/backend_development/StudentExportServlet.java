package com.example.backend_development;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentExportServlet", value = "/student-export")
public class StudentExportServlet extends HttpServlet {
    private transient StudentRecordDao studentRecordDao;

    @Override
    public void init() throws ServletException {
        try {
            studentRecordDao = new StudentRecordDao();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize StudentRecordDao", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            List<StudentRecordVO> records = studentRecordDao.queryAllRecords();
            String fileName = "student-records.csv";

            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
                            + URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20"));

            try (PrintWriter writer = response.getWriter()) {
                writer.write('\uFEFF');
                writer.println("ID,学号,姓名,性别,年龄,出生日期,联系电话,学院,专业,班级,邮箱,兴趣方向,个人简介,创建时间");
                for (StudentRecordVO record : records) {
                    writer.println(toCsvRow(
                            String.valueOf(record.getId()),
                            safe(record.getStudentId()),
                            safe(record.getStudentName()),
                            safe(record.getGender()),
                            record.getAge() == null ? "" : String.valueOf(record.getAge()),
                            record.getBirthday() == null ? "" : record.getBirthday().toString(),
                            safe(record.getPhone()),
                            safe(record.getDepartment()),
                            safe(record.getMajor()),
                            safe(record.getClassName()),
                            safe(record.getEmail()),
                            safe(record.getInterests()),
                            safe(record.getIntroduction()),
                            record.getCreatedAt() == null ? "" : record.getCreatedAt().toString()
                    ));
                }
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to export student records", e);
        }
    }

    private String safe(String value) {
        return value == null ? "" : value;
    }

    private String toCsvRow(String... values) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < values.length; i++) {
            if (i > 0) {
                builder.append(',');
            }
            builder.append('"')
                    .append(values[i].replace("\"", "\"\""))
                    .append('"');
        }
        return builder.toString();
    }
}
