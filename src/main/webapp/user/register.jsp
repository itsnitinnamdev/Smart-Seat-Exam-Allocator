<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Registration | Smart-Seat IPS Academy</title>
    
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
        .registration-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* Registration Card - Consistent with Login Page */
        .registration-card {
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

        /* Right Panel - Registration Form */
        .registration-panel {
            padding: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 55%;
        }

        .registration-wrapper {
            width: 100%;
            max-width: 400px;
        }

        .registration-header {
            margin-bottom: 40px;
            text-align: center;
        }

        .registration-title {
            font-weight: 800;
            font-size: 2rem;
            color: var(--primary-dark);
            margin-bottom: 10px;
        }

        .registration-subtitle {
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

        /* Form Elements - Consistent with Login */
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

        .password-strength {
            margin-top: 8px;
            font-size: 12px;
            font-weight: 500;
        }

        .strength-weak { color: var(--error-red); }
        .strength-medium { color: var(--warning-orange); }
        .strength-strong { color: var(--success-green); }

        /* Role Selection - Updated to match login style */
        .role-selection {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 24px;
        }

        .role-card {
            border: 2px solid var(--border-color);
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            background: white;
        }

        .role-card:hover {
            border-color: var(--primary-blue);
            background: var(--primary-light);
        }

        .role-card.selected {
            border-color: var(--primary-blue);
            background: var(--primary-light);
            box-shadow: 0 0 0 4px rgba(0, 102, 204, 0.1);
        }

        .role-card i {
            font-size: 24px;
            color: var(--primary-blue);
            margin-bottom: 12px;
        }

        .role-card .role-name {
            font-weight: 600;
            color: var(--dark-gray);
            margin-bottom: 5px;
        }

        .role-card .role-desc {
            font-size: 12px;
            color: var(--medium-gray);
        }

        /* Terms & Conditions - Consistent with login */
        .terms-group {
            margin: 30px 0;
        }

        .form-check-custom {
            display: flex;
            align-items: flex-start;
        }

        .form-check-custom input {
            margin-right: 10px;
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-color);
            border-radius: 4px;
            cursor: pointer;
            margin-top: 3px;
        }

        .form-check-custom label {
            font-size: 14px;
            color: var(--medium-gray);
            cursor: pointer;
        }

        .form-check-custom label a {
            color: var(--primary-blue);
            font-weight: 600;
            text-decoration: none;
        }

        /* Register Button - Consistent with login button */
        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 102, 204, 0.2);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .btn-register::after {
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

        .btn-register:focus:not(:active)::after {
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

        .login-link {
            color: var(--primary-blue);
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .login-link:hover {
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

        /* Responsive Design */
        @media (max-width: 991.98px) {
            .registration-card {
                flex-direction: column;
                max-width: 500px;
                min-height: auto;
            }
            
            .institution-panel {
                width: 100%;
                padding: 40px;
                min-height: 300px;
            }
            
            .registration-panel {
                width: 100%;
                padding: 40px;
            }
            
            .welcome-section h1 {
                font-size: 2.2rem;
            }
            
            .role-selection {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 575.98px) {
            .registration-container {
                padding: 10px;
            }
            
            .institution-panel {
                padding: 30px 20px;
            }
            
            .registration-panel {
                padding: 30px 20px;
            }
            
            .registration-title {
                font-size: 1.75rem;
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

<div class="registration-container">
    <div class="registration-card" data-aos="zoom-in" data-aos-duration="800">
        
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
                    <h1>Join Our Team</h1>
                    <p>
                        Register as staff member to access the professional examination management portal for IPS Academy, Indore. 
                        Help manage seating allocations, student data, and generate comprehensive reports.
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

        <!-- Right Registration Panel -->
        <div class="registration-panel">
            <div class="registration-wrapper" data-aos="fade-left" data-aos-duration="800" data-aos-delay="200">
                
                <!-- Status Messages -->
                <%
                    String status = request.getParameter("status");
                    if("success".equals(status)) { 
                %>
                <div class="alert-custom alert-success animate__animated animate__slideInDown">
                    <i class="fas fa-check-circle"></i>
                    <div>
                        <strong>Registration Successful!</strong><br>
                        Your account has been created. Please check your email for verification.
                    </div>
                </div>
                <%
                    } else if("error".equals(status)) { 
                %>
                <div class="alert-custom alert-danger animate__animated animate__slideInDown">
                    <i class="fas fa-exclamation-circle"></i>
                    <div>
                        <strong>Registration Failed</strong><br>
                        Please check your information and try again.
                    </div>
                </div>
                <%
                    }
                %>

                <div class="registration-header">
                    <h1 class="registration-title">Staff Registration</h1>
                    <p class="registration-subtitle">Create your account to access the system</p>
                </div>

                <form action="../RegisterServlet" method="POST" id="registrationForm">
                    
                    <!-- Full Name -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-user"></i>
                            Full Name
                        </label>
                        <div class="input-group-custom">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" 
                                   class="form-control-custom" 
                                   name="name" 
                                   id="name"
                                   placeholder="Enter your full name"
                                   required
                                   autocomplete="name"
                                   autofocus>
                        </div>
                    </div>

                    <!-- Email Address -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-envelope"></i>
                            Email Address
                        </label>
                        <div class="input-group-custom">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" 
                                   class="form-control-custom" 
                                   name="email" 
                                   id="email"
                                   placeholder="name@ipsacademy.org"
                                   required
                                   autocomplete="email">
                        </div>
                        <small class="text-muted">Must be an official IPS Academy email address</small>
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
                                   placeholder="Create a strong password"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="password-toggle" id="togglePassword">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            Password strength: <span id="strengthText">None</span>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-lock"></i>
                            Confirm Password
                        </label>
                        <div class="input-group-custom">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" 
                                   class="form-control-custom" 
                                   name="confirmPassword" 
                                   id="confirmPassword"
                                   placeholder="Re-enter your password"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="password-toggle" id="toggleConfirmPassword">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" class="password-strength"></div>
                    </div>

                    <!-- Role Selection -->
                    <div class="form-group-custom">
                        <label class="form-label-custom">
                            <i class="fas fa-user-tag"></i>
                            Select Role
                        </label>
                        <div class="role-selection">
                            <div class="role-card" data-role="staff">
                                <i class="fas fa-user-graduate"></i>
                                <div class="role-name">Exam Staff</div>
                                <div class="role-desc">Manage hall allocations, seating plans</div>
                            </div>
                            <div class="role-card" data-role="admin">
                                <i class="fas fa-user-cog"></i>
                                <div class="role-name">Administrator</div>
                                <div class="role-desc">Full system access, user management</div>
                            </div>
                        </div>
                        <input type="hidden" name="role" id="selectedRole" value="staff" required>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="terms-group">
                        <div class="form-check-custom">
                            <input type="checkbox" 
                                   id="terms" 
                                   name="terms"
                                   class="form-check-input"
                                   required>
                            <label for="terms">
                                I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms of Service</a> 
                                and <a href="#" data-bs-toggle="modal" data-bs-target="#privacyModal">Privacy Policy</a>.
                            </label>
                        </div>
                    </div>

                    <!-- Register Button -->
                    <button type="submit" class="btn-register pulse-animation" id="registerButton">
                        <i class="fas fa-user-plus"></i>
                        <span id="registerText">Create Staff Account</span>
                        <div class="loading-spinner" id="loadingSpinner"></div>
                    </button>

                    <!-- Login Link -->
                    <div class="links-section">
                        <p>Already have an account?</p>
                        <a href="login.jsp" class="login-link">
                            <i class="fas fa-sign-in-alt"></i>
                            Sign In to Your Account
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

<!-- Terms Modal (would be actual modal content) -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
    <!-- Modal content would go here -->
</div>

<!-- Privacy Modal (would be actual modal content) -->
<div class="modal fade" id="privacyModal" tabindex="-1" aria-hidden="true">
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

    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const confirmPasswordIcon = toggleConfirmPassword.querySelector('i');
    
    toggleConfirmPassword.addEventListener('click', function() {
        if (confirmPasswordInput.type === 'password') {
            confirmPasswordInput.type = 'text';
            confirmPasswordIcon.classList.remove('fa-eye');
            confirmPasswordIcon.classList.add('fa-eye-slash');
        } else {
            confirmPasswordInput.type = 'password';
            confirmPasswordIcon.classList.remove('fa-eye-slash');
            confirmPasswordIcon.classList.add('fa-eye');
        }
    });

    // Password strength checker
    document.getElementById('password').addEventListener('input', function() {
        const password = this.value;
        const strengthText = document.getElementById('strengthText');
        const strengthDiv = document.getElementById('passwordStrength');
        
        let strength = 0;
        let feedback = '';
        
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        
        // Update strength display
        strengthDiv.className = 'password-strength';
        
        switch(strength) {
            case 0:
                feedback = 'None';
                strengthDiv.className += ' strength-weak';
                break;
            case 1:
                feedback = 'Weak';
                strengthDiv.className += ' strength-weak';
                break;
            case 2:
                feedback = 'Fair';
                strengthDiv.className += ' strength-medium';
                break;
            case 3:
                feedback = 'Good';
                strengthDiv.className += ' strength-medium';
                break;
            case 4:
                feedback = 'Strong';
                strengthDiv.className += ' strength-strong';
                break;
        }
        
        strengthText.textContent = feedback;
        
        // Check password match
        checkPasswordMatch();
    });

    // Password match checker
    document.getElementById('confirmPassword').addEventListener('input', checkPasswordMatch);
    
    function checkPasswordMatch() {
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const matchDiv = document.getElementById('passwordMatch');
        
        if (!password || !confirmPassword) {
            matchDiv.textContent = '';
            return;
        }
        
        if (password === confirmPassword) {
            matchDiv.textContent = '✓ Passwords match';
            matchDiv.style.color = 'var(--success-green)';
            matchDiv.className = 'password-strength strength-strong';
        } else {
            matchDiv.textContent = '✗ Passwords do not match';
            matchDiv.style.color = 'var(--error-red)';
            matchDiv.className = 'password-strength strength-weak';
        }
    }

    // Role selection
    const roleCards = document.querySelectorAll('.role-card');
    const selectedRoleInput = document.getElementById('selectedRole');
    
    roleCards.forEach(card => {
        card.addEventListener('click', function() {
            // Remove selected class from all cards
            roleCards.forEach(c => c.classList.remove('selected'));
            
            // Add selected class to clicked card
            this.classList.add('selected');
            
            // Update hidden input value
            const role = this.getAttribute('data-role');
            selectedRoleInput.value = role;
        });
    });

    // Set default selection
    document.querySelector('.role-card[data-role="staff"]').classList.add('selected');

    // Form submission handling
    const registrationForm = document.getElementById('registrationForm');
    const registerButton = document.getElementById('registerButton');
    const registerText = document.getElementById('registerText');
    const loadingSpinner = document.getElementById('loadingSpinner');
    
    registrationForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form values
        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const terms = document.getElementById('terms').checked;
        
        // Basic validation
        if (!name || !email || !password || !confirmPassword) {
            showAlert('Please fill in all required fields.', 'error');
            return;
        }
        
        // Email validation
        if (!email.includes('@ipsacademy')) {
            showAlert('Please use an official IPS Academy email address.', 'error');
            return;
        }
        
        // Password validation
        if (password.length < 8) {
            showAlert('Password must be at least 8 characters long.', 'error');
            return;
        }
        
        // Password match validation
        if (password !== confirmPassword) {
            showAlert('Passwords do not match. Please check and try again.', 'error');
            return;
        }
        
        // Terms validation
        if (!terms) {
            showAlert('You must agree to the Terms of Service and Privacy Policy.', 'error');
            return;
        }
        
        // Show loading state
        registerText.style.display = 'none';
        loadingSpinner.style.display = 'block';
        registerButton.disabled = true;
        
        // Submit the form
        this.submit();
    });

    // Auto-focus name field on page load
    document.getElementById('name').focus();

    // Alert function
    function showAlert(message, type) {
        // Remove existing alerts
        const existingAlerts = document.querySelectorAll('.custom-alert');
        existingAlerts.forEach(alert => alert.remove());
        
        // Create alert element
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert-custom alert-${type === 'error' ? 'danger' : 'success'} custom-alert animate__animated animate__slideInDown`;
        alertDiv.innerHTML = `
            <i class="fas ${type === 'error' ? 'fa-exclamation-circle' : 'fa-check-circle'}"></i>
            <div>${message}</div>
        `;
        
        // Insert after registration header
        const registrationHeader = document.querySelector('.registration-header');
        registrationHeader.insertAdjacentElement('afterend', alertDiv);
        
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

    // Add Enter key support for form submission
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !registerButton.disabled) {
            if (document.activeElement !== registerButton) {
                registrationForm.requestSubmit();
            }
        }
    });
</script>
</body>
</html>