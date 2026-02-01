package com.smartseat.dao;

import java.sql.*;
import java.util.*;
import com.smartseat.model.Teacher;
import com.smartseat.util.DBConnection;

public class TeacherDAO {
    public boolean addTeacher(Teacher t) {
        String sql = "INSERT INTO teachers (name, department, email, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, t.getName());
            pstmt.setString(2, t.getDepartment());
            pstmt.setString(3, t.getEmail());
            pstmt.setString(4, t.getPhone());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Teacher> getAllTeachers() {
        List<Teacher> teachers = new ArrayList<>();
        
        // SQL Query: Is_deleted = 0 ensures we don't show removed faculty
        // ORDER BY name ASC helps in keeping the list organized
        String query = "SELECT * FROM teachers WHERE is_deleted = 0 ORDER BY name ASC";
        
        try (Connection connection = DBConnection.getConnection(); // Make sure your getConnection() is defined
             PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Teacher teacher = new Teacher();
                
                // Setting values from Database to Teacher Object
                // Column names should match your MySQL table schema
                teacher.setId(rs.getInt("teacher_id")); 
                teacher.setName(rs.getString("name")); 
                teacher.setDepartment(rs.getString("department")); 
                teacher.setEmail(rs.getString("email")); 
                teacher.setPhone(rs.getString("phone")); 
                
                teachers.add(teacher); 
            }
        } catch (SQLException e) {
            System.out.println("Error fetching teachers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return teachers; 
    }
    
 // TeacherDAO.java mein add karein
    public boolean deleteTeacher(int id) {
        boolean rowUpdated = false;
        // Database se delete karne ki jagah bas is_deleted ko 1 kar do
        String query = "UPDATE teachers SET is_deleted = 1 WHERE teacher_id = ?";
        
        try (Connection connection = DBConnection.getConnection(); 
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, id);
            rowUpdated = statement.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }
    
 // TeacherDAO.java mein add karein

 // 1. Duty assign ya update karne ke liye
 public boolean assignInvigilator(int teacherId, String roomNo, String date, String shift) {
     // ON DUPLICATE KEY UPDATE use kiya hai taaki agar room change ho to update ho jaye
     String sql = "INSERT INTO invigilator_assignments (teacher_id, room_no, exam_date, shift) " +
                  "VALUES (?, ?, ?, ?) " +
                  "ON DUPLICATE KEY UPDATE room_no = VALUES(room_no)";
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setInt(1, teacherId);
         pstmt.setString(2, roomNo);
         pstmt.setString(3, date);
         pstmt.setString(4, shift);
         return pstmt.executeUpdate() > 0;
     } catch (SQLException e) { e.printStackTrace(); return false; }
 }

 // 2. Specific room ka assigned teacher nikalne ke liye
 public String getAssignedTeacher(String roomNo, String date, String shift) {
     String sql = "SELECT t.name FROM teachers t JOIN invigilator_assignments ia " +
                  "ON t.teacher_id = ia.teacher_id WHERE ia.room_no = ? AND ia.exam_date = ? AND ia.shift = ?";
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setString(1, roomNo);
         pstmt.setString(2, date);
         pstmt.setString(3, shift);
         ResultSet rs = pstmt.executeQuery();
         if (rs.next()) return rs.getString("name");
     } catch (SQLException e) { e.printStackTrace(); }
     return "Not Assigned";
 }
 
 public boolean updateTeacher(Teacher teacher) {
	    boolean rowUpdated = false;
	    String query = "UPDATE teachers SET name = ?, department = ?, email = ?, phone = ? WHERE teacher_id = ?";
	    
	    try (Connection connection = DBConnection.getConnection(); // Aapka DB connection method
	         PreparedStatement statement = connection.prepareStatement(query)) {
	        
	        statement.setString(1, teacher.getName());
	        statement.setString(2, teacher.getDepartment());
	        statement.setString(3, teacher.getEmail());
	        statement.setString(4, teacher.getPhone());
	        statement.setInt(5, teacher.getId());

	        rowUpdated = statement.executeUpdate() > 0;
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return rowUpdated;
	}
 
 
}