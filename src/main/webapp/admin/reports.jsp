<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // Session and Auth check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../index.jsp?error=Please Login First");
    }
    String name = (String) session.getAttribute("adminName");
    java.util.Date today = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
    String currentDate = sdf.format(today);
    
    // Servlet data
    Map<String, Integer> branchStats = (Map<String, Integer>) request.getAttribute("branchStats");
    List<Map<String, Object>> roomDetails = (List<Map<String, Object>>) request.getAttribute("roomDetails");
    Integer totalAllocated = (Integer) request.getAttribute("totalAllocated");
    Integer totalRoomsUsed = (Integer) request.getAttribute("totalRoomsUsed");
    Long avgUtilization = (Long) request.getAttribute("avgUtilization");

    // Defaults
    if(totalAllocated == null) totalAllocated = 0;
    if(totalRoomsUsed == null) totalRoomsUsed = 0;
    if(avgUtilization == null) avgUtilization = 0L;
    if(branchStats == null) branchStats = new HashMap<>();
    if(roomDetails == null) roomDetails = new ArrayList<>();
    
    // Sample data for charts if empty
    if(branchStats.isEmpty()) {
        branchStats.put("CS", 350);
        branchStats.put("IT", 280);
        branchStats.put("EC", 320);
        branchStats.put("ME", 240);
        branchStats.put("CE", 190);
    }
    
    // Calculate total capacity
    int totalCapacity = 0;
    int totalAllocatedSeats = 0;
    for(Map<String, Object> room : roomDetails) {
        Object capObj = room.get("capacity");
        Object allocObj = room.get("allocated");
        if(capObj instanceof Integer) totalCapacity += (Integer)capObj;
        if(allocObj instanceof Integer) totalAllocatedSeats += (Integer)allocObj;
    }
    if(totalCapacity == 0) totalCapacity = 1200; // Default
    if(totalAllocatedSeats == 0) totalAllocatedSeats = totalAllocated;
    
    int vacantSeats = Math.max(0, totalCapacity - totalAllocatedSeats);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics | Smart-Seat IPS Academy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            min-height: 100vh;
        }

        /* Main Content */
        .main-content {
            margin-left: 280px;
            padding: 40px;
            min-height: 100vh;
        }

        /* Header */
        .top-nav {
            background: white;
            padding: 25px 30px;
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
            cursor: pointer;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
            color: white;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-blue);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .stat-info h3 {
            font-weight: 700;
            font-size: 2rem;
            color: var(--primary-dark);
            margin: 0 0 5px 0;
            line-height: 1;
        }

        .stat-info p {
            color: var(--medium-gray);
            font-size: 0.9rem;
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

        /* Report Cards */
        .report-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            height: 100%;
            transition: all 0.3s ease;
        }

        .report-card:hover {
            box-shadow: var(--shadow-md);
        }

        .section-title {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 20px;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            gap: 10px;
            border-bottom: 2px solid var(--primary-light);
            padding-bottom: 15px;
        }

        .section-title i {
            color: var(--primary-blue);
        }

        /* Chart Containers */
        .chart-container {
            position: relative;
            height: 280px;
            width: 100%;
            margin-top: 20px;
        }

        /* Table Container */
        .table-container {
            background: white;
            border-radius: 16px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        /* Utilization Bar */
        .utilization-bar {
            height: 8px;
            border-radius: 4px;
            background: #eee;
            overflow: hidden;
            margin-top: 10px;
            position: relative;
        }

        .utilization-fill {
            height: 100%;
            position: absolute;
            left: 0;
            top: 0;
            transition: width 1s ease-in-out;
            border-radius: 4px;
        }

        .bg-success { background: var(--success-green) !important; }
        .bg-warning { background: var(--warning-orange) !important; }
        .bg-danger { background: var(--error-red) !important; }

        /* Custom Table */
        .custom-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .custom-table thead th {
            background: var(--primary-light);
            color: var(--primary-blue);
            font-weight: 600;
            font-size: 0.9rem;
            padding: 15px;
            border: none;
            border-bottom: 2px solid var(--border-color);
        }

        .custom-table tbody td {
            padding: 15px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .custom-table tbody tr:hover {
            background: var(--light-gray);
        }

        .custom-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* Badge */
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-optimal { background: #d1fae5; color: #065f46; }
        .status-warning { background: #fef3c7; color: #92400e; }
        .status-critical { background: #fee2e2; color: #991b1b; }

        /* Tabs */
        .report-tabs {
            display: flex;
            gap: 5px;
            background: var(--primary-light);
            padding: 5px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .report-tab {
            flex: 1;
            text-align: center;
            padding: 12px;
            font-weight: 600;
            color: var(--medium-gray);
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .report-tab.active {
            background: white;
            color: var(--primary-blue);
            box-shadow: var(--shadow-sm);
        }

        /* Branch Cards */
        .branch-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .branch-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            border: 2px solid var(--border-color);
            transition: all 0.2s;
        }

        .branch-card:hover {
            border-color: var(--primary-blue);
            transform: translateY(-3px);
            box-shadow: var(--shadow-sm);
        }

        .branch-count {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-blue);
            margin-bottom: 5px;
        }

        .branch-label {
            font-size: 0.9rem;
            color: var(--medium-gray);
            font-weight: 600;
        }

		/* Sidebar Toggle Button Styling */
.mobile-menu-toggle {
    display: none; /* Desktop par hide rahega */
}

@media (max-width: 992px) {
    .mobile-menu-toggle {
        display: flex !important; /* Mobile par dikhega */
        position: fixed;
        top: 15px;
        right: 15px;
        z-index: 4000; /* Sidebar (3000) se upar rahega */
        background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
        color: white;
        border: none;
        width: 45px;
        height: 45px;
        border-radius: 12px;
        align-items: center;
        justify-content: center;
        box-shadow: 0 4px 15px rgba(0, 102, 204, 0.3);
        cursor: pointer;
    }
}
        
    </style>
</head>
<body>

    <jsp:include page="includes/sidebar.jsp" />

	<!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
    <i class="fas fa-bars"></i>
</button> -->

    <div class="main-content">
        <!-- Header -->
        <div class="top-nav animate__animated animate__fadeInDown">
            <div class="page-title">
                <h1>Reports &amp; Analytics</h1>
                <p>Detailed insights into examination seating and resource utilization</p>
            </div>
            <div class="header-actions">
                <div class="date-display">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <%= currentDate %>
                </div>
                <button onclick="exportReport()" class="btn-primary-custom">
                    <i class="fas fa-file-pdf me-2"></i> Export Report
                </button>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="stats-grid animate__animated animate__fadeInUp">
            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(0,102,204,0.1); color: var(--primary-blue);">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <div class="stat-info">
                    <h3><%= totalAllocated %></h3>
                    <p>Total Students Allocated</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-arrow-up"></i>
                        <span>+12% from last exam</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(0,168,107,0.1); color: var(--success-green);">
                    <i class="fas fa-door-open"></i>
                </div>
                <div class="stat-info">
                    <h3><%= totalRoomsUsed %></h3>
                    <p>Examination Rooms Used</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-arrow-up"></i>
                        <span>+2 rooms</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(255,107,53,0.1); color: var(--warning-orange);">
                    <i class="fas fa-chair"></i>
                </div>
                <div class="stat-info">
                    <h3><%= avgUtilization %>%</h3>
                    <p>Average Utilization</p>
                    <div class="stat-trend <%= avgUtilization > 90 ? "trend-down" : "trend-up" %>">
                        <i class="fas <%= avgUtilization > 90 ? "fa-arrow-down" : "fa-arrow-up" %>"></i>
                        <span><%= avgUtilization > 90 ? "High load" : "Optimal" %></span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: rgba(0,180,179,0.1); color: var(--accent-teal);">
                    <i class="fas fa-building"></i>
                </div>
                <div class="stat-info">
                    <h3><%= totalCapacity %></h3>
                    <p>Total Seating Capacity</p>
                    <div class="stat-trend trend-up">
                        <i class="fas fa-check-circle"></i>
                        <span><%= vacantSeats %> seats available</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Report Tabs -->
        <div class="report-tabs animate__animated animate__fadeInUp" style="animation-delay: 0.1s;">
            <div class="report-tab active" onclick="showTab('overview')">Overview</div>
            <div class="report-tab" onclick="showTab('branches')">Branch Analysis</div>
            <div class="report-tab" onclick="showTab('rooms')">Room Details</div>
        </div>

        <!-- Tab Content: Overview -->
        <div id="overviewTab" class="tab-content active">
            <div class="row g-4 animate__animated animate__fadeInUp" style="animation-delay: 0.2s;">
                <div class="col-lg-7">
                    <div class="report-card">
                        <h5 class="section-title">
                            <i class="fas fa-chart-bar me-2"></i>Student Distribution by Branch
                        </h5>
                        <div class="chart-container">
                            <canvas id="branchChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="report-card">
                        <h5 class="section-title">
                            <i class="fas fa-chart-pie me-2"></i>Seat Utilization Overview
                        </h5>
                        <div class="chart-container">
                            <canvas id="utilizationChart"></canvas>
                        </div>
                        <div class="mt-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="small text-muted">Allocated Seats</span>
                                <span class="fw-bold text-primary"><%= totalAllocatedSeats %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="small text-muted">Available Seats</span>
                                <span class="fw-bold text-success"><%= vacantSeats %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tab Content: Branch Analysis -->
        <div id="branchesTab" class="tab-content d-none">
            <div class="report-card animate__animated animate__fadeInUp">
                <h5 class="section-title">
                    <i class="fas fa-code-branch me-2"></i>Branch-wise Student Allocation
                </h5>
                <div class="branch-cards">
                    <% 
                    int maxCount = 0;
                    for(Integer count : branchStats.values()) {
                        if(count > maxCount) maxCount = count;
                    }
                    
                    for(Map.Entry<String, Integer> entry : branchStats.entrySet()) { 
                        String branch = entry.getKey();
                        int count = entry.getValue();
                        int percentage = maxCount > 0 ? (count * 100 / maxCount) : 0;
                    %>
                    <div class="branch-card">
                        <div class="branch-count"><%= count %></div>
                        <div class="branch-label"><%= branch %></div>
                        <div class="utilization-bar mt-2">
                            <div class="utilization-fill bg-primary" style="width: <%= percentage %>%"></div>
                        </div>
                        <div class="small text-muted mt-1"><%= percentage %>% of max</div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Tab Content: Room Details -->
        <div id="roomsTab" class="tab-content d-none">
            <div class="table-container animate__animated animate__fadeInUp">
                <h5 class="section-title">
                    <i class="fas fa-table me-2"></i>Room-wise Utilization Analysis
                </h5>
                <div class="table-responsive">
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Room No.</th>
                                <th>Block</th>
                                <th>Capacity</th>
                                <th>Allocated</th>
                                <th>Utilization</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(roomDetails != null && !roomDetails.isEmpty()) { 
                                for(Map<String, Object> room : roomDetails) { 
                                    Object utilObj = room.get("utilization");
                                    Object capObj = room.get("capacity");
                                    Object allocObj = room.get("allocated");
                                    
                                    long utilVal = 0;
                                    int capacity = 0;
                                    int allocated = 0;
                                    
                                    if(utilObj instanceof Long) utilVal = (Long)utilObj;
                                    else if(utilObj instanceof Integer) utilVal = (Integer)utilObj;
                                    
                                    if(capObj instanceof Integer) capacity = (Integer)capObj;
                                    else if(capObj instanceof String) capacity = Integer.parseInt(capObj.toString());
                                    
                                    if(allocObj instanceof Integer) allocated = (Integer)allocObj;
                                    else if(allocObj instanceof String) allocated = Integer.parseInt(allocObj.toString());
                                    
                                    String block = room.get("block") != null ? room.get("block").toString() : "N/A";
                                    String roomNo = room.get("roomNo") != null ? room.get("roomNo").toString() : "N/A";
                                    
                                    String statusClass = "status-optimal";
                                    String statusText = "Optimal";
                                    String fillClass = "bg-success";
                                    
                                    if(utilVal > 90) {
                                        statusClass = "status-critical";
                                        statusText = "Critical";
                                        fillClass = "bg-danger";
                                    } else if(utilVal > 75) {
                                        statusClass = "status-warning";
                                        statusText = "High";
                                        fillClass = "bg-warning";
                                    }
                            %>
                            <tr>
                                <td><strong><%= roomNo %></strong></td>
                                <td><%= block %></td>
                                <td><%= capacity %></td>
                                <td><%= allocated %></td>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="utilization-bar" style="flex: 1;">
                                            <div class="utilization-fill <%= fillClass %>" style="width: <%= utilVal %>%"></div>
                                        </div>
                                        <div style="min-width: 40px; text-align: right;">
                                            <span class="fw-bold"><%= utilVal %>%</span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= statusText %>
                                    </span>
                                </td>
                            </tr>
                            <% } 
                            } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    <i class="fas fa-info-circle me-2"></i>
                                    No room utilization data available
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Tab switching functionality
        function showTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
                tab.classList.add('d-none');
            });
            
            // Remove active class from all tab buttons
            document.querySelectorAll('.report-tab').forEach(btn => {
                btn.classList.remove('active');
            });
            
            // Show selected tab
            document.getElementById(tabName + 'Tab').classList.remove('d-none');
            document.getElementById(tabName + 'Tab').classList.add('active');
            
            // Activate selected tab button
            event.target.classList.add('active');
        }

        // Export report function
        function exportReport() {
            const button = event.target.closest('.btn-primary-custom');
            const originalHTML = button.innerHTML;
            
            button.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Generating PDF...';
            button.disabled = true;
            
            setTimeout(() => {
                alert('Report exported successfully!');
                button.innerHTML = originalHTML;
                button.disabled = false;
            }, 1500);
        }

        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // 1. Branch Chart
            const branchCtx = document.getElementById('branchChart').getContext('2d');
            const branchLabels = [];
            const branchData = [];
            
            <% 
            List<String> sortedBranches = new ArrayList<>(branchStats.keySet());
            Collections.sort(sortedBranches);
            for(String branch : sortedBranches) { 
            %>
                branchLabels.push('<%= branch %>');
                branchData.push(<%= branchStats.get(branch) %>);
            <% } %>
            
            new Chart(branchCtx, {
                type: 'bar',
                data: {
                    labels: branchLabels,
                    datasets: [{
                        label: 'Number of Students',
                        data: branchData,
                        backgroundColor: [
                            'rgba(0, 102, 204, 0.8)',
                            'rgba(0, 168, 107, 0.8)',
                            'rgba(255, 107, 53, 0.8)',
                            'rgba(0, 180, 179, 0.8)',
                            'rgba(99, 102, 241, 0.8)',
                            'rgba(139, 92, 246, 0.8)',
                            'rgba(236, 72, 153, 0.8)',
                            'rgba(245, 158, 11, 0.8)'
                        ],
                        borderColor: [
                            'rgba(0, 102, 204, 1)',
                            'rgba(0, 168, 107, 1)',
                            'rgba(255, 107, 53, 1)',
                            'rgba(0, 180, 179, 1)',
                            'rgba(99, 102, 241, 1)',
                            'rgba(139, 92, 246, 1)',
                            'rgba(236, 72, 153, 1)',
                            'rgba(245, 158, 11, 1)'
                        ],
                        borderWidth: 1,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleFont: { size: 12 },
                            bodyFont: { size: 12 },
                            padding: 12,
                            cornerRadius: 6
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: {
                                color: 'rgba(0, 0, 0, 0.05)'
                            },
                            ticks: {
                                font: { size: 11 }
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                font: { size: 11 }
                            }
                        }
                    }
                }
            });

            // 2. Utilization Chart
            const utilCtx = document.getElementById('utilizationChart').getContext('2d');
            const allocated = <%= totalAllocatedSeats %>;
            const vacant = <%= vacantSeats %>;
            
            new Chart(utilCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Allocated Seats', 'Available Seats'],
                    datasets: [{
                        data: [allocated, vacant],
                        backgroundColor: [
                            'rgba(0, 102, 204, 0.9)',
                            'rgba(230, 242, 255, 0.9)'
                        ],
                        borderColor: [
                            'rgba(0, 102, 204, 1)',
                            'rgba(0, 102, 204, 0.5)'
                        ],
                        borderWidth: 1,
                        hoverOffset: 15
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                padding: 20,
                                font: { size: 12 },
                                usePointStyle: true
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.raw || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = Math.round((value * 100) / total);
                                    return `${label}: ${value} seats (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });

            // Animate utilization bars
            setTimeout(() => {
                document.querySelectorAll('.utilization-fill').forEach(fill => {
                    const width = fill.style.width;
                    fill.style.width = '0%';
                    setTimeout(() => {
                        fill.style.width = width;
                    }, 100);
                });
            }, 500);
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>