<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    StudentRecordVO record = (StudentRecordVO) request.getAttribute("record");
    if (record == null) {
        record = new StudentRecordVO();
    }

    boolean updateMode = "update".equals(request.getAttribute("mode"));
    String heading = updateMode ? "JSP 修改数据显示页" : "JSP 新增数据显示页";
    String intro = updateMode
            ? "当前页面通过 JSP 回显数据库里的原始记录，用户可以直接在表单中修改已有数据。"
            : "当前页面通过 JSP 输出新增表单，提交后仍由 Servlet 保存，再跳回 JSP 查询结果页。";
    String submitText = updateMode ? "保存修改并返回 JSP 查询页" : "新增记录并返回 JSP 查询页";
    String studentName = HtmlUtil.escapeHtml(record.getStudentName() == null ? "" : record.getStudentName());
    String studentId = HtmlUtil.escapeHtml(record.getStudentId() == null ? "" : record.getStudentId());
    String phone = HtmlUtil.escapeHtml(record.getPhone() == null ? "" : record.getPhone());
    String major = HtmlUtil.escapeHtml(record.getMajor() == null ? "" : record.getMajor());
    String className = HtmlUtil.escapeHtml(record.getClassName() == null ? "" : record.getClassName());
    String email = HtmlUtil.escapeHtml(record.getEmail() == null ? "" : record.getEmail());
    String introduction = HtmlUtil.escapeHtml(record.getIntroduction() == null ? "" : record.getIntroduction());
    String age = record.getAge() == null ? (updateMode ? "" : "20") : String.valueOf(record.getAge());
    String birthday = record.getBirthday() == null ? "" : record.getBirthday().toString();
    String interests = record.getInterests() == null ? "" : record.getInterests();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第九章：<%= heading %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 09 Form</p>
        <h1><%= heading %></h1>
        <p class="section-intro"><%= intro %></p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/student-jsp">返回第九章查询页</a>
            <a href="<%= request.getContextPath() %>/student-update">查看第七章修改页</a>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>修改数据显示：Servlet 把根据主键查到的 <code>StudentRecordVO</code> 放进 request，再由 JSP 读取并回显。</li>
                <li>表单字段复用：本页的输入区域由 JSP 片段统一输出，减少页面重复代码。</li>
                <li>保存流程：表单提交后仍由 Servlet 调用 DAO，完成保存后重定向回第九章查询页。</li>
            </ul>
        </section>

        <section class="card">
            <form class="demo-form" action="<%= request.getContextPath() %>/student-jsp" method="post">
                <% if (updateMode && record.getId() != null) { %>
                <input type="hidden" name="id" value="<%= record.getId() %>">
                <% } %>

                <%@ include file="/WEB-INF/jspf/student-jsp-form-fields.jspf" %>

                <div class="button-row">
                    <button class="button primary" type="submit"><%= submitText %></button>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-jsp">取消并返回查询页</a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
