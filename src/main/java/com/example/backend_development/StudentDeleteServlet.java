package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentDeleteServlet", value = "/student-delete")
public class StudentDeleteServlet extends HttpServlet {
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
        String redirectBase = request.getContextPath() + "/student-manage";

        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(redirectBase + "?status=missing");
            return;
        }

        long id;
        try {
            id = Long.parseLong(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectBase + "?status=invalid&id=" + idParam);
            return;
        }

        try {
            boolean deleted = studentRecordDao.deleteById(id);
            if (deleted) {
                response.sendRedirect(redirectBase + "?status=deleted&id=" + id);
            } else {
                response.sendRedirect(redirectBase + "?status=notfound&id=" + id);
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to delete record by id", e);
        }
    }
}
