package com.synapse.controller;

import com.synapse.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * SYNAPSE Core Authorization Controller
 * Target: Tomcat 10.1.55 (Jakarta Servlet 6.0)
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Input Sanity Validation
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid_input");
            return;
        }

        try {
            // Execution of Precise Table Schema Query
            String query = "SELECT id, email, password, role FROM users WHERE email = ?";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query)) {
                
                ps.setString(1, email);
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");
                        String role = rs.getString("role"); // Expected: 'CLINICIAN' or 'ENGINEER'

                        // Credential Verification (In production, use BCrypt/Argon2 hashing)
                        if (storedPassword.equals(password)) {
                            HttpSession session = request.getSession(true);
                            
                            // Bind Role and Identity to Session Vector
                            session.setAttribute("userId", rs.getInt("id"));
                            session.setAttribute("userEmail", rs.getString("email"));
                            session.setAttribute("userRole", role.toUpperCase());
                            
                            // Secure Routing to Unified Dashboard
                            response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
                            System.out.println("[AUTH] Success: " + email + " logged in as " + role);
                        } else {
                            response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid_credentials");
                        }
                    } else {
                        response.sendRedirect(request.getContextPath() + "/index.jsp?error=user_not_found");
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[AUTH ERROR] Database Transaction Failure: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=db_failure");
        } catch (Exception e) {
            System.err.println("[AUTH ERROR] System Subsystem Exception: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=system_error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Prevent direct GET access to authorization logic
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
