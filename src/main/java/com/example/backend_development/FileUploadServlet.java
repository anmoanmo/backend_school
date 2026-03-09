package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 12 * 1024 * 1024
)
@WebServlet(name = "fileUploadServlet", value = "/file-upload")
public class FileUploadServlet extends HttpServlet {
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
            request.setAttribute("uploadRootDirectory", FileStorageUtil.getUploadRootDirectoryPath());
            request.getRequestDispatcher("/file-upload.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load uploaded file records", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        Part filePart = request.getPart("uploadFile");

        if (filePart == null || filePart.getSize() <= 0 || HtmlUtil.trimToNull(filePart.getSubmittedFileName()) == null) {
            response.sendRedirect(request.getContextPath() + "/file-upload?status=missingFile");
            return;
        }

        try {
            FileStorageUtil.StoredFile storedFile = FileStorageUtil.store(filePart);
            FileUploadRecordVO record = new FileUploadRecordVO();
            record.setOriginalFileName(storedFile.originalFileName());
            record.setStoredFileName(storedFile.storedFileName());
            record.setStoragePath(storedFile.storagePath());
            record.setContentType(storedFile.contentType());
            record.setFileSize(storedFile.fileSize());

            long generatedId = fileUploadRecordDao.insert(record);
            response.sendRedirect(request.getContextPath() + "/file-upload?status=uploaded&id=" + generatedId);
        } catch (SQLException e) {
            throw new ServletException("Failed to save upload record into database", e);
        }
    }
}
