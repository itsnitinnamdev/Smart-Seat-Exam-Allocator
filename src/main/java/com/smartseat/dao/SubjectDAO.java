package com.smartseat.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.smartseat.model.Subject;
import com.smartseat.util.DBConnection;

public class SubjectDAO {
    
    // Branch aur Semester ke basis par subjects fetch karne ke liye (AJAX ke kaam aayega)
    public List<Subject> getSubjectsByCriteria(String branch, int semester) {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects WHERE branch = ? AND semester = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, branch);
            pstmt.setInt(2, semester);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("id"));
                s.setSubjectCode(rs.getString("subject_code"));
                s.setSubjectName(rs.getString("subject_name"));
                s.setBranch(rs.getString("branch"));
                s.setSemester(rs.getInt("semester"));
                subjects.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }
    
 // SubjectDAO.java mein ye method add karein
    public List<Subject> getAllSubjects() {
        List<Subject> subjects = new ArrayList<>();
        String sql = "SELECT * FROM subjects ORDER BY branch, semester, subject_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Subject s = new Subject();
                s.setId(rs.getInt("id"));
                s.setSubjectCode(rs.getString("subject_code"));
                s.setSubjectName(rs.getString("subject_name"));
                s.setBranch(rs.getString("branch"));
                s.setSemester(rs.getInt("semester"));
                s.setAcademicYear(rs.getString("academic_year"));
                subjects.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return subjects;
    }
    
 // SubjectDAO.java mein add karein
    public boolean deleteSubject(int id) {
        String sql = "DELETE FROM subjects WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}