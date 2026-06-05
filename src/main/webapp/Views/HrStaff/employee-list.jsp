<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>mvn clean
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Employee List – HR Management</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet" />

    <style>
        :root {
            --primary: #4f46e5;
            --primary-light: #e0e7ff;
            --sidebar-bg: #1e1b4b;
        }

        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', system-ui, sans-serif;
            color: #1e293b;
        }

        /* ── Top bar ──────────────────────────────────── */
        .topbar {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 1rem 2rem;
            color: #fff;
            box-shadow: 0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0;
            letter-spacing: .3px;
        }
        .topbar p {
            font-size: .82rem;
            opacity: .8;
            margin: 0;
        }

        /* ── Card ─────────────────────────────────────── */
        .card-custom {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,.07);
        }
        .card-custom .card-header {
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            border-radius: 16px 16px 0 0 !important;
            padding: 1rem 1.5rem;
        }

        /* ── Table ────────────────────────────────────── */
        .table thead th {
            background: var(--primary);
            color: #fff;
            font-size: .8rem;
            font-weight: 600;
            letter-spacing: .6px;
            text-transform: uppercase;
            border: none;
            padding: .85rem 1rem;
            white-space: nowrap;
        }
        .table tbody tr {
            transition: background .15s;
        }
        .table tbody tr:hover {
            background-color: #f0f4ff;
        }
        .table tbody td {
            vertical-align: middle;
            font-size: .875rem;
            padding: .75rem 1rem;
            border-color: #f1f5f9;
        }

        /* ── Status badges ────────────────────────────── */
        .badge-active   { background-color: #d1fae5; color: #065f46; }
        .badge-inactive { background-color: #fee2e2; color: #991b1b; }
        .badge-other    { background-color: #e0e7ff; color: #3730a3; }

        /* ── Avatar circle ────────────────────────────── */
        .avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: var(--primary-light);
            color: var(--primary);
            font-weight: 700;
            font-size: .8rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        /* ── Detail button ────────────────────────────── */
        .btn-detail {
            font-size: .78rem;
            padding: .3rem .75rem;
            border-radius: 8px;
            white-space: nowrap;
        }

        /* ── Search bar ───────────────────────────────── */
        #searchInput {
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            padding-left: 2.4rem;
        }
        .search-wrapper { position: relative; }
        .search-wrapper .bi-search {
            position: absolute;
            left: .75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        /* ── Count badge ──────────────────────────────── */
        .count-badge {
            background: var(--primary-light);
            color: var(--primary);
            font-size: .75rem;
            font-weight: 700;
            border-radius: 20px;
            padding: .2rem .65rem;
        }

        /* ── Empty state ──────────────────────────────── */
        .empty-state {
            padding: 3rem;
            color: #94a3b8;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-people-fill fs-4"></i>
    <div>
        <h1>Employee List</h1>
        <p>Human Resources &rsaquo; Staff Management</p>
    </div>
</div>

<!-- ═══ Main content ══════════════════════════════════════ -->
<div class="container-fluid px-4 py-4">

    <div class="card card-custom">

        <!-- Card header: title + search -->
        <div class="card-header d-flex flex-wrap align-items-center justify-content-between gap-3">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-semibold text-dark">All Employees</span>
                <span class="count-badge">
                    <c:out value="${fn:length(employees)}" default="${employees.size()}" />
                    &nbsp;records
                </span>
            </div>
            <div class="search-wrapper">
                <i class="bi bi-search"></i>
                <input type="text"
                       id="searchInput"
                       class="form-control form-control-sm"
                       placeholder="Search name, email, position…"
                       style="width:260px;"
                       oninput="filterTable()" />
            </div>
        </div>

        <!-- Table -->
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="employeeTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Emp ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <th>Position</th>
                            <th>Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="employeeTableBody">
                        <c:choose>
                            <c:when test="${empty employees}">
                                <tr>
                                    <td colspan="9" class="text-center empty-state">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        No employees found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="employee" items="${employees}" varStatus="loop">
                                    <tr>
                                        <td class="text-muted">${loop.count}</td>
                                        <td>
                                            <span class="fw-semibold text-primary">
                                                #<c:out value="${employee.employeeId}" />
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar">
                                                    <c:out value="${fn:toUpperCase(fn:substring(employee.fullName, 0, 1))}" default="?" />
                                                </div>
                                                <span class="fw-medium">
                                                    <c:out value="${employee.fullName}" />
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <a href="mailto:<c:out value='${employee.email}'/>"
                                               class="text-decoration-none text-dark">
                                                <c:out value="${employee.email}" default="—" />
                                            </a>
                                        </td>
                                        <td><c:out value="${employee.phone}" default="—" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty employee.departmentName}">
                                                    <c:out value="${employee.departmentName}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${employee.position}" default="—" /></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${employee.status == 'Active'}">
                                                    <span class="badge badge-active rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.5rem;"></i>Active
                                                    </span>
                                                </c:when>
                                                <c:when test="${employee.status == 'Inactive'}">
                                                    <span class="badge badge-inactive rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.5rem;"></i>Inactive
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-other rounded-pill px-3 py-1">
                                                        <c:out value="${employee.status}" default="Unknown" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="employee\detail?id=${employee.employeeId}"
                                               class="btn btn-outline-primary btn-sm btn-detail">
                                                <i class="bi bi-eye me-1"></i>Detail
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div><!-- /card-body -->

        <!-- Card footer: row count -->
        <div class="card-footer bg-white border-top border-light text-muted"
             style="font-size:.8rem; border-radius:0 0 16px 16px;">
            Showing <span id="visibleCount"></span> of ${employees.size()} employees
        </div>

    </div><!-- /card -->
</div><!-- /container -->

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // ── Live search ──────────────────────────────────────
    const totalRows = document.querySelectorAll('#employeeTableBody tr[data-searchable], #employeeTableBody tr').length;

    function filterTable() {
        const query = document.getElementById('searchInput').value.toLowerCase();
        const rows  = document.querySelectorAll('#employeeTableBody tr');
        let visible = 0;

        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            const match = text.includes(query);
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });

        document.getElementById('visibleCount').textContent = visible;
    }

    // Init count on page load
    document.addEventListener('DOMContentLoaded', () => {
        const rows = document.querySelectorAll('#employeeTableBody tr');
        document.getElementById('visibleCount').textContent = rows.length;
    });
</script>
</body>
</html>
