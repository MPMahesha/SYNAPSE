package com.synapse.controller;

import com.google.gson.Gson;
import com.synapse.util.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard/*"})
public class DashboardServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        String role = (String) session.getAttribute("role");

        if ("/clinician".equals(pathInfo) && "CLINICIAN".equals(role)) {
            handleClinicianDashboard(request, response);
        } else if ("/engineer".equals(pathInfo) && "ENGINEER".equals(role)) {
            handleEngineerDashboard(request, response);
        } else if ("/data".equals(pathInfo)) {
            fetchTimeSeriesData(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    private void handleClinicianDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> patients = new ArrayList<>();
        String query = "SELECT p.id, p.full_name, p.clinical_status, s.moca_score, s.alsfrs_score " +
                       "FROM patients p LEFT JOIN pre_op_screenings s ON p.id = s.patient_id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Map<String, Object> patient = new HashMap<>();
                patient.put("id", rs.getInt("id"));
                patient.put("name", rs.getString("full_name"));
                patient.put("status", rs.getString("clinical_status"));
                patient.put("moca", rs.getInt("moca_score"));
                patient.put("alsfrs", rs.getInt("alsfrs_score"));
                patients.add(patient);
            }
            request.setAttribute("patients", patients);
            request.getRequestDispatcher("/WEB-INF/views/clinician-dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleEngineerDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/engineer-dashboard.jsp").forward(request, response);
    }

    private void fetchTimeSeriesData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int patientId = 2; // Defaulting to Gordon Freeman for demo
        Map<String, List<Object>> data = new HashMap<>();
        List<Object> snr = new ArrayList<>();
        List<Object> impedance = new ArrayList<>();
        List<Object> itr = new ArrayList<>();
        List<Object> labels = new ArrayList<>();

        String query = "SELECT h.snr, h.impedance, d.itr, h.recorded_at " +
                       "FROM hardware_metrics h " +
                       "JOIN decoding_metrics d ON h.patient_id = d.patient_id AND h.recorded_at = d.recorded_at " +
                       "WHERE h.patient_id = ? ORDER BY h.recorded_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                snr.add(rs.getDouble("snr"));
                impedance.add(rs.getDouble("impedance"));
                itr.add(rs.getDouble("itr"));
                labels.add(rs.getTimestamp("recorded_at").toString());
            }
            data.put("snr", snr);
            data.put("impedance", impedance);
            data.put("itr", itr);
            data.put("labels", labels);

            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(data));
        } catch (SQLException e) {
            response.sendError(500, e.getMessage());
        }
    }
}
