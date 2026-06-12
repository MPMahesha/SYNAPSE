<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>NeuroSyncBCI | Recover Access</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="glass-card">
                <h3 class="mb-4 text-center">Neural Key Recovery</h3>

                <% if(request.getParameter("email") == null) { %>
                    <!-- Step 1: Request OTP -->
                    <form action="${pageContext.request.contextPath}/auth/forgot-password" method="POST">
                        <div class="mb-4">
                            <label class="form-label">Registered Neural-ID (Email)</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-neon-purple">Generate Sync Token (OTP)</button>
                        </div>
                    </form>
                <% } else { %>
                    <!-- Step 2: Verify OTP and Reset -->
                    <form action="${pageContext.request.contextPath}/auth/reset-password" method="POST">
                        <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
                        <div class="mb-3">
                            <label class="form-label">Verification Token</label>
                            <input type="text" name="otp" class="form-control border-warning" required maxlength="6">
                            <small class="text-muted">Check console emulation logs for token</small>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">New Access Key</label>
                            <input type="password" name="newPassword" class="form-control" required minlength="8">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-neon-cyan">Sync & Restore Access</button>
                        </div>
                    </form>
                <% } %>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-muted small">Return to Gateway</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
