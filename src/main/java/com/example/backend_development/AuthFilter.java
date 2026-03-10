package com.example.backend_development;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuthFilter implements Filter {
    private static final String DEFAULT_TARGET = "/central-controller/list";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (AuthSessionUtil.isAuthenticated(session)) {
            chain.doFilter(request, response);
            return;
        }

        String redirectTarget = resolveRedirectTarget(httpRequest);
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?status=authRequired&redirect="
                + URLEncoder.encode(redirectTarget, StandardCharsets.UTF_8));
    }

    private String resolveRedirectTarget(HttpServletRequest request) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return DEFAULT_TARGET;
        }

        String uri = request.getRequestURI().substring(request.getContextPath().length());
        String query = request.getQueryString();
        if (query == null || query.isBlank()) {
            return uri;
        }
        return uri + "?" + query;
    }
}
