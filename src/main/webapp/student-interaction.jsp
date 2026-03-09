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
    <title>第八章：Servlet 交互</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 08</p>
        <h1>Servlet 交互与增删改查联动</h1>
        <p class="section-intro">
            第八章把前面的新增、查询、修改、删除串到同一个入口里，用 forward、sendRedirect 和 include 三种方式把页面交互连成完整流程。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-update">回到第七章</a>
            <a href="<%= request.getContextPath() %>/student-interaction?action=new">新增记录</a>
            <a href="<%= request.getContextPath() %>/student-interaction">刷新总控页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li><code>forward</code>：主控 Servlet 查询数据或准备表单后，转发到 JSP 页面显示。</li>
                <li><code>sendRedirect</code>：新增、修改、删除完成后，重定向回总控页，避免浏览器刷新时重复提交。</li>
                <li><code>include</code>：页面中的统计概览通过 <code>/student-interaction-summary</code> servlet 输出，再被 include 到当前页面。</li>
                <li>增删改查：本页统一提供查询、创建、更新、删除入口，把前面几章的能力连成一个完整后台页面。</li>
            </ul>
        </section>

        <% if ("created".equals(status)) { %>
        <section class="status-banner success">
            已新增主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，并通过 sendRedirect 返回到总控页。
        </section>
        <% } else if ("updated".equals(status)) { %>
        <section class="status-banner success">
            已更新主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，并通过 sendRedirect 返回到总控页。
        </section>
        <% } else if ("deleted".equals(status)) { %>
        <section class="status-banner success">
            已删除主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，并通过 sendRedirect 返回到总控页。
        </section>
        <% } else if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录，可能已经被其他操作删除。
        </section>
        <% } else if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            请求中的主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("invalidAction".equals(status)) { %>
        <section class="status-banner danger">
            请求中的动作参数不合法，请从页面提供的入口重新发起操作。
        </section>
        <% } %>

        <jsp:include page="/student-interaction-summary" />

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>综合管理表格</h2>
                    <p class="note">本页直接管理学生记录，操作列支持修改和删除；新增入口在页面顶部和表格上方都能进入。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/student-interaction?action=new">新增记录</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-query">查看纯查询页</a>
                </div>
            </div>

            <% if (records == null || records.isEmpty()) { %>
            <p class="note">数据库中还没有记录。先点击“新增记录”，完成第八章的整合式 CRUD 流程。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-manage table-sticky-action">
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
                        <th>邮箱</th>
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
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getEmail())) %></td>
                        <td><%= HtmlUtil.escapeHtml(record.getCreatedAt() == null ? "未记录" : record.getCreatedAt().toString()) %></td>
                        <td>
                            <div class="action-stack">
                                <a class="action-link primary"
                                   href="<%= request.getContextPath() %>/student-interaction?action=edit&id=<%= record.getId() %>">
                                    修改
                                </a>
                                <a class="action-link danger"
                                   href="<%= request.getContextPath() %>/student-interaction?action=delete&id=<%= record.getId() %>"
                                   onclick="return confirm('确认删除主键为 <%= record.getId() %> 的记录吗？');">
                                    删除
                                </a>
                            </div>
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
