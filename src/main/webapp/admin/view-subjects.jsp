<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*, com.smartseat.model.Subject, com.smartseat.dao.SubjectDAO" %>
<%
    if(session.getAttribute("adminUser") == null) { 
        response.sendRedirect("../home?error=Please Login First"); 
        return; 
    }
    
    String adminName = (String) session.getAttribute("adminName");
    String adminRole = (String) session.getAttribute("adminRole");
    
    SubjectDAO dao = new SubjectDAO();
    List<Subject> subjects = dao.getAllSubjects();
    
    java.util.Date today = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
    String currentDate = sdf.format(today);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Subjects | Smart-Seat Admin Dashboard</title>
    
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

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
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

        @media (max-width: 768px) {
            .top-nav {
                padding: 15px 20px;
                flex-direction: column;
                gap: 15px;
            }
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
        .stats-container {
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
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            font-size: 20px;
        }

        .stat-icon.total {
            background: rgba(0, 102, 204, 0.1);
            color: var(--primary-blue);
        }

        .stat-icon.semester {
            background: rgba(0, 180, 179, 0.1);
            color: var(--accent-teal);
        }

        .stat-icon.branch {
            background: rgba(255, 107, 53, 0.1);
            color: var(--warning-orange);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            color: var(--dark-gray);
            line-height: 1;
            margin-bottom: 5px;
        }

        .stat-label {
            color: var(--medium-gray);
            font-size: 14px;
            font-weight: 500;
        }

        /* Table Card */
        .table-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .table-card {
                padding: 20px;
            }
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .search-box-container {
            position: relative;
            max-width: 300px;
        }

        .search-box {
            background: var(--light-gray);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 12px 45px 12px 20px;
            font-size: 14px;
            width: 100%;
            transition: all 0.3s ease;
        }

        .search-box:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
            font-size: 14px;
        }

        /* Table Styles */
        .table {
            margin-bottom: 0;
        }

        .table thead th {
            border-bottom: 2px solid var(--border-color);
            color: var(--medium-gray);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 15px 12px;
        }

        .table tbody td {
            padding: 18px 12px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border-color);
        }

        .table tbody tr {
            transition: all 0.2s ease;
        }

        .table tbody tr:hover {
            background: var(--light-gray);
            transform: scale(1.002);
        }

        /* Badges */
        .badge-custom {
            background: var(--primary-light);
            color: var(--primary-blue);
            border: 1px solid rgba(0, 102, 204, 0.2);
            border-radius: 8px;
            padding: 6px 12px;
            font-weight: 600;
            font-size: 12px;
            letter-spacing: 0.3px;
        }

        .badge-semester {
            background: rgba(0, 180, 179, 0.1);
            color: var(--accent-teal);
            border-color: rgba(0, 180, 179, 0.2);
        }

        .badge-branch {
            background: rgba(255, 107, 53, 0.1);
            color: var(--warning-orange);
            border-color: rgba(255, 107, 53, 0.2);
        }

        /* Action Buttons */
        .btn-action {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
        }

        .btn-action.view {
            background: rgba(0, 102, 204, 0.1);
            color: var(--primary-blue);
        }

        .btn-action.view:hover {
            background: var(--primary-blue);
            color: white;
        }

        .btn-action.edit {
            background: rgba(0, 168, 107, 0.1);
            color: var(--success-green);
        }

        .btn-action.edit:hover {
            background: var(--success-green);
            color: white;
        }

        .btn-action.delete {
            background: rgba(229, 62, 62, 0.1);
            color: var(--error-red);
        }

        .btn-action.delete:hover {
            background: var(--error-red);
            color: white;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-icon {
            font-size: 48px;
            color: var(--border-color);
            margin-bottom: 20px;
        }

        .empty-state h4 {
            color: var(--medium-gray);
            margin-bottom: 10px;
            font-weight: 600;
        }

        .empty-state p {
            color: var(--medium-gray);
            margin-bottom: 25px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Alert Messages */
        .alert-custom {
            border-radius: 12px;
            padding: 20px;
            border: none;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            animation: slideInDown 0.5s ease;
            border-left: 4px solid;
        }

        .alert-custom.alert-success {
            background: rgba(0, 168, 107, 0.1);
            color: var(--success-green);
            border-left-color: var(--success-green);
        }

        .alert-custom.alert-danger {
            background: rgba(229, 62, 62, 0.1);
            color: var(--error-red);
            border-left-color: var(--error-red);
        }

        @keyframes slideInDown {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        
        @media (max-width: 992px) {
            .mobile-menu-toggle {
                display: flex;
            }
        }
    </style>
</head>
<body>

    <!-- Professional Sidebar -->
    <jsp:include page="includes/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Top Navigation Bar -->
        <div class="top-nav animate__animated animate__fadeInDown">
            <div class="page-title">
                <h1>Manage Subjects</h1>
                <p>View, search, and manage your college subject master list</p>
            </div>
            <div class="header-actions">
                <div class="date-display">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <%= currentDate %>
                </div>
                <a href="import-subjects.jsp" class="btn-primary-custom">
                    <i class="fas fa-plus"></i>
                    Import Subjects
                </a>
            </div>
        </div>

        <!-- Status Messages -->
        <%
            String message = request.getParameter("message");
            String error = request.getParameter("error");
            
            if(message != null && !message.isEmpty()) {
        %>
        <div class="alert-custom alert-success animate__animated animate__slideInDown">
            <i class="fas fa-check-circle"></i>
            <div>
                <strong>Success!</strong> <%= message %>
            </div>
        </div>
        <%
            } else if(error != null && !error.isEmpty()) {
        %>
        <div class="alert-custom alert-danger animate__animated animate__slideInDown">
            <i class="fas fa-exclamation-circle"></i>
            <div>
                <strong>Error!</strong> <%= error %>
            </div>
        </div>
        <%
            }
        %>

        <!-- Stats Cards -->
        <div class="stats-container animate__animated animate__fadeIn">
            <div class="stat-card">
                <div class="stat-icon total">
                    <i class="fas fa-book"></i>
                </div>
                <div class="stat-value"><%= subjects.size() %></div>
                <div class="stat-label">Total Subjects</div>
            </div>
            
            <%
                // Calculate unique semesters
                Set<Integer> uniqueSemesters = new HashSet<>();
                for(Subject s : subjects) {
                    uniqueSemesters.add(s.getSemester());
                }
            %>
            <div class="stat-card">
                <div class="stat-icon semester">
                    <i class="fas fa-layer-group"></i>
                </div>
                <div class="stat-value"><%= uniqueSemesters.size() %></div>
                <div class="stat-label">Active Semesters</div>
            </div>
            
            <%
                // Calculate unique branches
                Set<String> uniqueBranches = new HashSet<>();
                for(Subject s : subjects) {
                    uniqueBranches.add(s.getBranch());
                }
            %>
            <div class="stat-card">
                <div class="stat-icon branch">
                    <i class="fas fa-code-branch"></i>
                </div>
                <div class="stat-value"><%= uniqueBranches.size() %></div>
                <div class="stat-label">Different Branches</div>
            </div>
        </div>

        <!-- Table Card -->
        <div class="table-card animate__animated animate__fadeInUp">
            <div class="table-header">
                <div class="search-box-container">
                    <input type="text" id="subjectSearch" class="search-box" placeholder="Search subjects...">
                    <i class="fas fa-search search-icon"></i>
                </div>
                <div style="display: flex; align-items: center; gap: 15px;">
                    <span class="text-muted" style="font-size: 14px;">
                        Showing <strong id="visibleCount"><%= subjects.size() %></strong> of <%= subjects.size() %> subjects
                    </span>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table" id="subjectTable">
                    <thead>
                        <tr>
                            <th>Subject Code</th>
                            <th>Subject Name</th>
                            <th>Branch</th>
                            <th>Semester</th>
                            <th>Academic Year</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(!subjects.isEmpty()) { 
                            for(Subject s : subjects) { 
                        %>
                        <tr data-subject-code="<%= s.getSubjectCode() %>">
                            <td>
                                <span class="badge-custom">
                                    <%= s.getSubjectCode() %>
                                </span>
                            </td>
                            <td>
                                <div class="fw-medium"><%= s.getSubjectName() %></div>
                            </td>
                            <td>
                                <span class="badge badge-branch">
                                    <%= s.getBranch() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge badge-semester">
                                    Sem <%= s.getSemester() %>
                                </span>
                            </td>
                            <td>
                                <span class="text-muted" style="font-size: 13px;">
                                    <%= s.getAcademicYear() %>
                                </span>
                            </td>
                            <td class="text-center">
                                <div class="d-flex justify-content-center gap-2">
                                    <button class="btn-action view" title="View Details" onclick="viewSubject('<%= s.getSubjectCode() %>')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button class="btn-action edit" title="Edit Subject" onclick="editSubject('<%= s.getSubjectCode() %>')">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="btn-action delete" title="Delete Subject" onclick="confirmDelete('<%= s.getSubjectCode() %>', '<%= s.getSubjectName() %>')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="6">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-book-open"></i>
                                    </div>
                                    <h4>No Subjects Found</h4>
                                    <p>Get started by importing subjects using the CSV template</p>
                                    <a href="import-subjects.jsp" class="btn-primary-custom">
                                        <i class="fas fa-plus me-2"></i>
                                        Import Subjects
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
       

        // Search functionality
        document.getElementById('subjectSearch').addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('#subjectTable tbody tr:not([style*="display: none"])');
            let visibleCount = 0;
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                const subjectCode = row.getAttribute('data-subject-code')?.toLowerCase() || '';
                
                if (text.includes(searchTerm) || subjectCode.includes(searchTerm)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            document.getElementById('visibleCount').textContent = visibleCount;
        });

        // Action functions
        function viewSubject(subjectCode) {
            // Implement view functionality
            console.log('View subject:', subjectCode);
            alert(`View details for subject: \${subjectCode}\nThis would open a modal with detailed information.`);
        }

        function editSubject(subjectCode) {
            // Implement edit functionality
            console.log('Edit subject:', subjectCode);
            alert(`Edit subject: \${subjectCode}\nThis would open an edit form.`);
        }

        function confirmDelete(subjectCode, subjectName) {
            if (confirm(`Are you sure you want to delete "\${subjectName}" (\${subjectCode})?\n\nThis action cannot be undone.`)) {
                // Implement delete functionality
                console.log('Delete subject:', subjectCode);
                alert(`Subject "\${subjectName}" deleted successfully.\nIn a real implementation, this would make an API call.`);
                
                // In real implementation, you would submit a form or make an AJAX call
               
            }
        }

        // Highlight table rows on hover (added for better UX)
        document.querySelectorAll('#subjectTable tbody tr').forEach(row => {
            row.addEventListener('mouseenter', function() {
                this.style.transition = 'all 0.2s ease';
            });
        });
    </script>
</body>
</html>