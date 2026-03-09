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
    <title>第六章：根据主键删除记录</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 06</p>
        <h1>根据主键删除记录</h1>
        <p class="section-intro">
            这一章基于第五章的查询结果页继续向前推进：在 DAO 中定义根据主键删除的方法，在 Servlet 中接收主键参数，再通过浏览器中的删除链接完成删除操作。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-query">回到第五章</a>
            <a href="<%= request.getContextPath() %>/student-update">下一章：主键修改</a>
            <a href="<%= request.getContextPath() %>/student-manage">刷新管理页面</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>DAO 中新增 <code>deleteById(long id)</code> 方法，接收数据表主键参数。</li>
                <li>Servlet <code>StudentDeleteServlet</code> 接收请求参数 <code>id</code>，调用 DAO 删除记录。</li>
                <li>本页在表格中构造删除链接，点击后即可根据主键删除指定记录。</li>
                <li>第七章会继续使用同一张数据表，根据主键查询单条记录并完成修改。</li>
            </ul>
        </section>

        <% if ("deleted".equals(status)) { %>
        <section class="status-banner success">
            已删除主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录。
        </section>
        <% } else if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，可能已经被删除。
        </section>
        <% } else if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            删除失败：请求中的主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("missing".equals(status)) { %>
        <section class="status-banner danger">
            删除失败：请求里没有提供主键参数 <code>id</code>。
        </section>
        <% } %>

        <section class="card">
            <h2>记录管理表格</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">数据库中还没有记录。先到第四章录入一条学生信息，再回到第六章执行删除测试。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-manage table-sticky-action">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>学院</th>
                        <th>专业</th>
                        <th>兴趣方向</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (StudentRecordVO record : records) { %>
                    <tr>
                        <td><%= record.getId() %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentId())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentName())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getDepartment())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getMajor())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getInterests())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getCreatedAt() == null ? "未记录" : record.getCreatedAt().toString()) %></td>
                        <td>
                            <a class="action-link danger"
                               href="<%= request.getContextPath() %>/student-delete?id=<%= record.getId() %>"
                               onclick="return confirm('确认删除主键为 <%= record.getId() %> 的记录吗？');">
                                删除
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>
