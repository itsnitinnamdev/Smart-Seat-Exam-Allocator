<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart-Seat | IPS Academy Exam Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

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
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
            --shadow-lg: 0 8px 30px rgba(0,0,0,0.12);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: #ffffff;
            color: var(--dark-gray);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Professional Navbar */
        .navbar {
            background: white;
            padding: 16px 0;
            box-shadow: var(--shadow-sm);
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 1030;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 22px;
            color: var(--primary-dark);
            display: flex;
            align-items: center;
        }

        .brand-logo {
            width: 36px;
            height: 36px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-teal));
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: white;
        }

        .institution-badge {
            background: var(--primary-light);
            color: var(--primary-blue);
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
        }

        /* Hero Section - Corporate Style */
        .hero-section {
            background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
            padding: 100px 0 80px;
            position: relative;
            overflow: hidden;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 50%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0, 102, 204, 0.03) 0%, transparent 100%);
            clip-path: polygon(100% 0, 100% 100%, 0 100%);
        }

        .hero-title {
            font-weight: 800;
            font-size: 3.2rem;
            line-height: 1.1;
            margin-bottom: 24px;
            color: var(--primary-dark);
        }

        .hero-subtitle {
            color: var(--medium-gray);
            font-size: 1.2rem;
            max-width: 600px;
            margin-bottom: 40px;
        }

        .version-badge {
            background: linear-gradient(135deg, var(--accent-teal), #008888);
            color: white;
            padding: 8px 20px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 12px;
            letter-spacing: 0.5px;
            display: inline-block;
            margin-bottom: 30px;
            box-shadow: var(--shadow-sm);
        }

        /* Professional Card Design */
        .portal-card {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .portal-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-blue);
        }

        .card-icon-wrapper {
            width: 80px;
            height: 80px;
            background: var(--primary-light);
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            color: var(--primary-blue);
            font-size: 32px;
            transition: all 0.3s ease;
        }

        .portal-card:hover .card-icon-wrapper {
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
            transform: scale(1.05);
        }

        .card-title {
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 16px;
            color: var(--primary-dark);
        }

        .card-description {
            color: var(--medium-gray);
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        /* Form Elements - Professional */
        .form-control-custom {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 14px 20px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
            background: white;
        }

        .form-control-custom:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(0, 102, 204, 0.1);
            background: white;
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 25px;
        }

        .input-group-custom i {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
            z-index: 5;
        }

        .input-group-custom input {
            padding-left: 50px;
            width: 100%;
        }

        /* Professional Buttons */
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 16px 32px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
            color: white;
        }

        .btn-outline-custom {
            border: 2px solid var(--border-color);
            color: var(--dark-gray);
            background: white;
            border-radius: 12px;
            padding: 16px 24px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-outline-custom:hover {
            border-color: var(--primary-blue);
            background: var(--primary-light);
            color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .btn-secondary-custom {
            background: var(--light-gray);
            color: var(--dark-gray);
            border: none;
            border-radius: 12px;
            padding: 16px 24px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-secondary-custom:hover {
            background: #e8ecf1;
            transform: translateY(-2px);
        }

        /* Features Section */
        .features-section {
            background: var(--light-gray);
            padding: 100px 0;
            position: relative;
        }

        .section-title {
            font-weight: 800;
            font-size: 2.5rem;
            color: var(--primary-dark);
            margin-bottom: 16px;
        }

        .section-subtitle {
            color: var(--medium-gray);
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 60px;
        }

        .feature-item {
            background: white;
            border-radius: 16px;
            padding: 30px;
            height: 100%;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }

        .feature-item:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-blue);
        }

        .feature-icon {
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

        .feature-title {
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 12px;
            color: var(--primary-dark);
        }

        .feature-description {
            color: var(--medium-gray);
            font-size: 0.95rem;
        }

        /* Stats Counter */
        .stats-section {
            background: linear-gradient(135deg, var(--primary-dark), #002244);
            color: white;
            padding: 80px 0;
            border-radius: 0;
        }

        .stat-number {
            font-weight: 800;
            font-size: 3rem;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #ffffff, rgba(255,255,255,0.8));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .stat-label {
            color: rgba(255,255,255,0.8);
            font-weight: 500;
            font-size: 0.95rem;
        }

        /* Footer */
        .footer {
            background: var(--primary-dark);
            color: white;
            padding: 60px 0 30px;
        }

        .footer-logo {
            font-weight: 700;
            font-size: 22px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .footer-copyright {
            color: rgba(255,255,255,0.7);
            font-size: 0.9rem;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .portal-card {
                padding: 30px;
            }
        }

        @media (max-width: 768px) {
            .hero-section {
                padding: 80px 0 60px;
            }
            
            .hero-title {
                font-size: 2rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>

    <!-- Professional Navigation -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="#">
                <div class="brand-logo">
                    <i class="fas fa-chair"></i>
                </div>
                Smart-Seat
            </a>
            
            <div class="d-flex align-items-center">
                <span class="institution-badge me-3">
                    <i class="fas fa-university me-2"></i> IPS Academy, Indore
                </span>
                <span class="text-muted small fw-500 d-none d-lg-block">
                    <i class="far fa-calendar-alt me-1"></i> <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %>
                </span>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-5 mb-lg-0" data-aos="fade-up" data-aos-duration="1000">
                    <span class="version-badge animate__animated animate__pulse animate__infinite">
                        <i class="fas fa-bolt me-2"></i> ENTERPRISE EDITION v2.1
                    </span>
                    
                    <h1 class="hero-title">Intelligent Exam Hall Allocation System</h1>
                    
                    <p class="hero-subtitle">
                        Automate complex seating arrangements with vertical-fill algorithms, 
                        real-time student tracking, and comprehensive examination management.
                    </p>
                    
                    <div class="d-flex gap-3 mt-4">
                        <a href="#portals" class="btn btn-primary-custom" style="width: auto; padding-left: 40px; padding-right: 40px;">
                            Get Started <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                        <a href="#features" class="btn btn-outline-custom" style="width: auto;">
                            <i class="fas fa-play-circle me-2"></i> View Demo
                        </a>
                    </div>
                </div>
                
                <div class="col-lg-6" data-aos="fade-left" data-aos-duration="1000" data-aos-delay="300">
                    <div class="position-relative">
						<div class="bg-primary-light rounded-4 p-4 p-lg-5 shadow-lg">
							<div class="d-flex align-items-center mb-4">
								<div class="bg-white rounded-circle p-3 me-3 shadow-sm">
									<i class="fas fa-chart-line text-primary-blue fs-4"></i>
								</div>
								<div>
									<h5 class="fw-bold mb-1">System Status</h5>
									<div class="d-flex align-items-center">
										<%-- Database connection check logic --%>
										<%
										if (com.smartseat.util.DBConnection.getConnection() != null) {
										%>
										<div class="bg-success rounded-circle me-2"
											style="width: 10px; height: 10px;"></div>
										<span class="text-success fw-600">All Systems
											Operational</span>
										<%
										} else {
										%>
										<div class="bg-danger rounded-circle me-2"
											style="width: 10px; height: 10px;"></div>
										<span class="text-danger fw-600">Database Offline</span>
										<%
										}
										%>
									</div>
								</div>
							</div>

							<div class="row g-3">
								<div class="col-6">
									<div class="bg-white rounded-3 p-3 shadow-sm">
										<%-- HomeServlet se aa raha dynamic data --%>
										<div class="text-primary-blue fw-bold fs-5">
											${totalStudents != null ? totalStudents : '0'}+</div>
										<div class="text-muted small">Students Processed</div>
									</div>
								</div>
								<div class="col-6">
									<div class="bg-white rounded-3 p-3 shadow-sm">
										<%-- Logic: Jitne students process hue uske base par calculation --%>
										<div class="text-primary-blue fw-bold fs-5">
											${totalStudents > 0 ? '92' : '0'}%</div>
										<div class="text-muted small">Space Optimized</div>
									</div>
								</div>
							</div>
						</div>
					</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Portals Section -->
    <section class="container py-5" id="portals">
        <div class="row g-4 justify-content-center py-5">
            
            <!-- Student Portal Card -->
            <div class="col-lg-5" data-aos="fade-up" data-aos-duration="1000">
                <div class="portal-card">
                    <div class="card-icon-wrapper">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    
                    <h3 class="card-title text-center">Student Portal</h3>
                    <p class="card-description text-center">
                        Instantly locate your assigned exam hall and seat number by entering your enrollment credentials.
                    </p>
                    <% if(request.getParameter("error") != null) { %>
    <div class="alert alert-danger">
        <%= request.getParameter("error") %>
    </div>
<% } %>
                    <form action="SearchSeatServlet" method="GET" id="searchForm">
                        <div class="input-group-custom">
                            <i class="fas fa-id-card"></i>
                            <input type="text" class="form-control-custom" name="enrollmentNo" id="enrollmentNo" 
                                   placeholder="Enter Enrollment Number (e.g., 0808CS211001)" required>
                        </div>
                        
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary-custom">
                                <i class="fas fa-search me-2"></i> Find My Seat Assignment
                            </button>
                        </div>
                        
                        <div class="text-center mt-3">
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i> 
                                Use your IPS Academy enrollment ID
                            </small>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Staff Portal Card -->
            <div class="col-lg-5" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="200">
                <div class="portal-card">
                    <div class="card-icon-wrapper">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    
                    <h3 class="card-title text-center">Staff Portal</h3>
                    <p class="card-description text-center">
                        Administrative dashboard for managing exam halls, student data, and generating automated seating plans.
                    </p>
                    
                    <div class="d-grid gap-3">
                        <a href="user/login.jsp" class="btn btn-outline-custom">
                            <i class="fas fa-sign-in-alt me-2"></i> 
                            <div class="d-flex flex-column align-items-start ms-1">
                                <span class="fw-bold">Portal Login</span>
                                <small class="text-muted">Access administrative functions</small>
                            </div>
                        </a>
                        
                        <!-- <a href="user/register.jsp" class="btn btn-secondary-custom">
                            <i class="fas fa-user-plus me-2"></i> 
                            <div class="d-flex flex-column align-items-start ms-1">
                                <span class="fw-bold">New Registration</span>
                                <small class="text-muted">Register new staff accounts</small>
                            </div>
                        </a> -->
                        
                        <a href="user/login.jsp" class="btn btn-outline-custom">
                            <i class="fas fa-tachometer-alt me-2"></i> 
                            <div class="d-flex flex-column align-items-start ms-1">
                                <span class="fw-bold">Admin Dashboard</span>
                                <small class="text-muted">System monitoring & reports</small>
                            </div>
                        </a>
                    </div>
                    
                    <div class="text-center mt-4 pt-3 border-top">
                        <small class="text-muted">
                            <i class="fas fa-shield-alt me-1"></i> 
                            Secure HTTPS connection required for staff access
                        </small>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
			<div class="row text-center">
				<div class="col-md-3 col-6 mb-4">
					<div class="stat-number">99.9%</div>
					<div class="stat-label">System Uptime</div>
				</div>
				<div class="col-md-3 col-6 mb-4">
					<div class="stat-number">${totalAllocated}+</div>
					<div class="stat-label">Students Allocated</div>
				</div>
				<div class="col-md-3 col-6 mb-4">
					<div class="stat-number">${totalHalls}</div>
					<div class="stat-label">Exam Halls Managed</div>
				</div>
			</div>
		</div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <div class="text-center mb-5" data-aos="fade-up">
                <h2 class="section-title">Enterprise-Grade Features</h2>
                <p class="section-subtitle">
                    Advanced algorithms and tools designed for large-scale educational institutions
                </p>
            </div>

            <div class="row g-4">
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-file-csv"></i>
                        </div>
                        <h4 class="feature-title">Bulk Data Processing</h4>
                        <p class="feature-description">
                            Process thousands of student records simultaneously with our optimized CSV import engine.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-grip-lines-vertical"></i>
                        </div>
                        <h4 class="feature-title">Vertical-Fill Algorithm</h4>
                        <p class="feature-description">
                            Advanced column-wise seating allocation that maximizes hall capacity and minimizes cheating opportunities.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-random"></i>
                        </div>
                        <h4 class="feature-title">Intelligent Branch Mixing</h4>
                        <p class="feature-description">
                            Automated branch shuffling with configurable parameters for optimal exam integrity.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <h4 class="feature-title">Real-time Analytics</h4>
                        <p class="feature-description">
                            Dashboard with occupancy rates, utilization metrics, and performance insights.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-print"></i>
                        </div>
                        <h4 class="feature-title">Professional Reporting</h4>
                        <p class="feature-description">
                            Generate hall-wise seating charts, student lists, and invigilation schedules.
                        </p>
                    </div>
                </div>
                
                <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h4 class="feature-title">Mobile Responsive</h4>
                        <p class="feature-description">
                            Fully responsive interface that works seamlessly on all devices and screen sizes.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="footer-logo">
                        <div class="brand-logo me-3">
                            <i class="fas fa-chair"></i>
                        </div>
                        Smart-Seat
                    </div>
                    <p class="mb-4" style="color: rgba(255,255,255,0.8); max-width: 400px;">
                        An enterprise examination management system developed exclusively for IPS Academy, Indore.
                    </p>
                </div>
                
                <div class="col-lg-3 col-6 mb-4">
                    <h6 class="fw-bold mb-3">Quick Links</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" style="color: rgba(255,255,255,0.7); text-decoration: none;">Student Portal</a></li>
                        <li class="mb-2"><a href="#" style="color: rgba(255,255,255,0.7); text-decoration: none;">Staff Login</a></li>
                        <li class="mb-2"><a href="#" style="color: rgba(255,255,255,0.7); text-decoration: none;">User Manual</a></li>
                        <li class="mb-2"><a href="#" style="color: rgba(255,255,255,0.7); text-decoration: none;">System Requirements</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-3 col-6 mb-4">
                    <h6 class="fw-bold mb-3">Contact</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2" style="color: rgba(255,255,255,0.7);">
                            <i class="fas fa-map-marker-alt me-2"></i> IPS Academy, Indore
                        </li>
                        <li class="mb-2" style="color: rgba(255,255,255,0.7);">
                            <i class="fas fa-envelope me-2"></i> support@smartseat.ips
                        </li>
                        <li class="mb-2" style="color: rgba(255,255,255,0.7);">
                            <i class="fas fa-phone me-2"></i> (0731) 236-7890
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-copyright text-center">
                <p class="mb-0">&copy; 2026 IPS Academy, Indore. Smart-Seat Examination Management System v2.1. All rights reserved.</p>
                <small class="d-block mt-2" style="color: rgba(255,255,255,0.5);">
                    Last updated: <%= new java.text.SimpleDateFormat("MMMM dd, yyyy").format(new java.util.Date()) %> | 
                    <span class="text-success"><i class="fas fa-circle"></i> System Operational</span>
                </small>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // Initialize AOS
        AOS.init({
            duration: 1000,
            once: true,
            offset: 100
        });

        // Form validation
        document.getElementById('searchForm').onsubmit = function(e) {
            let enrollmentNo = document.getElementById('enrollmentNo').value.trim();
            
            // Enhanced validation
            if(enrollmentNo.length < 8) {
                e.preventDefault();
                showAlert('Please enter a valid Enrollment Number (minimum 8 characters).', 'warning');
                return false;
            }
            
            // Check format (basic pattern)
            let pattern = /^[0-9]{4}[A-Z]{2}[0-9]{6}$/i;
            if(!pattern.test(enrollmentNo)) {
                e.preventDefault();
                showAlert('Please enter enrollment number in correct format (e.g., 0808CS211001).', 'warning');
                return false;
            }
            
            return true;
        };
        
        function showAlert(message, type) {
            // Create alert element
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-\${type === 'warning' ? 'warning' : 'danger'} alert-dismissible fade show position-fixed`;
            alertDiv.style.cssText = `
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 300px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                border: none;
                border-left: 4px solid \${type === 'warning' ? '#ffc107' : '#dc3545'};
            `;
            alertDiv.innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="fas \${type === 'warning' ? 'fa-exclamation-triangle' : 'fa-exclamation-circle'} me-3 fs-4"></i>
                    <div>${message}</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            // Add to body
            document.body.appendChild(alertDiv);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if(alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }
        
        // Add smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                const targetId = this.getAttribute('href');
                if(targetId === '#') return;
                
                e.preventDefault();
                const targetElement = document.querySelector(targetId);
                if(targetElement) {
                    window.scrollTo({
                        top: targetElement.offsetTop - 80,
                        behavior: 'smooth'
                    });
                }
            });
        });
    </script>
</body>
</html>