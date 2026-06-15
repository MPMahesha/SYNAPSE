<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE v3.0 | Research Terminal</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --bg: #050508; --panel: rgba(15, 15, 25, 0.85); --accent: #BD00FF; --cyan: #00F0FF; --text: #e0e0e0; --dim: #666; }
        body, html { margin: 0; padding: 0; background: var(--bg); color: var(--text); font-family: 'JetBrains Mono', monospace; overflow: hidden; height: 100vh; }
        #bg-canvas { position: fixed; top: 0; left: 0; z-index: -1; }
        
        .grid-layout { display: grid; grid-template-columns: 320px 1fr 320px; grid-template-rows: 70px 1fr 200px; height: 100vh; gap: 10px; padding: 10px; box-sizing: border-box; }
        
        header { 
            grid-column: 1 / span 3; background: var(--panel); border: 1px solid rgba(189, 0, 255, 0.2); 
            display: flex; align-items: center; justify-content: space-between; padding: 0 25px; backdrop-filter: blur(15px); 
        }

        /* Profile Menu & Modals */
        .profile-menu { position: relative; }
        .profile-btn { background: var(--accent); padding: 5px 15px; border-radius: 4px; font-size: 0.7rem; cursor: pointer; font-weight: bold; }
        .dropdown { 
            position: absolute; top: 100%; right: 0; background: #12121c; border: 1px solid var(--accent); 
            display: none; width: 200px; z-index: 1000; box-shadow: 0 10px 30px rgba(0,0,0,0.8);
        }
        .dropdown a, .dropdown div { display: block; padding: 12px 20px; color: #fff; text-decoration: none; font-size: 0.75rem; border-bottom: 1px solid #222; cursor: pointer; }
        .dropdown div:hover, .dropdown a:hover { background: var(--accent); }
        .profile-menu:hover .dropdown { display: block; }

        .modal { 
            display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); 
            width: 400px; background: #12121c; border: 1px solid var(--cyan); z-index: 2000; padding: 30px; 
            box-shadow: 0 0 100px rgba(0, 240, 255, 0.2);
        }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 1999; }

        /* Panels */
        .panel { background: var(--panel); border: 1px solid rgba(189, 0, 255, 0.1); backdrop-filter: blur(10px); padding: 15px; overflow: hidden; display: flex; flex-direction: column; }
        .sidebar { grid-row: 2 / span 2; gap: 10px; overflow-y: auto; }
        .main-view { grid-column: 2; grid-row: 2; gap: 10px; }
        .bottom-shelf { grid-column: 2; grid-row: 3; }

        h2 { font-size: 0.75rem; color: var(--cyan); border-bottom: 1px solid rgba(0, 240, 255, 0.3); padding-bottom: 5px; margin: 0 0 12px 0; text-transform: uppercase; letter-spacing: 1px; }
        .metric-box { background: rgba(0,0,0,0.4); border-left: 3px solid var(--accent); padding: 12px; margin-bottom: 8px; position: relative; }
        .metric-label { font-size: 0.6rem; color: var(--dim); display: flex; justify-content: space-between; align-items: center; }
        .metric-value { font-size: 1.3rem; font-weight: bold; margin-top: 5px; }
        
        /* Tooltip */
        .tooltip { visibility: hidden; position: absolute; bottom: 100%; left: 0; background: #333; color: #fff; padding: 10px; border-radius: 4px; font-size: 0.65rem; width: 200px; z-index: 10; opacity: 0; transition: opacity 0.3s; pointer-events: none; border: 1px solid var(--accent); }
        .metric-box:hover .tooltip { visibility: visible; opacity: 1; }

        /* FFT Bars Fix */
        .fft-container { display: flex; justify-content: space-around; align-items: flex-end; height: 120px; padding-bottom: 20px; overflow: hidden; }
        .fft-col { display: flex; flex-direction: column; align-items: center; width: 40px; }
        .fft-bar { width: 100%; background: linear-gradient(to top, var(--accent), var(--cyan)); transition: height 0.1s ease-out; }
        .fft-label { font-size: 0.6rem; margin-top: 8px; color: var(--cyan); }

        .live-dot { width: 8px; height: 8px; border-radius: 50%; background: #0f0; display: inline-block; margin-right: 10px; box-shadow: 0 0 10px #0f0; }
        .status-text { font-size: 0.65rem; color: var(--dim); }
        
        /* Role Toggle Classes */
        .clinician-only, .engineer-only { display: none; }
        body[data-role="CLINICIAN"] .clinician-only { display: block; }
        body[data-role="ENGINEER"] .engineer-only { display: block; }

        #waveform-wrap { flex: 1; min-height: 0; position: relative; }
        #log-feed { font-size: 0.65rem; line-height: 1.5; color: #888; overflow-y: auto; flex: 1; }
        .log-entry { margin-bottom: 4px; border-bottom: 1px solid #222; padding-bottom: 2px; }
        .log-info { color: var(--cyan); }
        .log-warn { color: #ffaa00; }
    </style>
</head>
<body data-role="<%= session.getAttribute("userRole") %>">
    <% 
        String role = (String) session.getAttribute("userRole"); 
        if(role == null) { response.sendRedirect("index.jsp"); return; } 
    %>
    <canvas id="bg-canvas"></canvas>

    <div class="grid-layout">
        <header>
            <div style="display: flex; align-items: center;">
                <div class="live-dot" id="socket-status"></div>
                <div>
                    <div style="font-weight: 900; letter-spacing: 3px; font-size: 0.9rem;">SYNAPSE v3.0 TERMINAL</div>
                    <div class="status-text">SESSION: <span id="session-timer">00:00:00</span> | LINK: NOMINAL</div>
                </div>
            </div>
            <div class="profile-menu">
                <span class="profile-btn">PROFILE ▼</span>
                <div class="dropdown">
                    <div onclick="showModal('profile-modal')">User Profile</div>
                    <div onclick="showModal('settings-modal')">System Settings</div>
                    <div onclick="toggleWorkspace()">Switch Workspace</div>
                    <a href="logout">Secure Logout</a>
                </div>
            </div>
        </header>

        <!-- Sidebar: Metrics -->
        <div class="panel sidebar">
            <!-- CLINICIAN SIDEBAR -->
            <div class="clinician-only">
                <h2>PATIENT OUTCOMES</h2>
                <div class="metric-box">
                    <div class="metric-label">ATTENTION LEVEL ⓘ<span class="tooltip">Derived from Beta/Gamma neural activity. Indicates cognitive engagement.</span></div>
                    <div class="metric-value" id="val-att">0%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">MEDITATION INDEX ⓘ<span class="tooltip">Derived from Alpha/Theta neural activity. Indicates mental relaxation.</span></div>
                    <div class="metric-value" id="val-med">0%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">FATIGUE STATE ⓘ<span class="tooltip">Calculated from session duration and attention trends. Prevents overexertion.</span></div>
                    <div class="metric-value" id="val-fatigue" style="color: var(--cyan);">LOW</div>
                </div>
                
                <h2 style="margin-top: 20px;">NEUROPLASTICITY PANEL</h2>
                <div class="metric-box">
                    <div class="metric-label">DECODER ACCURACY</div>
                    <div class="metric-value" id="val-acc">92.4%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">CLASSIFIED TRIALS</div>
                    <div class="metric-value" id="val-trials">1245</div>
                </div>
            </div>

            <!-- ENGINEER SIDEBAR -->
            <div class="engineer-only">
                <h2>HARDWARE DIAGNOSTICS</h2>
                <div class="metric-box">
                    <div class="metric-label">SAMPLING FREQUENCY</div>
                    <div class="metric-value">250 Hz</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">SIGNAL QUALITY ⓘ<span class="tooltip">Aggregated score based on SNR, Noise Floor, and Packet Integrity.</span></div>
                    <div class="metric-value" id="val-quality">EXCELLENT</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">SNR (dB) ⓘ<span class="tooltip">Signal-to-Noise Ratio. Target range: 15-35 dB for research grade.</span></div>
                    <div class="metric-value" id="val-snr">0.0</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">IMPEDANCE (kΩ) ⓘ<span class="tooltip">Electrode contact resistance. Realistic research range: 2-15 kΩ.</span></div>
                    <div class="metric-value" id="val-imp">0.0</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">PACKET LOSS ⓘ<span class="tooltip">Calculated from stream continuity. Threshold: <0.5% for stability.</span></div>
                    <div class="metric-value" id="val-loss">0.0%</div>
                </div>
            </div>
        </div>

        <!-- Main View: Stream & Intent -->
        <div class="main-view panel">
            <h2>REAL-TIME EEG STREAM (CH: C3, C4, CZ, PZ)</h2>
            <div id="waveform-wrap">
                <canvas id="neural-chart"></canvas>
            </div>
            
            <div style="display: flex; gap: 10px; height: 120px;">
                <div class="panel" style="flex: 2;">
                    <h2>INTENT DECODER (HYSTERESIS)</h2>
                    <div style="display: flex; justify-content: space-between; align-items: center; height: 100%;">
                        <div>
                            <div class="metric-label">CURRENT INTENT</div>
                            <div style="font-size: 1.5rem; font-weight: 900; color: var(--cyan);" id="val-intent">CALIBRATING...</div>
                        </div>
                        <div style="text-align: right;">
                            <div class="metric-label">CONFIDENCE</div>
                            <div style="font-size: 1.2rem; font-weight: bold;" id="val-conf">0%</div>
                            <div style="font-size: 0.6rem; color: var(--dim);">STABILITY: <span id="val-stability">LOW</span></div>
                        </div>
                    </div>
                </div>
                <div class="panel engineer-only" style="flex: 1;">
                    <h2>BENCHMARKS</h2>
                    <div style="font-size: 0.65rem; display: grid; grid-template-columns: 1fr 1fr; gap: 5px;">
                        <span>LATENCY: 2.3ms</span><span>MODEL: EEGNet</span>
                        <span>F1 SCORE: 0.89</span><span>JITTER: <1ms</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Event Log -->
        <div class="panel sidebar">
            <h2><%= "CLINICIAN".equals(role) ? "CLINICAL" : "SYSTEM" %> EVENT LOG</h2>
            <div id="log-feed"></div>
        </div>

        <!-- Spectral Analysis -->
        <div class="panel bottom-shelf">
            <h2>SPECTRAL POWER DENSITY (NORMALIZED FFT)</h2>
            <div class="fft-container">
                <div class="fft-col"><div id="fft-delta" class="fft-bar" style="height: 0px;"></div><div class="fft-label">Δ</div></div>
                <div class="fft-col"><div id="fft-theta" class="fft-bar" style="height: 0px;"></div><div class="fft-label">θ</div></div>
                <div class="fft-col"><div id="fft-alpha" class="fft-bar" style="height: 0px;"></div><div class="fft-label">α</div></div>
                <div class="fft-col"><div id="fft-beta" class="fft-bar" style="height: 0px;"></div><div class="fft-label">β</div></div>
                <div class="fft-col"><div id="fft-gamma" class="fft-bar" style="height: 0px;"></div><div class="fft-label">γ</div></div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <div class="modal-overlay" id="modal-overlay" onclick="closeModals()"></div>
    <div class="modal" id="profile-modal">
        <h2>USER PROFILE</h2>
        <p style="font-size: 0.8rem;">IDENTITY: <%= session.getAttribute("userEmail") %></p>
        <p style="font-size: 0.8rem;">ASSIGNED ROLE: <%= session.getAttribute("userRole") %></p>
        <p style="font-size: 0.8rem;">ACCESS LEVEL: RESEARCH-LEVEL-3</p>
        <button onclick="closeModals()" style="background: var(--cyan); border: none; padding: 10px; width: 100%; cursor: pointer;">CLOSE</button>
    </div>
    <div class="modal" id="settings-modal">
        <h2>SYSTEM SETTINGS</h2>
        <label style="font-size: 0.7rem; color: var(--dim);">TARGET PORT: 8765</label><br>
        <label style="font-size: 0.7rem; color: var(--dim);">DSP FILTER: 0.5-45Hz BANDPASS</label><br>
        <label style="font-size: 0.7rem; color: var(--dim);">WINDOW SIZE: 250 SAMPLES</label>
        <button onclick="closeModals()" style="background: var(--accent); border: none; padding: 10px; width: 100%; margin-top: 20px; cursor: pointer; color: #fff;">APPLY</button>
    </div>

    <script>
        // --- State Management ---
        const startTime = Date.now();
        let currentRole = "<%= role %>";

        function updateTimer() {
            const elapsed = Math.floor((Date.now() - startTime) / 1000);
            const h = String(Math.floor(elapsed / 3600)).padStart(2, '0');
            const m = String(Math.floor((elapsed % 3600) / 60)).padStart(2, '0');
            const s = String(elapsed % 60).padStart(2, '0');
            document.getElementById('session-timer').innerText = h + ":" + m + ":" + s;
        }
        setInterval(updateTimer, 1000);

        function showModal(id) {
            document.getElementById('modal-overlay').style.display = 'block';
            document.getElementById(id).style.display = 'block';
        }
        function closeModals() {
            document.getElementById('modal-overlay').style.display = 'none';
            document.querySelectorAll('.modal').forEach(m => m.style.display = 'none');
        }
        function toggleWorkspace() {
            currentRole = currentRole === 'CLINICIAN' ? 'ENGINEER' : 'CLINICIAN';
            document.body.setAttribute('data-role', currentRole);
            addLog("Switched to " + currentRole + " Workspace", "info");
        }

        // --- Visuals ---
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('bg-canvas'), alpha: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        const pGeo = new THREE.BufferGeometry();
        const pCount = 800;
        const pPos = new Float32Array(pCount * 3);
        for(let i=0; i<pCount*3; i++) pPos[i] = (Math.random() - 0.5) * 60;
        pGeo.setAttribute('position', new THREE.BufferAttribute(pPos, 3));
        const particles = new THREE.Points(pGeo, new THREE.PointsMaterial({ color: 0xBD00FF, size: 0.1 }));
        scene.add(particles);
        camera.position.z = 20;
        function animate() { requestAnimationFrame(animate); particles.rotation.y += 0.0003; renderer.render(scene, camera); }
        animate();

        // --- Charting ---
        const ctx = document.getElementById('neural-chart').getContext('2d');
        const neuralChart = new Chart(ctx, {
            type: 'line',
            data: { labels: Array(100).fill(''), datasets: [{ data: Array(100).fill(0), borderColor: '#00F0FF', borderWidth: 1.5, pointRadius: 0, fill: false }] },
            options: { 
                responsive: true, maintainAspectRatio: false, 
                scales: { y: { min: -100, max: 100, grid: { color: 'rgba(255,255,255,0.05)' } }, x: { display: false } }, 
                plugins: { legend: { display: false } }, animation: false 
            }
        });

        // --- WebSocket Handlers ---
        const socket = new WebSocket('ws://localhost:8765');
        const socketStatus = document.getElementById('socket-status');
        const logFeed = document.getElementById('log-feed');
        let lastIntent = "";

        function addLog(msg, type="info") {
            const div = document.createElement('div');
            div.className = "log-entry log-" + type;
            div.innerHTML = "[" + new Date().toLocaleTimeString() + "] " + msg;
            logFeed.prepend(div);
            if(logFeed.children.length > 25) logFeed.lastChild.remove();
        }

        socket.onopen = () => { socketStatus.style.background = '#0f0'; addLog("Neural Matrix Handshake Success", "info"); };
        socket.onclose = () => { socketStatus.style.background = '#f00'; addLog("Link Severed - Check Daemon", "warn"); };

        socket.onmessage = (event) => {
            const data = JSON.parse(event.data);
            
            // Update Stream
            neuralChart.data.datasets[0].data.push(data.raw_voltages[0]);
            neuralChart.data.datasets[0].data.shift();
            neuralChart.update();

            // Update FFT
            Object.keys(data.spectral).forEach(band => {
                const el = document.getElementById('fft-' + band);
                if(el) el.style.height = (data.spectral[band] * 1.2) + "px";
            });

            // Update Metrics (Clinician)
            document.getElementById('val-att').innerText = data.clinician.attention + "%";
            document.getElementById('val-med').innerText = data.clinician.meditation + "%";
            document.getElementById('val-fatigue').innerText = data.clinician.fatigue;
            document.getElementById('val-intent').innerText = data.clinician.intent;
            document.getElementById('val-conf').innerText = data.clinician.confidence + "%";
            
            if(data.clinician.intent !== lastIntent && data.clinician.intent !== "STABILIZING...") {
                addLog("Intent Decoded: " + data.clinician.intent, "info");
                lastIntent = data.clinician.intent;
            }

            // Update Metrics (Engineer)
            document.getElementById('val-snr').innerText = data.engineer.snr;
            document.getElementById('val-imp').innerText = data.engineer.impedance;
            document.getElementById('val-loss').innerText = data.engineer.packet_loss + "%";
            document.getElementById('val-quality').innerText = data.engineer.quality.toUpperCase();
        };

        window.addEventListener('resize', () => { camera.aspect = window.innerWidth / window.innerHeight; camera.updateProjectionMatrix(); renderer.setSize(window.innerWidth, window.innerHeight); });
    </script>
</body>
</html>
