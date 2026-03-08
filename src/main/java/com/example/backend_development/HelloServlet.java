package com.example.backend_development;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    private String message;

    @Override
    public void init() {
        message = "Hello Servlet!";
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");

        String contextPath = request.getContextPath();
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html lang=\"zh-CN\">");
        out.println("<head>");
        out.println("    <meta charset=\"UTF-8\">");
        out.println("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        out.println("    <title>Hello Servlet</title>");
        out.println("    <link rel=\"stylesheet\" href=\"" + contextPath + "/assets/css/site.css\">");
        out.println("</head>");
        out.println("<body class=\"theme-section\">");
        out.println("    <div class=\"page-shell\">");
        out.println("        <header class=\"page-header\">");
        out.println("            <p class=\"eyebrow\">Servlet Demo</p>");
        out.println("            <h1>" + message + "</h1>");
        out.println("            <p class=\"section-intro\">这个页面由 Servlet 直接输出，方便和 HTML / JSP 页面做对比。</p>");
        out.println("            <nav class=\"page-nav\">");
        out.println("                <a href=\"" + contextPath + "/index.jsp\">返回首页</a>");
        out.println("                <a href=\"" + contextPath + "/html-forms.html\">打开表单练习</a>");
        out.println("            </nav>");
        out.println("        </header>");
        out.println("    </div>");
        out.println("</body>");
        out.println("</html>");
    }

    @Override
    public void destroy() {
    }
}
