<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<StudentRecordVO> records = (List<StudentRecordVO>) request.getAttribute("records");
    String status = (String) request.getAttribute("status");
    String targetId = (String) request.getAttribute("targetId");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第九章：JSP 查询结果页</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 09</p>
        <h1>JSP 改造查询结果页和修改显示页</h1>
        <p class="section-intro">
            这一章把查询结果显示和修改数据回显进一步收口到 JSP 视图层中。Servlet 负责准备数据，JSP 负责页面渲染和表单显示。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-interaction">回到第八章</a>
            <a href="<%= request.getContextPath() %>/file-upload">下一章：文件上传</a>
            <a href="<%= request.getContextPath() %>/student-jsp?action=new">进入 JSP 表单</a>
            <a href="<%= request.getContextPath() %>/student-jsp">刷新 JSP 查询页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>查询结果页：通过 <code>StudentJspServlet</code> 查询全部记录，再 forward 到 JSP 页面显示结果。</li>
                <li>修改显示页：根据主键读取单条记录，再 forward 到 JSP 表单页回显原始数据。</li>
                <li>JSP 片段：本章把查询表格和表单字段拆成 JSP 片段，体现 JSP 视图层的复用能力。</li>
            </ul>
        </section>

        <%@ include file="/WEB-INF/jspf/student-jsp-status.jspf" %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>JSP 查询结果显示页</h2>
                    <p class="note">下面的查询表格由 JSP 页面负责渲染，操作列会跳到第九章的 JSP 修改显示页。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/student-jsp?action=new">新增记录</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-query">查看第五章原始查询页</a>
                </div>
            </div>

            <%@ include file="/WEB-INF/jspf/student-jsp-query-table.jspf" %>
        </section>

        <section class="card">
            <h2>JSP 改造点</h2>
            <ul class="feature-list">
                <li>查询表格片段：当前页通过 JSP include 片段输出表格结构，避免整页重复编写表格代码。</li>
                <li>修改表单片段：下一页会复用同一套 JSP 字段片段，把数据库记录回显到表单输入框中。</li>
                <li>Servlet 与 JSP 分工：Servlet 负责查数据和保存数据，JSP 负责展示和回填。</li>
            </ul>
        </section>
    </main>
</div>
</body>
</html>
