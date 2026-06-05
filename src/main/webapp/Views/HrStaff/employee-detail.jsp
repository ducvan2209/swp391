<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Employee Detail – HR Management</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet" />

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
            box-shadow: 0 2px 8px rgba(79, 70, 229, .35);
        }
        .topbar h1 {
            font-size: 1.2rem;
            font-weight: 700;
            margin: 0;
        }
        .topbar p {
            font-size: .82rem;
            opacity: .8;
            margin: 0;
        }

        /* ── Avatar ──────────────────────────────────── */
        .avatar-lg {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            color: #fff;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            box-shadow: 0 4px 16px rgba(79, 70, 229, .35);
        }

        /* ── Section card ────────────────────────────── */
        .section-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, .06);
            margin-bottom: 1.5rem;
        }
        .section-card .card-header {
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            border-radius: 16px 16px 0 0 !important;
            padding: .85rem 1.5rem;
            font-weight: 600;
            font-size: .9rem;
            display: flex;
            align-items: center;
            gap: .6rem;
        }
        .section-card .card-header .icon-box {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
        }
        .icon-employee { background: #e0e7ff; color: #4f46e5; }
        .icon-dept     { background: #d1fae5; color: #059669; }
        .icon-contract { background: #fef3c7; color: #d97706; }

        /* ── Info row ────────────────────────────────── */
        .info-label {
            font-size: .75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .5px;
            color: #94a3b8;
            margin-bottom: .2rem;
        }
        .info-value {
            font-size: .9rem;
            color: #1e293b;
            font-weight: 500;
        }
        .info-value.empty {
            color: #cbd5e1;
            font-style: italic;
            font-weight: 400;
        }

        /* ── Status badge ────────────────────────────── */
        .badge-active   { background-color: #d1fae5; color: #065f46; }
        .badge-inactive { background-color: #fee2e2; color: #991b1b; }
        .badge-other    { background-color: #e0e7ff; color: #3730a3; }

        /* ── Alert not found ─────────────────────────── */
        .not-found-box {
            border-radius: 16px;
            padding: 3.5rem 2rem;
            text-align: center;
            background: #fff;
            box-shadow: 0 2px 16px rgba(0,0,0,.06);
        }

        /* ── Back btn ────────────────────────────────── */
        .btn-back {
            border-radius: 10px;
            font-size: .85rem;
            padding: .45rem 1.1rem;
        }

        /* ── Divider row ─────────────────────────────── */
        .info-row {
            padding: .75rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .info-row:last-child { border-bottom: none; }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-person-lines-fill fs-4"></i>
    <div>
        <h1>Employee Detail</h1>
        <p>Human Resources &rsaquo; Staff Management &rsaquo; Detail</p>
    </div>
</div>

<!-- ═══ Main content ══════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width: 1000px;">

    <!-- ── Back button ──────────────────────────────── -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/employee-list"
           class="btn btn-outline-secondary btn-back">
            <i class="bi bi-arrow-left me-1"></i>Back to Employee List
        </a>
    </div>

    <%-- ══════════════════════════════════════════════
         CASE 1: System/validation error
    ════════════════════════════════════════════════ --%>
    <c:if test="${not empty errorMessage}">
        <div class="not-found-box">
            <i class="bi bi-exclamation-triangle-fill text-warning fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Invalid Request</h5>
            <p class="text-muted mb-0"><c:out value="${errorMessage}" /></p>
        </div>
    </c:if>

    <%-- ══════════════════════════════════════════════
         CASE 2: Employee not found
    ════════════════════════════════════════════════ --%>
    <c:if test="${empty errorMessage and empty employee}">
        <div class="not-found-box">
            <i class="bi bi-person-x-fill text-secondary fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Employee Not Found</h5>
            <p class="text-muted mb-0">
                No employee exists with the requested ID.
                Please go back and try again.
            </p>
        </div>
    </c:if>

    <%-- ══════════════════════════════════════════════
         CASE 3: Employee found → render full detail
    ════════════════════════════════════════════════ --%>
    <c:if test="${not empty employee}">

        <%-- ── Hero header ─────────────────────────── --%>
        <div class="section-card card mb-4">
            <div class="card-body p-4 d-flex align-items-center gap-4 flex-wrap">
                <div class="avatar-lg">
                    <c:choose>
                        <c:when test="${not empty employee.fullName}">
                            ${fn:toUpperCase(fn:substring(employee.fullName, 0, 1))}
                        </c:when>
                        <c:otherwise>?</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 class="fw-bold mb-1">
                        <c:out value="${employee.fullName}" default="—" />
                    </h4>
                    <div class="text-muted mb-2" style="font-size:.85rem;">
                        <c:out value="${employee.position}" default="No position" />
                        <c:if test="${not empty employee.departmentName}">
                            &nbsp;·&nbsp;<c:out value="${employee.departmentName}" />
                        </c:if>
                    </div>
                    <%-- Status badge --%>
                    <c:choose>
                        <c:when test="${employee.status == 'Active'}">
                            <span class="badge badge-active rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Active
                            </span>
                        </c:when>
                        <c:when test="${employee.status == 'Inactive'}">
                            <span class="badge badge-inactive rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Inactive
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-other rounded-pill px-3 py-1">
                                <c:out value="${employee.status}" default="Unknown" />
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="ms-auto">
                    <span class="text-muted" style="font-size:.8rem;">Employee ID</span>
                    <div class="fw-bold text-primary fs-5">#<c:out value="${employee.employeeId}" /></div>
                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 1 — Employee Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-employee"><i class="bi bi-person-fill"></i></span>
                Personal &amp; Contact Information
            </div>
            <div class="card-body px-4 py-2">
                <div class="row">

                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Full Name</div>
                            <div class="info-value"><c:out value="${employee.fullName}" default="—" /></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Gender</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employee.gender}">
                                        <c:out value="${employee.gender}" />
                                    </c:when>
                                    <c:otherwise><span class="empty">Not specified</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Date of Birth</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employee.dob}">
                                       
                                        <c:out value="${employee.dob}" />
                                    </c:when>
                                    <c:otherwise><span class="empty">Not provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Address</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employee.address}">
                                        <c:out value="${employee.address}" />
                                    </c:when>
                                    <c:otherwise><span class="empty">Not provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Phone</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employee.phone}">
                                        <a href="tel:<c:out value='${employee.phone}'/>"
                                           class="text-decoration-none text-dark">
                                            <i class="bi bi-telephone me-1 text-primary"></i>
                                            <c:out value="${employee.phone}" />
                                        </a>
                                    </c:when>
                                    <c:otherwise><span class="empty">Not provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty employee.email}">
                                        <a href="mailto:<c:out value='${employee.email}'/>"
                                           class="text-decoration-none text-dark">
                                            <i class="bi bi-envelope me-1 text-primary"></i>
                                            <c:out value="${employee.email}" />
                                        </a>
                                    </c:when>
                                    <c:otherwise><span class="empty">Not provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Position</div>
                            <div class="info-value">
                                <c:out value="${employee.position}" default="—" />
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status</div>
                            <div class="info-value">
                                <c:out value="${employee.status}" default="—" />
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 2 — Department Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-dept"><i class="bi bi-building"></i></span>
                Department Information
            </div>
            <div class="card-body px-4 py-2">
                <c:choose>
                    <c:when test="${not empty employee.departmentName}">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Department ID</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty employee.departmentId}">
                                                <c:out value="${employee.departmentId}" />
                                            </c:when>
                                            <c:otherwise><span class="empty">—</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Department Name</div>
                                    <div class="info-value">
                                        <i class="bi bi-building me-1 text-success"></i>
                                        <c:out value="${employee.departmentName}" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-building fs-3 d-block mb-2 opacity-25"></i>
                            No department assigned
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 3 — Latest Contract Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-contract"><i class="bi bi-file-earmark-text"></i></span>
                Latest Contract
            </div>
            <div class="card-body px-4 py-2">
                <c:choose>
                    <c:when test="${not empty employee.latestContract}">
                        <c:set var="c" value="${employee.latestContract}" />
                        <div class="row">

                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Contract ID</div>
                                    <div class="info-value">#<c:out value="${c.contractId}" /></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Contract Type</div>
                                    <div class="info-value">
                                        <c:out value="${c.contractType}" default="—" />
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Start Date</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty c.startDate}">
                                                <c:out value="${c.startDate}" />
                                            </c:when>
                                            <c:otherwise><span class="empty">—</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">End Date</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty c.endDate}">
                                                <c:out value="${c.endDate}" />
                                            </c:when>
                                            <c:otherwise><span class="empty">Open-ended</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Base Salary</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty c.baseSalary}">
                                                <fmt:formatNumber value="${c.baseSalary}"
                                                                  type="currency"
                                                                  currencySymbol="₫"
                                                                  groupingUsed="true" />
                                            </c:when>
                                            <c:otherwise><span class="empty">—</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Allowance</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty c.allowance}">
                                                <fmt:formatNumber value="${c.allowance}"
                                                                  type="currency"
                                                                  currencySymbol="₫"
                                                                  groupingUsed="true" />
                                            </c:when>
                                            <c:otherwise><span class="empty">—</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Contract Status</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${c.status == 'Active'}">
                                                <span class="badge badge-active rounded-pill px-3">Active</span>
                                            </c:when>
                                            <c:when test="${c.status == 'Expired' or c.status == 'Inactive'}">
                                                <span class="badge badge-inactive rounded-pill px-3">
                                                    <c:out value="${c.status}" />
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-other rounded-pill px-3">
                                                    <c:out value="${c.status}" default="—" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Notes</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty c.notes}">
                                                <c:out value="${c.notes}" />
                                            </c:when>
                                            <c:otherwise><span class="empty">No notes</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-file-earmark-x fs-3 d-block mb-2 opacity-25"></i>
                            No contract available
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </c:if><%-- end employee not empty --%>

</div><%-- /container --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
