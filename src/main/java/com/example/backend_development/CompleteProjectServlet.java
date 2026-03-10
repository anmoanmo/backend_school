package com.example.backend_development;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "completeProjectServlet", value = "/complete-project/*")
public class CompleteProjectServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = resolveAction(request.getPathInfo());

        if ("chapters".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/complete-project/chapters.jsp").forward(request, response);
            return;
        }

        if (!"home".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/complete-project/home");
            return;
        }

        prepareHomeAttributes(request);
        request.getRequestDispatcher("/WEB-INF/complete-project/home.jsp").forward(request, response);
    }

    private void prepareHomeAttributes(HttpServletRequest request) {
        ServletContext servletContext = getServletContext();

        request.setAttribute("appStartTime", servletContext.getAttribute(ApplicationStatsListener.ATTR_START_TIME));
        request.setAttribute("totalSessions", counterValue(servletContext, ApplicationStatsListener.ATTR_TOTAL_SESSIONS));
        request.setAttribute("activeSessions", counterValue(servletContext, ApplicationStatsListener.ATTR_ACTIVE_SESSIONS));
        request.setAttribute(
                "authenticatedSessions",
                counterValue(servletContext, ApplicationStatsListener.ATTR_AUTHENTICATED_SESSIONS));
        request.setAttribute("uploadRootDirectory", FileStorageUtil.getUploadRootDirectoryPath());

        try {
            StudentRecordDao studentRecordDao = new StudentRecordDao();
            FileUploadRecordDao fileUploadRecordDao = new FileUploadRecordDao();
            List<StudentRecordVO> studentRecords = studentRecordDao.queryAllRecords();
            List<FileUploadRecordVO> fileRecords = fileUploadRecordDao.findAll();

            request.setAttribute("studentCount", studentRecords.size());
            request.setAttribute("fileCount", fileRecords.size());
            request.setAttribute("recentStudents", studentRecords.subList(0, Math.min(5, studentRecords.size())));
            request.setAttribute("recentFiles", fileRecords.subList(0, Math.min(5, fileRecords.size())));
            request.setAttribute("dataAvailable", true);
        } catch (SQLException | IllegalStateException e) {
            request.setAttribute("studentCount", 0);
            request.setAttribute("fileCount", 0);
            request.setAttribute("recentStudents", Collections.emptyList());
            request.setAttribute("recentFiles", Collections.emptyList());
            request.setAttribute("dataAvailable", false);
            request.setAttribute("dataMessage", "数据库当前不可用，首页已降级为静态入口展示。");
        }
    }

    private String resolveAction(String pathInfo) {
        if (pathInfo == null || "/".equals(pathInfo) || "/home".equalsIgnoreCase(pathInfo)) {
            return "home";
        }
        if ("/chapters".equalsIgnoreCase(pathInfo)) {
            return "chapters";
        }
        return "home";
    }

    private int counterValue(ServletContext servletContext, String attributeName) {
        Object attribute = servletContext.getAttribute(attributeName);
        if (attribute instanceof AtomicInteger counter) {
            return counter.get();
        }
        return 0;
    }
}
