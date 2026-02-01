package com.smartseat.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.smartseat.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            
            // UPDATE: Ab hum 'users' table se data fetch kar rahe hain
            String sql = "SELECT * FROM users WHERE username = ? AND status = 'Active'";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String hashedPasswordFromDB = rs.getString("password");
                String fullName = rs.getString("full_name");
                String role = rs.getString("role"); // Role fetch karna (Admin/Staff)

                // BCrypt se password compare karna
                // Note: Agar aapne manually database mein password 'admin123' dala hai bina hash ke, 
                // toh ye check fail ho jayega. Testing ke liye aap check badal sakte hain.
                if (BCrypt.checkpw(pass, hashedPasswordFromDB)) {
                    
                    // Login Success: Session create karna
                    HttpSession session = request.getSession();
                    session.setAttribute("adminUser", user);
                    session.setAttribute("adminName", fullName);
                    session.setAttribute("adminRole", role); // Session mein role save karna
                    
                    // Dashboard par bhej dena
                    response.sendRedirect("admin/dashboard.jsp");
                } else {
                    response.sendRedirect("user/login.jsp?error=Invalid Password");
                }
            } else {
                response.sendRedirect("user/login.jsp?error=User Not Found or Inactive");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user/login.jsp?error=Server Error: " + e.getMessage());
        } finally {
            try { 
                if (rs != null) rs.close(); 
                if (pstmt != null) pstmt.close(); 
                if (conn != null) conn.close(); 
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
}