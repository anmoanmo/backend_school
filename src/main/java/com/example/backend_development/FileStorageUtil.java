package com.example.backend_development;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;

import jakarta.servlet.http.Part;

public final class FileStorageUtil {
    private static final String UPLOAD_DIR_PROPERTY = "app.upload.dir";
    private static final String UPLOAD_DIR_ENV = "APP_UPLOAD_DIR";
    private static final Path DEFAULT_UPLOAD_ROOT = Path.of("D:\\school_work\\backend_development", "uploads");

    private FileStorageUtil() {
    }

    public static StoredFile store(Part filePart) throws IOException {
        String originalFileName = extractSubmittedFileName(filePart);
        if (originalFileName == null || originalFileName.isBlank()) {
            throw new IOException("Uploaded file name is empty");
        }

        Path rootDirectory = getUploadRootDirectory();
        LocalDate today = LocalDate.now();
        Path targetDirectory = rootDirectory
                .resolve(String.valueOf(today.getYear()))
                .resolve(String.format("%02d", today.getMonthValue()))
                .resolve(String.format("%02d", today.getDayOfMonth()));
        Files.createDirectories(targetDirectory);

        String safeFileName = sanitizeFileName(originalFileName);
        String extension = "";
        int dotIndex = safeFileName.lastIndexOf('.');
        if (dotIndex >= 0) {
            extension = safeFileName.substring(dotIndex);
            safeFileName = safeFileName.substring(0, dotIndex);
        }

        if (safeFileName.isBlank()) {
            safeFileName = "upload";
        }

        String storedFileName = safeFileName + "-" + UUID.randomUUID().toString().replace("-", "") + extension;
        Path targetFile = targetDirectory.resolve(storedFileName);

        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
        }

        return new StoredFile(
                originalFileName,
                storedFileName,
                targetFile.toAbsolutePath().toString(),
                filePart.getContentType(),
                filePart.getSize(),
                rootDirectory.toAbsolutePath().toString());
    }

    public static String getUploadRootDirectoryPath() {
        return getUploadRootDirectory().toAbsolutePath().toString();
    }

    private static Path getUploadRootDirectory() {
        String configuredPath = firstNonBlank(
                System.getProperty(UPLOAD_DIR_PROPERTY),
                System.getenv(UPLOAD_DIR_ENV));

        if (configuredPath != null) {
            return Path.of(configuredPath);
        }

        return DEFAULT_UPLOAD_ROOT;
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private static String extractSubmittedFileName(Part filePart) {
        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null) {
            return null;
        }

        String normalized = submittedFileName.replace("\\", "/");
        int slashIndex = normalized.lastIndexOf('/');
        return slashIndex >= 0 ? normalized.substring(slashIndex + 1) : normalized;
    }

    private static String sanitizeFileName(String fileName) {
        return fileName.replaceAll("[^A-Za-z0-9._-]", "_");
    }

    public record StoredFile(
            String originalFileName,
            String storedFileName,
            String storagePath,
            String contentType,
            long fileSize,
            String rootDirectory) {
    }
}
