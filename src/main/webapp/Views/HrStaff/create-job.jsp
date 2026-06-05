<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Job – HR Management</title>

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

        /* ── Top bar with gradient ── */
        .topbar {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 1.25rem 2rem;
            color: #fff;
            box-shadow: 0 2px 8px rgba(79, 70, 229, .35);
        }
        .topbar h1 {
            font-size: 1.25rem;
            font-weight: 700;
            margin: 0;
            letter-spacing: .3px;
        }
        .topbar p {
            font-size: .82rem;
            opacity: .85;
            margin: 0;
        }

        /* ── Breadcrumb ── */
        .breadcrumb-custom {
            --bs-breadcrumb-divider: '›';
            font-size: .85rem;
        }
        .breadcrumb-custom a {
            color: #e0e7ff;
            text-decoration: none;
            transition: color .15s;
        }
        .breadcrumb-custom a:hover {
            color: #fff;
            text-decoration: underline;
        }
        .breadcrumb-custom .active {
            color: #c7d2fe;
        }

        /* ── Card Customization ── */
        .card-custom {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,.06);
            background-color: #fff;
            transition: transform .2s, box-shadow .2s;
        }
        .card-custom .card-header {
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            border-radius: 16px 16px 0 0 !important;
            padding: 1.25rem 1.5rem;
        }

        /* ── Form Inputs ── */
        .form-label {
            font-size: .78rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .5px;
            color: #64748b;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 1.5px solid #e2e8f0;
            padding: .6rem .85rem;
            font-size: .9rem;
            color: #1e293b;
            transition: border-color .15s, box-shadow .15s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, .15);
            outline: none;
        }
        .form-control[readonly] {
            background-color: #f8fafc;
            border-color: #cbd5e1;
            color: #64748b;
        }

        /* ── Buttons ── */
        .btn-custom {
            border-radius: 10px;
            padding: .6rem 1.25rem;
            font-size: .88rem;
            font-weight: 600;
            transition: all .2s;
        }
        .btn-primary-custom {
            background-color: #4f46e5;
            border-color: #4f46e5;
            color: #fff;
        }
        .btn-primary-custom:hover {
            background-color: #4338ca;
            border-color: #4338ca;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(79, 70, 229, .25);
        }
        .btn-secondary-custom {
            background-color: #f1f5f9;
            border-color: #e2e8f0;
            color: #475569;
        }
        .btn-secondary-custom:hover {
            background-color: #e2e8f0;
            color: #334155;
            transform: translateY(-1px);
        }
        .btn-outline-custom {
            border: 1.5px solid #cbd5e1;
            color: #64748b;
            background-color: transparent;
        }
        .btn-outline-custom:hover {
            background-color: #f1f5f9;
            color: #334155;
            border-color: #94a3b8;
            transform: translateY(-1px);
        }

        /* ── Info Panel Tips ── */
        .tips-list {
            padding-left: 0;
            list-style: none;
        }
        .tips-list li {
            position: relative;
            padding-left: 1.5rem;
            margin-bottom: .85rem;
            font-size: .85rem;
            color: #475569;
            line-height: 1.5;
        }
        .tips-list li::before {
            content: "\F26E"; /* Bootstrap Icons check-circle-fill */
            font-family: "bootstrap-icons";
            position: absolute;
            left: 0;
            top: 1px;
            color: #10b981;
            font-size: .95rem;
        }

        /* Required asterisk */
        .required-mark::after {
            content: " *";
            color: #ef4444;
        }
    </style>
</head>
<body>

<!-- ═══ Top bar ═══════════════════════════════════════════ -->
<div class="topbar d-flex flex-wrap align-items-center justify-content-between gap-3">
    <div class="d-flex align-items-center gap-3">
        <i class="bi bi-plus-circle-fill fs-4"></i>
        <div>
            <h1>Create Job</h1>
            <p>Human Resources &rsaquo; Recruitment Management &rsaquo; Create Job</p>
        </div>
    </div>
    
    <!-- Breadcrumb inside Topbar for premium feel -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb breadcrumb-custom mb-0">
            <li class="breadcrumb-item"><a href="#"><i class="bi bi-house-door-fill me-1"></i>Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/recruitment/list">Recruitment</a></li>
            <li class="breadcrumb-item active" aria-current="page">Create Job</li>
        </ol>
    </nav>
</div>

