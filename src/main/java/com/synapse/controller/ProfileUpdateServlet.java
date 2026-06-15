package com.synapse.controller;

import com.synapse.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "ProfileUpdateServlet", urlPatterns = {"/api/update-profile"})
public class ProfileUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String email = request.getParameter("email");
        String currentEmail = (String) session.getAttribute("userEmail");

        // Simple update logic for research profile
        String query = "UPDATE users SET email = ? WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setString(1, email);
            ps.setString(2, currentEmail);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                session.setAttribute("userEmail", email);
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?status=profile_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=update_failed");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard.jsp?error=db_failure");
        }
    }
}
