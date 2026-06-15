package com.synapse.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "TelemetryServlet", urlPatterns = {"/api/*"})
public class TelemetryServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized Research Access\"}");
            return;
        }

        Map<String, Object> data = new HashMap<>();
        
        // Emulating cached metrics from the Python bridge
        if ("/metrics".equals(pathInfo)) {
            data.put("snr", 22.8);
            data.put("impedance", 4.3);
            data.put("sampling_rate", 250);
        } else if ("/intent".equals(pathInfo)) {
            data.put("last_intent", "LEFT_HAND");
            data.put("confidence", 94.2);
            data.put("stability", "High");
        } else if ("/session".equals(pathInfo)) {
            data.put("subject_id", "NS-2026-X49");
            data.put("session_start", session.getCreationTime());
            data.put("role", session.getAttribute("userRole"));
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            data.put("error", "Endpoint not provisioned");
        }

        response.getWriter().write(gson.toJson(data));
    }
}
