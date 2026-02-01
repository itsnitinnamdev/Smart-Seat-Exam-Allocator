package com.smartseat.controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.smartseat.util.DBConnection;
import java.util.*;

@WebServlet("/SearchSeatServlet")
public class SearchSeatServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String enrollmentNo = request.getParameter("enrollmentNo");
        
        if(enrollmentNo == null || enrollmentNo.trim().isEmpty()) {
            response.sendRedirect("index.jsp?error=Please enter enrollment number");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Latest exam date ke liye details fetch karna
            String sql = "SELECT * FROM seating_plan WHERE student_enrollment = ? ORDER BY exam_date DESC LIMIT 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, enrollmentNo.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Details ko Map mein daal kar JSP ko bhejna
                Map<String, String> assignment = new HashMap<>();
                
                // Yahan .add() ki jagah .put() use karein
                assignment.put("name", rs.getString("student_name"));
                assignment.put("room", rs.getString("room_no"));
                assignment.put("column", rs.getString("column_no"));
                assignment.put("bench", rs.getString("bench_no"));
                assignment.put("seat", rs.getString("seat_no"));
                assignment.put("date", rs.getString("exam_date"));
                assignment.put("shift", rs.getString("shift"));
                assignment.put("branch", rs.getString("branch"));
                assignment.put("subject", rs.getString("subject_name"));

                request.setAttribute("assignment", assignment);
                request.getRequestDispatcher("search-result.jsp").forward(request, response);
            } else {
                // Agar record nahi mila
            	// Ise use karein (Safe approach)
            	response.sendRedirect(request.getContextPath() + "/home?error=No assignment found for this Enrollment Number");
            }
        } catch (Exception e) {
            e.printStackTrace();
            
         // Ise use karein (Safe approach)
            response.sendRedirect(request.getContextPath() + "/home?error=An error occurred during search");
        }
    }
}