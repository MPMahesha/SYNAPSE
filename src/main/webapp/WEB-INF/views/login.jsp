<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE | Secure Portal</title>
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
        <div class="col-md-5">
            <div class="text-center mb-4">
                <h1 class="neon-text-purple">SYNAPSE</h1>
                <p class="text-muted-bright">Clinical Interface & Analytics v2.0</p>
            </div>
            
            <div class="glass-card">
                <h3 class="mb-4 text-center text-high-vis">Identity Verification</h3>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger bg-transparent text-danger border-danger mb-3">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <% if(request.getParameter("success") != null) { %>
                    <div class="alert alert-success bg-transparent text-success border-success mb-3">
                        Registration successful. Please login.
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth/login" method="POST" id="loginForm">
                    <div class="mb-3">
                        <label class="form-label text-cyan-vis">Neural-ID (Email)</label>
                        <input type="email" name="email" class="form-control" required 
                               placeholder="user@synapse.com">
                    </div>
                    <div class="mb-4">
                        <label class="form-label text-cyan-vis">Access Key (Password)</label>
                        <input type="password" name="password" class="form-control" required 
                               minlength="8" placeholder="••••••••">
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-synapse py-2">Initialize Session</button>
                    </div>
                </form>

                <div class="mt-4 text-center">
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="text-decoration-none text-muted-bright small me-3">Forgot Access Key?</a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="text-decoration-none neon-text-cyan small">New Clinician? Register</a>
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
