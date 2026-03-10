<%@ page import="com.example.backend_development.FileUploadRecordVO" %>
<%@ page import="com.example.backend_development.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<FileUploadRecordVO> records = (List<FileUploadRecordVO>) request.getAttribute("records");
    String status = (String) request.getAttribute("status");
    String targetId = (String) request.getAttribute("targetId");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第十一章：文件下载</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/site.css">
</head>
<body class="theme-section">
<div class="page-shell wide-shell">
    <header class="page-header">
        <p class="eyebrow">Chapter 11</p>
        <h1>文件下载</h1>
        <p class="section-intro">
            第十一章基于第十章的上传记录完成三项下载任务：最简单的下载实现、最经典的下载实现，以及导出数据库数据并下载。
        </p>
        <nav class="page-nav">
            <a href="<%= request.getContextPath() %>/index.jsp">返回首页</a>
            <a href="<%= request.getContextPath() %>/file-upload">回到第十章</a>
            <a href="<%= request.getContextPath() %>/central-controller/list">下一章：中央控制器</a>
            <a href="<%= request.getContextPath() %>/file-download">刷新下载页</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>任务对应</h2>
            <ul class="feature-list">
                <li>最简单的下载实现：<code>/file-download-simple</code> 直接按文件主键读取路径并把文件流写回浏览器。</li>
                <li>最经典的下载实现：<code>/file-download-classic</code> 设置 <code>Content-Disposition</code>、文件长度和缓冲流，强制浏览器以附件形式下载。</li>
                <li>导出数据并下载：<code>/student-export</code> 把数据库中的学生记录导出为 CSV，再直接下载。</li>
            </ul>
        </section>

        <% if ("invalid".equals(status)) { %>
        <section class="status-banner danger">
            下载失败：请求中的主键参数不合法，收到的值是 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong>。
        </section>
        <% } else if ("notfound".equals(status)) { %>
        <section class="status-banner warning">
            下载失败：没有找到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 的上传记录。
        </section>
        <% } else if ("missingFile".equals(status)) { %>
        <section class="status-banner danger">
            下载失败：数据库里有记录，但服务器磁盘中已经找不到主键为 <strong><%= HtmlUtil.escapeHtml(HtmlUtil.defaultText(targetId)) %></strong> 对应的文件。
        </section>
        <% } %>

        <section class="card">
            <div class="section-toolbar">
                <div>
                    <h2>导出数据下载</h2>
                    <p class="note">这里演示“导出数据库数据并下载”，当前实现会把学生信息表导出为 CSV 文件并触发浏览器下载。</p>
                </div>
                <div class="button-row">
                    <a class="button primary" href="<%= request.getContextPath() %>/student-export">导出学生数据 CSV</a>
                    <a class="button secondary" href="<%= request.getContextPath() %>/student-query">查看学生查询页</a>
                </div>
            </div>
        </section>

        <section class="card">
            <h2>上传文件下载列表</h2>
            <% if (records == null || records.isEmpty()) { %>
            <p class="note">当前还没有上传记录。先去第十章上传一个文件，再回到这里测试简单下载和经典下载。</p>
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
                                   href="<%= request.getContextPath() %>/file-download-simple?id=<%= record.getId() %>">
                                    简单下载
                                </a>
                                <a class="action-link secondary"
                                   href="<%= request.getContextPath() %>/file-download-classic?id=<%= record.getId() %>">
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
