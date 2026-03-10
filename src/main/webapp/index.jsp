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
            这个项目按“前端基础到后端数据管理”的顺序整理了当前十五章课程任务。每一章都保留了可直接浏览和测试的页面，也把 Servlet、VO、DAO、JDBC、本地 MySQL、中央控制器架构、登录鉴权、过滤器控制和监听器应用串成了一个完整示例。
        </p>
        <div class="hero-actions">
            <a class="button primary" href="html-basics.html">从第一章开始</a>
            <a class="button secondary" href="listener-demo.jsp">直达第十五章</a>
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

        <article class="card">
            <span class="card-index">08</span>
            <h2>第八章 Servlet 交互</h2>
            <p>把增删改查统一到一个总控页中，并在同一章里演示 forward、sendRedirect 和 include 三种交互方式。</p>
            <div class="link-list">
                <a class="text-link" href="student-interaction">第八章总控页</a>
                <a class="text-link" href="student-interaction?action=new">第八章新增入口</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">09</span>
            <h2>第九章 JSP 开发</h2>
            <p>把查询结果页面和修改数据显示页面改造成 JSP 视图层版本，并通过 JSP 片段减少页面重复代码。</p>
            <div class="link-list">
                <a class="text-link" href="student-jsp">第九章查询页</a>
                <a class="text-link" href="student-jsp?action=new">第九章表单页</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">10</span>
            <h2>第十章 文件上传</h2>
            <p>使用 Multipart 方式把文件上传到服务器指定目录，并把保存路径信息写入数据库表。</p>
            <div class="link-list">
                <a class="text-link" href="file-upload">第十章文件上传页</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">11</span>
            <h2>第十一章 文件下载</h2>
            <p>实现简单下载、经典下载以及数据库数据导出下载，并复用第十章的上传记录作为文件来源。</p>
            <div class="link-list">
                <a class="text-link" href="file-download">第十一章文件下载页</a>
                <a class="text-link" href="student-export">导出学生数据 CSV</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">12</span>
            <h2>第十二章 中央控制器架构</h2>
            <p>把学生管理和文件管理升级为统一入口的 Front Controller 结构，由中央控制器按路径分发列表、表单、保存、删除、上传和下载动作。</p>
            <div class="link-list">
                <a class="text-link" href="central-controller/list">中央控制器列表页</a>
                <a class="text-link" href="central-controller/form">中央控制器表单页</a>
                <a class="text-link" href="central-controller/files">中央控制器文件模块</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">13</span>
            <h2>第十三章 登录的实现</h2>
            <p>实现登录表单、登录动作处理、用户名密码验证和错误信息提示，并通过会话保护第十二章中央控制器。</p>
            <div class="link-list">
                <a class="text-link" href="login">第十三章登录页</a>
                <a class="text-link" href="logout">退出登录</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">14</span>
            <h2>第十四章 过滤器和登录控制</h2>
            <p>定义过滤器、配置过滤器，并在过滤器中验证用户是否处于登录状态，再决定是否放行到第十二章中央控制器。</p>
            <div class="link-list">
                <a class="text-link" href="filter-control.jsp">第十四章过滤器页</a>
                <a class="text-link" href="central-controller/list">受保护资源入口</a>
            </div>
        </article>

        <article class="card">
            <span class="card-index">15</span>
            <h2>第十五章 监听器的应用</h2>
            <p>定义监听器、配置监听器，并把监听器应用到应用启动时间统计、会话统计和登录状态统计中。</p>
            <div class="link-list">
                <a class="text-link" href="listener-demo.jsp">第十五章监听器页</a>
                <a class="text-link" href="login?redirect=%2Flistener-demo.jsp">登录后查看监听器统计</a>
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
            <li>第八章进入总控页，观察 forward 进表单、sendRedirect 回列表、include 统计片段这三种交互如何配合完成完整 CRUD。</li>
            <li>第九章进入 JSP 查询页和 JSP 表单页，确认查询表格和修改回显都已经收口到 JSP 页面和 JSP 片段中。</li>
            <li>第十章上传一个文件，确认文件已经保存到服务器目录，并且上传路径信息已经进入数据库表。</li>
            <li>第十一章测试简单下载、经典下载和 CSV 导出下载，确认三种下载方式都能触发浏览器获取文件。</li>
            <li>第十二章进入中央控制器页，观察学生管理与文件管理如何统一进入一个入口，再按路径分发到列表、表单、保存、删除、上传和下载动作。</li>
            <li>第十三章先访问登录页，再登录进入中央控制器，确认用户名密码验证、错误提示和退出登录都能正常工作。</li>
            <li>第十四章打开过滤器页，观察过滤器定义、过滤器配置，以及未登录访问受保护资源时如何被拦截并重定向到登录页。</li>
            <li>第十五章打开监听器页，观察监听器定义、监听器配置，以及应用启动时间、会话数和已登录会话数如何随操作变化。</li>
            <li>根目录中的 README 负责说明整体结构，本地数据库信息保存在不上传的 `.local` 文档中。</li>
        </ul>
    </section>
</div>
</body>
</html>
