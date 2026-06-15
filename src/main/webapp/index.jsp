<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SYNAPSE | Neural Interface Portal</title>
    
    <!-- Core Assets -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root { --accent: #BD00FF; --cyan: #00F0FF; --text: #FFFFFF; --bg: #000000; }
        
        body, html { 
            margin: 0; padding: 0; width: 100%; height: 100%; 
            background: var(--bg); color: var(--text); 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            overflow-x: hidden; cursor: none; /* Hide OS Cursor */
        }

        #webgl-canvas { position: fixed; top: 0; left: 0; z-index: -2; pointer-events: none; }
        
        /* Custom Theme Cursor */
        #custom-cursor {
            position: fixed; width: 20px; height: 20px; border: 2px solid var(--cyan);
            border-radius: 50%; pointer-events: none; transform: translate(-50%, -50%);
            z-index: 9999; transition: transform 0.1s ease-out, background 0.2s;
            box-shadow: 0 0 15px var(--cyan);
        }
        #custom-cursor.hover { transform: translate(-50%, -50%) scale(2); background: rgba(0, 240, 255, 0.1); }

        /* Inverse Parallax Starfield */
        #parallax-bg {
            position: fixed; top: -10%; left: -10%; width: 120%; height: 120%;
            background-image: radial-gradient(circle at center, #1a1a25 0%, transparent 80%);
            opacity: 0.3; z-index: -3; pointer-events: none;
        }

        /* Branding Navbar */
        nav {
            position: fixed; top: 0; width: 100%; height: 80px;
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 50px; box-sizing: border-box; z-index: 1000;
            background: linear-gradient(to bottom, rgba(0,0,0,0.8), transparent);
        }
        .logo { font-size: 1.8rem; font-weight: 900; letter-spacing: 8px; color: var(--cyan); }
        .nav-links a { color: #fff; text-decoration: none; margin-left: 30px; font-size: 0.8rem; letter-spacing: 2px; text-transform: uppercase; font-weight: bold; }

        /* Layout Sections */
        section { 
            min-height: 100vh; width: 100%; display: flex; flex-direction: column; 
            justify-content: center; align-items: center; padding: 100px 10%; box-sizing: border-box;
            position: relative;
        }
        
        .glass-box {
            background: rgba(10, 10, 15, 0.85); backdrop-filter: blur(20px);
            border: 1px solid rgba(189, 0, 255, 0.2); padding: 50px; border-radius: 12px;
            max-width: 800px; box-shadow: 0 0 50px rgba(0,0,0,0.5);
        }

        h1 { font-size: 4.5rem; letter-spacing: 1.2rem; text-transform: uppercase; margin: 0; color: var(--cyan); text-shadow: 0 0 30px rgba(0, 240, 255, 0.4); }
        h2 { font-size: 1.2rem; color: var(--accent); letter-spacing: 0.5rem; text-transform: uppercase; margin-bottom: 20px; }
        p { line-height: 1.8; color: #ccc; font-size: 1.1rem; }

        /* Journey Tree Timeline */
        .timeline { width: 100%; max-width: 900px; position: relative; margin-top: 50px; }
        .node { 
            position: relative; padding: 30px; border-left: 2px solid var(--cyan);
            margin-left: 50px; margin-bottom: 40px; background: rgba(0, 240, 255, 0.03);
        }
        .node::before {
            content: ''; position: absolute; left: -11px; top: 35px;
            width: 20px; height: 20px; border-radius: 50%; background: var(--cyan);
            box-shadow: 0 0 15px var(--cyan);
        }
        .node-year { font-weight: 900; color: var(--cyan); font-size: 1.5rem; display: block; margin-bottom: 10px; }

        /* Application Carousel */
        .carousel-container { display: flex; gap: 30px; overflow-x: auto; width: 100%; padding: 20px 0; scroll-snap-type: x mandatory; }
        .app-card {
            flex: 0 0 300px; padding: 40px; background: rgba(15, 15, 25, 0.9);
            border: 1px solid rgba(189, 0, 255, 0.3); border-radius: 10px;
            scroll-snap-align: center; transition: transform 0.3s;
        }
        .app-card:hover { transform: translateY(-10px); border-color: var(--cyan); }
        .app-card h3 { color: #E0FFFF; font-size: 1.2rem; margin-bottom: 15px; }

        /* Impact Grid */
        .impact-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; width: 100%; margin-top: 50px; }
        .impact-block { 
            padding: 40px; border: 2px solid var(--accent); position: relative;
            background: linear-gradient(135deg, rgba(189, 0, 255, 0.05), transparent);
        }
        .impact-block:nth-child(even) { border-color: var(--cyan); background: linear-gradient(135deg, rgba(0, 240, 255, 0.05), transparent); }
        .impact-block h4 { color: #FFFFFF; font-size: 1.3rem; margin-bottom: 20px; }

        /* Buttons */
        .tactical-btn {
            background: transparent; border: 2px solid var(--cyan); color: var(--cyan);
            padding: 15px 40px; font-weight: 900; letter-spacing: 4px; text-transform: uppercase;
            cursor: pointer; position: relative; overflow: hidden; transition: 0.3s; margin: 20px;
        }
        .tactical-btn:hover { background: var(--cyan); color: #000; box-shadow: 0 0 30px var(--cyan); }
        .tactical-btn.purple { border-color: var(--accent); color: var(--accent); }
        .tactical-btn.purple:hover { background: var(--accent); color: #fff; box-shadow: 0 0 30px var(--accent); }

        /* Visibility Fixes */
        .high-vis { color: #E0FFFF !important; font-weight: bold; }
    </style>
</head>
<body>
    <div id="custom-cursor"></div>
    <div id="parallax-bg"></div>
    <canvas id="webgl-canvas"></canvas>

    <nav>
        <div class="logo">SYNAPSE</div>
        <div class="nav-links">
            <a href="#section-1">Overview</a>
            <a href="#section-2">History</a>
            <a href="#section-3">Applications</a>
            <a href="auth/login">Portal Access</a>
            <a href="auth/register">Enrollment</a>
        </div>
    </nav>

    <div class="scroll-container">
        <!-- SECTION 1: WHAT IS BCI? -->
        <section id="section-1">
            <div class="glass-box">
                <h2>Elevating Human Cognition</h2>
                <h1>What is a Brain-Computer Interface?</h1>
                <p style="margin-top: 30px;">
                    A Brain-Computer Interface (BCI) is a direct, bi-directional communication pathway that bridges the biological mind with external digital systems. By bypassing traditional neuromuscular channels (like speaking or moving your hands), BCI systems record neural activity, decode it using advanced machine learning algorithms, and translate those thoughts into real-time digital commands. 
                </p>
                <p>
                    At NeuroSync, we utilize <span class="high-vis">High-Fidelity Signal Processing</span> through <span class="high-vis">Real-time Neural Decoding</span> arrays. These sit safely on the brain's surface beneath the skull, offering an optimal balance of ultra-high signal fidelity and <span class="high-vis">Biometric Encryption</span> without damaging delicate brain tissue.
                </p>
            </div>
        </section>

        <!-- SECTION 2: THE HISTORY OF BCI -->
        <section id="section-2">
            <h2>From Sci-Fi to Reality</h2>
            <h1 style="font-size: 2.5rem;">The Evolution of Neural Interfacing</h1>
            <p style="text-align: center; max-width: 600px; margin-bottom: 50px;">
                The concept of plugging the human brain into a computer isn't new, but the engineering required decades to perfect.
            </p>
            
            <div class="timeline">
                <div class="node">
                    <span class="node-year">1924</span>
                    <h3>The First Discovery</h3>
                    <p>Hans Berger records the very first human brainwaves using an EEG (Electroencephalogram), proving that the human brain continuously emits measurable electrical signals.</p>
                </div>
                <div class="node">
                    <span class="node-year">1973</span>
                    <h3>Coining the Term</h3>
                    <p>Professor Jacques Vidal at UCLA officially coins the term 'Brain-Computer Interface' and publishes the first blueprint for using EEG signals to control external graphics.</p>
                </div>
                <div class="node">
                    <span class="node-year">1998</span>
                    <h3>The First Cybernetic Human</h3>
                    <p>Dr. Philip Kennedy implants the first chronic cortical BCI into a human patient suffering from locked-in syndrome, allowing them to control a computer cursor by imagining movement.</p>
                </div>
                <div class="node">
                    <span class="node-year">2004</span>
                    <h3>The Pioneer: Matthew Nagle</h3>
                    <p>Nagle became the first human to be implanted with a cybernetic microelectrode array (the Utah Array). He successfully controlled a cursor to play Pong and opened a prosthetic robotic hand using nothing but his thoughts.</p>
                </div>
            </div>
        </section>

        <!-- SECTION 3: CORE APPLICATIONS -->
        <section id="section-3">
            <h2>Unlocking New Dimensions</h2>
            <h1 style="font-size: 2.5rem;">How BCI Redefines Human Potential</h1>
            
            <div class="carousel-container">
                <div class="app-card">
                    <h3>Neuroprosthetics & Mobility Restoration</h3>
                    <p>Reconnecting the mind to robotic limbs and exoskeletons. Patients with spinal cord injuries or ALS can regain autonomy directly.</p>
                </div>
                <div class="app-card">
                    <h3>Augmentative Communication</h3>
                    <p>Giving a voice back to the locked-in. Converts imagined speech into text and audio at near-natural speeds.</p>
                </div>
                <div class="app-card">
                    <h3>Cognitive Enhancement & Therapeutics</h3>
                    <p>Utilizing closed-loop neural feedback to treat neurological disorders by gently steering chaotic brain patterns back into harmony.</p>
                </div>
                <div class="app-card">
                    <h3>Next-Gen Human-Computer Interaction</h3>
                    <p>Frictionless interaction with spatial computing and virtual environments, moving beyond keyboards and touchscreens.</p>
                </div>
            </div>
        </section>

        <!-- SECTION 4: MEDICAL TRANSFORMATION -->
        <section id="section-4">
            <h2>A Paradigm Shift</h2>
            <h1 style="font-size: 2.5rem;">Beyond Treatment. Total Restoration.</h1>
            <p style="margin-bottom: 40px; opacity: 0.8;">Traditional medicine relied on biochemistry; BCI has shifted medical technology into bioelectronic medicine.</p>
            
            <div class="impact-grid">
                <div class="impact-block">
                    <h4>Bypassing the Injury</h4>
                    <p>Instead of healing scarred spinal cords, BCI creates a digital detour past the injury straight to assistive devices.</p>
                </div>
                <div class="impact-block">
                    <h4>Neuroplasticity Acceleration</h4>
                    <p>Trains the brain to form new pathways by marrying intent with action, accelerating rehabilitation rates.</p>
                </div>
                <div class="impact-block" style="grid-column: span 2;">
                    <h4>Real-Time Neurological Data</h4>
                    <p>Clinicians get a living map of cognitive health, allowing for predictive diagnostics before symptoms manifest.</p>
                </div>
            </div>
        </section>

        <!-- SECTION 5: CTA -->
        <section id="section-5">
            <div style="text-align: center;">
                <h1>The Future is Wired. Are You Ready?</h1>
                <p style="font-size: 1.3rem; margin: 40px 0;">Join the next evolution of human capability. Secure your portal access or enroll in upcoming clinical phases.</p>
                <div style="display: flex; justify-content: center; gap: 20px;">
                    <button class="tactical-btn" onclick="location.href='auth/login'">[ Portal Access ]</button>
                    <button class="tactical-btn purple" onclick="location.href='auth/register'">[ Enrollment ]</button>
                </div>
            </div>
        </section>
    </div>

    <script>
        // --- Custom Cursor Logic ---
        const cursor = document.getElementById('custom-cursor');
        document.addEventListener('mousemove', (e) => {
            cursor.style.left = e.clientX + 'px';
            cursor.style.top = e.clientY + 'px';
            
            // Inverse Parallax Drift
            const x = (window.innerWidth / 2 - e.clientX) / 50;
            const y = (window.innerHeight / 2 - e.clientY) / 50;
            document.getElementById('parallax-bg').style.transform = `translate(${x}px, ${y}px)`;
        });

        document.querySelectorAll('a, button, .app-card').forEach(el => {
            el.addEventListener('mouseenter', () => cursor.classList.add('hover'));
            el.addEventListener('mouseleave', () => cursor.classList.remove('hover'));
        });

        // --- Three.js Morphing Engine ---
        try {
            const scene = new THREE.Scene();
            const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('webgl-canvas'), antialias: true, alpha: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

            // Particle Setup
            const count = 3000;
            const positions = new Float32Array(count * 3);
            const brainPositions = new Float32Array(count * 3);
            const neuronPositions = new Float32Array(count * 3);
            const chipPositions = new Float32Array(count * 3);

            // Shape 1: Brain (Ellipsoid with noise)
            for(let i=0; i<count; i++) {
                const phi = Math.acos(-1 + (2 * i) / count);
                const theta = Math.sqrt(count * Math.PI) * phi;
                brainPositions[i*3] = 4 * Math.cos(theta) * Math.sin(phi);
                brainPositions[i*3+1] = 5 * Math.sin(theta) * Math.sin(phi);
                brainPositions[i*3+2] = 4 * Math.cos(phi);
                const noise = Math.sin(brainPositions[i*3]*2) * 0.5;
                brainPositions[i*3] += noise;
            }

            // Shape 2: Neuron
            for(let i=0; i<count; i++) {
                if(i < 1000) { 
                    const r = Math.random() * 2;
                    neuronPositions[i*3] = (Math.random()-0.5) * r;
                    neuronPositions[i*3+1] = (Math.random()-0.5) * r;
                    neuronPositions[i*3+2] = (Math.random()-0.5) * r;
                } else { 
                    const branch = i % 12;
                    const angle = (branch / 12) * Math.PI * 2;
                    const len = 5 + Math.random() * 10;
                    neuronPositions[i*3] = Math.cos(angle) * len;
                    neuronPositions[i*3+1] = Math.sin(angle) * len;
                    neuronPositions[i*3+2] = (Math.random()-0.5) * 2;
                }
            }

            // Shape 3: Chip
            const gridSize = Math.floor(Math.sqrt(count));
            for(let i=0; i<count; i++) {
                const ix = i % gridSize;
                const iy = Math.floor(i / gridSize);
                chipPositions[i*3] = (ix - gridSize/2) * 0.4;
                chipPositions[i*3+1] = (iy - gridSize/2) * 0.4;
                chipPositions[i*3+2] = Math.sin(ix/2) * Math.cos(iy/2) * 0.5;
            }

            // Legacy Structures
            const brainMeshGeo = new THREE.SphereGeometry(3.5, 64, 64);
            const brainMeshMat = new THREE.MeshStandardMaterial({ color: 0xBD00FF, roughness: 0.22, metalness: 0.3, emissive: 0x110022 });
            const brainMesh = new THREE.Mesh(brainMeshGeo, brainMeshMat);
            scene.add(brainMesh);

            const neuronGroup = new THREE.Group();
            for(let i=0; i<12; i++) {
                const angle = (i/12) * Math.PI * 2;
                const curve = new THREE.CatmullRomCurve3([new THREE.Vector3(0,0,0), new THREE.Vector3(Math.cos(angle)*1.5, Math.sin(angle)*1.5, Math.random()), new THREE.Vector3(Math.cos(angle)*4, Math.sin(angle)*4, Math.random()*2)]);
                neuronGroup.add(new THREE.Mesh(new THREE.TubeGeometry(curve, 32, 0.05, 8, false), brainMeshMat));
            }
            neuronGroup.position.set(15, 0, -10);
            scene.add(neuronGroup);

            const skullGroup = new THREE.Group();
            const cyanMat = new THREE.MeshBasicMaterial({ color: 0x00F0FF, transparent: true, opacity: 0.3 });
            for(let i=0; i<12; i++) {
                const points = [];
                for(let j=0; j<20; j++) points.push(new THREE.Vector3(Math.sin(j/5)*3 + (Math.random()*0.2), j/2, Math.cos(j/5)*3 + i*0.1));
                skullGroup.add(new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(points), 64, 0.015, 8, false), cyanMat));
            }
            skullGroup.position.set(-15, 0, -15);
            scene.add(skullGroup);

            // Particles Initial
            for(let i=0; i<count*3; i++) positions[i] = brainPositions[i];
            const geometry = new THREE.BufferGeometry();
            geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
            const particles = new THREE.Points(geometry, new THREE.PointsMaterial({ color: 0xBD00FF, size: 0.08, transparent: true, opacity: 0.8 }));
            scene.add(particles);

            const ambient = new THREE.AmbientLight(0xffffff, 0.4);
            const point = new THREE.PointLight(0x00F0FF, 1.5);
            point.position.set(5, 5, 5);
            scene.add(ambient, point);

            camera.position.z = 15;

            let mouseX = 0, mouseY = 0;
            document.addEventListener('mousemove', (e) => {
                mouseX = (e.clientX - window.innerWidth / 2) / 100;
                mouseY = (e.clientY - window.innerHeight / 2) / 100;
            });

            function animate() {
                requestAnimationFrame(animate);
                const time = performance.now() * 0.001;
                
                // Legacy Deformation
                const pos = brainMesh.geometry.attributes.position;
                for (let i = 0; i < pos.count; i++) {
                    const v = new THREE.Vector3().fromBufferAttribute(pos, i).normalize();
                    const n = Math.sin(v.x*3 + time) * Math.cos(v.y*3 + time) * 0.15;
                    const scale = 3.5 + n;
                    pos.setXYZ(i, v.x*scale, v.y*scale, v.z*scale);
                }
                pos.needsUpdate = true;

                brainMesh.rotation.y += 0.002;
                neuronGroup.rotation.z -= 0.001;
                skullGroup.rotation.y += 0.001;
                particles.rotation.y += 0.001;

                scene.rotation.x += (mouseY - scene.rotation.x) * 0.05;
                scene.rotation.y += (mouseX - scene.rotation.y) * 0.05;
                renderer.render(scene, camera);
            }
            animate();

            gsap.registerPlugin(ScrollTrigger);
            const tl = gsap.timeline({ scrollTrigger: { trigger: ".scroll-container", start: "top top", end: "bottom bottom", scrub: 1.5 } });
            
            // Particle Morphing
            tl.to(particles.geometry.attributes.position.array, { endArray: neuronPositions, duration: 2, onUpdate: () => particles.geometry.attributes.position.needsUpdate = true }, 0)
              .to(particles.geometry.attributes.position.array, { endArray: chipPositions, duration: 2, onUpdate: () => particles.geometry.attributes.position.needsUpdate = true }, 2);

            // Legacy Transitions
            tl.to(brainMesh.position, { x: -10, z: -10, duration: 1 }, 0)
              .to(neuronGroup.position, { x: 0, y: 0, z: 0, duration: 1 }, 0.5)
              .to(skullGroup.position, { x: 0, y: 0, z: -5, duration: 1 }, 1.5);

            window.addEventListener('resize', () => { camera.aspect = window.innerWidth / window.innerHeight; camera.updateProjectionMatrix(); renderer.setSize(window.innerWidth, window.innerHeight); });
        } catch (e) { console.error("Safeguard:", e); }
    </script>
</body>
</html>
