<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE | 2FA Verification</title>
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
            <div class="glass-card text-center">
                <div class="mb-4">
                    <h2 class="neon-text-purple">IDENTITY</h2>
                    <h3 class="neon-text-cyan">VERIFICATION</h3>
                </div>
                
                <p class="text-description mb-4">A 6-digit sync token has been routed to <strong class="text-high-vis"><%= request.getAttribute("email") != null ? request.getAttribute("email") : request.getParameter("email") %></strong>. Entry required for protocol activation.</p>

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
                               style="letter-spacing: 10px; font-size: 2rem; background: rgba(0,240,255,0.05); color: #fff;">
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-synapse py-3">Activate Neural Link</button>
                    </div>
                </form>

                <div class="mt-4">
                    <small class="text-description">Token expires in 5:00. <a href="#" class="text-decoration-none neon-text-cyan">Resend</a></small>
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
