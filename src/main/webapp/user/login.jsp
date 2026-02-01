<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login | Smart-Seat IPS Academy</title>
    
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
            overflow-x: hidden;
        }

        /* Main Container */
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Login Card - Professional Design */
        .login-card {
            background: white;
            border-radius: 24px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            width: 100%;
            max-width: 1000px;
            display: flex;
            min-height: 600px;
            position: relative;
            border: 1px solid var(--border-color);
        }

        /* Left Panel - Institution Information */
        .institution-panel {
            background: linear-gradient(135deg, var(--primary-dark) 0%, #002244 100%);
            color: white;
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            width: 45%;
            position: relative;
            overflow: hidden;
        }

        .institution-panel::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=1000&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            opacity: 0.1;
            z-index: 0;
        }

        .institution-panel > * {
            position: relative;
            z-index: 1;
        }

        .brand-section {
            margin-bottom: 40px;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .logo-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--accent-teal), var(--primary-blue));
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            color: white;
            font-size: 28px;
        }

        .brand-name {
            font-weight: 800;
            font-size: 32px;
            letter-spacing: -0.5px;
        }

        .brand-tagline {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            font-weight: 500;
            margin-top: 5px;
        }

        .welcome-section h1 {
            font-weight: 800;
            font-size: 2.8rem;
            line-height: 1.1;
            margin-bottom: 20px;
            color: white;
        }

        .welcome-section p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .security-badge {
            display: inline-flex;
            align-items: center;
            background: rgba(0, 180, 179, 0.2);
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 14px;
            margin-top: 20px;
        }

        .security-badge i {
            margin-right: 10px;
            font-size: 16px;
        }

        /* Right Panel - Login Form */
        .login-panel {
            padding: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 55%;
        }

        .login-wrapper {
            width: 100%;
            max-width: 400px;
        }

        .login-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .login-title {
            font-weight: 800;
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 10px;
        }

        .login-subtitle {
            color: var(--medium-gray);
            font-size: 1rem;
        }

        /* Status Messages */
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

        .alert-custom.alert-danger {
            background: rgba(229, 62, 62, 0.1);
            color: var(--error-red);
            border-left-color: var(--error-red);
        }

        .alert-custom.alert-success {
            background: rgba(0, 168, 107, 0.1);
            color: var(--success-green);
            border-left-color: var(--success-green);
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

        /* Form Elements */
        .form-group-custom {
            margin-bottom: 24px;
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
            padding: 16px 20px 16px 50px;
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

        .password-toggle {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: var(--medium-gray);
            cursor: pointer;
            z-index: 5;
        }

        /* Remember Me & Forgot Password */
        .login-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .form-check-custom {
            display: flex;
            align-items: center;
        }

        .form-check-custom input {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-color);
            border-radius: 4px;
            cursor: pointer;
        }

        .form-check-custom label {
            color: var(--medium-gray);
            font-size: 14px;
            cursor: pointer;
        }

        .forgot-password {
            color: var(--primary-blue);
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        /* Login Button */
        .btn-login {
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
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .btn-login::after {
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

        .btn-login:focus:not(:active)::after {
            animation: ripple 1s ease-out;
        }

        /* Links Section */
        .links-section {
            text-align: center;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid var(--border-color);
        }

        .links-section p {
            color: var(--medium-gray);
            font-size: 15px;
            margin-bottom: 15px;
        }

        .register-link {
            color: var(--primary-blue);
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .register-link:hover {
            text-decoration: underline;
        }

        .back-link {
            color: var(--medium-gray);
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-top: 10px;
        }

        .back-link:hover {
            color: var(--primary-blue);
        }

        /* Session Timer */
        .session-timer {
            background: var(--light-gray);
            border-radius: 12px;
            padding: 15px;
            margin-top: 25px;
            text-align: center;
            font-size: 13px;
            color: var(--medium-gray);
            border: 1px solid var(--border-color);
        }

        .timer-display {
            font-weight: 700;
            color: var(--primary-blue);
            font-size: 14px;
            margin-top: 5px;
        }

        /* Responsive Design */
        @media (max-width: 991.98px) {
            .login-card {
                flex-direction: column;
                max-width: 500px;
                min-height: auto;
            }
            
            .institution-panel {
                width: 100%;
                padding: 40px;
                min-height: 300px;
            }
            
            .login-panel {
                width: 100%;
                padding: 40px;
            }
            
            .welcome-section h1 {
                font-size: 2.2rem;
            }
        }

        @media (max-width: 575.98px) {
            .login-container {
                padding: 10px;
            }
            
            .institution-panel {
                padding: 30px 20px;
            }
            
            .login-panel {
                padding: 30px 20px;
            }
            
            .login-title {
                font-size: 1.75rem;
            }
            
            .login-options {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
        }

        /* Animations */
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

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .pulse-animation {
            animation: pulse 2s infinite;
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
    </style>
</head>
<body>

<div class="login-container">
    <div class="login-card" data-aos="zoom-in" data-aos-duration="800">
        
        <!-- Left Institution Panel -->
        <div class="institution-panel">
            <div>
                <div class="brand-section">
                    <div class="brand-logo">
                        <div class="logo-icon">
                            <i class="fas fa-chair"></i>
                        </div>
                        <div>
                            <div class="brand-name">Smart-Seat</div>
                            <div class="brand-tagline">IPS Academy Examination System</div>
                        </div>
                    </div>
                </div>

                <div class="welcome-section">
                    <h1>Welcome Back</h1>
                    <p>
                        Access the professional examination management portal for IPS Academy, Indore. 
                        Manage seating allocations, student data, and generate comprehensive reports.
                    </p>
                    
                    <div class="security-badge">
                        <i class="fas fa-shield-check"></i>
                        Enterprise-Grade Security | TLS 1.3 Encrypted
                    </div>
                </div>
            </div>

            <div class="institution-info">
                <div class="d-flex justify-content-between align-items-center small opacity-75">
                    <span>© 2026 IPS Academy, Indore</span>
                    <span>v2.1 Enterprise</span>
                </div>
            </div>
        </div>

        <!-- Right Login Panel -->
        <div class="login-panel">
            <div class="login-wrapper" data-aos="fade-left" data-aos-duration="800" data-aos-delay="200">
                
                <!-- Error Messages -->
                <%
                    String error = request.getParameter("error");
                    String success = request.getParameter("success");
                    String warning = request.getParameter("warning");
                    
                    if(error != null && !error.isEmpty()) {
                %>
                <div class="alert-custom alert-danger animate__animated animate__slideInDown">
                    <i class="fas fa-exclamation-circle"></i>
                    <div><%= error %></div>
                </div>
                <%
                    } else if(success != null && !success.isEmpty()) {
                %>
                <div class="alert-custom alert-success animate__animated animate__slideInDown">
                    <i class="fas fa-check-circle"></i>
                    <div><%= success %></div>
                </div>
                <%
                    } else if(warning != null && !warning.isEmpty()) {
                %>
                <div class="alert-custom alert-warning animate__animated animate__slideInDown">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div><%= warning %></div>
                </div>
                <%
                    }
                %>

                <div class="login-header">
                    <h1 class="login-title">Staff Login</h1>
                    <p class="login-subtitle">Enter your credentials to access the system</p>
                </div>

                <form action="../LoginServlet" method="POST" id="loginForm">
                    
                    <!-- Username/Email -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-user"></i>
                            Username / Email
                        </label>
                        <div class="input-group-custom">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" 
                                   class="form-control-custom" 
                                   name="username" 
                                   id="username"
                                   placeholder="Enter username or email"
                                   required
                                   autocomplete="username"
                                   autofocus>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-lock"></i>
                            Password
                        </label>
                        <div class="input-group-custom">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" 
                                   class="form-control-custom" 
                                   name="password" 
                                   id="password"
                                   placeholder="Enter your password"
                                   required
                                   autocomplete="current-password">
                            <button type="button" class="password-toggle" id="togglePassword">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Remember Me & Forgot Password -->
                    <div class="login-options">
                        <div class="form-check-custom">
                            <input type="checkbox" 
                                   id="remember" 
                                   name="remember"
                                   class="form-check-input">
                            <label for="remember">Remember me</label>
                        </div>
                        <a href="#" class="forgot-password" data-bs-toggle="modal" data-bs-target="#forgotPasswordModal">
                            Forgot Password?
                        </a>
                    </div>

                    <!-- Login Button -->
                    <button type="submit" class="btn-login pulse-animation" id="loginButton">
                        <i class="fas fa-sign-in-alt"></i>
                        <span id="loginText">Sign In to Dashboard</span>
                        <div class="loading-spinner" id="loadingSpinner"></div>
                    </button>

                    <!-- Session Timer -->
                    <div class="session-timer">
                        <div>Session will expire in:</div>
                        <div class="timer-display" id="sessionTimer">30:00</div>
                    </div>

                    <!-- Links Section -->
                    <div class="links-section">
                        <p>Don't have an account?</p>
                        <a href="register.jsp" class="register-link">
                            <i class="fas fa-user-plus"></i>
                            Create Staff Account
                        </a>
                        
                        <div class="mt-3">
                            <a href="../index.jsp" class="back-link">
                                <i class="fas fa-arrow-left"></i>
                                Return to Landing Page
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Forgot Password Modal (would be actual modal content) -->
<div class="modal fade" id="forgotPasswordModal" tabindex="-1" aria-hidden="true">
    <!-- Modal content would go here -->
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    // Initialize AOS
    AOS.init({
        duration: 800,
        once: true,
        offset: 50
    });

    // Password toggle functionality
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    const passwordIcon = togglePassword.querySelector('i');
    
    togglePassword.addEventListener('click', function() {
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            passwordIcon.classList.remove('fa-eye');
            passwordIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            passwordIcon.classList.remove('fa-eye-slash');
            passwordIcon.classList.add('fa-eye');
        }
    });

    // Session timer
    let sessionTime = 30 * 60; // 30 minutes in seconds
    const sessionTimer = document.getElementById('sessionTimer');
    
    function updateTimer() {
        const minutes = Math.floor(sessionTime / 60);
        const seconds = sessionTime % 60;
        sessionTimer.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        
        if (sessionTime > 0) {
            sessionTime--;
        } else {
            clearInterval(timerInterval);
            showAlert('Your session has expired. Please login again.', 'warning');
        }
    }
    
    let timerInterval = setInterval(updateTimer, 1000);
    updateTimer(); // Initial call

    // Form submission handling
    const loginForm = document.getElementById('loginForm');
    const loginButton = document.getElementById('loginButton');
    const loginText = document.getElementById('loginText');
    const loadingSpinner = document.getElementById('loadingSpinner');
    
    loginForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form values
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        
        // Basic validation
        if (!username || !password) {
            showAlert('Please fill in all required fields.', 'error');
            return;
        }
        
        // Show loading state
        loginText.style.display = 'none';
        loadingSpinner.style.display = 'block';
        loginButton.disabled = true;
        
        // Simulate API call delay (remove in production)
        setTimeout(() => {
            // Submit the form (in production, this would be the actual form submission)
            this.submit();
            
            // For demo purposes, reset after 2 seconds
            setTimeout(() => {
                loginText.style.display = 'inline';
                loadingSpinner.style.display = 'none';
                loginButton.disabled = false;
            }, 2000);
        }, 1500);
    });

    // Auto-focus username field on page load
    document.getElementById('username').focus();

    // Show/hide password on focus/blur for better UX
    passwordInput.addEventListener('focus', function() {
        this.parentElement.style.borderColor = 'var(--primary-blue)';
    });
    
    passwordInput.addEventListener('blur', function() {
        if (!this.value) {
            this.parentElement.style.borderColor = 'var(--border-color)';
        }
    });

    // Alert function
    function showAlert(message, type) {
        // Remove existing alerts
        const existingAlerts = document.querySelectorAll('.alert-custom');
        existingAlerts.forEach(alert => {
            if (alert.classList.contains('alert-danger') || 
                alert.classList.contains('alert-warning')) {
                alert.remove();
            }
        });
        
        // Create alert element
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert-custom alert-${type === 'error' ? 'danger' : 'warning'} animate__animated animate__slideInDown`;
        alertDiv.innerHTML = `
            <i class="fas ${type === 'error' ? 'fa-exclamation-circle' : 'fa-exclamation-triangle'}"></i>
            <div>${message}</div>
        `;
        
        // Insert after login header
        const loginHeader = document.querySelector('.login-header');
        loginHeader.insertAdjacentElement('afterend', alertDiv);
        
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

    // Reset timer on user interaction
    document.addEventListener('mousemove', resetTimer);
    document.addEventListener('keypress', resetTimer);
    
    function resetTimer() {
        sessionTime = 30 * 60; // Reset to 30 minutes
        updateTimer();
    }

    // Remember me functionality
    const rememberCheckbox = document.getElementById('remember');
    const usernameField = document.getElementById('username');
    
    // Load saved username if "Remember me" was checked previously
    const savedUsername = localStorage.getItem('smartseat_username');
    if (savedUsername) {
        usernameField.value = savedUsername;
        rememberCheckbox.checked = true;
    }
    
    // Save username on form submit if "Remember me" is checked
    loginForm.addEventListener('submit', function() {
        if (rememberCheckbox.checked) {
            localStorage.setItem('smartseat_username', usernameField.value);
        } else {
            localStorage.removeItem('smartseat_username');
        }
    });

    // Add Enter key support for form submission
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !loginButton.disabled) {
            if (document.activeElement !== loginButton) {
                loginForm.requestSubmit();
            }
        }
    });
</script>
</body>
</html>