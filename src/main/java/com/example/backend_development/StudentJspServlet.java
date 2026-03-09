package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentJspServlet", value = "/student-jsp")
public class StudentJspServlet extends HttpServlet {
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

        showQueryPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        StudentRecordVO record = StudentRecordMapper.fromRequest(request);
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isBlank() && record.getId() == null) {
            response.sendRedirect(request.getContextPath() + "/student-jsp?status=invalid&id=" + idParam);
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
                    response.sendRedirect(request.getContextPath() + "/student-jsp?status=notfound&id=" + record.getId());
                    return;
                }
                targetId = record.getId();
                status = "updated";
            }

            response.sendRedirect(request.getContextPath() + "/student-jsp?status=" + status + "&id=" + targetId);
        } catch (SQLException e) {
            throw new ServletException("Failed to save record on chapter 9 JSP page", e);
        }
    }

    private void showQueryPage(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            List<StudentRecordVO> records = studentRecordDao.queryAllRecords();
            request.setAttribute("records", records);
            request.setAttribute("status", request.getParameter("status"));
            request.setAttribute("targetId", request.getParameter("id"));
            request.getRequestDispatcher("/student-jsp-query.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Failed to load records for chapter 9 JSP query page", e);
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        Long id = parseId(idParam);

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/student-jsp?status=invalid&id=" + safeValue(idParam));
            return;
        }

        try {
            StudentRecordVO record = studentRecordDao.findById(id);
            if (record == null) {
                response.sendRedirect(request.getContextPath() + "/student-jsp?status=notfound&id=" + id);
                return;
            }
            showForm(request, response, record, "update");
        } catch (SQLException e) {
            throw new ServletException("Failed to load record for chapter 9 JSP form", e);
        }
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, StudentRecordVO record, String mode)
            throws IOException, ServletException {
        request.setAttribute("record", record);
        request.setAttribute("mode", mode);
        request.getRequestDispatcher("/student-jsp-form.jsp").forward(request, response);
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
