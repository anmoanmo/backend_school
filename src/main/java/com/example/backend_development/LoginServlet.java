package com.example.backend_development;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "loginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private static final String DEFAULT_TARGET = "/central-controller/list";

    private transient LoginService loginService;

    @Override
    public void init() {
        loginService = new LoginService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (AuthSessionUtil.isAuthenticated(session)) {
            response.sendRedirect(request.getContextPath() + normalizeRedirectTarget(request.getParameter("redirect")));
            return;
        }

        request.setAttribute("status", request.getParameter("status"));
        request.setAttribute("redirectTarget", normalizeRedirectTarget(request.getParameter("redirect")));
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String username = HtmlUtil.trimToNull(request.getParameter("username"));
        String password = HtmlUtil.trimToNull(request.getParameter("password"));
        String redirectTarget = normalizeRedirectTarget(request.getParameter("redirect"));

        if (loginService.validate(username, password)) {
            HttpSession session = request.getSession(true);
            AuthSessionUtil.login(session, username);
            response.sendRedirect(request.getContextPath() + redirectTarget);
            return;
        }

        request.setAttribute("status", "invalidCredential");
        request.setAttribute("username", username == null ? "" : username);
        request.setAttribute("redirectTarget", redirectTarget);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    private String normalizeRedirectTarget(String redirect) {
        String normalized = HtmlUtil.trimToNull(redirect);
        if (normalized == null) {
            return DEFAULT_TARGET;
        }
        if (!normalized.startsWith("/central-controller/")) {
            return DEFAULT_TARGET;
        }
        return normalized;
    }
}
