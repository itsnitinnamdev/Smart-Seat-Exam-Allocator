package com.smartseat.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartseat.dao.TeacherDAO;
import com.smartseat.model.Teacher;

@WebServlet("/UpdateTeacherServlet")
public class UpdateTeacherServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Data retrieve karein
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String department = request.getParameter("department");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        // 2. Model object mein data set karein
        Teacher teacher = new Teacher();
        teacher.setId(id);
        teacher.setName(name);
        teacher.setDepartment(department);
        teacher.setEmail(email);
        teacher.setPhone(phone);

        // 3. DAO call karke database update karein
        TeacherDAO dao = new TeacherDAO();
        boolean success = dao.updateTeacher(teacher);

        // 4. Redirect back to the management page
        if(success) {
            response.sendRedirect("admin/manage-teachers.jsp?msg=updated");
        } else {
            response.sendRedirect("admin/manage-teachers.jsp?error=failed");
        }
    }
}
