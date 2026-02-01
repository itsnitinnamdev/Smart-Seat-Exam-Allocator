package com.smartseat.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.smartseat.dao.TeacherDAO;

@WebServlet("/AssignInvigilatorServlet")
public class AssignInvigilatorServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        String roomNo = request.getParameter("roomNo");
        String date = request.getParameter("examDate");
        String shift = request.getParameter("shift");

        TeacherDAO dao = new TeacherDAO();
        if(dao.assignInvigilator(teacherId, roomNo, date, shift)) {
            response.sendRedirect("admin/seating-chart.jsp?roomNo="+roomNo+"&examDate="+date+"&shift="+shift+"&msg=Assigned");
        } else {
            response.sendRedirect("admin/seating-chart.jsp?error=Teacher already busy in another room");
        }
    }
}
