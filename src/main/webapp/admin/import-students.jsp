<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
    // Session check: Only logged-in staff can access
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("../home?error=Please Login First");
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
    <title>Import Students | Smart-Seat Admin Dashboard</title>
    
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

        /* CSV Info Card */
        .csv-info-card {
            background: linear-gradient(135deg, var(--primary-light), #F0F7FF);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 30px;
            border-left: 5px solid var(--primary-blue);
        }

        .csv-info-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .csv-info-header i {
            color: var(--primary-blue);
            font-size: 24px;
            margin-right: 15px;
        }

        /* Drop Zone */
        .drop-zone {
            border: 3px dashed var(--border-color);
            border-radius: 16px;
            padding: 50px 30px;
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            background: white;
            position: relative;
            margin-bottom: 30px;
        }

        .drop-zone:hover {
            border-color: var(--primary-blue);
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }

        .drop-zone.drag-over {
            border-color: var(--primary-blue);
            background: var(--primary-light);
            transform: scale(1.01);
        }

        .drop-zone-icon {
            font-size: 48px;
            color: var(--primary-blue);
            margin-bottom: 20px;
        }

        .file-preview {
            margin-top: 20px;
            padding: 15px;
            background: var(--light-gray);
            border-radius: 12px;
            display: none;
        }

        .file-info {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .file-name {
            font-weight: 600;
            color: var(--dark-gray);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .file-size {
            color: var(--medium-gray);
            font-size: 14px;
        }

        .btn-remove-file {
            background: none;
            border: none;
            color: var(--error-red);
            cursor: pointer;
            font-size: 18px;
        }

        /* Progress Bar */
        .progress-container {
            margin-top: 30px;
            display: none;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .progress-bar-custom {
            height: 10px;
            background: var(--border-color);
            border-radius: 5px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--primary-blue), var(--accent-teal));
            border-radius: 5px;
            width: 0%;
            transition: width 0.3s ease;
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

        .btn-submit:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
                <h1>Import Students</h1>
                <p>Bulk upload student data using CSV files for examination allocation</p>
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
                String warning = request.getParameter("warning");
                
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
                } else if(warning != null && !warning.isEmpty()) {
            %>
            <div class="alert-custom alert-warning animate__animated animate__slideInDown">
                <i class="fas fa-exclamation-triangle"></i>
                <div>
                    <strong>Warning!</strong> <%= warning %>
                </div>
            </div>
            <%
                }
            %>

            <div class="form-header">
                <h2>Import Student Data</h2>
                <p>Upload CSV file containing student information for examination allocation</p>
            </div>

            <!-- CSV Info Card -->
            <div class="csv-info-card">
                <div class="csv-info-header">
                    <i class="fas fa-info-circle"></i>
                    <h5 style="margin: 0; color: var(--primary-dark);">CSV Format Requirements</h5>
                </div>
                <p style="color: var(--medium-gray); margin-bottom: 15px;">
                    Your CSV file must contain the following columns in the exact order:
                </p>
                
                <div class="table-responsive">
                    <table class="table table-sm table-bordered bg-white">
						<thead style="background: var(--primary-light);">
							<tr>
								<th style="">enrollment_no</th>
								<th style="">name</th>
								<th style="">branch</th>
								<th style="">semester</th>
								<th style="">email</th>
								<th style="">academic_year</th>
								<th style="">student_type</th>
							</tr>
						</thead>
						<tbody>
                            <tr>
                                <td><code>0808CS221001</code></td>
                                <td><code>Rahul Sharma</code></td>
                                <td><code>CS</code></td>
                                <td><code>4</code></td>
                                <td><code>rahul@gmail.com</code></td>
                                <td><code>2025-2026</code></td>
                                <td><code>Regular</code></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <div style="margin-top: 15px; font-size: 14px; color: var(--medium-gray);">
                    <i class="fas fa-download me-2"></i>
                    <a href="../downloads/student_template.csv" style="color: var(--primary-blue); font-weight: 600; text-decoration: none;">
                        Download CSV Template
                    </a>
                </div>
            </div>

            <!-- Upload Form -->
            <form action="../ImportStudentsServlet" method="POST" enctype="multipart/form-data" id="uploadForm">
                <!-- Drop Zone -->
                <div class="drop-zone" id="dropZone">
                    <div class="drop-zone-icon">
                        <i class="fas fa-file-csv"></i>
                    </div>
                    <h4 style="color: var(--primary-dark); margin-bottom: 10px;">Drag & Drop CSV File</h4>
                    <p style="color: var(--medium-gray); margin-bottom: 20px;">
                        or click to browse your computer
                    </p>
                    <input type="file" name="studentFile" id="fileInput" accept=".csv" style="display: none;">
                    <button type="button" class="btn-primary-custom" id="browseButton">
                        <i class="fas fa-folder-open"></i>
                        Browse Files
                    </button>
                </div>

                <!-- File Preview -->
                <div class="file-preview" id="filePreview">
                    <div class="file-info">
                        <div class="file-name">
                            <i class="fas fa-file-csv" style="color: var(--primary-blue);"></i>
                            <span id="fileName">No file selected</span>
                        </div>
                        <div>
                            <span class="file-size" id="fileSize">0 KB</span>
                            <button type="button" class="btn-remove-file" id="removeFile">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div class="progress-container" id="progressContainer">
                    <div class="progress-header">
                        <span style="font-weight: 600; color: var(--dark-gray);">Uploading...</span>
                        <span id="progressPercentage">0%</span>
                    </div>
                    <div class="progress-bar-custom">
                        <div class="progress-fill" id="progressFill"></div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn-submit" id="submitButton" disabled>
                    <i class="fas fa-upload"></i>
                    <span id="submitText">Start Importing Students</span>
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
        

        // File upload elements
        const dropZone = document.getElementById('dropZone');
        const fileInput = document.getElementById('fileInput');
        const browseButton = document.getElementById('browseButton');
        const filePreview = document.getElementById('filePreview');
        const fileName = document.getElementById('fileName');
        const fileSize = document.getElementById('fileSize');
        const removeFile = document.getElementById('removeFile');
        const submitButton = document.getElementById('submitButton');
        const submitText = document.getElementById('submitText');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const progressContainer = document.getElementById('progressContainer');
        const progressFill = document.getElementById('progressFill');
        const progressPercentage = document.getElementById('progressPercentage');

        // Browse button click
        browseButton.addEventListener('click', () => fileInput.click());

        // File input change
        fileInput.addEventListener('change', handleFileSelect);

        // Remove file button
        removeFile.addEventListener('click', function() {
            fileInput.value = '';
            filePreview.style.display = 'none';
            submitButton.disabled = true;
        });

        // Drag and drop functionality
        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
            dropZone.addEventListener(eventName, preventDefaults, false);
        });

        function preventDefaults(e) {
            e.preventDefault();
            e.stopPropagation();
        }

        ['dragenter', 'dragover'].forEach(eventName => {
            dropZone.addEventListener(eventName, highlight, false);
        });

        ['dragleave', 'drop'].forEach(eventName => {
            dropZone.addEventListener(eventName, unhighlight, false);
        });

        function highlight() {
            dropZone.classList.add('drag-over');
        }

        function unhighlight() {
            dropZone.classList.remove('drag-over');
        }

        // Handle dropped files
        dropZone.addEventListener('drop', handleDrop, false);

        function handleDrop(e) {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files.length > 0) {
                fileInput.files = files;
                handleFileSelect();
            }
        }

        // Handle file selection
        function handleFileSelect() {
            if (fileInput.files.length > 0) {
                const file = fileInput.files[0];
                
                // Check file type
                if (!file.name.toLowerCase().endsWith('.csv')) {
                    showAlert('Please select a CSV file.', 'error');
                    return;
                }
                
                // Check file size (max 10MB)
                if (file.size > 10 * 1024 * 1024) {
                    showAlert('File size must be less than 10MB.', 'error');
                    return;
                }
                
                // Update preview
                fileName.textContent = file.name;
                fileSize.textContent = formatFileSize(file.size);
                filePreview.style.display = 'block';
                submitButton.disabled = false;
                
                // Show success message
                showAlert(`Ready to import: \${file.name}`, 'success');
            }
        }

        // Format file size
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }

        // Form submission
        const uploadForm = document.getElementById('uploadForm');
        uploadForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (!fileInput.files.length) {
                showAlert('Please select a CSV file to upload.', 'error');
                return;
            }
            
            // Show progress bar
            progressContainer.style.display = 'block';
            
            // Show loading state
            submitText.style.display = 'none';
            loadingSpinner.style.display = 'block';
            submitButton.disabled = true;
            
            // Simulate upload progress (in real app, this would be actual upload progress)
            simulateUploadProgress();
            
            // Submit the form after delay (in real app, this would be actual form submission)
            setTimeout(() => {
                this.submit();
            }, 2000);
        });

        // Simulate upload progress
        function simulateUploadProgress() {
            let progress = 0;
            const interval = setInterval(() => {
                progress += 5;
                if (progress > 95) {
                    clearInterval(interval);
                    progress = 95; // Hold at 95% until form submits
                }
                updateProgress(progress);
            }, 100);
        }

        // Update progress bar
        function updateProgress(percent) {
            progressFill.style.width = percent + '%';
            progressPercentage.textContent = percent + '%';
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
                <div>${message}</div>
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
    </script>
</body>
</html>