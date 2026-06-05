<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Create Employee – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <style>
        body {
            background-color: #f9fbfa;
            font-family: "Euclid Circular A", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #001e2b;
            min-height: 100vh;
            margin: 0;
        }

        /* ── Top bar ─────────────────────────────────── */
        .topbar {
            background-color: #001e2b;
            height: 72px;
            padding: 0 2rem;
            color: #ffffff;
            border-bottom: 1px solid #1e3a47;
            box-shadow: none;
        }
        .topbar h1 {
            font-size: 1.2rem;
            font-weight: 600;
            margin: 0;
            color: #ffffff;
        }
        .topbar p {
            font-size: .82rem;
            color: rgba(255, 255, 255, 0.65);
            margin: 0;
        }
        .topbar i {
            color: #00ed64;
        }

        /* ── Card ────────────────────────────────────── */
        .form-card {
            border: 1px solid #e1e5e8;
            border-radius: 12px;
            background-color: #ffffff;
            box-shadow: 0 2px 4px rgba(0, 30, 43, 0.04);
            margin-bottom: 1.5rem;
        }
        .form-card .card-header {
            background: #ffffff;
            border-bottom: 1px solid #e1e5e8;
            border-radius: 12px 12px 0 0 !important;
            padding: .9rem 1.5rem;
            font-weight: 600;
            font-size: .95rem;
            color: #001e2b;
            display: flex;
            align-items: center;
            gap: .6rem;
        }
        .section-icon {
            width: 32px;
            height: 32px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: .95rem;
        }
        .icon-personal  { background: #c3f0d2; color: #00684a; }
        .icon-contact   { background: #c3f2ec; color: #005f53; }
        .icon-work      { background: #e1f5eb; color: #00684a; }

        /* ── Form fields ─────────────────────────────── */
        .form-label {
            font-size: .78rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .4px;
            color: #5c6c7a;
            margin-bottom: .3rem;
        }
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #c1ccd6;
            font-size: .875rem;
            color: #001e2b;
            background-color: #ffffff;
            transition: border-color .2s, box-shadow .2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #00684a;
            box-shadow: 0 0 0 3px rgba(0,237,100,0.15);
            outline: 0;
            color: #001e2b;
        }
        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #d9383a !important;
        }
        .form-control.is-invalid:focus, .form-select.is-invalid:focus {
            box-shadow: 0 0 0 3px rgba(217, 56, 58, 0.15) !important;
        }
        .invalid-feedback {
            font-size: .78rem;
            color: #d9383a;
            font-weight: 500;
            margin-top: 0.25rem;
        }
        .form-text {
            color: #5c6c7a !important;
        }

        /* ── Input Group ─────────────────────────────── */
        .input-group-text {
            background-color: #f9fbfa;
            border: 1px solid #c1ccd6;
            color: #5c6c7a;
            border-radius: 6px 0 0 6px !important;
            font-size: 0.875rem;
        }
        .input-group > .form-control {
            border-radius: 0 6px 6px 0 !important;
        }
        .input-group:has(.is-invalid) .input-group-text {
            border-color: #d9383a !important;
        }

        /* ── Required star ───────────────────────────── */
        .req { color: #d9383a; margin-left: 2px; }

        /* ── Buttons ─────────────────────────────────── */
        .btn.btn-create {
            background-color: #00ed64;
            border: 1px solid #00ed64;
            color: #001e2b;
            border-radius: 9999px;
            padding: .55rem 1.6rem;
            font-weight: 600;
            font-size: .875rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background-color .15s ease-in-out, border-color .15s ease-in-out, color .15s ease-in-out, transform .15s ease-in-out;
        }
        .btn.btn-create:hover, .btn.btn-create:focus, .btn.btn-create:active {
            background-color: #00c653 !important;
            border-color: #00c653 !important;
            color: #001e2b !important;
            transform: translateY(-1px);
            box-shadow: 0 0 0 3px rgba(0, 237, 100, 0.15) !important;
        }
        .btn.btn-create:active {
            transform: translateY(0);
        }
        .btn.btn-create:disabled {
            background-color: #c1ccd6 !important;
            border-color: #c1ccd6 !important;
            color: #5c6c7a !important;
            cursor: not-allowed;
            transform: none;
            box-shadow: none !important;
        }

        .btn.btn-cancel {
            background-color: #ffffff !important;
            border: 1px solid #c1ccd6 !important;
            color: #001e2b !important;
            border-radius: 9999px !important;
            font-size: .875rem;
            padding: .55rem 1.4rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: background-color .15s ease-in-out, border-color .15s ease-in-out, color .15s ease-in-out;
        }
        .btn.btn-cancel:hover, .btn.btn-cancel:focus, .btn.btn-cancel:active {
            background-color: #f9fbfa !important;
            border-color: #001e2b !important;
            color: #001e2b !important;
            box-shadow: 0 0 0 3px rgba(0, 30, 43, 0.04) !important;
        }

        /* ── Global error alert ──────────────────────── */
        .alert-global {
            border-radius: 6px;
            background-color: #fdf2f2;
            border: 1px solid #f8b4b4;
            color: #9b1c1c;
            padding: 0.8rem 1.2rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex align-items-center gap-3">
    <i class="bi bi-person-plus-fill fs-4"></i>
    <div>
        <h1>Create Employee</h1>
        <p>Human Resources &rsaquo; Staff Management &rsaquo; New Employee</p>
    </div>
</div>

<!-- ═══ Content ═══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width:900px;">

    <!-- Back -->
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/employee-list"
           class="btn btn-outline-secondary btn-cancel">
            <i class="bi bi-arrow-left me-1"></i>Back to Employee List
        </a>
    </div>

    <!-- Global DB error -->
    <c:if test="${not empty globalError}">
        <div class="alert alert-danger alert-global d-flex align-items-center gap-2 mb-3">
            <i class="bi bi-exclamation-triangle-fill"></i>
            <c:out value="${globalError}" />
        </div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/employee/create"
          novalidate
          id="createForm">

        <%-- ════ SECTION 1: Personal Info ═══════════════════════ --%>
        <div class="card form-card mb-4">
            <div class="card-header">
                <span class="section-icon icon-personal"><i class="bi bi-person-fill"></i></span>
                Personal Information
            </div>
            <div class="card-body p-4">
                <div class="row g-3">

                    <%-- Full Name --%>
                    <div class="col-md-6">
                        <label class="form-label" for="fullName">
                            Full Name <span class="req">*</span>
                        </label>
                        <input type="text" id="fullName" name="fullName"
                               class="form-control <c:if test='${not empty errors.fullName}'>is-invalid</c:if>"
                               value="<c:out value='${formFullName}'/>"
                               maxlength="100" placeholder="e.g. Nguyen Van A" />
                        <c:if test="${not empty errors.fullName}">
                            <div class="invalid-feedback"><c:out value="${errors.fullName}"/></div>
                        </c:if>
                    </div>

                    <%-- Gender --%>
                    <div class="col-md-3">
                        <label class="form-label" for="gender">
                            Gender <span class="req">*</span>
                        </label>
                        <select id="gender" name="gender"
                                class="form-select <c:if test='${not empty errors.gender}'>is-invalid</c:if>">
                            <option value="">-- Select --</option>
                            <option value="Male"   <c:if test="${formGender == 'Male'}">selected</c:if>>Male</option>
                            <option value="Female" <c:if test="${formGender == 'Female'}">selected</c:if>>Female</option>
                            <option value="Other"  <c:if test="${formGender == 'Other'}">selected</c:if>>Other</option>
                        </select>
                        <c:if test="${not empty errors.gender}">
                            <div class="invalid-feedback"><c:out value="${errors.gender}"/></div>
                        </c:if>
                    </div>

                    <%-- Date of Birth --%>
                    <div class="col-md-3">
                        <label class="form-label" for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob"
                               class="form-control <c:if test='${not empty errors.dob}'>is-invalid</c:if>"
                               value="<c:out value='${formDob}'/>"
                               max="${java.time.LocalDate.now()}" />
                        <c:if test="${not empty errors.dob}">
                            <div class="invalid-feedback"><c:out value="${errors.dob}"/></div>
                        </c:if>
                    </div>

                    <%-- Address --%>
                    <div class="col-12">
                        <label class="form-label" for="address">Address</label>
                        <input type="text" id="address" name="address"
                               class="form-control"
                               value="<c:out value='${formAddress}'/>"
                               placeholder="Street, District, City" />
                    </div>

                </div>
            </div>
        </div>

        <%-- ════ SECTION 2: Contact Info ════════════════════════ --%>
        <div class="card form-card mb-4">
            <div class="card-header">
                <span class="section-icon icon-contact"><i class="bi bi-telephone-fill"></i></span>
                Contact Information
            </div>
            <div class="card-body p-4">
                <div class="row g-3">

                    <%-- Phone --%>
                    <div class="col-md-6">
                        <label class="form-label" for="phone">
                            Phone <span class="req">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text rounded-start-3">
                                <i class="bi bi-telephone"></i>
                            </span>
                            <input type="tel" id="phone" name="phone"
                                   class="form-control <c:if test='${not empty errors.phone}'>is-invalid</c:if>"
                                   value="<c:out value='${formPhone}'/>"
                                   placeholder="0901 234 567" />
                            <c:if test="${not empty errors.phone}">
                                <div class="invalid-feedback"><c:out value="${errors.phone}"/></div>
                            </c:if>
                        </div>
                    </div>

                    <%-- Email --%>
                    <div class="col-md-6">
                        <label class="form-label" for="email">
                            Email <span class="req">*</span>
                        </label>
                        <div class="input-group">
                            <span class="input-group-text rounded-start-3">
                                <i class="bi bi-envelope"></i>
                            </span>
                            <input type="email" id="email" name="email"
                                   class="form-control <c:if test='${not empty errors.email}'>is-invalid</c:if>"
                                   value="<c:out value='${formEmail}'/>"
                                   placeholder="example@company.com" />
                            <c:if test="${not empty errors.email}">
                                <div class="invalid-feedback"><c:out value="${errors.email}"/></div>
                            </c:if>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%-- ════ SECTION 3: Work Info ════════════════════════════ --%>
        <div class="card form-card mb-4">
            <div class="card-header">
                <span class="section-icon icon-work"><i class="bi bi-briefcase-fill"></i></span>
                Work Information
            </div>
            <div class="card-body p-4">
                <div class="row g-3">

                    <%-- Position --%>
                    <div class="col-md-6">
                        <label class="form-label" for="position">
                            Position <span class="req">*</span>
                        </label>
                        <input type="text" id="position" name="position"
                               class="form-control <c:if test='${not empty errors.position}'>is-invalid</c:if>"
                               value="<c:out value='${formPosition}'/>"
                               placeholder="e.g. Software Engineer" />
                        <c:if test="${not empty errors.position}">
                            <div class="invalid-feedback"><c:out value="${errors.position}"/></div>
                        </c:if>
                    </div>

                    <%-- Status --%>
                    <div class="col-md-3">
                        <label class="form-label" for="status">
                            Status <span class="req">*</span>
                        </label>
                        <select id="status" name="status"
                                class="form-select <c:if test='${not empty errors.status}'>is-invalid</c:if>">
                            <option value="">-- Select --</option>
                            <option value="Active"   <c:if test="${formStatus == 'Active'   || empty formStatus}">selected</c:if>>Active</option>
                            <option value="Inactive" <c:if test="${formStatus == 'Inactive'}">selected</c:if>>Inactive</option>
                        </select>
                        <c:if test="${not empty errors.status}">
                            <div class="invalid-feedback"><c:out value="${errors.status}"/></div>
                        </c:if>
                    </div>

                    <%-- Department --%>
                    <div class="col-md-3">
                        <label class="form-label" for="departmentId">Department</label>
                        <select id="departmentId" name="departmentId" class="form-select">
                            <option value="">-- None --</option>
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept.departmentId}"
                                    <c:if test="${formDepartmentId == dept.departmentId}">selected</c:if>>
                                    <c:out value="${dept.deptName}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <%-- Employment Period --%>
                    <div class="col-md-6">
                        <label class="form-label" for="employmentPeriod">Employment Period</label>
                        <input type="text" id="employmentPeriod" name="employmentPeriod"
                               class="form-control"
                               value="<c:out value='${formEmploymentPeriod}'/>"
                               placeholder="e.g. 2020-01-15 or 2 years" />
                        <div class="form-text text-muted" style="font-size:.75rem;">
                            Start date or duration of employment
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <%-- ════ Action buttons ══════════════════════════════════ --%>
        <div class="d-flex gap-2 justify-content-end">
            <a href="${pageContext.request.contextPath}/employee-list"
               class="btn btn-outline-secondary btn-cancel">
                <i class="bi bi-x-lg me-1"></i>Cancel
            </a>
            <button type="submit" class="btn btn-create" id="submitBtn">
                <i class="bi bi-person-plus me-1"></i>Create Employee
            </button>
        </div>

    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Prevent double-submit
    document.getElementById('createForm').addEventListener('submit', function () {
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Saving…';
    });

    // Cap date-of-birth to today
    document.getElementById('dob').max = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
