<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.FileUploadRecordVO" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    @SuppressWarnings("unchecked")
    List<StudentRecordVO> recentStudents = (List<StudentRecordVO>) request.getAttribute("recentStudents");
    @SuppressWarnings("unchecked")
    List<FileUploadRecordVO> recentFiles = (List<FileUploadRecordVO>) request.getAttribute("recentFiles");
    int studentCount = request.getAttribute("studentCount") == null ? 0 : (Integer) request.getAttribute("studentCount");
    int fileCount = request.getAttribute("fileCount") == null ? 0 : (Integer) request.getAttribute("fileCount");
    int totalSessions = request.getAttribute("totalSessions") == null ? 0 : (Integer) request.getAttribute("totalSessions");
    int activeSessions = request.getAttribute("activeSessions") == null ? 0 : (Integer) request.getAttribute("activeSessions");
    int authenticatedSessions = request.getAttribute("authenticatedSessions") == null
            ? 0 : (Integer) request.getAttribute("authenticatedSessions");
    LocalDateTime appStartTime = (LocalDateTime) request.getAttribute("appStartTime");
    String uploadRootDirectory = (String) request.getAttribute("uploadRootDirectory");
    boolean dataAvailable = request.getAttribute("dataAvailable") instanceof Boolean
            && (Boolean) request.getAttribute("dataAvailable");
    String dataMessage = (String) request.getAttribute("dataMessage");
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
    boolean loggedIn = currentUser != null;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>完整项目版首页</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-home">
