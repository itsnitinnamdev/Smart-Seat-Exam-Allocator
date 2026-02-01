package com.smartseat.controller;

import com.smartseat.dao.TeacherDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteTeacherServlet")
public class DeleteTeacherServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            TeacherDAO dao = new TeacherDAO();
            
            if(dao.deleteTeacher(id)) {
                response.sendRedirect("admin/manage-teachers.jsp?message=Teacher removed successfully");
            } else {
                response.sendRedirect("admin/manage-teachers.jsp?error=Could not delete teacher");
            }
        } else {
            response.sendRedirect("admin/manage-teachers.jsp");
        }
    }
}