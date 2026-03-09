package com.example.backend_development;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentInteractionSummaryServlet", value = "/student-interaction-summary")
public class StudentInteractionSummaryServlet extends HttpServlet {
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
        response.setContentType("text/html; charset=UTF-8");

        try {
            List<StudentRecordVO> records = studentRecordDao.queryAllRecords();
            StudentRecordVO latestRecord = records.isEmpty() ? null : records.get(0);
            Set<String> departments = new LinkedHashSet<>();
            for (StudentRecordVO record : records) {
                if (record.getDepartment() != null && !record.getDepartment().isBlank()) {
                    departments.add(record.getDepartment());
                }
            }

            PrintWriter out = response.getWriter();
            out.println("<section class=\"card\">");
            out.println("    <h2>include 统计片段</h2>");
            out.println("    <p class=\"section-intro\">这块内容由 <code>/student-interaction-summary</code> servlet 输出，再通过 include 方式嵌入当前页面。</p>");
            out.println("    <div class=\"parameter-grid\">");
            out.println("        <div class=\"parameter-card\"><span>总记录数</span><strong>" + records.size() + "</strong></div>");
            out.println("        <div class=\"parameter-card\"><span>学院数量</span><strong>" + departments.size() + "</strong></div>");
            out.println("        <div class=\"parameter-card\"><span>最新记录</span><strong>" +
                    HtmlUtil.escapeHtml(latestRecord == null ? "暂无数据" : HtmlUtil.defaultText(latestRecord.getStudentName())) +
                    "</strong></div>");
            out.println("        <div class=\"parameter-card\"><span>最新主键</span><strong>" +
                    HtmlUtil.escapeHtml(latestRecord == null || latestRecord.getId() == null ? "暂无数据" : String.valueOf(latestRecord.getId())) +
                    "</strong></div>");
            out.println("    </div>");
            out.println("</section>");
        } catch (SQLException e) {
            throw new ServletException("Failed to load chapter 8 summary fragment", e);
        }
    }
}
