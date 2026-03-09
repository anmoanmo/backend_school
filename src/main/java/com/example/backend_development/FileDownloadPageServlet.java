package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "fileDownloadPageServlet", value = "/file-download")
public class FileDownloadPageServlet extends HttpServlet {
    private transient FileUploadRecordDao fileUploadRecordDao;

    @Override
    public void init() throws ServletException {
        try {
            fileUploadRecordDao = new FileUploadRecordDao();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize FileUploadRecordDao", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            List<FileUploadRecordVO> uploadRecords = fileUploadRecordDao.findAll();
            request.setAttribute("records", uploadRecords);
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("targetId", request.getParameter("id"));
            request.getRequestDispatcher("/file-download.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load uploaded file records for chapter 11", e);
        }
    }
}
