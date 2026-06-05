<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Job – HR Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        body { background-color: #f1f5f9; font-family: 'Segoe UI', system-ui, sans-serif; color: #1e293b; }

        .topbar {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 1.25rem 2rem; color: #fff;
            box-shadow: 0 2px 8px rgba(79,70,229,.35);
        }
        .topbar h1 { font-size: 1.25rem; font-weight: 700; margin: 0; }
        .topbar p  { font-size: .82rem; opacity: .85; margin: 0; }

        .bc a { color: #e0e7ff; text-decoration: none; }
        .bc a:hover { color: #fff; text-decoration: underline; }
        .bc .active { color: #c7d2fe; }
        .bc { --bs-breadcrumb-divider: '›'; font-size: .83rem; }

        .card-custom {
            border: none; border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,.06); background: #fff;
        }
        .card-custom .card-header {
            background: #fff; border-bottom: 1px solid #e2e8f0;
            border-radius: 16px 16px 0 0 !important; padding: 1.25rem 1.5rem;
        }

        .form-label {
            font-size: .75rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: .5px; color: #64748b;
        }
        .form-control, .form-select {
            border-radius: 10px; border: 1.5px solid #e2e8f0;
            padding: .6rem .85rem; font-size: .9rem;
            transition: border-color .15s, box-shadow .15s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79,70,229,.15);
        }
        .form-control.is-invalid, .form-select.is-invalid { border-color: #ef4444; }
        .invalid-feedback { font-size: .8rem; }

        .btn-create {
            background: #4f46e5; border-color: #4f46e5; color: #fff;
            border-radius: 10px; font-weight: 600; font-size: .9rem; padding: .6rem 1.4rem;
            transition: all .2s;
        }
        .btn-create:hover {
            background: #4338ca; border-color: #4338ca;
            transform: translateY(-1px); box-shadow: 0 4px 12px rgba(79,70,229,.25);
        }
        .btn-cancel {
            border-radius: 10px; font-size: .9rem; padding: .6rem 1.2rem;
            border: 1.5px solid #cbd5e1; color: #64748b; background: transparent;
            transition: all .2s;
        }
        .btn-cancel:hover { background: #f1f5f9; color: #334155; }

        .btn-reset {
            border-radius: 10px; font-size: .9rem; padding: .6rem 1.2rem;
            background: #f1f5f9; border: 1.5px solid #e2e8f0; color: #475569;
            transition: all .2s;
        }
        .btn-reset:hover { background: #e2e8f0; }

        .required-mark::after { content: " *"; color: #ef4444; }

        /* Tips panel */
        .tips-list { padding-left: 0; list-style: none; }
        .tips-list li {
            position: relative; padding-left: 1.6rem;
            margin-bottom: .9rem; font-size: .84rem; color: #475569; line-height: 1.55;
        }
        .tips-list li::before {
            content: "\F26E"; font-family: "bootstrap-icons";
            position: absolute; left: 0; top: 2px; color: #10b981; font-size: .95rem;
        }

        .alert-server {
            border-radius: 12px; font-size: .875rem;
            border: none; padding: .9rem 1.2rem;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ══════════════════════════════════════════ -->
<div class="topbar d-flex flex-wrap align-items-center justify-content-between gap-3">
    <div class="d-flex align-items-center gap-3">
        <i class="bi bi-plus-circle-fill fs-4"></i>
        <div>
            <h1>Create Job Posting</h1>
            <p>Human Resources &rsaquo; Recruitment &rsaquo; Create Job</p>
        </div>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb bc mb-0">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"><i class="bi bi-house-door-fill me-1"></i>Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/recruitment/list">Recruitment</a></li>
            <li class="breadcrumb-item active" aria-current="page">Create Job</li>
        </ol>
    </nav>
</div>

<!-- ═══ Content ══════════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width:1200px;">

    <!-- Back button -->
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/recruitment/list" class="btn btn-cancel">
            <i class="bi bi-arrow-left me-1"></i>Back to List
        </a>
    </div>

    <!-- Server-side error alert (non-field) -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-server d-flex align-items-center gap-2 mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-5"></i>
            <c:out value="${errorMessage}" />
        </div>
    </c:if>

    <div class="row g-4">

        <!-- ── Left: Form Card ─────────────────────────────── -->
        <div class="col-lg-8">
            <div class="card card-custom">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-medical-fill text-primary fs-5"></i>
                    <span class="fw-bold text-dark fs-5">Job Posting Form</span>
                </div>
                <div class="card-body p-4">

                    <form action="${pageContext.request.contextPath}/recruitment/create"
                          method="POST" novalidate id="createForm">

                        <%-- Job Title --%>
                        <div class="mb-4">
                            <label for="jobTitle" class="form-label required-mark">Job Title</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0">
                                    <i class="bi bi-type text-muted"></i>
                                </span>
                                <input type="text"
                                       class="form-control border-start-0 <c:if test='${not empty errors.jobTitle}'>is-invalid</c:if>"
                                       id="jobTitle" name="jobTitle"
                                       placeholder="e.g. Senior Java Web Developer"
                                       value="<c:out value='${jobTitle}'/>"
                                       required />
                                <c:if test="${not empty errors.jobTitle}">
                                    <div class="invalid-feedback"><c:out value="${errors.jobTitle}"/></div>
                                </c:if>
                            </div>
                        </div>

                        <%-- Location & Salary --%>
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="location" class="form-label required-mark">Location</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <i class="bi bi-geo-alt text-muted"></i>
                                    </span>
                                    <input type="text"
                                           class="form-control border-start-0 <c:if test='${not empty errors.location}'>is-invalid</c:if>"
                                           id="location" name="location"
                                           placeholder="e.g. Hanoi, Vietnam"
                                           value="<c:out value='${location}'/>"
                                           required />
                                    <c:if test="${not empty errors.location}">
                                        <div class="invalid-feedback"><c:out value="${errors.location}"/></div>
                                    </c:if>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="salary" class="form-label required-mark">Salary (₫)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0">
                                        <i class="bi bi-cash text-muted"></i>
                                    </span>
                                    <input type="number"
                                           class="form-control border-start-0 <c:if test='${not empty errors.salary}'>is-invalid</c:if>"
                                           id="salary" name="salary"
                                           placeholder="e.g. 25000000"
                                           min="1" step="any"
                                           value="<c:out value='${salaryStr}'/>"
                                           required />
                                    <c:if test="${not empty errors.salary}">
                                        <div class="invalid-feedback"><c:out value="${errors.salary}"/></div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <%-- Requirement --%>
                        <div class="mb-4">
                            <label for="requirement" class="form-label required-mark">Requirements</label>
                            <textarea class="form-control <c:if test='${not empty errors.requirement}'>is-invalid</c:if>"
                                      id="requirement" name="requirement" rows="3"
                                      placeholder="e.g. Java, Spring Boot, 2+ years of experience…"
                                      required><c:out value="${requirement}"/></textarea>
                            <c:if test="${not empty errors.requirement}">
                                <div class="invalid-feedback"><c:out value="${errors.requirement}"/></div>
                            </c:if>
                        </div>

                        <%-- Job Description --%>
                        <div class="mb-4">
                            <label for="jobDescription" class="form-label">Job Description <span class="text-muted fw-normal">(optional)</span></label>
                            <textarea class="form-control"
                                      id="jobDescription" name="jobDescription" rows="6"
                                      placeholder="Describe the responsibilities and scope of this role…"><c:out value="${jobDescription}"/></textarea>
                        </div>

                        <%-- Status & Applicant --%>
                        <div class="row g-3 mb-5">
                            <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="New"      <c:if test="${selectedStatus == 'New'      || empty selectedStatus}">selected</c:if>>New</option>
                                    <option value="Waiting"  <c:if test="${selectedStatus == 'Waiting' }">selected</c:if>>Waiting</option>
                                    <option value="Applied"  <c:if test="${selectedStatus == 'Applied' }">selected</c:if>>Applied</option>
                                    <option value="Rejected" <c:if test="${selectedStatus == 'Rejected'}">selected</c:if>>Rejected</option>
                                    <option value="Deleted"  <c:if test="${selectedStatus == 'Deleted' }">selected</c:if>>Deleted</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="applicant" class="form-label">Initial Applicant Count</label>
                                <input type="number" class="form-control" id="applicant"
                                       name="applicant" value="1" min="1" />
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex align-items-center justify-content-end gap-2 border-top pt-4">
                            <a href="${pageContext.request.contextPath}/recruitment/list"
                               class="btn btn-cancel">
                                <i class="bi bi-x-circle me-1"></i>Cancel
                            </a>
                            <button type="reset" class="btn btn-reset">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
                            </button>
                            <button type="submit" class="btn btn-create" id="submitBtn">
                                <i class="bi bi-plus-lg me-1"></i>Create Job
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div><!-- /col -->

        <!-- ── Right: Tips Panel ───────────────────────────── -->
        <div class="col-lg-4">
            <div class="card card-custom h-auto">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-lightbulb-fill text-warning fs-5"></i>
                    <span class="fw-bold text-dark fs-5">Posting Tips</span>
                </div>
                <div class="card-body p-4">
                    <h6 class="fw-bold mb-3" style="color:#4f46e5;">Writing Great Job Ads</h6>
                    <ul class="tips-list">
                        <li><strong>Clear Job Titles:</strong> Keep titles simple and searchable — avoid internal jargon.</li>
                        <li><strong>Location Details:</strong> Specify On-site, Hybrid, or Remote clearly.</li>
                        <li><strong>Specific Requirements:</strong> Separate must-have from nice-to-have skills.</li>
                        <li><strong>Show Salary:</strong> Listings with salary ranges get significantly more applicants.</li>
                        <li><strong>Status:</strong> Set to <strong>New</strong> to make the posting visible immediately.</li>
                    </ul>

                    <hr class="my-3" />

                    <!-- Status colour reference -->
                    <h6 class="fw-bold mb-3" style="color:#4f46e5;">Status Reference</h6>
                    <div class="d-flex flex-column gap-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge rounded-pill px-3 py-1" style="background:#dbeafe;color:#1e40af;">New</span>
                            <span class="text-muted" style="font-size:.8rem;">Freshly published</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge rounded-pill px-3 py-1" style="background:#fef3c7;color:#92400e;">Waiting</span>
                            <span class="text-muted" style="font-size:.8rem;">Pending approval</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge rounded-pill px-3 py-1" style="background:#d1fae5;color:#065f46;">Applied</span>
                            <span class="text-muted" style="font-size:.8rem;">Receiving applications</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge rounded-pill px-3 py-1" style="background:#fee2e2;color:#991b1b;">Rejected</span>
                            <span class="text-muted" style="font-size:.8rem;">Not approved</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge rounded-pill px-3 py-1" style="background:#f1f5f9;color:#475569;">Deleted</span>
                            <span class="text-muted" style="font-size:.8rem;">Archived/removed</span>
                        </div>
                    </div>

                    <hr class="my-3" />
                    <div class="p-3 bg-light rounded-3 text-center">
                        <i class="bi bi-shield-check text-success fs-3 mb-2 d-block"></i>
                        <span class="fw-semibold text-dark d-block mb-1" style="font-size:.85rem;">Compliance Check</span>
                        <p class="text-muted mb-0" style="font-size:.77rem;">Ensure job descriptions follow equal opportunity and company HR policies.</p>
                    </div>
                </div>
            </div>
        </div><!-- /col -->

    </div><!-- /row -->
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Client-side validation before submit
    (() => {
        const form = document.getElementById('createForm');
        form.addEventListener('submit', e => {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    })();
</script>
</body>
</html>
