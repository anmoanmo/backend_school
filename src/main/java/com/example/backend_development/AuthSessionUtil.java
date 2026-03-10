package com.example.backend_development;

import jakarta.servlet.http.HttpSession;

public final class AuthSessionUtil {
    private static final String AUTHENTICATED_USER = "authenticatedUser";

    private AuthSessionUtil() {
    }

    public static boolean isAuthenticated(HttpSession session) {
        return session != null && session.getAttribute(AUTHENTICATED_USER) instanceof String;
    }

    public static void login(HttpSession session, String username) {
        session.setAttribute(AUTHENTICATED_USER, username);
    }

    public static void logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    public static String getAuthenticatedUsername(HttpSession session) {
        if (!isAuthenticated(session)) {
            return null;
        }
        return (String) session.getAttribute(AUTHENTICATED_USER);
    }
}
