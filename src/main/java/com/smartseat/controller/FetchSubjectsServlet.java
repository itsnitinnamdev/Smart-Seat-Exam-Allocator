package com.smartseat.controller;

import com.smartseat.dao.SubjectDAO;
import com.smartseat.model.Subject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/FetchSubjectsServlet")
public class FetchSubjectsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String branch = request.getParameter("branch");
        String semStr = request.getParameter("semester");

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        if (branch != null && !branch.trim().isEmpty() && semStr != null && !semStr.trim().isEmpty()) {
            try {
                int semester = Integer.parseInt(semStr);
                SubjectDAO subjectDAO = new SubjectDAO();
                
                // Humne SubjectDAO mein ye method banaya tha
                List<Subject> subjects = subjectDAO.getSubjectsByCriteria(branch, semester);

                // Simple JSON String manually construct karna
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < subjects.size(); i++) {
                    Subject s = subjects.get(i);
                    json.append("{");
                    json.append("\"id\":").append(s.getId()).append(",");
                    json.append("\"name\":\"").append(s.getSubjectName()).append("\"");
                    json.append("}");
                    if (i < subjects.size() - 1) json.append(",");
                }
                json.append("]");

                out.print(json.toString());
            } catch (Exception e) {
                e.printStackTrace();
                out.print("[]");
            }
        } else {
            out.print("[]");
        }
    }
}