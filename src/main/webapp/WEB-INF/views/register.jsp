<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>NeuroSyncBCI | Protocol Enrollment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="text-center mb-4">
                <h2 class="text-neon-cyan">System Enrollment</h2>
                <p class="text-muted">Authorization required for clinical access</p>
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
                            <label class="form-label">System Authorization Key</label>
                            <input type="text" name="systemKey" class="form-control border-info" required 
                                   placeholder="NS-CLINIC-XXXX-XXX">
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label">Professional Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Set Access Key</label>
                            <input type="password" name="password" class="form-control" required minlength="8">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">System Role</label>
                            <select name="role" class="form-control">
                                <option value="CLINICIAN">CLINICIAN</option>
                                <option value="ENGINEER">ENGINEER</option>
                            </select>
                        </div>
                    </div>
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-neon-cyan py-2">Activate Account</button>
                    </div>
                </form>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-muted small">Return to Gateway</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
