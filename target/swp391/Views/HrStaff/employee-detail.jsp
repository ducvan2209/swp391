<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee Details - HRM System</title>
    
    <!-- Google Fonts: Inter & Outfit -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    
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

        .detail-card {
            background: white;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.8);
            padding: 2rem;
            height: 100%;
        }

        .card-title-border {
            border-bottom: 2.5px solid #e2e8f0;
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #1e293b;
        }

        /* Read-Only Information Field Styling */
        .info-label {
            font-size: 0.775rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #64748b;
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-size: 1rem;
            color: #1e293b;
            font-weight: 500;
            background-color: #f8fafc;
            border: 1px solid #f1f5f9;
            border-radius: 8px;
            padding: 0.65rem 0.9rem;
            min-height: 2.6rem;
            display: flex;
            align-items: center;
        }

        .info-value-empty {
            font-style: italic;
            color: #94a3b8;
        }

        /* Status Badge Styling */
        .status-badge {
            font-weight: 600;
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
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

        .badge-contract-active {
            background-color: #dcfce7;
            color: #15803d;
        }
        
        .badge-contract-draft {
            background-color: #f1f5f9;
            color: #475569;
        }

        .badge-contract-pending {
            background-color: #fef3c7;
            color: #b45309;
        }

        .badge-contract-expired {
            background-color: #fee2e2;
            color: #b91c1c;
        }

        .btn-back {
            background-color: #ffffff;
            color: #475569;
            border: 1.5px solid #cbd5e1;
            font-weight: 500;
            border-radius: 8px;
            padding: 0.5rem 1.2rem;
            font-size: 0.9rem;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-back:hover {
            background-color: #f1f5f9;
            color: #1e293b;
            border-color: #94a3b8;
            transform: translateY(-1px);
        }

        .profile-avatar-large {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: linear-gradient(to right, #818cf8, #c084fc);
            color: white;
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 10px rgba(129, 140, 248, 0.3);
        }

        .alert-premium {
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            border: 1px solid rgba(226, 232, 240, 0.8);
        }

        .footer-text {
            font-size: 0.85rem;
            color: #64748b;
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
        <c:choose>
            <%-- Case: Employee NOT found --%>
            <c:when test="${empty employee}">
                <div class="alert alert-warning alert-premium p-5 text-center my-5" role="alert" id="employee-not-found-alert">
                    <i class="bi bi-exclamation-triangle-fill text-warning fs-1 d-block mb-3"></i>
                    <h2 class="h4 fw-bold">Employee Not Found</h2>
                    <p class="text-muted">The employee record you are trying to view does not exist or the ID is invalid.</p>
                    <a href="${pageContext.request.contextPath}/employee-list" class="btn btn-primary mt-3 px-4 rounded-pill" style="background-color: var(--primary-color); border: none;" id="btn-back-to-list-error">
                        <i class="bi bi-arrow-left me-1"></i> Back to Employee List
                    </a>
                </div>
            </c:when>
            
            <%-- Case: Employee found --%>
            <c:otherwise>
                <!-- Page Title & Header Info -->
                <div class="page-header-card d-md-flex align-items-center justify-content-between">
                    <div class="d-flex align-items-center gap-3">
                        <div class="profile-avatar-large">
                            <c:out value="${employee.fullName.substring(0, 1)}"/>
                        </div>
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard" class="text-decoration-none text-muted">Home</a></li>
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/employee-list" class="text-decoration-none text-muted">Employees</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Details</li>
                                </ol>
                            </nav>
                            <h1 class="h3 text-dark m-0 d-flex align-items-center gap-2" id="page-main-heading">
                                <c:out value="${employee.fullName}"/>
                            </h1>
                            <p class="text-muted m-0 mt-1">
                                <c:out value="${employee.position}"/> &bull; 
                                <c:choose>
                                    <c:when test="${not empty employee.departmentName}">
                                        <c:out value="${employee.departmentName}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted italic">No department assigned</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    <div class="mt-3 mt-md-0 d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/employee-list" class="btn-back" id="btn-back-to-list-header">
                            <i class="bi bi-arrow-left"></i> Back to List
                        </a>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- SECTION 1: Employee Basic Info -->
                    <div class="col-lg-8">
                        <div class="detail-card" id="section-employee-info">
                            <h2 class="h5 card-title-border">
                                <i class="bi bi-person-fill" style="color: var(--primary-color);"></i>
                                Employee Profile Information
                            </h2>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="info-label">Employee ID</div>
                                    <div class="info-value">#<c:out value="${employee.employeeId}"/></div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-label">Status</div>
                                    <div class="info-value">
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
                                    </div>
                                </div>
                                
                                <div class="col-md-12">
                                    <div class="info-label">Full Name</div>
                                    <div class="info-value"><c:out value="${employee.fullName}"/></div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value"><c:out value="${employee.gender}"/></div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-label">Date of Birth</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.dob}">
                                                <c:out value="${employee.dob}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="info-value-empty">Not Provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="info-label">Email Address</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.email}">
                                                <i class="bi bi-envelope me-2 text-muted"></i> <c:out value="${employee.email}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="info-value-empty">Not Provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-label">Phone Number</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.phone}">
                                                <i class="bi bi-telephone me-2 text-muted"></i> <c:out value="${employee.phone}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="info-value-empty">Not Provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="col-md-12">
                                    <div class="info-label">Current Address</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.address}">
                                                <i class="bi bi-geo-alt me-2 text-muted"></i> <c:out value="${employee.address}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="info-value-empty">Not Provided</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="info-label">Position</div>
                                    <div class="info-value"><c:out value="${employee.position}"/></div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-label">Employment Period</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.employmentPeriod}">
                                                <c:out value="${employee.employmentPeriod}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="info-value-empty">Not Defined</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Department and Contract Info -->
                    <div class="col-lg-4 d-flex flex-column gap-4">
                        <!-- SECTION 2: Department Info -->
                        <div class="detail-card flex-grow-0" id="section-department-info">
                            <h2 class="h5 card-title-border">
                                <i class="bi bi-building-fill" style="color: var(--primary-color);"></i>
                                Department Info
                            </h2>
                            <div>
                                <div class="info-label">Assigned Department</div>
                                <c:choose>
                                    <c:when test="${not empty employee.departmentName}">
                                        <div class="info-value fw-bold">
                                            <i class="bi bi-building me-2 text-muted"></i>
                                            <c:out value="${employee.departmentName}"/>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-secondary py-2 px-3 border m-0 rounded-3 text-secondary" style="font-size: 0.9rem;">
                                            <i class="bi bi-info-circle me-1"></i> No department assigned
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- SECTION 3: Contract Info -->
                        <div class="detail-card flex-grow-1" id="section-contract-info">
                            <h2 class="h5 card-title-border">
                                <i class="bi bi-file-earmark-text-fill" style="color: var(--primary-color);"></i>
                                Latest Contract Info
                            </h2>
                            <c:choose>
                                <%-- Case: Has Contract --%>
                                <c:when test="${not empty employee.latestContract}">
                                    <div class="row g-3">
                                        <div class="col-12">
                                            <div class="info-label">Contract Type</div>
                                            <div class="info-value fw-semibold"><c:out value="${employee.latestContract.contractType}"/></div>
                                        </div>
                                        
                                        <div class="col-12">
                                            <div class="info-label">Contract Status</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${employee.latestContract.status == 'Active'}">
                                                        <span class="status-badge badge-contract-active"><i class="bi bi-check-circle-fill"></i> Active</span>
                                                    </c:when>
                                                    <c:when test="${employee.latestContract.status == 'Pending_Approval' || employee.latestContract.status == 'Pending'}">
                                                        <span class="status-badge badge-contract-pending"><i class="bi bi-clock-fill"></i> Pending Approval</span>
                                                    </c:when>
                                                    <c:when test="${employee.latestContract.status == 'Draft'}">
                                                        <span class="status-badge badge-contract-draft"><i class="bi bi-file-earmark-code"></i> Draft</span>
                                                    </c:when>
                                                    <c:when test="${employee.latestContract.status == 'Expired'}">
                                                        <span class="status-badge badge-contract-expired"><i class="bi bi-exclamation-octagon-fill"></i> Expired</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary"><c:out value="${employee.latestContract.status}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="info-label">Base Salary</div>
                                            <div class="info-value fw-bold text-dark">
                                                <fmt:setLocale value="vi_VN"/>
                                                <fmt:formatNumber value="${employee.latestContract.baseSalary}" type="currency"/>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-label">Allowance</div>
                                            <div class="info-value text-dark">
                                                <fmt:setLocale value="vi_VN"/>
                                                <fmt:formatNumber value="${employee.latestContract.allowance}" type="currency"/>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <div class="info-label">Start Date</div>
                                            <div class="info-value">
                                                <i class="bi bi-calendar-event me-2 text-muted"></i>
                                                <c:out value="${employee.latestContract.startDate}"/>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="info-label">End Date</div>
                                            <div class="info-value">
                                                <i class="bi bi-calendar-x me-2 text-muted"></i>
                                                <c:choose>
                                                    <c:when test="${not empty employee.latestContract.endDate}">
                                                        <c:out value="${employee.latestContract.endDate}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted italic">Indefinite</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                
                                <%-- Case: No Contract --%>
                                <c:otherwise>
                                    <div class="alert alert-secondary p-4 rounded-3 text-center my-3 text-secondary" style="font-size: 0.95rem;">
                                        <i class="bi bi-file-earmark-x fs-2 d-block mb-2 opacity-50"></i>
                                        No contract available
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-top py-4 mt-auto">
        <div class="container text-center">
            <p class="m-0 footer-text">&copy; 2026 Antigravity HRM System. All rights reserved. Designed for HR Operations.</p>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
</body>
</html>
