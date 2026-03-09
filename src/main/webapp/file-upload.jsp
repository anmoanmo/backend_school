<%@ page import="com.example.backend_development.FileUploadRecordVO" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<FileUploadRecordVO> records = (List<FileUploadRecordVO>) request.getAttribute("records");
    String status = (String) request.getAttribute("status");
    String targetId = (String) request.getAttribute("targetId");
    String uploadRootDirectory = (String) request.getAttribute("uploadRootDirectory");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十章：文件上传</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 10</p>
        <h1>文件上传</h1>
        <p class="section-intro">
            第十章实现两件事：把文件上传到服务器指定目录，并把上传后的保存路径信息写入数据库表，形成完整的上传记录链路。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/student-jsp">回到第九章</a>
            <a href="<%= request.getContextPath() %>/file-download">下一章：文件下载</a>
            <a href="<%= request.getContextPath() %>/file-upload">刷新上传页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>服务器目录：Servlet 使用 Multipart 接收文件，并把文件保存到服务器本地目录 <code><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(uploadRootDirectory)) %></code>。</li>
                <li>数据库表：上传成功后，把原始文件名、服务器保存文件名、绝对路径、文件类型和大小写入 <code>uploaded_file_records</code> 表。</li>
                <li>浏览器验证：当前页面下方会直接显示上传记录，方便验证“文件落盘”和“路径入库”两项任务都已完成。</li>
            </ul>
        </section>

        <% if ("uploaded".equals(status)) { %>
        <section class="status-banner success">
            文件上传成功，数据库记录主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("missingFile".equals(status)) { %>
        <section class="status-banner danger">
            上传失败：你还没有选择文件，或者提交的文件为空。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>上传表单</h2>
                    <p class="note">表单必须使用 <code>multipart/form-data</code>，Servlet 通过 <code>request.getPart(...)</code> 获取上传文件。</p>
                </div>
                <div class="parameter-grid upload-summary-grid">
                    <div class="parameter-card">
                        <span>上传目录</span>
                        <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(uploadRootDirectory)) %></strong>
                    </div>
                    <div class="parameter-card">
                        <span>单文件限制</span>
                        <strong>10 MB</strong>
                    </div>
                </div>
            </div>

            <form class="demo-form" action="<%= request.getContextPath() %>/file-upload" method="post" enctype="multipart/form-data">
                <fieldset>
                    <legend>选择文件</legend>

                    <label class="full-width">
                        <span>上传文件</span>
                        <input type="file" name="uploadFile" required>
                    </label>
                </fieldset>

                <div class="button-row">
                    <button class="button primary" type="submit">上传文件并写入数据库</button>
                    <button class="button secondary" type="reset">清空选择</button>
                </div>
            </form>
        </section>

        <section class="card">
            <h2>上传记录</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">当前还没有文件上传记录。先提交一个文件，再回到这里查看服务器路径和数据库记录。</p>
            <% } else { %>
            <div class="table-scroll">
                <table class="demo-table demo-table-upload">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>原始文件名</th>
                        <th>服务器文件名</th>
                        <th>保存路径</th>
                        <th>文件类型</th>
                        <th>大小</th>
                        <th>上传时间</th>
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
                        <td><%= HtmlUtil.escapeHtml(record.getCreatedAt() == null ? "未记录" : record.getCreatedAt().toString()) %></td>
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
