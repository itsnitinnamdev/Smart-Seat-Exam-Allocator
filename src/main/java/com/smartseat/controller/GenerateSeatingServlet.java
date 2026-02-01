package com.smartseat.controller;

import com.smartseat.dao.StudentDAO;
import com.smartseat.model.Student;
import com.smartseat.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/GenerateSeatingServlet")
public class GenerateSeatingServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String examDate = request.getParameter("examDate");
        String shiftFull = request.getParameter("shift");
        String[] semesters = request.getParameterValues("semesters");
        String[] branches = request.getParameterValues("branches");
        String[] roomIds = request.getParameterValues("roomIds");
        String academicYear = request.getParameter("academicYear");
        String examType = request.getParameter("examType");
        String subject1 = request.getParameter("subject1");
        String subject2 = request.getParameter("subject2");

        // Settings se dynamic data uthana
        String seatsAttr = (String) getServletContext().getAttribute("default_students_per_bench");
        int seatsPerBench = Integer.parseInt(seatsAttr != null ? seatsAttr : "2");
        String shift = (shiftFull != null) ? shiftFull.split(" ")[0] : "";

        StudentDAO studentDAO = new StudentDAO();

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // Transaction safety
         // Purana global delete hata kar ye targeted delete likhein
            String deleteSql = "DELETE FROM seating_plan WHERE room_no = ? AND exam_date = ? AND shift = ?";
            try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
                for (String rId : roomIds) {
                    psDelete.setString(1, rId);
                    psDelete.setString(2, examDate);
                    psDelete.setString(3, shift);
                    psDelete.addBatch();
                }
                psDelete.executeBatch();
            }

            // 1. DAO ka use karke har branch ke students ki list lana
            List<List<Student>> allBranchesData = new ArrayList<>();
            for (String branch : branches) {
                // Ab ye academicYear aur examType ke basis par filter karega
                allBranchesData.add(studentDAO.getStudentsForAllocation(branch, semesters, academicYear, examType));
            }
            
            int[] pointers = new int[allBranchesData.size()]; // Har branch ke liye pointer
            int totalAllocated = 0;

            String sql = "INSERT INTO seating_plan (room_no, column_no, bench_no, seat_no, student_enrollment, student_name, branch, semester, exam_date, shift, subject_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                for (String rId : roomIds) {
                    // Room dimensions fetch karna
                    try (PreparedStatement psR = conn.prepareStatement("SELECT total_columns, benches_per_column FROM rooms WHERE room_no = ?")) {
                        psR.setString(1, rId);
                        ResultSet rsR = psR.executeQuery();

                        if (rsR.next()) {
                            int cols = rsR.getInt("total_columns");
                            int benches = rsR.getInt("benches_per_column");

                            // Vertical Allocation Logic
                            for (int c = 1; c <= cols; c++) {
                                for (int b = 1; b <= benches; b++) {
                                    for (int s = 1; s <= seatsPerBench; s++) {
                                        
                                        // Rotation logic: Seat 1 -> Branch 1, Seat 2 -> Branch 2...
                                        int branchIdx = (s - 1) % allBranchesData.size();
                                        List<Student> currentBranchList = allBranchesData.get(branchIdx);

                                        if (pointers[branchIdx] < currentBranchList.size()) {
                                            Student st = currentBranchList.get(pointers[branchIdx]++);
                                            String currentSubject = (branchIdx == 0) ? subject1 : subject2;
                                            // Batch mein add karna
                                            addSeatingToBatch(pstmt, rId, c, b, s, st, examDate, shift, currentSubject);
                                            totalAllocated++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                pstmt.executeBatch();
                conn.commit(); // Sab sahi raha toh commit
                response.sendRedirect("admin/seating-chart.jsp?message=Seating Generated! Total: " + totalAllocated);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/generate-plan.jsp?error=" + e.getMessage());
        }
    }

	private void addSeatingToBatch(PreparedStatement p, String r, int c, int b, int s, Student st, String d, String sh, String sub) throws SQLException {
	    p.setString(1, r); 
	    p.setInt(2, c); 
	    p.setInt(3, b); 
	    p.setInt(4, s);
	    p.setString(5, st.getEnrollmentNo()); // student_enrollment column
	    p.setString(6, st.getName());         // student_name column
	    p.setString(7, st.getBranch()); 
	    p.setInt(8, st.getSemester()); 
	    p.setString(9, d); 
	    p.setString(10, sh);
	    p.setString(11, sub);                // subject_name column
	    p.addBatch();
	}
}