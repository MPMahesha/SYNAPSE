<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>NeuroSync | Telemetry Dashboard</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --bg: #050508; --panel: rgba(15, 15, 25, 0.8); --accent: #BD00FF; --cyan: #00F0FF; }
        body, html { margin: 0; padding: 0; background: var(--bg); color: #fff; font-family: 'JetBrains Mono', monospace; overflow: hidden; height: 100vh; }
        #bg-canvas { position: fixed; top: 0; left: 0; z-index: -1; }
        .grid-layout { display: grid; grid-template-columns: 320px 1fr 320px; grid-template-rows: 70px 1fr 180px; height: 100vh; gap: 10px; padding: 10px; box-sizing: border-box; }
        header { grid-column: 1 / span 3; background: var(--panel); border: 1px solid rgba(0, 240, 255, 0.15); display: flex; align-items: center; justify-content: space-between; padding: 0 25px; backdrop-filter: blur(15px); }
        .panel { background: var(--panel); border: 1px solid rgba(189, 0, 255, 0.1); backdrop-filter: blur(10px); padding: 15px; overflow-y: auto; }
        .main-stream { grid-column: 2; grid-row: 2; display: flex; flex-direction: column; gap: 10px; }
        .sidebar { grid-row: 2 / span 2; }
        .bottom-shelf { grid-column: 2; grid-row: 3; }
        h2 { font-size: 0.9rem; color: var(--cyan); border-bottom: 1px solid var(--cyan); padding-bottom: 5px; margin: 0 0 15px 0; text-transform: uppercase; }
        .stat-box { background: rgba(0,0,0,0.4); border-left: 2px solid var(--accent); padding: 12px; margin-bottom: 8px; }
        .stat-label { font-size: 0.7rem; color: #888; }
        .stat-value { font-size: 1.3rem; font-weight: bold; margin-top: 4px; }
        .live-dot { width: 8px; height: 8px; border-radius: 50%; background: #0f0; display: inline-block; margin-right: 10px; box-shadow: 0 0 10px #0f0; }
        #chart-wrap { flex: 1; min-height: 0; }
        .role-badge { background: var(--accent); padding: 4px 12px; border-radius: 4px; font-size: 0.7rem; font-weight: bold; }
    </style>
</head>
<body>
    <% 
        String role = (String) session.getAttribute("userRole"); 
        if(role == null) { response.sendRedirect("index.jsp"); return; } 
    %>
    <canvas id="bg-canvas"></canvas>

    <div class="grid-layout">
        <header>
            <div style="display: flex; align-items: center;">
                <div class="live-dot" id="socket-status"></div>
                <span style="letter-spacing: 4px; font-weight: 800; font-size: 1.1rem;">SYNAPSE TERMINAL v2.6.0</span>
            </div>
            <div>
                <span class="role-badge"><%= role %></span>
                <span style="margin-left: 15px; opacity: 0.6; font-size: 0.8rem;"><%= session.getAttribute("userEmail") %></span>
            </div>
        </header>

        <!-- Left Column: Primary Metrics -->
        <div class="panel sidebar">
            <h2>CORE TELEMETRY</h2>
            <div id="metrics-content">
                <% if("CLINICIAN".equals(role)) { %>
                    <div class="stat-box">
                        <div class="stat-label">ATTENTION LEVEL</div>
                        <div class="stat-value" id="val-att">0%</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">MEDITATION INDEX</div>
                        <div class="stat-value" id="val-med">0%</div>
                    </div>
                    <div class="stat-box" style="border-left-color: var(--cyan);">
                        <div class="stat-label">INTENT DECODED</div>
                        <div class="stat-value" id="val-intent" style="color: var(--cyan); font-size: 1.1rem;">RESTING...</div>
                    </div>
                <% } else { %>
                    <div class="stat-box">
                        <div class="stat-label">SAMPLING FREQUENCY</div>
                        <div class="stat-value">250 Hz</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">IMPEDANCE AVG</div>
                        <div class="stat-value" id="val-imp">4.2 kΩ</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-label">DATA PACKETS</div>
                        <div class="stat-value" id="val-packets">0</div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Center: Live Stream -->
        <div class="main-stream">
            <div class="panel" style="flex: 1; display: flex; flex-direction: column;">
                <h2>LIVE NEURAL STREAM</h2>
                <div id="chart-wrap">
                    <canvas id="neural-chart"></canvas>
                </div>
            </div>
        </div>

        <!-- Right Column: System Logs -->
        <div class="panel sidebar">
            <h2>EVENT LOG</h2>
            <div id="log-feed" style="font-size: 0.7rem; color: #666; line-height: 1.6;">
                <div>[SYSTEM] HANDSHAKE_INIT_SUCCESS</div>
                <div>[SYSTEM] SESSION_ESTABLISHED</div>
                <div>[SYSTEM] ATTACHING NEURAL PROBE...</div>
            </div>
        </div>

        <!-- Bottom: Spectral Matrix -->
        <div class="panel bottom-shelf">
            <h2>SPECTRAL POWER DENSITY (FFT)</h2>
            <div style="display: flex; justify-content: space-around; align-items: flex-end; height: 100px; padding-bottom: 10px;">
                <div style="text-align: center;"><div id="fft-delta" style="width: 25px; background: #ff4444; height: 10px; transition: height 0.1s;"></div><div style="font-size: 10px; margin-top: 5px;">Δ</div></div>
                <div style="text-align: center;"><div id="fft-theta" style="width: 25px; background: #ffbb33; height: 10px; transition: height 0.1s;"></div><div style="font-size: 10px; margin-top: 5px;">θ</div></div>
                <div style="text-align: center;"><div id="fft-alpha" style="width: 25px; background: #00C851; height: 10px; transition: height 0.1s;"></div><div style="font-size: 10px; margin-top: 5px;">α</div></div>
                <div style="text-align: center;"><div id="fft-beta" style="width: 25px; background: #33b5e5; height: 10px; transition: height 0.1s;"></div><div style="font-size: 10px; margin-top: 5px;">β</div></div>
            </div>
        </div>
    </div>

    <script>
        window.addEventListener("DOMContentLoaded", () => {
            const role = "<%= role %>";
            
            // --- Three.js Telemetry Background ---
            const scene = new THREE.Scene();
            const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('bg-canvas'), antialias: true, alpha: true });
            renderer.setSize(window.innerWidth, window.innerHeight);

            // meshA: Particle Node System
            const pCount = 800;
            const pGeo = new THREE.BufferGeometry();
            const pPos = new Float32Array(pCount * 3);
            for(let i=0; i<pCount*3; i++) pPos[i] = (Math.random() - 0.5) * 60;
            pGeo.setAttribute('position', new THREE.BufferAttribute(pPos, 3));
            const meshA = new THREE.Points(pGeo, new THREE.PointsMaterial({ color: 0x00F0FF, size: 0.08 }));
            scene.add(meshA);

            // meshB: Data Core
            const meshB = new THREE.Mesh(new THREE.IcosahedronGeometry(2, 1), new THREE.MeshBasicMaterial({ color: 0xBD00FF, wireframe: true, transparent: true, opacity: 0.15 }));
            scene.add(meshB);

            camera.position.z = 20;

            function animate() {
                requestAnimationFrame(animate);
                meshA.rotation.y += 0.0008;
                meshB.rotation.x += 0.004;
                meshB.rotation.z += 0.002;
                renderer.render(scene, camera);
            }
            animate();

            // --- Chart.js Signal Plotting ---
            const ctx = document.getElementById('neural-chart').getContext('2d');
            const dataSets = role === 'ENGINEER' ? [
                { label: 'CH1', data: [], borderColor: '#ff4444', borderWidth: 1, pointRadius: 0 },
                { label: 'CH2', data: [], borderColor: '#ffbb33', borderWidth: 1, pointRadius: 0 },
                { label: 'CH3', data: [], borderColor: '#00C851', borderWidth: 1, pointRadius: 0 },
                { label: 'CH4', data: [], borderColor: '#33b5e5', borderWidth: 1, pointRadius: 0 }
            ] : [
                { label: 'Activity Index', data: [], borderColor: '#BD00FF', borderWidth: 2, pointRadius: 0, fill: true, backgroundColor: 'rgba(189, 0, 255, 0.1)' }
            ];

            const neuralChart = new Chart(ctx, {
                type: 'line',
                data: { labels: Array(60).fill(''), datasets: dataSets },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    scales: { y: { min: -100, max: 100, grid: { color: 'rgba(255,255,255,0.05)' } }, x: { display: false } },
                    plugins: { legend: { display: false } },
                    animation: false
                }
            });

            // --- WebSocket Integration ---
            const socket = new WebSocket('ws://localhost:8765');
            const statusIndicator = document.getElementById('socket-status');
            const logFeed = document.getElementById('log-feed');
            let packets = 0;

            function log(msg, color="#888") {
                const div = document.createElement('div');
                div.style.color = color;
                div.innerHTML = "[" + new Date().toLocaleTimeString() + "] " + msg;
                logFeed.prepend(div);
                if(logFeed.children.length > 15) logFeed.lastChild.remove();
            }

            socket.onopen = () => { statusIndicator.style.background = '#0f0'; statusIndicator.style.boxShadow = '0 0 10px #0f0'; log("LINK_ESTABLISHED", "#0f0"); };
            socket.onclose = () => { statusIndicator.style.background = '#f00'; statusIndicator.style.boxShadow = '0 0 10px #f00'; log("LINK_SEVERED", "#f00"); };

            socket.onmessage = (event) => {
                const raw = JSON.parse(event.data);
                packets++;

                // Update Signal Charts
                if(role === 'ENGINEER') {
                    for(let i=0; i<4; i++) {
                        neuralChart.data.datasets[i].data.push(raw.raw_voltages[i]);
                        if(neuralChart.data.datasets[i].data.length > 60) neuralChart.data.datasets[i].data.shift();
                    }
                    document.getElementById('val-packets').innerText = packets;
                } else {
                    const avg = raw.raw_voltages.reduce((a,b)=>a+b,0) / raw.raw_voltages.length;
                    neuralChart.data.datasets[0].data.push(avg);
                    if(neuralChart.data.datasets[0].data.length > 60) neuralChart.data.datasets[0].data.shift();
                    
                    document.getElementById('val-att').innerText = Math.round(raw.spectral.beta * 8) + "%";
                    document.getElementById('val-med').innerText = Math.round(raw.spectral.alpha * 10) + "%";
                    
                    const intentEl = document.getElementById('val-intent');
                    intentEl.innerText = raw.intent.prediction.toUpperCase();
                    if(raw.intent.prediction !== "Rest") {
                        intentEl.style.color = "#0f0";
                        log(`INTENT_DECODED: ${raw.intent.prediction}`, "#00F0FF");
                    } else {
                        intentEl.style.color = "var(--cyan)";
                    }
                }
                neuralChart.update();

                // Update FFT Matrix
                document.getElementById('fft-delta').style.height = (raw.spectral.delta * 1.5) + 'px';
                document.getElementById('fft-theta').style.height = (raw.spectral.theta * 1.5) + 'px';
                document.getElementById('fft-alpha').style.height = (raw.spectral.alpha * 1.5) + 'px';
                document.getElementById('fft-beta').style.height = (raw.spectral.beta * 1.5) + 'px';
            };

            window.addEventListener('resize', () => { camera.aspect = window.innerWidth / window.innerHeight; camera.updateProjectionMatrix(); renderer.setSize(window.innerWidth, window.innerHeight); });
        });
    </script>
</body>
</html>
