package com.smartseat.controller;

import com.smartseat.dao.SubjectDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteSubjectServlet")
public class DeleteSubjectServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            SubjectDAO dao = new SubjectDAO();
            if (dao.deleteSubject(id)) {
                response.sendRedirect("admin/view-subjects.jsp?message=Subject Deleted Successfully");
            } else {
                response.sendRedirect("admin/view-subjects.jsp?error=Deletion Failed");
            }
        }
    }
}