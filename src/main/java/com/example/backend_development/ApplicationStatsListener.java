package com.example.backend_development;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

public class ApplicationStatsListener
        implements ServletContextListener, HttpSessionListener, HttpSessionAttributeListener {
    public static final String ATTR_START_TIME = "listener.appStartTime";
    public static final String ATTR_TOTAL_SESSIONS = "listener.totalSessions";
    public static final String ATTR_ACTIVE_SESSIONS = "listener.activeSessions";
    public static final String ATTR_AUTHENTICATED_SESSIONS = "listener.authenticatedSessions";

    private static final String AUTHENTICATED_USER = "authenticatedUser";

    private final Set<String> authenticatedSessionIds = ConcurrentHashMap.newKeySet();

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext servletContext = sce.getServletContext();
        servletContext.setAttribute(ATTR_START_TIME, LocalDateTime.now());
        servletContext.setAttribute(ATTR_TOTAL_SESSIONS, new AtomicInteger(0));
        servletContext.setAttribute(ATTR_ACTIVE_SESSIONS, new AtomicInteger(0));
        servletContext.setAttribute(ATTR_AUTHENTICATED_SESSIONS, new AtomicInteger(0));
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        authenticatedSessionIds.clear();
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext servletContext = se.getSession().getServletContext();
        counter(servletContext, ATTR_TOTAL_SESSIONS).incrementAndGet();
        counter(servletContext, ATTR_ACTIVE_SESSIONS).incrementAndGet();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext servletContext = se.getSession().getServletContext();
        decrement(counter(servletContext, ATTR_ACTIVE_SESSIONS));
        if (authenticatedSessionIds.remove(se.getSession().getId())) {
            decrement(counter(servletContext, ATTR_AUTHENTICATED_SESSIONS));
        }
    }

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        syncAuthenticatedState(event.getSession());
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        syncAuthenticatedState(event.getSession());
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        syncAuthenticatedState(event.getSession());
    }

    private void syncAuthenticatedState(HttpSession session) {
        boolean authenticated = session.getAttribute(AUTHENTICATED_USER) != null;
        boolean counted = authenticatedSessionIds.contains(session.getId());
        AtomicInteger authenticatedCounter = counter(session.getServletContext(), ATTR_AUTHENTICATED_SESSIONS);

        if (authenticated && !counted) {
            authenticatedSessionIds.add(session.getId());
            authenticatedCounter.incrementAndGet();
        } else if (!authenticated && counted) {
            authenticatedSessionIds.remove(session.getId());
            decrement(authenticatedCounter);
        }
    }

    private AtomicInteger counter(ServletContext servletContext, String attributeName) {
        return (AtomicInteger) servletContext.getAttribute(attributeName);
    }

    private void decrement(AtomicInteger counter) {
        counter.updateAndGet(current -> Math.max(0, current - 1));
    }
}
