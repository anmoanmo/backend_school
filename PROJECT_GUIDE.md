# 项目讲解文档

## 1. 项目整体是什么

这个项目是一个典型的 JavaWeb 课程项目，使用的是：

- `Jakarta Servlet`
- `JSP`
- `JDBC`
- `MySQL`
- `Maven`
- `Tomcat`

它不是前后端彻底分离的 `Vue/React + REST API` 项目，而是传统的服务端渲染项目：

1. 浏览器访问某个 URL。
2. Tomcat 把请求交给对应的 `Servlet`。
3. `Servlet` 负责接收参数、执行业务逻辑、调用数据库。
4. `Servlet` 再把数据放进 `request`，转发给 `JSP`。
5. `JSP` 在服务器上拼出最终 HTML。
6. 浏览器拿到的是已经渲染好的页面。

所以，这个项目里“前后端连接”的核心不是接口文档，而是：

- URL 路由
- 表单提交
- `request.getParameter(...)`
- `request.setAttribute(...)`
- `RequestDispatcher.forward(...)`
- `response.sendRedirect(...)`

---

## 2. 项目目录怎么读

### 2.1 根目录的作用

- `pom.xml`
  - Maven 工程配置，定义依赖、Java 版本、WAR 打包方式。
- `README.md`
  - 当前项目的章节说明和运行说明。
- `PROJECT_GUIDE.md`
  - 这份详细讲解文档。
- `.gitignore`
  - 告诉 Git 哪些文件不上传，比如 `target/`、IDE 配置、本地数据库配置、上传文件。
- `DATABASE_SETUP.local.md`
  - 本地数据库说明，属于本机使用信息，不适合公开提交。
- `mvnw` / `mvnw.cmd`
  - Maven Wrapper，机器上就算没全局配置 Maven，也能直接构建项目。
- `.mvn/wrapper/maven-wrapper.properties`
  - Wrapper 配置。
- `.mvn/wrapper/maven-wrapper.jar`
  - Wrapper 运行所需 Jar。
- `uploads/`
  - 文件上传保存目录。
- `uploads/.gitkeep`
  - 让空目录也能保留在 Git 中。

### 2.2 源码目录的作用

- `src/main/java`
  - 放后端 Java 代码。
- `src/main/resources`
  - 放资源文件，这里主要是数据库配置和建表 SQL。
- `src/main/webapp`
  - 放前端页面、JSP、CSS、JS、图片、`WEB-INF/web.xml`。

### 2.3 JavaWeb 工程中最关键的三个目录

- `src/main/java`
  - 处理请求、业务逻辑、数据库访问。
- `src/main/resources`
  - 配置与 SQL。
- `src/main/webapp`
  - 浏览器实际会访问到的页面资源，以及 JSP 页面。

---

## 3. 项目最核心的运行链路

### 3.1 项目启动后的首页链路

当前根路径的处理链路是：

```text
浏览器访问 /
-> index.jsp
-> <jsp:forward page="/complete-project/home" />
-> CompleteProjectServlet
-> /WEB-INF/complete-project/home.jsp
-> 返回完整项目首页 HTML
```

对应文件位置：

- `src/main/webapp/index.jsp`
- `src/main/java/com/example/backend_development/CompleteProjectServlet.java`
- `src/main/webapp/WEB-INF/complete-project/home.jsp`

### 3.2 学生表单入库的核心链路

```text
浏览器打开 /student-db-form
-> StudentDbServlet#doGet
-> 转发到 student-db-form.jsp
-> 用户填写表单并提交 POST /student-db-form
-> StudentRecordMapper.fromRequest(request)
-> StudentRecordDao.insert(...) 或 update(...)
-> DatabaseUtil.getConnection()
-> MySQL
-> StudentDbServlet 转发到 student-db-result.jsp
-> 浏览器看到结果
```

### 3.3 文件上传的核心链路

```text
浏览器打开 /file-upload
-> FileUploadServlet#doGet
-> 转发到 file-upload.jsp
-> 表单提交 multipart/form-data 到 /file-upload
-> request.getPart("uploadFile")
-> FileStorageUtil.store(...)
-> 文件保存到 D:\school_work\backend_development\uploads\年\月\日
-> FileUploadRecordDao.insert(...)
-> 上传记录写入 MySQL
-> 重定向回 /file-upload
```

### 3.4 中央控制器的核心链路

```text
浏览器访问 /central-controller/list
-> CentralControllerServlet
-> 根据 pathInfo 识别动作为 list
-> handleList(...)
-> StudentRecordDao.queryAllRecords()
-> forward 到 central-controller-list.jsp
```

---

## 4. 根目录文件逐个说明

