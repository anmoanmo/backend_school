package com.example.backend_development;

public class LoginService {
    public static final String DEMO_USERNAME = "admin";
    public static final String DEMO_PASSWORD = "123456";

    public boolean validate(String username, String password) {
        return DEMO_USERNAME.equals(username) && DEMO_PASSWORD.equals(password);
    }
}
