<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>2FA Verification | NeuroSyncBCI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="d-flex align-items-center min-vh-100">

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="glass-card text-center">
                <div class="mb-4">
                    <h2 class="neon-text-purple">IDENTITY</h2>
                    <h3 class="neon-text-cyan">VERIFICATION</h3>
                </div>
                
                <p class="text-muted mb-4">A 6-digit sync token has been routed to <strong><%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %></strong>. Entry required for protocol activation.</p>

                <% if(request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger bg-transparent text-danger border-danger mb-4">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/auth/verify-otp" method="POST">
                    <input type="hidden" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %>">
                    <div class="mb-4">
                        <input type="text" name="otp" class="form-control form-control-lg text-center border-info" 
                               placeholder="0 0 0 0 0 0" maxlength="6" required 
                               style="letter-spacing: 10px; font-size: 2rem; background: rgba(0,240,255,0.05);">
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-neon-cyan py-3">Activate Neural Link</button>
                    </div>
                </form>

                <div class="mt-4">
                    <small class="text-muted">Token expires in 5:00. <a href="#" class="text-decoration-none text-info">Resend</a></small>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
