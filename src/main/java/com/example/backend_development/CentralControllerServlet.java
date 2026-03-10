package com.example.backend_development;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.Map;

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
@WebServlet(name = "centralControllerServlet", value = "/central-controller/*")
public class CentralControllerServlet extends HttpServlet {
    private transient StudentRecordDao studentRecordDao;
    private transient FileUploadRecordDao fileUploadRecordDao;
    private transient Map<String, ActionHandler> actionHandlers;

    @Override
    public void init() throws ServletException {
        try {
            studentRecordDao = new StudentRecordDao();
            fileUploadRecordDao = new FileUploadRecordDao();
        } catch (SQLException e) {
            throw new ServletException("Failed to initialize DAO for chapter 12", e);
        }

        actionHandlers = Map.ofEntries(
                Map.entry("list", this::handleList),
                Map.entry("form", this::handleForm),
                Map.entry("save", this::handleSave),
                Map.entry("delete", this::handleDelete),
                Map.entry("files", this::handleFileList),
                Map.entry("file-upload", this::handleFileUpload),
                Map.entry("file-download-simple", this::handleFileDownloadSimple),
                Map.entry("file-download-classic", this::handleFileDownloadClassic),
                Map.entry("export-students", this::handleExportStudents)
        );
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = resolveAction(request.getPathInfo());
        ActionHandler actionHandler = actionHandlers.get(action);

        if (actionHandler == null) {
            response.sendRedirect(request.getContextPath() + "/central-controller/list?status=invalidAction&action="
                    + encode(action));
            return;
        }

        try {
            ControllerResult result = actionHandler.handle(request, response);
            if (response.isCommitted() || result == null) {
                return;
            }

            if (result.redirect()) {
                response.sendRedirect(request.getContextPath() + result.target());
            } else {
                request.getRequestDispatcher(result.target()).forward(request, response);
            }
        } catch (IOException e) {
            throw e;
        } catch (ServletException e) {
            throw e;
        } catch (SQLException e) {
            throw new ServletException("Failed to execute central controller action: " + action, e);
        }
    }

