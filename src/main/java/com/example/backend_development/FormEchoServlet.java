package com.example.backend_development;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "formEchoServlet", value = "/form-echo")
public class FormEchoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        renderResponse(request, response, "GET");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        renderResponse(request, response, "POST");
    }

    private void renderResponse(HttpServletRequest request, HttpServletResponse response, String method)
            throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"zh-CN\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>表单提交结果</title>");
        out.println("    <link rel=\"stylesheet\" href=\"" + contextPath + "/assets/css/site.css\">");
        out.println("</head>");
        out.println("<body class=\"theme-section\">");
        out.println("    <div class=\"page-shell\">");
        out.println("        <header class=\"page-header\">");
        out.println("            <p class=\"eyebrow\">Form Echo</p>");
        out.println("            <h1>表单提交结果</h1>");
        out.println("            <p class=\"section-intro\">当前请求方法：" + method + "</p>");
        out.println("            <nav class=\"page-nav\">");
        out.println("                <a href=\"" + contextPath + "/index.jsp\">返回首页</a>");
        out.println("                <a href=\"" + contextPath + "/html-forms.html\">返回表单页面</a>");
        out.println("            </nav>");
        out.println("        </header>");
        out.println("        <main class=\"content-stack\">");
        out.println("            <section class=\"card\">");
        out.println("                <h2>接收到的参数</h2>");

        Map<String, String[]> parameters = request.getParameterMap();
        if (parameters.isEmpty()) {
            out.println("                <p class=\"note\">当前没有接收到任何表单数据。</p>");
        } else {
            out.println("                <table class=\"demo-table\">");
            out.println("                    <thead>");
            out.println("                    <tr><th>参数名</th><th>参数值</th></tr>");
            out.println("                    </thead>");
            out.println("                    <tbody>");
            for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
                out.println("                    <tr>");
                out.println("                        <td>" + escapeHtml(entry.getKey()) + "</td>");
                out.println("                        <td>" + joinValues(entry.getValue()) + "</td>");
                out.println("                    </tr>");
            }
            out.println("                    </tbody>");
            out.println("                </table>");
        }

        out.println("            </section>");
        out.println("        </main>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }

    private String joinValues(String[] values) {
        if (values == null || values.length == 0) {
            return "";
        }

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < values.length; i++) {
            if (i > 0) {
                builder.append(", ");
            }
            builder.append(escapeHtml(values[i]));
        }
        return builder.toString();
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
