package com.smartseat.controller;

import java.io.IOException;

import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.smartseat.util.DBConnection;

//ReportsServlet.java snippet
@WebServlet("/ReportsServlet")
public class ReportsServlet extends HttpServlet {
 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     int totalAllocated = 0;
     int totalRoomsUsed = 0;
     Map<String, Integer> branchStats = new LinkedHashMap<>();
     List<Map<String, Object>> roomDetails = new ArrayList<>();

     try (Connection conn = DBConnection.getConnection()) {
         // 1. Total Allocated Students fetch karna
         ResultSet rs1 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM seating_plan");
         if(rs1.next()) totalAllocated = rs1.getInt(1);

         // 2. Total Rooms Used fetch karna
         ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(DISTINCT room_no) FROM seating_plan");
         if(rs2.next()) totalRoomsUsed = rs2.getInt(1);

         // 3. Branch-wise Statistics fetch karna
         ResultSet rs3 = conn.createStatement().executeQuery("SELECT branch, COUNT(*) as count FROM seating_plan GROUP BY branch");
         while(rs3.next()) {
             branchStats.put(rs3.getString("branch"), rs3.getInt("count"));
         }

         // 4. Room Details aur Utilization fetch karna
         String roomQuery = "SELECT r.room_no, r.building_block, (r.total_columns * r.benches_per_column * 2) as capacity, " +
                            "COUNT(sp.student_enrollment) as allocated " +
                            "FROM rooms r JOIN seating_plan sp ON r.room_no = sp.room_no " +
                            "GROUP BY r.room_no, r.building_block";
         ResultSet rs4 = conn.createStatement().executeQuery(roomQuery);
         while(rs4.next()) {
             Map<String, Object> room = new HashMap<>();
             int cap = rs4.getInt("capacity");
             int alloc = rs4.getInt("allocated");
             long util = (cap > 0) ? (long)((double)alloc / cap * 100) : 0;
             
             room.put("roomNo", rs4.getString("room_no"));
             room.put("block", rs4.getString("building_block"));
             room.put("capacity", cap);
             room.put("allocated", alloc);
             room.put("utilization", util);
             roomDetails.add(room);
         }

         // Attributes set karke JSP par forward karna 
         request.setAttribute("totalAllocated", totalAllocated);
         request.setAttribute("totalRoomsUsed", totalRoomsUsed);
         request.setAttribute("branchStats", branchStats);
         request.setAttribute("roomDetails", roomDetails);
         request.setAttribute("avgUtilization", calculateAvg(roomDetails));

     } catch (Exception e) { e.printStackTrace(); }
     request.getRequestDispatcher("admin/reports.jsp").forward(request, response);
 }

 private long calculateAvg(List<Map<String, Object>> rooms) {
     if(rooms.isEmpty()) return 0;
     long totalUtil = 0;
     for(Map<String, Object> r : rooms) totalUtil += (Long)r.get("utilization");
     return totalUtil / rooms.size();
 }
}