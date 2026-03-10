<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
    boolean loggedIn = currentUser != null;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>完整项目版章节目录</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Course Chapters</p>
        <h1>章节目录</h1>
        <p class="section-intro">这里保留原来的章节入口，便于按课程顺序单独演示。</p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/complete-project/home">返回完整项目首页</a>
            <a href="<%= request.getContextPath() %>/central-controller/list">学生数据中心</a>
            <a href="<%= request.getContextPath() %>/central-controller/files">文件服务中心</a>
            <% if (loggedIn) { %>
            <a href="<%= request.getContextPath() %>/logout">退出登录：<%= HtmlUtil.escapeHtml(currentUser) %></a>
            <% } else { %>
            <a href="<%= request.getContextPath() %>/login?redirect=%2Fcomplete-project%2Fchapters">登录后返回目录</a>
            <% } %>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card-grid">
            <article class="card">
                <span class="card-index">01-02</span>
                <h2>前端基础阶段</h2>
                <p>用于展示基础页面、表单元素和 HTML 进阶标签能力。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/html-basics.html">第一章 HTML 基础</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-forms.html">第二章 表单页面</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/html-advanced.jsp">第二章 进阶页面</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">03-05</span>
                <h2>表单接收与入库</h2>
                <p>从最初的 Servlet 处理表单，到 JDBC 入库，再到数据库查询显示。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/student-form.html">第三章 表单处理</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-db-form">第四章 表单入库</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-query">第五章 查询显示</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">06-09</span>
                <h2>学生 CRUD 完整链路</h2>
                <p>删除、修改、Servlet 交互、JSP 开发共同组成完整的学生记录业务闭环。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/student-manage">第六章 删除</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-update">第七章 修改</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-interaction">第八章 交互</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-jsp">第九章 JSP 开发</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">10-11</span>
                <h2>文件服务阶段</h2>
                <p>服务器目录落盘、数据库记录保存、文件下载和 CSV 导出下载。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/file-upload">第十章 文件上传</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/file-download">第十一章 文件下载</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/student-export">学生数据导出</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">12-13</span>
                <h2>统一入口与登录</h2>
                <p>中央控制器负责统一调度，登录模块负责身份验证并保护系统核心入口。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/list">第十二章 中央控制器</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/central-controller/files">第十二章 文件模块</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/login">第十三章 登录</a>
                </div>
            </article>

            <article class="card">
                <span class="card-index">14-15</span>
                <h2>控制与系统监控</h2>
                <p>过滤器验证登录状态，监听器统计应用、会话与登录用户运行状态。</p>
                <div class="link-list">
                    <a class="text-link" href="<%= request.getContextPath() %>/filter-control.jsp">第十四章 过滤器</a>
                    <a class="text-link" href="<%= request.getContextPath() %>/listener-demo.jsp">第十五章 监听器</a>
                </div>
            </article>
        </section>
    </main>
</div>
</body>
</html>
