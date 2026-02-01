package com.smartseat.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;

import com.smartseat.dao.StudentDAO;
import com.smartseat.model.Student;

@WebServlet("/ImportServlet")
@MultipartConfig // File upload handle karne ke liye zaroori hai
public class ImportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO = new StudentDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file"); // JSP ke input name se match hona chahiye
        
        try (BufferedReader fileReader = new BufferedReader(new InputStreamReader(filePart.getInputStream()));
             @SuppressWarnings("deprecation")
			 CSVParser csvParser = new CSVParser(fileReader, CSVFormat.DEFAULT.withFirstRecordAsHeader().withIgnoreHeaderCase().withTrim())) {

            int count = 0;
            for (CSVRecord csvRecord : csvParser) {
                // CSV se data nikalna
                String enrollmentNo = csvRecord.get("enrollment_no");
                String name = csvRecord.get("name");
                String branch = csvRecord.get("branch");

                // Student object banana
                Student student = new Student(enrollmentNo, name, branch);
                
                // Database mein save karna
                if (studentDAO.saveStudent(student)) {
                    count++;
                }
            }
            
            // Success message ke saath redirect
            response.sendRedirect("admin/import-students.jsp?message=" + count + " Students Imported Successfully!");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/import-students.jsp?error=Error importing file: " + e.getMessage());
        }
    }
}