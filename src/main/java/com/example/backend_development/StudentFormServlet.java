package com.example.backend_development;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "studentFormServlet", value = "/student-form")
public class StudentFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/student-form.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();
        String interests = join(request.getParameterValues("interest"));

        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"zh-CN\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>学生信息提交结果</title>");
        out.println("    <link rel=\"stylesheet\" href=\"" + contextPath + "/assets/css/site.css\">");
        out.println("</head>");
        out.println("<body class=\"theme-section\">");
        out.println("    <div class=\"page-shell\">");
        out.println("        <header class=\"page-header\">");
        out.println("            <p class=\"eyebrow\">Task 04 Result</p>");
        out.println("            <h1>Servlet 已接收到表单数据</h1>");
        out.println("            <p class=\"section-intro\">下面这些内容由 StudentFormServlet 从 request 中读取并输出。</p>");
        out.println("            <nav class=\"page-nav\">");
        out.println("                <a href=\"" + contextPath + "/student-form.html\">返回登记表</a>");
        out.println("                <a href=\"" + contextPath + "/index.jsp\">返回首页</a>");
        out.println("            </nav>");
        out.println("        </header>");

        out.println("        <main class=\"content-stack\">");
        out.println("            <section class=\"card\">");
        out.println("                <h2>学生信息摘要</h2>");
        out.println("                <div class=\"parameter-grid\">");
        printCard(out, "姓名", request.getParameter("studentName"));
        printCard(out, "学号", request.getParameter("studentId"));
        printCard(out, "性别", request.getParameter("gender"));
        printCard(out, "年龄", request.getParameter("age"));
        printCard(out, "出生日期", request.getParameter("birthday"));
        printCard(out, "联系电话", request.getParameter("phone"));
        printCard(out, "学院", request.getParameter("department"));
        printCard(out, "专业", request.getParameter("major"));
        printCard(out, "班级", request.getParameter("className"));
        printCard(out, "邮箱", request.getParameter("email"));
        printCard(out, "兴趣方向", interests);
        printCard(out, "个人简介", request.getParameter("introduction"));
        out.println("                </div>");
        out.println("            </section>");

        out.println("            <section class=\"card\">");
        out.println("                <h2>Servlet 处理说明</h2>");
        out.println("                <ul class=\"feature-list\">");
        out.println("                    <li>通过 request.getParameter(\"studentName\") 等方法获取单个表单值。</li>");
        out.println("                    <li>通过 request.getParameterValues(\"interest\") 获取复选框数组。</li>");
        out.println("                    <li>在 doPost 中设置 request.setCharacterEncoding(\"UTF-8\")，避免中文乱码。</li>");
        out.println("                </ul>");
        out.println("            </section>");
        out.println("        </main>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private void printCard(PrintWriter out, String label, String value) {
        out.println("                    <div class=\"parameter-card\">");
        out.println("                        <span>" + escapeHtml(label) + "</span>");
        out.println("                        <strong>" + escapeHtml(value == null || value.isBlank() ? "未填写" : value) + "</strong>");
        out.println("                    </div>");
    }

    private String join(String[] values) {
        if (values == null || values.length == 0) {
            return "未选择";
        }

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < values.length; i++) {
            if (i > 0) {
                builder.append("、");
            }
            builder.append(values[i]);
        }
        return builder.toString();
    }

    private String escapeHtml(String value) {
        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