| 文件 | 作用 |
| --- | --- |
| `pom.xml` | Maven 核心配置，定义 `war` 打包、Java 23、Servlet API、JUnit、MySQL 驱动。 |
| `README.md` | 项目总览和章节摘要，偏“使用说明”。 |
| `PROJECT_GUIDE.md` | 这份完整讲解文档，偏“源码导读”。 |
| `.gitignore` | 忽略构建产物、IDE 配置、上传文件、本地敏感配置。 |
| `DATABASE_SETUP.local.md` | 本地数据库账号、库名、使用方式说明，只适合本机保存。 |
| `mvnw` | Linux/macOS 下执行 Maven Wrapper。 |
| `mvnw.cmd` | Windows 下执行 Maven Wrapper。 |
| `.mvn/wrapper/maven-wrapper.properties` | 指定 Wrapper 使用的 Maven 发行版。 |
| `.mvn/wrapper/maven-wrapper.jar` | Wrapper 的执行文件。 |
| `uploads/.gitkeep` | 保留上传目录结构。 |

补充说明：

- `uploads/2026/...` 这类具体上传文件不是源码，而是运行时产生的数据。
- 它们体现的是第十章、第十一章功能结果，不属于项目实现代码本身。

---

## 5. Java 源码文件逐个说明

下面按模块讲。

### 5.1 基础工具和公共类

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/HtmlUtil.java` | 公共字符串工具，负责 HTML 转义、默认文本、字符串裁剪、复选框值拼接。 |
| `src/main/java/com/example/backend_development/ControllerResult.java` | 第十二章中央控制器返回值对象，用来统一表示“forward 还是 redirect，以及跳到哪里”。 |
| `src/main/java/com/example/backend_development/DatabaseUtil.java` | 项目的数据库总入口。负责加载 MySQL 驱动、读取数据库配置、提供 JDBC 连接、首次执行建表 SQL。 |
| `src/main/java/com/example/backend_development/AuthSessionUtil.java` | 会话工具，负责判断是否登录、写入登录用户、退出登录、读取当前用户名。 |

### 5.2 最早期基础示例

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/HelloServlet.java` | 最基础的 Servlet 示例，访问后直接输出一段 HTML。用于理解 Servlet 生命周期和 `doGet()`。 |
| `src/main/java/com/example/backend_development/FormEchoServlet.java` | 简单表单回显示例，用于说明表单参数如何在 Servlet 中被接收和显示。 |

### 5.3 学生信息核心数据模型

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/StudentRecordVO.java` | 学生记录的 VO，对应数据库里的学生表一行数据。字段包括学号、姓名、性别、年龄、专业、班级等。 |
| `src/main/java/com/example/backend_development/StudentRecordMapper.java` | 把 `HttpServletRequest` 里的表单参数统一转换成 `StudentRecordVO`。这是表单到业务对象的关键连接点。 |
| `src/main/java/com/example/backend_development/StudentRecordDao.java` | 学生数据 DAO，负责增删改查 SQL。真正和 `student_form_records` 表打交道的类。 |

### 5.4 第三章到第九章的学生业务 Servlet

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/StudentFormServlet.java` | 第三章 Servlet，处理普通表单提交，不入库，只显示提交结果。 |
| `src/main/java/com/example/backend_development/StudentDbServlet.java` | 第四章和第七章共用的保存 Servlet。`GET` 负责显示新增/修改表单，`POST` 负责入库或更新。 |
| `src/main/java/com/example/backend_development/StudentDbListServlet.java` | 兼容旧入口的跳转 Servlet，把旧查询路径跳转到新的查询页。 |
| `src/main/java/com/example/backend_development/StudentQueryServlet.java` | 第五章查询 Servlet，调用 DAO 查询全部学生记录并转发到 JSP。 |
| `src/main/java/com/example/backend_development/StudentManageServlet.java` | 第六章管理页 Servlet，负责显示带删除操作的列表。 |
| `src/main/java/com/example/backend_development/StudentDeleteServlet.java` | 第六章删除 Servlet，接收主键 `id`，调用 DAO 删除对应记录。 |
| `src/main/java/com/example/backend_development/StudentUpdateServlet.java` | 第七章修改入口页 Servlet，显示带“修改”链接的列表。 |
| `src/main/java/com/example/backend_development/StudentInteractionServlet.java` | 第八章交互总控 Servlet，把新增、删除、修改、查询串成一套流程。 |
| `src/main/java/com/example/backend_development/StudentInteractionSummaryServlet.java` | 第八章被 `include` 的统计 Servlet，用于演示 `include` 跳转。 |
| `src/main/java/com/example/backend_development/StudentJspServlet.java` | 第九章 JSP 开发 Servlet，把查询页和修改表单页交给 JSP 负责渲染。 |

