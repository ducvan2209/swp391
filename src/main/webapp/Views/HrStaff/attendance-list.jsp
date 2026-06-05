<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Attendance List – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body {
            background-color: #f1f5f9;
            font-family: 'Segoe UI', system-ui, sans-serif;
            color: #1e293b;
        }

        /* ── Top bar ─────────────────────────────────── */
        .topbar {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 1rem 2rem;
            color: #fff;
            box-shadow: 0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 { font-size: 1.25rem; font-weight: 700; margin: 0; letter-spacing: .3px; }
        .topbar p  { font-size: .82rem; opacity: .8; margin: 0; }

        /* ── Card ────────────────────────────────────── */
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

        /* ── Filter bar ──────────────────────────────── */
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
            box-shadow: 0 0 0 3px rgba(79,70,229,.1);
        }

        /* ── Count badge ─────────────────────────────── */
        .count-badge {
            background: #e0e7ff;
            color: #4f46e5;
            font-size: .75rem;
            font-weight: 700;
            border-radius: 20px;
            padding: .2rem .65rem;
        }

        /* ── Table ───────────────────────────────────── */
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
        .table tbody tr { transition: background .15s; }
        .table tbody tr:hover { background-color: #f0f4ff; }
        .table tbody td {
            vertical-align: middle;
            font-size: .855rem;
            padding: .72rem 1rem;
            border-color: #f1f5f9;
        }

        /* ── Avatar ──────────────────────────────────── */
        .avatar {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: #e0e7ff;
            color: #4f46e5;
            font-weight: 700;
            font-size: .78rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        /* ── Working hours pill ──────────────────────── */
        .hours-badge {
            background: #f0fdf4;
            color: #166534;
            border-radius: 8px;
            padding: .15rem .55rem;
            font-size: .8rem;
            font-weight: 600;
        }
        .overtime-badge {
            background: #fef3c7;
            color: #92400e;
            border-radius: 8px;
            padding: .15rem .55rem;
            font-size: .8rem;
            font-weight: 600;
        }
        .overtime-zero {
            color: #94a3b8;
            font-size: .8rem;
        }

        /* ── Empty state ─────────────────────────────── */
        .empty-state { padding: 3.5rem; color: #94a3b8; }

        /* ── Summary stat chips ──────────────────────── */
        .stat-chip {
            background: #fff;
            border-radius: 12px;
            padding: .75rem 1.25rem;
            box-shadow: 0 2px 10px rgba(0,0,0,.05);
            display: flex;
            align-items: center;
            gap: .75rem;
        }
        .stat-chip .stat-icon {
            width: 40px; height: 40px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
        }
        .stat-chip .stat-value { font-size: 1.25rem; font-weight: 700; line-height: 1; }
        .stat-chip .stat-label { font-size: .72rem; color: #94a3b8; font-weight: 500; }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-calendar-check-fill fs-4"></i>
    <div>
        <h1>Attendance List</h1>
        <p>Human Resources &rsaquo; Attendance Management</p>
    </div>
</div>

<!-- ═══ Content ═══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4">

    <%-- ── Summary stat chips ──────────────────────── --%>
    <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#e0e7ff;">
                    <i class="bi bi-calendar2-check text-primary"></i>
                </div>
                <div>
                    <div class="stat-value" id="statTotal">${attendances.size()}</div>
                    <div class="stat-label">Total Records</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-chip">
                <div class="stat-icon" style="background:#d1fae5;">
                    <i class="bi bi-clock-fill text-success"></i>
                </div>
                <div>
                    <div class="stat-value" id="statVisible">${attendances.size()}</div>
                    <div class="stat-label">Showing</div>
                </div>
            </div>
        </div>
    </div>

    <%-- ── Filter bar ───────────────────────────────── --%>
    <div class="filter-bar">
        <%-- Name search --%>
        <div style="flex:1;min-width:180px;">
            <label for="filterName"><i class="bi bi-search me-1"></i>Employee Name</label>
            <input type="text" id="filterName" class="form-control"
                   placeholder="Search name…" oninput="applyFilters()"/>
        </div>

        <%-- Department filter — populated from data --%>
        <div style="min-width:160px;">
            <label for="filterDept"><i class="bi bi-building me-1"></i>Department</label>
            <select id="filterDept" class="form-select" onchange="applyFilters()">
                <option value="">All Departments</option>
                <%-- filled by JS from table data --%>
            </select>
        </div>

        <%-- Date from --%>
        <div style="min-width:150px;">
            <label for="filterDateFrom"><i class="bi bi-calendar3 me-1"></i>Date From</label>
            <input type="date" id="filterDateFrom" class="form-control" oninput="applyFilters()"/>
        </div>

        <%-- Date to --%>
        <div style="min-width:150px;">
            <label for="filterDateTo">Date To</label>
            <input type="date" id="filterDateTo" class="form-control" oninput="applyFilters()"/>
        </div>

        <%-- Reset --%>
        <div>
            <label style="visibility:hidden;">Reset</label>
            <button class="btn btn-outline-secondary d-block"
                    style="border-radius:10px;height:36px;font-size:.83rem;"
                    onclick="resetFilters()">
                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
            </button>
        </div>
    </div>

    <%-- ── Main card ─────────────────────────────────── --%>
    <div class="card card-custom">

        <div class="card-header d-flex align-items-center justify-content-between gap-2 flex-wrap">
            <div class="d-flex align-items-center gap-2">
                <span class="fw-semibold text-dark">Attendance Records</span>
                <span class="count-badge" id="countBadge">${attendances.size()} records</span>
            </div>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="attendanceTable">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Att. ID</th>
                            <th>Employee</th>
                            <th>Department</th>
                            <th>Date</th>
                            <th>Check In</th>
                            <th>Check Out</th>
                            <th>Working Hrs</th>
                            <th>Overtime Hrs</th>
                        </tr>
                    </thead>
                    <tbody id="attendanceBody">
                        <c:choose>
                            <c:when test="${empty attendances}">
                                <tr id="emptyRow">
                                    <td colspan="9" class="text-center empty-state">
                                        <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
                                        No attendance records found.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="att" items="${attendances}" varStatus="loop">
                                    <tr data-name="${att.employeeName}"
                                        data-dept="${att.departmentName}"
                                        data-date="${att.date}">
                                        <td class="text-muted">${loop.count}</td>
                                        <td>
                                            <span class="fw-semibold text-primary">
                                                #<c:out value="${att.attendanceId}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div class="avatar">
                                                    <c:choose>
                                                        <c:when test="${not empty att.employeeName}">
                                                            ${att.employeeName.substring(0,1).toUpperCase()}
                                                        </c:when>
                                                        <c:otherwise>?</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <span class="fw-medium">
                                                    <c:out value="${att.employeeName}" default="—"/>
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.departmentName}">
                                                    <c:out value="${att.departmentName}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">—</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.date}">
                                                    <c:out value="${att.date}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.checkIn}">
                                                    <i class="bi bi-box-arrow-in-right text-success me-1"></i>
                                                    <c:out value="${att.checkIn}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.checkOut}">
                                                    <i class="bi bi-box-arrow-right text-danger me-1"></i>
                                                    <c:out value="${att.checkOut}"/>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.workingHours}">
                                                    <span class="hours-badge">
                                                        <c:out value="${att.workingHours}"/> h
                                                    </span>
                                                </c:when>
                                                <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty att.overtimeHours and att.overtimeHours > 0}">
                                                    <span class="overtime-badge">
                                                        +<c:out value="${att.overtimeHours}"/> h
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="overtime-zero">0 h</span>
                                                </c:otherwise>
                                            </c:choose>
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
             style="font-size:.8rem; border-radius:0 0 16px 16px;">
            Showing <span id="footerCount">0</span> of ${attendances.size()} records
        </div>
    </div>

