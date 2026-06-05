<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Contract Detail – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body { background-color:#f1f5f9; font-family:'Segoe UI',system-ui,sans-serif; color:#1e293b; }

        .topbar {
            background:linear-gradient(135deg,#4f46e5 0%,#7c3aed 100%);
            padding:1rem 2rem; color:#fff;
            box-shadow:0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 { font-size:1.2rem; font-weight:700; margin:0; }
        .topbar p  { font-size:.82rem; opacity:.8; margin:0; }

        /* Section cards */
        .section-card {
            border:none; border-radius:16px;
            box-shadow:0 2px 16px rgba(0,0,0,.06);
            margin-bottom:1.5rem;
        }
        .section-card .card-header {
            background:#fff;
            border-bottom:1px solid #e2e8f0;
            border-radius:16px 16px 0 0 !important;
            padding:.85rem 1.5rem;
            font-weight:600; font-size:.9rem;
            display:flex; align-items:center; gap:.6rem;
        }
        .icon-box {
            width:32px; height:32px; border-radius:8px;
            display:inline-flex; align-items:center; justify-content:center; font-size:1rem;
        }
        .icon-employee   { background:#e0e7ff; color:#4f46e5; }
        .icon-contract   { background:#fef3c7; color:#d97706; }
        .icon-salary     { background:#d1fae5; color:#059669; }
        .icon-additional { background:#f3e8ff; color:#7c3aed; }

        /* Info rows */
        .info-row { padding:.75rem 0; border-bottom:1px solid #f1f5f9; }
        .info-row:last-child { border-bottom:none; }
        .info-label {
            font-size:.75rem; font-weight:600;
            text-transform:uppercase; letter-spacing:.5px; color:#94a3b8; margin-bottom:.2rem;
        }
        .info-value { font-size:.9rem; color:#1e293b; font-weight:500; }
        .info-value.empty { color:#cbd5e1; font-style:italic; font-weight:400; }

        /* Status badges */
        .badge-draft     { background:#e2e8f0; color:#475569; }
        .badge-pending   { background:#fef3c7; color:#92400e; }
        .badge-approved  { background:#dbeafe; color:#1e40af; }
        .badge-rejected  { background:#fee2e2; color:#991b1b; }
        .badge-active    { background:#d1fae5; color:#065f46; }
        .badge-expired   { background:#1e293b; color:#f8fafc; }

        /* Avatar */
        .avatar-lg {
            width:72px; height:72px; border-radius:50%;
            background:linear-gradient(135deg,#4f46e5,#7c3aed);
            color:#fff; font-size:1.8rem; font-weight:700;
            display:flex; align-items:center; justify-content:center;
            box-shadow:0 4px 14px rgba(79,70,229,.3); flex-shrink:0;
        }

        /* Salary highlight */
        .salary-box {
            background:linear-gradient(135deg,#f0fdf4,#dcfce7);
            border-radius:12px; padding:1rem 1.25rem;
            border-left:4px solid #22c55e;
        }
        .allowance-box {
            background:linear-gradient(135deg,#eff6ff,#dbeafe);
            border-radius:12px; padding:1rem 1.25rem;
            border-left:4px solid #3b82f6;
        }
        .box-label { font-size:.72rem; font-weight:600; text-transform:uppercase; letter-spacing:.5px; color:#64748b; }
        .box-value { font-size:1.4rem; font-weight:800; margin-top:.15rem; }

        .not-found-box {
            border-radius:16px; padding:3.5rem 2rem; text-align:center;
            background:#fff; box-shadow:0 2px 16px rgba(0,0,0,.06);
        }
        .btn-back { border-radius:10px; font-size:.85rem; padding:.45rem 1.1rem; }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-file-earmark-text-fill fs-4"></i>
    <div>
        <h1>Contract Detail</h1>
        <p>Human Resources &rsaquo; Contract Management &rsaquo; Detail</p>
    </div>
</div>

<!-- ═══ Content ═══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width:960px;">

    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/contract-list"
           class="btn btn-outline-secondary btn-back">
            <i class="bi bi-arrow-left me-1"></i>Back to Contract List
        </a>
    </div>

    <%-- Error / validation failure --%>
    <c:if test="${not empty errorMessage}">
        <div class="not-found-box">
            <i class="bi bi-exclamation-triangle-fill text-warning fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Invalid Request</h5>
            <p class="text-muted mb-0"><c:out value="${errorMessage}"/></p>
        </div>
    </c:if>

    <%-- Contract not found --%>
    <c:if test="${empty errorMessage and empty contract}">
        <div class="not-found-box">
            <i class="bi bi-file-earmark-x text-secondary fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Contract Not Found</h5>
            <p class="text-muted mb-0">No contract exists with the requested ID.</p>
        </div>
    </c:if>

    <%-- ════ Contract found ═══════════════════════════════ --%>
    <c:if test="${not empty contract}">

        <%-- Hero header --%>
        <div class="card section-card mb-4">
            <div class="card-body p-4 d-flex align-items-center gap-4 flex-wrap">
                <div class="avatar-lg">
                    <c:choose>
                        <c:when test="${not empty contract.employeeName}">
                            ${contract.employeeName.substring(0,1).toUpperCase()}
                        </c:when>
                        <c:otherwise>?</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 class="fw-bold mb-1">
                        <c:out value="${contract.employeeName}" default="Unknown Employee"/>
                    </h4>
                    <div class="text-muted mb-2" style="font-size:.85rem;">
                        <c:out value="${contract.contractType}" default="Contract"/>
                        <c:if test="${not empty contract.departmentName}">
                            &nbsp;·&nbsp;<c:out value="${contract.departmentName}"/>
                        </c:if>
                    </div>
                    <%-- Status badge --%>
                    <c:choose>
                        <c:when test="${contract.status == 'Draft'}">
                            <span class="badge badge-draft rounded-pill px-3 py-1">Draft</span>
                        </c:when>
                        <c:when test="${contract.status == 'Pending_Approval'}">
                            <span class="badge badge-pending rounded-pill px-3 py-1">
                                <i class="bi bi-clock me-1"></i>Pending Approval
                            </span>
                        </c:when>
                        <c:when test="${contract.status == 'Approved'}">
                            <span class="badge badge-approved rounded-pill px-3 py-1">
                                <i class="bi bi-check me-1"></i>Approved
                            </span>
                        </c:when>
                        <c:when test="${contract.status == 'Rejected'}">
                            <span class="badge badge-rejected rounded-pill px-3 py-1">
                                <i class="bi bi-x me-1"></i>Rejected
                            </span>
                        </c:when>
                        <c:when test="${contract.status == 'Active'}">
                            <span class="badge badge-active rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Active
                            </span>
                        </c:when>
                        <c:when test="${contract.status == 'Expired'}">
                            <span class="badge badge-expired rounded-pill px-3 py-1">Expired</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary rounded-pill px-3 py-1">
                                <c:out value="${contract.status}" default="Unknown"/>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="ms-auto text-end">
                    <div class="text-muted" style="font-size:.8rem;">Contract ID</div>
                    <div class="fw-bold text-primary fs-4">#<c:out value="${contract.contractId}"/></div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">

                <%-- ── Employee Information ─────────────────────── --%>
                <div class="card section-card">
                    <div class="card-header">
                        <span class="icon-box icon-employee"><i class="bi bi-person-fill"></i></span>
                        Employee Information
                    </div>
                    <div class="card-body px-4 py-2">
                        <div class="info-row">
                            <div class="info-label">Employee ID</div>
                            <div class="info-value">#<c:out value="${contract.employeeId}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Full Name</div>
                            <div class="info-value fw-semibold">
                                <c:out value="${contract.employeeName}" default="—"/>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Department</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty contract.departmentName}">
                                        <i class="bi bi-building me-1 text-success"></i>
                                        <c:out value="${contract.departmentName}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty">No department assigned</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ── Contract Information ────────────────────── --%>
                <div class="card section-card">
                    <div class="card-header">
                        <span class="icon-box icon-contract"><i class="bi bi-file-earmark-text"></i></span>
                        Contract Information
                    </div>
                    <div class="card-body px-4 py-2">
                        <div class="info-row">
                            <div class="info-label">Contract Type</div>
                            <div class="info-value"><c:out value="${contract.contractType}" default="—"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Start Date</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty contract.startDate}">
                                        <c:out value="${contract.startDate}"/>
                                    </c:when>
                                    <c:otherwise><span class="empty">Not set</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">End Date</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty contract.endDate}">
                                        <c:out value="${contract.endDate}"/>
                                    </c:when>
                                    <c:otherwise><span class="empty">Open-ended</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status</div>
                            <div class="info-value">
                                <c:out value="${contract.status}" default="—"/>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="col-md-6">

                <%-- ── Compensation ─────────────────────────────── --%>
                <div class="card section-card">
                    <div class="card-header">
                        <span class="icon-box icon-salary"><i class="bi bi-currency-dollar"></i></span>
                        Compensation
                    </div>
                    <div class="card-body p-4">
                        <div class="salary-box mb-3">
                            <div class="box-label">Base Salary</div>
                            <div class="box-value text-success">
                                <c:choose>
                                    <c:when test="${not empty contract.baseSalary}">
                                        <fmt:formatNumber value="${contract.baseSalary}" type="number" groupingUsed="true"/> ₫
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="allowance-box">
                            <div class="box-label">Allowance</div>
                            <div class="box-value text-primary">
                                <c:choose>
                                    <c:when test="${not empty contract.allowance}">
                                        <fmt:formatNumber value="${contract.allowance}" type="number" groupingUsed="true"/> ₫
                                    </c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- ── Additional Information ──────────────────── --%>
                <div class="card section-card">
                    <div class="card-header">
                        <span class="icon-box icon-additional"><i class="bi bi-info-circle-fill"></i></span>
                        Additional Information
                    </div>
                    <div class="card-body px-4 py-2">
                        <div class="info-row">
                            <div class="info-label">Notes</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty contract.notes}">
                                        <c:out value="${contract.notes}"/>
                                    </c:when>
                                    <c:otherwise><span class="empty">No notes</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Created Date</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty contract.createdAt}">
                                        <c:out value="${contract.createdAt}"/>
                                    </c:when>
                                    <c:otherwise><span class="empty">—</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </c:if><%-- end contract not empty --%>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
