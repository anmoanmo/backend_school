package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentInteractionServlet", value = "/student-interaction")
public class StudentInteractionServlet extends HttpServlet {
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
        String action = HtmlUtil.trimToNull(request.getParameter("action"));

        if ("new".equals(action)) {
            showForm(request, response, new StudentRecordVO(), "insert");
            return;
        }

        if ("edit".equals(action)) {
            showEditForm(request, response);
            return;
        }

        if ("delete".equals(action)) {
            handleDelete(request, response);
            return;
        }

        showDashboard(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        String action = HtmlUtil.trimToNull(request.getParameter("action"));

        if (!"save".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/student-interaction?status=invalidAction");
            return;
        }

        StudentRecordVO record = StudentRecordMapper.fromRequest(request);
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank() && record.getId() == null) {
            response.sendRedirect(request.getContextPath() + "/student-interaction?status=invalid&id=" + idParam);
            return;
        }

        try {
            String status;
            long targetId;

            if (record.getId() == null) {
                targetId = studentRecordDao.insert(record);
                status = "created";
            } else {
                boolean updated = studentRecordDao.update(record);
                if (!updated) {
                    response.sendRedirect(request.getContextPath() + "/student-interaction?status=notfound&id=" + record.getId());
                    return;
                }
                targetId = record.getId();
                status = "updated";
            }

            response.sendRedirect(request.getContextPath() + "/student-interaction?status=" + status + "&id=" + targetId);
        } catch (SQLException e) {
            throw new ServletException("Failed to save record from chapter 8 interaction page", e);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            List<StudentRecordVO> records = studentRecordDao.queryAllRecords();
            request.setAttribute("records", records);
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("targetId", request.getParameter("id"));
            request.getRequestDispatcher("/student-interaction.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load records for chapter 8 interaction page", e);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        Long id = parseId(idParam);

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/student-interaction?status=invalid&id=" + safeValue(idParam));
            return;
        }

        try {
            StudentRecordVO record = studentRecordDao.findById(id);
            if (record == null) {
                response.sendRedirect(request.getContextPath() + "/student-interaction?status=notfound&id=" + id);
                return;
            }
            showForm(request, response, record, "update");
        } catch (SQLException e) {
            throw new ServletException("Failed to load record for chapter 8 edit form", e);
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        Long id = parseId(idParam);

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/student-interaction?status=invalid&id=" + safeValue(idParam));
            return;
        }

        try {
            boolean deleted = studentRecordDao.deleteById(id);
            String status = deleted ? "deleted" : "notfound";
            response.sendRedirect(request.getContextPath() + "/student-interaction?status=" + status + "&id=" + id);
        } catch (SQLException e) {
            throw new ServletException("Failed to delete record from chapter 8 interaction page", e);
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, StudentRecordVO record, String mode)
            throws IOException, ServletException {
        request.setAttribute("record", record);
        request.setAttribute("mode", mode);
        request.getRequestDispatcher("/student-interaction-form.jsp").forward(request, response);
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
