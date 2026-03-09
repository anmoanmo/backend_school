<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    StudentRecordVO record = (StudentRecordVO) request.getAttribute("record");
    Long generatedId = (Long) request.getAttribute("generatedId");
    boolean hasRecord = record != null;
    String operation = (String) request.getAttribute("operation");
    boolean updateMode = "update".equals(operation);
    String pageTitle = updateMode ? "数据库修改成功" : "数据库写入成功";
    String heading = updateMode ? "表单数据已更新到数据库" : "表单数据已写入数据库";
    String intro = updateMode ? "当前更新记录主键 ID：" : "当前记录主键 ID：";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow"><%= updateMode ? "Chapter 07 Result" : "Chapter 04 Result" %></p>
        <h1><%= heading %></h1>
        <p class="section-intro"><%= intro %><%= generatedId == null ? "未返回" : generatedId %></p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/student-db-form"><%= updateMode ? "继续新增" : "继续录入" %></a>
            <% if (generatedId != null) { %>
            <a href="<%= request.getContextPath() %>/student-db-form?id=<%= generatedId %>">编辑当前记录</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/student-query">进入第五章查询</a>
            <a href="<%= request.getContextPath() %>/student-update">进入第七章修改</a>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </nav>
    </header>

    <main class="content-stack">
        <% if (!hasRecord) { %>
        <section class="card">
            <h2>没有可展示的数据</h2>
            <p class="note">当前页面通常由 StudentDbServlet 在写库成功后转发而来，请先返回第四章表单页面提交数据。</p>
        </section>
        <% } else { %>
        <section class="card">
            <h2>已保存的数据</h2>
            <div class="parameter-grid">
                <div class="parameter-card"><span>姓名</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentName())) %></strong></div>
                <div class="parameter-card"><span>学号</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentId())) %></strong></div>
                <div class="parameter-card"><span>性别</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getGender())) %></strong></div>
                <div class="parameter-card"><span>年龄</span><strong><%= HtmlUtil.escapeHtml(record.getAge() == null ? "未填写" : String.valueOf(record.getAge())) %></strong></div>
                <div class="parameter-card"><span>出生日期</span><strong><%= HtmlUtil.escapeHtml(record.getBirthday() == null ? "未填写" : record.getBirthday().toString()) %></strong></div>
                <div class="parameter-card"><span>联系电话</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getPhone())) %></strong></div>
                <div class="parameter-card"><span>学院</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getDepartment())) %></strong></div>
                <div class="parameter-card"><span>专业</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getMajor())) %></strong></div>
                <div class="parameter-card"><span>班级</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getClassName())) %></strong></div>
                <div class="parameter-card"><span>邮箱</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getEmail())) %></strong></div>
                <div class="parameter-card"><span>兴趣方向</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getInterests())) %></strong></div>
                <div class="parameter-card"><span>个人简介</span><strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getIntroduction())) %></strong></div>
            </div>
        </section>

        <section class="card">
            <h2><%= updateMode ? "第七章实现对应" : "第四章实现对应" %></h2>
            <ul class="feature-list">
                <li>VO：Servlet 先把表单参数封装为 <code>StudentRecordVO</code> 对象。</li>
                <li>DAO：<code>StudentRecordDao</code> 使用 <code>PreparedStatement</code> 执行 JDBC <%= updateMode ? "更新" : "插入" %>。</li>
                <li>数据库表：首次访问时会自动初始化 <code>student_form_records</code> 表。</li>
                <li>当前项目已把插入和修改合并到同一个 <code>StudentDbServlet</code> 和共用表单页面中。</li>
            </ul>
        </section>
        <% } %>
    </main>
</div>
</body>
</html>
