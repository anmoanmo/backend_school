package com.example.backend_development;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "fileDownloadSimpleServlet", value = "/file-download-simple")
public class FileDownloadSimpleServlet extends HttpServlet {
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
        Long id = parseId(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/file-download?status=invalid&id=" + safeValue(request.getParameter("id")));
            return;
        }

        try {
            FileUploadRecordVO record = fileUploadRecordDao.findById(id);
            if (record == null) {
                response.sendRedirect(request.getContextPath() + "/file-download?status=notfound&id=" + id);
                return;
            }

            Path targetFile = Path.of(record.getStoragePath());
            if (!Files.exists(targetFile)) {
                response.sendRedirect(request.getContextPath() + "/file-download?status=missingFile&id=" + id);
                return;
            }

            String contentType = HtmlUtil.trimToNull(record.getContentType());
            response.setContentType(contentType == null ? "application/octet-stream" : contentType);

            try (OutputStream outputStream = response.getOutputStream()) {
                Files.copy(targetFile, outputStream);
                outputStream.flush();
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to load file metadata for simple download", e);
        }
    }

    private Long parseId(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        if (normalized == null) {
            return null;
        }

        try {
            return Long.parseLong(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String safeValue(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        return normalized == null ? "" : normalized;
    }
}
