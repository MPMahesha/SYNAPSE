package com.synapse.controller;

import com.synapse.service.AuthService;
import com.synapse.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth/*"})
public class AuthServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        if ("/login".equals(pathInfo)) {
            handleLogin(request, response);
        } else if ("/register".equals(pathInfo)) {
            handleRegister(request, response);
        } else if ("/verify-otp".equals(pathInfo)) {
            handleVerifyRegisterOTP(request, response);
        } else if ("/forgot-password".equals(pathInfo)) {
            handleForgotPassword(request, response);
        } else if ("/reset-password".equals(pathInfo)) {
            handleResetPassword(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Fault Isolation: Session Fallback for Interrupted Requests
        HttpSession existingSession = request.getSession(false);
        if (existingSession != null && existingSession.getAttribute("user") != null) {
            String role = (String) existingSession.getAttribute("role");
            response.sendRedirect(request.getContextPath() + ("/CLINICIAN".equalsIgnoreCase(role) ? "/dashboard/clinician" : "/dashboard/engineer"));
            return;
        }

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (isInvalid(email) || isInvalid(password)) {
            forwardWithError(request, response, "/WEB-INF/views/login.jsp", "Credentials cannot be empty");
            return;
        }

        try {
            // Aligned with (id, email, password, role) schema
            String query = "SELECT email, password, role FROM users WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String role = rs.getString("role"); // ENUM: 'CLINICIAN' or 'ENGINEER'
                    
                    if (storedPassword.equals(password)) {
                        HttpSession session = request.getSession(true);
                        session.setAttribute("user", email);
                        session.setAttribute("role", role);
                        
                        response.sendRedirect(request.getContextPath() + ("/CLINICIAN".equalsIgnoreCase(role) ? "/dashboard/clinician" : "/dashboard/engineer"));
                    } else {
                        forwardWithError(request, response, "/WEB-INF/views/login.jsp", "Invalid security credentials");
                    }
                } else {
                    forwardWithError(request, response, "/WEB-INF/views/login.jsp", "Invalid security credentials");
                }
            }
        } catch (Exception e) {
            System.err.println("Subsystem Exception: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=auth_subsystem_offline");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String systemKey = request.getParameter("systemKey");

        if (isInvalid(username) || isInvalid(email) || isInvalid(password) || isInvalid(systemKey)) {
            forwardWithError(request, response, "/WEB-INF/views/register.jsp", "All fields are required");
            return;
        }

        try {
            // 1. Validate System Authorization Key
            if (authService.validateAndUseSystemKey(systemKey, role)) {
                // 2. Generate 2FA OTP
                String otp = authService.generateNumericOTP(6);
                LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);

                String query = "INSERT INTO users (email, password, role, otp, otp_expiry) VALUES (?, ?, ?, ?, ?)";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(query)) {
                    ps.setString(1, email);
                    ps.setString(2, password);
                    ps.setString(3, role);
                    ps.setString(4, otp);
                    ps.setTimestamp(5, Timestamp.valueOf(expiry));
                    ps.executeUpdate();

                    System.out.println("[2FA EMULATION] OTP for " + email + ": " + otp);
                    
                    // Redirect to OTP Verification View
                    request.setAttribute("email", email);
                    request.getRequestDispatcher("/WEB-INF/views/verify-otp.jsp").forward(request, response);
                }
            } else {
                forwardWithError(request, response, "/WEB-INF/views/register.jsp", "Invalid or used System Authorization Key");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=db_failure");
        }
    }

    private void handleVerifyRegisterOTP(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");

        if (authService.validateOTP(email, otp)) {
            // Clear OTP and activate (implied by clearing OTP)
            String query = "UPDATE users SET otp = NULL, otp_expiry = NULL WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, email);
                ps.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/auth/login?success=verified");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        } else {
            request.setAttribute("email", email);
            forwardWithError(request, response, "/WEB-INF/views/verify-otp.jsp", "Invalid or expired verification token");
        }
    }

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        if (authService.initiatePasswordReset(email, true)) {
            response.sendRedirect(request.getContextPath() + "/auth/reset-password?email=" + email);
        } else {
            forwardWithError(request, response, "/WEB-INF/views/forgot-password.jsp", "Email not found");
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        if (authService.validateOTP(email, otp)) {
            String query = "UPDATE users SET password = ?, otp = NULL, otp_expiry = NULL WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, newPassword);
                ps.setString(2, email);
                ps.executeUpdate();
                response.sendRedirect(request.getContextPath() + "/auth/login?success=reset");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
        } else {
            forwardWithError(request, response, "/WEB-INF/views/forgot-password.jsp", "Invalid or expired token");
        }
    }

    private boolean isInvalid(String str) {
        return str == null || str.trim().isEmpty();
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String path, String error) throws ServletException, IOException {
        request.setAttribute("error", error);
        request.getRequestDispatcher(path).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if ("/login".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else if ("/register".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else if ("/forgot-password".equals(pathInfo)) {
            request.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp").forward(request, response);
        } else if ("/logout".equals(pathInfo)) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login");
        } else {
            // Default to landing page
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}
