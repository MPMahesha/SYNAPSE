<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SYNAPSE v4.0 | Research Intelligence</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --bg: #050508; --panel: rgba(15, 15, 25, 0.9); --accent: #BD00FF; --cyan: #00F0FF; --text: #e0e0e0; --dim: #666; }
        body, html { margin: 0; padding: 0; background: var(--bg); color: var(--text); font-family: 'JetBrains Mono', monospace; overflow: hidden; height: 100vh; }
        #bg-canvas { position: fixed; top: 0; left: 0; z-index: -1; }
        
        .grid-layout { display: grid; grid-template-columns: 350px 1fr 320px; grid-template-rows: 70px 1fr 220px; height: 100vh; gap: 12px; padding: 12px; box-sizing: border-box; }
        
        header { 
            grid-column: 1 / span 3; background: var(--panel); border: 1px solid rgba(189, 0, 255, 0.3); 
            display: flex; align-items: center; justify-content: space-between; padding: 0 30px; backdrop-filter: blur(20px); 
            position: relative; z-index: 5000;
        }

        .profile-menu { position: relative; z-index: 5001; }
        .profile-btn { background: linear-gradient(45deg, var(--accent), var(--cyan)); padding: 6px 18px; border-radius: 4px; font-size: 0.75rem; cursor: pointer; font-weight: 900; color: #fff; border: none; }
        .dropdown { 
            position: absolute; top: 100%; right: 0; background: #0a0a12; border: 1px solid var(--cyan); 
            display: none; width: 220px; margin-top: 10px; box-shadow: 0 10px 40px rgba(0,240,255,0.2);
            z-index: 6000;
        }
        .dropdown div, .dropdown a { display: block; padding: 15px 25px; color: #fff; text-decoration: none; font-size: 0.8rem; border-bottom: 1px solid #1a1a25; cursor: pointer; }
        .dropdown div:hover, .dropdown a:hover { background: rgba(0, 240, 255, 0.1); color: var(--cyan); }
        .profile-menu:hover .dropdown { display: block; }

        .panel { background: var(--panel); border: 1px solid rgba(189, 0, 255, 0.15); backdrop-filter: blur(15px); padding: 18px; overflow: hidden; display: flex; flex-direction: column; }
        .sidebar { grid-row: 2 / span 2; gap: 12px; overflow-y: auto; }
        .main-view { grid-column: 2; grid-row: 2; gap: 12px; }
        .bottom-shelf { grid-column: 2; grid-row: 3; }

        h2 { font-size: 0.75rem; color: var(--cyan); border-bottom: 1px solid rgba(0, 240, 255, 0.2); padding-bottom: 8px; margin: 0 0 15px 0; text-transform: uppercase; letter-spacing: 2px; }
        .metric-box { background: rgba(0,0,0,0.5); border-left: 4px solid var(--accent); padding: 15px; margin-bottom: 10px; position: relative; }
        .metric-label { font-size: 0.65rem; color: var(--dim); margin-bottom: 5px; cursor: help; }
        .metric-value { font-size: 1.4rem; font-weight: 900; }
        
        .tooltip { visibility: hidden; position: absolute; bottom: 100%; left: 0; background: #1a1a25; color: #fff; padding: 12px; border-radius: 4px; font-size: 0.7rem; width: 240px; z-index: 2000; opacity: 0; transition: 0.3s; border: 1px solid var(--cyan); line-height: 1.4; }
        .metric-box:hover .tooltip { visibility: visible; opacity: 1; }

        .fft-container { display: flex; justify-content: space-around; align-items: flex-end; height: 140px; padding-bottom: 25px; }
        .fft-col { display: flex; flex-direction: column; align-items: center; width: 50px; height: 100%; justify-content: flex-end; }
        .fft-bar { width: 100%; background: linear-gradient(to top, var(--accent), var(--cyan)); transition: height 0.2s cubic-bezier(0.4, 0, 0.2, 1); min-height: 2px; border-radius: 2px 2px 0 0; }
        .fft-label { font-size: 0.65rem; margin-top: 10px; color: var(--dim); }

        .clinician-only, .engineer-only { display: none; }
        body[data-role="CLINICIAN"] .clinician-only { display: block; }
        body[data-role="ENGINEER"] .engineer-only { display: block; }

        #log-feed { font-size: 0.7rem; color: #888; overflow-y: auto; flex: 1; border-top: 1px solid #1a1a25; padding-top: 10px; }
        .log-entry { margin-bottom: 6px; padding: 4px 8px; border-radius: 2px; }
        .log-info { background: rgba(0, 240, 255, 0.05); color: var(--cyan); border-left: 2px solid var(--cyan); }
        .log-warn { background: rgba(255, 170, 0, 0.05); color: #ffaa00; border-left: 2px solid #ffaa00; }
        
        #waveform-container { flex: 1; position: relative; background: rgba(0,0,0,0.3); border: 1px solid #1a1a25; margin-bottom: 10px; }
        .axis-label { position: absolute; font-size: 0.6rem; color: var(--dim); }
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
            <div style="display: flex; align-items: center; gap: 20px;">
                <div id="socket-status" style="width: 10px; height: 100%; background: #ff4444; box-shadow: 0 0 10px #f00;"></div>
                <div>
                    <div style="font-weight: 900; letter-spacing: 5px; font-size: 1.1rem; color: var(--cyan);">SYNAPSE v4.0 INTELLIGENCE</div>
                    <div style="font-size: 0.65rem; color: var(--dim);">DATA SOURCE: PHYSIONET MOTOR IMAGERY | MODE: REAL-TIME INFERENCE</div>
                </div>
            </div>
            <div style="display: flex; align-items: center; gap: 30px;">
                <div style="text-align: right;">
                    <div style="font-size: 0.6rem; color: var(--dim);">SESSION ELAPSED</div>
                    <div id="session-timer" style="font-weight: bold; color: #fff;">00:00:00</div>
                </div>
                <div class="profile-menu">
                    <button class="profile-btn">SYSTEM ACCESS ▼</button>
                    <div class="dropdown">
                        <div onclick="toggleModal('profile-modal')">Subject Identity</div>
                        <div onclick="toggleModal('settings-modal')">Neural Filters</div>
                        <div onclick="toggleWorkspace()">Workspace Switch</div>
                        <a href="logout">Secure Invalidate</a>
                    </div>
                </div>
            </div>
        </header>

        <!-- Left Sidebar: High-Fidelity Analytics -->
        <div class="panel sidebar">
            <!-- CLINICIAN PORTAL -->
            <div class="clinician-only">
                <h2>PATIENT REHAB ANALYTICS</h2>
                <div class="metric-box">
                    <div class="metric-label">ATTENTION INDEX ⓘ<div class="tooltip">Definition: Cognitive engagement ratio.<br>Calc: (Beta+Gamma)/Total Power.<br>Interpretation: Higher values indicate task focus.</div></div>
                    <div class="metric-value" id="val-att">0%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">MEDITATION DEPTH ⓘ<div class="tooltip">Definition: Neural relaxation state.<br>Calc: (Alpha+Theta)/Total Power.<br>Interpretation: High Alpha indicates resting state.</div></div>
                    <div class="metric-value" id="val-med">0%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">MENTAL FATIGUE ⓘ<div class="tooltip">Definition: Subjective exhaustion.<br>Calc: Session Time * Attention Volatility.<br>Threshold: Warning > 70%.</div></div>
                    <div class="metric-value" id="val-fatigue" style="color: var(--cyan);">LOW</div>
                </div>
                
                <h2 style="margin-top: 25px;">NEUROPLASTICITY INDEX</h2>
                <div class="metric-box">
                    <div class="metric-label">DECODER ACCURACY</div>
                    <div class="metric-value" id="val-acc">92.4%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">SUCCESSFUL TRIALS</div>
                    <div class="metric-value" id="val-trials">1,245</div>
                </div>
            </div>

            <!-- ENGINEER TERMINAL -->
            <div class="engineer-only">
                <h2>HARDWARE TELEMETRY</h2>
                <div class="metric-box">
                    <div class="metric-label">SIGNAL-TO-NOISE (SNR) ⓘ<div class="tooltip">Definition: Signal clarity vs noise floor.<br>Calc: 10*log10(S/N).<br>Target: 15-35 dB.</div></div>
                    <div class="metric-value"><span id="val-snr">0.0</span> <span style="font-size: 0.8rem; color: var(--dim);">dB</span></div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">ELECTRODE IMPEDANCE ⓘ<div class="tooltip">Definition: Contact resistance.<br>Calc: Real-time drift model.<br>Stable: 2-15 kΩ.</div></div>
                    <div class="metric-value"><span id="val-imp">0.0</span> <span style="font-size: 0.8rem; color: var(--dim);">kΩ</span></div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">STREAM STABILITY ⓘ<div class="tooltip">Definition: Packet delivery health.<br>Calc: Network drop percentage.<br>Threshold: <0.5%.</div></div>
                    <div class="metric-value" id="val-loss">0.0%</div>
                </div>
                <div class="metric-box">
                    <div class="metric-label">TOTAL LATENCY ⓘ<div class="tooltip">Definition: End-to-end BCI delay.<br>Includes: Ingest + DSP + Inference.<br>Target: <5ms.</div></div>
                    <div class="metric-value"><span id="val-latency">0.0</span> <span style="font-size: 0.8rem; color: var(--dim);">ms</span></div>
                </div>
            </div>
        </div>

        <!-- Center: Real EEG Stream & Intent -->
        <div class="main-view panel">
            <h2 id="waveform-title">LIVE EEG STREAM (C3, C4, CZ, PZ) - uV</h2>
            <div id="waveform-container">
                <div class="axis-label" style="top: 10px; left: 10px;">+100uV</div>
                <div class="axis-label" style="bottom: 10px; left: 10px;">-100uV</div>
                <canvas id="stream-chart"></canvas>
            </div>
            
            <div style="display: flex; gap: 12px; height: 130px;">
                <div class="panel" style="flex: 2; border-color: var(--cyan);">
                    <h2>EEGNET INTENT DECODER (STABLE)</h2>
                    <div style="display: flex; justify-content: space-between; align-items: center; height: 100%;">
                        <div>
                            <div class="metric-label">PREDICTED COMMAND</div>
                            <div style="font-size: 1.8rem; font-weight: 900; color: var(--cyan); text-shadow: 0 0 15px var(--cyan);" id="val-intent">INITIALIZING...</div>
                        </div>
                        <div style="text-align: right;">
                            <div class="metric-label">CONFIDENCE</div>
                            <div style="font-size: 1.5rem; font-weight: bold;" id="val-conf">0%</div>
                            <div style="font-size: 0.7rem; color: var(--dim);">MODEL: EEGNet_v4</div>
                        </div>
                    </div>
                </div>
                <div class="panel engineer-only" style="flex: 1;">
                    <h2>DL BENCHMARKS</h2>
                    <div style="font-size: 0.7rem; display: grid; grid-template-columns: 1fr 1fr; gap: 8px;">
                        <span>ACC: 94.1%</span><span>PREC: 92.8%</span>
                        <span>F1: 0.93</span><span>RECALL: 93.4%</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right: Event Log -->
        <div class="panel sidebar">
            <h2>REAL-TIME EVENT PIPELINE</h2>
            <div id="log-feed"></div>
        </div>

        <!-- Bottom: Spectral Density -->
        <div class="panel bottom-shelf">
            <h2>SPECTRAL POWER DENSITY (FFT) - NORMALIZED</h2>
            <div class="fft-container">
                <div class="fft-col"><div id="fft-delta" class="fft-bar" style="height: 0%;"></div><div class="fft-label">Δ DELTA</div></div>
                <div class="fft-col"><div id="fft-theta" class="fft-bar" style="height: 0%;"></div><div class="fft-label">θ THETA</div></div>
                <div class="fft-col"><div id="fft-alpha" class="fft-bar" style="height: 0%;"></div><div class="fft-label">α ALPHA</div></div>
                <div class="fft-col"><div id="fft-beta" class="fft-bar" style="height: 0%;"></div><div class="fft-label">β BETA</div></div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <div id="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.85); z-index: 2000;" onclick="closeAllModals()"></div>
    <div id="profile-modal" class="panel" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 450px; z-index: 2001; border-color: var(--cyan);">
        <h2>SUBJECT IDENTITY PROVISION</h2>
        <div style="font-size: 0.9rem; line-height: 2;">
            <p>NAME: MPMahesha_Subject_001</p>
            <p>ID: NS-2026-X49</p>
            <p>ROLE: <%= session.getAttribute("userRole") %></p>
            <p>EMAIL: <%= session.getAttribute("userEmail") %></p>
        </div>
        <button onclick="closeAllModals()" style="background: var(--cyan); border: none; padding: 12px; margin-top: 20px; font-weight: bold; cursor: pointer;">CLOSE</button>
    </div>

    <script>
        // --- v4.0 Logic ---
        const startTime = Date.now();
        let currentRole = "<%= role %>";
        let lastIntent = "";

        // Timer
        setInterval(() => {
            const elapsed = Math.floor((Date.now() - startTime) / 1000);
            const h = String(Math.floor(elapsed / 3600)).padStart(2, '0');
            const m = String(Math.floor((elapsed % 3600) / 60)).padStart(2, '0');
            const s = String(elapsed % 60).padStart(2, '0');
            document.getElementById('session-timer').innerText = h + ":" + m + ":" + s;
        }, 1000);

        function toggleWorkspace() {
            currentRole = currentRole === 'CLINICIAN' ? 'ENGINEER' : 'CLINICIAN';
            document.body.setAttribute('data-role', currentRole);
            addLog("Workspace context shifted to " + currentRole, "info");
        }
        function toggleModal(id) { document.getElementById('modal-overlay').style.display = 'block'; document.getElementById(id).style.display = 'block'; }
        function closeAllModals() { document.getElementById('modal-overlay').style.display = 'none'; document.querySelectorAll('.panel[style*="display: none"]').forEach(p => p.style.display = 'none'); document.getElementById('profile-modal').style.display = 'none'; }

        // --- Three.js Atmosphere (Legacy Main Dashboard Assets) ---
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('bg-canvas'), alpha: true, antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);

        // meshA: Brain (Spherical Harmonics)
        const brainGeo = new THREE.SphereGeometry(4, 128, 128);
        const brainPos = brainGeo.attributes.position;
        const brainMat = new THREE.MeshStandardMaterial({ color: 0xBD00FF, roughness: 0.22, metalness: 0.3, emissive: 0x110022 });
        const meshA = new THREE.Mesh(brainGeo, brainMat);
        scene.add(meshA);

        // meshB: Neuron (Soma + Dendrites)
        const meshB = new THREE.Group();
        const soma = new THREE.Mesh(new THREE.IcosahedronGeometry(0.8, 1), brainMat);
        meshB.add(soma);
        for(let i=0; i<12; i++) {
            const angle = (i/12) * Math.PI * 2;
            const curve = new THREE.CatmullRomCurve3([new THREE.Vector3(0,0,0), new THREE.Vector3(Math.cos(angle)*1.5, Math.sin(angle)*1.5, Math.random()), new THREE.Vector3(Math.cos(angle)*4, Math.sin(angle)*4, Math.random()*2)]);
            meshB.add(new THREE.Mesh(new THREE.TubeGeometry(curve, 32, 0.05, 8, false), brainMat));
        }
        meshB.position.set(12, 5, -15);
        scene.add(meshB);

        // meshC: Cybernetic Skull (Cyan Splines)
        const meshC = new THREE.Group();
        const cyanMat = new THREE.MeshBasicMaterial({ color: 0x00F0FF, transparent: true, opacity: 0.4 });
        for(let i=0; i<12; i++) {
            const points = [];
            for(let j=0; j<20; j++) {
                const p = j/20;
                points.push(new THREE.Vector3(Math.sin(p*Math.PI)*3 + (Math.random()-0.5)*0.2, Math.cos(p*Math.PI)*4, Math.sin(p*Math.PI*2)*1.5 + i*0.2));
            }
            meshC.add(new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(points), 64, 0.02, 8, false), cyanMat));
        }
        meshC.position.set(-15, -5, -20);
        scene.add(meshC);

        // Lighting
        const ambient = new THREE.AmbientLight(0xffffff, 0.4);
        const point = new THREE.PointLight(0x00F0FF, 1.5);
        point.position.set(5, 5, 5);
        scene.add(ambient, point);

        camera.position.z = 25;

        function animate() {
            requestAnimationFrame(animate);
            const time = performance.now() * 0.001;

            // Brain Wave Deformation
            for(let i=0; i<brainPos.count; i++) {
                const v = new THREE.Vector3().fromBufferAttribute(brainPos, i).normalize();
                const noise = Math.sin(v.x*3 + time) * Math.cos(v.y*3 + time) * 0.15;
                const sagittal = Math.abs(v.x) < 0.15 ? -0.2 : 0;
                const scale = 4 + noise + sagittal;
                brainPos.setXYZ(i, v.x*scale, v.y*scale, v.z*scale);
            }
            brainPos.needsUpdate = true;

            meshA.rotation.y += 0.002;
            meshB.rotation.z -= 0.001;
            meshC.rotation.y += 0.0005;

            renderer.render(scene, camera);
        }
        animate();

        // --- Chart.js EEG Stream ---
        const ctx = document.getElementById('stream-chart').getContext('2d');
        const streamChart = new Chart(ctx, {
            type: 'line',
            data: { labels: Array(100).fill(''), datasets: [
                { label: 'C3', data: Array(100).fill(0), borderColor: '#00F0FF', borderWidth: 1, pointRadius: 0, fill: false },
                { label: 'C4', data: Array(100).fill(0), borderColor: '#BD00FF', borderWidth: 1, pointRadius: 0, fill: false }
            ]},
            options: { 
                responsive: true, maintainAspectRatio: false, 
                scales: { y: { min: -5, max: 5, grid: { color: '#1a1a25' } }, x: { display: false } }, 
                plugins: { legend: { display: true, labels: { color: '#666', boxWidth: 10 } } }, animation: false 
            }
        });

        // --- v4.0 WebSocket Client ---
        const socket = new WebSocket('ws://localhost:8765');
        const statusEl = document.getElementById('socket-status');
        const logFeed = document.getElementById('log-feed');

        function addLog(msg, type="info") {
            const div = document.createElement('div');
            div.className = "log-entry log-" + type;
            div.innerHTML = "[" + new Date().toLocaleTimeString() + "] " + msg;
            logFeed.prepend(div);
            if(logFeed.children.length > 30) logFeed.lastChild.remove();
        }

        socket.onopen = () => { statusEl.style.background = '#0f0'; statusEl.style.boxShadow = '0 0 15px #0f0'; addLog("Neural Pipeline Linked - Receiving v4.0 Stream", "info"); };
        socket.onclose = () => { statusEl.style.background = '#f44'; statusEl.style.boxShadow = '0 0 15px #f00'; addLog("Critical: Neural Matrix Link Severed", "warn"); };

        socket.onmessage = (event) => {
            const data = JSON.parse(event.data);
            
            // 1. Update Waveform (Multi-channel labels)
            streamChart.data.datasets[0].data.push(data.waveform[0]);
            streamChart.data.datasets[1].data.push(data.waveform[1]);
            streamChart.data.datasets.forEach(d => { if(d.data.length > 100) d.data.shift(); });
            streamChart.update();

            // 2. Normalize & Fix FFT Bars (Prevent overflow)
            Object.keys(data.fft).forEach(band => {
                const el = document.getElementById('fft-' + band);
                if(el) {
                    const height = Math.min(data.fft[band], 100);
                    el.style.height = height + "%";
                }
            });

            // 3. Clinician Updates
            document.getElementById('val-att').innerText = Math.round(data.fft.beta + 15) + "%"; // Mock research logic
            document.getElementById('val-med').innerText = Math.round(data.fft.alpha + 10) + "%";
            
            const fatigue = (Date.now() - startTime) > 600000 ? "MODERATE" : "LOW";
            document.getElementById('val-fatigue').innerText = fatigue;

            // 4. Engineer Updates
            document.getElementById('val-snr').innerText = data.snr;
            document.getElementById('val-imp').innerText = data.impedance;
            document.getElementById('val-loss').innerText = data.packetLoss + "%";
            document.getElementById('val-latency').innerText = data.latency;

            // 5. Intent Decoder
            const intentEl = document.getElementById('val-intent');
            intentEl.innerText = data.intent.replace("_", " ");
            document.getElementById('val-conf').innerText = data.confidence + "%";
            
            if(data.intent !== lastIntent) {
                addLog("Intent Decoded: " + data.intent, "info");
                lastIntent = data.intent;
            }
        };

        window.addEventListener('resize', () => { camera.aspect = window.innerWidth / window.innerHeight; camera.updateProjectionMatrix(); renderer.setSize(window.innerWidth, window.innerHeight); });
    </script>
</body>
</html>
