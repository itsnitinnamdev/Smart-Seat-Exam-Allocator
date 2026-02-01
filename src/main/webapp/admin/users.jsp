<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.smartseat.util.DBConnection" %>
<%@ page import="java.util.*" %>
<%
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../index.jsp?error=Login First");
    }
    
    String currDate = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy").format(new java.util.Date());
    String name = (String) session.getAttribute("adminName");
    
    // Default colors for different roles
    Map<String, String> roleColors = new HashMap<>();
    roleColors.put("System Admin", "bg-danger bg-opacity-10 text-danger");
    roleColors.put("Admin", "bg-primary bg-opacity-10 text-primary");
    roleColors.put("Staff", "bg-success bg-opacity-10 text-success");
    roleColors.put("Faculty", "bg-info bg-opacity-10 text-info");
    roleColors.put("Viewer", "bg-secondary bg-opacity-10 text-secondary");
    
    // Default status colors
    Map<String, String> statusColors = new HashMap<>();
    statusColors.put("Active", "bg-success bg-opacity-10 text-success");
    statusColors.put("Inactive", "bg-secondary bg-opacity-10 text-secondary");
    statusColors.put("Suspended", "bg-danger bg-opacity-10 text-danger");
    statusColors.put("Pending", "bg-warning bg-opacity-10 text-warning");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management | Smart-Seat IPS Academy</title>
    
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

        /* User Management Container */
        .user-management-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
        }

        /* Section Header */
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--primary-light);
        }

        .section-title {
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--primary-dark);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: var(--primary-blue);
        }

        /* Search and Filter */
        .search-filter-container {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }

        .search-input {
            width: 100%;
            padding: 12px 45px 12px 20px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.2s;
        }

        .search-input:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            outline: none;
        }

        .search-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 10px 20px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            background: white;
            color: var(--medium-gray);
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .filter-btn:hover {
            border-color: var(--primary-blue);
            color: var(--primary-blue);
        }

        .filter-btn.active {
            background: var(--primary-blue);
            color: white;
            border-color: var(--primary-blue);
        }

        /* User Stats */
        .user-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--primary-light);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-blue);
            font-size: 20px;
        }

        .stat-info h3 {
            font-weight: 700;
            font-size: 1.8rem;
            color: var(--primary-dark);
            margin: 0;
        }

        .stat-info p {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin: 0;
        }

        /* User Table */
        .user-table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid var(--border-color);
        }

        .user-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        .user-table thead th {
            background: var(--primary-light);
            color: var(--primary-blue);
            font-weight: 600;
            font-size: 0.9rem;
            padding: 18px 20px;
            border-bottom: 2px solid var(--border-color);
            text-align: left;
        }

        .user-table tbody td {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .user-table tbody tr:hover {
            background: var(--light-gray);
        }

        .user-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* User Avatar */
        .user-avatar {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-teal));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
        }

        /* Status Badge */
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .action-btn:hover {
            transform: translateY(-2px);
        }

        .btn-edit {
            background: rgba(0, 102, 204, 0.1);
            color: var(--primary-blue);
        }

        .btn-edit:hover {
            background: var(--primary-blue);
            color: white;
        }

        .btn-delete {
            background: rgba(239, 68, 68, 0.1);
            color: var(--error-red);
        }

        .btn-delete:hover {
            background: var(--error-red);
            color: white;
        }

        .btn-reset {
            background: rgba(0, 168, 107, 0.1);
            color: var(--success-green);
        }

        .btn-reset:hover {
            background: var(--success-green);
            color: white;
        }

        /* Modal Customization */
        .modal-content {
            border-radius: 20px;
            border: none;
            box-shadow: var(--shadow-lg);
        }

        .modal-header {
            border-bottom: 2px solid var(--primary-light);
            padding: 25px 30px;
        }

        .modal-title {
            font-weight: 700;
            color: var(--primary-dark);
        }

        .modal-body {
            padding: 30px;
        }

        .modal-footer {
            border-top: 2px solid var(--primary-light);
            padding: 20px 30px;
        }

        .form-label {
            font-weight: 600;
            color: var(--primary-dark);
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .form-control-custom {
            border: 2px solid var(--border-color);
            border-radius: 10px;
            padding: 12px 15px;
            font-size: 0.95rem;
            transition: all 0.2s;
            width: 100%;
        }

        .form-control-custom:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            outline: none;
        }

        /* Role Tag */
        .role-tag {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
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
                <h1>User Management</h1>
                <p>Manage administrative and staff accounts for Smart-Seat system</p>
            </div>
            <div class="header-actions">
                <div class="date-display">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <%= currDate %>
                </div>
                <button class="btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="fas fa-plus-circle me-2"></i> Add New User
                </button>
            </div>
        </div>

        <!-- User Stats -->
        <%
    // Servlet se aayi list catch karein
    List<Map<String, String>> usersData = (List<Map<String, String>>) request.getAttribute("userList");
    
    int totalUsers = 0;
    int adminCount = 0;
    int staffCount = 0;
    int activeCount = 0;

    if(usersData != null) {
        totalUsers = usersData.size(); 
        for(Map<String, String> u : usersData) {
            String role = u.get("role");
            String status = u.get("status");

            if("System Admin".equals(role)) adminCount++;
            if("Staff".equals(role)) staffCount++;
            if("Active".equals(status)) activeCount++;
        }
    }
%>

<div class="user-stats animate__animated animate__fadeInUp">
    <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-users"></i></div>
        <div class="stat-info">
            <h3><%= totalUsers %></h3> <p>Total Users</p>
        </div>
    </div>
    
    <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-user-shield"></i></div>
        <div class="stat-info">
            <h3><%= adminCount %></h3> <p>System Admins</p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-user-tie"></i></div>
        <div class="stat-info">
            <h3><%= staffCount %></h3> <p>Staff Members</p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon"><i class="fas fa-user-check"></i></div>
        <div class="stat-info">
            <h3><%= activeCount %></h3> <p>Active Users</p>
        </div>
    </div>
</div>

        <!-- User Management Container -->
        <div class="user-management-container animate__animated animate__fadeInUp" style="animation-delay: 0.1s;">
            <!-- Section Header -->
            <div class="section-header">
                <div class="section-title">
                    <i class="fas fa-user-cog"></i>
                    System Users
                </div>
                <div class="text-muted small">
                    Last updated: Just now
                </div>
            </div>

            <!-- Search and Filter -->
            <div class="search-filter-container">
                <div class="search-box">
                    <input type="text" class="search-input" placeholder="Search users by name, username, or role...">
                    <i class="fas fa-search search-icon"></i>
                </div>
                
                <div class="filter-buttons">
                    <button class="filter-btn active">All Users</button>
                    <button class="filter-btn">Active</button>
                    <button class="filter-btn">Admins</button>
                    <button class="filter-btn">Staff</button>
                    <button class="filter-btn">Inactive</button>
                </div>
            </div>

            <!-- User Table -->
            <div class="user-table-container">
                <table class="user-table">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Username</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Map<String, String>> users = (List<Map<String, String>>) request.getAttribute("userList");
                            if(users != null && !users.isEmpty()) {
                                for(Map<String, String> user : users) {
                                    String userName = user.get("name") != null ? user.get("name") : "Unknown User";
                                    String username = user.get("username") != null ? user.get("username") : "N/A";
                                    String role = user.get("role") != null ? user.get("role") : "Staff";
                                    String status = user.get("status") != null ? user.get("status") : "Active";
                                    String lastLogin = user.get("last_login") != null ? user.get("last_login") : "Never";
                                    String createdAt = user.get("created_at") != null ? user.get("created_at") : "N/A";
                                    
                                    // Get colors for role and status
                                    String roleColorClass = roleColors.getOrDefault(role, "bg-secondary bg-opacity-10 text-secondary");
                                    String statusColorClass = statusColors.getOrDefault(status, "bg-success bg-opacity-10 text-success");
                        %>
                        <tr>
                            <td data-label="User">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="user-avatar">
                                        <%= userName.charAt(0) %>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="font-size: 0.95rem;"><%= userName %></div>
                                        <div class="text-muted small" style="font-size: 0.8rem;">
                                            <i class="fas fa-calendar-plus me-1"></i>Joined <%= createdAt %>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td data-label="Username">
                                <code class="bg-light px-2 py-1 rounded"><%= username %></code>
                            </td>
                            <td data-label="Role">
                                <span class="role-tag <%= roleColorClass %>">
                                    <i class="fas <%= role.equals("System Admin") ? "fa-user-shield" : "fa-user-tie" %> me-1"></i>
                                    <%= role %>
                                </span>
                            </td>
                            <td data-label="Status">
                                <span class="status-badge <%= statusColorClass %>">
                                    <i class="fas fa-circle me-1" style="font-size: 0.6rem;"></i>
                                    <%= status %>
                                </span>
                            </td>
                            <td data-label="Last Login">
                                <div class="text-muted small">
                                    <%= lastLogin.equals("Never") ? "Never logged in" : lastLogin %>
                                </div>
                            </td>
                            <td data-label="Actions">
                                <div class="action-buttons">
                                    <button class="action-btn btn-edit" title="Edit User">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="action-btn btn-reset" title="Reset Password">
                                        <i class="fas fa-key"></i>
                                    </button>
                                    <button class="action-btn btn-delete" title="Delete User">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                                // Display sample data if no users found
                                String[][] sampleUsers = {
                                    {"Rajesh Sharma", "rajesh.admin", "System Admin", "Active", "2 hours ago"},
                                    {"Priya Patel", "priya.staff", "Staff", "Active", "Yesterday"},
                                    {"Amit Kumar", "amit.admin", "System Admin", "Active", "Today"},
                                    {"Sneha Gupta", "sneha.staff", "Staff", "Active", "1 week ago"},
                                    {"Vikram Singh", "vikram.staff", "Staff", "Inactive", "2 weeks ago"},
                                    {"Meera Nair", "meera.staff", "Staff", "Active", "Yesterday"}
                                };
                                
                                for(String[] sampleUser : sampleUsers) {
                        %>
                        <tr>
                            <td data-label="User">
                                <div class="d-flex align-items-center gap-3">
                                    <div class="user-avatar">
                                        <%= sampleUser[0].charAt(0) %>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="font-size: 0.95rem;"><%= sampleUser[0] %></div>
                                        <div class="text-muted small" style="font-size: 0.8rem;">
                                            <i class="fas fa-calendar-plus me-1"></i>Joined 2 months ago
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td data-label="Username">
                                <code class="bg-light px-2 py-1 rounded"><%= sampleUser[1] %></code>
                            </td>
                            <td data-label="Role">
                                <span class="role-tag <%= sampleUser[2].equals("System Admin") ? "role-admin" : "role-staff" %>">
                                    <i class="fas <%= sampleUser[2].equals("System Admin") ? "fa-user-shield" : "fa-user-tie" %> me-1"></i>
                                    <%= sampleUser[2] %>
                                </span>
                            </td>
                            <td data-label="Status">
                                <span class="status-badge <%= sampleUser[3].equals("Active") ? "bg-success bg-opacity-10 text-success" : "bg-secondary bg-opacity-10 text-secondary" %>">
                                    <i class="fas fa-circle me-1" style="font-size: 0.6rem;"></i>
                                    <%= sampleUser[3] %>
                                </span>
                            </td>
                            <td data-label="Last Login">
                                <div class="text-muted small">
                                    <%= sampleUser[4] %>
                                </div>
                            </td>
                            <td data-label="Actions">
                                <div class="action-buttons">
                                    <button class="action-btn btn-edit" title="Edit User">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button class="action-btn btn-reset" title="Reset Password">
                                        <i class="fas fa-key"></i>
                                    </button>
                                    <button class="action-btn btn-delete" title="Delete User">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } 
                        %>
                    </tbody>
                </table>
            </div>
            
            <!-- Pagination -->
            <div class="d-flex justify-content-between align-items-center mt-4">
                <div class="text-muted small">
                    Showing 1 to 6 of 12 users
                </div>
                <nav>
                    <ul class="pagination mb-0">
                        <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">Next</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user-plus me-2"></i>
                        Register New User
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/UserServlet" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control-custom" required 
                                   placeholder="Enter full name of the user">
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control-custom" required 
                                   placeholder="Choose a unique username">
                            <div class="form-text text-muted small">Username must be unique and 4-20 characters long.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Email Address</label>
                            <input type="email" name="email" class="form-control-custom" required 
                                   placeholder="user@example.com">
                        </div>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Role</label>
                                <select name="role" class="form-control-custom" required>
                                    <option value="">Select Role</option>
                                    <option value="System Admin">System Administrator</option>
                                    <option value="Admin">Administrator</option>
                                    <option value="Staff">Staff Member</option>
                                    <option value="Faculty">Faculty</option>
                                    <option value="Viewer">Viewer Only</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Status</label>
                                <select name="status" class="form-control-custom" required>
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                    <option value="Pending">Pending Activation</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control-custom" required 
                                   placeholder="Set a strong password">
                            <div class="form-text text-muted small">Password must be at least 8 characters with letters and numbers.</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" name="confirmPassword" class="form-control-custom" required 
                                   placeholder="Confirm the password">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-primary-custom">
                            <i class="fas fa-user-plus me-2"></i>
                            Create User Account
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.querySelector('.search-input');
            const filterButtons = document.querySelectorAll('.filter-btn');
            const userRows = document.querySelectorAll('.user-table tbody tr');
            
            // Search filter
            if(searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    
                    userRows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        if(text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
            
            // Filter buttons
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    const filter = this.textContent.trim().toLowerCase();
                    
                    if(filter === 'all users') {
                        userRows.forEach(row => row.style.display = '');
                        return;
                    }
                    
                    userRows.forEach(row => {
                        const rowText = row.textContent.toLowerCase();
                        
                        if(filter === 'active') {
                            row.style.display = rowText.includes('active') ? '' : 'none';
                        } else if(filter === 'admins') {
                            row.style.display = rowText.includes('admin') ? '' : 'none';
                        } else if(filter === 'staff') {
                            row.style.display = rowText.includes('staff') && !rowText.includes('admin') ? '' : 'none';
                        } else if(filter === 'inactive') {
                            row.style.display = rowText.includes('inactive') ? '' : 'none';
                        }
                    });
                });
            });
            
            // Action buttons
            const editButtons = document.querySelectorAll('.btn-edit');
            const resetButtons = document.querySelectorAll('.btn-reset');
            const deleteButtons = document.querySelectorAll('.btn-delete');
            
            editButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    alert('Edit user functionality coming soon!');
                });
            });
            
            resetButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    alert('Reset password functionality coming soon!');
                });
            });
            
            deleteButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    if(confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                        alert('User deleted successfully!');
                    }
                });
            });
            
            // Add user modal enhancement
            const addUserForm = document.querySelector('#addUserModal form');
            if(addUserForm) {
                addUserForm.addEventListener('submit', function(e) {
                    const password = this.querySelector('input[name="password"]').value;
                    const confirmPassword = this.querySelector('input[name="confirmPassword"]').value;
                    
                    if(password !== confirmPassword) {
                        e.preventDefault();
                        alert('Passwords do not match!');
                        return;
                    }
                    
                    if(password.length < 8) {
                        e.preventDefault();
                        alert('Password must be at least 8 characters long!');
                        return;
                    }
                    
                    // Show loading state
                    const submitBtn = this.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Creating...';
                    submitBtn.disabled = true;
                });
            }
        });
    </script>
</body>
</html>