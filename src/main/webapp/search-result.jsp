<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.Date" %>
<%
    Map<String, String> data = (Map<String, String>) request.getAttribute("assignment");
    if(data == null) { 
        response.sendRedirect("index.jsp"); 
        return; 
    }
    
    // Format current date and time
    Date today = new Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy 'at' hh:mm a");
    String currentDateTime = sdf.format(today);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seat Assignment | Smart-Seat IPS Academy</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            --error-red: #E53E3E;
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.06);
            --shadow-md: 0 4px 16px rgba(0,0,0,0.08);
            --shadow-lg: 0 8px 30px rgba(0,0,0,0.12);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);
            color: var(--dark-gray);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Main Container */
        .assignment-container {
            width: 100%;
            max-width: 800px;
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Header */
        .assignment-header {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            padding: 30px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .header-pattern {
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            opacity: 0.1;
            background-image: radial-gradient(circle at 20% 80%, rgba(255,255,255,0.3) 0%, transparent 50%);
        }

        .institution-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            backdrop-filter: blur(10px);
        }

        .institution-name {
            font-weight: 700;
            font-size: 28px;
            letter-spacing: -0.5px;
        }

        .institution-subtitle {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 5px;
        }

        .document-title {
            font-weight: 700;
            font-size: 1.8rem;
            margin: 10px 0 5px 0;
        }

        .document-subtitle {
            font-size: 1rem;
            opacity: 0.9;
        }

        /* Content Area */
        .assignment-content {
            padding: 40px;
        }

        /* Student Info */
        .student-info {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 25px;
            align-items: start;
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 2px solid var(--light-gray);
        }

        .student-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-teal));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
            font-weight: 700;
            box-shadow: var(--shadow-md);
        }

        .student-details h3 {
            font-weight: 700;
            font-size: 1.8rem;
            color: var(--primary-dark);
            margin-bottom: 5px;
        }

        .student-enrollment {
            color: var(--medium-gray);
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .student-enrollment i {
            color: var(--primary-blue);
        }

        /* Seat Badge */
        .seat-badge-container {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background: var(--light-gray);
            border-radius: 20px;
        }

        .seat-badge-label {
            font-size: 0.9rem;
            color: var(--medium-gray);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .seat-badge {
            width: 140px;
            height: 140px;
            background: linear-gradient(135deg, var(--primary-blue), var(--secondary-blue));
            color: white;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            box-shadow: var(--shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .seat-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.2), transparent);
            animation: shine 3s infinite;
        }

        @keyframes shine {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .seat-number {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1;
        }

        .seat-label {
            font-size: 1rem;
            font-weight: 600;
            opacity: 0.9;
        }

        /* Assignment Details */
        .assignment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .detail-card {
            background: var(--light-gray);
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .detail-card:hover {
            border-color: var(--primary-blue);
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }

        .detail-icon {
            width: 50px;
            height: 50px;
            background: var(--primary-light);
            color: var(--primary-blue);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 22px;
        }

        .detail-label {
            font-size: 0.9rem;
            color: var(--medium-gray);
            margin-bottom: 8px;
            font-weight: 500;
        }

        .detail-value {
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--primary-dark);
        }

        .detail-subvalue {
            font-size: 0.9rem;
            color: var(--medium-gray);
            margin-top: 5px;
        }

        /* Important Notice */
        .notice-box {
            background: linear-gradient(135deg, #fff8e1, #fff3cd);
            border: 2px solid #ffd54f;
            border-radius: 16px;
            padding: 20px;
            margin-top: 30px;
        }

        .notice-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .notice-icon {
            color: #ff6b35;
            font-size: 20px;
        }

        .notice-title {
            font-weight: 700;
            color: #92400e;
        }

        .notice-content {
            color: #92400e;
            font-size: 0.9rem;
            line-height: 1.5;
        }

        /* Footer */
        .assignment-footer {
            background: var(--light-gray);
            padding: 30px 40px;
            border-top: 1px solid var(--border-color);
        }

        .footer-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .generated-info {
            color: var(--medium-gray);
            font-size: 0.9rem;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
        }

        /* Buttons */
        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.3);
            color: white;
        }

        .btn-secondary-custom {
            background: white;
            color: var(--primary-blue);
            border: 2px solid var(--primary-blue);
            border-radius: 12px;
            padding: 14px 28px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-secondary-custom:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
        }

        /* Print Styles */
        @media print {
            body {
                background: white !important;
                padding: 0 !important;
            }
            
            .assignment-container {
                box-shadow: none !important;
                border: 1px solid #ddd !important;
                margin: 0 !important;
                max-width: 100% !important;
            }
            
            .action-buttons {
                display: none !important;
            }
            
            .notice-box {
                break-inside: avoid;
            }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .assignment-container {
                border-radius: 16px;
            }
            
            .assignment-header,
            .assignment-content,
            .assignment-footer {
                padding: 25px;
            }
            
            .student-info {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .student-avatar {
                margin: 0 auto;
            }
            
            .assignment-details {
                grid-template-columns: 1fr;
            }
            
            .footer-info {
                flex-direction: column;
                text-align: center;
            }
            
            .action-buttons {
                width: 100%;
                flex-direction: column;
            }
            
            .btn-primary-custom,
            .btn-secondary-custom {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .assignment-header,
            .assignment-content,
            .assignment-footer {
                padding: 20px;
            }
            
            .document-title {
                font-size: 1.5rem;
            }
            
            .seat-badge {
                width: 120px;
                height: 120px;
            }
            
            .seat-number {
                font-size: 2.8rem;
            }
        }
    </style>
</head>
<body>
    <div class="assignment-container">
        <!-- Header -->
        <div class="assignment-header">
            <div class="header-pattern"></div>
            <div class="institution-logo">
                <div class="logo-icon">
                    <i class="fas fa-chair"></i>
                </div>
                <div>
                    <div class="institution-name">IPS Academy</div>
                    <div class="institution-subtitle">Smart-Seat Examination System</div>
                </div>
            </div>
            <h1 class="document-title">Seat Assignment Slip</h1>
            <p class="document-subtitle">Official Examination Hall Allocation</p>
        </div>

        <!-- Content -->
        <div class="assignment-content">
            <!-- Student Information -->
            <div class="student-info">
                <div class="student-avatar">
                    <%= data.get("name") != null ? data.get("name").substring(0, 1).toUpperCase() : "S" %>
                </div>
                <div class="student-details">
                    <h3><%= data.get("name") != null ? data.get("name") : "Student Name" %></h3>
                    <div class="student-enrollment">
                        <i class="fas fa-id-card"></i>
                        <%= request.getParameter("enrollmentNo") != null ? request.getParameter("enrollmentNo") : "Enrollment Number" %>
                    </div>
                    <p style="color: var(--medium-gray); font-size: 0.95rem;">
                        <i class="fas fa-graduation-cap me-2"></i>
                        <%= data.get("branch") != null ? data.get("branch") : "Branch" %> - 
                        Semester <%= data.get("semester") != null ? data.get("semester") : "Semester" %>
                    </p>
                </div>
            </div>

            <!-- Seat Badge -->
            <div class="seat-badge-container">
                <div class="seat-badge-label">Your Assigned Seat</div>
                <div class="seat-badge">
                    <div class="seat-number">S<%= data.get("seat") != null ? data.get("seat") : "00" %></div>
                    <div class="seat-label">SEAT NUMBER</div>
                </div>
            </div>

            <!-- Assignment Details -->
            <div class="assignment-details">
                <div class="detail-card">
                    <div class="detail-icon">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="detail-label">Examination Hall</div>
                    <div class="detail-value">Room <%= data.get("room") != null ? data.get("room") : "000" %></div>
                    <div class="detail-subvalue">Check floor map at entrance</div>
                </div>

                <div class="detail-card">
                    <div class="detail-icon">
                        <i class="fas fa-th"></i>
                    </div>
                    <div class="detail-label">Seat Location</div>
                    <div class="detail-value">Col <%= data.get("column") != null ? data.get("column") : "0" %>, Bench <%= data.get("bench") != null ? data.get("bench") : "0" %></div>
                    <div class="detail-subvalue">Enter from main door and follow signs</div>
                </div>

                <div class="detail-card">
                    <div class="detail-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <div class="detail-label">Date &amp; Time</div>
                    <div class="detail-value"><%= data.get("date") != null ? data.get("date") : "Date" %></div>
                    <div class="detail-subvalue"><%= data.get("shift") != null ? data.get("shift") : "Shift" %> Shift</div>
                </div>
                
                
    <div class="detail-card">
        <div class="detail-icon"><i class="fas fa-book-open"></i></div>
        <div class="detail-content">
            <div class="detail-label">Examination Subject</div>
            <div class="detail-value text-primary">
                <%= data.get("subject") != null ? data.get("subject") : "Not Specified" %>
            </div>
        </div>
    </div>

            </div>

			
            <!-- Important Notice -->
            <div class="notice-box">
                <div class="notice-header">
                    <i class="fas fa-exclamation-circle notice-icon"></i>
                    <div class="notice-title">Important Instructions</div>
                </div>
                <div class="notice-content">
                    • Please arrive at the examination hall 30 minutes before the scheduled time.<br>
                    • Carry your institute ID card and this assignment slip for verification.<br>
                    • Seat numbers are strictly assigned - do not exchange seats.<br>
                    • Electronic devices are not permitted inside the examination hall.
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="assignment-footer">
            <div class="footer-info">
                <div class="generated-info">
                    <i class="fas fa-clock me-2"></i>
                    Generated on: <%= currentDateTime %>
                </div>
                <div class="action-buttons">
                    <button onclick="window.print()" class="btn-primary-custom">
                        <i class="fas fa-print"></i>
                        Print Assignment Slip
                    </button>
                    <a href="index.jsp" class="btn-secondary-custom">
                        <i class="fas fa-search"></i>
                        Search Another
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add animation to seat badge
        document.addEventListener('DOMContentLoaded', function() {
            const seatBadge = document.querySelector('.seat-badge');
            if(seatBadge) {
                setTimeout(() => {
                    seatBadge.style.transform = 'scale(1.1)';
                    setTimeout(() => {
                        seatBadge.style.transform = 'scale(1)';
                    }, 300);
                }, 500);
            }

            // Print button enhancement
            const printBtn = document.querySelector('.btn-primary-custom');
            if(printBtn) {
                printBtn.addEventListener('click', function() {
                    const originalHTML = this.innerHTML;
                    this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Preparing Print...';
                    
                    setTimeout(() => {
                        window.print();
                        this.innerHTML = originalHTML;
                    }, 500);
                });
            }

            // Add subtle hover effect to all detail cards
            const detailCards = document.querySelectorAll('.detail-card');
            detailCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    const icon = this.querySelector('.detail-icon');
                    if(icon) {
                        icon.style.transform = 'scale(1.1)';
                        icon.style.transition = 'transform 0.3s ease';
                    }
                });
                
                card.addEventListener('mouseleave', function() {
                    const icon = this.querySelector('.detail-icon');
                    if(icon) {
                        icon.style.transform = 'scale(1)';
                    }
                });
            });
        });
    </script>
</body>
</html>