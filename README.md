# 后端服务开发基础课程项目

这个项目把当前已经完成的课程任务整理成一个递进式 JavaWeb 示例，从 HTML 基础一直走到 Servlet + JDBC + MySQL 查询、删除、按主键修改、交互整合、JSP 视图开发、文件上传和文件下载。

## 章节结构

### 第一章：HTML 基础

- 页面入口：`src/main/webapp/html-basics.html`
- 练习内容：HTML 注释、CSS、链接、图像、表格、列表

### 第二章：表单与页面进阶

- 页面入口：`src/main/webapp/html-forms.html`
- 页面入口：`src/main/webapp/html-advanced.jsp`
- 练习内容：表单、输入类型、输入属性、框架、脚本、实体、URL、URL 编码

### 第三章：Servlet 处理表单

- 表单页面：`src/main/webapp/student-form.html`
- 处理 Servlet：`src/main/java/com/example/backend_development/StudentFormServlet.java`
- 结果页面：`src/main/webapp/student-form-result.jsp`
- 关键知识点：`request.getParameter`、`request.getParameterValues`、Servlet 转发到 JSP

### 第四章：JDBC 表单入库

- 表单入口：`src/main/java/com/example/backend_development/StudentDbServlet.java` 的 `GET /student-db-form`
- 共用表单页面：`src/main/webapp/student-db-form.jsp`
- 兼容跳转页面：`src/main/webapp/student-db-form.html`
- 入库 Servlet：`src/main/java/com/example/backend_development/StudentDbServlet.java`
- 结果页面：`src/main/webapp/student-db-result.jsp`
- VO：`src/main/java/com/example/backend_development/StudentRecordVO.java`
- DAO：`src/main/java/com/example/backend_development/StudentRecordDao.java`
- 数据库初始化：`src/main/java/com/example/backend_development/DatabaseUtil.java`
- 建表 SQL：`src/main/resources/db/student_form.sql`

### 第五章：查询并显示到浏览器

- 查询 Servlet：`src/main/java/com/example/backend_development/StudentQueryServlet.java`
- 兼容跳转 Servlet：`src/main/java/com/example/backend_development/StudentDbListServlet.java`
- 查询页面：`src/main/webapp/student-query.jsp`
- 关键知识点：DAO 查询全部记录、`List<StudentRecordVO>` 返回、Servlet 转发、JSP 表格渲染

### 第六章：根据主键删除记录

- 管理 Servlet：`src/main/java/com/example/backend_development/StudentManageServlet.java`
- 删除 Servlet：`src/main/java/com/example/backend_development/StudentDeleteServlet.java`
- 管理页面：`src/main/webapp/student-manage.jsp`
- 关键知识点：DAO 根据主键删除、Servlet 接收主键参数、表格构造删除链接

### 第七章：根据主键修改记录

- 修改列表 Servlet：`src/main/java/com/example/backend_development/StudentUpdateServlet.java`
- 共用保存 Servlet：`src/main/java/com/example/backend_development/StudentDbServlet.java`
- 修改列表页面：`src/main/webapp/student-update.jsp`
- 共用表单页面：`src/main/webapp/student-db-form.jsp`
- DAO 关键方法：`findById(long id)`、`update(StudentRecordVO record)`
- 关键知识点：根据主键查询单条记录、表单回显、插入和修改共用同一个保存入口

### 第八章：Servlet 交互

- 总控 Servlet：`src/main/java/com/example/backend_development/StudentInteractionServlet.java`
- include 统计 Servlet：`src/main/java/com/example/backend_development/StudentInteractionSummaryServlet.java`
- 总控页面：`src/main/webapp/student-interaction.jsp`
- 第八章表单页：`src/main/webapp/student-interaction-form.jsp`
- 关键知识点：`forward` 转发表单/列表、`sendRedirect` 防止重复提交、`include` 引入统计片段、把增删改查统一到一页中联动

### 第九章：JSP 开发

