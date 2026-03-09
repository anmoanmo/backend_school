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
    <title>第七章：根据主键修改记录</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 07</p>
        <h1>根据主键修改一条记录</h1>
        <p class="section-intro">
            这一章在前面几章的基础上新增主键查询和更新能力。先查询一条记录并回显到表单，再通过同一个保存 Servlet 提交修改结果。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-manage">回到第六章</a>
            <a href="<%= request.getContextPath() %>/student-interaction">下一章：Servlet 交互</a>
            <a href="<%= request.getContextPath() %>/student-db-form">新增一条记录</a>
            <a href="<%= request.getContextPath() %>/student-update">刷新修改页面</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>DAO 中新增 <code>findById(long id)</code>，根据主键查询单条记录。</li>
                <li>修改表单会回显原始数据，由同一个 <code>StudentDbServlet</code> 接收并保存更新。</li>
                <li>插入和修改共用 <code>/student-db-form</code> 入口，只是根据是否带有主键参数决定当前模式。</li>
                <li>本页负责输出带“修改”链接的表格，点击即可把主键参数带到共用表单页。</li>
            </ul>
        </section>

        <% if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，可能已经被删除。
        </section>
        <% } else if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            修改失败：请求中的主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } %>

        <section class="card">
            <h2>可修改记录列表</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">数据库中还没有记录。先到第四章新增一条学生信息，再回到第七章执行主键修改。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-update table-sticky-action">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>学号</th>
                        <th>姓名</th>
                        <th>性别</th>
                        <th>学院</th>
                        <th>专业</th>
                        <th>班级</th>
                        <th>联系电话</th>
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
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getGender())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getDepartment())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getMajor())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getClassName())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getPhone())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getInterests())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getCreatedAt() == null ? "未记录" : record.getCreatedAt().toString()) %></td>
                        <td>
                            <a class="action-link primary"
                               href="<%= request.getContextPath() %>/student-db-form?id=<%= record.getId() %>">
                                修改
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
