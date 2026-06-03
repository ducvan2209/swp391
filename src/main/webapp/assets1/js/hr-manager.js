/**
 * HRM - HR Manager shared layout and utilities (frontend mock data)
 */
(function () {
  "use strict";

  var MSG = {
    NO_EVALUATION: "No evaluation data.",
    PAYROLL_UPDATE_FAIL: "Unable to update payroll status.",
    PAYROLL_GEN_FAIL: "Payroll generation failed.",
    PAYSLIP_NA: "Payslip not available.",
    REJECT_REASON_REQUIRED: "Rejection reason is required.",
    PAYROLL_APPROVED: "Payroll approved. Employees will be notified.",
    PAYROLL_REJECTED: "Payroll rejected and returned for correction.",
    CANDIDATE_APPROVED: "Candidate approved. Notification will be sent.",
    CANDIDATE_REJECTED: "Candidate rejected. Notification will be sent.",
  };

  var NAV = [
    {
      label: "Payroll",
      items: [
        { id: "payroll-list", href: "PayrollList.html", text: "Payroll List" },
        { id: "payroll-detail", href: "PayrollDetail.html", text: "Payroll Detail" },
        { id: "approve-payroll", href: "ApprovePayroll.html", text: "Approve Payroll" },
      ],
    },
    {
      label: "Recruitment",
      items: [
        { id: "candidate-evaluation", href: "CandidateEvaluation.html", text: "View Evaluation" },
        { id: "approve-candidate", href: "ApproveCandidate.html", text: "Approve Candidate" },
      ],
    },
    {
      label: "Reports",
      items: [
        { id: "hr-report", href: "HrReport.html", text: "Payroll Report" },
        { id: "recruitment-report", href: "RecruitmentReport.html", text: "Recruitment Report" },
      ],
    },
  ];

  var PAYROLL_STATUSES = ["Draft", "Pending", "Approved", "Rejected", "Paid"];

  var MOCK_EMPLOYEES = {
    1: { name: "Tran Duy Hien", dept: "Human Resources", position: "HR Manager", status: "Active" },
    2: { name: "Tran Duy Thanh", dept: "Human Resources", position: "HR Staff", status: "Active" },
    3: { name: "Nguyen Tat Dang Huy", dept: "Finance", position: "Finance Manager", status: "Active" },
    5: { name: "Do Van E", dept: "IT Department", position: "IT Manager", status: "Active" },
  };

  /** Payroll: PayPeriod YYYY-MM, amounts, status, approver */
  var MOCK_PAYROLLS = [
    {
      payrollId: 1,
      employeeId: 1,
      payPeriod: "2025-10",
      baseSalary: 25000000,
      allowance: 3000000,
      bonus: 2000000,
      deduction: 500000,
      netSalary: 29500000,
      status: "Pending",
      approvedBy: null,
      approvedDate: null,
      workingDays: 22,
      leaveDays: 0,
      overtimeHours: 4,
    },
    {
      payrollId: 2,
      employeeId: 2,
      payPeriod: "2025-10",
      baseSalary: 15000000,
      allowance: 2000000,
      bonus: 1000000,
      deduction: 0,
      netSalary: 18000000,
      status: "Pending",
      approvedBy: null,
      approvedDate: null,
      workingDays: 21,
      leaveDays: 1,
      overtimeHours: 0,
    },
    {
      payrollId: 3,
      employeeId: 3,
      payPeriod: "2025-10",
      baseSalary: 30000000,
      allowance: 5000000,
      bonus: 2000000,
      deduction: 0,
      netSalary: 37000000,
      status: "Pending",
      approvedBy: null,
      approvedDate: null,
      workingDays: 22,
      leaveDays: 0,
      overtimeHours: 2,
    },
    {
      payrollId: 4,
      employeeId: 5,
      payPeriod: "2025-10",
      baseSalary: 28000000,
      allowance: 4000000,
      bonus: 2500000,
      deduction: 1000000,
      netSalary: 33500000,
      status: "Pending",
      approvedBy: null,
      approvedDate: null,
      workingDays: 20,
      leaveDays: 2,
      overtimeHours: 6,
    },
  ];

  /**
   * Guest applicant + HR evaluation data
   * Guest: FullName, Email, Phone, CV, Status, RecruitmentID, AppliedDate
   */
  var MOCK_CANDIDATES = [
    {
      guestId: 1,
      fullName: "Nguyen Tien Khanh",
      email: "khanh@example.com",
      phone: "0981111111",
      cv: "link_cv_k.pdf",
      status: "Processing",
      recruitmentId: 1,
      jobTitle: "Software Developer",
      appliedDate: "2025-09-01",
      evaluation: null,
    },
    {
      guestId: 2,
      fullName: "Le Thi Lanh",
      email: "lanh@example.com",
      phone: "0982222222",
      cv: "link_cv_l.pdf",
      status: "Processing",
      recruitmentId: 1,
      jobTitle: "Software Developer",
      appliedDate: "2025-09-03",
      evaluation: {
        interviewDate: "2025-09-20",
        interviewTime: "14:00",
        interviewer: "Tran Duy Thanh (HR Staff)",
        interviewResult: "Passed",
        technicalAssessment: "Meets requirements",
        softSkillsAssessment: "Good",
        overallScore: 4,
        hrRecommendation: "Recommend hire",
        hrComments: "Strong Java skills and clear communication.",
        evaluatedBy: "Tran Duy Thanh",
        evaluatedDate: "2025-09-21",
      },
    },
    {
      guestId: 3,
      fullName: "Pham Van Manh",
      email: "manh@example.com",
      phone: "0983333333",
      cv: "link_cv_m.pdf",
      status: "Processing",
      recruitmentId: 1,
      jobTitle: "Software Developer",
      appliedDate: "2025-09-05",
      evaluation: {
        interviewDate: "2025-09-22",
        interviewTime: "10:00",
        interviewer: "Tran Duy Thanh (HR Staff)",
        interviewResult: "Passed",
        technicalAssessment: "Average",
        softSkillsAssessment: "Average",
        overallScore: 3,
        hrRecommendation: "Continue to next interview round",
        hrComments: "Additional technical test recommended.",
        evaluatedBy: "Tran Duy Thanh",
        evaluatedDate: "2025-09-23",
      },
    },
    {
      guestId: 4,
      fullName: "Do Thi Ngoc",
      email: "ngoc@example.com",
      phone: "0984444444",
      cv: "link_cv_n.pdf",
      status: "Processing",
      recruitmentId: 1,
      jobTitle: "Software Developer",
      appliedDate: "2025-09-08",
      evaluation: {
        interviewDate: "2025-09-25",
        interviewTime: "09:30",
        interviewer: "Tran Duy Thanh (HR Staff)",
        interviewResult: "Passed",
        technicalAssessment: "Exceeds requirements",
        softSkillsAssessment: "Excellent",
        overallScore: 5,
        hrRecommendation: "Recommend hire",
        hrComments: "Best fit for the position; proceed to contract.",
        evaluatedBy: "Tran Duy Thanh",
        evaluatedDate: "2025-09-26",
      },
    },
  ];

  /** Recruitment job postings */
  var MOCK_RECRUITMENTS = [
    {
      recruitmentId: 1,
      jobTitle: "Software Developer",
      jobDescription: "Develop and maintain web applications",
      requirement: "Java, Spring Boot, MySQL",
      location: "Hanoi",
      salary: 25000000,
      status: "New",
      applicant: 4,
      postedDate: "2025-09-01",
    },
  ];

  window.HrManager = {
    MSG: MSG,
    NAV: NAV,
    PAYROLL_STATUSES: PAYROLL_STATUSES,
    MOCK_EMPLOYEES: MOCK_EMPLOYEES,
    MOCK_PAYROLLS: MOCK_PAYROLLS,
    MOCK_CANDIDATES: MOCK_CANDIDATES,
    MOCK_RECRUITMENTS: MOCK_RECRUITMENTS,
    formatCurrency: formatCurrency,
    formatDate: formatDate,
    statusBadge: statusBadge,
    getQueryParam: getQueryParam,
    showToast: showToast,
    initLayout: initLayout,
    getPayrollById: getPayrollById,
    getEmployeeForPayroll: getEmployeeForPayroll,
    getCandidateById: getCandidateById,
    hasEvaluation: hasEvaluation,
    renderEvaluationFields: renderEvaluationFields,
    escapeHtml: escapeHtml,
  };

  function formatCurrency(amount) {
    return new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "VND",
      maximumFractionDigits: 0,
    }).format(amount);
  }

  function formatDate(str) {
    if (!str) return "-";
    var d = new Date(str);
    if (isNaN(d.getTime())) return str;
    return d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
  }

  function statusBadge(status) {
    var map = {
      Pending: "hr-badge-pending",
      Approved: "hr-badge-approved",
      Rejected: "hr-badge-rejected",
      Draft: "hr-badge-draft",
      Paid: "hr-badge-approved",
      Processing: "hr-badge-processing",
      Hired: "hr-badge-hired",
      New: "hr-badge-processing",
      Waiting: "hr-badge-pending",
      Applied: "hr-badge-processing",
    };
    var cls = map[status] || "hr-badge-draft";
    return '<span class="hr-badge ' + cls + '">' + escapeHtml(status) + "</span>";
  }

  function escapeHtml(s) {
    if (s == null) return "";
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function getQueryParam(name) {
    return new URLSearchParams(window.location.search).get(name);
  }

  function showToast(message) {
    var el = document.getElementById("hr-toast");
    if (!el) {
      el = document.createElement("div");
      el.id = "hr-toast";
      el.className = "hr-toast";
      document.body.appendChild(el);
    }
    el.textContent = message;
    el.classList.add("show");
    clearTimeout(el._timer);
    el._timer = setTimeout(function () {
      el.classList.remove("show");
    }, 3200);
  }

  function getPayrollById(id) {
    var n = parseInt(id, 10);
    return MOCK_PAYROLLS.find(function (p) {
      return p.payrollId === n;
    });
  }

  function getEmployeeForPayroll(payroll) {
    if (!payroll) return null;
    return (
      MOCK_EMPLOYEES[payroll.employeeId] || {
        name: "Employee #" + payroll.employeeId,
        dept: "-",
        position: "-",
        status: "-",
      }
    );
  }

  function getCandidateById(id) {
    var n = parseInt(id, 10);
    return MOCK_CANDIDATES.find(function (c) {
      return c.guestId === n;
    });
  }

  function hasEvaluation(candidate) {
    return !!(candidate && candidate.evaluation);
  }

  /** Read-only HR evaluation block */
  function renderEvaluationFields(ev) {
    if (!ev) {
      return (
        '<div class="hr-alert hr-alert-warning" role="alert">' +
        escapeHtml(MSG.NO_EVALUATION) +
        "</div>"
      );
    }
    var rows = [
      ["Interview Date", ev.interviewDate],
      ["Interview Time", ev.interviewTime],
      ["Interviewer", ev.interviewer],
      ["Interview Result", ev.interviewResult],
      ["Technical Assessment", ev.technicalAssessment],
      ["Soft Skills Assessment", ev.softSkillsAssessment],
      ["Overall Score (1-5)", ev.overallScore],
      ["HR Recommendation", ev.hrRecommendation],
      ["HR Comments", ev.hrComments],
      ["Evaluated By", ev.evaluatedBy],
      ["Evaluated Date", formatDate(ev.evaluatedDate)],
    ];
    return (
      '<ul class="hr-detail-list">' +
      rows
        .map(function (r) {
          return (
            "<li><span>" +
            escapeHtml(r[0]) +
            '</span><span><strong>' +
            escapeHtml(r[1]) +
            "</strong></span></li>"
          );
        })
        .join("") +
      "</ul>"
    );
  }

  function initLayout(pageId, pageTitle) {
    var sidebar = document.getElementById("hr-sidebar");
    var topbar = document.getElementById("hr-topbar");
    if (!sidebar || !topbar) return;

    var navHtml = '<div class="hr-brand"><h1>HRM System</h1><p>HR Manager</p></div><nav class="hr-nav">';
    NAV.forEach(function (section) {
      navHtml +=
        '<div class="hr-nav-section"><div class="hr-nav-label">' +
        escapeHtml(section.label) +
        "</div>";
      section.items.forEach(function (item) {
        var cls = item.id === pageId ? "active" : "";
        navHtml +=
          '<a href="' +
          escapeHtml(item.href) +
          '" class="' +
          cls +
          '">' +
          escapeHtml(item.text) +
          "</a>";
      });
      navHtml += "</div>";
    });
    navHtml += '</nav><div class="hr-sidebar-footer">SWP391 Group 1</div>';
    sidebar.innerHTML = navHtml;

    topbar.innerHTML =
      '<div><button type="button" class="hr-menu-toggle" id="hr-menu-toggle" aria-label="Open menu">Menu</button>' +
      "<h2>" +
      escapeHtml(pageTitle) +
      "</h2></div>" +
      '<div class="hr-topbar-meta">' +
      '<span class="hr-user-chip"><span class="avatar">TH</span><span><strong>Tran Duy Hien</strong><br>HR Manager</span></span>' +
      "</div>";

    var overlay = document.getElementById("hr-sidebar-overlay");
    if (!overlay) {
      overlay = document.createElement("div");
      overlay.id = "hr-sidebar-overlay";
      overlay.className = "hr-sidebar-overlay";
      document.body.appendChild(overlay);
    }

    var toggle = document.getElementById("hr-menu-toggle");
    if (toggle) {
      toggle.addEventListener("click", function () {
        sidebar.classList.toggle("open");
        overlay.classList.toggle("show");
      });
    }
    overlay.addEventListener("click", function () {
      sidebar.classList.remove("open");
      overlay.classList.remove("show");
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    var body = document.body;
    if (!body.classList.contains("hr-manager-app")) return;
    initLayout(body.getAttribute("data-page") || "", body.getAttribute("data-title") || "HR Manager");
  });
})();
