<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.smartseat.util.DBConnection, java.util.*" %>
<%
    // Session and Authentication check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../index.jsp?error=Please Login First");
    }

    // Parameters
    String selectedRoom = request.getParameter("roomNo");
    String selectedDate = request.getParameter("examDate");
    String selectedShift = request.getParameter("shift");
    
    // Auto-select latest date if not provided
    if(selectedDate == null || selectedDate.isEmpty()) {
        try (Connection c = DBConnection.getConnection();
             ResultSet rs = c.createStatement().executeQuery("SELECT MAX(exam_date) FROM seating_plan")) {
            if(rs.next()) selectedDate = rs.getString(1);
        } catch(Exception e) {
            selectedDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        }
    }
    if(selectedShift == null) selectedShift = "Morning";

    // Data structures for visualization
    Map<Integer, Map<Integer, List<String[]>>> dataMap = new TreeMap<>();
    List<String> activeRooms = new ArrayList<>();
    int totalCols = 0, benchesPerCol = 0, totalStudents = 0;
    boolean hasData = false;
    String roomName = "";
    String examTitle = "";
    int studentsPerBench = 2; // Default
    
    // Variables for invigilator assignment
    String currentInvigilator = "Not Assigned";
    com.smartseat.dao.TeacherDAO tDao = new com.smartseat.dao.TeacherDAO();
    List<com.smartseat.model.Teacher> teachersList = tDao.getAllTeachers();

    try (Connection conn = DBConnection.getConnection()) {
        // Fetch Active Rooms for selected date/shift
        PreparedStatement psActive = conn.prepareStatement(
            "SELECT DISTINCT room_no FROM seating_plan WHERE exam_date = ? AND shift = ? ORDER BY room_no"
        );
        psActive.setString(1, selectedDate);
        psActive.setString(2, selectedShift);
        ResultSet rsActive = psActive.executeQuery();
        while(rsActive.next()) {
            String roomNo = rsActive.getString("room_no");
            activeRooms.add(roomNo + "|Room " + roomNo); 
        }

        // Fetch Student Data if room is selected
        if(selectedRoom != null && !selectedRoom.isEmpty()) {
            // Get room details and students per bench from settings
            PreparedStatement psRoom = conn.prepareStatement(
                "SELECT r.total_columns, r.benches_per_column, " +
                "(SELECT setting_value FROM system_settings WHERE setting_key = 'default_students_per_bench') as students_per_bench " +
                "FROM rooms r " + 
                "LEFT JOIN seating_plan sp ON sp.room_no = r.room_no " +
                "WHERE r.room_no = ? AND sp.exam_date = ? AND sp.shift = ? " +
                "LIMIT 1"
            );
            psRoom.setString(1, selectedRoom);
            psRoom.setString(2, selectedDate);
            psRoom.setString(3, selectedShift);
            ResultSet rsR = psRoom.executeQuery();
            if(rsR.next()) {
                totalCols = rsR.getInt("total_columns");
                benchesPerCol = rsR.getInt("benches_per_column");
                studentsPerBench = rsR.getInt("students_per_bench");
                if(studentsPerBench == 0) studentsPerBench = 2; // Default fallback
                examTitle = "Examination Seating Plan"; 
                roomName = "Room " + selectedRoom;
                hasData = true;
            }

            // Get student data
            String sql = "SELECT * FROM seating_plan WHERE room_no = ? AND exam_date = ? AND shift = ? ORDER BY column_no, bench_no, seat_no";
            PreparedStatement psData = conn.prepareStatement(sql);
            psData.setString(1, selectedRoom);
            psData.setString(2, selectedDate);
            psData.setString(3, selectedShift);
            ResultSet rsData = psData.executeQuery();
            
            while(rsData.next()) {
                int c = rsData.getInt("column_no"); 
                int b = rsData.getInt("bench_no");
                dataMap.putIfAbsent(c, new TreeMap<>());
                dataMap.get(c).putIfAbsent(b, new ArrayList<>());
                dataMap.get(c).get(b).add(new String[]{
                    rsData.getString("seat_no"), 
                    rsData.getString("student_name"),
                    rsData.getString("student_enrollment"), 
                    rsData.getString("branch"),
                    String.valueOf(rsData.getInt("semester")),
                    "N/A"
                });
                totalStudents++;
            }
            
            // Get current invigilator for this room
            currentInvigilator = tDao.getAssignedTeacher(selectedRoom, selectedDate, selectedShift);
            if(currentInvigilator == null || currentInvigilator.trim().isEmpty()) {
                currentInvigilator = "Not Assigned";
            }
        }
    } catch(Exception e) { 
        e.printStackTrace(); 
    }
    
    // Format date for display
    String displayDate = selectedDate;
    try {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
        java.util.Date d = sdf.parse(selectedDate);
        sdf.applyPattern("EEEE, MMMM dd, yyyy");
        displayDate = sdf.format(d);
    } catch(Exception e) {}
    
    
    // Logic to fetch unique generated plans for the dropdown
    List<String[]> planHistory = new ArrayList<>();
    try (Connection c = DBConnection.getConnection();
         PreparedStatement psHist = c.prepareStatement("SELECT DISTINCT exam_date, shift FROM seating_plan ORDER BY exam_date DESC LIMIT 15")) {
        ResultSet rsHist = psHist.executeQuery();
        while(rsHist.next()) {
            planHistory.add(new String[]{rsHist.getString("exam_date"), rsHist.getString("shift")});
        }
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart-Seat | Seating Visualization</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        :root {
            --primary-blue: #0066CC;
            --primary-dark: #003366;
            --primary-light: #E6F2FF;
            --secondary-blue: #0088CC;
            --accent-teal: #00B4B3;
            --success-green: #00A86B;
            --warning-orange: #FF6B35;
            --light-bg: #F8FBFF;
            --card-bg: #FFFFFF;
            --border-color: #E1E5EB;
            --text-primary: #1A1A1A;
            --text-secondary: #666666;
            --sidebar-width: 280px;
            --radius-lg: 20px;
            --radius-md: 12px;
            --radius-sm: 8px;
            --shadow-sm: 0 4px 12px rgba(0, 0, 0, 0.05);
            --shadow-md: 0 10px 30px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 20px 50px rgba(0, 0, 0, 0.12);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--light-bg);
            color: var(--text-primary);
            min-height: 100vh;
        }

        /* Main Layout */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 0;
            min-height: 100vh;
            background: var(--light-bg);
            transition: margin-left 0.3s ease;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
            }
        }

        /* Enhanced Header */
        .page-header {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary-blue) 100%);
            padding: 40px 40px 30px;
            position: relative;
            overflow: hidden;
            color: white;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle at 70% 30%, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: white;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .page-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            font-weight: 400;
            max-width: 700px;
            line-height: 1.6;
        }

        /* Header Stats */
        .header-stats {
            display: flex;
            gap: 20px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .header-stat {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-md);
            padding: 15px 25px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-stat-value {
            font-size: 1.8rem;
            font-weight: 800;
            color: white;
            margin-bottom: 5px;
            line-height: 1;
        }

        .header-stat-label {
            font-size: 0.9rem;
            color: rgba(255, 255, 255, 0.8);
            font-weight: 500;
        }

        /* Action Buttons */
        .header-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .btn-icon:hover {
            transform: translateY(-3px);
            background: rgba(255, 255, 255, 0.25);
            border-color: white;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }

        .btn-primary-custom {
            background: white;
            color: var(--primary-blue);
            border: none;
            border-radius: var(--radius-md);
            padding: 12px 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            color: var(--primary-dark);
        }

        /* Filter Panel */
        .filter-panel {
            background: white;
            border-radius: var(--radius-lg);
            padding: 30px;
            margin: 30px 40px 20px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        .panel-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .panel-title i {
            color: var(--primary-blue);
        }

        /* Form Styles */
        .form-label-custom {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .input-group-custom {
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .input-group-custom:focus-within {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }

        .input-group-text-custom {
            background: linear-gradient(135deg, var(--primary-light), #f1f9ff);
            border: none;
            color: var(--primary-blue);
            font-weight: 600;
            min-width: 50px;
            justify-content: center;
        }

        .form-select-custom {
            border: none;
            background: white;
            padding: 14px 20px;
            font-size: 1rem;
            color: var(--text-primary);
            height: auto;
        }

        /* Room Selection */
        .room-selection {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .room-card {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: var(--radius-md);
            padding: 20px;
            min-width: 140px;
            text-align: center;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            cursor: pointer;
            box-shadow: var(--shadow-sm);
        }

        .room-card:hover {
            border-color: var(--primary-blue);
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .room-card.active {
            border-color: var(--primary-blue);
            background: var(--primary-light);
            transform: translateY(-3px);
        }

        .room-code {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--primary-dark);
            margin-bottom: 8px;
        }

        .room-card.active .room-code {
            color: var(--primary-blue);
        }

        /* IMPROVED: Room Header */
        .room-header {
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
            border-radius: var(--radius-lg);
            padding: 30px;
            margin: 0 40px 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .room-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, rgba(0, 102, 204, 0.05) 0%, transparent 70%);
            border-radius: 50%;
        }

        .room-title-section {
            position: relative;
            z-index: 1;
        }

        .room-title-main {
            font-size: 2rem;
            font-weight: 800;
            color: var(--primary-dark);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .room-title-main i {
            color: var(--primary-blue);
            font-size: 2.2rem;
        }

        .room-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 25px;
            flex-wrap: wrap;
        }

        .room-info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background: var(--primary-light);
            padding: 8px 15px;
            border-radius: var(--radius-sm);
        }

        .room-info-item i {
            color: var(--primary-blue);
        }

        .room-stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }

        .room-stat-card {
            background: white;
            border-radius: var(--radius-md);
            padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            text-align: center;
        }

        .room-stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--primary-blue);
            margin-bottom: 5px;
            line-height: 1;
        }

        .room-stat-label {
            font-size: 0.9rem;
            color: var(--text-secondary);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* ENHANCED: Invigilator Assignment Card */
        .invigilator-card {
            background: linear-gradient(135deg, var(--primary-light), white);
            border-radius: var(--radius-lg);
            padding: 30px;
            margin: 0 40px 30px;
            box-shadow: var(--shadow-md);
            border: 2px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .invigilator-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: linear-gradient(180deg, var(--accent-teal), var(--success-green));
        }

        .invigilator-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .invigilator-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .invigilator-title i {
            color: var(--accent-teal);
            font-size: 1.5rem;
        }

        .current-invigilator {
            background: white;
            border-radius: var(--radius-md);
            padding: 15px 25px;
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: var(--shadow-sm);
        }

        .invigilator-avatar {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--accent-teal), var(--success-green));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            font-weight: 600;
        }

        .invigilator-details h4 {
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
            font-size: 1.1rem;
        }

        .invigilator-details p {
            color: var(--text-secondary);
            margin: 0;
            font-size: 0.9rem;
        }

        .invigilator-form {
            background: white;
            border-radius: var(--radius-md);
            padding: 25px;
            border: 1px solid var(--border-color);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 20px;
            align-items: flex-end;
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .assign-btn {
            background: linear-gradient(135deg, var(--accent-teal), var(--success-green));
            color: white;
            border: none;
            border-radius: var(--radius-md);
            padding: 12px 30px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            height: 50px;
            white-space: nowrap;
        }

        .assign-btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            color: white;
        }

        /* Dynamic Seating Layout */
        .seating-layout {
            display: flex;
            flex-direction: column;
            gap: 40px;
            margin-top: 30px;
        }

        .column-row {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .column-container {
            flex: 1;
            min-width: 350px;
            max-width: 450px;
            background: linear-gradient(135deg, #f8fafc, white);
            border-radius: var(--radius-lg);
            padding: 25px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .column-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
            padding: 18px;
            border-radius: var(--radius-md);
            text-align: center;
            margin-bottom: 25px;
        }

        .column-title {
            font-weight: 700;
            font-size: 1.3rem;
            letter-spacing: 1px;
        }

        .benches-container {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .bench-group {
            background: white;
            border-radius: var(--radius-md);
            padding: 20px;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
        }

        .bench-header {
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .bench-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1.1rem;
        }

        .bench-count {
            background: var(--primary-light);
            color: var(--primary-blue);
            font-size: 0.8rem;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
        }

        /* DYNAMIC SEAT GRID */
        .seat-grid {
            display: grid;
            gap: 12px;
        }

        .grid-1 { grid-template-columns: 1fr; }
        .grid-2 { grid-template-columns: repeat(2, 1fr); }
        .grid-3 { grid-template-columns: repeat(3, 1fr); }
        .grid-4 { grid-template-columns: repeat(2, 1fr); }
        .grid-5 { grid-template-columns: repeat(3, 1fr); }
        .grid-6 { grid-template-columns: repeat(3, 1fr); }

        .seat-card {
            background: white;
            border-radius: var(--radius-sm);
            padding: 15px;
            border: 2px solid var(--border-color);
            position: relative;
            transition: all 0.3s ease;
            min-height: 120px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .seat-card:hover {
            border-color: var(--primary-blue);
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .seat-number {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--primary-blue);
            color: white;
            font-size: 0.8rem;
            font-weight: 700;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }

        .student-name {
            font-weight: 600;
            font-size: 0.95rem;
            color: var(--text-primary);
            margin-bottom: 5px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.3;
            padding-right: 30px;
        }

        .student-id {
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-bottom: 8px;
            font-family: 'Courier New', monospace;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .badge-container {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .branch-badge {
            background: #dbeafe;
            color: #1e40af;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
        }

        .semester-badge {
            background: #dcfce7;
            color: #166534;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
        }

        .empty-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, var(--primary-light), white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            color: var(--primary-blue);
            font-size: 3rem;
            box-shadow: var(--shadow-sm);
        }

        .empty-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 15px;
        }

        .empty-text {
            color: var(--text-secondary);
            max-width: 500px;
            margin: 0 auto 30px;
            font-size: 1.1rem;
            line-height: 1.6;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .main-content {
                margin-left: 0;
            }
            
            .page-header,
            .filter-panel,
            .room-header,
            .invigilator-card {
                margin: 20px;
                padding: 25px;
            }
            
            .column-row {
                flex-direction: column;
                align-items: center;
            }
            
            .column-container {
                min-width: 100%;
            }
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 2rem;
            }
            
            .room-selection {
                justify-content: center;
            }
            
            .room-card {
                min-width: 120px;
                padding: 15px;
            }
            
            .room-stats-grid {
                grid-template-columns: 1fr;
            }
            
            .invigilator-header {
                flex-direction: column;
                gap: 20px;
                align-items: flex-start;
            }
            
            .grid-4, .grid-5, .grid-6 {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .grid-2, .grid-3, .grid-4, .grid-5, .grid-6 {
                grid-template-columns: 1fr;
            }
            
            .header-stats {
                flex-direction: column;
            }
            
            .room-title-main {
                font-size: 1.8rem;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .room-subtitle {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }

        /* Animation Classes */
        .animate-delay-1 { animation-delay: 0.1s; }
        .animate-delay-2 { animation-delay: 0.2s; }
        .animate-delay-3 { animation-delay: 0.3s; }

        /* Print Styles */
        @media print {
            .sidebar, .no-print, .header-actions, .filter-panel, 
            .invigilator-card, .btn-icon, .btn-primary-custom {
                display: none !important;
            }
            
            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
            }
            
            .room-header {
                box-shadow: none !important;
                border: none !important;
                padding: 20px !important;
            }
            
            .seat-card:hover {
                transform: none !important;
                box-shadow: none !important;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="includes/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Enhanced Header -->
        <div class="page-header animate__animated animate__fadeInDown">
            <div class="header-content">
                <div class="row align-items-center">
                    <div class="col-lg-8 mb-4 mb-lg-0">
                        <h1 class="page-title">Seating Visualization</h1>
                        <p class="page-subtitle">
                            Interactive view of seating arrangements with dynamic layout adjustment based on room configuration.
                        </p>
                        
                        <div class="header-stats">
                            <div class="header-stat">
                                <div class="header-stat-value"><%= activeRooms.size() %></div>
                                <div class="header-stat-label">Active Rooms</div>
                            </div>
                            <div class="header-stat">
                                <div class="header-stat-value">
                                    <% 
                                        int totalAllocated = 0;
                                        try (Connection conn = DBConnection.getConnection()) {
                                            PreparedStatement ps = conn.prepareStatement(
                                                "SELECT COUNT(*) as total FROM seating_plan WHERE exam_date = ? AND shift = ?"
                                            );
                                            ps.setString(1, selectedDate);
                                            ps.setString(2, selectedShift);
                                            ResultSet rs = ps.executeQuery();
                                            if(rs.next()) totalAllocated = rs.getInt("total");
                                        } catch(Exception e) {}
                                    %>
                                    <%= totalAllocated %>
                                </div>
                                <div class="header-stat-label">Total Allocated</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4 text-lg-end">
                        <div class="header-actions">
                            <a href="dashboard.jsp" class="btn-icon" title="Back to Dashboard">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                            <button onclick="window.print()" class="btn-primary-custom">
                                <i class="fas fa-print"></i>
                                Print Chart
                            </button>
                            <a href="#" class="btn-icon" title="Full Screen" onclick="toggleFullscreen()">
                                <i class="fas fa-expand"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Panel -->
        <div class="filter-panel animate__animated animate__fadeInUp">
            <h3 class="panel-title">
                <i class="fas fa-filter"></i>
                Select Seating Plan
            </h3>
            
            <div class="row g-4">
                <div class="col-lg-6">
                    <label class="form-label-custom">
                        <i class="fas fa-calendar-alt"></i>
                        Choose Generated Plan
                    </label>
                    <div class="input-group input-group-custom">
                        <span class="input-group-text input-group-text-custom">
                            <i class="fas fa-history"></i>
                        </span>
                        <select class="form-select form-select-custom" onchange="if(this.value) { 
                            const p = this.value.split('|'); 
                            location.href='?examDate=' + p[0] + '&shift=' + p[1]; 
                        }">
                            <option value="">-- Select an existing plan --</option>
                            <% for(String[] plan : planHistory) { 
                                String val = plan[0] + "|" + plan[1];
                                boolean isSelected = plan[0].equals(selectedDate) && plan[1].equals(selectedShift);
                                
                                // User-friendly date format
                                String formattedOptDate = plan[0];
                                try {
                                    java.text.SimpleDateFormat sdfIn = new java.text.SimpleDateFormat("yyyy-MM-dd");
                                    java.text.SimpleDateFormat sdfOut = new java.text.SimpleDateFormat("dd MMM yyyy");
                                    formattedOptDate = sdfOut.format(sdfIn.parse(plan[0]));
                                } catch(Exception e) {}
                            %>
                                <option value="<%= val %>" <%= isSelected ? "selected" : "" %>>
                                    <%= formattedOptDate %> — <%= plan[1] %> Shift
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <label class="form-label-custom">
                            <i class="fas fa-door-open"></i>
                            Available Rooms for <%= displayDate %>
                        </label>
                        <span class="badge bg-primary">
                            <%= activeRooms.size() %> rooms
                        </span>
                    </div>
                    
                    <div class="room-selection">
                        <% if(activeRooms.isEmpty()) { %>
                            <div class="alert alert-info mb-0">
                                <i class="fas fa-info-circle me-2"></i>
                                No rooms allocated for this selection
                            </div>
                        <% } else { 
                            for(String roomInfo : activeRooms) { 
                                String[] parts = roomInfo.split("\\|");
                                String roomNo = parts[0];
                                String roomDisplayName = parts.length > 1 ? parts[1] : "Room " + roomNo;
                                boolean isActive = roomNo.equals(selectedRoom);
                        %>
                            <a href="?examDate=<%= selectedDate %>&shift=<%= selectedShift %>&roomNo=<%= roomNo %>" 
                               class="room-card <%= isActive ? "active" : "" %> animate__animated animate__fadeIn">
                                <div class="room-code">
                                    <%= roomDisplayName %>
                                </div>
                                <div class="small text-muted mt-2">
                                    <i class="fas fa-eye"></i> View Plan
                                </div>
                            </a>
                        <% } } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Visualization Content -->
        <% if(hasData) { %>
            <!-- IMPROVED Room Header -->
            <div class="room-header animate__animated animate__fadeInUp animate-delay-1">
                <div class="room-title-section">
                    <h2 class="room-title-main">
                        <i class="fas fa-door-open"></i>
                        <%= roomName %> - Seating Layout
                    </h2>
                    
                    <div class="room-subtitle">
                        <div class="room-info-item">
                            <i class="fas fa-calendar-alt"></i>
                            <span><%= displayDate %></span>
                        </div>
                        <div class="room-info-item">
                            <i class="fas fa-clock"></i>
                            <span><%= selectedShift %> Shift</span>
                        </div>
                        <div class="room-info-item">
                            <i class="fas fa-users"></i>
                            <span><%= studentsPerBench %> students per bench</span>
                        </div>
                    </div>
                    
                    <div class="room-stats-grid">
                        <div class="room-stat-card">
                            <div class="room-stat-value"><%= totalStudents %></div>
                            <div class="room-stat-label">Total Students</div>
                        </div>
                        <div class="room-stat-card">
                            <div class="room-stat-value"><%= totalCols %></div>
                            <div class="room-stat-label">Columns</div>
                        </div>
                        <div class="room-stat-card">
                            <div class="room-stat-value"><%= benchesPerCol %></div>
                            <div class="room-stat-label">Benches per Column</div>
                        </div>
                        <div class="room-stat-card">
                            <div class="room-stat-value">
                                <% 
                                    int seatsAvailable = totalCols * benchesPerCol * studentsPerBench;
                                    int occupancyRate = (int) Math.round((totalStudents * 100.0) / seatsAvailable);
                                %>
                                <%= occupancyRate %>%
                            </div>
                            <div class="room-stat-label">Occupancy Rate</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ENHANCED Invigilator Assignment Card -->
            <div class="invigilator-card animate__animated animate__fadeInUp animate-delay-2">
                <div class="invigilator-header">
                    <h3 class="invigilator-title">
                        <i class="fas fa-user-tie"></i>
                        Invigilator Assignment
                    </h3>
                    
                    <div class="current-invigilator">
                        <div class="invigilator-avatar">
                            <% if(!currentInvigilator.equals("Not Assigned")) { %>
                                <%= currentInvigilator.charAt(0) %>
                            <% } else { %>
                                <i class="fas fa-user-slash"></i>
                            <% } %>
                        </div>
                        <div class="invigilator-details">
                            <h4>
                                <%= currentInvigilator %>
                            </h4>
                            <p>Currently assigned for this session</p>
                        </div>
                    </div>
                </div>
                
                <div class="invigilator-form">
                    <form action="${pageContext.request.contextPath}/AssignInvigilatorServlet" method="post">
                        <input type="hidden" name="roomNo" value="<%= selectedRoom %>">
                        <input type="hidden" name="examDate" value="<%= selectedDate %>">
                        <input type="hidden" name="shift" value="<%= selectedShift %>">
                        
                        <div class="form-row">
                            <div>
                                <label class="form-label-custom mb-3">
                                    <i class="fas fa-chalkboard-teacher"></i>
                                    Assign New Invigilator
                                </label>
                                <div class="input-group input-group-custom">
                                    <span class="input-group-text input-group-text-custom">
                                        <i class="fas fa-user-tie"></i>
                                    </span>
                                    <select name="teacherId" class="form-select form-select-custom" required>
                                        <option value="">-- Select Faculty Member --</option>
                                        <% for(com.smartseat.model.Teacher teacher : teachersList) { %>
                                            <option value="<%= teacher.getId() %>">
                                                <%= teacher.getName() %> (<%= teacher.getDepartment() %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                <small class="text-muted mt-2 d-block">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Select a faculty member to assign as invigilator for this room
                                </small>
                            </div>
                            
                            <div>
                                <button type="submit" class="assign-btn">
                                    <i class="fas fa-user-check"></i>
                                    Assign Invigilator
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Dynamic Seating Layout -->
            <div class="seating-layout animate__animated animate__fadeInUp animate-delay-3" id="seatingLayout">
                <%
                int colsPerRow = 2; // Default columns per row
                if(totalCols > 4) colsPerRow = 3;
                
                int currentRow = 0;
                int colsInCurrentRow = 0;
                
                for (int c = 1; c <= totalCols; c++) {
                    Map<Integer, List<String[]>> columnData = dataMap.getOrDefault(c, new TreeMap<>());
                    
                    if(colsInCurrentRow == 0) {
                        // Start new row
                        currentRow++;
                %>
                <div class="column-row row-<%= currentRow %>">
                <% } %>

                    <div class="column-container animate__animated animate__fadeInUp"
                        style="animation-delay: <%=(c - 1) * 0.1%>s">
                        <div class="column-header">
                            <div class="column-title">
                                Column <%= c %>
                            </div>
                        </div>

                        <div class="benches-container">
                            <% for(int b = 1; b <= benchesPerCol; b++) { 
                                List<String[]> benchStudents = columnData.getOrDefault(b, new ArrayList<>()); 
                                if(!benchStudents.isEmpty()) {
                                    // Determine grid class based on students per bench
                                    String gridClass = "grid-" + studentsPerBench;
                                    if(benchStudents.size() > studentsPerBench) {
                                        // If more students than configured per bench
                                        if(benchStudents.size() <= 3) gridClass = "grid-3";
                                        else if(benchStudents.size() <= 4) gridClass = "grid-4";
                                        else gridClass = "grid-6";
                                    }
                            %>
                            <div class="bench-group">
                                <div class="bench-header">
                                    <div class="bench-title">
                                        <i class="fas fa-chair"></i> Bench <%= b %>
                                    </div>
                                    <div class="bench-count">
                                        <%= benchStudents.size() %> seats
                                    </div>
                                </div>

                                <div class="seat-grid <%= gridClass %>">
                                    <% for(String[] student : benchStudents) { 
                                        String seatNo = student[0];
                                        String studentName = student[1];
                                        String enrollment = student[2];
                                        String branch = student[3];
                                        String semester = student[4];
                                    %>
                                    <div class="seat-card" data-student="<%= studentName %>"
                                        data-enrollment="<%= enrollment %>"
                                        data-branch="<%= branch %>" data-semester="<%= semester %>">
                                        <div class="seat-number">
                                            <%= seatNo %>
                                        </div>
                                        <div class="student-name" title="<%= studentName %>">
                                            <%= studentName %>
                                        </div>
                                        <div class="student-id" title="<%= enrollment %>">
                                            <%= enrollment %>
                                        </div>
                                        <div class="badge-container">
                                            <span class="branch-badge"><%= branch %></span> 
                                            <span class="semester-badge">Sem <%= semester %></span>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } } %>
                        </div>
                    </div>

                <% 
                    colsInCurrentRow++;
                    if(colsInCurrentRow == colsPerRow || c == totalCols) {
                        // Close row
                        colsInCurrentRow = 0;
                %>
                </div>
                <% } 
                } %>
            </div>
            
        <% } else if(selectedRoom == null && !activeRooms.isEmpty()) { %>
            <!-- Select Room Prompt -->
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-arrow-up"></i>
                </div>
                <h3 class="empty-title">Select a Room</h3>
                <p class="empty-text">
                    Choose a room from the list above to view the detailed seating arrangement.
                    The layout will dynamically adjust based on the room's configuration.
                </p>
                <div class="alert alert-info mt-4" style="max-width: 500px; margin: 0 auto;">
                    <i class="fas fa-lightbulb me-2"></i>
                    Tip: Each room displays seating with <%= studentsPerBench %> students per bench configuration
                </div>
            </div>
            
        <% } else if(activeRooms.isEmpty()) { %>
            <!-- No Data State -->
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-calendar-times"></i>
                </div>
                <h3 class="empty-title">No Seating Plans Found</h3>
                <p class="empty-text">
                    There are no seating plans generated for the selected date and shift.
                    Generate a new plan to visualize seating arrangements.
                </p>
                <a href="generate-plan.jsp" class="btn-primary-custom mt-3">
                    <i class="fas fa-plus"></i>
                    Generate New Plan
                </a>
            </div>
        <% } %>
    </div>

<!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button> -->

    <!-- JavaScript for Dynamic Features -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Dynamic grid adjustment based on viewport
            function adjustGridLayout() {
                const seatGrids = document.querySelectorAll('.seat-grid');
                const viewportWidth = window.innerWidth;
                
                seatGrids.forEach(grid => {
                    const currentClass = Array.from(grid.classList).find(cls => cls.startsWith('grid-'));
                    const benchStudents = grid.children.length;
                    
                    if(viewportWidth < 480) {
                        // Mobile: Single column
                        grid.className = 'seat-grid grid-1';
                    } else if(viewportWidth < 768) {
                        // Tablet: Adjust based on student count
                        if(benchStudents <= 2) {
                            grid.className = 'seat-grid grid-2';
                        } else if(benchStudents <= 4) {
                            grid.className = 'seat-grid grid-2';
                        } else {
                            grid.className = 'seat-grid grid-2';
                        }
                    } else {
                        // Desktop: Restore original class
                        if(currentClass) {
                            grid.className = 'seat-grid ' + currentClass;
                        }
                    }
                });
            }
            
            // Initial adjustment
            adjustGridLayout();
            
            // Adjust on resize
            window.addEventListener('resize', adjustGridLayout);
            
            // Student search functionality
            const searchInput = document.createElement('input');
            searchInput.type = 'text';
            searchInput.placeholder = '🔍 Search student by name or enrollment...';
            searchInput.className = 'form-control mb-4 no-print';
            searchInput.style.maxWidth = '500px';
            searchInput.style.margin = '0 auto 30px';
            searchInput.style.padding = '12px 20px';
            searchInput.style.borderRadius = 'var(--radius-md)';
            searchInput.style.border = '2px solid var(--border-color)';
            searchInput.style.boxShadow = 'var(--shadow-sm)';
            
            const vizContainer = document.querySelector('.seating-layout');
            if(vizContainer) {
                const roomHeader = document.querySelector('.room-header');
                if(roomHeader) {
                    roomHeader.insertAdjacentElement('afterend', searchInput);
                }
                
                searchInput.addEventListener('input', function(e) {
                    const searchTerm = e.target.value.toLowerCase().trim();
                    const seatCards = document.querySelectorAll('.seat-card');
                    
                    seatCards.forEach(card => {
                        const studentName = card.dataset.student.toLowerCase();
                        const enrollment = card.dataset.enrollment.toLowerCase();
                        
                        if(searchTerm === '' || 
                           studentName.includes(searchTerm) || 
                           enrollment.includes(searchTerm)) {
                            card.style.borderColor = 'var(--border-color)';
                            card.style.backgroundColor = 'white';
                            card.style.opacity = '1';
                        } else {
                            card.style.borderColor = 'transparent';
                            card.style.backgroundColor = 'rgba(0,0,0,0.05)';
                            card.style.opacity = '0.4';
                        }
                    });
                });
            }
            
            // Fullscreen toggle
            window.toggleFullscreen = function() {
                const elem = document.documentElement;
                if (!document.fullscreenElement) {
                    elem.requestFullscreen().catch(err => {
                        console.error(`Error attempting to enable full-screen mode: ${err.message}`);
                    });
                } else {
                    document.exitFullscreen();
                }
            };
            
            // Print functionality enhancement
            const printBtn = document.querySelector('.btn-primary-custom');
            if(printBtn) {
                printBtn.addEventListener('click', function(e) {
                    if(!e.target.closest('.btn-primary-custom')) return;
                    
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Preparing...';
                    this.disabled = true;
                    
                    setTimeout(() => {
                        window.print();
                        this.innerHTML = originalHTML;
                        this.disabled = false;
                    }, 1000);
                });
            }
            
            // Hover effects for seat cards
            const seatCards = document.querySelectorAll('.seat-card');
            seatCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    const allCards = document.querySelectorAll('.seat-card');
                    allCards.forEach(c => c.style.zIndex = '1');
                    this.style.zIndex = '10';
                });
            });
            
            // Add loading animation for form submission
            const invigilatorForm = document.querySelector('.invigilator-form form');
            if(invigilatorForm) {
                invigilatorForm.addEventListener('submit', function(e) {
                    const submitBtn = this.querySelector('.assign-btn');
                    if(submitBtn) {
                        const originalHTML = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Assigning...';
                        submitBtn.disabled = true;
                        
                        setTimeout(() => {
                            submitBtn.innerHTML = originalHTML;
                            submitBtn.disabled = false;
                        }, 3000);
                    }
                });
            }
            
            // Calculate and display occupancy percentage
            function calculateOccupancy() {
                const totalSeats = <%= totalCols * benchesPerCol * studentsPerBench %>;
                const occupiedSeats = <%= totalStudents %>;
                if(totalSeats > 0) {
                    const occupancy = Math.round((occupiedSeats * 100) / totalSeats);
                    return occupancy;
                }
                return 0;
            }
            
            // Add occupancy visualization
            const occupancyElement = document.querySelector('.room-stat-card:last-child .room-stat-value');
            if(occupancyElement) {
                const occupancy = calculateOccupancy();
                if(occupancy > 80) {
                    occupancyElement.style.color = 'var(--success-green)';
                } else if(occupancy > 50) {
                    occupancyElement.style.color = 'var(--warning-orange)';
                }
            }
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>