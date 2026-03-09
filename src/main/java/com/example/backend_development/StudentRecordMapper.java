package com.example.backend_development;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import jakarta.servlet.http.HttpServletRequest;

public final class StudentRecordMapper {
    private StudentRecordMapper() {
    }

    public static StudentRecordVO fromRequest(HttpServletRequest request) {
        StudentRecordVO record = new StudentRecordVO();
        record.setId(parseLong(request.getParameter("id")));
        record.setStudentName(HtmlUtil.trimToNull(request.getParameter("studentName")));
        record.setStudentId(HtmlUtil.trimToNull(request.getParameter("studentId")));
        record.setGender(HtmlUtil.trimToNull(request.getParameter("gender")));
        record.setAge(parseInteger(request.getParameter("age")));
        record.setBirthday(parseDate(request.getParameter("birthday")));
        record.setPhone(HtmlUtil.trimToNull(request.getParameter("phone")));
        record.setDepartment(HtmlUtil.trimToNull(request.getParameter("department")));
        record.setMajor(HtmlUtil.trimToNull(request.getParameter("major")));
        record.setClassName(HtmlUtil.trimToNull(request.getParameter("className")));
        record.setEmail(HtmlUtil.trimToNull(request.getParameter("email")));
        record.setInterests(HtmlUtil.joinValues(request.getParameterValues("interest"), "、", "未选择"));
        record.setIntroduction(HtmlUtil.trimToNull(request.getParameter("introduction")));
        return record;
    }

    private static Integer parseInteger(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        if (normalized == null) {
            return null;
        }

        try {
            return Integer.parseInt(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static LocalDate parseDate(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        if (normalized == null) {
            return null;
        }

        try {
            return LocalDate.parse(normalized);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private static Long parseLong(String value) {
        String normalized = HtmlUtil.trimToNull(value);
        if (normalized == null) {
            return null;
        }

        try {
            return Long.parseLong(normalized);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
