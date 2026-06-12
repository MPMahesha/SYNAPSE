package com.synapse.service;

import com.synapse.util.DBConnection;
import java.security.SecureRandom;
import java.sql.*;
import java.time.LocalDateTime;

public class AuthService {
    private static final String CAPS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String LOWERS = "abcdefghijklmnopqrstuvwxyz";
    private static final String DIGITS = "0123456789";
    private static final String SYMBOLS = "!@#$%^&*()-_=+";
    private static final SecureRandom RANDOM = new SecureRandom();

    public String generateSecurePassword(int length) {
        StringBuilder sb = new StringBuilder(length);
        String allChars = CAPS + LOWERS + DIGITS + SYMBOLS;
        for (int i = 0; i < length; i++) {
            sb.append(allChars.charAt(RANDOM.nextInt(allChars.length())));
        }
        return sb.toString();
    }

    public String generateNumericOTP(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(DIGITS.charAt(RANDOM.nextInt(DIGITS.length())));
        }
        return sb.toString();
    }

    public boolean validateAndUseSystemKey(String key, String role) {
        String query = "SELECT id FROM system_keys WHERE key_value = ? AND role = ? AND is_used = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, key);
            ps.setString(2, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int id = rs.getInt("id");
                String update = "UPDATE system_keys SET is_used = TRUE WHERE id = ?";
                try (PreparedStatement ups = conn.prepareStatement(update)) {
                    ups.setInt(1, id);
                    ups.executeUpdate();
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean initiatePasswordReset(String target, boolean isEmail) {
        String otp = generateNumericOTP(6);
        String query = isEmail ? "UPDATE users SET otp = ?, otp_expiry = ? WHERE email = ?" 
                               : "UPDATE users SET otp = ?, otp_expiry = ? WHERE phone = ?"; // Assuming phone field exists or handled by target
        
        LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, otp);
            ps.setTimestamp(2, Timestamp.valueOf(expiry));
            ps.setString(3, target);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                System.out.println("[EMULATION LOG] Password reset initiated for: " + target);
                System.out.println("[EMULATION LOG] Generated OTP: " + otp);
                System.out.println("[EMULATION LOG] Expiry: " + expiry);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean validateOTP(String email, String otp) {
        String query = "SELECT id FROM users WHERE email = ? AND otp = ? AND otp_expiry > ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
