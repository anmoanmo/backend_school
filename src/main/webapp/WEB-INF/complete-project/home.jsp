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
        <p class="eyebrow">Integrated Project</p>
        <h1>校园服务综合实验平台</h1>
        <p class="hero-text">
            这里把 1 到 15 章课程内容重新组合成一个完整项目入口。前端基础页、学生信息管理、文件上传下载、登录鉴权、过滤器控制和监听器统计都保留在同一套应用里，并按“真实项目首页”的方式集中展示。
        </p>
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
            <h2>运行概览</h2>
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
                <span class="card-index">A</span>
                <h2>前端基础区</h2>
                <p>保留第一章和第二章的静态页面练习，作为完整项目中的前端基础展示与原始页面素材来源。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/html-basics.html">HTML 基础页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-forms.html">HTML 表单页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-advanced.jsp">HTML 进阶页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">B</span>
                <h2>学生数据中心</h2>
                <p>把第三章到第九章的表单、JDBC、查询、删除、修改、Servlet 交互和 JSP 视图能力集中到学生数据管理模块。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/list">中央控制器列表</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/form">新增学生记录</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-jsp">JSP 查询页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">C</span>
                <h2>文件服务中心</h2>
                <p>把第十章和第十一章的上传、下载、导出整合成独立文件服务模块，并沿用项目根目录下的上传空间。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/files">文件管理入口</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/file-upload">原始上传页</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/file-download">原始下载页</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">D</span>
                <h2>登录与监控</h2>
                <p>第十二章到第十五章的中央控制器、登录、过滤器和监听器组成完整的访问控制与运行时监控链路。</p>
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
                        <p class="note">这里直接读取数据库中的最新 5 条学生数据，验证第四章到第九章的数据链路已经被完整项目复用。</p>
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
                        <p class="note">这里直接读取上传记录表，验证文件上传、数据库落库和下载路径管理已经进入同一套项目结构。</p>
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

        <section class="card">
            <h2>章节如何被组合成完整项目</h2>
            <div class="card-grid">
                <article class="card">
                    <span class="card-index">01-02</span>
                    <h3>前端基础搭建</h3>
                    <p>HTML、表单、脚本、URL 和编码知识被作为完整项目的页面基础和表单素材来源。</p>
                </article>
                <article class="card">
                    <span class="card-index">03-09</span>
                    <h3>学生业务闭环</h3>
                    <p>从 Servlet 接表单、JDBC 入库、查询、删除、修改到 JSP 展示，这部分形成完整的学生记录管理闭环。</p>
                </article>
                <article class="card">
                    <span class="card-index">10-11</span>
                    <h3>文件服务闭环</h3>
                    <p>上传、下载和导出能力被整合为文件服务中心，上传目录统一落在项目根目录下。</p>
                </article>
                <article class="card">
                    <span class="card-index">12-15</span>
                    <h3>控制与监控闭环</h3>
                    <p>中央控制器负责统一入口，登录与过滤器负责访问控制，监听器负责观察应用和会话运行状态。</p>
                </article>
            </div>
        </section>
    </main>
</div>
</body>
</html>
