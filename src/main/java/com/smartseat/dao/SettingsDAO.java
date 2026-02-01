package com.smartseat.dao;

import java.sql.*;
import java.util.*;
import com.smartseat.util.DBConnection;

public class SettingsDAO {
    
    // Saari settings fetch karne ke liye (Map use karna convenient rahega)
    public Map<String, String> getAllSettings() {
        Map<String, String> settings = new HashMap<>();
        String query = "SELECT setting_key, setting_value FROM system_settings";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                settings.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return settings;
    }

    // Specific setting update karne ke liye
    public boolean updateSetting(String key, String value) {
        String query = "UPDATE system_settings SET setting_value = ? WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, value);
            pstmt.setString(2, key);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateMultipleSettings(Map<String, String> settingsMap) {
        String query = "UPDATE system_settings SET setting_value = ? WHERE setting_key = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Transaction handling for scalability
            try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                for (Map.Entry<String, String> entry : settingsMap.entrySet()) {
                    pstmt.setString(1, entry.getValue());
                    pstmt.setString(2, entry.getKey());
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}