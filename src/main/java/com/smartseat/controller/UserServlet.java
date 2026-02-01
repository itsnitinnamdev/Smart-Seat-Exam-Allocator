package com.smartseat.controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;
import com.smartseat.util.DBConnection;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 1. Sidebar link par click karne par users dikhane ke liye logic
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> userList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while(rs.next()) {
                Map<String, String> user = new HashMap<>();
                user.put("id", rs.getString("user_id"));
                user.put("name", rs.getString("full_name"));
                user.put("username", rs.getString("username"));
                user.put("role", rs.getString("role"));
                user.put("status", rs.getString("status"));
                user.put("created_at", rs.getString("created_at"));
                userList.add(user);
            }
            
            request.setAttribute("userList", userList);
            // Naye redesigned page par forward karein
            request.getRequestDispatcher("admin/users.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/dashboard.jsp?error=Failed to load users");
        }
    }

    // 2. Modal form se naya Staff/Admin add karne ke liye logic
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email"); // Added
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String status = request.getParameter("status"); // Added

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try (Connection conn = DBConnection.getConnection()) {
            // SQL query update kari (Email column ke saath)
            String sql = "INSERT INTO users (full_name, username, email, password, role, status) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.setString(4, hashedPassword);
            ps.setString(5, role);
            ps.setString(6, status);

            if (ps.executeUpdate() > 0) {
                // Success ke baad context path use karke redirect karein
                response.sendRedirect(request.getContextPath() + "/UserServlet?msg=User added successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Error aane par wapas list par bhej dein
            response.sendRedirect(request.getContextPath() + "/UserServlet?error=Error adding user: " + e.getMessage());
        }
    }
}