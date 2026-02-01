package com.smartseat.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet; // Added for check logic
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartseat.util.DBConnection;

@WebServlet("/AddRoomServlet")
public class AddRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. JSP form se data nikalna
        String roomNo = request.getParameter("roomNo").trim(); // trim() to remove extra spaces
        String buildingBlock = request.getParameter("buildingBlock");
        int floor = Integer.parseInt(request.getParameter("floor"));
        int totalColumns = Integer.parseInt(request.getParameter("totalColumns"));
        int benchesPerColumn = Integer.parseInt(request.getParameter("benchesPerColumn"));

        try (Connection conn = DBConnection.getConnection()) {
            
            // --- NEW: Validation Logic ---
            // Pehle check karein ki roomNo already exist toh nahi karta
            String checkSql = "SELECT COUNT(*) FROM rooms WHERE room_no = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, roomNo);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Room already exists in database
                response.sendRedirect("admin/add-room.jsp?error=Room Number '" + roomNo + "' already exists!");
                return; // Execution yahi stop karein
            }
            // -----------------------------

            // 2. Database mein insert karna agar unique hai
            String insertSql = "INSERT INTO rooms (room_no, building_block, floor, total_columns, benches_per_column) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, roomNo);
            pstmt.setString(2, buildingBlock);
            pstmt.setInt(3, floor);
            pstmt.setInt(4, totalColumns);
            pstmt.setInt(5, benchesPerColumn);

            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("admin/add-room.jsp?message=Room Added Successfully!");
            } else {
                response.sendRedirect("admin/add-room.jsp?error=Failed to add room.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/add-room.jsp?error=Server Error: " + e.getMessage());
        }
    }
}