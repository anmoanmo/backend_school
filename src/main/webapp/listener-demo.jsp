<%@ page import="com.example.backend_development.ApplicationStatsListener" %>
<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.concurrent.atomic.AtomicInteger" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    LocalDateTime appStartTime = (LocalDateTime) application.getAttribute(ApplicationStatsListener.ATTR_START_TIME);
    AtomicInteger totalSessions = (AtomicInteger) application.getAttribute(ApplicationStatsListener.ATTR_TOTAL_SESSIONS);
    AtomicInteger activeSessions = (AtomicInteger) application.getAttribute(ApplicationStatsListener.ATTR_ACTIVE_SESSIONS);
    AtomicInteger authenticatedSessions =
            (AtomicInteger) application.getAttribute(ApplicationStatsListener.ATTR_AUTHENTICATED_SESSIONS);
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
    boolean loggedIn = currentUser != null;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十五章：监听器的应用</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 15</p>
        <h1>监听器的应用</h1>
        <p class="section-intro">
            第十五章把监听器单独整理为课程任务：定义监听器、配置监听器，并把监听器应用到应用启动、会话统计和登录状态统计中。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/filter-control.jsp">回到第十四章</a>
            <a href="<%= request.getContextPath() %>/listener-demo.jsp">刷新监听器页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>监听器的定义：使用 <code>ApplicationStatsListener</code> 同时实现 <code>ServletContextListener</code>、<code>HttpSessionListener</code> 和 <code>HttpSessionAttributeListener</code>。</li>
                <li>监听器的配置：在 <code>WEB-INF/web.xml</code> 中显式注册监听器类。</li>
                <li>监听器的应用：监听应用启动时间、累计会话数、当前在线会话数，以及已登录用户会话数。</li>
            </ul>
        </section>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>监听器统计结果</h2>
                    <p class="note">本页会读取监听器写入到 <code>ServletContext</code> 里的统计数据，直接展示监听器是否生效。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/central-controller/list">访问受保护资源</a>
                    <% if (loggedIn) { %>
                    <a class="button secondary" href="<%= request.getContextPath() %>/logout">退出登录</a>
                    <% } else { %>
                    <a class="button secondary" href="<%= request.getContextPath() %>/login?redirect=%2Flistener-demo.jsp">先去登录</a>
                    <% } %>
                </div>
            </div>

            <div class="parameter-grid upload-summary-grid">
                <div class="parameter-card">
                    <span>应用启动时间</span>
                    <strong><%= appStartTime == null ? "未记录" : formatter.format(appStartTime) %></strong>
                </div>
                <div class="parameter-card">
                    <span>累计会话数</span>
                    <strong><%= totalSessions == null ? 0 : totalSessions.get() %></strong>
                </div>
                <div class="parameter-card">
                    <span>当前在线会话数</span>
                    <strong><%= activeSessions == null ? 0 : activeSessions.get() %></strong>
                </div>
                <div class="parameter-card">
                    <span>已登录会话数</span>
                    <strong><%= authenticatedSessions == null ? 0 : authenticatedSessions.get() %></strong>
                </div>
                <div class="parameter-card">
                    <span>当前会话 ID</span>
                    <strong><%= HtmlUtil.escapeHtml(session.getId()) %></strong>
                </div>
                <div class="parameter-card">
                    <span>当前登录状态</span>
                    <strong><%= loggedIn ? "已登录：" + HtmlUtil.escapeHtml(currentUser) : "未登录" %></strong>
                </div>
            </div>
        </section>

        <section class="card">
            <h2>实现位置</h2>
            <ul class="feature-list">
                <li>监听器类：<code>src/main/java/com/example/backend_development/ApplicationStatsListener.java</code></li>
                <li>监听器配置：<code>src/main/webapp/WEB-INF/web.xml</code></li>
                <li>监听器应用页面：<code>src/main/webapp/listener-demo.jsp</code></li>
                <li>登录状态来源：<code>src/main/java/com/example/backend_development/AuthSessionUtil.java</code></li>
            </ul>
        </section>
    </main>
</div>
</body>
</html>
