<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.smartseat.dao.TeacherDAO, com.smartseat.model.Teacher, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Management | Smart-Seat</title>
    
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
            --error-red: #E53E3E;
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

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f5f9ff 0%, #ffffff 100%);
            color: var(--text-primary);
            min-height: 100vh;
            overflow-x: hidden;
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

        /* Header Section */
        .page-header {
            background: linear-gradient(135deg, #ffffff 0%, #f8fbff 100%);
            padding: 40px 40px 30px;
            border-bottom: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, rgba(0, 102, 204, 0.05) 0%, transparent 100%);
            border-radius: 50%;
            transform: translate(30%, -30%);
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .page-title {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            font-weight: 500;
            max-width: 600px;
            line-height: 1.6;
        }

        .stats-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 25px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            min-width: 200px;
        }

        .stats-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-light), white);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
            color: var(--primary-blue);
            font-size: 1.5rem;
        }

        .stats-count {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--primary-dark);
            line-height: 1;
            margin-bottom: 5px;
        }

        .stats-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Main Content Container */
        .content-container {
            padding: 30px 40px;
        }

        /* Add Teacher Card */
        .add-teacher-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 35px;
            margin-bottom: 30px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            position: relative;
            overflow: hidden;
        }

        .add-teacher-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 6px;
            height: 100%;
            background: linear-gradient(180deg, var(--primary-blue), var(--accent-teal));
        }

        .card-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .card-title i {
            color: var(--primary-blue);
            font-size: 1.3rem;
        }

        /* Form Styles */
        .form-group-custom {
            margin-bottom: 25px;
        }

        .form-label-custom {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label-custom i {
            color: var(--primary-blue);
            font-size: 0.9rem;
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
            transform: translateY(-2px);
        }

        .input-group-text-custom {
            background: linear-gradient(135deg, var(--primary-light), #f1f9ff);
            border: none;
            color: var(--primary-blue);
            font-weight: 600;
            min-width: 50px;
            justify-content: center;
            padding: 16px 20px;
        }

        .form-control-custom,
        .form-select-custom {
            border: none;
            background: white;
            padding: 16px 20px;
            font-size: 1rem;
            color: var(--text-primary);
            height: auto;
        }

        .form-control-custom:focus,
        .form-select-custom:focus {
            box-shadow: none;
            background: white;
        }

        /* Submit Button */
        .btn-submit {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: var(--radius-md);
            padding: 16px 35px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            box-shadow: var(--shadow-sm);
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            color: white;
            background: linear-gradient(135deg, var(--primary-dark), #002244);
        }

        /* Teacher Table Card */
        .teacher-table-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 35px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
        }

        /* Table Styles */
        .modern-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .modern-table thead {
            background: linear-gradient(135deg, var(--primary-light), #f0f7ff);
        }

        .modern-table th {
            padding: 20px;
            text-align: left;
            font-weight: 700;
            color: var(--primary-dark);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid var(--border-color);
            position: relative;
        }

        .modern-table th::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary-blue);
            transition: width 0.3s ease;
        }

        .modern-table th:hover::after {
            width: 100%;
        }

        .modern-table tbody tr {
            transition: all 0.3s ease;
            border-bottom: 1px solid var(--border-color);
        }

        .modern-table tbody tr:hover {
            background: rgba(0, 102, 204, 0.02);
            transform: translateX(5px);
        }

        .modern-table td {
            padding: 20px;
            vertical-align: middle;
            color: var(--text-secondary);
            border-bottom: 1px solid var(--border-color);
        }

        .teacher-id {
            font-weight: 700;
            color: var(--primary-blue);
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .teacher-name {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 1.05rem;
        }

        /* Department Badge */
        .dept-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .dept-cs { background: #dbeafe; color: #1e40af; }
        .dept-it { background: #f0f9ff; color: #0369a1; }
        .dept-ec { background: #fef3c7; color: #92400e; }
        .dept-me { background: #fce7f3; color: #be185d; }
        .dept-ce { background: #dcfce7; color: #166534; }

        /* Contact Info */
        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
        }

        .contact-item i {
            width: 20px;
            color: var(--text-secondary);
            opacity: 0.7;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-action {
            width: 40px;
            height: 40px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-sm);
        }

        .btn-edit {
            background: linear-gradient(135deg, #ebf8ff, #d1e9ff);
            color: #3182ce;
        }

        .btn-delete {
            background: linear-gradient(135deg, #fff5f5, #fed7d7);
            color: #e53e3e;
        }

        .btn-action:hover {
            transform: translateY(-3px) scale(1.1);
            box-shadow: var(--shadow-md);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, var(--primary-light), white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: var(--primary-blue);
            font-size: 2rem;
        }

        .empty-state-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 10px;
        }

        .empty-state-text {
            color: var(--text-secondary);
            max-width: 400px;
            margin: 0 auto;
        }

        /* Animation Delays */
        .animate-delay-1 { animation-delay: 0.1s; }
        .animate-delay-2 { animation-delay: 0.2s; }
        .animate-delay-3 { animation-delay: 0.3s; }

        /* Responsive Design */
/* --- Optimized Responsive Design --- */

@media (max-width: 992px) {
    .main-content {
        margin-left: 0 !important;
        padding: 15px !important;
        margin-top: 60px; /* Mobile toggle ke liye space */ 
    }
    
    .page-title {
        font-size: 1.8rem !important; /* Mobile par title chota kiya */
        text-align: center;
    }

    .page-subtitle {
        text-align: center;
        font-size: 0.95rem;
    }

    .stats-card {
        margin-top: 20px;
        text-align: center;
    }
}

@media (max-width: 768px) {
    /* Main Content spacing */
    .content-container { padding: 15px !important; }

    /* Card Styling for each row */
    .modern-table, .modern-table tbody, .modern-table tr, .modern-table td {
        display: block;
        width: 100%;
    }

    .modern-table thead { display: none; } /* Desktop header hide karein */

    .modern-table tr {
        background: #1a1c23; /* Dark theme card background */
        margin-bottom: 20px;
        border-radius: 15px !important;
        padding: 15px;
        border: 1px solid rgba(255,255,255,0.1) !important;
        box-shadow: 0 10px 20px rgba(0,0,0,0.3) !important;
    }

    .modern-table td {
        border: none !important;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px 0 !important;
        border-bottom: 1px solid rgba(255,255,255,0.05) !important;
    }

    .modern-table td:last-child { border-bottom: none !important; margin-top: 10px; }

    /* Labels styling */
    .modern-table td::before {
        font-weight: 600;
        color: var(--text-secondary); [cite: 4]
        font-size: 0.85rem;
        text-transform: uppercase;
    }

    /* Assign Labels */
    .modern-table td:nth-of-type(1)::before { content: "ID"; } [cite: 99]
    .modern-table td:nth-of-type(2)::before { content: "Faculty"; } [cite: 100]
    .modern-table td:nth-of-type(3)::before { content: "Dept"; } [cite: 100]
    .modern-table td:nth-of-type(4)::before { content: "Contact"; } [cite: 101]
    .modern-table td:nth-of-type(5)::before { content: "Actions"; } [cite: 101]

    /* Action Buttons (Touch Friendly) */
    .action-buttons {
        gap: 15px !important;
        justify-content: flex-end;
    }

    .btn-action {
        width: 45px !important;
        height: 45px !important;
        font-size: 1.1rem;
    }
}
    </style>
</head>
<body>
    <!-- Sidebar -->
    <jsp:include page="includes/sidebar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header Section -->
        <div class="page-header animate__animated animate__fadeInDown">
            <div class="header-content">
                <div class="row align-items-center">
                    <div class="col-lg-8 mb-4 mb-lg-0">
                        <h1 class="page-title">Faculty Management</h1>
                        <p class="page-subtitle">
                            Add, edit, and manage faculty members for examination duties and invigilation assignments.
                        </p>
                    </div>
                    <div class="col-lg-4">
                        <div class="stats-card animate__animated animate__fadeInRight">
                            <div class="stats-icon">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <% TeacherDAO countDao = new TeacherDAO(); %>
                            <div class="stats-count"><%= countDao.getAllTeachers().size() %></div>
                            <div class="stats-label">Total Faculty Members</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

<% if("updated".equals(request.getParameter("msg"))) { %>
    <div class="alert alert-success alert-dismissible fade show mx-4 mt-3" role="alert">
        <strong>Success!</strong> Faculty details have been updated.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

<% 
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
    
    if("deleted".equals(msg)) { 
%>
    <div class="alert alert-danger alert-dismissible fade show mx-4 mt-3" role="alert">
        <i class="fas fa-trash-alt me-2"></i> Faculty member has been removed.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } else if("delete_failed".equals(error)) { %>
    <div class="alert alert-warning alert-dismissible fade show mx-4 mt-3" role="alert">
        <strong>Error!</strong> Could not delete the faculty member.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
<% } %>

        <!-- Main Content Area -->
        <div class="content-container">
            <!-- Add Teacher Form -->
            <div class="add-teacher-card animate__animated animate__fadeInUp">
                <h3 class="card-title">
                    <i class="fas fa-user-plus"></i>
                    Register New Faculty Member
                </h3>
                
                <form action="${pageContext.request.contextPath}/AddTeacherServlet" method="post" class="row g-4">
    
    <div class="col-12 col-md-6 col-lg-4">
        <label class="form-label-custom">
            <i class="fas fa-user"></i> Full Name
        </label>
        <div class="input-group input-group-custom">
            <span class="input-group-text input-group-text-custom">
                <i class="fas fa-id-card"></i>
            </span>
            <input type="text" name="name" class="form-control form-control-custom" placeholder="e.g., Dr. Satish Gupta" required>
        </div>
    </div>

    <div class="col-12 col-md-6 col-lg-4">
        <label class="form-label-custom">
            <i class="fas fa-building"></i> Department
        </label>
        <div class="input-group input-group-custom">
            <span class="input-group-text input-group-text-custom">
                <i class="fas fa-university"></i>
            </span>
            <select name="department" class="form-select form-select-custom" required>
                <option value="">Select Department</option>
                <option value="CS">Computer Science</option>
                <option value="IT">Information Technology</option>
                <option value="EC">Electronics & Communication</option>
                <option value="ME">Mechanical Engineering</option>
                <option value="CE">Civil Engineering</option>
            </select>
        </div>
    </div>

    <div class="col-12 col-md-6 col-lg-4">
        <label class="form-label-custom">
            <i class="fas fa-envelope"></i> Email Address
        </label>
        <div class="input-group input-group-custom">
            <span class="input-group-text input-group-text-custom">@</span>
            <input type="email" name="email" class="form-control form-control-custom" placeholder="faculty@ipsacademy.org">
        </div>
    </div>

    <div class="col-12 col-md-6 col-lg-4">
        <label class="form-label-custom">
            <i class="fas fa-phone"></i> Phone Number
        </label>
        <div class="input-group input-group-custom">
            <span class="input-group-text input-group-text-custom">
                <i class="fas fa-mobile-alt"></i>
            </span>
            <input type="text" name="phone" class="form-control form-control-custom" placeholder="+91 98765 43210">
        </div>
    </div>

    <div class="col-12 mt-4 text-center text-md-end">
        <button type="submit" class="btn btn-submit w-100 w-md-auto">
            <i class="fas fa-user-plus"></i> Add Faculty Member
        </button>
    </div>
</form>
            </div>

            <!-- Faculty Directory -->
            <div class="teacher-table-card animate__animated animate__fadeInUp animate-delay-1">
                <h3 class="card-title mb-4">
                    <i class="fas fa-users"></i>
                    Faculty Directory
                </h3>

                <div class="table-responsive">
                    <table class="modern-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Faculty Name</th>
                                <th>Department</th>
                                <th>Contact Information</th>
                                <th style="width: 100px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                TeacherDAO dao = new TeacherDAO();
                                List<Teacher> teachers = dao.getAllTeachers();
                                
                                if(teachers.isEmpty()) {
                            %>
                            <tr>
                                <td colspan="5">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">
                                            <i class="fas fa-users-slash"></i>
                                        </div>
                                        <h4 class="empty-state-title">No Faculty Members Found</h4>
                                        <p class="empty-state-text">
                                            Start by adding faculty members using the form above.
                                        </p>
                                    </div>
                                </td>
                            </tr>
                            <% } else {
                                for(Teacher t : teachers) {
                                    String deptClass = "";
                                    switch(t.getDepartment()) {
                                        case "CS": deptClass = "dept-cs"; break;
                                        case "IT": deptClass = "dept-it"; break;
                                        case "EC": deptClass = "dept-ec"; break;
                                        case "ME": deptClass = "dept-me"; break;
                                        case "CE": deptClass = "dept-ce"; break;
                                        default: deptClass = "dept-cs";
                                    }
                            %>
                            <tr class="animate__animated animate__fadeIn">
                                <td>
                                    <div class="teacher-id">#<%= t.getId() %></div>
                                </td>
                                <td>
                                    <div class="teacher-name"><%= t.getName() %></div>
                                </td>
                                <td>
                                    <span class="dept-badge <%= deptClass %>">
                                        <i class="fas fa-building"></i>
                                        <%= t.getDepartment() %>
                                    </span>
                                </td>
                                <td>
                                    <div class="contact-info">
                                        <div class="contact-item">
                                            <i class="fas fa-envelope"></i>
                                            <span><%= t.getEmail() %></span>
                                        </div>
                                        <div class="contact-item">
                                            <i class="fas fa-phone"></i>
                                            <span><%= t.getPhone() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="action-buttons">
										<a href="javascript:void(0)"
											onclick="openEditModal('<%=t.getId()%>', '<%=t.getName()%>', '<%=t.getDepartment()%>', '<%=t.getEmail()%>', '<%=t.getPhone()%>')"
											class="btn-action btn-edit" title="Edit"> <i
											class="fas fa-pen"></i>
										</a> <a href="../DeleteTeacherServlet?id=<%= t.getId() %>" 
                                           class="btn-action btn-delete" 
                                           title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this faculty member? This action cannot be undone.')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

<!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button> -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    
 // Function to open Modal and populate data
    function openEditModal(id, name, dept, email, phone) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-dept').value = dept;
        document.getElementById('edit-email').value = email;
        document.getElementById('edit-phone').value = phone;
        
        var myModal = new bootstrap.Modal(document.getElementById('editTeacherModal'));
        myModal.show();
    }
        document.addEventListener('DOMContentLoaded', function() {
            // Add hover effects to table rows
            const tableRows = document.querySelectorAll('.modern-table tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateX(5px)';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateX(0)';
                });
            });
            
            // Form validation
            const form = document.querySelector('form');
            if (form) {
                form.addEventListener('submit', function(e) {
                    const nameInput = this.querySelector('input[name="name"]');
                    const deptSelect = this.querySelector('select[name="department"]');
                    
                    if (!nameInput.value.trim()) {
                        e.preventDefault();
                        showError(nameInput, 'Please enter faculty name');
                        return;
                    }
                    
                    if (!deptSelect.value) {
                        e.preventDefault();
                        showError(deptSelect, 'Please select department');
                        return;
                    }
                });
                
                function showError(element, message) {
                    // Remove any existing error
                    const existingError = element.parentElement.querySelector('.error-message');
                    if (existingError) existingError.remove();
                    
                    // Add error styling
                    element.parentElement.classList.add('error');
                    
                    // Create error message
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'error-message text-danger mt-2 small';
                    errorDiv.innerHTML = `<i class="fas fa-exclamation-circle me-1"></i>${message}`;
                    
                    element.parentElement.appendChild(errorDiv);
                    
                    // Remove error after 3 seconds
                    setTimeout(() => {
                        element.parentElement.classList.remove('error');
                        errorDiv.remove();
                    }, 3000);
                }
            }
            
            // Add smooth animations
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

            // Observe all table rows
            tableRows.forEach(row => observer.observe(row));
        });
    </script>
    <div class="modal fade" id="editTeacherModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px;">
            <div class="modal-header bg-primary text-white" style="border-radius: 20px 20px 0 0;">
                <h5 class="modal-title"><i class="fas fa-user-edit me-2"></i>Edit Faculty Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/UpdateTeacherServlet" method="post">
                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Full Name</label>
                        <input type="text" name="name" id="edit-name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Department</label>
                        <select name="department" id="edit-dept" class="form-select" required>
                            <option value="CS">Computer Science</option>  
                            <option value="IT">Information Technology</option> 
                            <option value="EC">Electronics & Communication</option> 
                            <option value="ME">Mechanical Engineering</option> 
                            <option value="CE">Civil Engineering</option> 
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Email Address</label>
                        <input type="email" name="email" id="edit-email" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Phone Number</label>
                        <input type="text" name="phone" id="edit-phone" class="form-control">
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>