</div><%-- /container --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ── Build department dropdown from live table data ────────────────────────
    (function buildDeptDropdown() {
        const depts = new Set();
        document.querySelectorAll('#attendanceBody tr[data-dept]').forEach(row => {
            const d = row.dataset.dept;
            if (d && d !== 'null') depts.add(d);
        });
        const sel = document.getElementById('filterDept');
        [...depts].sort().forEach(d => {
            const opt = document.createElement('option');
            opt.value = d;
            opt.textContent = d;
            sel.appendChild(opt);
        });
    })();

    // ── Filter engine ─────────────────────────────────────────────────────────
    function applyFilters() {
        const name     = document.getElementById('filterName').value.toLowerCase();
        const dept     = document.getElementById('filterDept').value;
        const dateFrom = document.getElementById('filterDateFrom').value; // yyyy-MM-dd
        const dateTo   = document.getElementById('filterDateTo').value;

        const rows = document.querySelectorAll('#attendanceBody tr[data-name]');
        let visible = 0;

        rows.forEach(row => {
            const rowName = (row.dataset.name || '').toLowerCase();
            const rowDept = row.dataset.dept || '';
            const rowDate = row.dataset.date || ''; // yyyy-MM-dd from LocalDate.toString()

            const nameMatch  = name === '' || rowName.includes(name);
            const deptMatch  = dept === '' || rowDept === dept;
            const fromMatch  = dateFrom === '' || rowDate >= dateFrom;
            const toMatch    = dateTo   === '' || rowDate <= dateTo;

            const show = nameMatch && deptMatch && fromMatch && toMatch;
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });

        // Update count displays
        document.getElementById('statVisible').textContent = visible;
        document.getElementById('countBadge').textContent  = visible + ' records';
        document.getElementById('footerCount').textContent = visible;

        // Empty state
        let noResult = document.getElementById('noResultRow');
        if (visible === 0 && rows.length > 0) {
            if (!noResult) {
                noResult = document.createElement('tr');
                noResult.id = 'noResultRow';
                noResult.innerHTML =
                    '<td colspan="9" class="text-center empty-state">' +
                    '<i class="bi bi-search fs-1 d-block mb-2"></i>' +
                    'No records match your filters.</td>';
                document.getElementById('attendanceBody').appendChild(noResult);
            }
            noResult.style.display = '';
        } else if (noResult) {
            noResult.style.display = 'none';
        }
    }

    function resetFilters() {
        document.getElementById('filterName').value     = '';
        document.getElementById('filterDept').value     = '';
        document.getElementById('filterDateFrom').value = '';
        document.getElementById('filterDateTo').value   = '';
        applyFilters();
    }

    // Init footer count on load
    document.addEventListener('DOMContentLoaded', () => {
        const total = document.querySelectorAll('#attendanceBody tr[data-name]').length;
        document.getElementById('footerCount').textContent = total;
        document.getElementById('statVisible').textContent = total;
    });
</script>
</body>
</html>
