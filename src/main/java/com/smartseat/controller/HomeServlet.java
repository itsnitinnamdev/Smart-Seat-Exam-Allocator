package com.smartseat.controller;

import com.smartseat.dao.StudentDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/home", ""}) // Isse portal '/home' par khulega
public class HomeServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StudentDAO dao = new StudentDAO();
        
        // Database se dynamic data lana
        int totalStudents = dao.getTotalStudentsCount();
        int totalAllocated = dao.getTotalAllocations();
        
        // Rooms count ke liye aap direct SQL bhi chala sakte hain ya DAO method
        // Abhi ke liye hum in values ko request scope mein set kar rahe hain
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalAllocated", totalAllocated);
        request.setAttribute("totalHalls", 15); // Example: Isse bhi DAO se layein

        // index.jsp par data ke saath bhej dena
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}