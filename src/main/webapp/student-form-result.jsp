<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    StudentRecordVO record = (StudentRecordVO) request.getAttribute("record");
    boolean hasRecord = record != null;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>学生信息提交结果</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 03 Result</p>
        <h1>Servlet 已接收到表单数据</h1>
        <p class="section-intro">这一页由 StudentFormServlet 接收参数后转发到 JSP 展示结果，结构比直接拼接 HTML 更清晰。</p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/student-form.html">返回登记表</a>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </nav>
    </header>

    <main class="content-stack">
        <% if (!hasRecord) { %>
        <section class="card">
            <h2>没有可展示的数据</h2>
            <p class="note">当前页面通常由 StudentFormServlet 转发而来，请先返回第三章表单页面再提交一次数据。</p>
        </section>
        <% } else { %>
        <section class="card">
            <h2>学生信息摘要</h2>
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
            <h2>Servlet 处理说明</h2>
            <ul class="feature-list">
                <li>Servlet 通过 <code>request.getParameter</code> 和 <code>request.getParameterValues</code> 获取表单数据。</li>
                <li>公共映射器 <code>StudentRecordMapper</code> 把请求参数整理成统一的学生对象。</li>
                <li>结果页改为 JSP，后续继续扩展字段时不需要在 Servlet 中维护大量 <code>out.println</code>。</li>
            </ul>
        </section>
        <% } %>
    </main>
</div>
</body>
</html>
