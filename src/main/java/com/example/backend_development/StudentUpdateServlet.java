package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentUpdateServlet", value = "/student-update")
public class StudentUpdateServlet extends HttpServlet {
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
            request.setAttribute("records", records);
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("targetId", request.getParameter("id"));
            request.getRequestDispatcher("/student-update.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load records for update page", e);
        }
    }
}
