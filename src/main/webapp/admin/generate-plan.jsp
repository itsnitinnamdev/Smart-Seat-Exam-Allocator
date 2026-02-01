<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, com.smartseat.util.DBConnection, com.smartseat.dao.SubjectDAO, com.smartseat.model.Subject, java.util.List" %>
<%
    if(session.getAttribute("adminUser") == null) { 
        response.sendRedirect("../home?error=Login First"); 
    }
    
    String currDate = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date());
    String name = (String) session.getAttribute("adminName");
    
    // Real-world data
    String[] academicYears = {"2024-2025", "2025-2026", "2026-2027"};
    String[] examTypes = {"Regular", "Supplementary", "Re-evaluation", "Term Test"};
    String[] sessions = {"Morning (10:00 AM - 1:00 PM)", "Afternoon (2:00 PM - 5:00 PM)", "Evening (6:00 PM - 9:00 PM)"};
    String[] branches = {"CS", "IT", "CSITCS", "IOT", "EC", "ME", "CE", "EE", "AE", "CH"};
    
 // Database se actual counts lane ke liye map (Example logic)
    // generate-plan.jsp ke top par (branches array ke niche)
    java.util.Map<String, java.util.Map<String, Integer>> dbStats = new java.util.HashMap<>();
    try (java.sql.Connection conn = com.smartseat.util.DBConnection.getConnection()) {
        String sql = "SELECT branch, semester, COUNT(*) as count FROM students GROUP BY branch, semester";
        java.sql.ResultSet rs = conn.createStatement().executeQuery(sql);
        while(rs.next()) {
            String b = rs.getString("branch");
            String s = rs.getString("semester");
            int c = rs.getInt("count");
            dbStats.putIfAbsent(b, new java.util.HashMap<>());
            dbStats.get(b).put(s, c);
        }
    } catch(Exception e) { e.printStackTrace(); }
    
    
    SubjectDAO subDao = new SubjectDAO();
    List<Subject> allSubjectsList = subDao.getAllSubjects();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generate Seating Plan | Smart-Seat IPS Academy</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    
    <style>
        :root {
            --primary-blue: #0066CC;
            --primary-dark: #003366;
            --primary-light: #E6F2FF;
            --secondary-blue: #0088CC;
            --accent-teal: #00B4B3;
            --dark-gray: #1A1A1A;
            --medium-gray: #666666;
            --light-gray: #F5F7FA;
            --border-color: #E1E5EB;
            --success-green: #00A86B;
            --warning-orange: #FF6B35;
            --error-red: #E53E3E;
            --sidebar-bg: #0F172A;
            --sidebar-active: #1E293B;
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
            color: var(--dark-gray);
            min-height: 100vh;
        }

         /* Professional Sidebar */
        

        .main-content {
            margin-left: 280px;
            padding: 30px;
        }

        /* Header */
        .header {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
        }

        .page-title h1 {
            font-weight: 700;
            font-size: 1.8rem;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .page-title p {
            color: var(--medium-gray);
            font-size: 0.95rem;
            margin: 0;
        }

        /* Alert */
        .alert-box {
            background: #e0f2fe;
            color: #1e40af;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 1px solid #0ea5e9;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* Form Sections */
        .form-section {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        .section-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 25px;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--primary-blue);
        }

        /* Form Elements */
        .form-label {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .form-control, .form-select {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }

        /* Selection Grid */
        .selection-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .selection-item {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 18px 10px;
            text-align: center;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }

        .selection-item:hover {
            border-color: var(--primary-blue);
            transform: translateY(-2px);
        }

        .selection-item.selected {
            border-color: var(--primary-blue);
            background: #eff6ff;
        }

        .item-number {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 8px;
        }

        .selection-item.selected .item-number {
            color: var(--primary-blue);
        }

        .item-label {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--dark-gray);
        }

        .selection-item.selected .item-label {
            color: var(--primary-blue);
        }

        /* Branch Selection */
        .branch-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .branch-item {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 20px 10px;
            text-align: center;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }

        .branch-item:hover {
            border-color: var(--primary-blue);
            transform: translateY(-2px);
        }

        .branch-item.selected {
            border-color: var(--primary-blue);
            background: #eff6ff;
        }

        .branch-code {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 8px;
        }

        .branch-item.selected .branch-code {
            color: var(--primary-blue);
        }

        .branch-name {
            font-size: 0.85rem;
            color: var(--medium-gray);
        }

        /* Room Selection */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .room-item {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
            background: white;
            cursor: pointer;
            transition: all 0.2s;
        }

        .room-item:hover {
            border-color: var(--primary-blue);
            transform: translateY(-3px);
            box-shadow: var(--shadow-sm);
        }

        .room-item.selected {
            border-color: var(--primary-blue);
            background: #eff6ff;
        }

        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .room-name {
            font-weight: 600;
            font-size: 1.2rem;
            color: var(--primary-dark);
        }

        .room-item.selected .room-name {
            color: var(--primary-blue);
        }

        .room-capacity {
            background: var(--primary-light);
            color: var(--primary-blue);
            font-size: 0.85rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 15px;
        }

        .room-details {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
        }

        /* Building Tabs */
        .building-tabs {
            display: flex;
            gap: 5px;
            background: var(--primary-light);
            padding: 5px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .building-tab {
            flex: 1;
            text-align: center;
            padding: 12px;
            font-weight: 600;
            color: var(--medium-gray);
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .building-tab.active {
            background: white;
            color: var(--primary-blue);
            box-shadow: var(--shadow-sm);
        }

        /* Summary Panel */
        .summary-panel {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            position: sticky;
            top: 30px;
        }

        .summary-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 20px;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .summary-item:last-child {
            border-bottom: none;
        }

        .summary-label {
            color: var(--medium-gray);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .summary-value {
            font-weight: 600;
            color: var(--primary-dark);
        }

        .summary-value.success {
            color: var(--success-green);
        }

        .summary-value.error {
            color: var(--error-red);
        }

        /* Status Box */
        .status-box {
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            font-weight: 500;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-waiting {
            background: #fef3c7;
            color: #92400e;
            border: 1px solid #fbbf24;
        }

        .status-ready {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }

        .status-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #ef4444;
        }

        /* Generate Button */
        .generate-btn {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 16px;
            font-weight: 600;
            font-size: 1rem;
            width: 100%;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .generate-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .generate-btn:disabled {
            background: var(--border-color);
            color: var(--medium-gray);
            cursor: not-allowed;
        }

        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .quick-btn {
            background: var(--primary-light);
            color: var(--primary-blue);
            border: none;
            border-radius: 20px;
            padding: 8px 15px;
            font-weight: 500;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .quick-btn:hover {
            background: var(--primary-blue);
            color: white;
        }

	/* Page specific header fix for mobile */
@media (max-width: 992px) {
    /* Header container ko flex-column mein badlo */
    .header .d-flex.justify-content-between {
        flex-direction: column !important;
        align-items: flex-start !important;
        gap: 20px;
    }

    /* Date aur Dashboard button wale container ko stack karo */
    .header .d-flex.align-items-center.gap-3 {
        flex-direction: column;
        width: 100%;
        align-items: stretch !important;
    }

/* Professional Back Button Style (as per image) */
.btn-back-themed {
    background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
    color: white !important;
    padding: 10px 20px;
    border-radius: 12px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 15px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(0, 102, 204, 0.2);
    border: none;
}

.btn-back-themed:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0, 102, 204, 0.3);
    background: var(--primary-blue);
}

.btn-back-themed i {
    font-size: 1.2rem;
}

.btn-text-container {
    display: flex;
    flex-direction: column;
    text-align: left;
    line-height: 1.2;
}

.btn-text-top {
    font-size: 0.75rem;
    font-weight: 400;
    opacity: 0.9;
}

.btn-text-main {
    font-size: 1rem;
    font-weight: 700;
    letter-spacing: 0.5px;
}

/* Mobile Responsive Fix */
@media (max-width: 992px) {
    .btn-back-themed {
        width: 100%;
        justify-content: center;
    }
}
    /* Buttons aur Date badge ko full width karo taaki overlap na ho */
    .header .gap-3 div, 
    .header .gap-3 a {
        width: 100% !important;
        text-align: center;
        justify-content: center;
    }
    
    .btn-dashboard-back {
        width: 100%;
        justify-content: center;
    }
}
        
    </style>
</head>
<body>

    <!-- Simple Sidebar -->
    <jsp:include page="includes/sidebar.jsp" />

	<!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
    <i class="fas fa-bars"></i>
</button> -->
	
    <div class="main-content">
        <!-- Header -->
        <div class="header animate__animated animate__fadeInDown">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
        <div class="page-title">
            <h1>Generate Seating Plan</h1>
            <p>Create seating arrangements using vertical sequence allocation</p>
        </div>
        
        <div class="d-flex flex-column flex-sm-row align-items-center gap-3 w-100-mobile">
            <div style="background: var(--primary-light); color: var(--primary-blue); padding: 10px 20px; border-radius: 50px; font-weight: 600; font-size: 14px; white-space: nowrap;">
                <i class="fas fa-calendar-alt me-2"></i>
                <%= currDate %>
            </div>
					<a href="dashboard.jsp" class="btn-back-themed"> <i
						class="fas fa-arrow-left"></i>

						<div class="btn-text-container">
							<span class="btn-text-top">Back to</span> <span
								class="btn-text-main">Dashboard</span>
						</div>
					</a>
				</div>
    </div>
</div>

        <!-- Alert -->
        <div class="alert-box">
            <i class="fas fa-info-circle fa-lg"></i>
            <div>
                <strong>Vertical Allocation Logic:</strong> Select exactly 2 branches to mix students for enhanced academic integrity. 
                Seats are allocated using the vertical sequence algorithm.
            </div>
        </div>

        <form action="../GenerateSeatingServlet" method="POST" id="allocationForm" class="animate__animated animate__fadeInUp">
            <div class="row">
                <div class="col-lg-8">
                    <!-- Section 1: Exam Configuration -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-clipboard-list"></i>
                            Exam Configuration
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Academic Year</label>
                                <select name="academicYear" class="form-select" required>
                                    <option value="">Select Academic Year</option>
                                    <% for(String year : academicYears) { %>
                                        <option value="<%= year %>"><%= year %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Exam Type</label>
                                <select name="examType" class="form-select" required>
                                    <option value="">Select Exam Type</option>
                                    <% for(String type : examTypes) { %>
                                        <option value="<%= type %>"><%= type %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Examination Date</label>
                                <input type="date" name="examDate" class="form-control" required 
                                       min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Session</label>
                                <select name="shift" class="form-select" required>
                                    <option value="">Select Session</option>
                                    <% for(String sess : sessions) { %> 
    <option value="<%= sess %>"><%= sess %></option>
<% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="row g-3">
    <div class="col-md-6 mb-3">
        <label class="form-label fw-bold">Subject for Branch 1</label>
        <select name="subject1" id="subjectSelect1" class="form-select" required>
            <option value="">-- Select Branch 1 First --</option>
        </select>
    </div>
    <div class="col-md-6 mb-3">
        <label class="form-label fw-bold">Subject for Branch 2</label>
        <select name="subject2" id="subjectSelect2" class="form-select" required>
            <option value="">-- Select Branch 2 First --</option>
        </select>
    </div>
</div>
                    </div>

                    <!-- Section 2: Student Selection -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-users"></i>
                            Student Selection
                        </div>
                        
                        <div class="mb-4">
                            <label class="form-label">Select Semesters</label>
                            <div class="quick-actions">
                                <button type="button" class="quick-btn" onclick="selectSemesters('odd')">
                                    <i class="fas fa-filter me-1"></i> Odd
                                </button>
                                <button type="button" class="quick-btn" onclick="selectSemesters('even')">
                                    <i class="fas fa-filter me-1"></i> Even
                                </button>
                                <button type="button" class="quick-btn" onclick="selectSemesters('all')">
                                    <i class="fas fa-check-double me-1"></i> All
                                </button>
                                <button type="button" class="quick-btn" onclick="selectSemesters('none')">
                                    <i class="fas fa-times me-1"></i> Clear
                                </button>
                            </div>
                            
                            <%-- Line ~380 ke paas --%>
							<div class="selection-grid" id="semesterGrid">
								<%
								for (int i = 1; i <= 8; i++) {
									// Real count calculation for this semester across all branches
									int semTotal = 0;
									for (String b : branches) {
										if (dbStats.containsKey(b) && dbStats.get(b).containsKey(String.valueOf(i))) {
									semTotal += dbStats.get(b).get(String.valueOf(i));
										}
									}
								%>
								<div class="selection-item" data-semester="<%=i%>"
									onclick="toggleSemester(this)">
									<div class="item-number"><%=i%></div>
									<div class="item-label">
										Semester
										<%=i%></div>
									<%-- Ab yahan real database count dikhega --%>
									<div
										style="font-size: 0.8rem; color: var(--primary-blue); font-weight: 600; margin-top: 5px;">
										<%=semTotal%>
										Students
									</div>
									<input type="checkbox" name="semesters" value="<%=i%>"
										class="d-none">
								</div>
								<% } %>
							</div>
						</div>
                        
                        <div class="mb-4">
                            <label class="form-label">Select Exactly 2 Branches to Mix</label>
                            <%-- Line ~400 ke paas --%>
<div class="branch-grid" id="branchGrid">
    <% 
    for(String branch : branches) { 
        // 1. Pehle Real count nikalna (Across all semesters)
        int branchTotal = 0;
        if(dbStats != null && dbStats.containsKey(branch)) {
            for(int count : dbStats.get(branch).values()) {
                branchTotal += count;
            }
        }

        // 2. Phir Branch ka full name set karna (Ye wala part missing tha)
        String branchName = "";
        switch(branch) {
            case "CS": branchName = "Computer Science"; break;
            case "IT": branchName = "Information Technology"; break;
            case "CSITCS": branchName = "CS with IOT & Cyber Security"; break;
            case "IOT": branchName = "Internet Of Things"; break;
            case "EC": branchName = "Electronics & Communication"; break;
            case "ME": branchName = "Mechanical Engineering"; break;
            case "CE": branchName = "Civil Engineering"; break;
            case "EE": branchName = "Electrical Engineering"; break;
            case "AE": branchName = "Automobile Engineering"; break;
            case "CH": branchName = "Chemical Engineering"; break;
            default: branchName = "Other Branch";
        }
    %>
        <div class="branch-item" data-branch="<%=branch%>" onclick="toggleBranch(this)">
            <div class="branch-code"><%=branch%></div>
            <div class="branch-name"><%=branchName%></div>
            <%-- Ab yahan real database count dikhega --%>
            <div style="font-size: 0.8rem; color: var(--primary-blue); font-weight: 600; margin-top: 5px;">
                <%=branchTotal%> Students
            </div>
            <input type="checkbox" name="branches" value="<%=branch%>" class="d-none">
        </div>
    <% } %>
</div>
                        </div>
                    </div>

                    <!-- Section 3: Room Allocation -->
                    <div class="form-section">
                        <div class="section-title">
                            <i class="fas fa-building"></i>
                            Room Allocation
                        </div>
                        
                        <div class="building-tabs">
                            <div class="building-tab active" onclick="showBuilding('new')">
                                New Building
                            </div>
                            <div class="building-tab" onclick="showBuilding('old')">
                                Old Building
                            </div>
                        </div>
                        
                        <div class="quick-actions mb-3">
                            <button type="button" class="quick-btn" onclick="selectAllRooms()">
                                <i class="fas fa-check-square me-1"></i> Select All
                            </button>
                            <button type="button" class="quick-btn" onclick="deselectAllRooms()">
                                <i class="fas fa-times-circle me-1"></i> Clear
                            </button>
                        </div>
                        
                        <div class="room-grid" id="newBuildingRooms">
    <% 
    // SQL query using LIKE for partial matching with building_block
    String newBuildSql = "SELECT * FROM rooms WHERE building_block LIKE 'New Building%' ORDER BY room_no";
    try(Connection c = DBConnection.getConnection();
        ResultSet rs = c.createStatement().executeQuery(newBuildSql)) { 
        boolean found = false;
        while(rs.next()) { 
            found = true;
            String roomNo = rs.getString("room_no");
            int columns = rs.getInt("total_columns");
            int benches = rs.getInt("benches_per_column");
            int capacity = columns * benches * 2; // Vertical Allocation: 2 students per bench [cite: 2026-01-05]
            int floorNum = rs.getInt("floor"); 
    %>
        <div class="room-item" data-room="<%=roomNo%>" data-capacity="<%=capacity%>" onclick="toggleRoom(this)">
            <div class="room-header">
                <div class="room-name">Hall <%=roomNo%></div>
                <div class="room-capacity"><%=capacity%> seats</div>
            </div>
            <div class="room-details">
                <span>Floor: <%=floorNum%></span>
                <span><%=columns%> columns</span>
            </div>
            <input type="checkbox" name="roomIds" value="<%=roomNo%>" class="d-none">
        </div>
    <%  } 
        if(!found) { %> <p class="text-muted p-3">No rooms found in New Building.</p> <% }
    } catch(Exception e) { e.printStackTrace(); } %>
</div>
                        
                        <div class="room-grid d-none" id="oldBuildingRooms">
    <% 
    String oldBuildSql = "SELECT * FROM rooms WHERE building_block LIKE 'Old Building%' ORDER BY room_no";
    try(Connection c = DBConnection.getConnection(); 
        ResultSet rs = c.createStatement().executeQuery(oldBuildSql)) { 
        boolean found = false;
        while(rs.next()) { 
            found = true;
            String roomNo = rs.getString("room_no");
            int columns = rs.getInt("total_columns");
            int benches = rs.getInt("benches_per_column");
            int capacity = columns * benches * 2;
            int floorNum = rs.getInt("floor");
    %>
        <div class="room-item" data-room="<%=roomNo%>" data-capacity="<%=capacity%>" onclick="toggleRoom(this)">
            <div class="room-header">
                <div class="room-name">Hall <%=roomNo%></div>
                <div class="room-capacity"><%=capacity%> seats</div>
            </div>
            <div class="room-details">
                <span>Floor: <%=floorNum%></span>
                <span><%=columns%> columns</span>
            </div>
            <input type="checkbox" name="roomIds" value="<%=roomNo%>" class="d-none">
        </div>
    <%  }
        if(!found) { %> <p class="text-muted p-3">No rooms found in Old Building.</p> <% }
    } catch(Exception e) { e.printStackTrace(); } %>
</div>
                    </div>
                </div>

                <!-- Summary Panel -->
                <div class="col-lg-4">
                    <div class="summary-panel">
                        <div class="summary-title">
                            <i class="fas fa-chart-pie"></i>
                            Allocation Summary
                        </div>
                        
                        <div class="summary-item">
                            <span class="summary-label">Selected Semesters</span>
                            <span class="summary-value" id="totalSemesters">0</span>
                        </div>
                        
                        <div class="summary-item">
                            <span class="summary-label">Selected Branches</span>
                            <span class="summary-value" id="totalBranches">0/2</span>
                        </div>

						<div class="summary-item">
							<span class="summary-label">Total Students (Branch A + B)</span>
							<span class="summary-value" id="totalStudents">0</span>
						</div>

						<div class="summary-item">
                            <span class="summary-label">Selected Rooms</span>
                            <span class="summary-value" id="totalRooms">0</span>
                        </div>
                        
                        <div class="summary-item">
                            <span class="summary-label">Total Capacity</span>
                            <span class="summary-value" id="totalCapacity">0</span>
                        </div>
                        
                        <div id="statusBox" class="status-box status-waiting">
                            <i class="fas fa-info-circle"></i>
                            <span>Complete all sections</span>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label mb-2">Notes (Optional)</label>
                            <textarea class="form-control" rows="3" name="allocationNotes" placeholder="Additional instructions..."></textarea>
                        </div>
                        
                        <button type="submit" class="generate-btn" id="generateBtn" disabled>
                            <i class="fas fa-bolt"></i>
                            GENERATE PLAN
                        </button>
                        
                        <div class="text-center mt-3" style="color: #666; font-size: 0.85rem;">
                            <i class="fas fa-shield-alt me-1"></i>
                            Vertical sequence algorithm
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script>
    
    const studentData = {
            <% 
            // Ensure karein ki dbStats wala Java block file ke top par present hai
            if (dbStats != null) {
                for(String b : dbStats.keySet()) { 
            %>
                "<%= b %>": {
                    <% for(String s : dbStats.get(b).keySet()) { %>
                        "<%= s %>": <%= dbStats.get(b).get(s) %>,
                    <% } %>
                },
            <% 
                } 
            }
            %>
        };
    
    const allSubjectsLocal = [
        <% for(Subject s : allSubjectsList) { %>
            { 
                branch: "<%= s.getBranch() %>", 
                sem: <%= s.getSemester() %>, 
                name: "<%= s.getSubjectName() %>" 
            },
        <% } %>
    ];
    
 // Jab Branch ya Semester change ho, tab subjects fetch karo
    document.querySelectorAll('input[name="branches"], input[name="semesters"]').forEach(element => {
        element.addEventListener('change', fetchSubjects);
    });

    function fetchSubjects() {
        // Current selections nikalein
        const selectedBranches = Array.from(document.querySelectorAll('input[name="branches"]:checked')).map(cb => cb.value);
        const selectedSemesters = Array.from(document.querySelectorAll('input[name="semesters"]:checked')).map(cb => cb.value);
        
        const sub1 = document.getElementById('subjectSelect1');
        const sub2 = document.getElementById('subjectSelect2');

        // Default: Dono ko reset kar dein
        sub1.innerHTML = '<option value="">-- Select Branch 1 First --</option>';
        sub2.innerHTML = '<option value="">-- Select Branch 2 First --</option>';

        if (selectedSemesters.length > 0) {
            const sem = parseInt(selectedSemesters[0]);

            // Branch 1 ke subjects fill karein
            if (selectedBranches.length >= 1) {
                const branch1 = selectedBranches[0];
                const filtered1 = allSubjectsLocal.filter(s => s.branch === branch1 && s.sem === sem);
                populateDropdown(sub1, filtered1, branch1);
            }

            // Branch 2 ke subjects fill karein
            if (selectedBranches.length === 2) {
                const branch2 = selectedBranches[1];
                const filtered2 = allSubjectsLocal.filter(s => s.branch === branch2 && s.sem === sem);
                populateDropdown(sub2, filtered2, branch2);
            }
        }
    }

    // Helper function dropdown bharne ke liye
    function populateDropdown(dropdown, subjects, branchName) {
        if (subjects.length > 0) {
            dropdown.innerHTML = '<option value="">-- Select Subject for ' + branchName + ' --</option>';
            subjects.forEach(sub => {
                const option = document.createElement('option');
                option.value = sub.name;
                option.textContent = sub.name;
                dropdown.add(option);
            });
        } else {
            dropdown.innerHTML = '<option value="">No subjects found for ' + branchName + '</option>';
        }
    }
        // Simple selection functions
        function toggleSemester(element) {
            const checkbox = element.querySelector('input[type="checkbox"]');
            checkbox.checked = !checkbox.checked;
            
            if (checkbox.checked) {
                element.classList.add('selected');
            } else {
                element.classList.remove('selected');
            }
            
            updateSummary();
            fetchSubjects();
        }
        
        function toggleBranch(element) {
            const checkbox = element.querySelector('input[type="checkbox"]');
            const selectedBranches = document.querySelectorAll('.branch-item.selected');
            
            if (!checkbox.checked && selectedBranches.length >= 2) {
                alert('You can only select exactly 2 branches for vertical allocation.');
                return;
            }
            
            checkbox.checked = !checkbox.checked;
            
            if (checkbox.checked) {
                element.classList.add('selected');
            } else {
                element.classList.remove('selected');
            }
            
            updateSummary();
            fetchSubjects();
        }
        
        function toggleRoom(element) {
            const checkbox = element.querySelector('input[type="checkbox"]');
            checkbox.checked = !checkbox.checked;
            
            if (checkbox.checked) {
                element.classList.add('selected');
            } else {
                element.classList.remove('selected');
            }
            
            updateSummary();
        }
        
        // Quick selection functions
        function selectSemesters(type) {
            const items = document.querySelectorAll('.selection-item');
            
            items.forEach(item => {
                const semester = parseInt(item.getAttribute('data-semester'));
                const checkbox = item.querySelector('input[type="checkbox"]');
                
                let shouldSelect = false;
                
                if (type === 'odd' && semester % 2 === 1) shouldSelect = true;
                if (type === 'even' && semester % 2 === 0) shouldSelect = true;
                if (type === 'all') shouldSelect = true;
                if (type === 'none') shouldSelect = false;
                
                if (type === 'none') {
                    checkbox.checked = false;
                    item.classList.remove('selected');
                } else if (shouldSelect) {
                    checkbox.checked = true;
                    item.classList.add('selected');
                }
            });
            
            updateSummary();
            fetchSubjects();
        }
        
        function showBuilding(building) {
            const newTab = document.querySelector('.building-tab:first-child');
            const oldTab = document.querySelector('.building-tab:last-child');
            const newRooms = document.getElementById('newBuildingRooms');
            const oldRooms = document.getElementById('oldBuildingRooms');
            
            if (building === 'new') {
                newTab.classList.add('active');
                oldTab.classList.remove('active');
                newRooms.classList.remove('d-none');
                oldRooms.classList.add('d-none');
            } else {
                newTab.classList.remove('active');
                oldTab.classList.add('active');
                newRooms.classList.add('d-none');
                oldRooms.classList.remove('d-none');
            }
        }
        
        function selectAllRooms() {
            const activeBuilding = document.querySelector('.building-tab.active');
            const buildingId = activeBuilding.textContent.includes('New') ? 'newBuildingRooms' : 'oldBuildingRooms';
            const rooms = document.querySelectorAll(`#${buildingId} .room-item`);
            
            rooms.forEach(room => {
                const checkbox = room.querySelector('input[type="checkbox"]');
                checkbox.checked = true;
                room.classList.add('selected');
            });
            
            updateSummary();
        }
        
        function deselectAllRooms() {
            const activeBuilding = document.querySelector('.building-tab.active');
            const buildingId = activeBuilding.textContent.includes('New') ? 'newBuildingRooms' : 'oldBuildingRooms';
            const rooms = document.querySelectorAll(`#${buildingId} .room-item`);
            
            rooms.forEach(room => {
                const checkbox = room.querySelector('input[type="checkbox"]');
                checkbox.checked = false;
                room.classList.remove('selected');
            });
            
            updateSummary();
        }
        
        function updateSummary() {
            // 1. Selected Semesters aur Branches ki actual values nikalein
            let selectedSems = [];
            document.querySelectorAll('.selection-item.selected input').forEach(i => selectedSems.push(i.value));
            
            let selectedBranches = [];
            document.querySelectorAll('.branch-item.selected input').forEach(i => selectedBranches.push(i.value));

            const semesterCount = selectedSems.length;
            const branchCount = selectedBranches.length;
            const roomCount = document.querySelectorAll('.room-item.selected').length;
            
            // 2. Formula Fix: Real-time dynamic calculation [cite: 2026-01-05]
            let realStudents = 0;
            if (branchCount === 2 && semesterCount > 0) {
                selectedBranches.forEach(branch => {
                    selectedSems.forEach(sem => {
                        // Check if data exists for this branch and semester
                        if(studentData[branch] && studentData[branch][sem]) {
                            realStudents += studentData[branch][sem];
                        }
                    });
                });
            }

            // 3. UI Updates
            document.getElementById('totalSemesters').textContent = semesterCount;
            document.getElementById('totalBranches').textContent = branchCount + "/2";
            document.getElementById('totalStudents').textContent = realStudents;
            document.getElementById('totalRooms').textContent = roomCount;
            
            // Capacity calculation
            let totalCap = 0;
            document.querySelectorAll('.room-item.selected').forEach(room => {
                totalCap += parseInt(room.getAttribute('data-capacity') || '0');
            });
            document.getElementById('totalCapacity').textContent = totalCap;

            // Enable button only if capacity is sufficient
            const generateBtn = document.getElementById('generateBtn');
            generateBtn.disabled = !(realStudents > 0 && roomCount > 0 && totalCap >= realStudents);
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            const examDateInput = document.querySelector('input[name="examDate"]');
            if (examDateInput) {
                examDateInput.min = today;
            }
            
            // Add event listeners to form inputs
            const formInputs = document.querySelectorAll('input, select');
            formInputs.forEach(input => {
                input.addEventListener('change', updateSummary);
            });
            
            // Initial summary update
            updateSummary();
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>