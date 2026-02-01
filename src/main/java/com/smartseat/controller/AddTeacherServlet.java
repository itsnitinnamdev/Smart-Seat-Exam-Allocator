package com.smartseat.controller;

import com.smartseat.dao.TeacherDAO;
import com.smartseat.model.Teacher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/AddTeacherServlet")
public class AddTeacherServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String dept = request.getParameter("department");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        Teacher t = new Teacher();
        t.setName(name);
        t.setDepartment(dept);
        t.setEmail(email);
        t.setPhone(phone);

        TeacherDAO dao = new TeacherDAO();
        if(dao.addTeacher(t)) {
            response.sendRedirect("admin/manage-teachers.jsp?message=Teacher Added Successfully");
        } else {
            response.sendRedirect("admin/manage-teachers.jsp?error=Failed to Add Teacher");
        }
    }
}