<div class="page-shell wide-shell">
    <header class="hero">
        <p class="eyebrow">Servlet + JSP + JDBC</p>
        <h1>学生信息与文件管理系统</h1>
        <p class="hero-text">这是课程任务整合后的统一入口，当前包含学生数据管理、文件上传下载、登录控制和运行状态统计。</p>
        <div class="hero-actions">
            <a class="button primary" href="<%= request.getContextPath() %>/central-controller/list">进入学生数据中心</a>
            <a class="button secondary" href="<%= request.getContextPath() %>/complete-project/chapters">查看章节目录</a>
            <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/files">进入文件中心</a>
            <% if (loggedIn) { %>
            <a class="button secondary" href="<%= request.getContextPath() %>/logout">退出登录</a>
            <% } else { %>
            <a class="button secondary" href="<%= request.getContextPath() %>/login?redirect=%2Fcomplete-project%2Fhome">登录系统</a>
            <% } %>
        </div>
    </header>

    <% if (loggedIn) { %>
    <section class="status-banner success">
        当前已登录用户：<strong><%= HtmlUtil.escapeHtml(currentUser) %></strong>。你可以直接进入学生管理、文件管理和系统监控模块。
    </section>
    <% } else { %>
    <section class="status-banner warning">
        当前未登录。你仍然可以浏览课程章节和前端基础页面；进入中央控制器模块时会由过滤器要求先登录。
    </section>
    <% } %>

    <% if (!dataAvailable) { %>
    <section class="status-banner warning">
        <strong>数据模块暂不可用：</strong><%= HtmlUtil.escapeHtml(dataMessage == null ? "数据库尚未连接。" : dataMessage) %>
        你仍然可以浏览完整项目首页、章节目录、前端页面以及登录与监听器入口。
    </section>
    <% } %>

    <main class="content-stack">
        <section class="card">
            <h2>系统概况</h2>
            <div class="parameter-grid upload-summary-grid">
                <div class="parameter-card">
                    <span>课程章节</span>
                    <strong>15 章</strong>
                </div>
                <div class="parameter-card">
                    <span>学生记录数</span>
                    <strong><%= studentCount %></strong>
                </div>
                <div class="parameter-card">
                    <span>上传文件数</span>
                    <strong><%= fileCount %></strong>
                </div>
                <div class="parameter-card">
                    <span>累计会话数</span>
                    <strong><%= totalSessions %></strong>
                </div>
                <div class="parameter-card">
                    <span>在线会话数</span>
                    <strong><%= activeSessions %></strong>
                </div>
                <div class="parameter-card">
                    <span>已登录会话数</span>
                    <strong><%= authenticatedSessions %></strong>
                </div>
                <div class="parameter-card">
                    <span>应用启动时间</span>
                    <strong><%= appStartTime == null ? "未记录" : formatter.format(appStartTime) %></strong>
                </div>
                <div class="parameter-card">
                    <span>上传根目录</span>
                    <strong><%= HtmlUtil.escapeHtml(uploadRootDirectory == null ? "未记录" : uploadRootDirectory) %></strong>
                </div>
            </div>
        </section>

        <section class="card-grid">
            <article class="card">
                <span class="card-index">01</span>
                <h2>前端基础页面</h2>
                <p>保留基础 HTML、表单和进阶标签页面，方便回看每一章的原始练习。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/html-basics.html">HTML 基础页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-forms.html">HTML 表单页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-advanced.jsp">HTML 进阶页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">02</span>
                <h2>学生数据中心</h2>
                <p>学生信息的新增、查询、修改、删除都统一进入这里处理。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/list">中央控制器列表</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/form">新增学生记录</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-jsp">JSP 查询页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">03</span>
                <h2>文件服务中心</h2>
                <p>上传文件、下载文件和导出数据都集中在这里，上传目录位于项目根目录下。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/files">文件管理入口</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/file-upload">原始上传页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/file-download">原始下载页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">04</span>
                <h2>登录与监控</h2>
                <p>登录、过滤器和监听器单独保留，方便测试系统访问控制和运行状态。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/login?redirect=%2Fcomplete-project%2Fhome">登录页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/filter-control.jsp">过滤器页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/listener-demo.jsp">监听器页</a>
                </div>
            </article>
        </section>

        <section class="project-summary-grid">
            <section class="card">
                <div class="section-toolbar">
                    <div>
                        <h2>最近学生记录</h2>
                        <p class="note">显示数据库中最近录入的学生信息。</p>
                    </div>
                    <div class="button-row">
                        <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/list">查看全部</a>
                        <a class="button secondary" href="<%= request.getContextPath() %>/student-export">导出 CSV</a>
                    </div>
                </div>
                <div class="table-scroll">
                    <table class="demo-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>姓名</th>
                            <th>专业</th>
                            <th>班级</th>
                            <th>创建时间</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (recentStudents == null || recentStudents.isEmpty()) { %>
                        <tr>
                            <td colspan="5">当前还没有学生数据，请先进入学生数据中心新增一条记录。</td>
                        </tr>
                        <% } else { %>
                        <% for (StudentRecordVO record : recentStudents) { %>
                        <tr>
                            <td><%= record.getId() == null ? "-" : record.getId() %></td>
                            <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStudentName())) %></td>
                            <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getMajor())) %></td>
                            <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getClassName())) %></td>
                            <td><%= record.getCreatedAt() == null ? "-" : formatter.format(record.getCreatedAt()) %></td>
                        </tr>
                        <% } %>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </section>

            <section class="card">
                <div class="section-toolbar">
                    <div>
                        <h2>最近上传文件</h2>
                        <p class="note">显示最近上传的文件记录，可继续进入文件中心下载或管理。</p>
                    </div>
                    <div class="button-row">
                        <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/files">查看全部</a>
                    </div>
                </div>
                <div class="table-scroll">
                    <table class="demo-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>文件名</th>
                            <th>大小</th>
                            <th>上传时间</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (recentFiles == null || recentFiles.isEmpty()) { %>
                        <tr>
                            <td colspan="4">当前还没有上传记录，请先进入文件服务中心上传一个文件。</td>
                        </tr>
                        <% } else { %>
                        <% for (FileUploadRecordVO record : recentFiles) { %>
                        <tr>
                            <td><%= record.getId() == null ? "-" : record.getId() %></td>
                            <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getOriginalFileName())) %></td>
                            <td><%= record.getFileSize() == null ? 0 : record.getFileSize() %> B</td>
                            <td><%= record.getCreatedAt() == null ? "-" : formatter.format(record.getCreatedAt()) %></td>
                        </tr>
                        <% } %>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </section>
    </main>
</div>
</body>
</html>
