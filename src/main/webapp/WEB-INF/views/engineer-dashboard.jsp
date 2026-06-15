<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Engineer Dashboard | SYNAPSE</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <!-- EXPLICIT INDEPENDENT LIBRARY IMPORTS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        #webgl-canvas-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: -1;
            pointer-events: none;
            background-color: #000000;
        }

        body {
            background-color: #000000;
            overflow-x: hidden;
        }

        .content-overlay {
            position: relative;
            z-index: 10;
            background: linear-gradient(180deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.85) 100%);
        }

        .glass-card {
            background: rgba(20, 20, 40, 0.6) !important;
            border: 1px solid rgba(0, 240, 255, 0.2) !important;
        }
    </style>
</head>
<body>

<!-- WEBGL CANVAS CONTAINER (FIXED BACKGROUND) -->
<div id="webgl-canvas-container"></div>

<!-- CONTENT OVERLAY (ABOVE CANVAS) -->
<div class="content-overlay">
    <nav class="navbar navbar-expand-lg border-bottom border-secondary mb-4" style="background: rgba(0,0,0,0.9);">
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
            <ol class="breadcrumb" style="background: rgba(255,255,255,0.02);">
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
</div>

<script>
    // ============================================================
    // BULLETPROOF WEBGL INITIALIZATION WITH COMPLETE ERROR GUARDS
    // ============================================================

    window.addEventListener('DOMContentLoaded', () => {
        try {
            console.log("[SYNAPSE] Dashboard initialization starting...");

            // STEP 1: CONTAINER VALIDATION
            const container = document.getElementById('webgl-canvas-container');
            if (!container) {
                console.error("[SYNAPSE] FATAL: Canvas container not found.");
                return;
            }
            console.log("[SYNAPSE] Canvas container acquired.");

            // STEP 2: WEBGL SUPPORT CHECK
            const canvas = document.createElement('canvas');
            if (!window.WebGLRenderingContext && !window.WebGL2RenderingContext) {
                console.warn("[SYNAPSE] WebGL not supported. Skipping 3D rendering.");
                container.style.display = 'none';
                return;
            }
            console.log("[SYNAPSE] WebGL support verified.");

            try {
                // STEP 3: THREE.JS SCENE INITIALIZATION
                const scene = new THREE.Scene();
                const camera = new THREE.PerspectiveCamera(
                    75,
                    window.innerWidth / window.innerHeight,
                    0.1,
                    2000
                );
                const renderer = new THREE.WebGLRenderer({
                    antialias: true,
                    alpha: true,
                    powerPreference: "high-performance",
                    failIfMajorPerformanceCaveat: false
                });

                renderer.setSize(window.innerWidth, window.innerHeight);
                renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
                renderer.setClearColor(0x000000, 1.0);
                renderer.shadowMap.enabled = false;
                renderer.autoClear = false;

                container.appendChild(renderer.domElement);
                console.log("[SYNAPSE] WebGL renderer initialized.");

                camera.position.set(0, 0, 40);
                camera.lookAt(0, 0, 0);

                // STEP 4: LIGHTING SETUP
                try {
                    const ambLight = new THREE.AmbientLight(0x110522, 1.5);
                    scene.add(ambLight);

                    const dirLight = new THREE.DirectionalLight(0x00F0FF, 2.0);
                    dirLight.position.set(20, 15, 10);
                    scene.add(dirLight);
                    console.log("[SYNAPSE] Lighting subsystem initialized.");
                } catch (lightError) {
                    console.error("[SYNAPSE] Lighting setup failed:", lightError);
                }

                // STEP 5: MATERIAL DEFINITIONS
                let coreMaterial, particleMaterial;
                try {
                    coreMaterial = new THREE.MeshStandardMaterial({
                        color: 0xBD00FF,
                        roughness: 0.22,
                        metalness: 0.3,
                        transparent: true,
                        opacity: 0.85
                    });

                    particleMaterial = new THREE.MeshStandardMaterial({
                        color: 0x00F0FF,
                        emissive: 0x00F0FF,
                        emissiveIntensity: 1.5,
                        transparent: true,
                        opacity: 0.8
                    });
                    console.log("[SYNAPSE] Materials created successfully.");
                } catch (matError) {
                    console.error("[SYNAPSE] Material creation failed:", matError);
                    throw matError;
                }

                // ============================================================
                // STEP 6: PROCEDURAL TELEMETRY MESH A (PARTICLE NETWORK)
                // ============================================================
                let particleGroup = null;
                try {
                    particleGroup = new THREE.Group();
                    const particleCount = 32;
                    const particles = [];

                    for (let i = 0; i < particleCount; i++) {
                        try {
                            const pGeometry = new THREE.SphereGeometry(0.2, 8, 8);
                            const pMaterial = particleMaterial.clone();
                            const particle = new THREE.Mesh(pGeometry, pMaterial);

                            const angle = (i / particleCount) * Math.PI * 2;
                            const radius = 10 + Math.random() * 5;
                            particle.position.set(
                                Math.cos(angle) * radius,
                                (Math.random() - 0.5) * 10,
                                Math.sin(angle) * radius
                            );

                            particle.velocity = new THREE.Vector3(
                                (Math.random() - 0.5) * 0.04,
                                (Math.random() - 0.5) * 0.03,
                                (Math.random() - 0.5) * 0.04
                            );

                            particleGroup.add(particle);
                            particles.push({
                                mesh: particle,
                                velocity: particle.velocity
                            });
                        } catch (pError) {
                            console.warn("[SYNAPSE] Particle " + i + " creation skipped:", pError);
                        }
                    }

                    scene.add(particleGroup);
                    console.log("[SYNAPSE] Particle network created (" + particles.length + " particles).");

                    // PARTICLE ANIMATION CONTROLLER
                    window.particleController = {
                        particles: particles,
                        update: function() {
                            this.particles.forEach((p) => {
                                p.mesh.position.add(p.velocity);

                                if (Math.abs(p.mesh.position.x) > 20) p.mesh.position.x *= -0.9;
                                if (Math.abs(p.mesh.position.y) > 15) p.mesh.position.y *= -0.9;
                                if (Math.abs(p.mesh.position.z) > 20) p.mesh.position.z *= -0.9;

                                p.velocity.multiplyScalar(0.96);

                                const attraction = new THREE.Vector3()
                                    .copy(p.mesh.position)
                                    .multiplyScalar(-0.0008);
                                p.velocity.add(attraction);

                                const pulseScale = 0.8 + Math.sin(Date.now() * 0.002 + p.mesh.uuid.charCodeAt(0)) * 0.25;
                                p.mesh.scale.set(pulseScale, pulseScale, pulseScale);
                            });
                        }
                    };

                } catch (particleError) {
                    console.error("[SYNAPSE] Particle network setup failed:", particleError);
                    particleGroup = null;
                }

                // ============================================================
                // STEP 7: PROCEDURAL TELEMETRY MESH B (DATA ANCHOR CORE)
                // ============================================================
                let coreMesh = null;
                try {
                    const coreGeometry = new THREE.OctahedronGeometry(3.5, 2);
                    coreMesh = new THREE.Mesh(coreGeometry, coreMaterial.clone());
                    coreMesh.rotation.x = 0.3;
                    coreMesh.rotation.y = 0.4;
                    scene.add(coreMesh);
                    console.log("[SYNAPSE] Data anchor core mesh initialized.");
                } catch (coreError) {
                    console.error("[SYNAPSE] Core mesh setup failed:", coreError);
                    coreMesh = null;
                }

                // ============================================================
                // STEP 8: ANIMATION & RENDER LOOP
                // ============================================================
                let animationFrameId = null;
                let lastErrorTime = 0;

                function animate(time) {
                    try {
                        animationFrameId = requestAnimationFrame(animate);

                        // Update particle animations
                        if (window.particleController) {
                            window.particleController.update();
                        }

                        // Rotate core mesh
                        if (coreMesh) {
                            coreMesh.rotation.x += 0.0002;
                            coreMesh.rotation.y += 0.0004;
                            const scale = 1.0 + Math.sin(time * 0.001) * 0.08;
                            coreMesh.scale.set(scale, scale, scale);
                        }

                        // Render
                        renderer.clear();
                        renderer.render(scene, camera);

                    } catch (frameError) {
                        const now = Date.now();
                        if (now - lastErrorTime > 5000) {
                            console.error("[SYNAPSE] Frame render error:", frameError);
                            lastErrorTime = now;
                        }
                    }
                }

                animate(0);
                console.log("[SYNAPSE] Animation loop started.");

                // WINDOW RESIZE HANDLER
                window.addEventListener('resize', () => {
                    try {
                        camera.aspect = window.innerWidth / window.innerHeight;
                        camera.updateProjectionMatrix();
                        renderer.setSize(window.innerWidth, window.innerHeight);
                    } catch (resizeError) {
                        console.error("[SYNAPSE] Resize handler error:", resizeError);
                    }
                });

                // TELEMETRY CONTROLLER INTERFACE
                window.telemetryMeshController = {
                    pulseTelemetry: (confidence) => {
                        if (window.particleController) {
                            window.particleController.particles.forEach((p) => {
                                p.velocity.multiplyScalar(1.0 + confidence * 0.2);
                            });
                        }
                    }
                };

                console.log("[SYNAPSE] Dashboard WebGL subsystem fully initialized.");

            } catch (glError) {
                console.error("[SYNAPSE] CRITICAL: WebGL subsystem initialization failed:", glError);
                container.innerHTML = '<div style="color: #999; padding: 40px; text-align: center; font-family: monospace;"><p>WebGL Rendering Subsystem: OFFLINE</p><p style="font-size: 12px; margin-top: 20px;">Telemetry visualization unavailable. Dashboard in fallback mode.</p></div>';
            }

        } catch (globalError) {
            console.error("[SYNAPSE] FATAL: Dashboard initialization failed:", globalError);
        }
    });

    // ============================================================
    // CHART.JS TELEMETRY VISUALIZATION
    // ============================================================

    window.addEventListener('DOMContentLoaded', () => {
        try {
            const ctx = document.getElementById('liveChart');
            if (!ctx) return;

            const chartContext = ctx.getContext('2d');
            let chart = new Chart(chartContext, {
                type: 'line',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'Neural Signal (uV)',
                        data: [],
                        borderColor: '#00F0FF',
                        backgroundColor: 'rgba(0, 240, 255, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 2
                    }]
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
                        legend: { display: false }
                    }
                }
            });

            console.log("[SYNAPSE] Chart.js analytics initialized.");

            // ============================================================
            // WEBSOCKET TELEMETRY STREAM
            // ============================================================

            const socket = new WebSocket('ws://' + window.location.host + '${pageContext.request.contextPath}/neuralstream');
            const logConsole = document.getElementById('log-console');

            socket.onopen = () => {
                console.log("[SYNAPSE] WebSocket telemetry stream connected.");
                const entry = document.createElement('div');
                entry.className = 'text-success';
                entry.innerText = '[' + new Date().toLocaleTimeString() + '] SYSTEM -> Telemetry Stream CONNECTED';
                if (logConsole) logConsole.prepend(entry);
            };

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
                    chart.data.datasets[0].data.push(data.signal_matrix.ch1 || 0);
                    chart.update('none');

                    // Update KPI Cards
                    document.getElementById('avg-snr').innerText = (data.decoder_analytics.confidence_score * 10).toFixed(1) + ' dB';
                    document.getElementById('avg-itr').innerText = (data.decoder_analytics.inference_latency_ms * 2).toFixed(1) + ' bpm';

                    // Pulse 3D telemetry mesh
                    if (window.telemetryMeshController) {
                        window.telemetryMeshController.pulseTelemetry(data.decoder_analytics.confidence_score);
                    }

                    // Log telemetry events
                    if (data.telemetry_header.frame_id % 25 === 0) {
                        const entry = document.createElement('div');
                        entry.className = data.telemetry_header.frame_id === -1 ? 'text-warning' : 'text-info';
                        const intent = data.decoder_analytics.predicted_intent;
                        const conf = (data.decoder_analytics.confidence_score * 100).toFixed(2);
                        const lat = data.decoder_analytics.inference_latency_ms;

                        entry.innerText = data.telemetry_header.frame_id === -1 ?
                            `[${time}] SYSTEM -> Core Offline. Mode: FALLBACK MOCK` :
                            `[${time}] CORE -> Intent: [${intent}] | Confidence: ${conf}% | Latency: ${lat}ms`;

                        if (logConsole) {
                            logConsole.prepend(entry);
                            if (logConsole.childNodes.length > 100) logConsole.removeChild(logConsole.lastChild);
                        }
                    }

                } catch (parseError) {
                    console.warn("[SYNAPSE] Telemetry parse error:", parseError);
                }
            };

            socket.onerror = (error) => {
                console.error("[SYNAPSE] WebSocket error:", error);
                const entry = document.createElement('div');
                entry.className = 'text-danger';
                entry.innerText = '[' + new Date().toLocaleTimeString() + '] SYSTEM -> Telemetry Stream ERROR';
                if (logConsole) logConsole.prepend(entry);
            };

            socket.onclose = () => {
                console.log("[SYNAPSE] WebSocket telemetry stream closed.");
            };

            // DSP TOGGLE HANDLER
            const dspToggle = document.getElementById('dspToggle');
            if (dspToggle) {
                dspToggle.addEventListener('change', (e) => {
                    try {
                        socket.send(JSON.stringify({
                            command: "TOGGLE_DSP",
                            state: e.target.checked
                        }));
                        const entry = document.createElement('div');
                        entry.className = e.target.checked ? 'text-success' : 'text-danger';
                        entry.innerText = "[" + new Date().toLocaleTimeString() + "] CONTROL -> DSP: " + (e.target.checked ? 'ENABLED' : 'DISABLED');
                        if (logConsole) logConsole.prepend(entry);
                    } catch (cmdError) {
                        console.error("[SYNAPSE] DSP command failed:", cmdError);
                    }
                });
            }

        } catch (chartError) {
            console.error("[SYNAPSE] Chart initialization failed:", chartError);
        }
    });
</script>

</body>
</html>
