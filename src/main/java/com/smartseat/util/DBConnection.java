package com.smartseat.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    public static Connection getConnection() {
        // Render/Production ke liye Env Vars uthayega
        String url = System.getenv("mysql://ubyiy6eebbnskr6q:Gds5w62Ed4czabaNnFyR@bqecn9pa4bxabl0zmxzl-mysql.services.clever-cloud.com:3306/bqecn9pa4bxabl0zmxzl");
        String user = System.getenv("ubyiy6eebbnskr6q");
        String pass = System.getenv("Gds5w62Ed4czabaNnFyR");

        // Agar Env Vars null hain (yani aap local machine par ho), toh hardcoded use karein
        if (url == null) {
            url = "jdbc:mysql://localhost:3306/smart_seat_db"; // Apne local DB ka naam check karein
            user = "root";
            pass = "root"; // Apna local password likhein
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Database Connection Failed: " + e.getMessage());
            return null;
        }
    }
}