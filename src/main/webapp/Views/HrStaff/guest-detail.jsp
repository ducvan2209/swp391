<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Candidate Detail – HR Management</title>

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
        .icon-candidate  { background: #e0e7ff; color: #4f46e5; }
        .icon-recruitment { background: #d1fae5; color: #059669; }
        .icon-cv         { background: #fef3c7; color: #d97706; }

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

        /* ── Status badges ────────────────────────────── */
        .badge-processing { background-color: #fef3c7; color: #92400e; }
        .badge-hired      { background-color: #d1fae5; color: #065f46; }
        .badge-rejected   { background-color: #fee2e2; color: #991b1b; }
        .badge-other      { background-color: #e0e7ff; color: #3730a3; }

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

        /* ── CV content ──────────────────────────────── */
        .cv-content {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 1.25rem;
            font-size: .88rem;
            line-height: 1.7;
            white-space: pre-wrap;
            word-wrap: break-word;
            max-height: 400px;
            overflow-y: auto;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-person-badge-fill fs-4"></i>
    <div>
        <h1>Candidate Detail</h1>
        <p>Human Resources &rsaquo; Recruitment &rsaquo; Candidates &rsaquo; Detail</p>
    </div>
</div>

<!-- ═══ Main content ══════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width: 1000px;">

    <!-- ── Back button ──────────────────────────────── -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/guest-list"
           class="btn btn-outline-secondary btn-back">
            <i class="bi bi-arrow-left me-1"></i>Back to Candidate List
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
         CASE 2: Candidate not found
    ════════════════════════════════════════════════ --%>
    <c:if test="${empty errorMessage and empty guest}">
        <div class="not-found-box">
            <i class="bi bi-person-x-fill text-secondary fs-1 d-block mb-3"></i>
            <h5 class="fw-semibold">Candidate Not Found</h5>
            <p class="text-muted mb-0">
                No candidate exists with the requested ID.
                Please go back and try again.
            </p>
        </div>
    </c:if>

    <%-- ══════════════════════════════════════════════
         CASE 3: Candidate found → render full detail
    ════════════════════════════════════════════════ --%>
    <c:if test="${not empty guest}">

        <%-- ── Hero header ─────────────────────────── --%>
        <div class="section-card card mb-4">
            <div class="card-body p-4 d-flex align-items-center gap-4 flex-wrap">
                <div class="avatar-lg">
                    <c:choose>
                        <c:when test="${not empty guest.fullName}">
                            ${fn:toUpperCase(fn:substring(guest.fullName, 0, 1))}
                        </c:when>
                        <c:otherwise>?</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h4 class="fw-bold mb-1">
                        <c:out value="${guest.fullName}" default="—" />
                    </h4>
                    <div class="text-muted mb-2" style="font-size:.85rem;">
                        <c:choose>
                            <c:when test="${not empty guest.recruitment}">
                                Applied for: <c:out value="${guest.recruitment.jobTitle}" />
                            </c:when>
                            <c:otherwise>
                                No job applied
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <%-- Status badge --%>
                    <c:choose>
                        <c:when test="${guest.status == 'Processing'}">
                            <span class="badge badge-processing rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Processing
                            </span>
                        </c:when>
                        <c:when test="${guest.status == 'Hired'}">
                            <span class="badge badge-hired rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Hired
                            </span>
                        </c:when>
                        <c:when test="${guest.status == 'Rejected'}">
                            <span class="badge badge-rejected rounded-pill px-3 py-1">
                                <i class="bi bi-circle-fill me-1" style="font-size:.45rem;vertical-align:middle;"></i>Rejected
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-other rounded-pill px-3 py-1">
                                <c:out value="${guest.status}" default="Unknown" />
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="ms-auto">
                    <span class="text-muted" style="font-size:.8rem;">Candidate ID</span>
                    <div class="fw-bold text-primary fs-5">#<c:out value="${guest.guestId}" /></div>
                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 1 — Candidate Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-candidate"><i class="bi bi-person-fill"></i></span>
                Candidate Information
            </div>
            <div class="card-body px-4 py-2">
                <div class="row">

                    <div class="col-md-6">
                        <div class="info-row">
                            <div class="info-label">Full Name</div>
                            <div class="info-value"><c:out value="${guest.fullName}" default="—" /></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Email</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty guest.email}">
                                        <a href="mailto:<c:out value='${guest.email}'/>"
                                           class="text-decoration-none text-dark">
                                            <i class="bi bi-envelope me-1 text-primary"></i>
                                            <c:out value="${guest.email}" />
                                        </a>
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
                                    <c:when test="${not empty guest.phone}">
                                        <a href="tel:<c:out value='${guest.phone}'/>"
                                           class="text-decoration-none text-dark">
                                            <i class="bi bi-telephone me-1 text-primary"></i>
                                            <c:out value="${guest.phone}" />
                                        </a>
                                    </c:when>
                                    <c:otherwise><span class="empty">Not provided</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Applied Date</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty guest.appliedDate}">
                                        <c:out value="${guest.appliedDate}" />
                                    </c:when>
                                    <c:otherwise><span class="empty">Not available</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 2 — Recruitment Info
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-recruitment"><i class="bi bi-briefcase-fill"></i></span>
                Recruitment Information
            </div>
            <div class="card-body px-4 py-2">
                <c:choose>
                    <c:when test="${not empty guest.recruitment}">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Job Title</div>
                                    <div class="info-value">
                                        <i class="bi bi-briefcase me-1 text-success"></i>
                                        <c:out value="${guest.recruitment.jobTitle}" />
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Location</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty guest.recruitment.location}">
                                                <i class="bi bi-geo-alt me-1 text-success"></i>
                                                <c:out value="${guest.recruitment.location}" />
                                            </c:when>
                                            <c:otherwise><span class="empty">Not specified</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="info-row">
                                    <div class="info-label">Salary</div>
                                    <div class="info-value">
                                        <fmt:formatNumber value="${guest.recruitment.salary}"
                                                          type="currency"
                                                          currencySymbol="₫"
                                                          groupingUsed="true" />
                                    </div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Job Status</div>
                                    <div class="info-value">
                                        <c:out value="${guest.recruitment.status}" default="—" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-briefcase fs-3 d-block mb-2 opacity-25"></i>
                            No job applied
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- ════════════════════════════════════════
             SECTION 3 — CV / Resume
        ══════════════════════════════════════════ --%>
        <div class="section-card card">
            <div class="card-header">
                <span class="icon-box icon-cv"><i class="bi bi-file-earmark-text-fill"></i></span>
                CV / Resume
            </div>
            <div class="card-body px-4 py-3">
                <c:choose>
                    <c:when test="${not empty guest.cv}">
                        <div class="cv-content"><c:out value="${guest.cv}" /></div>
                    </c:when>
                    <c:otherwise>
                        <div class="py-4 text-center text-muted">
                            <i class="bi bi-file-earmark-x fs-3 d-block mb-2 opacity-25"></i>
                            No CV uploaded
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </c:if><%-- end guest not empty --%>

</div><%-- /container --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
