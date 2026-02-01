package com.smartseat.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import org.mindrot.jbcrypt.BCrypt; 
import com.smartseat.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Form se parameters fetch karna
        String fullName = request.getParameter("fullname");
        String user = request.getParameter("username");
        String rawPassword = request.getParameter("password");

        // 1. Password ko Hash karna (Security ke liye BCrypt use kar rahe hain)
        String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt());

        try (Connection conn = DBConnection.getConnection()) {
            // 2. SQL Query Update: 'admins' ki jagah 'users' table aur 'role' column add kiya
            String sql = "INSERT INTO users (full_name, username, password, role, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, fullName);
            pstmt.setString(2, user);
            pstmt.setString(3, hashedPassword); 
            pstmt.setString(4, "System Admin"); // Default role for this registration
            pstmt.setString(5, "Active");       // Account status Active rakhne ke liye

            int result = pstmt.executeUpdate();
            if (result > 0) {
                // Success message ke saath redirect
                response.sendRedirect("index.jsp?msg=Registration Successful! Please Login.");
            }
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            // Agar username pehle se exist karta ho
            response.sendRedirect("register.jsp?error=Username already exists");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=Error: " + e.getMessage());
        }
    }
}