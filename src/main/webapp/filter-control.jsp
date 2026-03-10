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
    <title>第十四章：过滤器和登录控制</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 14</p>
        <h1>过滤器和登录控制</h1>
        <p class="section-intro">
            第十四章把过滤器单独整理为课程任务：定义过滤器、配置过滤器，并在过滤器里验证用户是否处于登录状态，再决定是否放行到中央控制器。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/login">回到第十三章登录页</a>
            <a href="<%= request.getContextPath() %>/filter-control.jsp">刷新过滤器页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>过滤器的定义：使用 <code>AuthFilter</code> 这个类实现 <code>jakarta.servlet.Filter</code> 接口。</li>
                <li>过滤器的配置：在 <code>WEB-INF/web.xml</code> 中显式配置 <code>authFilter</code> 并映射到 <code>/central-controller/*</code>。</li>
                <li>在过滤器里验证登录状态：如果会话中没有登录用户，过滤器就重定向到登录页；如果已登录，则放行到中央控制器。</li>
            </ul>
        </section>

        <% if (loggedIn) { %>
        <section class="status-banner success">
            当前已登录用户：<strong><%= HtmlUtil.escapeHtml(currentUser) %></strong>。你现在访问中央控制器会被过滤器直接放行。
        </section>
        <% } else { %>
        <section class="status-banner warning">
            当前未登录。你现在点击受保护资源时，会先被过滤器拦截并重定向到登录页。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>过滤器测试入口</h2>
                    <p class="note">这里直接用受保护的中央控制器页面作为测试对象，最能体现“登录控制”的课程要求。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/central-controller/list">访问学生模块</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/central-controller/files">访问文件模块</a>
                    <% if (loggedIn) { %>
                    <a class="button secondary" href="<%= request.getContextPath() %>/logout">退出登录</a>
                    <% } else { %>
                    <a class="button secondary" href="<%= request.getContextPath() %>/login?redirect=%2Fcentral-controller%2Flist">先去登录</a>
                    <% } %>
                </div>
            </div>
        </section>

        <section class="card">
            <h2>实现位置</h2>
            <ul class="feature-list">
                <li>过滤器类：<code>src/main/java/com/example/backend_development/AuthFilter.java</code></li>
                <li>过滤器配置：<code>src/main/webapp/WEB-INF/web.xml</code></li>
                <li>登录页：<code>src/main/webapp/login.jsp</code></li>
                <li>受保护资源示例：<code>src/main/webapp/central-controller-list.jsp</code></li>
            </ul>
        </section>
    </main>
</div>
</body>
</html>
