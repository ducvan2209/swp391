(function () {
  const pages = [
    ["dashboard.html", "Dashboard", "DB"],
    ["employee-list.html", "Employees", "ID"],
    ["employee-detail.html", "Employee Detail", "PR"],
    ["task-list.html", "Tasks", "TS"],
    ["task-create.html", "Create Task", "+"],
    ["task-detail.html", "Task Detail", "TD"],
    ["request-list.html", "Requests", "RQ"],
    ["request-detail.html", "Request Detail", "RD"],
    ["department-report.html", "Reports", "RP"]
  ];

  const titleMap = {
    "dashboard.html": ["Department Manager", "Operations Dashboard"],
    "employee-list.html": ["People", "Department Employees"],
    "employee-detail.html": ["Employee Profile", "Employee Detail"],
    "task-list.html": ["Execution", "Task Management"],
    "task-create.html": ["Execution", "Create Task"],
    "task-detail.html": ["Execution", "Task Detail"],
    "request-list.html": ["Approvals", "Request Approval"],
    "request-detail.html": ["Approvals", "Request Detail"],
    "department-report.html": ["Analytics", "Department Report"]
  };

  const current = location.pathname.split("/").pop() || "dashboard.html";

  function injectShell() {
    const sidebar = document.querySelector("[data-sidebar]");
    const topbar = document.querySelector("[data-topbar]");
    const footer = document.querySelector("[data-footer]");
    const pageTitle = titleMap[current] || titleMap["dashboard.html"];

    if (sidebar) {
      sidebar.innerHTML = `
        <div class="dm-brand">
          <div class="dm-brand-mark">HR</div>
          <div>
            <strong>Greenhouse HR</strong>
            <span>Manager Workspace</span>
          </div>
        </div>
        <nav class="dm-nav" aria-label="Department manager navigation">
          ${pages.map(([href, label, icon]) => `
            <a href="${href}" class="${href === current ? "is-active" : ""}">
              <span class="dm-nav-icon">${icon}</span>
              <span>${label}</span>
            </a>
          `).join("")}
        </nav>
        <div class="dm-sidebar-note">
          <strong>Department Pulse</strong>
          <p>IT Department is tracking ahead on delivery with 82% task completion this month.</p>
        </div>
      `;
    }

    if (topbar) {
      topbar.innerHTML = `
        <button class="mobile-menu" type="button" aria-label="Open navigation">Menu</button>
        <div>
          <p class="dm-page-kicker">${pageTitle[0]}</p>
          <h1 class="dm-page-title">${pageTitle[1]}</h1>
        </div>
        <div class="dm-top-actions">
          <input class="dm-search-top" type="search" placeholder="Search people, tasks, requests">
          <div class="dm-user">
            <span class="dm-user-avatar">ND</span>
            <div>
              <strong>Nguyen Dang</strong>
              <span>Department Manager</span>
            </div>
          </div>
        </div>
      `;
    }

    if (footer) {
      footer.innerHTML = `
        <span>&copy; 2026 Greenhouse HR Department Manager</span>
        <span>Premium HRM prototype &middot; Starbucks-inspired enterprise UI</span>
      `;
    }
  }

  function setupMobileNav() {
    document.addEventListener("click", (event) => {
      if (event.target.closest(".mobile-menu")) {
        document.body.classList.toggle("nav-open");
      }
      if (event.target.matches(".dm-nav a")) {
        document.body.classList.remove("nav-open");
      }
    });
  }

  function setupTables() {
    document.querySelectorAll("[data-table-card]").forEach((card) => {
      const search = card.querySelector("[data-table-search]");
      const filter = card.querySelector("[data-table-filter]");
      const rows = Array.from(card.querySelectorAll("tbody tr[data-status]"));

      function apply() {
        const query = (search?.value || "").trim().toLowerCase();
        const value = (filter?.value || "All").toLowerCase();
        let shown = 0;

        rows.forEach((row) => {
          const text = row.textContent.toLowerCase();
          const status = (row.dataset.status || "").toLowerCase();
          const matchesQuery = !query || text.includes(query);
          const matchesFilter = value === "all" || status === value;
          row.hidden = !(matchesQuery && matchesFilter);
          if (!row.hidden) shown += 1;
        });

        const empty = card.querySelector("[data-empty-row]");
        if (empty) empty.hidden = shown !== 0;
      }

      search?.addEventListener("input", apply);
      filter?.addEventListener("change", apply);
      apply();
    });
  }

  function setupButtons() {
    document.querySelectorAll("[data-toast]").forEach((button) => {
      button.addEventListener("click", () => showToast(button.dataset.toast));
    });
  }

  async function loadDashboardData() {
    if (window.location.protocol === "file:") {
      return;
    }

    const metricTargets = document.querySelectorAll("[data-dashboard-metric], [data-dashboard-chart], [data-dashboard-activities], [data-request-status-metric]");
    if (!metricTargets.length) {
      return;
    }

    const apiUrl = `${getApplicationRoot()}/api/department-manager/dashboard${getManagerQueryString()}`;
    try {
      const response = await fetch(apiUrl, { headers: { Accept: "application/json" } });
      if (!response.ok) {
        throw new Error(`Dashboard API returned ${response.status}`);
      }
      const dashboard = await response.json();
      applyDashboardMetrics(dashboard);
      applyDashboardCharts(dashboard);
      applyDashboardActivities(dashboard.recentActivities || []);
    } catch (error) {
      console.warn("Using static dashboard sample data because live data could not be loaded.", error);
    }
  }

  function getApplicationRoot() {
    const marker = "/department-manager/";
    const index = window.location.pathname.indexOf(marker);
    if (index === -1) {
      return "";
    }
    return window.location.pathname.slice(0, index);
  }

  function getManagerQueryString() {
    const params = new URLSearchParams(window.location.search);
    const managerEmployeeId = params.get("managerEmployeeId");
    return managerEmployeeId ? `?managerEmployeeId=${encodeURIComponent(managerEmployeeId)}` : "";
  }

  function applyDashboardMetrics(dashboard) {
    document.querySelectorAll("[data-dashboard-metric]").forEach((element) => {
      const key = element.dataset.dashboardMetric;
      if (dashboard[key] === undefined || dashboard[key] === null) {
        return;
      }
      element.textContent = `${dashboard[key]}${element.dataset.suffix || ""}`;
    });

    const requestStats = dashboard.requestStatistics || [];
    document.querySelectorAll("[data-request-status-metric]").forEach((element) => {
      const status = element.dataset.requestStatusMetric;
      const point = requestStats.find((item) => item.label === status);
      if (point) {
        element.textContent = point.value;
      }
    });
  }

  function applyDashboardCharts(dashboard) {
    document.querySelectorAll("[data-dashboard-chart]").forEach((canvas) => {
      const key = canvas.dataset.dashboardChart;
      const points = dashboard[key] || [];
      if (!points.length) {
        return;
      }
      canvas.dataset.labels = JSON.stringify(points.map((point) => point.label));
      canvas.dataset.values = JSON.stringify(points.map((point) => point.value));
    });
  }

  function applyDashboardActivities(activities) {
    const list = document.querySelector("[data-dashboard-activities]");
    if (!list || !activities.length) {
      return;
    }

    list.innerHTML = activities.map((activity) => `
      <li class="activity-item">
        <span class="activity-dot">${escapeHtml(activity.type || "AC")}</span>
        <div>
          <strong>${escapeHtml(activity.title || "Activity updated")}</strong>
          <span>${escapeHtml(activity.description || "")}</span>
        </div>
        <span class="badge ${escapeHtml(activity.badgeType || "neutral")}">${escapeHtml(activity.status || "Updated")}</span>
      </li>
    `).join("");
  }

  async function loadLivePageData() {
    if (window.location.protocol === "file:") {
      return;
    }

    if (document.querySelector("[data-dashboard-metric], [data-dashboard-chart], [data-dashboard-activities], [data-request-status-metric]")) {
      await loadDashboardData();
    }

    if (current === "employee-list.html") {
      await loadEmployeeList();
    } else if (current === "employee-detail.html") {
      await loadEmployeeDetail();
    } else if (current === "task-list.html") {
      await loadTaskList();
    } else if (current === "task-create.html") {
      await setupTaskCreate();
    } else if (current === "task-detail.html") {
      await loadTaskDetail();
    } else if (current === "request-list.html") {
      await loadRequestList();
    } else if (current === "request-detail.html") {
      await loadRequestDetail();
    }
  }

  async function fetchApi(resource, params = {}) {
    const query = new URLSearchParams(params);
    const pageParams = new URLSearchParams(window.location.search);
    const managerEmployeeId = pageParams.get("managerEmployeeId");
    if (managerEmployeeId && !query.has("managerEmployeeId")) {
      query.set("managerEmployeeId", managerEmployeeId);
    }
    const suffix = query.toString() ? `?${query}` : "";
    const response = await fetch(`${getApplicationRoot()}/api/department-manager/${resource}${suffix}`, {
      headers: { Accept: "application/json" }
    });
    if (!response.ok) {
      throw new Error(`${resource} API returned ${response.status}`);
    }
    return response.json();
  }

  async function loadEmployeeList() {
    try {
      const employees = await fetchApi("employees");
      const tbody = document.querySelector(".data-table tbody");
      if (!tbody) return;
      tbody.innerHTML = employees.map((employee) => `
        <tr data-status="${escapeHtml(employee.status || "Unknown")}">
          <td><span class="avatar">${escapeHtml(initials(employee.fullName))}</span></td>
          <td>EMP-${escapeHtml(employee.employeeId)}</td>
          <td><a href="employee-detail.html?id=${encodeURIComponent(employee.employeeId)}"><strong>${escapeHtml(employee.fullName)}</strong></a></td>
          <td>${escapeHtml(employee.position || "")}</td>
          <td>${escapeHtml(employee.email || "")}</td>
          <td>${escapeHtml(employee.phone || "")}</td>
          <td><span class="badge ${statusClass(employee.status)}">${escapeHtml(employee.status || "Unknown")}</span></td>
        </tr>
      `).join("") + `<tr data-empty-row hidden><td colspan="7" class="empty-row">No employees match the current filters.</td></tr>`;
      const countText = document.querySelector(".card-header p");
      if (countText) countText.textContent = `${employees.length} employees loaded from MySQL`;
    } catch (error) {
      console.warn("Employee data could not be loaded.", error);
    }
  }

  async function loadEmployeeDetail() {
    try {
      const id = getDetailId();
      const employee = id ? await fetchApi("employees", { id }) : (await fetchApi("employees"))[0];
      if (!employee) return;

      setText(".profile-hero .avatar", initials(employee.fullName));
      setText(".profile-hero h2", employee.fullName);
      setText(".profile-hero p", `${employee.position || ""} · ${employee.status || ""} · EMP-${employee.employeeId}`);
      renderInfoGrid(document.querySelectorAll(".info-grid")[0], [
        ["Email", employee.email],
        ["Phone", employee.phone],
        ["Date of Birth", employee.dob],
        ["Address", employee.address]
      ]);
      renderInfoGrid(document.querySelectorAll(".info-grid")[1], [
        ["Position", employee.position],
        ["Status", employee.status],
        ["Employment Period", employee.employmentPeriod],
        ["Department ID", employee.departmentId]
      ]);

      const tasks = await fetchApi("tasks");
      const employeeTasks = tasks.filter((task) => String(task.assignedEmployeeId) === String(employee.employeeId));
      const requests = await fetchApi("requests");
      const employeeRequests = requests.filter((item) => String(item.employeeId) === String(employee.employeeId));
      const statValues = document.querySelectorAll(".stat-card strong");
      if (statValues.length >= 4) {
        statValues[0].textContent = employeeTasks.length;
        statValues[1].textContent = employeeTasks.filter((task) => task.status === "Completed").length;
        statValues[2].textContent = employeeTasks.filter((task) => task.status === "In Progress" || task.status === "Waiting").length;
        statValues[3].textContent = employeeTasks.filter((task) => task.status === "Rejected").length;
      }
      const activityList = document.querySelector(".activity-list");
      if (activityList) {
        activityList.innerHTML = employeeRequests.map((item) => `
          <li class="activity-item">
            <span class="activity-dot">${escapeHtml(initials(item.requestType))}</span>
            <div><strong>${escapeHtml(item.requestType)}</strong><span>${escapeHtml(item.reason || "No reason provided")}</span></div>
            <span class="badge ${statusClass(item.status)}">${escapeHtml(item.status)}</span>
          </li>
        `).join("");
      }
    } catch (error) {
      console.warn("Employee detail could not be loaded.", error);
    }
  }

  async function loadTaskList() {
    try {
      const tasks = await fetchApi("tasks");
      const tbody = document.querySelector(".data-table tbody");
      if (!tbody) return;
      tbody.innerHTML = tasks.map((task) => `
        <tr data-status="${escapeHtml(task.status || "Unknown")}">
          <td><a href="task-detail.html?id=${encodeURIComponent(task.taskId)}"><strong>${escapeHtml(task.title)}</strong></a></td>
          <td>${escapeHtml(task.assignedEmployeeName || "Unassigned")}</td>
          <td>${escapeHtml(task.startDate || "")}</td>
          <td>${escapeHtml(task.dueDate || "")}</td>
          <td><span class="badge neutral">${escapeHtml(task.priority || "Normal")}</span></td>
          <td><span class="badge ${statusClass(task.status)}">${escapeHtml(task.status || "Unknown")}</span></td>
          <td><div class="btn-row"><a class="btn btn-ghost" href="task-detail.html?id=${encodeURIComponent(task.taskId)}">View</a></div></td>
        </tr>
      `).join("") + `<tr data-empty-row hidden><td colspan="7" class="empty-row">No tasks match the current filters.</td></tr>`;
      const countText = document.querySelector(".card-header p");
      if (countText) countText.textContent = `${tasks.length} tasks loaded from MySQL`;
    } catch (error) {
      console.warn("Task data could not be loaded.", error);
    }
  }

  async function setupTaskCreate() {
    try {
      const employees = await fetchApi("employees");
      const employeeSelect = document.querySelector("#employee");
      if (employeeSelect) {
        employeeSelect.innerHTML = employees.map((employee) => `<option value="${escapeHtml(employee.employeeId)}">${escapeHtml(employee.fullName)}</option>`).join("");
      }
      const form = document.querySelector(".form-grid");
      const createButton = form?.querySelector(".btn-primary");
      createButton?.addEventListener("click", async () => {
        const body = new URLSearchParams({
          title: document.querySelector("#taskTitle")?.value || "",
          description: document.querySelector("#description")?.value || "",
          assignedEmployeeId: employeeSelect?.value || "",
          priority: document.querySelector("#priority")?.value || "Normal",
          startDate: document.querySelector("#startDate")?.value || "",
          dueDate: document.querySelector("#dueDate")?.value || ""
        });
        const manager = new URLSearchParams(window.location.search).get("managerEmployeeId");
        if (manager) body.set("managerEmployeeId", manager);
        const response = await fetch(`${getApplicationRoot()}/api/department-manager/tasks`, {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body
        });
        if (!response.ok) throw new Error(`Create task returned ${response.status}`);
        const task = await response.json();
        showToast("Task created successfully");
        window.location.href = `task-detail.html?id=${encodeURIComponent(task.taskId)}`;
      });
    } catch (error) {
      console.warn("Create task data could not be loaded.", error);
    }
  }

  async function loadTaskDetail() {
    try {
      const task = await fetchApi("tasks", { id: getDetailId() });
      if (!task) return;
      setText(".hero-panel h2", task.title);
      setText(".hero-panel p", `Assigned to ${task.assignedEmployeeName || "Unassigned"}, due ${task.dueDate || "not set"}. Current status is ${task.status}.`);
      const infoGrids = document.querySelectorAll(".info-grid");
      renderInfoGrid(infoGrids[0], [
        ["Priority", task.priority || "Normal"],
        ["Status", task.status],
        ["Start Date", task.startDate],
        ["Due Date", task.dueDate]
      ]);
      setText(".profile-hero .avatar", initials(task.assignedEmployeeName));
      setText(".profile-hero h2", task.assignedEmployeeName || "Unassigned");
      setText(".profile-hero p", `Employee ID ${task.assignedEmployeeId || ""}`);
      document.querySelectorAll("[data-toast]").forEach((button) => {
        if (button.textContent.toLowerCase().includes("approve")) button.onclick = () => updateTaskStatus(task.taskId, "approve");
        if (button.textContent.toLowerCase().includes("reject")) button.onclick = () => updateTaskStatus(task.taskId, "reject");
      });
    } catch (error) {
      console.warn("Task detail could not be loaded.", error);
    }
  }

  async function updateTaskStatus(id, action) {
    const body = new URLSearchParams({ id, action });
    await fetch(`${getApplicationRoot()}/api/department-manager/tasks`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body
    });
    showToast(action === "approve" ? "Task approved" : "Task rejected");
    await loadTaskDetail();
  }

  async function loadRequestList() {
    try {
      const requests = await fetchApi("requests");
      const tbody = document.querySelector(".data-table tbody");
      if (!tbody) return;
      tbody.innerHTML = requests.map((item) => `
        <tr data-status="${escapeHtml(item.status || "Unknown")}">
          <td><strong>${escapeHtml(item.requestType || "")}</strong></td>
          <td>${escapeHtml(item.employeeName || `EMP-${item.employeeId}`)}</td>
          <td>${escapeHtml(item.startDate || item.endDate || "")}</td>
          <td><span class="badge ${statusClass(item.status)}">${escapeHtml(item.status || "Unknown")}</span></td>
          <td>
            <div class="btn-row">
              <a class="btn btn-ghost" href="request-detail.html?id=${encodeURIComponent(item.requestId)}">View</a>
              <button class="btn btn-ghost" data-request-action="approve" data-request-id="${escapeHtml(item.requestId)}">Approve</button>
              <button class="btn btn-ghost" data-request-action="reject" data-request-id="${escapeHtml(item.requestId)}">Reject</button>
            </div>
          </td>
        </tr>
      `).join("") + `<tr data-empty-row hidden><td colspan="5" class="empty-row">No requests match the current filters.</td></tr>`;
      const pendingToday = document.querySelector(".hero-metric strong");
      if (pendingToday) pendingToday.textContent = requests.filter((item) => item.status === "Pending").length;
      bindRequestButtons();
    } catch (error) {
      console.warn("Request data could not be loaded.", error);
    }
  }

  async function loadRequestDetail() {
    try {
      const request = await fetchApi("requests", { id: getDetailId() });
      if (!request) return;
      const employee = await fetchApi("employees", { id: request.employeeId });
      setText(".hero-panel h2", `${request.requestType} Request`);
      setText(".hero-panel p", `${employee?.fullName || request.employeeName || "Employee"} submitted this request. Current status is ${request.status}.`);
      const infoGrids = document.querySelectorAll(".info-grid");
      renderInfoGrid(infoGrids[0], [
        ["Name", employee?.fullName || request.employeeName],
        ["Email", employee?.email],
        ["Phone", employee?.phone],
        ["Position", employee?.position]
      ]);
      renderInfoGrid(infoGrids[1], [
        ["Type", request.requestType],
        ["Status", request.status],
        ["Submitted", request.startDate || ""],
        ["Duration", request.endDate ? `${request.startDate || ""} to ${request.endDate}` : "No date range"]
      ]);
      const reasonCard = document.querySelector(".grid-2 + .card p, .card p");
      if (reasonCard) reasonCard.textContent = request.reason || "No reason provided.";
      document.querySelectorAll("[data-toast]").forEach((button) => {
        if (button.textContent.toLowerCase().includes("approve")) button.onclick = () => updateRequestStatus(request.requestId, "approve");
        if (button.textContent.toLowerCase().includes("reject")) button.onclick = () => updateRequestStatus(request.requestId, "reject");
      });
    } catch (error) {
      console.warn("Request detail could not be loaded.", error);
    }
  }

  function bindRequestButtons() {
    document.querySelectorAll("[data-request-action]").forEach((button) => {
      button.addEventListener("click", () => updateRequestStatus(button.dataset.requestId, button.dataset.requestAction));
    });
  }

  async function updateRequestStatus(id, action) {
    const body = new URLSearchParams({ id, action });
    await fetch(`${getApplicationRoot()}/api/department-manager/requests`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body
    });
    showToast(action === "approve" ? "Request approved" : "Request rejected");
    if (current === "request-list.html") await loadRequestList();
    if (current === "request-detail.html") await loadRequestDetail();
  }

  function getDetailId() {
    return new URLSearchParams(window.location.search).get("id");
  }

  function renderInfoGrid(grid, items) {
    if (!grid) return;
    grid.innerHTML = items.map(([label, value]) => `
      <div class="info-item"><span>${escapeHtml(label)}</span><strong>${escapeHtml(value || "")}</strong></div>
    `).join("");
  }

  function setText(selector, value) {
    const element = document.querySelector(selector);
    if (element) element.textContent = value || "";
  }

  function initials(value) {
    const words = String(value || "").trim().split(/\s+/).filter(Boolean);
    if (!words.length) return "HR";
    if (words.length === 1) return words[0].slice(0, 2).toUpperCase();
    return `${words[0][0]}${words[words.length - 1][0]}`.toUpperCase();
  }

  function statusClass(status) {
    const normalized = String(status || "").toLowerCase();
    if (normalized.includes("active") || normalized.includes("approved") || normalized.includes("completed")) return "success";
    if (normalized.includes("progress") || normalized.includes("remote")) return "progress";
    if (normalized.includes("reject") || normalized.includes("resigned")) return "danger";
    return "pending";
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function showToast(message) {
    let toast = document.querySelector(".toast");
    if (!toast) {
      toast = document.createElement("div");
      toast.className = "toast";
      document.body.appendChild(toast);
    }
    toast.textContent = message || "Action completed";
    toast.classList.add("show");
    window.clearTimeout(showToast.timer);
    showToast.timer = window.setTimeout(() => toast.classList.remove("show"), 2400);
  }

  function drawCharts() {
    document.querySelectorAll("canvas[data-chart]").forEach((canvas) => {
      const ctx = canvas.getContext("2d");
      const type = canvas.dataset.chart;
      const labels = JSON.parse(canvas.dataset.labels || "[]");
      const values = JSON.parse(canvas.dataset.values || "[]");
      const width = canvas.width = canvas.offsetWidth * window.devicePixelRatio;
      const height = canvas.height = canvas.offsetHeight * window.devicePixelRatio;
      ctx.scale(window.devicePixelRatio, window.devicePixelRatio);
      ctx.clearRect(0, 0, width, height);

      if (type === "donut") drawDonut(ctx, canvas.offsetWidth, canvas.offsetHeight, labels, values);
      else drawBars(ctx, canvas.offsetWidth, canvas.offsetHeight, labels, values, type === "line");
    });
  }

  function drawBars(ctx, width, height, labels, values, asLine) {
    const pad = 34;
    const max = Math.max(...values, 1);
    const chartW = width - pad * 2;
    const chartH = height - pad * 2;

    ctx.strokeStyle = "#dde4dd";
    ctx.lineWidth = 1;
    for (let i = 0; i < 4; i++) {
      const y = pad + (chartH / 3) * i;
      ctx.beginPath();
      ctx.moveTo(pad, y);
      ctx.lineTo(width - pad, y);
      ctx.stroke();
    }

    const points = values.map((value, index) => {
      const x = pad + (chartW / Math.max(values.length - 1, 1)) * index;
      const y = pad + chartH - (value / max) * chartH;
      return { x, y, value };
    });

    if (asLine) {
      ctx.strokeStyle = "#00754A";
      ctx.lineWidth = 4;
      ctx.beginPath();
      points.forEach((point, index) => index ? ctx.lineTo(point.x, point.y) : ctx.moveTo(point.x, point.y));
      ctx.stroke();
      points.forEach((point) => {
        ctx.fillStyle = "#ffffff";
        ctx.beginPath();
        ctx.arc(point.x, point.y, 7, 0, Math.PI * 2);
        ctx.fill();
        ctx.strokeStyle = "#006241";
        ctx.lineWidth = 3;
        ctx.stroke();
      });
    } else {
      const barW = Math.max(18, chartW / values.length - 18);
      points.forEach((point) => {
        const barH = pad + chartH - point.y;
        const x = point.x - barW / 2;
        const grd = ctx.createLinearGradient(0, point.y, 0, height - pad);
        grd.addColorStop(0, "#00754A");
        grd.addColorStop(1, "#D7EADF");
        ctx.fillStyle = grd;
        roundRect(ctx, x, point.y, barW, barH, 8);
        ctx.fill();
      });
    }

    ctx.fillStyle = "#6f7f78";
    ctx.font = "600 12px Inter, Arial";
    ctx.textAlign = "center";
    labels.forEach((label, index) => {
      const x = pad + (chartW / Math.max(labels.length - 1, 1)) * index;
      ctx.fillText(label, x, height - 8);
    });
  }

  function drawDonut(ctx, width, height, labels, values) {
    const total = values.reduce((sum, value) => sum + value, 0) || 1;
    const cx = width / 2;
    const cy = height / 2;
    const radius = Math.min(width, height) / 2 - 26;
    const colors = ["#006241", "#00754A", "#C48B2C", "#A25F3D"];
    let start = -Math.PI / 2;

    values.forEach((value, index) => {
      const angle = (value / total) * Math.PI * 2;
      ctx.beginPath();
      ctx.arc(cx, cy, radius, start, start + angle);
      ctx.lineWidth = 30;
      ctx.strokeStyle = colors[index % colors.length];
      ctx.stroke();
      start += angle;
    });

    ctx.fillStyle = "#1E3932";
    ctx.font = "800 30px Inter, Arial";
    ctx.textAlign = "center";
    ctx.fillText(`${Math.round((values[0] / total) * 100)}%`, cx, cy + 6);
    ctx.fillStyle = "#6f7f78";
    ctx.font = "700 12px Inter, Arial";
    ctx.fillText(labels[0] || "Complete", cx, cy + 28);
  }

  function roundRect(ctx, x, y, w, h, r) {
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.arcTo(x + w, y, x + w, y + h, r);
    ctx.arcTo(x + w, y + h, x, y + h, r);
    ctx.arcTo(x, y + h, x, y, r);
    ctx.arcTo(x, y, x + w, y, r);
    ctx.closePath();
  }

  window.addEventListener("resize", () => {
    window.clearTimeout(drawCharts.timer);
    drawCharts.timer = window.setTimeout(drawCharts, 120);
  });

  document.addEventListener("DOMContentLoaded", async () => {
    injectShell();
    setupMobileNav();
    await loadLivePageData();
    setupTables();
    setupButtons();
    drawCharts();
  });
})();
