<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Recruitment List – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body { background-color:#f1f5f9; font-family:'Segoe UI',system-ui,sans-serif; color:#1e293b; }

        .topbar {
            background:linear-gradient(135deg,#4f46e5 0%,#7c3aed 100%);
            padding:1.25rem 2rem; color:#fff;
            box-shadow:0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 { font-size:1.25rem; font-weight:700; margin:0; }
        .topbar p  { font-size:.82rem; opacity:.85; margin:0; }

        .bc { --bs-breadcrumb-divider:'›'; font-size:.83rem; }
        .bc a { color:#e0e7ff; text-decoration:none; }
        .bc a:hover { color:#fff; text-decoration:underline; }
        .bc .active { color:#c7d2fe; }

        .card-custom { border:none; border-radius:16px; box-shadow:0 4px 24px rgba(0,0,0,.06); }
        .card-custom .card-header {
            background:#fff; border-bottom:1px solid #e2e8f0;
            border-radius:16px 16px 0 0 !important; padding:1.25rem 1.5rem;
        }

        .filter-bar {
            background:#fff; border-radius:12px; padding:1.1rem 1.25rem;
            box-shadow:0 2px 12px rgba(0,0,0,.04); margin-bottom:1.5rem;
            display:flex; flex-wrap:wrap; gap:.75rem; align-items:flex-end;
        }
        .filter-label {
            font-size:.72rem; font-weight:600; text-transform:uppercase;
            letter-spacing:.4px; color:#64748b; display:block; margin-bottom:.25rem;
        }
        .form-control,.form-select {
            border-radius:10px; border:1.5px solid #e2e8f0;
            font-size:.85rem; height:38px;
        }
        .form-control:focus,.form-select:focus {
            border-color:#4f46e5; box-shadow:0 0 0 3px rgba(79,70,229,.1);
        }

        .count-badge {
            background:#e0e7ff; color:#4f46e5;
            font-size:.75rem; font-weight:700;
            border-radius:20px; padding:.2rem .65rem;
        }

        .table thead th {
            background:#4f46e5; color:#fff;
            font-size:.78rem; font-weight:600;
            letter-spacing:.5px; text-transform:uppercase;
            border:none; padding:.9rem 1rem; white-space:nowrap;
        }
        .table tbody tr { transition:background .15s; }
        .table tbody tr:hover { background-color:#f0f4ff; }
        .table tbody td {
            vertical-align:middle; font-size:.88rem;
            padding:.85rem 1rem; border-color:#f1f5f9;
        }

        .salary-pill {
            background:#f0fdf4; color:#166534;
            border-radius:8px; padding:.15rem .55rem;
            font-size:.8rem; font-weight:600;
        }

        /* Status badges */
        .badge-new      { background:#dbeafe; color:#1e40af; }
        .badge-waiting  { background:#fef3c7; color:#92400e; }
        .badge-applied  { background:#d1fae5; color:#065f46; }
        .badge-rejected { background:#fee2e2; color:#991b1b; }
        .badge-deleted  { background:#f1f5f9; color:#475569; }

        .empty-state { padding:4rem; color:#94a3b8; }

        .stat-chip {
            background:#fff; border-radius:12px;
            padding:.75rem 1.25rem; box-shadow:0 2px 10px rgba(0,0,0,.05);
            display:flex; align-items:center; gap:.75rem;
        }
        .stat-icon {
            width:40px; height:40px; border-radius:10px;
            display:flex; align-items:center; justify-content:center; font-size:1.1rem;
        }
        .stat-value { font-size:1.25rem; font-weight:700; line-height:1; }
        .stat-label { font-size:.72rem; color:#94a3b8; font-weight:500; }
    </style>
</head>
<body>

<!-- ═══ Top bar ══════════════════════════════════════════ -->
<div class="topbar d-flex flex-wrap align-items-center justify-content-between gap-3">
    <div class="d-flex align-items-center gap-3">
        <i class="bi bi-briefcase-fill fs-4"></i>
        <div>
            <h1>Recruitment List</h1>
            <p>Human Resources &rsaquo; Recruitment Management</p>
        </div>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb bc mb-0">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"><i class="bi bi-house-door-fill me-1"></i>Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Recruitment</li>
        </ol>
    </nav>
</div>

<!-- ═══ Content ══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4">

    <%-- ── Success Flash ── --%>
    <c:if test="${not empty successMessage}">
        <div id="successAlert" class="alert alert-success d-flex align-items-center gap-2 mb-4"
             style="border-radius:12px; border:none; font-size:.9rem;" role="alert">
            <i class="bi bi-check-circle-fill fs-5"></i>
            <c:out value="${successMessage}"/>
            <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- ── Stat Chips ── --%>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#e0e7ff;">
                    <i class="bi bi-briefcase text-primary"></i>
                </div>
                <div>
                    <div class="stat-value">${recruitments.size()}</div>
                    <div class="stat-label">Total Jobs</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#d1fae5;">
                    <i class="bi bi-eye text-success"></i>
                </div>
                <div>
                    <div class="stat-value" id="statVisible">${recruitments.size()}</div>
                    <div class="stat-label">Showing</div>
                </div>
            </div>
        </div>
    </div>

    <%-- ── Filter Bar ── --%>
    <div class="filter-bar">
        <div style="flex:1;min-width:180px;">
            <label for="filterTitle" class="filter-label"><i class="bi bi-search me-1"></i>Job Title</label>
            <input type="text" id="filterTitle" class="form-control"
                   placeholder="Search job title…" oninput="applyFilters()"/>
        </div>
        <div style="min-width:160px;">
            <label for="filterStatus" class="filter-label"><i class="bi bi-circle-half me-1"></i>Status</label>
            <select id="filterStatus" class="form-select" onchange="applyFilters()">
                <option value="">All Statuses</option>
                <option value="New">New</option>
                <option value="Waiting">Waiting</option>
                <option value="Applied">Applied</option>
                <option value="Rejected">Rejected</option>
                <option value="Deleted">Deleted</option>
            </select>
        </div>
        <div>
            <label style="visibility:hidden;" class="filter-label">Reset</label>
            <button class="btn d-block"
                    style="border-radius:10px;height:38px;font-size:.85rem;border:1.5px solid #e2e8f0;background:#f1f5f9;color:#475569;"
                    onclick="resetFilters()">
                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
            </button>
        </div>
        <%-- spacer + Add button --%>
        <div class="ms-auto">
            <label style="visibility:hidden;" class="filter-label">Add</label>
            <a href="${pageContext.request.contextPath}/recruitment/create"
               class="btn d-block fw-semibold"
               style="border-radius:10px;height:38px;background:#4f46e5;color:#fff;border:none;font-size:.85rem;padding:0 1.1rem;line-height:36px;">
                <i class="bi bi-plus-lg me-1"></i>Add Job
            </a>
        </div>
    </div>

    <%-- ── Main Card ── --%>
    <div class="card card-custom">
        <div class="card-header d-flex align-items-center justify-content-between gap-2 flex-wrap">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-bold text-dark">Recruitment Records</span>
                <span class="count-badge" id="countBadge">${recruitments.size()} records</span>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="recruitTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>ID</th>
                            <th>Job Title</th>
                            <th>Location</th>
                            <th>Salary</th>
                            <th>Status</th>
                            <th>Posted Date</th>
                            <th>Applicants</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="recruitBody">
                        <c:choose>
                            <c:when test="${empty recruitments}">
                                <tr>
                                    <td colspan="9" class="text-center empty-state">
                                        <i class="bi bi-briefcase fs-1 d-block mb-2"></i>
                                        No recruitment records found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="r" items="${recruitments}" varStatus="loop">
                                    <tr data-title="${r.jobTitle}" data-status="${r.status}">
                                        <td class="text-muted">${loop.count}</td>
                                        <td><span class="fw-semibold text-primary">#<c:out value="${r.recruitmentId}"/></span></td>
                                        <td><span class="fw-medium"><c:out value="${r.jobTitle}"/></span></td>
                                        <td><c:out value="${r.location}"/></td>
                                        <td>
                                            <span class="salary-pill">
                                                <fmt:formatNumber value="${r.salary}" type="currency"
                                                                  currencySymbol="₫" groupingUsed="true"/>
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'New'}">
                                                    <span class="badge badge-new rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.4rem;vertical-align:middle;"></i>New
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Waiting'}">
                                                    <span class="badge badge-waiting rounded-pill px-3 py-1">
                                                        <i class="bi bi-clock-fill me-1" style="font-size:.4rem;vertical-align:middle;"></i>Waiting
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Applied'}">
                                                    <span class="badge badge-applied rounded-pill px-3 py-1">
                                                        <i class="bi bi-check-circle-fill me-1" style="font-size:.4rem;vertical-align:middle;"></i>Applied
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Rejected'}">
                                                    <span class="badge badge-rejected rounded-pill px-3 py-1">
                                                        <i class="bi bi-x-circle-fill me-1" style="font-size:.4rem;vertical-align:middle;"></i>Rejected
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Deleted'}">
                                                    <span class="badge badge-deleted rounded-pill px-3 py-1">Deleted</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill px-3 py-1">
                                                        <c:out value="${r.status}" default="Unknown"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty r.postedDate}">
                                                    <c:out value="${r.postedDate.format(dateFormatter)}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center fw-semibold">
                                            <c:out value="${r.applicant}"/>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-1">
                                                <a href="${pageContext.request.contextPath}/recruitment/detail?id=${r.recruitmentId}"
                                                   class="btn btn-outline-primary btn-sm"
                                                   style="border-radius:8px;font-size:.75rem;padding:.25rem .65rem;"
                                                   title="View Detail">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card-footer bg-white text-muted border-top border-light"
             style="font-size:.8rem;border-radius:0 0 16px 16px;">
            Showing <span id="footerCount">0</span> of ${recruitments.size()} records
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function applyFilters() {
        const title  = document.getElementById('filterTitle').value.toLowerCase();
        const status = document.getElementById('filterStatus').value;
        const rows   = document.querySelectorAll('#recruitBody tr[data-title]');
        let visible  = 0;

        rows.forEach(row => {
            const show = (title === '' || (row.dataset.title || '').toLowerCase().includes(title)) &&
                         (status === '' || row.dataset.status === status);
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        document.getElementById('statVisible').textContent = visible;
        document.getElementById('countBadge').textContent  = visible + ' records';
        document.getElementById('footerCount').textContent = visible;
    }

    function resetFilters() {
        document.getElementById('filterTitle').value  = '';
        document.getElementById('filterStatus').value = '';
        applyFilters();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const total = document.querySelectorAll('#recruitBody tr[data-title]').length;
        document.getElementById('footerCount').textContent = total;
    });
</script>
</body>
</html>
