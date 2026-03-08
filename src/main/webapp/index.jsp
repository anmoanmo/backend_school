<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HTML 操练项目</title>
    <link rel="stylesheet" href="assets/css/site.css">
</head>
<body class="theme-home">
<div class="page-shell">
    <header class="hero">
        <p class="eyebrow">JavaWeb / HTML Practice</p>
        <h1>HTML 操练项目</h1>
        <p class="hero-text">
            这个项目按照题目要求整理了三组 HTML 基础练习内容，每一组都可以直接在浏览器中打开、点击和测试。
        </p>
        <div class="hero-actions">
            <a class="button primary" href="html-basics.html">开始第一组</a>
            <a class="button secondary" href="hello-servlet">查看 Servlet 示例</a>
        </div>
    </header>

    <main class="card-grid">
        <article class="card">
            <span class="card-index">01</span>
            <h2>HTML 基础标签</h2>
            <p>包含注释、CSS、链接、图像、表格和列表，适合做第一轮静态页面练习。</p>
            <a class="text-link" href="html-basics.html">打开第一组页面</a>
        </article>

        <article class="card">
            <span class="card-index">02</span>
            <h2>HTML 表单</h2>
            <p>覆盖表单、表单元素、输入类型和常见输入属性，并支持提交到本地 Servlet 回显。</p>
            <a class="text-link" href="html-forms.html">打开第二组页面</a>
        </article>

        <article class="card">
            <span class="card-index">03</span>
            <h2>HTML 进阶主题</h2>
            <p>演示框架、内联框架、背景、脚本、头部、实体、URL 和 URL 编码。</p>
            <a class="text-link" href="html-advanced.jsp">打开第三组页面</a>
        </article>

        <article class="card">
            <span class="card-index">04</span>
            <h2>Servlet 处理表单</h2>
            <p>定义一个学生信息登记表，并交给专门的 Servlet 接收和展示提交结果。</p>
            <a class="text-link" href="student-form.html">打开下一课任务</a>
        </article>
    </main>

    <section class="card">
        <h2>浏览器测试建议</h2>
        <ul class="feature-list">
            <li>先按顺序打开三个页面，确认样式、图片、链接和表单都能正常工作。</li>
            <li>在第一组页面使用“查看网页源代码”，可以看到 HTML 注释的写法。</li>
            <li>在第二组页面提交表单，观察 Servlet 如何接收并显示数据。</li>
            <li>在第三组页面点击 URL 示例链接，观察浏览器地址栏中的编码结果。</li>
        </ul>
    </section>
</div>
</body>
</html>
