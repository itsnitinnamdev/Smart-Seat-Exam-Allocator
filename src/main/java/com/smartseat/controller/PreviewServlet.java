package com.smartseat.controller;

import com.smartseat.dao.StudentDAO;
import com.smartseat.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/PreviewServlet")
public class PreviewServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomNo = request.getParameter("roomNo");
        String date = request.getParameter("date");
        String shift = request.getParameter("shift");

        StudentDAO dao = new StudentDAO();
        Map<String, List<Map<String, Object>>> seatingMap = new HashMap<>();
        int totalCols = 0;
        int benchesPerCol = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Room ki dimensions fetch karein
            String roomSql = "SELECT total_columns, benches_per_column FROM rooms WHERE room_no = ?";
            try (PreparedStatement ps = conn.prepareStatement(roomSql)) {
                ps.setString(1, roomNo);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    totalCols = rs.getInt("total_columns");
                    benchesPerCol = rs.getInt("benches_per_column");
                }
            }

            // 2. Seating plan fetch karein aur group karein
            List<Map<String, Object>> rawData = dao.getSeatingByRoom(roomNo, date, shift);
            for (Map<String, Object> seat : rawData) {
                // Key format: "column-bench" (e.g., "1-2")
                String key = seat.get("column_no") + "-" + seat.get("bench_no");
                seatingMap.computeIfAbsent(key, k -> new ArrayList<>()).add(seat);
            }

            // 3. Data JSP ko pass karein
            request.setAttribute("seatingMap", seatingMap);
            request.setAttribute("totalCols", totalCols);
            request.setAttribute("benchesPerCol", benchesPerCol);
            request.getRequestDispatcher("admin/visual-preview.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/seating-chart.jsp?error=" + e.getMessage());
        }
    }
}