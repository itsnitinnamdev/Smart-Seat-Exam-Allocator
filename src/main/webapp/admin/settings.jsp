<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.smartseat.dao.SettingsDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings | Smart-Seat</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    
    <style>
        :root {
            --primary-blue: #0066CC;
            --primary-dark: #003366;
            --primary-light: #E6F2FF;
            --success-green: #00A86B;
            --warning-orange: #FF6B35;
            --sidebar-width: 280px;
            --shadow-sm: 0 4px 6px rgba(0, 0, 0, 0.07);
            --shadow-md: 0 10px 25px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.15);
            --radius-lg: 16px;
            --radius-md: 12px;
            --radius-sm: 8px;
        }

        body {
            background: linear-gradient(135deg, #f8fbff 0%, #f0f7ff 100%);
            font-family: 'Inter', 'Segoe UI', system-ui, sans-serif;
            color: #2c3e50;
            min-height: 100vh;
        }

        /* Main Layout */
        .main-content {
            margin-left: var(--sidebar-width);
            padding: 40px;
            transition: all 0.3s ease;
            min-height: 100vh;
        }

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }

        /* Header Styles */
        .page-header {
            margin-bottom: 40px;
        }

        .page-title {
            font-size: 2.2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary-dark), var(--primary-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }

        .page-subtitle {
            color: #64748b;
            font-size: 1.1rem;
            font-weight: 500;
        }

        .header-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-light), white);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(0, 102, 204, 0.1);
        }

        .header-icon i {
            font-size: 32px;
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Alert Styles */
        .custom-alert {
            border: none;
            border-radius: var(--radius-md);
            padding: 20px;
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            box-shadow: var(--shadow-sm);
            border-left: 5px solid var(--success-green);
        }

        /* Card Styles */
        .settings-card {
            background: white;
            border-radius: var(--radius-lg);
            border: none;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
            overflow: hidden;
            height: 100%;
        }

        .settings-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-light), white);
            border-bottom: 1px solid rgba(0, 102, 204, 0.1);
            padding: 25px 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .card-icon {
            width: 50px;
            height: 50px;
            background: white;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow-sm);
        }

        .institution-icon {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
        }

        .allocation-icon {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: var(--success-green);
        }

        .card-title-custom {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-dark);
            margin: 0;
        }

        .card-body-custom {
            padding: 30px;
        }

        /* Form Styles */
        .form-group-custom {
            margin-bottom: 25px;
        }

        .form-label-custom {
            font-weight: 600;
            color: #334155;
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
            border: 1px solid #e2e8f0;
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

        .form-control-custom,
        .form-select-custom {
            border: none;
            background: white;
            padding: 14px 20px;
            font-size: 1rem;
            color: #334155;
        }

        .form-control-custom:focus,
        .form-select-custom:focus {
            box-shadow: none;
            background: white;
        }

        /* Button Styles */
        .save-section {
            background: white;
            border-radius: var(--radius-lg);
            padding: 30px;
            margin-top: 40px;
            box-shadow: var(--shadow-sm);
            border: 1px solid rgba(0, 102, 204, 0.1);
        }

        .btn-save {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: var(--radius-md);
            padding: 16px 40px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            box-shadow: var(--shadow-sm);
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            color: white;
            background: linear-gradient(135deg, var(--primary-dark), #002244);
        }

        .btn-save:active {
            transform: translateY(-1px);
        }

        .info-text {
            color: #64748b;
            font-size: 0.95rem;
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
        }

        /* Animation Classes */
        .animate-delay-1 { animation-delay: 0.2s; }
        .animate-delay-2 { animation-delay: 0.4s; }

        /* Loading State */
        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-title {
                font-size: 1.8rem;
            }
            
            .card-header-custom {
                padding: 20px;
            }
            
            .card-body-custom {
                padding: 20px;
            }
            
            .save-section {
                padding: 20px;
            }
            
            .btn-save {
                width: 100%;
                justify-content: center;
            }
        }
        @media (max-width: 992px) {
    /* Mobile par header icon ko thoda niche shift karein taaki toggle button ke piche na chupe */
    .header-icon {
        margin-top: 40px; 
    }
    
    .page-header {
        padding-top: 20px;
    }
}
    </style>
</head>
<body>
    <div class="dashboard-container">
        <jsp:include page="includes/sidebar.jsp" />
        
        <!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button> -->

        <div class="main-content">
            <div class="container-fluid">
                <!-- Page Header -->
                <div class="page-header animate__animated animate__fadeInDown">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h1 class="page-title">System Configuration</h1>
                            <p class="page-subtitle">Manage institutional settings and allocation preferences</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="header-icon animate__animated animate__fadeInRight">
                                <i class="fas fa-sliders-h"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Success Message --%>
                <% String message = request.getParameter("message"); if(message != null) { %>
                    <div class="alert custom-alert animate__animated animate__fadeInUp mb-4" role="alert">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle fa-2x me-3"></i>
                            <div>
                                <h5 class="alert-heading mb-1">Settings Updated!</h5>
                                <p class="mb-0"><%= message %></p>
                            </div>
                        </div>
                    </div>
                <% } %>

                <% 
                    SettingsDAO dao = new SettingsDAO();
                    Map<String, String> settings = dao.getAllSettings();
                %>

                <form action="../UpdateSettingsServlet" method="post" id="settingsForm">
                    <div class="row g-4">
                        <!-- Institution Settings Card -->
                        <div class="col-lg-6">
                            <div class="settings-card animate__animated animate__fadeInLeft animate-delay-1">
                                <div class="card-header-custom">
                                    <div class="card-icon institution-icon">
                                        <i class="fas fa-university fa-lg"></i>
                                    </div>
                                    <h3 class="card-title-custom">Institution Information</h3>
                                </div>
                                <div class="card-body-custom">
                                    <div class="form-group-custom">
                                        <label class="form-label-custom">
                                            <i class="fas fa-school"></i>
                                            College/Institution Name
                                        </label>
                                        <div class="input-group input-group-custom">
                                            <span class="input-group-text input-group-text-custom">
                                                <i class="fas fa-building"></i>
                                            </span>
                                            <input type="text" 
                                                   name="college_name" 
                                                   class="form-control form-control-custom"
                                                   value="<%= settings.getOrDefault("college_name", "IPS Academy, Institute of Engineering & Science") %>"
                                                   required
                                                   placeholder="Enter institution name">
                                        </div>
                                        <small class="text-muted mt-2 d-block">
                                            <i class="fas fa-info-circle me-1"></i>
                                            This name will appear on all reports and seating charts
                                        </small>
                                    </div>

                                    <div class="form-group-custom">
                                        <label class="form-label-custom">
                                            <i class="fas fa-calendar-alt"></i>
                                            Academic Year
                                        </label>
                                        <div class="input-group input-group-custom">
                                            <span class="input-group-text input-group-text-custom">
                                                <i class="fas fa-graduation-cap"></i>
                                            </span>
                                            <input type="text" 
                                                   name="academic_year" 
                                                   class="form-control form-control-custom"
                                                   value="<%= settings.getOrDefault("academic_year", "2025-26") %>"
                                                   placeholder="e.g., 2025-26">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Allocation Settings Card -->
                        <div class="col-lg-6">
                            <div class="settings-card animate__animated animate__fadeInRight animate-delay-1">
                                <div class="card-header-custom">
                                    <div class="card-icon allocation-icon">
                                        <i class="fas fa-bolt fa-lg"></i>
                                    </div>
                                    <h3 class="card-title-custom">Allocation Engine</h3>
                                </div>
                                <div class="card-body-custom">
                                    <div class="form-group-custom">
                                        <label class="form-label-custom">
                                            <i class="fas fa-user-friends"></i>
                                            Students Per Bench
                                        </label>
                                        <div class="input-group input-group-custom">
                                            <span class="input-group-text input-group-text-custom">
                                                <i class="fas fa-users"></i>
                                            </span>
                                            <input type="number" 
                                                   name="default_students_per_bench" 
                                                   class="form-control form-control-custom"
                                                   value="<%= settings.getOrDefault("default_students_per_bench", "2") %>"
                                                   min="1" 
                                                   max="4"
                                                   required>
                                        </div>
                                        <small class="text-muted mt-2 d-block">
                                            <i class="fas fa-lightbulb me-1"></i>
                                            Recommended: 2 students per bench for proper spacing
                                        </small>
                                    </div>

                                    <div class="form-group-custom">
                                        <label class="form-label-custom">
                                            <i class="fas fa-sitemap"></i>
                                            Default Allocation Method
                                        </label>
                                        <div class="input-group input-group-custom">
                                            <span class="input-group-text input-group-text-custom">
                                                <i class="fas fa-project-diagram"></i>
                                            </span>
                                            <select name="allocation_method" class="form-select form-select-custom">
                                                <option value="Vertical" <%= "Vertical".equals(settings.get("allocation_method")) ? "selected" : "" %>>Vertical Allocation</option>
                                                <option value="Horizontal" <%= "Horizontal".equals(settings.get("allocation_method")) ? "selected" : "" %>>Horizontal Allocation</option>
                                            </select>
                                        </div>
                                        <small class="text-muted mt-2 d-block">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Vertical allocation prevents same-branch students sitting together
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Save Button Section -->
                    <div class="save-section animate__animated animate__fadeInUp animate-delay-2">
                        <div class="text-center">
                            <button type="submit" class="btn btn-save" id="saveBtn">
                                <i class="fas fa-cloud-upload-alt"></i>
                                Apply System Changes
                                <div class="loading-spinner ms-2"></div>
                            </button>
                            <p class="info-text">
                                <i class="fas fa-shield-alt"></i>
                                Changes will be applied globally to all departments and future allocations
                            </p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('settingsForm');
            const saveBtn = document.getElementById('saveBtn');
            const spinner = saveBtn.querySelector('.loading-spinner');
            
            form.addEventListener('submit', function(e) {
                // Show loading state
                saveBtn.disabled = true;
                spinner.style.display = 'inline-block';
                saveBtn.querySelector('i').style.opacity = '0.7';
                
                // Add a small delay to show the loading state
                setTimeout(() => {
                    // Form will submit normally
                }, 100);
            });
            
            // Add focus effects to form inputs
            const inputs = form.querySelectorAll('.form-control-custom, .form-select-custom');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.closest('.input-group-custom').style.boxShadow = '0 0 0 3px rgba(0, 102, 204, 0.15)';
                });
                
                input.addEventListener('blur', function() {
                    this.closest('.input-group-custom').style.boxShadow = 'var(--shadow-sm)';
                });
            });
            
            // Add character counter for institution name
            const collegeNameInput = document.querySelector('input[name="college_name"]');
            if (collegeNameInput) {
                const counter = document.createElement('small');
                counter.className = 'text-muted mt-1 d-block text-end';
                counter.textContent = `\${collegeNameInput.value.length}/100 characters`;
                
                collegeNameInput.parentNode.parentNode.appendChild(counter);
                
                collegeNameInput.addEventListener('input', function() {
                    counter.textContent = `\${this.value.length}/100 characters`;
                    if (this.value.length > 100) {
                        counter.style.color = 'var(--warning-orange)';
                    } else {
                        counter.style.color = '#64748b';
                    }
                });
            }
        });
    </script>
</body>
</html>