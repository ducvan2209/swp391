<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Directory - HRM System</title>
    
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin>
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <!-- Custom Premium Styles -->
    <style>
        :root {
            --primary-color: #4f46e5;
            --primary-hover: #4338ca;
            --background-gradient: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
            --header-gradient: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--background-gradient);
            min-height: 100vh;
            color: #334155;
            display: flex;
            flex-direction: column;
        }
        
        h1, h2, h3, h4, h5 {
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
        }

        .navbar-premium {
            background: var(--header-gradient);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .brand-text {
            font-family: 'Outfit', sans-serif;
            font-weight: 800;
            background: linear-gradient(to right, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .dashboard-container {
            margin-top: 2.5rem;
            margin-bottom: 2.5rem;
            flex: 1;
        }

        .page-header-card {
            background: white;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.8);
            padding: 1.75rem;
            margin-bottom: 2rem;
        }

        .table-card {
            background: white;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.8);
            overflow: hidden;
        }

        .table-responsive {
            margin: 0;
        }

        .table-premium {
            margin-bottom: 0;
        }

        .table-premium thead {
            background-color: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }

        .table-premium th {
            color: #475569;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem 1.5rem;
        }

        .table-premium td {
            padding: 1rem 1.5rem;
            font-size: 0.925rem;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        .table-premium tbody tr {
            transition: all 0.2s ease-in-out;
        }

        .table-premium tbody tr:hover {
            background-color: #f1f5f9;
            transform: scale(1.002);
        }

        /* Status Badge Styling */
        .status-badge {
            font-weight: 600;
            font-size: 0.775rem;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .badge-active {
            background-color: #dcfce7;
            color: #15803d;
        }

        .badge-probation {
            background-color: #fef3c7;
            color: #b45309;
        }

        .badge-intern {
            background-color: #e0e7ff;
            color: #4338ca;
        }

        .badge-resigned {
            background-color: #fee2e2;
            color: #b91c1c;
        }

        /* Button Premium Styling */
        .btn-detail {
            background-color: #ffffff;
            color: var(--primary-color);
            border: 1.5px solid var(--primary-color);
            font-weight: 500;
            border-radius: 8px;
            padding: 0.4rem 0.9rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        .btn-detail:hover {
            background-color: var(--primary-color);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
            transform: translateY(-1px);
        }

        .search-container {
            position: relative;
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .search-input {
            padding-left: 2.5rem;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .search-input:focus {
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
            border-color: var(--primary-color);
        }

        .footer-text {
            font-size: 0.85rem;
            color: #64748b;
        }

        .pagination-container {
            padding: 1rem 1.5rem;
            border-top: 1px solid #e2e8f0;
            background-color: #f8fafc;
        }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark navbar-premium py-3" id="main-navigation">
            <div class="container">
                <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/dashboard" id="nav-brand-link">
                    <i class="bi bi-briefcase-fill fs-3 text-light"></i>
                    <span class="brand-text fs-4">AntigravityHRM</span>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation" id="navbar-toggle-btn">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard" id="nav-dashboard-link"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/employee-list" id="nav-employees-link"><i class="bi bi-people-fill me-1"></i> Employees</a>
                        </li>
                    </ul>
                    <div class="d-flex align-items-center gap-3 text-light">
                        <span class="d-none d-md-inline" id="user-role-indicator">
                            <i class="bi bi-person-badge-fill me-1"></i> HR Staff Panel
                        </span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm px-3 rounded-pill" id="nav-logout-btn">
                            <i class="bi bi-box-arrow-right me-1"></i> Logout
                        </a>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="container dashboard-container">
        <!-- Page Title & Header Info -->
        <div class="page-header-card d-md-flex align-items-center justify-content-between">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none text-muted">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Employees</li>
                    </ol>
                </nav>
                <h1 class="h2 text-dark m-0 d-flex align-items-center gap-2" id="page-main-heading">
                    Employee Directory
                </h1>
                <p class="text-muted m-0 mt-1">Manage and view employee information across all departments.</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <button type="button" class="btn btn-primary d-inline-flex align-items-center gap-2 px-3 py-2 rounded-3 shadow-sm" style="background-color: var(--primary-color); border: none;" id="btn-export-excel" onclick="alert('Export functionality demo!')">
                    <i class="bi bi-file-earmark-excel"></i> Export CSV
                </button>
            </div>
        </div>

        <!-- Table Container Card -->
        <div class="table-card">
            <!-- Search & Filtering Mock Toolbar -->
            <div class="p-3 border-bottom d-flex flex-column flex-md-row gap-3 align-items-md-center justify-content-between bg-light">
                <div class="search-container col-12 col-md-5">
                    <i class="bi bi-search search-icon"></i>
                    <input type="text" id="employee-search-bar" class="form-control search-input" placeholder="Search by name, email or position..." onkeyup="filterEmployees()">
                </div>
                <div class="d-flex align-items-center gap-2 justify-content-md-end">
                    <label for="filter-status" class="form-label mb-0 text-nowrap text-muted" style="font-size: 0.85rem;">Status:</label>
                    <select id="filter-status" class="form-select form-select-sm" style="border-radius: 8px;" onchange="filterStatus()">
                        <option value="All">All Statuses</option>
                        <option value="Active">Active</option>
                        <option value="Probation">Probation</option>
                        <option value="Intern">Intern</option>
                        <option value="Resigned">Resigned</option>
                    </select>
                </div>
            </div>

            <!-- Table of Employees -->
            <div class="table-responsive">
                <table class="table table-premium align-middle" id="employees-table">
                    <thead>
                        <tr>
                            <th scope="col" style="width: 10%;">ID</th>
                            <th scope="col" style="width: 20%;">Full Name</th>
                            <th scope="col" style="width: 20%;">Email</th>
                            <th scope="col" style="width: 15%;">Phone</th>
                            <th scope="col" style="width: 15%;">Department</th>
                            <th scope="col" style="width: 10%;">Position</th>
                            <th scope="col" style="width: 5%;">Status</th>
                            <th scope="col" class="text-end" style="width: 5%;">Action</th>
                        </tr>
                    </thead>
                    <tbody id="employees-table-body">
                        <c:choose>
                            <c:when test="${not empty employees}">
                                <c:forEach var="employee" items="${employees}">
                                    <tr class="employee-row" data-status="${employee.status}">
                                        <td class="fw-semibold text-secondary">#${employee.employeeId}</td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="bg-light border rounded-circle d-flex align-items-center justify-content-center text-secondary fw-bold" style="width: 32px; height: 32px; font-size: 0.85rem;">
                                                    <c:out value="${employee.fullName.substring(0, 1)}"/>
                                                </div>
                                                <span class="emp-name fw-bold text-dark"><c:out value="${employee.fullName}"/></span>
                                            </div>
                                        </td>
                                        <td class="emp-email text-muted"><c:out value="${employee.email}"/></td>
                                        <td class="emp-phone text-muted"><c:out value="${employee.phone}"/></td>
                                        <td>
                                            <span class="badge bg-secondary-subtle text-secondary border px-2 py-1" style="font-size: 0.8rem; border-radius: 6px;">
                                                <i class="bi bi-building me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty employee.departmentName}">
                                                        <c:out value="${employee.departmentName}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted italic">Unassigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td><span class="fw-medium text-dark"><c:out value="${employee.position}"/></span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${employee.status == 'Active'}">
                                                    <span class="status-badge badge-active"><i class="bi bi-check-circle-fill"></i> Active</span>
                                                </c:when>
                                                <c:when test="${employee.status == 'Probation'}">
                                                    <span class="status-badge badge-probation"><i class="bi bi-hourglass-split"></i> Probation</span>
                                                </c:when>
                                                <c:when test="${employee.status == 'Intern'}">
                                                    <span class="status-badge badge-intern"><i class="bi bi-mortarboard-fill"></i> Intern</span>
                                                </c:when>
                                                <c:when test="${employee.status == 'Resigned'}">
                                                    <span class="status-badge badge-resigned"><i class="bi bi-x-circle-fill"></i> Resigned</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary"><c:out value="${employee.status}"/></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/employee/detail?id=${employee.employeeId}" class="btn-detail" id="btn-detail-${employee.employeeId}">
                                                <i class="bi bi-eye"></i> Detail
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-people fs-1 d-block mb-2 text-secondary opacity-50"></i>
                                        No employee records found.
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Table Footer with Mock Pagination & Stats -->
            <div class="pagination-container d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
                <span class="footer-text" id="table-entries-stats">
                    Showing <span class="fw-semibold text-dark" id="visible-count"><c:out value="${employees.size()}"/></span> out of <span class="fw-semibold text-dark"><c:out value="${employees.size()}"/></span> employee entries
                </span>
                <nav aria-label="Page navigation" id="table-pagination-nav">
                    <ul class="pagination pagination-sm m-0">
                        <li class="page-item disabled"><a class="page-link" href="#" tabindex="-1">Previous</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">Next</a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-top py-4 mt-auto">
        <div class="container text-center">
            <p class="m-0 footer-text">&copy; 2026 Antigravity HRM System. All rights reserved. Designed for HR Operations.</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>

    <!-- JS Client-side Filters -->
    <script>
        function filterEmployees() {
            const input = document.getElementById("employee-search-bar");
            const filter = input.value.toLowerCase().trim();
            const rows = document.getElementsByClassName("employee-row");
            let visibleCount = 0;
            const statusFilter = document.getElementById("filter-status").value;

            for (let i = 0; i < rows.length; i++) {
                const nameNode = rows[i].querySelector(".emp-name");
                const emailNode = rows[i].querySelector(".emp-email");
                const phoneNode = rows[i].querySelector(".emp-phone");
                const rowStatus = rows[i].getAttribute("data-status");
                
                const nameText = nameNode ? nameNode.textContent.toLowerCase() : "";
                const emailText = emailNode ? emailNode.textContent.toLowerCase() : "";
                const phoneText = phoneNode ? phoneNode.textContent.toLowerCase() : "";

                const matchesSearch = nameText.includes(filter) || emailText.includes(filter) || phoneText.includes(filter);
                const matchesStatus = (statusFilter === "All" || rowStatus === statusFilter);

                if (matchesSearch && matchesStatus) {
                    rows[i].style.display = "";
                    visibleCount++;
                } else {
                    rows[i].style.display = "none";
                }
            }
            document.getElementById("visible-count").textContent = visibleCount;
        }

        function filterStatus() {
            filterEmployees();
        }
    </script>
</body>
</html>
