<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clinician Dashboard | NeuroSyncBCI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>

<nav class="navbar navbar-expand-lg border-bottom border-secondary mb-4">
    <div class="container-fluid px-4">
        <a class="navbar-brand text-neon-purple" href="#">NeuroSync<span style="color:var(--electric-cyan)">BCI</span></a>
        <div class="ms-auto">
            <span class="text-muted me-3">Clinician: <span class="text-neon-cyan">${user}</span></span>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-danger btn-sm">Terminate Session</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="glass-card text-center py-4">
                <h2 class="text-neon-purple">12</h2>
                <p class="mb-0 text-muted">Active Patients</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card text-center py-4">
                <h2 class="text-neon-cyan">4</h2>
                <p class="mb-0 text-muted">Awaiting Implantation</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card text-center py-4">
                <h2 class="text-neon-magenta">2</h2>
                <p class="mb-0 text-muted">Urgent Review</p>
            </div>
        </div>
        <div class="col-md-3">
            <div class="glass-card text-center py-4">
                <h2 class="text-white">98%</h2>
                <p class="mb-0 text-muted">Protocol Compliance</p>
            </div>
        </div>
    </div>

    <div class="glass-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0">Patient Population Registry</h4>
            <button class="btn btn-neon-cyan btn-sm"><i class="bi bi-plus-lg"></i> Register New Subject</button>
        </div>
        
        <div class="table-responsive">
            <table class="table align-middle">
                <thead>
                    <tr>
                        <th>Subject ID</th>
                        <th>Name</th>
                        <th>Status</th>
                        <th>MoCA Score</th>
                        <th>ALSFRS-R</th>
                        <th>Eligibility</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${patients}" var="p">
                        <tr>
                            <td>#BCI-${p.id}00${p.id}</td>
                            <td>${p.name}</td>
                            <td>
                                <span class="status-badge ${p.status == 'POST_OP' ? 'badge-postop' : 'badge-preop'}">
                                    ${p.status}
                                </span>
                            </td>
                            <td class="text-info">${p.moca != null ? p.moca : '--'}</td>
                            <td class="text-warning">${p.alsfrs != null ? p.alsfrs : '--'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.moca >= 26}">
                                        <span class="text-success"><i class="bi bi-check-circle-fill"></i> Optimized</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-warning"><i class="bi bi-exclamation-triangle"></i> Review Req.</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-outline-info">View Record</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>
