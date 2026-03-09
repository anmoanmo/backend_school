package com.example.backend_development;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "fileDownloadClassicServlet", value = "/file-download-classic")
public class FileDownloadClassicServlet extends HttpServlet {
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
            String downloadName = HtmlUtil.trimToNull(record.getOriginalFileName());
            if (downloadName == null) {
                downloadName = targetFile.getFileName().toString();
            }

            response.setContentType(contentType == null ? "application/octet-stream" : contentType);
            response.setContentLengthLong(Files.size(targetFile));
            response.setHeader("Content-Disposition", buildAttachmentHeader(downloadName));

            try (InputStream inputStream = Files.newInputStream(targetFile);
                 OutputStream outputStream = response.getOutputStream()) {
                byte[] buffer = new byte[8192];
                int length;
                while ((length = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, length);
                }
                outputStream.flush();
            }
        } catch (SQLException e) {
            throw new ServletException("Failed to load file metadata for classic download", e);
        }
    }

    private String buildAttachmentHeader(String fileName) {
        String encodedName = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
        String fallbackName = fileName.replace("\"", "");
        return "attachment; filename=\"" + fallbackName + "\"; filename*=UTF-8''" + encodedName;
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
