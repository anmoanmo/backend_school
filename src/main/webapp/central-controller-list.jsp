<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<StudentRecordVO> records = (List<StudentRecordVO>) request.getAttribute("records");
    String status = (String) request.getAttribute("status");
    String targetId = (String) request.getAttribute("targetId");
    String requestedAction = (String) request.getAttribute("requestedAction");
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十二章：中央控制器架构</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 12</p>
        <h1>中央控制器架构</h1>
        <p class="section-intro">
            第十二章把学生管理模块和文件管理模块升级为 Front Controller 结构。所有请求统一进入一个中央控制器，再按路径分发到列表、表单、保存、删除、上传和下载等动作。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/file-download">回到第十一章</a>
            <a href="<%= request.getContextPath() %>/central-controller/form">新增记录</a>
            <a href="<%= request.getContextPath() %>/central-controller/files">文件模块</a>
            <a href="<%= request.getContextPath() %>/logout">退出登录（<%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(currentUser)) %>）</a>
            <a href="<%= request.getContextPath() %>/central-controller/list">刷新中央控制器页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>统一入口：所有学生管理请求都先进入 <code>/central-controller/*</code>。</li>
                <li>动作分发：中央控制器根据路径决定执行 <code>list</code>、<code>form</code>、<code>save</code>、<code>delete</code>。</li>
                <li>统一结果：每个动作返回同一种分发结果对象，再由中央控制器统一决定 <code>forward</code> 或 <code>redirect</code>。</li>
                <li>文件扩展：同一个中央控制器还继续分发文件上传、简单下载、经典下载和导出下载。</li>
            </ul>
        </section>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>中央控制器路径</h2>
                    <p class="note">本章不再依赖 <code>action</code> 参数，而是用路径本身表示动作，便于统一管理。</p>
                </div>
                <div class="parameter-grid upload-summary-grid">
                    <div class="parameter-card">
                        <span>列表入口</span>
                        <strong>/central-controller/list</strong>
                    </div>
                    <div class="parameter-card">
                        <span>表单入口</span>
                        <strong>/central-controller/form</strong>
                    </div>
                    <div class="parameter-card">
                        <span>保存动作</span>
                        <strong>POST /central-controller/save</strong>
                    </div>
                    <div class="parameter-card">
                        <span>删除动作</span>
                        <strong>/central-controller/delete?id=主键</strong>
                    </div>
                </div>
            </div>
        </section>

        <% if ("created".equals(status)) { %>
        <section class="status-banner success">
            中央控制器已新增主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录。
        </section>
        <% } else if ("updated".equals(status)) { %>
        <section class="status-banner success">
            中央控制器已更新主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录。
        </section>
        <% } else if ("deleted".equals(status)) { %>
        <section class="status-banner success">
            中央控制器已删除主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录。
        </section>
        <% } else if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的记录。
        </section>
        <% } else if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("invalidAction".equals(status)) { %>
        <section class="status-banner danger">
            中央控制器无法识别动作 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(requestedAction)) %></strong>。
        </section>
        <% } else if ("invalidMethod".equals(status)) { %>
        <section class="status-banner danger">
            当前动作只允许使用指定的 HTTP 方法，请从本页提供的入口重新发起请求。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>学生记录总表</h2>
                    <p class="note">表格中的“修改”“删除”链接都回到中央控制器，由同一个入口继续分发。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/central-controller/form">通过中央控制器新增</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/files">进入文件模块</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-interaction">对照第八章总控页</a>
                </div>
            </div>

            <% if (records == null || records.isEmpty()) { %>
            <p class="note">数据库中还没有记录。先点击上方“通过中央控制器新增”，再回到这里查看统一入口的完整流程。</p>
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
                                   href="<%= request.getContextPath() %>/central-controller/form?id=<%= record.getId() %>">
                                    修改
                                </a>
                                <a class="action-link danger"
                                   href="<%= request.getContextPath() %>/central-controller/delete?id=<%= record.getId() %>"
                                   onclick="return confirm('确认通过中央控制器删除主键为 <%= record.getId() %> 的记录吗？');">
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
