<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.SimpleDateFormat, model.Attendance, model.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Records</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            background-color: #f5f5f5;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #4682b4, #b0c4de);
            color: #fff;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            padding: 20px;
            z-index: 1000;
            transition: width 0.3s ease, transform 0.3s ease;
            overflow-y: auto;
        }

        .sidebar.collapsed {
            width: 60px;
        }

        .sidebar.collapsed .logo,
        .sidebar.collapsed .nav-text {
            display: none;
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .sidebar .logo {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }

        .sidebar .toggle-btn {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .sidebar .toggle-btn i {
            font-size: 24px;
            cursor: pointer;
            color: #fff;
            transition: transform 0.3s ease;
        }

        .sidebar .toggle-btn i:hover {
            transform: scale(1.2);
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #fff;
            padding: 12px 16px;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 8px;
            font-size: 16px;
            transition: background 0.3s ease;
        }

        .sidebar a:hover {
            background-color: #f4a261;
            color: #2f4f4f;
        }

        .sidebar.collapsed a {
            justify-content: center;
            padding: 12px;
        }

        .sidebar-toggle {
            display: none;
            position: fixed;
            top: 20px;
            left: 20px;
            font-size: 24px;
            color: #4682b4;
            cursor: pointer;
            z-index: 1100;
        }

        .main-content {
            margin-left: 250px;
            padding: 20px;
            flex: 1;
            transition: margin-left 0.3s ease;
            padding-bottom: 60px;
        }

        .sidebar.collapsed ~ .main-content {
            margin-left: 60px;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 var(--spacing);
        }

        .attendance-header {
            background: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
        }

        .attendance-header h2 {
            color: var(--text-color);
            margin-bottom: 1.5rem;
            font-size: 1.8rem;
        }

        .attendance-header h2 i {
            margin-right: 0.5rem;
            color: #4682b4;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .stat-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            text-align: center;
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease;
            border: 1px solid #eee;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card i {
            font-size: 2rem;
            color: #4682b4;
            margin-bottom: 1rem;
        }

        .stat-card h3 {
            font-size: 2rem;
            margin: 0.5rem 0;
            color: var(--text-color);
        }

        .stat-card p {
            color: #666;
            margin: 0;
        }

        .attendance-table {
            background: white;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .table-container {
            overflow-x: auto;
            margin: 0 -1.5rem;
            padding: 0 1.5rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }

        th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
            text-align: left;
            padding: 1rem;
            border: none;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            text-transform: capitalize;
        }

        .status-present {
            background-color: #e0f7fa;
            color: #0077a0;
        }

        .status-absent {
            background-color: #ffebee;
            color: #c62828;
        }

        .alert {
            background-color: #f8d7da;
            color: #721c24;
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert i {
            font-size: 1.2rem;
        }

        .no-records {
            text-align: center;
            padding: 2rem;
            color: #666;
        }

        .no-records i {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #999;
        }

        @media (max-width: 768px) {
             .sidebar {
                 width: 250px;
                 transform: translateX(-250px);
             }

             .sidebar.active {
                 transform: translateX(0);
             }

            .sidebar.collapsed {
                width: 250px;
                transform: translateX(-250px);
            }

             .sidebar-toggle {
                 display: block;
             }

            .main-content {
                margin-left: 0;
            }

             .sidebar.collapsed ~ .main-content {
                 margin-left: 0;
             }

            .stats-container {
                grid-template-columns: 1fr;
            }
            
            .attendance-table {
                padding: 1rem;
            }
            
            .table-container {
                margin: 0 -1rem;
                padding: 0 1rem;
            }

            th, td {
                padding: 0.75rem;
            }
        }

        footer {
            background-color: #2f4f4f;
            padding: 32px 16px;
            color: #fff;
            text-align: center;
            width: 100%;
            position: relative;
            margin-top: auto;
        }

        .sidebar a i {
            color: #fff;
        }
    </style>
</head>
<body>

<aside class="sidebar" id="sidebar">
    <div class="toggle-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </div>
    <div class="logo">Itahari International</div>
    <a href="${pageContext.request.contextPath}/student-dash" title="Go to Dashboard"><i class="fas fa-home"></i><span class="nav-text">Dashboard</span></a>
    <a href="${pageContext.request.contextPath}/student-attendance" title="View Attendance"><i class="fas fa-clipboard-check"></i><span class="nav-text">Attendance</span></a>
    <a href="${pageContext.request.contextPath}/student/notifications" title="View Notifications"><i class="fas fa-bell"></i><span class="nav-text">Notifications</span></a>
    <a href="${pageContext.request.contextPath}/student/contact">
        <i class="fas fa-envelope"></i>
        <span class="nav-text">Contact Teacher</span>
    </a>
    <a href="${pageContext.request.contextPath}/logout" title="Log Out"><i class="fas fa-sign-out-alt"></i><span class="nav-text">Logout</span></a>
</aside>

<div class="sidebar-toggle" id="sidebar-toggle">
    <i class="fas fa-bars"></i>
</div>

<div class="main-content">
    <div class="container">
        <div class="attendance-header">
            <h2><i class="fas fa-calendar-check"></i> Attendance Records</h2>
            <div class="stats-container">
                <div class="stat-card">
                    <i class="fas fa-chalkboard"></i>
                    <h3>${totalClasses}</h3>
                    <p>Total Classes</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-user-check"></i>
                    <h3>${presentCount}</h3>
                    <p>Present</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-user-times"></i>
                    <h3>${absentCount}</h3>
                    <p>Absent</p>
                </div>
                <div class="stat-card">
                    <i class="fas fa-percentage"></i>
                    <h3>${attendancePercentage}%</h3>
                    <p>Attendance Rate</p>
                </div>
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        <% } %>

        <div class="attendance-table">
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Day</th>
                            <th>Faculty</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Attendance> attendanceRecords = (List<Attendance>) request.getAttribute("attendanceRecords");
                            if (attendanceRecords != null && !attendanceRecords.isEmpty()) {
                                for (Attendance record : attendanceRecords) {
                        %>
                            <tr>
                                <td><%= new SimpleDateFormat("yyyy-MM-dd").format(record.getDate()) %></td>
                                <td><%= record.getDay() != null ? record.getDay() : "N/A" %></td>
                                <td><%= record.getFaculty() != null ? record.getFaculty() : "N/A" %></td>
                                <td>
                                    <span class="status-badge status-<%= record.getStatus() != null ? record.getStatus().toLowerCase() : "unknown" %>">
                                        <%= record.getStatus() != null ? record.getStatus() : "Unknown" %>
                                    </span>
                                </td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="4" class="no-records">
                                    <i class="fas fa-clipboard"></i>
                                    <p>No attendance records found.</p>
                                </td>
                            </tr>
                        <% 
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <footer>
        <div style="max-width: 1200px; margin: 0 auto;">
            <p style="font-size: 16px;">© <%= new java.util.Date().getYear() + 1900 %> Itahari International College. All rights reserved.</p>
        </div>
    </footer>
</div>

<script>
    const sidebar = document.getElementById('sidebar');
    const toggle = document.getElementById('sidebar-toggle');

    function toggleSidebar() {
        sidebar.classList.toggle('collapsed');
    }

    toggle.addEventListener('click', () => {
        sidebar.classList.toggle('active');
        sidebar.classList.toggle('collapsed');
         if (sidebar.classList.contains('active')) {
             document.body.style.overflow = 'hidden';
         } else {
             document.body.style.overflow = '';
         }
    });

    document.addEventListener('click', (event) => {
        if (!sidebar.contains(event.target) && !toggle.contains(event.target) && sidebar.classList.contains('active')) {
            sidebar.classList.remove('active');
             document.body.style.overflow = '';
        }
    });

     window.addEventListener('resize', () => {
         if (window.innerWidth > 768) {
             sidebar.classList.remove('active');
             document.body.style.overflow = '';
         } else {
              sidebar.classList.remove('collapsed');
         }
     });

      window.addEventListener('load', () => {
          if (window.innerWidth <= 768) {
              sidebar.classList.add('collapsed');
          }
      });


</script>

</body>
</html> 