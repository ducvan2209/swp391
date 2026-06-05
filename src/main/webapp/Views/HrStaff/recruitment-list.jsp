<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Recruitment List – HR Management</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', system-ui, sans-serif;
            color: #1e293b;
        }

        .topbar {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 1rem 2rem;
            color: #fff;
            box-shadow: 0 2px 8px rgba(79, 70, 229, .35);
        }
        .topbar h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0;
        }
        .topbar p  {
            font-size: .82rem;
            opacity: .8;
            margin: 0;
        }

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

        /* Filter bar */
        .filter-bar {
            background: #fff;
            border-radius: 12px;
            padding: 1rem 1.25rem;
            box-shadow: 0 2px 12px rgba(0,0,0,.05);
            margin-bottom: 1.25rem;
            display: flex;
            flex-wrap: wrap;
            gap: .75rem;
            align-items: flex-end;
        }
        .filter-bar label {
            font-size: .72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .4px;
            color: #64748b;
            display: block;
            margin-bottom: .25rem;
        }
        .filter-bar .form-control,
        .filter-bar .form-select {
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            font-size: .83rem;
            height: 36px;
        }
        .filter-bar .form-control:focus,
        .filter-bar .form-select:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, .1);
        }

        .count-badge {
            background: #e0e7ff;
            color: #4f46e5;
            font-size: .75rem;
            font-weight: 700;
            border-radius: 20px;
            padding: .2rem .65rem;
        }

        /* Table */
        .table thead th {
            background: #4f46e5;
            color: #fff;
            font-size: .78rem;
            font-weight: 600;
            letter-spacing: .5px;
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
            font-size: .855rem;
            padding: .72rem 1rem;
            border-color: #f1f5f9;
        }

        /* Salary pill */
        .salary-pill {
            background: #f0fdf4;
            color: #166534;
            border-radius: 8px;
            padding: .15rem .55rem;
            font-size: .8rem;
            font-weight: 600;
            display: inline-block;
        }

        /* Status badges */
        .badge-status-new      { background-color: #d1fae5; color: #065f46; }
        .badge-status-waiting  { background-color: #fef3c7; color: #92400e; }
        .badge-status-rejected { background-color: #fee2e2; color: #991b1b; }
        .badge-status-applied  { background-color: #dbeafe; color: #1e40af; }
        .badge-status-deleted  { background-color: #f1f5f9; color: #475569; }

        .empty-state {
            padding: 3.5rem;
            color: #94a3b8;
        }

        /* Stat chips */
        .stat-chip {
            background: #fff;
            border-radius: 12px;
            padding: .75rem 1.25rem;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
            display: flex;
            align-items: center;
            gap: .75rem;
        }
        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }
        .stat-value {
            font-size: 1.25rem;
            font-weight: 700;
            line-height: 1;
        }
        .stat-label {
            font-size: .72rem;
            color: #94a3b8;
            font-weight: 500;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-briefcase-fill fs-4"></i>
    <div>
        <h1>Recruitment List</h1>
        <p>Human Resources &rsaquo; Recruitment Management</p>
    </div>
</div>

<!-- ═══ Content ═══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4">

    <%-- ── Stat chips ─────────────────────────────────────── --%>
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

    <%-- ── Filter bar ─────────────────────────────────────── --%>
    <div class="filter-bar">
        <div style="flex:1;min-width:180px;">
            <label for="filterTitle"><i class="bi bi-search me-1"></i>Job Title</label>
            <input type="text" id="filterTitle" class="form-control"
                   placeholder="Search job title…" oninput="applyFilters()"/>
        </div>
        <div style="min-width:160px;">
            <label for="filterStatus"><i class="bi bi-circle-half me-1"></i>Status</label>
            <select id="filterStatus" class="form-select" onchange="applyFilters()">
                <option value="">All Statuses</option>
                <option value="New">New</option>
                <option value="Waiting">Waiting</option>
                <option value="Rejected">Rejected</option>
                <option value="Applied">Applied</option>
                <option value="Deleted">Deleted</option>
            </select>
        </div>
        <div>
            <label style="visibility:hidden;">Reset</label>
            <button class="btn btn-outline-secondary d-block"
                    style="border-radius:10px;height:36px;font-size:.83rem;"
                    onclick="resetFilters()">
                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
            </button>
        </div>
    </div>

    <%-- ── Main card ───────────────────────────────────────── --%>
    <div class="card card-custom">
        <div class="card-header d-flex align-items-center justify-content-between gap-2 flex-wrap">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-semibold text-dark">Recruitment Records</span>
                <span class="count-badge" id="countBadge">${recruitments.size()} records</span>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="recruitmentTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Recruitment ID</th>
                            <th>Job Title</th>
                            <th>Location</th>
                            <th>Salary</th>
                            <th>Status</th>
                            <th>Posted Date</th>
                            <th>Applicants</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="recruitmentBody">
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
                                        <td>
                                            <span class="fw-semibold text-primary">
                                                #<c:out value="${r.recruitmentId}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-medium">
                                                <c:out value="${r.jobTitle}"/>
                                            </span>
                                        </td>
                                        <td><c:out value="${r.location}"/></td>
                                        <td>
                                            <span class="salary-pill">
                                                <fmt:formatNumber value="${r.salary}" type="currency" currencySymbol="₫" groupingUsed="true" />
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.status == 'New'}">
                                                    <span class="badge badge-status-new rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>New
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Waiting'}">
                                                    <span class="badge badge-status-waiting rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Waiting
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Rejected'}">
                                                    <span class="badge badge-status-rejected rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Rejected
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Applied'}">
                                                    <span class="badge badge-status-applied rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Applied
                                                    </span>
                                                </c:when>
                                                <c:when test="${r.status == 'Deleted'}">
                                                    <span class="badge badge-status-deleted rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Deleted
                                                    </span>
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
                                                    <c:out value="${r.postedDate.format(dateFormatter)}" />
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">
                                                <c:out value="${r.applicant}"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/recruitment/detail?id=${r.recruitmentId}"
                                               class="btn btn-outline-primary btn-sm"
                                               style="border-radius:8px;font-size:.78rem;padding:.3rem .75rem;">
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
        </div>

        <div class="card-footer bg-white text-muted border-top border-light"
             style="font-size:.8rem;border-radius:0 0 16px 16px;">
            Showing <span id="footerCount">0</span> of ${recruitments.size()} records
        </div>
    </div>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ── Filter engine ─────────────────────────────────────────────────────────
    function applyFilters() {
        const title  = document.getElementById('filterTitle').value.toLowerCase();
        const status = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#recruitmentBody tr[data-title]');
        let visible = 0;

        rows.forEach(row => {
            const rowTitle  = (row.dataset.title  || '').toLowerCase();
            const rowStatus =  row.dataset.status || '';

            const show = (title === '' || rowTitle.includes(title)) &&
                         (status === '' || rowStatus === status);

            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        document.getElementById('statVisible').textContent = visible;
        document.getElementById('countBadge').textContent  = visible + ' records';
        document.getElementById('footerCount').textContent = visible;

        let noResult = document.getElementById('noResultRow');
        if (visible === 0 && rows.length > 0) {
            if (!noResult) {
                noResult = document.createElement('tr');
                noResult.id = 'noResultRow';
                noResult.innerHTML =
                    '<td colspan="9" class="text-center empty-state">' +
                    '<i class="bi bi-search fs-1 d-block mb-2"></i>' +
                    'No recruitment posts match your filters.</td>';
                document.getElementById('recruitmentBody').appendChild(noResult);
            }
            noResult.style.display = '';
        } else if (noResult) {
            noResult.style.display = 'none';
        }
    }

    function resetFilters() {
        document.getElementById('filterTitle').value  = '';
        document.getElementById('filterStatus').value = '';
        applyFilters();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const total = document.querySelectorAll('#recruitmentBody tr[data-title]').length;
        document.getElementById('footerCount').textContent = total;
        document.getElementById('statVisible').textContent = total;
        document.getElementById('countBadge').textContent  = total + ' records';
    });
</script>
</body>
</html>
