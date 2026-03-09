<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后端服务开发基础课程项目</title>
    <link rel="stylesheet" href="assets/css/site.css">
</head>
<body class="theme-home">
<div class="page-shell">
    <header class="hero">
        <p class="eyebrow">Backend Development Basics</p>
        <h1>后端服务开发基础课程项目</h1>
        <p class="hero-text">
            这个项目按“前端基础到后端数据管理”的顺序整理了当前七章课程任务。每一章都保留了可直接浏览和测试的页面，也把 Servlet、VO、DAO、JDBC 和本地 MySQL 串成了一个完整示例。
        </p>
        <div class="hero-actions">
            <a class="button primary" href="html-basics.html">从第一章开始</a>
            <a class="button secondary" href="student-update">直达第七章</a>
        </div>
    </header>

    <main class="card-grid">
        <article class="card">
            <span class="card-index">01</span>
            <h2>第一章 HTML 基础</h2>
            <p>练习 HTML 注释、CSS、链接、图像、表格和列表，完成最基础的静态页面编写。</p>
            <div class="link-list">
                <a class="text-link" href="html-basics.html">基础标签页面</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">02</span>
            <h2>第二章 表单与页面进阶</h2>
            <p>在表单页面里练输入控件和属性，在进阶页面里练框架、脚本、实体、URL 和编码。</p>
            <div class="link-list">
                <a class="text-link" href="html-forms.html">HTML 表单页面</a>
                <a class="text-link" href="html-advanced.jsp">HTML 进阶页面</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">03</span>
            <h2>第三章 Servlet 处理表单</h2>
            <p>定义学生信息登记表，由 Servlet 接收表单数据，再转发到 JSP 结果页展示请求参数。</p>
            <div class="link-list">
                <a class="text-link" href="student-form.html">学生登记表</a>
                <a class="text-link" href="hello-servlet">基础 Servlet 示例</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">04</span>
            <h2>第四章 JDBC 表单入库</h2>
            <p>把表单数据封装为 VO，通过 DAO 和 JDBC 写入本地 MySQL，完成数据插入流程。</p>
            <div class="link-list">
                <a class="text-link" href="student-db-form">数据库录入页面</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">05</span>
            <h2>第五章 查询并显示到浏览器</h2>
            <p>DAO 查询数据库表中的全部记录，Servlet 调用查询方法，并把结果以表格形式显示在浏览器中。</p>
            <div class="link-list">
                <a class="text-link" href="student-query">第五章查询页面</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">06</span>
            <h2>第六章 根据主键删除</h2>
            <p>在第五章的表格基础上追加删除链接，由 Servlet 接收主键参数并调用 DAO 删除指定记录。</p>
            <div class="link-list">
                <a class="text-link" href="student-manage">第六章管理页面</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">07</span>
            <h2>第七章 根据主键修改</h2>
            <p>根据主键查询单条记录，把原始数据回显到表单中，再通过同一个保存 Servlet 完成数据库更新。</p>
            <div class="link-list">
                <a class="text-link" href="student-update">第七章修改页面</a>
                <a class="text-link" href="student-db-form">共用新增/修改表单</a>
            </div>
        </article>
    </main>

    <section class="card">
        <h2>课程测试建议</h2>
        <ul class="feature-list">
            <li>先做第一章和第二章，确认页面结构、链接、脚本和表单控件都能正常显示。</li>
            <li>第三章提交学生登记表后，观察 Servlet 如何接收参数并转发到 JSP 结果页。</li>
            <li>第四章提交数据库表单后，再进入第五章查询页，确认数据已经进入本地 MySQL 并能显示到浏览器。</li>
            <li>第六章在管理页点击删除链接，观察 URL 中的主键参数如何传入 Servlet 并删除一条记录。</li>
            <li>第七章在修改页点击“修改”，确认表单会自动回显原记录，提交后更新数据库中的对应行。</li>
            <li>根目录中的 README 负责说明整体结构，本地数据库信息保存在不上传的 `.local` 文档中。</li>
        </ul>
    </section>
</div>
</body>
</html>
