<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>第三组：HTML 进阶主题</title>
    <link rel="stylesheet" href="assets/css/site.css">
    <script defer src="assets/js/playground.js"></script>
</head>
<body class="theme-section advanced-page">
<div class="page-shell">
    <header class="page-header">
        <p class="eyebrow">Task 03</p>
        <h1>HTML 进阶主题练习</h1>
        <p class="section-intro">本页覆盖 HTML 框架、内联框架、背景、脚本、头部、实体、URL 和 URL 编码。</p>
        <nav class="page-nav">
            <a href="index.jsp">返回首页</a>
            <a href="html-basics.html">第一组</a>
            <a href="html-forms.html">第二组</a>
        </nav>
    </header>

    <main class="content-stack">
        <section class="card">
            <h2>HTML 头部</h2>
            <p>虽然 <code>&lt;head&gt;</code> 不会直接显示在页面主体中，但它负责声明字符集、标题、样式和脚本等重要配置。</p>
            <pre class="code-block"><code>&lt;meta charset="UTF-8"&gt;
&lt;meta name="viewport" content="width=device-width, initial-scale=1.0"&gt;
&lt;title&gt;第三组：HTML 进阶主题&lt;/title&gt;
&lt;link rel="stylesheet" href="assets/css/site.css"&gt;
&lt;script defer src="assets/js/playground.js"&gt;&lt;/script&gt;</code></pre>
        </section>

        <section class="card background-showcase">
            <h2>HTML 背景</h2>
            <p>这一整页的背景色、渐变和装饰形状都通过 CSS 设置完成，说明 HTML 页面可以配合背景样式增强视觉层次。</p>
        </section>

        <section class="card">
            <h2>HTML 框架</h2>
            <p><code>frameset</code> 属于旧式写法，HTML5 中已经不再推荐，但很多基础教材依然会提到它。</p>
            <div class="link-list">
                <a href="legacy-frames.html" target="_blank" rel="noreferrer">打开旧式框架示例页面</a>
            </div>
        </section>

        <section class="card">
            <h2>HTML 内联框架</h2>
            <p>下面使用 <code>&lt;iframe&gt;</code> 展示一个内联框架，它会把另一个页面嵌入到当前页面中。</p>
            <div class="iframe-shell">
                <iframe src="frame-home.html" title="内联框架示例" loading="lazy"></iframe>
            </div>
        </section>

        <section class="card">
            <h2>HTML 脚本</h2>
            <p>脚本可以给页面增加交互。下面两个按钮分别演示计数器和当前时间。</p>
            <div class="button-row">
                <button id="counter-button" class="button primary" type="button">点击计数</button>
                <span class="counter-chip">当前次数：<strong id="counter-value">0</strong></span>
                <button id="time-button" class="button secondary" type="button">显示当前时间</button>
            </div>
            <p id="time-output" class="note">点击按钮后在这里显示时间。</p>
        </section>

        <section class="card">
            <h2>HTML 实体</h2>
            <table class="demo-table">
                <thead>
                <tr>
                    <th>实体</th>
                    <th>效果</th>
                    <th>说明</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td><code>&amp;lt;div&amp;gt;</code></td>
                    <td>&lt;div&gt;</td>
                    <td>显示标签文本而不是解析为标签</td>
                </tr>
                <tr>
                    <td><code>&amp;copy;</code></td>
                    <td>&copy;</td>
                    <td>版权符号</td>
                </tr>
                <tr>
                    <td><code>&amp;amp;</code></td>
                    <td>&amp;</td>
                    <td>与号字符</td>
                </tr>
                <tr>
                    <td><code>&amp;nbsp;</code></td>
                    <td>A&nbsp;B</td>
                    <td>空格实体</td>
                </tr>
                </tbody>
            </table>
        </section>

        <section class="card">
            <h2>HTML URL 与 URL 编码</h2>
            <p>浏览器地址栏里的参数通常使用百分号编码。点击下面链接后，JSP 会把解码后的参数显示出来。</p>
            <div class="link-list">
                <a href="html-advanced.jsp?topic=JavaWeb&city=%E5%8C%97%E4%BA%AC&note=Tomcat%20demo">打开 URL 编码示例</a>
            </div>
            <pre class="code-block"><code>html-advanced.jsp?topic=JavaWeb&amp;city=%E5%8C%97%E4%BA%AC&amp;note=Tomcat%20demo</code></pre>
            <div class="parameter-grid">
                <div class="parameter-card">
                    <span>topic</span>
                    <strong>${empty param.topic ? '未传入参数' : param.topic}</strong>
                </div>
                <div class="parameter-card">
                    <span>city</span>
                    <strong>${empty param.city ? '未传入参数' : param.city}</strong>
                </div>
                <div class="parameter-card">
                    <span>note</span>
                    <strong>${empty param.note ? '未传入参数' : param.note}</strong>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
