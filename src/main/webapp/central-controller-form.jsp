<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    StudentRecordVO record = (StudentRecordVO) request.getAttribute("record");
    if (record == null) {
        record = new StudentRecordVO();
    }

    boolean updateMode = "update".equals(request.getAttribute("mode"));
    String heading = updateMode ? "中央控制器修改表单" : "中央控制器新增表单";
    String intro = updateMode
            ? "当前记录由中央控制器先根据主键查询，再统一 forward 到 JSP 表单页回显。"
            : "当前表单由中央控制器统一 forward 到 JSP 页面，提交后仍会回到中央控制器执行保存动作。";
    String submitText = updateMode ? "通过中央控制器保存修改" : "通过中央控制器新增记录";
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
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十二章：<%= heading %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 12 Form</p>
        <h1><%= heading %></h1>
        <p class="section-intro"><%= intro %></p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/central-controller/list">返回中央控制器列表</a>
            <a href="<%= request.getContextPath() %>/central-controller/files">进入文件模块</a>
            <a href="<%= request.getContextPath() %>/student-db-form">对照第四章表单</a>
            <a href="<%= request.getContextPath() %>/logout">退出登录（<%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(currentUser)) %>）</a>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>统一入口：新增和修改表单都由 <code>/central-controller/form</code> 进入。</li>
                <li>统一保存：表单统一提交到 <code>/central-controller/save</code>，由中央控制器决定插入还是更新。</li>
                <li>统一结果：保存完成后不直接输出 HTML，而是统一重定向回列表页。</li>
            </ul>
        </section>

        <section class="card">
            <form class="demo-form" action="<%= request.getContextPath() %>/central-controller/save" method="post">
                <% if (updateMode && record.getId() != null) { %>
                <input type="hidden" name="id" value="<%= record.getId() %>">
                <% } %>

                <%@ include file="/WEB-INF/jspf/student-jsp-form-fields.jspf" %>

                <div class="button-row">
                    <button class="button primary" type="submit"><%= submitText %></button>
                    <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/list">取消并返回列表</a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
