<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*, com.smartseat.util.DBConnection, java.util.*" %>
<%
    // Session check: If not logged in, redirect to index page
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../home?error=Please Login First");
    }
    String name = (String) session.getAttribute("adminName");
    String role = (String) session.getAttribute("adminRole");
    
    // Sample data - In real app, fetch from database
    java.util.Date today = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
    String currentDate = sdf.format(today);
    
 // 1. Page Load Time start point
    long startTime = System.currentTimeMillis();

    // 2. Active Sessions fetch karna
    int activeSessionsCount = com.smartseat.util.SessionListener.getActiveSessions();
    if(activeSessionsCount <= 0) activeSessionsCount = 1; 

    // 3. Uptime Calculate karna (FIXED LINE)
    // Hum current user ki session creation time use karenge
    long sessionStartTime = session.getCreationTime(); 
    long diff = System.currentTimeMillis() - sessionStartTime;
    
    // Minutes mein dikhane ke liye
    long minutes = diff / (60 * 1000);
    String uptimeDisplay = (minutes > 0 ? minutes + " mins" : "Just started");
    
 // Database se dynamic data nikalne ke liye variables
    int totalStudentsCount = 0;
    int totalRoomsCount = 0;
    int totalPlansCount = 0;
    int branchCount = 0;

    try (Connection conn = com.smartseat.util.DBConnection.getConnection()) {
        // 1. Total Students Count
        ResultSet rs1 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM students");
        if(rs1.next()) totalStudentsCount = rs1.getInt(1);

        // 2. Total Rooms Count
        ResultSet rs2 = conn.createStatement().executeQuery("SELECT COUNT(*) FROM rooms");
        if(rs2.next()) totalRoomsCount = rs2.getInt(1);

        // 3. Active Seating Plans (Unique exams/dates)
        ResultSet rs3 = conn.createStatement().executeQuery("SELECT COUNT(DISTINCT exam_date, shift) FROM seating_plan");
        if(rs3.next()) totalPlansCount = rs3.getInt(1);
        
        // 4. Unique Branches
        ResultSet rs4 = conn.createStatement().executeQuery("SELECT COUNT(DISTINCT branch) FROM students");
        if(rs4.next()) branchCount = rs4.getInt(1);

    } catch(Exception e) {
        e.printStackTrace();
    }
    
 // Pehle wale counts ke baad ye add karein
    List<Map<String, String>> activities = new ArrayList<>();
    
    try (Connection conn = com.smartseat.util.DBConnection.getConnection()) {
        // Latest 2 Rooms fetch karna
        String roomSql = "SELECT room_no, building_block FROM rooms ORDER BY room_no DESC LIMIT 2";
        ResultSet rsRooms = conn.createStatement().executeQuery(roomSql);
        while(rsRooms.next()) {
            Map<String, String> act = new HashMap<>();
            act.put("icon", "fas fa-door-open");
            act.put("title", "New Room Added");
            act.put("desc", "Exam Hall " + rsRooms.getString("room_no") + " in " + rsRooms.getString("building_block"));
            act.put("time", "Recently");
            activities.add(act);
        }

        // Latest 2 Seating Plans fetch karna
        String planSql = "SELECT DISTINCT exam_date, shift FROM seating_plan ORDER BY exam_date DESC LIMIT 2";
        ResultSet rsPlans = conn.createStatement().executeQuery(planSql);
        while(rsPlans.next()) {
            Map<String, String> act = new HashMap<>();
            act.put("icon", "fas fa-cogs");
            act.put("title", "Plan Generated");
            act.put("desc", "Seating for " + rsPlans.getString("exam_date") + " (" + rsPlans.getString("shift") + ")");
            act.put("time", "Recently");
            activities.add(act);
        }
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Smart-Seat IPS Academy</title>
    
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
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
            --shadow-lg: 0 8px 30px rgba(0,0,0,0.12);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
            color: var(--dark-gray);
            overflow-x: hidden;
            min-height: 100vh;
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 40px;
            min-height: 100vh;
        }

        /* Top Navigation Bar */
        .top-nav {
            background: white;
            padding: 20px 40px;
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title h1 {
            font-weight: 800;
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .page-title p {
            color: var(--medium-gray);
            font-size: 0.95rem;
            margin: 0;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .date-display {
            background: var(--primary-light);
            color: var(--primary-blue);
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 14px;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
            color: white;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-blue);
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            background: var(--primary-light);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: var(--primary-blue);
            font-size: 28px;
        }

        .stat-info h3 {
            font-weight: 800;
            font-size: 2.5rem;
            color: var(--primary-dark);
            margin: 0 0 5px 0;
            line-height: 1;
        }

        .stat-info p {
            color: var(--medium-gray);
            font-size: 0.95rem;
            margin: 0;
        }

        .stat-trend {
            font-size: 0.85rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
            margin-top: 8px;
        }

        .trend-up { color: var(--success-green); }
        .trend-down { color: var(--error-red); }

        /* Quick Actions */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 50px 0 25px 0;
        }

        .section-title {
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--primary-dark);
        }

        .section-subtitle {
            color: var(--medium-gray);
            font-size: 1rem;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .action-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-blue);
        }

        .action-icon {
            width: 60px;
            height: 60px;
            background: var(--primary-light);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            color: var(--primary-blue);
            font-size: 24px;
        }

        .action-title {
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--primary-dark);
            margin-bottom: 8px;
        }

        .action-desc {
            color: var(--medium-gray);
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Recent Activity */
        .activity-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            margin-top: 30px;
        }

        .activity-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .activity-item {
            padding: 20px 0;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 50px;
            height: 50px;
            background: var(--primary-light);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: var(--primary-blue);
            font-size: 20px;
        }

        .activity-content h4 {
            font-weight: 600;
            font-size: 1rem;
            color: var(--dark-gray);
            margin: 0 0 5px 0;
        }

        .activity-content p {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin: 0;
        }

        .activity-time {
            font-size: 0.85rem;
            color: var(--medium-gray);
            margin-left: auto;
        }

        /* System Status */
        .status-card {
            background: linear-gradient(135deg, var(--primary-dark), #002244);
            color: white;
            border-radius: 20px;
            padding: 30px;
            margin-top: 30px;
        }

        .status-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .status-indicator {
            width: 12px;
            height: 12px;
            background: var(--success-green);
            border-radius: 50%;
            margin-right: 10px;
            animation: pulse 2s infinite;
        }
        
        /* Status Card Desktop Layout */
.status-stats-container {
    display: flex;
    gap: 40px;
    flex-wrap: wrap; /* Mobile par items ko niche shift hone dega */
}

.status-stat-item {
    text-align: center;
}

.stat-number {
    font-size: 2rem;
    font-weight: 700;
}

.stat-text {
    font-size: 0.9rem;
    opacity: 0.8;
}

/* Mobile Fix (Jab screen choti ho) */
@media (max-width: 576px) {
    .status-stats-container {
        gap: 20px;
        justify-content: space-between; /* Items ke beech barabar jagah */
    }
    
    .status-stat-item {
        flex: 1 1 40%; /* Ek line mein 2 item aayenge, 3rd wala apne aap niche stack hoga */
        text-align: left; /* Mobile par left alignment zyada clean lagta hai */
    }

    .stat-number {
        font-size: 1.5rem; /* Numbers ka size thoda chota mobile ke liye */
    }
}

        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

       
    </style>
</head>
<body>

    <!-- Professional Sidebar -->
    <jsp:include page="includes/sidebar.jsp" />

    <div class="main-content">
    <div class="top-nav animate__animated animate__fadeInDown">
        <div class="page-title">
            <%-- College Name Dynamic --%>
            <div style="font-size: 0.85rem; color: #3498db; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">
                <%= application.getAttribute("college_name") != null ? application.getAttribute("college_name") : "SMART-SEAT" %>
            </div>

            <h1><%= "Staff".equals(role) ? "Staff Dashboard" : "Admin Dashboard" %></h1>
            
            <p>
                Welcome back, <strong><%= name %></strong>. 
                <%-- Academic Year Dynamic --%>
                Session: <span class="badge bg-light text-dark"><%= application.getAttribute("academic_year") %></span>
            </p>
        </div>

        <div class="header-actions">
            <%-- New Allotment button sirf Admin ko dikhega --%>
            <% if (!"Staff".equals(role)) { %>
                <a href="generate-plan.jsp" class="btn-primary-custom">
                    <i class="fas fa-plus-circle me-2"></i> 
                    New Allotment
                </a>
            <% } %>
        </div>
    </div>

        <!-- Stats Overview -->
        <div class="stats-grid animate__animated animate__fadeInUp">
    <% if("Staff".equals(role)) { %>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
            <div class="stat-info">
                <h3>03</h3> 
                <p>Today's Duties</p>
                <div class="stat-trend trend-up">
                    <span>Assigned in Block A & B</span>
                </div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-door-open"></i></div>
            <div class="stat-info">
                <h3>08</h3> 
                <p>Rooms Supervised</p>
                <div class="stat-trend trend-up">
                    <span>Current Active Rooms</span>
                </div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon"><i class="fas fa-users"></i></div>
            <div class="stat-info">
                <h3>450</h3>
                <p>Students Today</p>
                <div class="stat-trend trend-up">
                    <span>Expected in your shift</span>
                </div>
            </div>
        </div>
    <% } else { %>
    <div class="stat-card">
        <div class="stat-icon" style="background: #e0f2fe; color: #0369a1;"><i class="fas fa-user-graduate"></i></div>
        <div class="stat-info">
            <h3><%= totalStudentsCount %></h3> 
            <p>Registered Students</p>
            <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> <span>Dynamic</span></div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background: #fef3c7; color: #92400e;"><i class="fas fa-door-open"></i></div>
        <div class="stat-info">
            <h3><%= totalRoomsCount %></h3> 
            <p>Total Classrooms</p>
            <div class="stat-trend trend-up"><span>Active Halls</span></div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background: #dcfce7; color: #166534;"><i class="fas fa-file-signature"></i></div>
        <div class="stat-info">
            <h3><%= totalPlansCount %></h3> 
            <p>Seating Plans</p>
            <div class="stat-trend trend-up"><span>Allotments Done</span></div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background: #f3e8ff; color: #7e22ce;"><i class="fas fa-university"></i></div>
        <div class="stat-info">
            <h3><%= branchCount %></h3> 
            <p>Active Branches</p>
            <div class="stat-trend trend-up"><span>Departments</span></div>
        </div>
    </div>
<% } %>
</div>

<% if("Staff".equals(role)) { %>
    <div class="activity-card animate__animated animate__fadeInUp" style="margin-bottom: 30px;">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="section-title">Today's Seating Quick View</h3>
                <p class="section-subtitle">Real-time room allotment for current shift</p>
            </div>
            <a href="seating-chart.jsp" class="btn-primary-custom" style="padding: 8px 16px;">
                View Full Chart
            </a>
        </div>
        
        <div class="table-responsive">
            <table class="table table-hover custom-table">
                <thead class="table-light">
                    <tr>
                        <th>Room No.</th>
                        <th>Subject / Branch</th>
                        <th>Time Slot</th>
                        <th>Strength</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong>B-101</strong></td>
                        <td>CS (3rd Sem) & IT (3rd Sem)</td>
                        <td>10:00 AM - 01:00 PM</td>
                        <td>60/60</td>
                        <td><span class="badge bg-success bg-opacity-10 text-success">Active</span></td>
                    </tr>
                    <tr>
                        <td><strong>A-203</strong></td>
                        <td>Mechanical (5th Sem)</td>
                        <td>10:00 AM - 01:00 PM</td>
                        <td>45/60</td>
                        <td><span class="badge bg-warning bg-opacity-10 text-warning">In-Progress</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
<% } %>

        <!-- Quick Actions -->
        <div class="section-header animate__animated animate__fadeInUp">
            <div>
                <h2 class="section-title">Quick Actions</h2>
                <p class="section-subtitle">Frequently used administrative tasks</p>
            </div>
        </div>

        <div class="actions-grid animate__animated animate__fadeInUp">
            <a href="add-room.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-door-open"></i>
                </div>
                <h3 class="action-title">Manage Rooms</h3>
                <p class="action-desc">Add, edit or remove examination rooms and configure capacities.</p>
            </a>

            <a href="import-students.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-file-upload"></i>
                </div>
                <h3 class="action-title">Import Students</h3>
                <p class="action-desc">Upload CSV files to import student data in bulk.</p>
            </a>

            <a href="generate-plan.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-cogs"></i>
                </div>
                <h3 class="action-title">Generate Seating</h3>
                <p class="action-desc">Run vertical allocation algorithm to create seating plans.</p>
            </a>

            <a href="seating-chart.jsp" class="action-card">
                <div class="action-icon">
                    <i class="fas fa-print"></i>
                </div>
                <h3 class="action-title">Print Charts</h3>
                <p class="action-desc">Generate printable seating charts for exam halls.</p>
            </a>
        </div>

        <!-- Recent Activity -->
        <div class="activity-card animate__animated animate__fadeInUp">
    <h3 class="section-title">Recent Activity</h3>
    <p class="section-subtitle">Latest system updates from database</p>
    
    <ul class="activity-list">
        <% if(activities.isEmpty()) { %>
            <li class="activity-item">
                <p class="text-muted">No recent activities found.</p>
            </li>
        <% } else { 
            for(Map<String, String> activity : activities) { %>
            <li class="activity-item">
                <div class="activity-icon">
                    <i class="<%= activity.get("icon") %>"></i>
                </div>
                <div class="activity-content">
                    <h4><%= activity.get("title") %></h4>
                    <p><%= activity.get("desc") %></p>
                </div>
                <div class="activity-time"><%= activity.get("time") %></div>
            </li>
        <% } } %>
    </ul>
</div>

        <!-- System Status -->
        <div class="status-card animate__animated animate__fadeInUp">
    <div class="status-header">
        <div class="status-indicator"></div>
        <h3 style="margin: 0; color: white;">System Status</h3>
    </div>
    <p style="color: rgba(255, 255, 255, 0.9); margin-bottom: 25px;">
        All systems are operational. Server response time is optimal.
    </p>
    
    <div class="status-stats-container">
        <div class="status-stat-item">
            <div class="stat-number"><%= uptimeDisplay %></div>
            <div class="stat-text">System Uptime</div>
        </div>
        <div class="status-stat-item">
            <div class="stat-number"><%= activeSessionsCount %></div>
            <div class="stat-text">Active Sessions</div>
        </div>
        <div class="status-stat-item">
            <% 
                // Load time calculate karna
                long endTime = System.currentTimeMillis();
                double loadTime = (endTime - startTime) / 1000.0; 
            %>
            <div class="stat-number"><%= String.format("%.2f", loadTime) %>s</div>
            <div class="stat-text">Page Load Time</div>
        </div>
    </div>
</div>
    </div>

    <!-- Mobile Menu Toggle (Hidden by default) -->
    <!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button> -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Mobile menu toggle functionality
        // dashboard.jsp ke script section mein replace karein
/* document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (mobileMenuToggle && sidebar) {
        mobileMenuToggle.addEventListener('click', function(e) {
            e.stopPropagation();
            sidebar.classList.toggle('active');
        });

        // Mobile UX: Sidebar ke bahar click karne par band ho jaye
        document.addEventListener('click', function(event) {
            if (!sidebar.contains(event.target) && !mobileMenuToggle.contains(event.target)) {
                sidebar.classList.remove('active');
            }
        });
    }
}); */

        // Update stats with live data (simulated)
        function updateLiveStats() {
            // In a real application, this would fetch data from an API
            const studentCount = document.querySelector('.stat-card:nth-child(3) h3');
            if (studentCount) {
                // Simulate live updates
                const current = parseInt(studentCount.textContent.replace(',', ''));
                const newCount = current + Math.floor(Math.random() * 10);
                studentCount.textContent = newCount.toLocaleString();
            }
        }

        // Update every 30 seconds
        setInterval(updateLiveStats, 30000);

        // Add active class to current page in sidebar
        

        // Simple animations on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('animate__animated', 'animate__fadeInUp');
                }
            });
        }, observerOptions);

        // Observe all cards for animation
        document.querySelectorAll('.stat-card, .action-card, .activity-card').forEach(card => {
            observer.observe(card);
        });
    </script>
</body>
</html>