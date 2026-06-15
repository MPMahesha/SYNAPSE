<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE | Protocol Enrollment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100">

<!-- Escape Hatch to Main Portal -->
<a href="${pageContext.request.contextPath}/index.jsp" class="back-home" title="Return to SYNAPSE Portal">
    <i class="bi bi-arrow-left-circle-fill"></i>
</a>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="text-center mb-4">
                <h2 class="neon-text-cyan">System Enrollment</h2>
                <p class="text-muted-bright">Authorization required for clinical access</p>
            </div>
            
            <div class="glass-card">
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger bg-transparent text-danger border-danger mb-3">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth/register" method="POST">
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form-label text-cyan-vis">System Authorization Key</label>
                            <input type="text" name="systemKey" class="form-control border-info" required 
                                   placeholder="NS-CLINIC-XXXX-XXX">
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label text-cyan-vis">Create Neural-ID (Username)</label>
                            <input type="text" name="username" class="form-control" required placeholder="Choose a unique username">
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label text-cyan-vis">Professional Email</label>
                            <input type="email" name="email" class="form-control" required placeholder="user@synapse.com">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-cyan-vis">Set Access Key</label>
                            <input type="password" name="password" class="form-control" required minlength="8" placeholder="••••••••">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label text-cyan-vis">System Role</label>
                            <select name="role" class="form-control">
                                <option value="CLINICIAN">CLINICIAN</option>
                                <option value="ENGINEER">ENGINEER</option>
                            </select>
                        </div>
                    </div>
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-synapse py-2">Activate Account</button>
                    </div>
                </form>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-muted-bright small">Return to Gateway</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const cursor = document.getElementById('custom-cursor');
    document.addEventListener('mousemove', e => {
        cursor.style.left = e.clientX + 'px';
        cursor.style.top = e.clientY + 'px';
    });
</script>
</body>
</html>
