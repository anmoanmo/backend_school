<%@ page import="com.example.backend_development.LoginService" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String status = (String) request.getAttribute("status");
    if (status == null) {
        status = request.getParameter("status");
    }
    String username = (String) request.getAttribute("username");
    if (username == null) {
        username = "";
    }
    String redirectTarget = (String) request.getAttribute("redirectTarget");
    if (redirectTarget == null || redirectTarget.isBlank()) {
        redirectTarget = "/central-controller/list";
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十三章：登录的实现</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 13</p>
        <h1>登录的实现</h1>
        <p class="section-intro">
            第十三章实现登录表单、处理登录动作、用户名和密码验证，以及登录错误信息提示。登录成功后会进入第十二章中央控制器。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/central-controller/list">尝试进入中央控制器</a>
            <a href="<%= request.getContextPath() %>/filter-control.jsp">下一章：过滤器</a>
            <a href="<%= request.getContextPath() %>/login">刷新登录页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>登录表单：当前页面提供用户名和密码输入框。</li>
                <li>处理登录的 action：表单提交到 <code>/login</code>，由 Servlet 处理。</li>
                <li>用户名和密码验证：当前演示账号固定为 <code><%= LoginService.DEMO_USERNAME %></code> / <code><%= LoginService.DEMO_PASSWORD %></code>。</li>
                <li>登录错误提示：账号密码错误、未登录访问受保护资源、退出登录后都会返回明确提示。</li>
            </ul>
        </section>

        <% if ("invalidCredential".equals(status)) { %>
        <section class="status-banner danger">
            登录失败：用户名或密码错误，请重新输入。
        </section>
        <% } else if ("authRequired".equals(status)) { %>
        <section class="status-banner warning">
            请先登录后再访问中央控制器中的受保护资源。
        </section>
        <% } else if ("loggedOut".equals(status)) { %>
        <section class="status-banner success">
            你已经成功退出登录。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>登录表单</h2>
                    <p class="note">为了便于课程演示，这里使用固定账号密码验证。登录成功后会通过会话保存登录状态。</p>
                </div>
                <div class="parameter-grid upload-summary-grid">
                    <div class="parameter-card">
                        <span>演示账号</span>
                        <strong><%= LoginService.DEMO_USERNAME %></strong>
                    </div>
                    <div class="parameter-card">
                        <span>演示密码</span>
                        <strong><%= LoginService.DEMO_PASSWORD %></strong>
                    </div>
                </div>
            </div>

            <form class="demo-form" action="<%= request.getContextPath() %>/login" method="post">
                <input type="hidden" name="redirect" value="<%= HtmlUtil.escapeHtml(redirectTarget) %>">

                <fieldset>
                    <legend>输入登录信息</legend>

                    <label>
                        <span>用户名</span>
                        <input type="text" name="username" required maxlength="30" value="<%= HtmlUtil.escapeHtml(username) %>" autofocus>
                    </label>

                    <label>
                        <span>密码</span>
                        <input type="password" name="password" required maxlength="30" placeholder="请输入密码">
                    </label>
                </fieldset>

                <div class="button-row">
                    <button class="button primary" type="submit">登录并进入后台</button>
                    <button class="button secondary" type="reset">清空输入</button>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
