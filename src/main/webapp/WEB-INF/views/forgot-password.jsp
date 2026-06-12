<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE | Recover Access</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100">

<div id="custom-cursor"></div>
<a href="${pageContext.request.contextPath}/index.jsp" class="back-home" title="Return to Portal"><i class="bi bi-arrow-left-circle-fill"></i></a>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="glass-card">
                <h3 class="mb-4 text-center text-high-vis">Neural Key Recovery</h3>

                <% if(request.getParameter("email") == null) { %>
                    <!-- Step 1: Request OTP -->
                    <form action="${pageContext.request.contextPath}/auth/forgot-password" method="POST">
                        <div class="mb-4">
                            <label class="form-label text-cyan-vis">Registered Neural-ID (Email)</label>
                            <input type="email" name="email" class="form-control" required placeholder="user@synapse.com">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-synapse">Generate Sync Token (OTP)</button>
                        </div>
                    </form>
                <% } else { %>
                    <!-- Step 2: Verify OTP and Reset -->
                    <form action="${pageContext.request.contextPath}/auth/reset-password" method="POST">
                        <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
                        <div class="mb-3">
                            <label class="form-label text-cyan-vis">Verification Token</label>
                            <input type="text" name="otp" class="form-control border-warning" required maxlength="6" style="color:#fff;">
                            <small class="text-description">Check console emulation logs for token</small>
                        </div>
                        <div class="mb-4">
                            <label class="form-label text-cyan-vis">New Access Key</label>
                            <input type="password" name="newPassword" class="form-control" required minlength="8" placeholder="••••••••">
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-synapse btn-synapse-purple">Sync & Restore Access</button>
                        </div>
                    </form>
                <% } %>

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
