package com.smartseat.controller;

import com.opencsv.CSVReader;
import com.smartseat.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/ImportSubjectsServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10)
public class ImportSubjectsServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("subjectFile");
        
        // SQL query with "Smart Sync": Update if code already exists
        String sql = "INSERT INTO subjects (subject_code, subject_name, branch, semester, academic_year) " +
                "VALUES (?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE " +
                "subject_name = VALUES(subject_name), " +
                "branch = VALUES(branch), " +
                "semester = VALUES(semester), " +
                "academic_year = VALUES(academic_year)";

        try (Connection conn = DBConnection.getConnection();
             CSVReader reader = new CSVReader(new InputStreamReader(filePart.getInputStream()));
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            String[] line;
            int count = 0;
            reader.readNext(); // Skip header row

            while ((line = reader.readNext()) != null) {
                if (line.length < 5) continue;

                pstmt.setString(1, line[0].trim()); // subject_code
                pstmt.setString(2, line[1].trim()); // subject_name
                pstmt.setString(3, line[2].trim()); // branch
                pstmt.setInt(4, Integer.parseInt(line[3].trim())); // semester
                pstmt.setString(5, line[4].trim()); // academic_year
                
                pstmt.addBatch();
                count++;
                if (count % 100 == 0) pstmt.executeBatch();
            }
            pstmt.executeBatch();
            response.sendRedirect("admin/import-subjects.jsp?message=Subjects imported: " + count);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/import-subjects.jsp?error=Upload failed: " + e.getMessage());
        }
    }
}