<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
    // Session check: Only logged-in staff can access
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../user/login.jsp?error=Unauthorized Access!");
    }
    String adminName = (String) session.getAttribute("adminName");
    String adminRole = (String) session.getAttribute("adminRole");
    
    java.util.Date today = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy");
    String currentDate = sdf.format(today);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Room | Smart-Seat Admin Dashboard</title>
    
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

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow-md);
            border: 1px solid var(--border-color);
            max-width: 900px;
            margin: 0 auto;
        }

        .form-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .form-header h2 {
            font-weight: 800;
            font-size: 1.8rem;
            color: var(--primary-dark);
            margin-bottom: 10px;
        }

        .form-header p {
            color: var(--medium-gray);
            font-size: 1rem;
        }

        /* Form Elements - Consistent with Login/Registration */
        .form-group-custom {
            margin-bottom: 25px;
        }

        .form-label-custom {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--dark-gray);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .form-label-custom i {
            margin-right: 10px;
            color: var(--medium-gray);
            width: 20px;
            text-align: center;
        }

        .input-group-custom {
            position: relative;
        }

        .form-control-custom {
            background: white;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 16px 20px;
            font-size: 15px;
            font-weight: 500;
            color: var(--dark-gray);
            transition: all 0.3s ease;
            width: 100%;
        }

        .form-control-custom:focus {
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 4px rgba(0, 102, 204, 0.1);
            outline: none;
        }

        .input-icon {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--medium-gray);
            z-index: 5;
        }

        /* Capacity Preview */
        .capacity-preview {
            background: var(--primary-light);
            border-radius: 16px;
            padding: 25px;
            margin: 30px 0;
            border: 2px solid var(--primary-blue);
        }

        .capacity-display {
            text-align: center;
        }

        .capacity-number {
            font-weight: 800;
            font-size: 3rem;
            color: var(--primary-blue);
            line-height: 1;
            margin-bottom: 10px;
        }

        .capacity-label {
            color: var(--primary-dark);
            font-weight: 600;
            font-size: 1.1rem;
        }

        .capacity-note {
            color: var(--medium-gray);
            font-size: 0.9rem;
            margin-top: 10px;
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

        .alert-custom.alert-warning {
            background: rgba(255, 107, 53, 0.1);
            color: var(--warning-orange);
            border-left-color: var(--warning-orange);
        }

        .alert-custom i {
            font-size: 20px;
            margin-right: 15px;
        }

        /* Submit Button */
        .btn-submit {
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-dark));
            color: white;
            border: none;
            border-radius: 12px;
            padding: 18px 32px;
            font-weight: 700;
            font-size: 16px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            gap: 10px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            margin-top: 30px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .btn-submit::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 5px;
            height: 5px;
            background: rgba(255, 255, 255, 0.5);
            opacity: 0;
            border-radius: 100%;
            transform: scale(1, 1) translate(-50%);
            transform-origin: 50% 50%;
        }

        .btn-submit:focus:not(:active)::after {
            animation: ripple 1s ease-out;
        }

        /* Loading Animation */
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

        @keyframes ripple {
            0% {
                transform: scale(0, 0);
                opacity: 1;
            }
            20% {
                transform: scale(25, 25);
                opacity: 1;
            }
            100% {
                opacity: 0;
                transform: scale(40, 40);
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
                <h1>Manage Rooms</h1>
                <p>Add new examination rooms and configure their capacities</p>
            </div>
            <div class="header-actions">
                <div class="date-display">
                    <i class="fas fa-calendar-alt me-2"></i>
                    <%= currentDate %>
                </div>
                <a href="index.jsp" class="btn-primary-custom">
                    <i class="fas fa-arrow-left"></i>
                    Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Form Container -->
        <div class="form-container animate__animated animate__fadeInUp">
            
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

            <div class="form-header">
                <h2>Add New Examination Room</h2>
                <p>Configure room details and seating capacity for vertical allocation</p>
            </div>

            <form action="../AddRoomServlet" method="POST" id="roomForm">
                <div class="row g-4">
                    <!-- Room Information -->
                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-building"></i>
                                Building Block
                            </label>
                            <select class="form-control-custom" name="buildingBlock" id="buildingBlock" required>
                                <option value="">Select Building Block</option>
                                <option value="New Building (B-Block)">New Building (B-Block)</option>
                                <option value="Old Building (A-Block)">Old Building (A-Block)</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-layer-group"></i>
                                Floor Level
                            </label>
                            <select class="form-control-custom" name="floor" id="floor" required>
                                <option value="">Select Floor</option>
                                <option value="0">Ground Floor (G)</option>
                                <option value="1">1st Floor</option>
                                <option value="2">2nd Floor</option>
                                <option value="3">3rd Floor</option>
                                <option value="4">4th Floor</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-hashtag"></i>
                                Room Number / Name
                            </label>
                            <input type="text" 
                                   class="form-control-custom" 
                                   name="roomNo" 
                                   id="roomNo"
                                   placeholder="e.g. N-101, O-205, Seminar Hall"
                                   required
                                   pattern="[A-Za-z0-9\-\s]+"
                                   title="Room number can contain letters, numbers, hyphens, and spaces">
                            <small class="text-muted mt-2 d-block">
                                Use a clear identifier that matches the actual room signage
                            </small>
                        </div>
                    </div>

                    <!-- Separator -->
                    <div class="col-12">
                        <hr style="border-color: var(--border-color); opacity: 0.3;">
                    </div>

                    <!-- Capacity Configuration -->
                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-grip-lines-vertical"></i>
                                Total Columns
                            </label>
                            <div class="input-group-custom">
                                <input type="number" 
                                       class="form-control-custom" 
                                       name="totalColumns" 
                                       id="totalColumns"
                                       placeholder="e.g. 3"
                                       min="1"
                                       max="10"
                                       required>
                            </div>
                            <small class="text-muted mt-2 d-block">
                                Number of vertical columns in the room (typically 2-5)
                            </small>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-chair"></i>
                                Benches per Column
                            </label>
                            <div class="input-group-custom">
                                <input type="number" 
                                       class="form-control-custom" 
                                       name="benchesPerColumn" 
                                       id="benchesPerColumn"
                                       placeholder="e.g. 10"
                                       min="1"
                                       max="30"
                                       required>
                            </div>
                            <small class="text-muted mt-2 d-block">
                                Number of benches in each column (each bench seats 2 students)
                            </small>
                        </div>
                    </div>

                    <!-- Capacity Preview -->
                    <div class="col-12">
                        <div class="capacity-preview">
                            <div class="capacity-display">
                                <div class="capacity-number" id="capacityNumber">0</div>
                                <div class="capacity-label">Total Student Capacity</div>
                                <div class="capacity-note">
                                    Calculated as: <strong>(Columns × Benches × 2)</strong> students per room
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Information -->
                    <div class="col-12">
                        <div class="form-group-custom">
                            <label class="form-label-custom">
                                <i class="fas fa-info-circle"></i>
                                Additional Notes (Optional)
                            </label>
                            <textarea class="form-control-custom" 
                                      name="notes" 
                                      id="notes"
                                      placeholder="Any special instructions or room characteristics..."
                                      rows="3"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn-submit" id="submitButton">
                    <i class="fas fa-plus-circle"></i>
                    <span id="submitText">Register Room Details</span>
                    <div class="loading-spinner" id="loadingSpinner"></div>
                </button>
            </form>
        </div>
    </div>

    <!-- Mobile Menu Toggle (Hidden by default) -->
    <!-- <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="fas fa-bars"></i>
    </button> -->

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        

        // Calculate and display capacity
        function updateCapacity() {
            const columns = parseInt(document.getElementById('totalColumns').value) || 0;
            const benches = parseInt(document.getElementById('benchesPerColumn').value) || 0;
            const capacity = columns * benches * 2;
            
            document.getElementById('capacityNumber').textContent = capacity;
            
            // Update color based on capacity
            const capacityNumber = document.getElementById('capacityNumber');
            if (capacity === 0) {
                capacityNumber.style.color = 'var(--medium-gray)';
            } else if (capacity < 30) {
                capacityNumber.style.color = 'var(--warning-orange)';
            } else if (capacity < 100) {
                capacityNumber.style.color = 'var(--primary-blue)';
            } else {
                capacityNumber.style.color = 'var(--success-green)';
            }
        }

        // Add event listeners for capacity calculation
        document.getElementById('totalColumns').addEventListener('input', updateCapacity);
        document.getElementById('benchesPerColumn').addEventListener('input', updateCapacity);

        // Form submission handling
        const roomForm = document.getElementById('roomForm');
        const submitButton = document.getElementById('submitButton');
        const submitText = document.getElementById('submitText');
        const loadingSpinner = document.getElementById('loadingSpinner');
        
        roomForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form values
            const roomNo = document.getElementById('roomNo').value.trim();
            const columns = parseInt(document.getElementById('totalColumns').value);
            const benches = parseInt(document.getElementById('benchesPerColumn').value);
            
            // Validation
            if (!roomNo) {
                showAlert('Please enter a room number or name.', 'error');
                return;
            }
            
            if (columns < 1 || columns > 10) {
                showAlert('Number of columns must be between 1 and 10.', 'error');
                return;
            }
            
            if (benches < 1 || benches > 30) {
                showAlert('Number of benches per column must be between 1 and 30.', 'error');
                return;
            }
            
            // Show loading state
            submitText.style.display = 'none';
            loadingSpinner.style.display = 'block';
            submitButton.disabled = true;
            
            // Simulate processing delay
            setTimeout(() => {
                // Submit the form
                this.submit();
            }, 1500);
        });

        // Auto-generate room number based on selections
        document.getElementById('buildingBlock').addEventListener('change', generateRoomNumber);
        document.getElementById('floor').addEventListener('change', generateRoomNumber);
        
        function generateRoomNumber() {
            const building = document.getElementById('buildingBlock').value;
            const floor = document.getElementById('floor').value;
            const roomNoInput = document.getElementById('roomNo');
            
            if (building && floor && !roomNoInput.value) {
                let prefix = 'N-';
                if (building.includes('Old Building')) prefix = 'O-';
                
                let floorCode = 'G';
                if (floor === '1') floorCode = '1';
                if (floor === '2') floorCode = '2';
                if (floor === '3') floorCode = '3';
                if (floor === '4') floorCode = '4';
                
                // Generate random room number (01-20)
                const randomRoom = Math.floor(Math.random() * 20) + 1;
             // Backticks ki jagah normal quotes use karein
                const roomNumber = prefix + floorCode + randomRoom.toString().padStart(2, '0');
                
                roomNoInput.value = roomNumber;
                roomNoInput.focus();
            }
        }

        // Alert function
        function showAlert(message, type) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.custom-alert');
            existingAlerts.forEach(alert => alert.remove());
            
            // Create alert element
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert-custom alert-\${type === 'error' ? 'danger' : 'success'} custom-alert animate__animated animate__slideInDown`;
            alertDiv.innerHTML = `
                <i class="fas \${type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
                <div>\${message}</div>
            `;
            
            // Insert after form header
            const formHeader = document.querySelector('.form-header');
            formHeader.insertAdjacentElement('afterend', alertDiv);
            
            // Auto remove after 5 seconds
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.classList.add('animate__fadeOutUp');
                    setTimeout(() => {
                        if (alertDiv.parentNode) {
                            alertDiv.remove();
                        }
                    }, 500);
                }
            }, 5000);
        }

        // Initialize capacity display
        updateCapacity();
    </script>
</body>
</html>