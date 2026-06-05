<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Contract List – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body { background-color:#f1f5f9; font-family:'Segoe UI',system-ui,sans-serif; color:#1e293b; }

        .topbar {
            background: linear-gradient(135deg,#4f46e5 0%,#7c3aed 100%);
            padding:1rem 2rem; color:#fff;
            box-shadow:0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 { font-size:1.25rem; font-weight:700; margin:0; }
        .topbar p  { font-size:.82rem; opacity:.8; margin:0; }

        .card-custom {
            border:none; border-radius:16px;
            box-shadow:0 4px 24px rgba(0,0,0,.07);
        }
        .card-custom .card-header {
            background:#fff; border-bottom:1px solid #e2e8f0;
            border-radius:16px 16px 0 0 !important;
            padding:1rem 1.5rem;
        }

        /* Filter bar */
        .filter-bar {
            background:#fff; border-radius:12px; padding:1rem 1.25rem;
            box-shadow:0 2px 12px rgba(0,0,0,.05); margin-bottom:1.25rem;
            display:flex; flex-wrap:wrap; gap:.75rem; align-items:flex-end;
        }
        .filter-bar label {
            font-size:.72rem; font-weight:600; text-transform:uppercase;
            letter-spacing:.4px; color:#64748b; display:block; margin-bottom:.25rem;
        }
        .filter-bar .form-control,
        .filter-bar .form-select {
            border-radius:10px; border:1.5px solid #e2e8f0;
            font-size:.83rem; height:36px;
        }
        .filter-bar .form-control:focus,
        .filter-bar .form-select:focus {
            border-color:#4f46e5; box-shadow:0 0 0 3px rgba(79,70,229,.1);
        }

        .count-badge {
            background:#e0e7ff; color:#4f46e5;
            font-size:.75rem; font-weight:700;
            border-radius:20px; padding:.2rem .65rem;
        }

        /* Table */
        .table thead th {
            background:#4f46e5; color:#fff;
            font-size:.78rem; font-weight:600;
            letter-spacing:.5px; text-transform:uppercase;
            border:none; padding:.85rem 1rem; white-space:nowrap;
        }
        .table tbody tr { transition:background .15s; }
        .table tbody tr:hover { background-color:#f0f4ff; }
        .table tbody td {
            vertical-align:middle; font-size:.855rem;
            padding:.72rem 1rem; border-color:#f1f5f9;
        }

        /* Avatar */
        .avatar {
            width:32px; height:32px; border-radius:50%;
            background:#e0e7ff; color:#4f46e5;
            font-weight:700; font-size:.78rem;
            display:inline-flex; align-items:center; justify-content:center;
        }

        /* Salary pill */
        .salary-pill {
            background:#f0fdf4; color:#166534;
            border-radius:8px; padding:.15rem .55rem;
            font-size:.8rem; font-weight:600;
        }
        .allowance-pill {
            background:#eff6ff; color:#1e40af;
            border-radius:8px; padding:.15rem .55rem;
            font-size:.8rem; font-weight:600;
        }

        /* Status badges */
        .badge-draft     { background:#e2e8f0; color:#475569; }
        .badge-pending   { background:#fef3c7; color:#92400e; }
        .badge-approved  { background:#dbeafe; color:#1e40af; }
        .badge-rejected  { background:#fee2e2; color:#991b1b; }
        .badge-active    { background:#d1fae5; color:#065f46; }
        .badge-expired   { background:#1e293b; color:#f8fafc; }

        .empty-state { padding:3.5rem; color:#94a3b8; }

        /* Stat chips */
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

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-file-earmark-text-fill fs-4"></i>
    <div>
        <h1>Contract List</h1>
        <p>Human Resources &rsaquo; Contract Management</p>
    </div>
</div>

<!-- ═══ Content ═══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4">

    <%-- ── Stat chips ─────────────────────────────────────── --%>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#e0e7ff;">
                    <i class="bi bi-file-earmark-check text-primary"></i>
                </div>
                <div>
                    <div class="stat-value">${contracts.size()}</div>
                    <div class="stat-label">Total Contracts</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#d1fae5;">
                    <i class="bi bi-check-circle-fill text-success"></i>
                </div>
                <div>
                    <div class="stat-value" id="statVisible">${contracts.size()}</div>
                    <div class="stat-label">Showing</div>
                </div>
            </div>
        </div>
    </div>

    <%-- ── Filter bar ─────────────────────────────────────── --%>
    <div class="filter-bar">
        <div style="flex:1;min-width:180px;">
            <label for="filterName"><i class="bi bi-search me-1"></i>Employee Name</label>
            <input type="text" id="filterName" class="form-control"
                   placeholder="Search name…" oninput="applyFilters()"/>
        </div>
        <div style="min-width:160px;">
            <label for="filterType"><i class="bi bi-tag me-1"></i>Contract Type</label>
            <select id="filterType" class="form-select" onchange="applyFilters()">
                <option value="">All Types</option>
            </select>
        </div>
        <div style="min-width:160px;">
            <label for="filterStatus"><i class="bi bi-circle-half me-1"></i>Status</label>
            <select id="filterStatus" class="form-select" onchange="applyFilters()">
                <option value="">All Statuses</option>
                <option value="Draft">Draft</option>
                <option value="Pending_Approval">Pending Approval</option>
                <option value="Approved">Approved</option>
                <option value="Rejected">Rejected</option>
                <option value="Active">Active</option>
                <option value="Expired">Expired</option>
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
                <span class="fw-semibold text-dark">Contract Records</span>
                <span class="count-badge" id="countBadge">${contracts.size()} records</span>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="contractTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Contract ID</th>
                            <th>Employee</th>
                            <th>Department</th>
                            <th>Type</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Base Salary</th>
                            <th>Allowance</th>
                            <th>Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="contractBody">
                        <c:choose>
                            <c:when test="${empty contracts}">
                                <tr>
                                    <td colspan="11" class="text-center empty-state">
                                        <i class="bi bi-file-earmark-x fs-1 d-block mb-2"></i>
                                        No contracts found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="ct" items="${contracts}" varStatus="loop">
                                    <tr data-name="${ct.employeeName}"
                                        data-type="${ct.contractType}"
                                        data-status="${ct.status}">

                                        <td class="text-muted">${loop.count}</td>

                                        <td>
                                            <span class="fw-semibold text-primary">
                                                #<c:out value="${ct.contractId}"/>
                                            </span>
                                        </td>

                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty ct.employeeName}">
                                                            ${ct.employeeName.substring(0,1).toUpperCase()}
                                                        </c:when>
                                                        <c:otherwise>?</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span class="fw-medium">
                                                    <c:out value="${ct.employeeName}" default="—"/>
                                                </span>
                                            </div>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ct.departmentName}">
                                                    <c:out value="${ct.departmentName}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td><c:out value="${ct.contractType}" default="—"/></td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ct.startDate}">
                                                    <c:out value="${ct.startDate}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ct.endDate}">
                                                    <c:out value="${ct.endDate}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted fst-italic">Open-ended</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ct.baseSalary}">
                                                    <span class="salary-pill">
                                                        <fmt:formatNumber value="${ct.baseSalary}" type="number" groupingUsed="true"/> ₫
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty ct.allowance}">
                                                    <span class="allowance-pill">
                                                        <fmt:formatNumber value="${ct.allowance}" type="number" groupingUsed="true"/> ₫
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${ct.status == 'Draft'}">
                                                    <span class="badge badge-draft rounded-pill px-3 py-1">Draft</span>
                                                </c:when>
                                                <c:when test="${ct.status == 'Pending_Approval'}">
                                                    <span class="badge badge-pending rounded-pill px-3 py-1">
                                                        <i class="bi bi-clock me-1"></i>Pending
                                                    </span>
                                                </c:when>
                                                <c:when test="${ct.status == 'Approved'}">
                                                    <span class="badge badge-approved rounded-pill px-3 py-1">
                                                        <i class="bi bi-check me-1"></i>Approved
                                                    </span>
                                                </c:when>
                                                <c:when test="${ct.status == 'Rejected'}">
                                                    <span class="badge badge-rejected rounded-pill px-3 py-1">
                                                        <i class="bi bi-x me-1"></i>Rejected
                                                    </span>
                                                </c:when>
                                                <c:when test="${ct.status == 'Active'}">
                                                    <span class="badge badge-active rounded-pill px-3 py-1">
                                                        <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Active
                                                    </span>
                                                </c:when>
                                                <c:when test="${ct.status == 'Expired'}">
                                                    <span class="badge badge-expired rounded-pill px-3 py-1">Expired</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary rounded-pill px-3 py-1">
                                                        <c:out value="${ct.status}" default="Unknown"/>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <a href="${pageContext.request.contextPath}/contract/detail?id=${ct.contractId}"
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
            Showing <span id="footerCount">0</span> of ${contracts.size()} contracts
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ── Populate Contract Type dropdown from live data ────────────────────────
    (function buildTypeDropdown() {
        const types = new Set();
        document.querySelectorAll('#contractBody tr[data-type]').forEach(row => {
            const t = row.dataset.type;
            if (t && t !== 'null') types.add(t);
        });
        const sel = document.getElementById('filterType');
        [...types].sort().forEach(t => {
            const opt = document.createElement('option');
            opt.value = t; opt.textContent = t;
            sel.appendChild(opt);
        });
    })();

    // ── Filter engine ─────────────────────────────────────────────────────────
    function applyFilters() {
        const name   = document.getElementById('filterName').value.toLowerCase();
        const type   = document.getElementById('filterType').value;
        const status = document.getElementById('filterStatus').value;

        const rows = document.querySelectorAll('#contractBody tr[data-name]');
        let visible = 0;

        rows.forEach(row => {
            const rowName   = (row.dataset.name   || '').toLowerCase();
            const rowType   =  row.dataset.type   || '';
            const rowStatus =  row.dataset.status || '';

            const show = (name === '' || rowName.includes(name)) &&
                         (type === '' || rowType === type) &&
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
                    '<td colspan="11" class="text-center empty-state">' +
                    '<i class="bi bi-search fs-1 d-block mb-2"></i>' +
                    'No contracts match your filters.</td>';
                document.getElementById('contractBody').appendChild(noResult);
            }
            noResult.style.display = '';
        } else if (noResult) {
            noResult.style.display = 'none';
        }
    }

    function resetFilters() {
        document.getElementById('filterName').value   = '';
        document.getElementById('filterType').value   = '';
        document.getElementById('filterStatus').value = '';
        applyFilters();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const total = document.querySelectorAll('#contractBody tr[data-name]').length;
        document.getElementById('footerCount').textContent = total;
    });
</script>
</body>
</html>
