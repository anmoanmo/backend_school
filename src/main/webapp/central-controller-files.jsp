<%@ page import="com.example.backend_development.AuthSessionUtil" %>
<%@ page import="com.example.backend_development.FileUploadRecordVO" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<FileUploadRecordVO> records = (List<FileUploadRecordVO>) request.getAttribute("records");
    String status = (String) request.getAttribute("status");
    String targetId = (String) request.getAttribute("targetId");
    String requestedAction = (String) request.getAttribute("requestedAction");
    String uploadRootDirectory = (String) request.getAttribute("uploadRootDirectory");
    String currentUser = AuthSessionUtil.getAuthenticatedUsername(session);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十二章：中央控制器文件模块</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 12 Files</p>
        <h1>中央控制器中的文件上传与下载</h1>
        <p class="section-intro">
            在保留第十章和第十一章原有要求不变的前提下，这一页把文件上传、简单下载、经典下载和数据导出统一接入第十二章中央控制器。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/central-controller/list">回到中央控制器学生模块</a>
            <a href="<%= request.getContextPath() %>/file-upload">对照第十章原入口</a>
            <a href="<%= request.getContextPath() %>/file-download">对照第十一章原入口</a>
            <a href="<%= request.getContextPath() %>/logout">退出登录（<%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(currentUser)) %>）</a>
            <a href="<%= request.getContextPath() %>/central-controller/files">刷新文件模块页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>文件上传到服务器指定目录：统一通过 <code>POST /central-controller/file-upload</code> 接收 <code>multipart/form-data</code> 表单。</li>
                <li>文件上传后的保存路径信息写入数据库表：上传成功后仍然写入 <code>uploaded_file_records</code>。</li>
                <li>最简单的下载实现：通过 <code>/central-controller/file-download-simple?id=主键</code> 直接回写文件流。</li>
                <li>最经典的下载实现：通过 <code>/central-controller/file-download-classic?id=主键</code> 设置附件头并缓冲输出。</li>
                <li>导出数据库并下载：通过 <code>/central-controller/export-students</code> 导出学生数据 CSV。</li>
            </ul>
        </section>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>中央控制器文件路由</h2>
                    <p class="note">和学生模块一样，文件模块也统一从中央控制器分发，不再为每个动作单独暴露一个独立业务 Servlet 作为主入口。</p>
                </div>
                <div class="parameter-grid upload-summary-grid">
                    <div class="parameter-card">
                        <span>文件首页</span>
                        <strong>/central-controller/files</strong>
                    </div>
                    <div class="parameter-card">
                        <span>上传动作</span>
                        <strong>POST /central-controller/file-upload</strong>
                    </div>
                    <div class="parameter-card">
                        <span>简单下载</span>
                        <strong>/central-controller/file-download-simple</strong>
                    </div>
                    <div class="parameter-card">
                        <span>经典下载</span>
                        <strong>/central-controller/file-download-classic</strong>
                    </div>
                </div>
            </div>
        </section>

        <% if ("uploaded".equals(status)) { %>
        <section class="status-banner success">
            文件上传成功，数据库记录主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("missingFile".equals(status)) { %>
        <section class="status-banner danger">
            上传或下载失败：没有选择文件，或者服务器磁盘中已经找不到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的文件。
        </section>
        <% } else if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            请求中的主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的上传记录。
        </section>
        <% } else if ("invalidAction".equals(status)) { %>
        <section class="status-banner danger">
            中央控制器无法识别文件动作 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(requestedAction)) %></strong>。
        </section>
        <% } else if ("invalidMethod".equals(status)) { %>
        <section class="status-banner danger">
            当前文件动作只允许使用指定的 HTTP 方法，请从当前页面提供的入口重新发起请求。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>上传表单</h2>
                    <p class="note">文件仍然保存到项目目录下的 <code><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(uploadRootDirectory)) %></code>，要求与第十章保持一致。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/central-controller/export-students">导出学生数据 CSV</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-query">查看学生查询页</a>
                </div>
            </div>

            <form class="demo-form" action="<%= request.getContextPath() %>/central-controller/file-upload" method="post" enctype="multipart/form-data">
                <fieldset>
                    <legend>选择文件</legend>

                    <label class="full-width">
                        <span>上传文件</span>
                        <input type="file" name="uploadFile" required>
                    </label>
                </fieldset>

                <div class="button-row">
                    <button class="button primary" type="submit">通过中央控制器上传文件</button>
                    <button class="button secondary" type="reset">清空选择</button>
                </div>
            </form>
        </section>

        <section class="card">
            <h2>上传记录与下载入口</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">当前还没有上传记录。先上传一个文件，再测试简单下载、经典下载和导出下载。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-download">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>原始文件名</th>
                        <th>服务器文件名</th>
                        <th>保存路径</th>
                        <th>文件类型</th>
                        <th>大小</th>
                        <th>下载方式</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (FileUploadRecordVO record : records) { %>
                    <tr>
                        <td><%= record.getId() %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getOriginalFileName())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStoredFileName())) %></td>
                        <td class="path-cell"><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getStoragePath())) %></td>
                        <td><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(record.getContentType())) %></td>
                        <td><%= record.getFileSize() == null ? "0 B" : record.getFileSize() + " B" %></td>
                        <td>
                            <div class="action-stack">
                                <a class="action-link primary"
                                   href="<%= request.getContextPath() %>/central-controller/file-download-simple?id=<%= record.getId() %>">
                                    简单下载
                                </a>
                                <a class="action-link secondary"
                                   href="<%= request.getContextPath() %>/central-controller/file-download-classic?id=<%= record.getId() %>">
                                    经典下载
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>
