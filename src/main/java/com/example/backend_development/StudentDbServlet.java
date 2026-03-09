package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentDbServlet", value = "/student-db-form")
public class StudentDbServlet extends HttpServlet {
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
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank()) {
            try {
                long id = Long.parseLong(idParam);
                StudentRecordVO record = studentRecordDao.findById(id);
                if (record == null) {
                    response.sendRedirect(request.getContextPath() + "/student-update?status=notfound&id=" + id);
                    return;
                }
                request.setAttribute("record", record);
                request.setAttribute("mode", "update");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/student-update?status=invalid&id=" + idParam);
                return;
            } catch (SQLException e) {
                throw new ServletException("Failed to load record by id", e);
            }
        } else {
            request.setAttribute("record", new StudentRecordVO());
            request.setAttribute("mode", "insert");
        }

        request.getRequestDispatcher("/student-db-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        StudentRecordVO record = StudentRecordMapper.fromRequest(request);
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank() && record.getId() == null) {
            response.sendRedirect(request.getContextPath() + "/student-update?status=invalid&id=" + idParam);
            return;
        }

        try {
            String operation;
            long generatedId;

            if (record.getId() == null) {
                generatedId = studentRecordDao.insert(record);
                record.setId(generatedId);
                operation = "insert";
            } else {
                boolean updated = studentRecordDao.update(record);
                if (!updated) {
                    response.sendRedirect(request.getContextPath() + "/student-update?status=notfound&id=" + record.getId());
                    return;
                }
                generatedId = record.getId();
                operation = "update";
            }

            request.setAttribute("record", record);
            request.setAttribute("generatedId", generatedId);
            request.setAttribute("operation", operation);
            request.getRequestDispatcher("/student-db-result.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to save form data into database", e);
        }
    }
}
