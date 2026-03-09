<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="com.example.backend_development.StudentRecordVO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    StudentRecordVO record = (StudentRecordVO) request.getAttribute("record");
    if (record == null) {
        record = new StudentRecordVO();
    }

    boolean updateMode = "update".equals(request.getAttribute("mode"));
    String heading = updateMode ? "修改学生记录" : "新增学生记录";
    String intro = updateMode
            ? "这一步通过 forward 进入表单页，先把数据库中的原始数据回显出来，再提交修改。"
            : "这一步通过 forward 进入新增表单页，提交后会 sendRedirect 回到第八章总控页。";
    String submitText = updateMode ? "保存修改并返回总控页" : "新增记录并返回总控页";
    String studentName = HtmlUtil.escapeHtml(record.getStudentName() == null ? "" : record.getStudentName());
    String studentId = HtmlUtil.escapeHtml(record.getStudentId() == null ? "" : record.getStudentId());
    String phone = HtmlUtil.escapeHtml(record.getPhone() == null ? "" : record.getPhone());
    String major = HtmlUtil.escapeHtml(record.getMajor() == null ? "" : record.getMajor());
    String className = HtmlUtil.escapeHtml(record.getClassName() == null ? "" : record.getClassName());
    String email = HtmlUtil.escapeHtml(record.getEmail() == null ? "" : record.getEmail());
    String introduction = HtmlUtil.escapeHtml(record.getIntroduction() == null ? "" : record.getIntroduction());
    String age = record.getAge() == null ? (updateMode ? "" : "20") : String.valueOf(record.getAge());
    String birthday = record.getBirthday() == null ? "" : record.getBirthday().toString();
    String interests = record.getInterests() == null ? "" : record.getInterests();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第八章：<%= heading %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 08 Form</p>
        <h1><%= heading %></h1>
        <p class="section-intro"><%= intro %></p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/student-interaction">返回第八章总控页</a>
            <a href="<%= request.getContextPath() %>/student-db-form">查看第 4/7 章共用表单</a>
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>交互说明</h2>
            <ul class="feature-list">
                <li>当前表单页是由 <code>StudentInteractionServlet</code> 使用 <code>forward</code> 转发而来。</li>
                <li>提交后仍然由同一个 Servlet 处理保存，再通过 <code>sendRedirect</code> 回到总控页。</li>
                <li>这样浏览器刷新时不会重复提交表单，也能把增删改查串到同一章节中。</li>
            </ul>
        </section>

        <section class="card">
            <form class="demo-form" action="<%= request.getContextPath() %>/student-interaction" method="post">
                <input type="hidden" name="action" value="save">
                <% if (updateMode && record.getId() != null) { %>
                <input type="hidden" name="id" value="<%= record.getId() %>">
                <% } %>

                <fieldset>
                    <legend>基本资料</legend>

                    <label>
                        <span>姓名</span>
                        <input type="text" name="studentName" placeholder="请输入姓名" required maxlength="20" value="<%= studentName %>" autofocus>
                    </label>

                    <label>
                        <span>学号</span>
                        <input type="text" name="studentId" placeholder="例如 20260001" required value="<%= studentId %>">
                    </label>

                    <div class="option-group">
                        <span>性别</span>
                        <label class="inline-option"><input type="radio" name="gender" value="男" <%= !"女".equals(record.getGender()) ? "checked" : "" %>> 男</label>
                        <label class="inline-option"><input type="radio" name="gender" value="女" <%= "女".equals(record.getGender()) ? "checked" : "" %>> 女</label>
                    </div>

                    <label>
                        <span>年龄</span>
                        <input type="number" name="age" min="16" max="35" value="<%= age %>">
                    </label>

                    <label>
                        <span>出生日期</span>
                        <input type="date" name="birthday" value="<%= birthday %>">
                    </label>

                    <label>
                        <span>联系电话</span>
                        <input type="tel" name="phone" pattern="[0-9]{11}" placeholder="请输入 11 位手机号" value="<%= phone %>">
                    </label>
                </fieldset>

                <fieldset>
                    <legend>学习信息</legend>

                    <label>
                        <span>学院</span>
                        <select name="department">
                            <option value="计算机学院" <%= (record.getDepartment() == null || "计算机学院".equals(record.getDepartment())) ? "selected" : "" %>>计算机学院</option>
                            <option value="信息工程学院" <%= "信息工程学院".equals(record.getDepartment()) ? "selected" : "" %>>信息工程学院</option>
                            <option value="管理学院" <%= "管理学院".equals(record.getDepartment()) ? "selected" : "" %>>管理学院</option>
                            <option value="外国语学院" <%= "外国语学院".equals(record.getDepartment()) ? "selected" : "" %>>外国语学院</option>
                        </select>
                    </label>

                    <label>
                        <span>专业</span>
                        <input type="text" name="major" value="<%= major.isEmpty() && !updateMode ? "软件工程" : major %>">
                    </label>

                    <label>
                        <span>班级</span>
                        <input type="text" name="className" value="<%= className.isEmpty() && !updateMode ? "软工 1 班" : className %>">
                    </label>

                    <label>
                        <span>邮箱</span>
                        <input type="email" name="email" placeholder="student@example.com" value="<%= email %>">
                    </label>

                    <div class="option-group">
                        <span>兴趣方向</span>
                        <label class="inline-option"><input type="checkbox" name="interest" value="JavaWeb" <%= interests.contains("JavaWeb") || (!updateMode && interests.isEmpty()) ? "checked" : "" %>> JavaWeb</label>
                        <label class="inline-option"><input type="checkbox" name="interest" value="数据库" <%= interests.contains("数据库") ? "checked" : "" %>> 数据库</label>
                        <label class="inline-option"><input type="checkbox" name="interest" value="前端开发" <%= interests.contains("前端开发") ? "checked" : "" %>> 前端开发</label>
                        <label class="inline-option"><input type="checkbox" name="interest" value="算法" <%= interests.contains("算法") ? "checked" : "" %>> 算法</label>
                    </div>

                    <label class="full-width">
                        <span>个人简介</span>
                        <textarea name="introduction" rows="5" placeholder="介绍一下你的学习方向、兴趣或目标"><%= introduction %></textarea>
                    </label>
                </fieldset>

                <div class="button-row">
                    <button class="button primary" type="submit"><%= submitText %></button>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-interaction">取消并返回总控页</a>
                </div>
            </form>
        </section>
    </main>
</div>
</body>
</html>
