<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Recruitment Detail – HR Management</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

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
        .icon-job   { background: #e0e7ff; color: #4f46e5; }
        .icon-desc  { background: #d1fae5; color: #059669; }
        .icon-req   { background: #fef3c7; color: #d97706; }

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

        /* Status badges */
        .badge-status-new      { background-color: #d1fae5; color: #065f46; }
        .badge-status-waiting  { background-color: #fef3c7; color: #92400e; }
        .badge-status-rejected { background-color: #fee2e2; color: #991b1b; }
        .badge-status-applied  { background-color: #dbeafe; color: #1e40af; }
        .badge-status-deleted  { background-color: #f1f5f9; color: #475569; }

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

        .text-pre {
            white-space: pre-wrap;
            font-family: inherit;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-briefcase-fill fs-4"></i>
    <div>
        <h1>Recruitment Detail</h1>
        <p>Human Resources &rsaquo; Recruitment Management &rsaquo; Detail</p>
    </div>
</div>

<!-- ═══ Main content ══════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width: 1000px;">

    <!-- ── Back button ──────────────────────────────── -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/recruitment/list"
           class="btn btn-outline-secondary btn-back">
            <i class="bi bi-arrow-left me-1"></i>Back to Recruitment List
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
         CASE 2: Recruitment post not found
    ════════════════════════════════════════════════ --%>
    <c:if test="${empty errorMessage and empty recruitment}">
        <div class="not-found-box">
            <i class="bi bi-briefcase-fill text-secondary fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Recruitment Post Not Found</h5>
            <p class="text-muted mb-0">
                No recruitment record exists with the requested ID.
                Please go back and try again.
            </p>
        </div>
    </c:if>

    <%-- ══════════════════════════════════════════════
         CASE 3: Recruitment post found → render details
    ════════════════════════════════════════════════ --%>
    <c:if test="${not empty recruitment}">

        <%-- ── Hero header ─────────────────────────── --%>
        <div class="section-card card mb-4">
            <div class="card-body p-4 d-flex align-items-center gap-4 flex-wrap">
                <div class="avatar-lg">
                    <i class="bi bi-briefcase-fill text-white fs-2"></i>
                </div>
                <div>
                    <h4 class="fw-bold mb-1">
                        <c:out value="${recruitment.jobTitle}" default="—" />
                    </h4>
                    <div class="text-muted mb-2" style="font-size:.85rem;">
                        <i class="bi bi-geo-alt me-1"></i><c:out value="${recruitment.location}" />
                        &nbsp;·&nbsp;
                        <i class="bi bi-cash me-1"></i>
                        <fmt:formatNumber value="${recruitment.salary}" type="currency" currencySymbol="₫" groupingUsed="true" />
                    </div>
                    <%-- Status badge --%>
                    <c:choose>
                        <c:when test="${recruitment.status == 'New'}">
                            <span class="badge badge-status-new rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>New
                            </span>
                        </c:when>
                        <c:when test="${recruitment.status == 'Waiting'}">
                            <span class="badge badge-status-waiting rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Waiting
                            </span>
                        </c:when>
                        <c:when test="${recruitment.status == 'Rejected'}">
                            <span class="badge badge-status-rejected rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Rejected
                            </span>
                        </c:when>
                        <c:when test="${recruitment.status == 'Applied'}">
                            <span class="badge badge-status-applied rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Applied
                            </span>
                        </c:when>
                        <c:when test="${recruitment.status == 'Deleted'}">
                            <span class="badge badge-status-deleted rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Deleted
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-secondary rounded-pill px-3 py-1">
                                <c:out value="${recruitment.status}" default="Unknown" />
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="ms-auto">
                    <span class="text-muted" style="font-size:.8rem;">Recruitment ID</span>
                    <div class="fw-bold text-primary fs-5">#<c:out value="${recruitment.recruitmentId}" /></div>
                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 1 — Recruitment Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-job"><i class="bi bi-info-circle-fill"></i></span>
                Job Posting Information
            </div>
            <div class="card-body px-4 py-2">
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Job Title</div>
                            <div class="info-value"><c:out value="${recruitment.jobTitle}" default="—" /></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Location</div>
                            <div class="info-value"><c:out value="${recruitment.location}" default="—" /></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Salary (Gross)</div>
                            <div class="info-value">
                                <fmt:formatNumber value="${recruitment.salary}" type="currency" currencySymbol="₫" groupingUsed="true" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Posted Date</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty recruitment.postedDate}">
                                        <c:out value="${recruitment.postedDate.format(dateFormatter)}" />
                                    </c:when>
                                    <c:otherwise><span class="empty">Not specified</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Applicant Count</div>
                            <div class="info-value">
                                <i class="bi bi-people me-1 text-primary"></i>
                                <c:out value="${recruitment.applicant}" /> candidates
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Status</div>
                            <div class="info-value"><c:out value="${recruitment.status}" default="—" /></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 2 — Job Description
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-desc"><i class="bi bi-file-earmark-text-fill"></i></span>
                Job Description
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty recruitment.jobDescription}">
                        <div class="info-value text-pre"><c:out value="${recruitment.jobDescription}" /></div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-file-earmark-x fs-3 d-block mb-2 opacity-25"></i>
                            No description provided.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 3 — Requirements
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-req"><i class="bi bi-card-checklist"></i></span>
                Requirements
            </div>
            <div class="card-body p-4">
                <c:choose>
                    <c:when test="${not empty recruitment.requirement}">
                        <div class="info-value text-pre"><c:out value="${recruitment.requirement}" /></div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-card-checklist fs-3 d-block mb-2 opacity-25"></i>
                            No requirements specified.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </c:if>

</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
