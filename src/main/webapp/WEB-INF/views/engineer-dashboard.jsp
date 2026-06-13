<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Engineer Dashboard | SYNAPSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<nav class="navbar navbar-expand-lg border-bottom border-secondary mb-4">
    <div class="container-fluid px-4">
        <a class="navbar-brand neon-text-cyan" href="#">SYNAPSE</a>
        <div class="ms-auto">
            <span class="text-muted me-3">System Engineer: <span class="text-neon-purple">${user}</span></span>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-danger btn-sm">Terminate Session</a>
        </div>
    </div>
</nav>

<div class="container-fluid px-4">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="#" class="text-neon-cyan text-decoration-none">Global Fleet</a></li>
            <li class="breadcrumb-item active text-muted">Subject #BCI-2002 (Gordon Freeman)</li>
        </ol>
    </nav>

    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="glass-card">
                <p class="text-muted small mb-1">Signal-to-Noise Ratio (Avg)</p>
                <h3 class="text-neon-cyan" id="avg-snr">9.1 dB</h3>
                <div class="progress bg-dark" style="height: 4px;">
                    <div class="progress-bar bg-info" style="width: 75%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card">
                <p class="text-muted small mb-1">Electrode Impedance</p>
                <h3 class="text-neon-purple" id="avg-impedance">58.2 kΩ</h3>
                <div class="progress bg-dark" style="height: 4px;">
                    <div class="progress-bar bg-primary" style="width: 60%"></div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card">
                <p class="text-muted small mb-1">Info Transfer Rate (ITR)</p>
                <h3 class="text-neon-magenta" id="avg-itr">28.5 bpm</h3>
                <div class="progress bg-dark" style="height: 4px;">
                    <div class="progress-bar bg-danger" style="width: 85%"></div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="glass-card mb-4" style="height: 450px;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="mb-0">Real-Time Neural Streaming Analytics</h5>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="dspToggle" checked>
                        <label class="form-check-label small text-muted" for="dspToggle">Signal Processing (DSP)</label>
                    </div>
                </div>
                <canvas id="liveChart"></canvas>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card" style="height: 450px;">
                <h5>Hardware Health Log</h5>
                <div class="mt-3 small" id="log-console" style="height: 350px; overflow-y: auto; font-family: monospace;">
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('liveChart').getContext('2d');
    let chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Neural Signal (uV)',
                data: [],
                borderColor: '#00F0FF',
                backgroundColor: 'rgba(0, 240, 255, 0.1)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#888' } },
                x: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#888' } }
            },
            plugins: { legend: { display: false } }
        }
    });

    const socket = new WebSocket('ws://' + window.location.host + '${pageContext.request.contextPath}/neuralstream');
    const log = document.getElementById('log-console');

    socket.onmessage = (event) => {
        try {
            const data = JSON.parse(event.data);
            const time = new Date().toLocaleTimeString();
            
            // Update Chart
            if (chart.data.labels.length > 50) {
                chart.data.labels.shift();
                chart.data.datasets[0].data.shift();
            }
            chart.data.labels.push(time);
            chart.data.datasets[0].data.push(data.signal_matrix.ch1);
            chart.update('none');

            // Update Analytics Cards
            document.getElementById('avg-snr').innerText = (data.decoder_analytics.confidence_score * 10).toFixed(1) + ' dB';
            document.getElementById('avg-itr').innerText = (data.decoder_analytics.inference_latency_ms * 2).toFixed(1) + ' bpm';

            // Terminal Intent Logging
            if (data.telemetry_header.frame_id % 25 === 0) {
                const entry = document.createElement('div');
                entry.className = data.telemetry_header.frame_id === -1 ? 'text-warning' : 'text-info';
                const intent = data.decoder_analytics.predicted_intent;
                const conf = (data.decoder_analytics.confidence_score * 100).toFixed(2);
                const lat = data.decoder_analytics.inference_latency_ms;
                
                entry.innerText = data.telemetry_header.frame_id === -1 ? 
                    `[${time}] SYSTEM -> Python Core Offline. Broadcast: FALLBACK MOCK` :
                    `[${time}] CORE DETECT -> Intent: [${intent}] | Confidence: ${conf}% | ML Latency: ${lat} ms`;
                
                log.prepend(entry);
                if (log.childNodes.length > 100) log.removeChild(log.lastChild);
            }
        } catch(e) { console.error("Data Parse Error", e); }
    };

    document.getElementById('dspToggle').addEventListener('change', (e) => {
        try {
            socket.send(JSON.stringify({
                command: "TOGGLE_DSP",
                state: e.target.checked
            }));
            const entry = document.createElement('div');
            entry.className = e.target.checked ? 'text-success' : 'text-danger';
            entry.innerText = `[${new Date().toLocaleTimeString()}] CONTROL -> DSP Filter: ${e.target.checked ? 'ENABLED' : 'DISABLED (RAW MODE)'}`;
            log.prepend(entry);
        } catch(e) { console.error("Command send failed", e); }
    });
</script>

</body>
</html>
