<%-- sidebar.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
if(session.getAttribute("adminUser") == null) {
    response.sendRedirect("../index.jsp?error=Please Login First");
    return;
}
    String role = (String) session.getAttribute("adminRole");
    String name = (String) session.getAttribute("adminName");
%>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Toggle menu" style="display: none;">
    <i class="fas fa-bars"></i>
</button>

<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="brand-logo">
            <div class="logo-icon"><i class="fas fa-chair"></i></div>
            <div class="brand-name">Smart-Seat</div>
        </div>
        <div class="brand-subtitle">IPS Academy Examination System</div>
    </div>

    <div class="sidebar-menu">
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="nav-link"> 
                <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
            </a>
        </div>

        <% if("System Admin".equals(role) || "Admin".equals(role)) { %>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/add-room.jsp" class="nav-link">
                    <i class="fas fa-door-open"></i> <span>Manage Rooms</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a class="nav-link collapsed" data-bs-toggle="collapse" href="#subjectsMenu">
                    <i class="fas fa-book"></i> <span>Manage Subjects</span>
                    <i class="fas fa-chevron-down ms-auto"></i>
                </a>
                <div class="collapse" id="subjectsMenu">
                    <div class="ps-3">
                        <a href="${pageContext.request.contextPath}/admin/import-subjects.jsp" class="nav-link py-1 small">Import Subjects</a>
                        <a href="${pageContext.request.contextPath}/admin/view-subjects.jsp" class="nav-link py-1 small">View All Subjects</a>
                    </div>
                </div>
            </div>

            <div class="nav-item">
                <a class="nav-link collapsed" data-bs-toggle="collapse" href="#studentsMenu">
                    <i class="fas fa-user-graduate"></i> <span>Manage Students</span>
                    <i class="fas fa-chevron-down ms-auto"></i>
                </a>
                <div class="collapse" id="studentsMenu">
                    <div class="ps-3">
                        <a href="${pageContext.request.contextPath}/admin/import-students.jsp" class="nav-link py-1 small">Import Students</a>
                        <a href="${pageContext.request.contextPath}/admin/view-students.jsp" class="nav-link py-1 small">View All Students</a>
                    </div>
                </div>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/generate-plan.jsp" class="nav-link">
                    <i class="fas fa-cogs"></i> <span>Generate Plan</span>
                </a>
            </div>
        <% } %>

        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/seating-chart.jsp" class="nav-link">
                <i class="fas fa-table"></i> <span>Seating Chart</span>
            </a>
        </div>
        
        <div class="nav-item">
            <a href="${pageContext.request.contextPath}/ReportsServlet" class="nav-link">
                <i class="fas fa-chart-bar"></i> <span>Reports &amp; Analytics</span>
            </a>
        </div>

        <%-- Highly Sensitive: Only System Admin can manage users and settings --%>
        <% if("System Admin".equals(role)) { %>
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/UserServlet" class="nav-link">
                    <i class="fas fa-user-cog"></i> <span>User Management</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/manage-teachers.jsp" class="nav-link">
                    <i class="fas fa-chalkboard-teacher"></i> <span>Manage Teachers</span>
                </a>
            </div>
            
            <div class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/settings.jsp" class="nav-link">
                    <i class="fas fa-cog"></i> <span>System Settings</span>
                </a>
            </div>
        <% } %>
    </div>

    <div class="sidebar-footer">
        <div class="user-info">
            <div class="user-avatar"><%= (name != null) ? name.charAt(0) : "A" %></div>
            <div class="user-details">
                <div class="user-name"><%= (name != null) ? name : "Admin" %></div>
                <div class="user-role"><%= (role != null) ? role : "Staff" %></div>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="ms-auto" title="Logout">
                <i class="fas fa-sign-out-alt"></i>
            </a>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const toggleBtn = document.getElementById('mobileMenuToggle');
    const navLinks = document.querySelectorAll('.nav-link');
    
    // 1. Mobile toggle visibility check
    function checkMobile() {
        const isMobile = window.innerWidth <= 992;
        if (toggleBtn) {
            // Agar script crash nahi hoga, toh ye line button dikhayegi
            toggleBtn.style.display = isMobile ? 'flex' : 'none';
        }
        
        if (!isMobile) {
            sidebar.classList.remove('active');
            overlay.classList.remove('active');
            document.body.style.overflow = '';
        }
    }
    
    checkMobile();

    // 2. Sidebar Toggle Logic
    function toggleSidebar() {
        sidebar.classList.toggle('active');
        overlay.classList.toggle('active');
        if (sidebar.classList.contains('active')) {
            document.body.style.overflow = 'hidden';
            sidebar.setAttribute('tabindex', '-1');
            sidebar.focus();
        } else {
            document.body.style.overflow = '';
        }
    }

    function closeSidebar() {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    if (toggleBtn) {
        toggleBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            toggleSidebar();
        });
    }

    if (overlay) overlay.addEventListener('click', closeSidebar);

    // 3. Auto-close logic (Dropdowns ko chhod kar)
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            const isDropdownToggle = link.hasAttribute('data-bs-toggle');
            if (window.innerWidth <= 992 && !isDropdownToggle) {
                closeSidebar(); 
            }
        });
    });

    // 4. Highlight Active Link & Expand Parent Dropdown
    function highlightActiveLink() {
        const currentPath = window.location.pathname;
        const currentPage = currentPath.split('/').pop(); // Current file name nikalne ke liye
        let found = false;

        navLinks.forEach(link => {
            link.classList.remove('active');
            const href = link.getAttribute('href');
            
            if (href && (currentPath.endsWith(href) || currentPath.includes(href))) {
                link.classList.add('active');
                found = true;
                
                // Parent dropdown expand logic
                const parentCollapse = link.closest('.collapse');
                if (parentCollapse) {
                    parentCollapse.classList.add('show');
                    const toggleBtn = document.querySelector(`[href="#${parentCollapse.id}"]`);
                    if (toggleBtn) {
                        toggleBtn.classList.remove('collapsed');
                        toggleBtn.setAttribute('aria-expanded', 'true');
                    }
                }
            }
        });

        // Agar koi match nahi mila aur hum dashboard par hain
        if (!found && (currentPage === 'dashboard.jsp' || currentPage === '')) {
            const dashboardLink = document.querySelector('a[href*="dashboard.jsp"]');
            if (dashboardLink) dashboardLink.classList.add('active');
        }
    }
    
    highlightActiveLink();

    // 5. Resize handler
    let resizeTimer;
    window.addEventListener('resize', function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(() => {
            checkMobile();
            if (window.innerWidth > 992 && sidebar.classList.contains('active')) {
                closeSidebar();
            }
        }, 250);
    });
});
</script>