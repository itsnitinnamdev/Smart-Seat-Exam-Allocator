package com.smartseat.controller;

import com.opencsv.CSVReader;
import com.smartseat.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ImportStudentsServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)   
public class ImportStudentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @SuppressWarnings("unused")
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("studentFile"); 
        
        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("admin/import-students.jsp?error=Please select a valid CSV file");
            return;
        }

        // SMART SQL: Agar enrollment_no match hua toh semester/name/branch update ho jayega
        String sql = "INSERT INTO students (enrollment_no, name, branch, semester, email, academic_year, student_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE " +
                "name = VALUES(name), branch = VALUES(branch), " +
                "semester = VALUES(semester), email = VALUES(email), " +
                "academic_year = VALUES(academic_year), student_type = VALUES(student_type)";
        
        try (Connection conn = DBConnection.getConnection(); 
             CSVReader reader = new CSVReader(new InputStreamReader(filePart.getInputStream()));
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (conn == null) throw new Exception("Database connection failed!");

            String[] nextLine;
            int count = 0;
            reader.readNext(); // Skip header

            while ((nextLine = reader.readNext()) != null) {
                // Check karein ki line khali toh nahi ya columns kam toh nahi hain
                // Aapko kam se kam 5 columns chahiye (0 se 4 tak)
            	if (nextLine == null || nextLine.length < 7) {
                    continue; 
                }

                try {
                    pstmt.setString(1, nextLine[0].trim()); // enrollment_no
                    pstmt.setString(2, nextLine[1].trim()); // name
                    pstmt.setString(3, nextLine[2].trim()); // branch
                    pstmt.setInt(4, Integer.parseInt(nextLine[3].trim())); // semester
                    pstmt.setString(5, nextLine[4].trim()); // email
                    pstmt.setString(6, nextLine[5].trim()); // academic_year (e.g., 2025-2026)
                    pstmt.setString(7, nextLine[6].trim()); // student_type (Regular/Supplementary)
                    
                    pstmt.addBatch();
                    count++;
                } catch (Exception e) {
                    System.err.println("Skipping invalid row: " + java.util.Arrays.toString(nextLine));
                    continue;
                }
                
                if (count % 500 == 0) { pstmt.executeBatch(); }
            }
            
            pstmt.executeBatch(); 
            response.sendRedirect("admin/import-students.jsp?message=Data Synchronized Successfully! Total processed: " + count);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/import-students.jsp?error=Sync failed: " + e.getMessage());
        }
    }
}