# 后端服务开发基础课程项目

这个项目把当前已经完成的课程任务整理成一个递进式 JavaWeb 示例，从 HTML 基础一直走到 Servlet + JDBC + MySQL 查询、删除、按主键修改和交互整合。

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
