<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<StudentRecordVO> records = (List<StudentRecordVO>) request.getAttribute("records");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第五章：查询并显示到浏览器</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 05</p>
        <h1>查询并显示到浏览器</h1>
        <p class="section-intro">
            这一章通过 Servlet 调用 DAO 的查询方法，读取数据库中的全部记录，并以表格形式显示在浏览器中。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-db-form">回到第四章</a>
            <a href="<%= request.getContextPath() %>/student-manage">下一章：主键删除</a>
            <a href="<%= request.getContextPath() %>/student-query">刷新查询结果</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>DAO 中定义了 <code>queryAllRecords()</code>，查询数据库表中的全部记录并以 <code>List&lt;StudentRecordVO&gt;</code> 返回。</li>
                <li>Servlet <code>StudentQueryServlet</code> 调用 DAO 查询方法，并转发到 JSP 页面。</li>
                <li>JSP 页面使用表格展示查询结果，完成“显示到浏览器”的任务要求。</li>
                <li>第六章会继续复用这份查询结果，在表格中追加删除链接，实现根据主键删除记录。</li>
            </ul>
        </section>

        <section class="card">
            <h2>数据库查询结果</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">数据库中还没有记录。先到第四章页面提交一条学生信息，再回到这里查询。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-query">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>年龄</th>
                        <th>出生日期</th>
                        <th>电话</th>
                        <th>学院</th>
                        <th>专业</th>
                        <th>班级</th>
                        <th>邮箱</th>
                        <th>兴趣方向</th>
                        <th>个人简介</th>
                        <th>创建时间</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (StudentRecordVO record : records) { %>
                    <tr>
                        <td><%= record.getId() %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentId())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentName())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getGender())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getAge() == null ? "未填写" : String.valueOf(record.getAge())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getBirthday() == null ? "未填写" : record.getBirthday().toString()) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getPhone())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getDepartment())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getMajor())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getClassName())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getEmail())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getInterests())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getIntroduction())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getCreatedAt() == null ? "未记录" : record.getCreatedAt().toString()) %></td>
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
