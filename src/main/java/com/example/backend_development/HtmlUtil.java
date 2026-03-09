package com.example.backend_development;

public final class HtmlUtil {
    private HtmlUtil() {
    }

    public static String escapeHtml(String value) {
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

    public static String defaultText(String value) {
        return value == null || value.isBlank() ? "未填写" : value;
    }

    public static String joinValues(String[] values, String separator, String emptyText) {
        if (values == null || values.length == 0) {
            return emptyText;
        }

        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < values.length; i++) {
            if (i > 0) {
                builder.append(separator);
            }
            builder.append(values[i]);
        }
        return builder.toString();
    }

    public static String trimToNull(String value) {
        if (value == null) {
            return null;
        }

        String normalized = value.trim();
        return normalized.isEmpty() ? null : normalized;
    }
}
