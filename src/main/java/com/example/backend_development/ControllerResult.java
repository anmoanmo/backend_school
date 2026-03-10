package com.example.backend_development;

public record ControllerResult(boolean redirect, String target) {
    public static ControllerResult forward(String viewPath) {
        return new ControllerResult(false, viewPath);
    }

    public static ControllerResult redirect(String location) {
        return new ControllerResult(true, location);
    }
}
