package com.smartseat.model;

public class Student {
    private int id;
    private String enrollmentNo; 
    private String name;
    private String branch;
    private int semester; 
    private String email;
    // Naye fields add kiye hain
    private String academicYear;
    private String studentType;

    public Student() {}
    
    public Student(String enrollmentNo, String name, String branch) {
        this.enrollmentNo = enrollmentNo;
        this.name = name;
        this.branch = branch;
    }

    // Getters and Setters
    public int getId() 
    { 
    		return id; 
    }
    public void setId(int id) { this.id = id; }

    public String getEnrollmentNo() { return enrollmentNo; }
    public void setEnrollmentNo(String enrollmentNo) { this.enrollmentNo = enrollmentNo; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }
    
    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // Naye Getters aur Setters
    public String getAcademicYear() { return academicYear; }
    public void setAcademicYear(String academicYear) { this.academicYear = academicYear; }

    public String getStudentType() { return studentType; }
    public void setStudentType(String studentType) { this.studentType = studentType; }
}