### 5.5 文件上传、下载、导出模块

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/FileUploadRecordVO.java` | 文件上传记录 VO，对应一条文件元数据记录。 |
| `src/main/java/com/example/backend_development/FileUploadRecordDao.java` | 文件上传记录 DAO，负责把上传文件信息写入 `uploaded_file_records` 表，并查询下载列表。 |
| `src/main/java/com/example/backend_development/FileStorageUtil.java` | 文件物理存储工具，把上传文件落到项目根目录 `uploads/年/月/日`，并生成安全文件名。 |
| `src/main/java/com/example/backend_development/FileUploadServlet.java` | 第十章上传 Servlet，负责接收 `multipart/form-data`、保存文件、记录数据库信息。 |
| `src/main/java/com/example/backend_development/FileDownloadPageServlet.java` | 第十一章下载页面入口，负责查询文件列表并展示下载页。 |
| `src/main/java/com/example/backend_development/FileDownloadSimpleServlet.java` | 第十一章最简单下载实现，直接把文件流写回浏览器。 |
| `src/main/java/com/example/backend_development/FileDownloadClassicServlet.java` | 第十一章经典下载实现，设置 `Content-Disposition`，让浏览器按附件方式下载。 |
| `src/main/java/com/example/backend_development/StudentExportServlet.java` | 第十一章数据导出 Servlet，把学生表导出为 CSV 并下载。 |

### 5.6 第十二章到第十五章的整合与控制层

| 文件 | 作用 |
| --- | --- |
| `src/main/java/com/example/backend_development/CentralControllerServlet.java` | 第十二章中央控制器。统一接收 `/central-controller/*` 请求，再分发到不同动作处理器。 |
| `src/main/java/com/example/backend_development/CompleteProjectServlet.java` | 完整项目首页控制器，负责完整项目首页和章节目录页面。 |
| `src/main/java/com/example/backend_development/LoginService.java` | 登录校验服务，目前是演示版，账号密码写在类中：`admin / 123456`。 |
| `src/main/java/com/example/backend_development/LoginServlet.java` | 第十三章登录 Servlet，负责显示登录页、校验登录、登录后跳转。 |
| `src/main/java/com/example/backend_development/LogoutServlet.java` | 第十三章退出登录 Servlet，负责销毁会话。 |
| `src/main/java/com/example/backend_development/AuthFilter.java` | 第十四章过滤器，拦截 `/central-controller/*`，未登录则强制跳到登录页。 |
| `src/main/java/com/example/backend_development/ApplicationStatsListener.java` | 第十五章监听器，监听应用启动、会话创建/销毁、会话属性变化，并维护统计信息。 |

---

## 6. 前端页面文件逐个说明

### 6.1 第一章和第二章基础页面

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/html-basics.html` | HTML 基础演示页，覆盖注释、CSS、链接、图片、表格、列表。 |
| `src/main/webapp/html-forms.html` | 表单基础演示页，覆盖表单、输入类型、输入属性。 |
| `src/main/webapp/html-advanced.jsp` | 页面进阶演示页，覆盖脚本、实体、URL、编码、内联框架等。 |
| `src/main/webapp/legacy-frames.html` | 旧式框架示例页。 |
| `src/main/webapp/frame-nav.html` | 旧式框架中的导航页。 |
| `src/main/webapp/frame-home.html` | 旧式框架中的内容首页。 |

### 6.2 第三章到第九章学生模块页面

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/student-form.html` | 第三章表单页面，纯前端表单，提交给 `StudentFormServlet`。 |
| `src/main/webapp/student-form-result.jsp` | 第三章结果页，显示普通表单提交内容。 |
| `src/main/webapp/student-db-form.html` | 第四章旧入口兼容页，用来引导或跳转到新的数据库表单入口。 |
| `src/main/webapp/student-db-form.jsp` | 第四章和第七章共用表单页，既支持新增，也支持修改回显。 |
| `src/main/webapp/student-db-result.jsp` | 第四章和第七章保存完成后的结果提示页。 |
| `src/main/webapp/student-query.jsp` | 第五章查询结果页，以表格方式显示学生记录。 |
| `src/main/webapp/student-manage.jsp` | 第六章删除管理页，表格最后一列提供删除操作。 |
| `src/main/webapp/student-update.jsp` | 第七章修改入口页，表格最后一列提供修改链接。 |
| `src/main/webapp/student-interaction.jsp` | 第八章总控页，把增删改查组织在一个流程中。 |
| `src/main/webapp/student-interaction-form.jsp` | 第八章表单页，用于新增和修改。 |
| `src/main/webapp/student-jsp-query.jsp` | 第九章 JSP 查询结果页。 |
| `src/main/webapp/student-jsp-form.jsp` | 第九章 JSP 表单页，用于新增和修改。 |

### 6.3 第十章和第十一章文件模块页面

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/file-upload.jsp` | 第十章上传页，提供文件上传表单，并显示上传记录。 |
| `src/main/webapp/file-download.jsp` | 第十一章下载页，提供简单下载、经典下载、CSV 导出下载入口。 |

### 6.4 第十二章到第十五章整合页面

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/central-controller-list.jsp` | 第十二章中央控制器学生列表页。 |
| `src/main/webapp/central-controller-form.jsp` | 第十二章中央控制器学生表单页。 |
| `src/main/webapp/central-controller-files.jsp` | 第十二章中央控制器文件管理页。 |
| `src/main/webapp/login.jsp` | 第十三章登录页。 |
| `src/main/webapp/filter-control.jsp` | 第十四章过滤器演示页。 |
| `src/main/webapp/listener-demo.jsp` | 第十五章监听器演示页，显示监听器统计结果。 |

### 6.5 完整项目入口页面

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/index.jsp` | 根入口页面，只做一件事：转发到完整项目首页。 |
| `src/main/webapp/WEB-INF/complete-project/home.jsp` | 完整项目首页，集中展示学生模块、文件模块、登录状态和系统统计。 |
| `src/main/webapp/WEB-INF/complete-project/chapters.jsp` | 章节目录页，按章节列出原始课程任务入口。 |

### 6.6 JSP 片段和受保护页面

这些文件放在 `WEB-INF` 下，浏览器不能直接访问，必须由 Servlet 转发过去：

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/WEB-INF/jspf/student-jsp-status.jspf` | 第九章状态提示片段。 |
| `src/main/webapp/WEB-INF/jspf/student-jsp-query-table.jspf` | 第九章查询表格片段。 |
| `src/main/webapp/WEB-INF/jspf/student-jsp-form-fields.jspf` | 第九章表单字段片段。 |
| `src/main/webapp/WEB-INF/web.xml` | Web 应用配置文件，负责过滤器、监听器、JSP 编码配置。 |

### 6.7 静态资源

| 文件 | 作用 |
| --- | --- |
| `src/main/webapp/assets/css/site.css` | 全站样式文件，所有页面的布局和视觉风格基本都在这里。 |
| `src/main/webapp/assets/js/playground.js` | 前期 HTML 页面用到的简单交互脚本。 |
| `src/main/webapp/assets/images/html-basics.svg` | 第一章图片演示资源。 |

---

## 7. 资源文件和数据库文件逐个说明

| 文件 | 作用 |
| --- | --- |
| `src/main/resources/db/student_form.sql` | 建表 SQL，定义学生表 `student_form_records` 和文件表 `uploaded_file_records`。 |
| `src/main/resources/db/mysql.properties.example` | MySQL 配置模板，说明 URL、用户名、密码应该如何写。 |
| `src/main/resources/db/mysql.local.properties` | 当前机器的实际数据库配置，运行时会被 `DatabaseUtil` 读取。这个文件属于本地敏感配置。 |

---

## 8. 各个模块是如何实现的

### 8.1 第一章和第二章：HTML 基础模块

这一部分基本没有复杂后端逻辑，重点是前端基础页面练习。

实现方式：

1. 用 `html-basics.html`、`html-forms.html`、`html-advanced.jsp` 这些页面承载 HTML 练习内容。
2. `site.css` 提供样式。
3. `playground.js` 提供少量交互效果。
4. `html-basics.svg` 作为图片资源，演示 `<img>` 用法。

这一部分的作用是给后面真正的表单、JSP 页面、文件上传页面提供页面写法基础。

### 8.2 第三章：Servlet 处理普通表单

这一章的关键目标是理解：

- 表单怎么提交到 Servlet
- Servlet 怎么拿参数
- Servlet 怎么把数据转交给 JSP

实现链路：

```text
student-form.html
-> form action="/student-form"
-> StudentFormServlet
-> request.getParameter(...)
-> request.setAttribute(...)
-> forward 到 student-form-result.jsp
```

重点连接点：

- 前端表单页面：`student-form.html`
- 后端处理类：`StudentFormServlet.java`
- 结果页面：`student-form-result.jsp`

### 8.3 第四章到第七章：学生信息入库、查询、删除、修改

这一部分是整个学生业务模块的主体。

#### 8.3.1 数据模型

学生一条记录对应 `StudentRecordVO`。

它承载的数据包括：

- 主键 `id`
- 学号 `studentId`
- 姓名 `studentName`
- 性别 `gender`
- 年龄 `age`
- 生日 `birthday`
- 电话 `phone`
- 学院 `department`
- 专业 `major`
- 班级 `className`
- 邮箱 `email`
- 兴趣方向 `interests`
- 个人简介 `introduction`
- 创建时间 `createdAt`

#### 8.3.2 表单参数如何变成 Java 对象

这一层由 `StudentRecordMapper.fromRequest(request)` 负责。

它做了三件事：

1. 从 `request` 中把每个字段读出来。
2. 把空字符串统一处理成 `null`。
3. 把数字、日期、复选框等字段转成合适类型。

也就是说，表单和数据库之间不是直接连的，中间先经过 `StudentRecordMapper`。

#### 8.3.3 数据如何写入数据库

由 `StudentRecordDao` 负责。

主要方法：

- `insert(StudentRecordVO record)`
- `queryAllRecords()`
- `findById(long id)`
- `update(StudentRecordVO record)`
- `deleteById(long id)`

这里是真正写 SQL 的地方。也就是说：

- 页面不写 SQL
- Servlet 不写 SQL
- DAO 才是 SQL 的归口

#### 8.3.4 第四章新增/保存流程

```text
GET /student-db-form
-> StudentDbServlet#doGet
-> forward 到 student-db-form.jsp

POST /student-db-form
-> StudentDbServlet#doPost
-> StudentRecordMapper.fromRequest(request)
-> StudentRecordDao.insert(record)
-> DatabaseUtil.getConnection()
-> MySQL
-> forward 到 student-db-result.jsp
```

#### 8.3.5 第五章查询流程

```text
GET /student-query
-> StudentQueryServlet
-> StudentRecordDao.queryAllRecords()
-> request.setAttribute("records", ...)
-> forward 到 student-query.jsp
-> JSP 输出 HTML 表格
```

#### 8.3.6 第六章删除流程

```text
student-manage.jsp 上点击删除链接
-> /student-delete?id=主键
-> StudentDeleteServlet
-> StudentRecordDao.deleteById(id)
-> redirect 到 /student-manage?status=...
```

#### 8.3.7 第七章修改流程

```text
student-update.jsp 点击修改
-> /student-db-form?id=主键
-> StudentDbServlet#doGet
-> StudentRecordDao.findById(id)
-> 把 record 放进 request
-> student-db-form.jsp 表单回显
-> 提交 POST /student-db-form
-> StudentRecordDao.update(record)
```

这章最关键的设计点是：

- 新增和修改共用一套表单 `student-db-form.jsp`
- 新增和修改共用一个保存入口 `StudentDbServlet#doPost`
- 区分逻辑靠的是 `id` 是否存在

### 8.4 第八章：Servlet 交互模块

这一章的目标是把增删改查串起来，并展示三种跳转方式：

- `forward`
- `sendRedirect`
- `include`

#### 8.4.1 它如何实现

`StudentInteractionServlet` 根据 `action` 参数决定当前行为：

- `new`：打开新增表单
- `edit`：打开修改表单
- `delete`：删除
- `save`：保存
- 其他：显示总控列表页

#### 8.4.2 关键连接方式

- `forward`
  - 打开表单页、打开总控页时使用。
- `sendRedirect`
  - 保存、删除完成后使用，避免浏览器刷新导致重复提交。
- `include`
  - 页面中通过 `StudentInteractionSummaryServlet` 引入统计片段。

### 8.5 第九章：JSP 视图开发模块

这一章的重点是把“页面渲染职责”更多交给 JSP。

#### 8.5.1 实现结构

- `StudentJspServlet`
  - 负责准备数据和控制流程。
- `student-jsp-query.jsp`
  - 负责渲染查询页。
- `student-jsp-form.jsp`
  - 负责渲染新增/修改表单。
- `WEB-INF/jspf/*.jspf`
  - 把状态提示、表格、表单字段拆成可复用片段。

#### 8.5.2 这一章的核心意义

它说明一个传统 JavaWeb 项目里：

- Servlet 更像控制器
- JSP 更像视图层

也就是：

- Servlet 准备数据
- JSP 负责显示数据

### 8.6 第十章和第十一章：文件服务模块

这一部分分成“文件物理存储”和“文件元数据入库”两部分。

#### 8.6.1 上传如何实现

关键类：

- `FileUploadServlet`
- `FileStorageUtil`
- `FileUploadRecordDao`
- `FileUploadRecordVO`

上传流程：

```text
file-upload.jsp
-> POST /file-upload
-> request.getPart("uploadFile")
-> FileStorageUtil.store(part)
-> 文件保存到 uploads/年/月/日
-> 生成 FileUploadRecordVO
-> FileUploadRecordDao.insert(record)
-> metadata 写入 MySQL
```

#### 8.6.2 下载如何实现

关键类：

- `FileDownloadPageServlet`
- `FileDownloadSimpleServlet`
- `FileDownloadClassicServlet`

实现区别：

- 简单下载
  - 直接把文件内容写到响应流。
- 经典下载
  - 除了输出文件流，还设置 `Content-Disposition`，让浏览器以附件方式下载，并保留文件名。

#### 8.6.3 导出数据库并下载如何实现

由 `StudentExportServlet` 实现。

流程是：

```text
StudentExportServlet
-> StudentRecordDao.queryAllRecords()
-> 把每条学生记录写成 CSV 行
-> 设置响应头为附件下载
-> 浏览器下载 student-records.csv
```

### 8.7 第十二章：中央控制器架构

这一章是结构优化的关键。

在前面章节里，不同功能有很多独立 Servlet。第十二章开始把很多动作统一收口到一个入口：

- `/central-controller/*`

#### 8.7.1 中央控制器如何分发

在 `CentralControllerServlet` 的 `init()` 里维护了动作映射表：

- `list`
- `form`
- `save`
- `delete`
- `files`
- `file-upload`
- `file-download-simple`
- `file-download-classic`
- `export-students`

请求进来后，`service()` 会：

1. 从 `pathInfo` 里解析动作。
2. 找到对应处理函数。
3. 执行处理逻辑。
4. 根据 `ControllerResult` 决定 `forward` 还是 `redirect`。

#### 8.7.2 这一章的意义

它体现了 Front Controller 思想：

- 统一入口
- 集中分发
- 集中跳转控制
- 让结构更像真实项目

### 8.8 第十三章和第十四章：登录与过滤器控制

#### 8.8.1 登录如何实现

关键类：

- `LoginServlet`
- `LoginService`
- `AuthSessionUtil`
- `LogoutServlet`

流程：

```text
GET /login
-> LoginServlet 显示 login.jsp

POST /login
-> LoginServlet 读取 username/password
-> LoginService.validate(...)
-> AuthSessionUtil.login(session, username)
-> redirect 到目标页面
```

当前演示账号写死在 `LoginService`：

- 用户名：`admin`
- 密码：`123456`

#### 8.8.2 过滤器如何实现登录拦截

`AuthFilter` 配置在 `web.xml` 中，拦截路径是：

- `/central-controller/*`

执行逻辑：

1. 用户访问中央控制器路径。
2. 过滤器先运行。
3. 如果会话里有 `authenticatedUser`，则放行。
4. 如果没有，则重定向到登录页，并带上原始目标地址。

这就是“登录控制”真正发生的地方。

### 8.9 第十五章：监听器应用

关键类：

- `ApplicationStatsListener`

它监听三类事情：

1. 应用启动
2. 会话创建/销毁
3. 会话属性变化

因此它能统计：

- 应用启动时间
- 累计会话数
- 当前在线会话数
- 当前已登录会话数

这些数据会被放进 `ServletContext`，然后由页面读取显示。

### 8.10 完整项目整合模块

关键类：

- `CompleteProjectServlet`
- `WEB-INF/complete-project/home.jsp`
- `WEB-INF/complete-project/chapters.jsp`

这一层不是新业务，而是把前 15 章重新组合成一个完整入口。

#### 8.10.1 它做了什么

- 把根路径统一引到完整项目首页。
- 首页显示：
  - 学生模块入口
  - 文件模块入口
  - 登录与过滤器入口
  - 监听器统计
  - 最近学生记录
  - 最近上传文件
- 如果数据库不可用，首页不会直接报错，而是降级显示静态入口。

#### 8.10.2 为什么 JSP 放到 `WEB-INF`

因为 `CompleteProjectServlet` 映射的是 `/complete-project/*`。

如果 JSP 也直接放在 `/complete-project/home.jsp` 这种公开路径下，Servlet 转发时会再次命中自身，造成递归转发。

所以这里把完整项目页放在：

- `WEB-INF/complete-project/home.jsp`
- `WEB-INF/complete-project/chapters.jsp`

由 Servlet 转发访问，避免循环。

---

## 9. 前后端是如何进行连接的

这一部分是理解项目最关键的部分。

### 9.1 连接方式一：URL 路由

浏览器访问的 URL，要先能找到后端入口。

这个项目里的 URL 主要通过两种方式定义：

1. `@WebServlet(...)`
2. `web.xml`

例如：

- `/student-query` -> `StudentQueryServlet`
- `/file-upload` -> `FileUploadServlet`
- `/login` -> `LoginServlet`
- `/central-controller/*` -> `CentralControllerServlet`

所以第一层连接点是“路径和 Servlet 的绑定”。

### 9.2 连接方式二：表单提交

前端页面的 `<form>` 会把数据提交给 Servlet。

例如：

- `student-form.html` 提交给 `/student-form`
- `student-db-form.jsp` 提交给 `/student-db-form`
- `file-upload.jsp` 提交给 `/file-upload`
- `login.jsp` 提交给 `/login`

后端收到后，通过：

- `request.getParameter(...)`
- `request.getParameterValues(...)`
- `request.getPart(...)`

读取这些数据。

### 9.3 连接方式三：Servlet 向 JSP 传值

后端处理完之后，不是直接把 Java 对象“发给前端框架”，而是：

1. `request.setAttribute("name", value)`
2. `request.getRequestDispatcher("/xxx.jsp").forward(...)`

这样，JSP 页面就可以拿到 Servlet 放进去的数据并渲染。

这也是传统 JSP 项目的标准方式。

### 9.4 连接方式四：重定向

当某些动作完成后，项目不会直接 forward，而是使用：

- `response.sendRedirect(...)`

原因是：

- 防止用户刷新时重复提交表单
- 让浏览器地址栏更新到新的页面

这在保存、删除、登录成功后很常见。

### 9.5 连接方式五：include

第八章演示了 `include`。

它的作用不是换页面，而是把一个 Servlet 或 JSP 的输出嵌进当前页面的一部分区域里。

这说明前端页面不一定只对应一个后端入口，也可能由多个后端片段共同组成。

---

## 10. 数据库如何实现和连接

### 10.1 使用的数据库

当前项目使用的是 `MySQL`。

连接场景是：

- Tomcat 运行在 Windows
- MySQL 运行在本地可访问的 `127.0.0.1:3306`
- 项目通过 JDBC 连接它

### 10.2 数据库连接写在哪里

最核心的文件是：

- `src/main/java/com/example/backend_development/DatabaseUtil.java`

它负责三件事：

1. `Class.forName("com.mysql.cj.jdbc.Driver")`
   - 加载 MySQL 驱动。
2. `getConnection()`
   - 返回 JDBC 连接。
3. `initializeDatabase()`
   - 第一次使用时执行 SQL 脚本建表。

### 10.3 数据库配置从哪里读取

`DatabaseUtil` 按优先级读取数据库配置：

1. JVM 参数
   - `app.db.url`
   - `app.db.user`
   - `app.db.password`
2. 环境变量
   - `APP_DB_URL`
   - `APP_DB_USER`
   - `APP_DB_PASSWORD`
3. 本地配置文件
   - `src/main/resources/db/mysql.local.properties`

也就是说，真正的连接字符串、用户名、密码，不写死在 DAO 里，而是由 `DatabaseUtil` 统一加载。

### 10.4 建表 SQL 在哪里

文件：

- `src/main/resources/db/student_form.sql`

这里定义了两张表：

1. `student_form_records`
   - 存学生信息。
2. `uploaded_file_records`
   - 存上传文件元数据。

### 10.5 DAO 如何连接数据库

以 `StudentRecordDao` 为例：

1. 构造函数先调用 `DatabaseUtil.initializeDatabase()`。
2. 每次执行 `insert/query/update/delete` 时，再调用 `DatabaseUtil.getConnection()`。
3. 拿到 `Connection` 后，用 `PreparedStatement` 执行 SQL。

所以真正的链路是：

```text
Servlet
-> DAO
-> DatabaseUtil.getConnection()
-> JDBC Connection
-> MySQL
```

### 10.6 文件记录为什么也要入库

文件上传有两部分：

1. 文件内容保存到磁盘
2. 文件信息保存到数据库

数据库中保存的是：

- 原文件名
- 服务器保存文件名
- 存储路径
- 内容类型
- 文件大小
- 上传时间

这样第十一章下载列表页才能知道有哪些文件可以下载。

---

## 11. 每个关键连接点在哪里

这一节专门回答“关键连接在哪里”。

### 11.1 根入口连接点

- `src/main/webapp/index.jsp`
  - 根路径进入完整项目首页的第一跳。

### 11.2 URL 和 Servlet 的连接点

主要在这些类的 `@WebServlet` 注解中：

- `HelloServlet.java`
- `FormEchoServlet.java`
- `StudentFormServlet.java`
- `StudentDbServlet.java`
- `StudentQueryServlet.java`
- `StudentManageServlet.java`
- `StudentDeleteServlet.java`
- `StudentUpdateServlet.java`
- `StudentInteractionServlet.java`
- `StudentInteractionSummaryServlet.java`
- `StudentJspServlet.java`
- `FileUploadServlet.java`
- `FileDownloadPageServlet.java`
- `FileDownloadSimpleServlet.java`
- `FileDownloadClassicServlet.java`
- `StudentExportServlet.java`
- `CentralControllerServlet.java`
- `LoginServlet.java`
- `LogoutServlet.java`
- `CompleteProjectServlet.java`

### 11.3 过滤器和监听器的连接点

写在：

- `src/main/webapp/WEB-INF/web.xml`

这里明确配置了：

- `AuthFilter` 拦截 `/central-controller/*`
- `ApplicationStatsListener` 作为监听器注册
- `*.jsp`、`*.jspf` 的 UTF-8 编码

### 11.4 表单参数和 Java 对象的连接点

写在：

- `src/main/java/com/example/backend_development/StudentRecordMapper.java`

这是表单字段和 VO 字段的关键桥梁。

### 11.5 Java 对象和数据库表的连接点

主要写在：

- `src/main/java/com/example/backend_development/StudentRecordDao.java`
- `src/main/java/com/example/backend_development/FileUploadRecordDao.java`

这两个类里的 SQL 就是 Java 对象和数据库表的直接连接点。

### 11.6 数据库配置和实际连接的连接点

写在：

- `src/main/java/com/example/backend_development/DatabaseUtil.java`
- `src/main/resources/db/mysql.local.properties`
- `src/main/resources/db/mysql.properties.example`

### 11.7 文件上传目录的连接点

写在：

- `src/main/java/com/example/backend_development/FileStorageUtil.java`

默认目录是：

- `D:\school_work\backend_development\uploads`

### 11.8 页面渲染的连接点

主要写在各个 Servlet 中的：

- `request.setAttribute(...)`
- `request.getRequestDispatcher(...).forward(...)`

也就是说，Servlet 决定 JSP 能看到哪些数据。

### 11.9 中央控制器的动作分发连接点

写在：

- `src/main/java/com/example/backend_development/CentralControllerServlet.java`

这里的 `actionHandlers` 映射表，就是第十二章最核心的“路径到功能”的连接处。

### 11.10 登录状态的连接点

写在：

- `src/main/java/com/example/backend_development/AuthSessionUtil.java`

它使用的会话属性名是：

- `authenticatedUser`

过滤器、监听器、登录逻辑，都是围绕这个属性协作的。

---

## 12. 模块之间是怎么串起来的

### 12.1 学生模块

```text
表单页面
-> StudentRecordMapper
-> StudentRecordVO
-> StudentRecordDao
-> MySQL
-> Servlet 放入 request
-> JSP 表格或结果页
```

### 12.2 文件模块

```text
上传页面
-> FileUploadServlet
-> FileStorageUtil 保存文件
-> FileUploadRecordVO
-> FileUploadRecordDao
-> MySQL
-> 下载页查询列表
-> 下载 Servlet 输出文件
```

### 12.3 登录控制模块

```text
login.jsp
-> LoginServlet
-> LoginService.validate
-> AuthSessionUtil.login
-> session 中写入 authenticatedUser
-> AuthFilter 检查 session
-> 放行或重定向
```

### 12.4 监听器统计模块

```text
Tomcat 启动
-> ApplicationStatsListener.contextInitialized

用户访问站点
-> sessionCreated / sessionDestroyed

用户登录退出
-> session attribute changed

统计结果写入 ServletContext
-> listener-demo.jsp / CompleteProjectServlet 读取
```

### 12.5 完整项目整合模块

```text
/
-> index.jsp
-> /complete-project/home
-> CompleteProjectServlet
-> 首页展示学生模块、文件模块、登录过滤、监听器数据
```

---

## 13. 这个项目本质上体现了哪些 JavaWeb 基础知识

它覆盖了下面这些典型知识点：

- WAR 工程结构
- Servlet 生命周期
- `doGet()` / `doPost()`
- `HttpServletRequest` 和 `HttpServletResponse`
- 表单提交
- 参数接收
- JSP 渲染
- `forward`
- `redirect`
- `include`
- JDBC 连接数据库
- VO / DAO 分层
- 文件上传
- 文件下载
- CSV 导出
- 中央控制器架构
- 登录和 Session
- 过滤器
- 监听器

所以，这个项目实际上就是一套比较完整的 JavaWeb 课程实验项目。

---

## 14. 如果你要按源码顺序学习，建议这样读

建议阅读顺序：

1. `pom.xml`
2. `src/main/webapp/index.jsp`
3. `src/main/java/com/example/backend_development/CompleteProjectServlet.java`
4. `src/main/webapp/WEB-INF/complete-project/home.jsp`
5. `src/main/java/com/example/backend_development/StudentRecordVO.java`
6. `src/main/java/com/example/backend_development/StudentRecordMapper.java`
7. `src/main/java/com/example/backend_development/StudentRecordDao.java`
8. `src/main/java/com/example/backend_development/DatabaseUtil.java`
9. `src/main/java/com/example/backend_development/StudentDbServlet.java`
10. `src/main/webapp/student-db-form.jsp`
11. `src/main/webapp/student-query.jsp`
12. `src/main/java/com/example/backend_development/FileStorageUtil.java`
13. `src/main/java/com/example/backend_development/FileUploadServlet.java`
14. `src/main/java/com/example/backend_development/CentralControllerServlet.java`
15. `src/main/java/com/example/backend_development/LoginServlet.java`
16. `src/main/java/com/example/backend_development/AuthFilter.java`
17. `src/main/java/com/example/backend_development/ApplicationStatsListener.java`
18. `src/main/webapp/WEB-INF/web.xml`

这样读会比较容易把整个项目串起来。

---

## 15. 最后一句话概括整个项目

这个项目的本质是：

一个以 `Servlet + JSP + JDBC + MySQL` 为主线、从前端基础页面到数据库 CRUD、再到文件服务、中央控制器、登录控制、过滤器、监听器，最终整合为一个完整入口的 JavaWeb 课程项目。
