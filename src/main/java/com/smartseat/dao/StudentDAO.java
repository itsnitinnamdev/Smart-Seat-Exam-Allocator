package com.smartseat.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.smartseat.model.Student;
import com.smartseat.util.DBConnection;

public class StudentDAO {
	
	// 1. Allocation ke liye students fetch karna (Filters Added)
    public List<Student> getStudentsForAllocation(String branch, String[] semesters, String academicYear, String examType) throws SQLException {
        List<Student> students = new ArrayList<>();
        
        // Logical Mapping: Term Test aur Regular dono 'Regular' category ke students use karte hain
        String studentType = (examType.equals("Regular") || examType.equals("Term Test")) ? "Regular" : examType;

        String placeholders = String.join(",", Collections.nCopies(semesters.length, "?"));
        
        // Updated SQL: academic_year aur student_type filters ke saath
        String sql = "SELECT enrollment_no, name, branch, semester FROM students " +
                     "WHERE branch = ? AND academic_year = ? AND student_type = ? " +
                     "AND semester IN (" + placeholders + ") " +
                     "ORDER BY enrollment_no ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, branch);
            pstmt.setString(2, academicYear);
            pstmt.setString(3, studentType);
            
            for (int i = 0; i < semesters.length; i++) {
                pstmt.setInt(i + 4, Integer.parseInt(semesters[i]));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Student s = new Student();
                    s.setEnrollmentNo(rs.getString("enrollment_no"));
                    s.setName(rs.getString("name"));
                    s.setBranch(rs.getString("branch"));
                    s.setSemester(rs.getInt("semester"));
                    students.add(s);
                }
            }
        }
        return students;
    }

    // 2. Student ko save karne ke liye (Naye columns ke saath)
    public boolean saveStudent(Student student) {
        String query = "INSERT INTO students (enrollment_no, name, branch, semester, email, academic_year, student_type) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, student.getEnrollmentNo());
            pstmt.setString(2, student.getName());
            pstmt.setString(3, student.getBranch());
            pstmt.setInt(4, student.getSemester()); 
            pstmt.setString(5, student.getEmail());
            // In do fields ko Student model mein add karna zaroori hai
            pstmt.setString(6, student.getAcademicYear());
            pstmt.setString(7, student.getStudentType());
            
            int result = pstmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 2. Branch ke students nikalne ke liye (Added Semester fetch)
    public List<Student> getStudentsByBranch(String branch, String[] semesters) {
        List<Student> students = new ArrayList<>();
        String placeholders = String.join(",", java.util.Collections.nCopies(semesters.length, "?"));
        String query = "SELECT * FROM students WHERE branch = ? AND semester IN (" + placeholders + ") ORDER BY enrollment_no ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, branch);
            for(int i=0; i < semesters.length; i++) {
                pstmt.setInt(i + 2, Integer.parseInt(semesters[i]));
            }
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setEnrollmentNo(rs.getString("enrollment_no"));
                s.setName(rs.getString("name"));
                s.setBranch(rs.getString("branch"));
                s.setSemester(rs.getInt("semester"));
                students.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public void clearAllStudents() {
        String query = "DELETE FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
 // Branch aur Semester ke basis par students fetch karne ke liye
    public List<Student> getStudentsByCriteria(String branch, int semester) {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT enrollment_no, name, branch, semester FROM students WHERE branch = ? AND semester = ? ORDER BY enrollment_no ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, branch);
            pstmt.setInt(2, semester);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Student s = new Student();
                s.setEnrollmentNo(rs.getString("enrollment_no"));
                s.setName(rs.getString("name"));
                s.setBranch(rs.getString("branch"));
                s.setSemester(rs.getInt("semester"));
                students.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }
    
 // StudentDAO.java mein ye methods add karein
    public int getTotalStudentsCount() {
        String query = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalAllocations() {
        String query = "SELECT COUNT(*) FROM seating_plan";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
    
 // StudentDAO.java mein add karein
    public List<Map<String, Object>> getSeatingByRoom(String roomNo, String date, String shift) {
        List<Map<String, Object>> plan = new ArrayList<>();
        String sql = "SELECT * FROM seating_plan WHERE room_no = ? AND exam_date = ? AND shift = ? ORDER BY column_no, bench_no, seat_no";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, roomNo);
            pstmt.setString(2, date);
            pstmt.setString(3, shift);
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("column_no", rs.getInt("column_no"));
                row.put("bench_no", rs.getInt("bench_no"));
                row.put("seat_no", rs.getInt("seat_no"));
                row.put("enrollment", rs.getString("student_enrollment"));
                row.put("name", rs.getString("student_name"));
                row.put("branch", rs.getString("branch"));
                plan.add(row);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return plan;
    }
    
 // StudentDAO.java mein ye methods add karein

 // 1. Saare students fetch karne ke liye (View page ke liye)
 public List<Student> getAllStudents() {
     List<Student> students = new ArrayList<>();
     String sql = "SELECT * FROM students ORDER BY branch, semester, name";
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql);
          ResultSet rs = pstmt.executeQuery()) {
         while (rs.next()) {
             Student s = new Student();
             s.setEnrollmentNo(rs.getString("enrollment_no"));
             s.setName(rs.getString("name"));
             s.setBranch(rs.getString("branch"));
             s.setSemester(rs.getInt("semester"));
             s.setEmail(rs.getString("email"));
             s.setAcademicYear(rs.getString("academic_year"));
             s.setStudentType(rs.getString("student_type"));
             students.add(s);
         }
     } catch (SQLException e) { e.printStackTrace(); }
     return students;
 }

 // 2. Enrollment No ke basis par delete karne ke liye
 public boolean deleteStudent(String enrollmentNo) {
     String sql = "DELETE FROM students WHERE enrollment_no = ?";
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement pstmt = conn.prepareStatement(sql)) {
         pstmt.setString(1, enrollmentNo);
         return pstmt.executeUpdate() > 0;
     } catch (SQLException e) { e.printStackTrace(); return false; }
 }
}