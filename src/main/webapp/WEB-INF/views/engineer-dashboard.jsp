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
                <h5 class="mb-4">Real-Time Neural Streaming Analytics</h5>
                <canvas id="liveChart"></canvas>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card" style="height: 450px;">
                <h5>Hardware Health Log</h5>
                <div class="mt-3 small" id="log-console" style="height: 350px; overflow-y: auto; font-family: monospace;">
                    <div class="text-success">[08:45:01] System Handshake: SUCCESS</div>
                    <div class="text-info">[08:45:12] Neural Array 01 Calibration: STABLE</div>
                    <div class="text-warning">[08:45:30] Packet Loss detected: 0.02%</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('liveChart').getContext('2d');
    let chart;

    async function initChart() {
        const response = await fetch('${pageContext.request.contextPath}/dashboard/data');
        const data = await response.json();

        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels.map(l => l.split(' ')[1]), // Show only time
                datasets: [
                    {
                        label: 'SNR (dB)',
                        data: data.snr,
                        borderColor: '#00f5d4',
                        backgroundColor: 'rgba(0, 245, 212, 0.1)',
                        fill: true,
                        tension: 0.4
                    },
                    {
                        label: 'ITR (bpm)',
                        data: data.itr,
                        borderColor: '#ff0055',
                        backgroundColor: 'rgba(255, 0, 85, 0.1)',
                        fill: true,
                        tension: 0.4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        grid: { color: 'rgba(255,255,255,0.05)' },
                        ticks: { color: '#888' }
                    },
                    x: {
                        grid: { color: 'rgba(255,255,255,0.05)' },
                        ticks: { color: '#888' }
                    }
                },
                plugins: {
                    legend: { labels: { color: '#e0e0e0', font: { family: 'Rajdhani' } } }
                }
            }
        });
    }

    // Simulate Live Updates
    function simulateLiveFeed() {
        setInterval(() => {
            const time = new Date().toLocaleTimeString();
            const newSnr = (Math.random() * 2 + 8).toFixed(1);
            const newItr = (Math.random() * 5 + 25).toFixed(1);

            // Update Chart
            if (chart.data.labels.length > 10) {
                chart.data.labels.shift();
                chart.data.datasets[0].data.shift();
                chart.data.datasets[1].data.shift();
            }
            chart.data.labels.push(time);
            chart.data.datasets[0].data.push(newSnr);
            chart.data.datasets[1].data.push(newItr);
            chart.update('none');

            // Update Cards
            document.getElementById('avg-snr').innerText = newSnr + ' dB';
            document.getElementById('avg-itr').innerText = newItr + ' bpm';

            // Log
            const log = document.getElementById('log-console');
            const entry = document.createElement('div');
            entry.className = Math.random() > 0.8 ? 'text-warning' : 'text-info';
            entry.innerText = `[${time}] Live Stream Sync: OK (${newSnr} dB)`;
            log.prepend(entry);
        }, 3000);
    }

    initChart().then(simulateLiveFeed);
</script>

</body>
</html>