    private ControllerResult handleList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        request.setAttribute("records", studentRecordDao.queryAllRecords());
        request.setAttribute("status", request.getParameter("status"));
        request.setAttribute("targetId", request.getParameter("id"));
        request.setAttribute("requestedAction", request.getParameter("action"));
        return ControllerResult.forward("/central-controller-list.jsp");
    }

    private ControllerResult handleForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        String idParam = request.getParameter("id");
        StudentRecordVO record = new StudentRecordVO();
        String mode = "insert";

        if (HtmlUtil.trimToNull(idParam) != null) {
            Long id = parseLong(idParam);
            if (id == null) {
                return ControllerResult.redirect("/central-controller/list?status=invalid&id=" + encode(idParam));
            }

            record = studentRecordDao.findById(id);
            if (record == null) {
                return ControllerResult.redirect("/central-controller/list?status=notfound&id=" + id);
            }
            mode = "update";
        }

        request.setAttribute("record", record);
        request.setAttribute("mode", mode);
        return ControllerResult.forward("/central-controller-form.jsp");
    }

    private ControllerResult handleSave(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return ControllerResult.redirect("/central-controller/list?status=invalidMethod&action=save");
        }

        StudentRecordVO record = StudentRecordMapper.fromRequest(request);
        String idParam = request.getParameter("id");

        if (HtmlUtil.trimToNull(idParam) != null && record.getId() == null) {
            return ControllerResult.redirect("/central-controller/list?status=invalid&id=" + encode(idParam));
        }

        if (record.getId() == null) {
            long generatedId = studentRecordDao.insert(record);
            return ControllerResult.redirect("/central-controller/list?status=created&id=" + generatedId);
        }

        boolean updated = studentRecordDao.update(record);
        if (!updated) {
            return ControllerResult.redirect("/central-controller/list?status=notfound&id=" + record.getId());
        }

        return ControllerResult.redirect("/central-controller/list?status=updated&id=" + record.getId());
    }

    private ControllerResult handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        Long id = parseLong(request.getParameter("id"));
        if (id == null) {
            return ControllerResult.redirect("/central-controller/list?status=invalid&id="
                    + encode(request.getParameter("id")));
        }

        boolean deleted = studentRecordDao.deleteById(id);
        if (!deleted) {
            return ControllerResult.redirect("/central-controller/list?status=notfound&id=" + id);
        }

        return ControllerResult.redirect("/central-controller/list?status=deleted&id=" + id);
    }

    private ControllerResult handleFileList(HttpServletRequest request, HttpServletResponse response)
            throws SQLException {
        request.setAttribute("records", fileUploadRecordDao.findAll());
        request.setAttribute("status", request.getParameter("status"));
        request.setAttribute("targetId", request.getParameter("id"));
        request.setAttribute("requestedAction", request.getParameter("action"));
        request.setAttribute("uploadRootDirectory", FileStorageUtil.getUploadRootDirectoryPath());
        return ControllerResult.forward("/central-controller-files.jsp");
    }

    private ControllerResult handleFileUpload(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            return ControllerResult.redirect("/central-controller/files?status=invalidMethod&action=file-upload");
        }

        Part filePart = request.getPart("uploadFile");
        if (filePart == null || filePart.getSize() <= 0 || HtmlUtil.trimToNull(filePart.getSubmittedFileName()) == null) {
            return ControllerResult.redirect("/central-controller/files?status=missingFile");
        }

        FileStorageUtil.StoredFile storedFile = FileStorageUtil.store(filePart);
        FileUploadRecordVO record = new FileUploadRecordVO();
        record.setOriginalFileName(storedFile.originalFileName());
        record.setStoredFileName(storedFile.storedFileName());
        record.setStoragePath(storedFile.storagePath());
        record.setContentType(storedFile.contentType());
        record.setFileSize(storedFile.fileSize());

        long generatedId = fileUploadRecordDao.insert(record);
        return ControllerResult.redirect("/central-controller/files?status=uploaded&id=" + generatedId);
    }

    private ControllerResult handleFileDownloadSimple(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        FileUploadRecordVO record = resolveDownloadRecord(request);
        if (record == null) {
            return ControllerResult.redirect(buildFileRedirect(request));
        }

        Path targetFile = Path.of(record.getStoragePath());
        String contentType = HtmlUtil.trimToNull(record.getContentType());
        response.setContentType(contentType == null ? "application/octet-stream" : contentType);

        try (OutputStream outputStream = response.getOutputStream()) {
            Files.copy(targetFile, outputStream);
            outputStream.flush();
        }
        return null;
    }

    private ControllerResult handleFileDownloadClassic(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        FileUploadRecordVO record = resolveDownloadRecord(request);
        if (record == null) {
            return ControllerResult.redirect(buildFileRedirect(request));
        }

        Path targetFile = Path.of(record.getStoragePath());
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
        return null;
    }

    private ControllerResult handleExportStudents(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String fileName = "student-records.csv";
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''"
                        + URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20"));

        try (PrintWriter writer = response.getWriter()) {
            writer.write('\uFEFF');
            writer.println("ID,学号,姓名,性别,年龄,出生日期,联系电话,学院,专业,班级,邮箱,兴趣方向,个人简介,创建时间");
            for (StudentRecordVO record : studentRecordDao.queryAllRecords()) {
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
        return null;
    }

    private String resolveAction(String pathInfo) {
        if (pathInfo == null || "/".equals(pathInfo)) {
            return "list";
        }

        String normalized = pathInfo.trim();
        while (normalized.startsWith("/")) {
            normalized = normalized.substring(1);
        }
        while (normalized.endsWith("/")) {
            normalized = normalized.substring(0, normalized.length() - 1);
        }

        return normalized.isEmpty() ? "list" : normalized;
    }

    private Long parseLong(String value) {
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

    private String encode(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        if (normalized == null) {
            return "";
        }
        return URLEncoder.encode(normalized, StandardCharsets.UTF_8);
    }

    private FileUploadRecordVO resolveDownloadRecord(HttpServletRequest request) throws SQLException, IOException {
        Long id = parseLong(request.getParameter("id"));
        if (id == null) {
            request.setAttribute("fileRedirect", "/central-controller/files?status=invalid&id="
                    + encode(request.getParameter("id")));
            return null;
        }

        FileUploadRecordVO record = fileUploadRecordDao.findById(id);
        if (record == null) {
            request.setAttribute("fileRedirect", "/central-controller/files?status=notfound&id=" + id);
            return null;
        }

        Path targetFile = Path.of(record.getStoragePath());
        if (!Files.exists(targetFile)) {
            request.setAttribute("fileRedirect", "/central-controller/files?status=missingFile&id=" + id);
            return null;
        }

        return record;
    }

    private String buildFileRedirect(HttpServletRequest request) {
        return (String) request.getAttribute("fileRedirect");
    }

    private String buildAttachmentHeader(String fileName) {
        String encodedName = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
        String fallbackName = fileName.replace("\"", "");
        return "attachment; filename=\"" + fallbackName + "\"; filename*=UTF-8''" + encodedName;
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

    @FunctionalInterface
    private interface ActionHandler {
        ControllerResult handle(HttpServletRequest request, HttpServletResponse response)
                throws SQLException, IOException, ServletException;
    }
}