- 第九章 Servlet：`src/main/java/com/example/backend_development/StudentJspServlet.java`
- JSP 查询页：`src/main/webapp/student-jsp-query.jsp`
- JSP 表单页：`src/main/webapp/student-jsp-form.jsp`
- JSP 片段：`src/main/webapp/WEB-INF/jspf/student-jsp-status.jspf`
- JSP 片段：`src/main/webapp/WEB-INF/jspf/student-jsp-query-table.jspf`
- JSP 片段：`src/main/webapp/WEB-INF/jspf/student-jsp-form-fields.jspf`
- 关键知识点：Servlet 准备数据后 forward 到 JSP、查询结果表格改造为 JSP 页面、修改数据显示表单改造为 JSP 页面、通过 JSP 片段复用视图结构

### 第十章：文件上传

- 上传 Servlet：`src/main/java/com/example/backend_development/FileUploadServlet.java`
- 文件元数据 VO：`src/main/java/com/example/backend_development/FileUploadRecordVO.java`
- 文件元数据 DAO：`src/main/java/com/example/backend_development/FileUploadRecordDao.java`
- 文件存储工具：`src/main/java/com/example/backend_development/FileStorageUtil.java`
- 上传页面：`src/main/webapp/file-upload.jsp`
- 数据库表：`uploaded_file_records`
- 默认上传目录：`D:\school_work\backend_development\uploads`
- 关键知识点：`multipart/form-data`、`request.getPart(...)`、服务器本地目录落盘、上传路径信息入库

### 第十一章：文件下载

- 下载列表页 Servlet：`src/main/java/com/example/backend_development/FileDownloadPageServlet.java`
- 简单下载 Servlet：`src/main/java/com/example/backend_development/FileDownloadSimpleServlet.java`
- 经典下载 Servlet：`src/main/java/com/example/backend_development/FileDownloadClassicServlet.java`
- 数据导出 Servlet：`src/main/java/com/example/backend_development/StudentExportServlet.java`
- 下载页面：`src/main/webapp/file-download.jsp`
- 关键知识点：最简单的文件流下载、`Content-Disposition` 经典下载、数据库数据导出为 CSV 并下载

## 项目入口

- 首页：`src/main/webapp/index.jsp`
- 基础 Servlet 示例：`src/main/java/com/example/backend_development/HelloServlet.java`
- HTML 表单回显示例：`src/main/java/com/example/backend_development/FormEchoServlet.java`

## 结构优化说明

- 学生表单参数映射统一收口到 `StudentRecordMapper`
- HTML 转义和默认文本处理统一收口到 `HtmlUtil`
- 第三章和第四章的结果页改为 JSP，避免在 Servlet 中维护大量 `out.println`
- 首页按章节组织，便于按课程顺序演示

## 本地运行

### 环境要求

- JDK 23
- Tomcat 10.1.x
- 本地 MySQL（当前项目已适配 WSL 中的 MySQL）

### 构建

```powershell
.\mvnw.cmd package
```

### 数据库配置

- 运行时读取：`src/main/resources/db/mysql.local.properties`
- 配置模板：`src/main/resources/db/mysql.properties.example`
- 这个文件带有 `.local`，不会提交到 Git
- 本地数据库账号信息另外保存在根目录 `DATABASE_SETUP.local.md`

## 当前数据库方案

- 数据库类型：MySQL
- 用途：第四章 JDBC 表单入库 + 第五章 查询显示
- 连接方式：Windows 中运行的 Tomcat 连接 `127.0.0.1:3306`
- 数据库表：`student_form_records`

## 建议演示顺序

1. 从首页依次打开第一章和第二章页面，展示 HTML 基础能力
2. 提交第三章学生表单，展示 Servlet 获取请求参数
3. 提交第四章数据库表单，展示 JDBC 入库
4. 打开第五章查询页面，展示 DAO 查询结果如何以表格方式显示到浏览器
5. 打开第六章管理页面，点击删除链接，展示主键参数如何驱动删除逻辑
6. 打开第七章修改页面，点击“修改”链接，展示记录回显和数据库更新流程
7. 打开第八章总控页，体验 forward 进入表单、sendRedirect 回总控页、include 统计片段，以及一站式增删改查
8. 打开第九章 JSP 查询页和 JSP 表单页，体验 JSP 页面和 JSP 片段如何接管查询显示与修改回显
9. 打开第十章上传页，上传一个文件并检查服务器目录和数据库记录
10. 打开第十一章下载页，测试简单下载、经典下载和 CSV 导出下载