<!-- ═══ Main Content ══════════════════════════════════════ -->
<div class="container-fluid px-4 py-4" style="max-width: 1200px;">

    <!-- ── Back to List Button ── -->
    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/recruitment/list" class="btn btn-outline-custom btn-custom">
            <i class="bi bi-arrow-left me-1"></i>Back to Recruitment List
        </a>
    </div>

    <div class="row g-4">
        
        <!-- ── Left Column: Form Card ── -->
        <div class="col-lg-8">
            <div class="card card-custom">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-file-earmark-medical-fill text-primary fs-5"></i>
                    <span class="fw-bold text-dark fs-5">Job Posting Form</span>
                </div>
                <div class="card-body p-4">
                    <form action="#" method="POST" class="needs-validation" novalidate>
                        
                        <!-- Job Title -->
                        <div class="mb-4">
                            <label for="jobTitle" class="form-label required-mark">Job Title</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="bi bi-type text-muted"></i></span>
                                <input type="text" class="form-control border-start-0" id="jobTitle" name="jobTitle" placeholder="e.g. Senior Java Web Developer" required />
                                <div class="invalid-feedback">Please provide a job title.</div>
                            </div>
                        </div>

                        <!-- Location & Salary Row -->
                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="location" class="form-label">Location</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-geo-alt text-muted"></i></span>
                                    <input type="text" class="form-control border-start-0" id="location" name="location" placeholder="e.g. Hanoi, Vietnam" />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="salary" class="form-label">Salary (₫)</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light border-end-0"><i class="bi bi-cash text-muted"></i></span>
                                    <input type="number" class="form-control border-start-0" id="salary" name="salary" placeholder="e.g. 25000000" min="0" />
                                </div>
                            </div>
                        </div>

                        <!-- Job Description -->
                        <div class="mb-4">
                            <label for="jobDescription" class="form-label">Job Description</label>
                            <textarea class="form-control" id="jobDescription" name="jobDescription" rows="6" placeholder="Describe the responsibilities and scope of this job..."></textarea>
                        </div>

                        <!-- Requirements -->
                        <div class="mb-4">
                            <label for="requirement" class="form-label">Requirements</label>
                            <textarea class="form-control" id="requirement" name="requirement" rows="4" placeholder="e.g. Java, Spring Boot, 2+ years experience..."></textarea>
                        </div>

                        <!-- Status, Applicant & Posted Date Row -->
                        <div class="row g-3 mb-5">
                            <div class="col-md-4">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="New" selected>New</option>
                                    <option value="Waiting">Waiting</option>
                                    <option value="Rejected">Rejected</option>
                                    <option value="Applied">Applied</option>
                                    <option value="Deleted">Deleted</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="applicant" class="form-label">Applicant Count</label>
                                <input type="number" class="form-control" id="applicant" name="applicant" value="1" min="1" />
                            </div>
                            <div class="col-md-4">
                                <label for="postedDate" class="form-label">Posted Date (Auto)</label>
                                <input type="text" class="form-control" id="postedDate" name="postedDate" readonly />
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex align-items-center justify-content-end gap-2 border-top pt-4">
                            <a href="${pageContext.request.contextPath}/recruitment/list" class="btn btn-outline-custom btn-custom">
                                <i class="bi bi-x-circle me-1"></i>Cancel
                            </a>
                            <button type="reset" class="btn btn-secondary-custom btn-custom">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
                            </button>
                            <button type="button" class="btn btn-primary-custom btn-custom">
                                <i class="bi bi-plus-lg me-1"></i>Create Job
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>

        <!-- ── Right Column: Info Panel ── -->
        <div class="col-lg-4">
            <div class="card card-custom h-100">
                <div class="card-header d-flex align-items-center gap-2">
                    <i class="bi bi-lightbulb-fill text-warning fs-5"></i>
                    <span class="fw-bold text-dark fs-5">Job Posting Tips</span>
                </div>
                <div class="card-body p-4">
                    <h6 class="fw-bold text-indigo mb-3" style="color: #4f46e5;">Writing Great Job Ads</h6>
                    <ul class="tips-list">
                        <li>
                            <strong>Clear Job Titles:</strong> Keep titles simple and search-friendly (e.g., use "Software Engineer" instead of "Code Wizard").
                        </li>
                        <li>
                            <strong>Location Details:</strong> Mention if the job is On-site, Hybrid, or fully Remote.
                        </li>
                        <li>
                            <strong>Clear Requirements:</strong> Separate core required skills from optional "nice-to-have" qualifications.
                        </li>
                        <li>
                            <strong>Explicit Salary:</strong> Clear salaries or salary ranges increase job application rates by over 30%.
                        </li>
                        <li>
                            <strong>Status:</strong> New postings should defaults to "New" status to be visible in the candidate board.
                        </li>
                    </ul>
                    
                    <hr class="my-4 text-muted" />
                    
                    <div class="p-3 bg-light rounded-3 border border-light-subtle text-center">
                        <i class="bi bi-shield-check text-success fs-3 mb-2 d-block"></i>
                        <span class="d-block fw-semibold text-dark mb-1" style="font-size: .85rem;">Compliance Check</span>
                        <p class="text-muted mb-0" style="font-size: .78rem;">Ensure the job description aligns with equal opportunity regulations and company policies.</p>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Bootstrap 5 JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Automatically set the Posted Date field to today's date in dd-MM-yyyy format
    document.addEventListener('DOMContentLoaded', () => {
        const today = new Date();
        const dd = String(today.getDate()).padStart(2, '0');
        const mm = String(today.getMonth() + 1).padStart(2, '0'); // January is 0
        const yyyy = today.getFullYear();
        const formattedDate = dd + '-' + mm + '-' + yyyy;
        document.getElementById('postedDate').value = formattedDate;
    });
</script>
</body>
</html>
