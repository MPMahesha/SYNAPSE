<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SYNAPSE | Neural Systems Architecture</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
</head>
<body>

<div id="custom-cursor"></div>
<div id="canvas-container"></div>
<div class="particle-bg" id="parallax-bg"></div>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top px-4">
    <a class="navbar-brand neon-text-cyan" href="#">SYNAPSE</a>
    <div class="ms-auto d-none d-lg-flex gap-4 align-items-center">
        <a href="#about" class="text-decoration-none text-muted-bright small hover-cyan">WHAT IS BCI?</a>
        <a href="#history" class="text-decoration-none text-muted-bright small hover-cyan">HISTORY</a>
        <a href="#apps" class="text-decoration-none text-muted-bright small hover-cyan">APPLICATIONS</a>
        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-synapse btn-synapse-purple btn-sm">[ Portal Access ]</a>
        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-synapse btn-sm">[ Enrollment ]</a>
    </div>
</nav>

<!-- SECTION 1: WHAT IS BCI? -->
<section id="hero" class="content-section" style="text-align: center; justify-content: center; padding-bottom: 250px;">
    <div class="container">
        <h5 class="neon-text-cyan mb-3" style="letter-spacing: 5px;">Elevating Human Cognition</h5>
        <h1 class="display-1 fw-bold mb-4 neon-text-purple" style="letter-spacing: 15px;">SYNAPSE</h1>
    </div>
</section>

<section id="about" class="content-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h2 class="h3 text-high-vis mb-5">What is a Brain-Computer Interface?</h2>
                <p class="lead text-description mb-5">
                    A Brain-Computer Interface (BCI) is a direct, bi-directional communication pathway that bridges the biological mind with external digital systems. By bypassing traditional neuromuscular channels (like speaking or moving your hands), BCI systems record neural activity, decode it using advanced machine learning algorithms, and translate those thoughts into real-time digital commands.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- SECTION 2: THE HISTORY OF BCI -->
<section id="history" class="content-section">
    <div class="container">
        <div class="text-center mb-5">
            <h5 class="neon-text-purple">From Sci-Fi to Reality</h5>
            <h2 class="display-4 fw-bold text-high-vis">The Evolution of Neural Interfacing</h2>
            <p class="text-description mx-auto" style="max-width: 700px;">The concept of plugging the human brain into a computer isn't new, but the engineering required decades to perfect.</p>
        </div>

        <div class="journey-path">
            <div class="journey-node">
                <h4 class="text-high-vis">1924 – The First Discovery</h4>
                <p class="text-description">Hans Berger records the very first human brainwaves using an EEG (Electroencephalogram), proving that the human brain continuously emits measurable electrical signals.</p>
            </div>
            <div class="journey-node">
                <h4 class="text-high-vis">1973 – Coining the Term</h4>
                <p class="text-description">Professor Jacques Vidal at UCLA officially coins the term 'Brain-Computer Interface' and publishes the first blueprint for using EEG signals to control external graphics.</p>
            </div>
            <div class="journey-node">
                <h4 class="text-high-vis">1998 – The First Cybernetic Human</h4>
                <p class="text-description">Dr. Philip Kennedy implants the first chronic cortical BCI into a human patient suffering from locked-in syndrome, allowing them to control a computer cursor by imagining movement.</p>
            </div>
            <div class="journey-node">
                <h4 class="text-high-vis">The Pioneer: Matthew Nagle (2004)</h4>
                <p class="text-description">
                    Nagle became the first human to be implanted with a cybernetic microelectrode array (the Utah Array) in his motor cortex. Through this pioneering trial:
                    <br>• He successfully controlled a computer cursor to play Pong.
                    <br>• He opened and closed a prosthetic robotic hand.
                    <br>• He operated a television remote control using nothing but his thoughts.
                    <br><br>
                    Nagle's courage proved to the medical world that a paralyzed brain could still send perfectly coherent digital commands out to the world.
                </p>
            </div>
        </div>
    </div>
</section>

<!-- SECTION 3: CORE APPLICATIONS & USES -->
<section id="apps" class="content-section">
    <div class="container">
        <div class="text-center mb-5">
            <h5 class="neon-text-cyan">Unlocking New Dimensions of Capability</h5>
            <h2 class="display-4 fw-bold text-high-vis">How BCI Redefines Human Potential</h2>
        </div>

        <div id="appCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="glass-card text-center mx-auto" style="max-width: 850px;">
                        <h3 class="neon-text-purple mb-4">Neuroprosthetics & Mobility Restoration</h3>
                        <p class="text-description">Reconnecting the mind to robotic limbs, exoskeletons, and digital interfaces. Patients with spinal cord injuries or ALS can regain autonomy by controlling wheelchairs or smart homes directly.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="glass-card text-center mx-auto" style="max-width: 850px;">
                        <h3 class="neon-text-purple mb-4">Augmentative Communication</h3>
                        <p class="text-description">Giving a voice back to the locked-in. High-speed neural decoding converts imagined speech or typing into text and synthesized audio at near-natural conversational speeds.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="glass-card text-center mx-auto" style="max-width: 850px;">
                        <h3 class="neon-text-purple mb-4">Cognitive Enhancement & Therapeutics</h3>
                        <p class="text-description">Utilizing closed-loop neural feedback to treat severe treatment-resistant depression, PTSD, and neurological disorders by gently steering chaotic brain patterns back into harmony.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="glass-card text-center mx-auto" style="max-width: 850px;">
                        <h3 class="neon-text-purple mb-4">Next-Gen Human-Computer Interaction (HCI)</h3>
                        <p class="text-description">Moving beyond keyboards and touchscreens. The future of BCI includes hands-free, frictionless interaction with spatial computing, virtual environments, and complex digital ecosystems.</p>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#appCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#appCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </div>
</section>

<!-- SECTION 4: HOW BCI CHANGED MEDICAL TECHNOLOGY -->
<section id="impact" class="content-section">
    <div class="container">
        <div class="text-center mb-5">
            <h5 class="neon-text-magenta">A Paradigm Shift in Modern Medicine</h5>
            <h2 class="display-4 fw-bold text-high-vis">Beyond Treatment. Total Restoration.</h2>
            <p class="text-description mx-auto mt-4" style="max-width: 800px;">Traditionally, medicine relied on biochemistry (pharmaceuticals) or macro-surgery to treat neurological conditions. BCI has fundamentally shifted medical technology into the era of bioelectronic medicine.</p>
        </div>

        <div class="row g-4 mt-5">
            <div class="col-md-4">
                <div class="glass-card h-100" style="border-top: 4px solid var(--neon-purple);">
                    <h4 class="text-high-vis mb-3">Bypassing the Injury</h4>
                    <p class="text-description small">Instead of trying to heal complex, scarred spinal cords, BCI simply creates a digital detour. It takes the intent from the brain and beams it wirelessly past the injury straight to the muscles or assistive devices.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card h-100" style="border-top: 4px solid var(--neon-cyan);">
                    <h4 class="text-high-vis mb-3">Neuroplasticity Acceleration</h4>
                    <p class="text-description small">Continuous use of a BCI trains the brain to form new neural pathways. By marrying intent with instant digital action, patients see accelerated rehabilitation rates that were previously thought biologically impossible.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="glass-card h-100" style="border-top: 4px solid var(--pure-white);">
                    <h4 class="text-high-vis mb-3">Real-Time Neurological Data</h4>
                    <p class="text-description small">For the first time, clinicians don’t have to guess what is happening inside a patient’s brain. Continuous, real-time neural decoding provides a living map of cognitive health, allowing for predictive diagnostics before symptoms even manifest.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- SECTION 5: FOOTER / CALL TO ACTION -->
<footer class="content-section" style="min-height: 60vh; text-align: center; border-top: 1px solid rgba(255,255,255,0.05);">
    <div class="container">
        <h2 class="display-4 fw-bold mb-4 neon-text-purple">The Future is Wired. Are You Ready?</h2>
        <div class="d-flex justify-content-center gap-4 mt-5">
            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-synapse btn-synapse-purple px-5 py-3">[ Portal Access ]</a>
            <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-synapse px-5 py-3">[ Enrollment ]</a>
        </div>
        <div class="mt-5 pt-5">
            <p class="text-muted-bright small">&copy; 2026 SYNAPSE NEURAL SYSTEMS. ALL RIGHTS RESERVED.</p>
        </div>
    </div>
</footer>

<script>
    try {
        // 1. SYSTEM INITIALIZATION & CANVAS INFRASTRUCTURE
        const container = document.getElementById('canvas-container');
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
        
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.setClearColor(0x000000, 1.0); 
        if(container) container.appendChild(renderer.domElement);

        scene.add(new THREE.AmbientLight(0x110522, 2.0));
        const dLight = new THREE.DirectionalLight(0x00F0FF, 3.5);
        dLight.position.set(10, 15, 8);
        scene.add(dLight);

        // --- FULL-SCREEN GRAIN SHADER ---
        const noiseShaderMat = new THREE.ShaderMaterial({
            uniforms: { 
                time: { value: 1.0 }, 
                resolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) } 
            },
            vertexShader: `varying vec2 vUv; void main() { vUv = uv; gl_Position = vec4(position, 1.0); }`,
            fragmentShader: `
                uniform float time;
                uniform vec2 resolution;
                varying vec2 vUv;
                float noise(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }
                void main() {
                    float n = noise(vUv * (resolution.xy / 100.0) + time * 0.05);
                    gl_FragColor = vec4(vec3(n * 0.04), 1.0);
                }
            `,
            transparent: true,
            depthTest: false
        });
        const noiseQuad = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), noiseShaderMat);
        const noiseScene = new THREE.Scene();
        const noiseCam = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
        noiseScene.add(noiseQuad);

        const material = new THREE.MeshStandardMaterial({
            color: 0xBD00FF,
            roughness: 0.22,
            metalness: 0.3,
            transparent: true,
            opacity: 1
        });

        const v = new THREE.Vector3();

        // --- MODEL A: ANATOMICAL HUMAN BRAIN ---
        const geoA = new THREE.SphereGeometry(3.5, 128, 128);
        const posA = geoA.attributes.position;
        for(let i = 0; i < posA.count; i++) {
            v.fromBufferAttribute(posA, i);
            const theta = Math.atan2(v.y, v.x);
            const phi = Math.acos(v.z / v.length());
            const g1 = 0.65 * Math.sin(14 * phi) * Math.cos(14 * theta);
            const g2 = 0.25 * Math.sin(32 * phi) * Math.sin(32 * theta);
            const r = 3.5 + g1 + g2;
            v.normalize().multiplyScalar(r);
            if(v.x > 0) v.x += 0.15; else v.x -= 0.15;
            posA.setXYZ(i, v.x * 1.5, v.y * 1.1, v.z * 1.3);
        }
        geoA.computeVertexNormals();
        const meshA = new THREE.Mesh(geoA, material.clone());
        scene.add(meshA);

        // --- MODEL B: BIOLOGICAL NEURON STRUCTURE ---
        const groupB = new THREE.Group();
        const soma = new THREE.Mesh(new THREE.SphereGeometry(1.2, 64, 64), material.clone());
        const sPos = soma.geometry.attributes.position;
        for(let i = 0; i < sPos.count; i++) {
            v.fromBufferAttribute(sPos, i);
            const n = 1 + (Math.sin(v.x * 8) + Math.cos(v.y * 8)) * 0.15;
            v.multiplyScalar(n);
            sPos.setXYZ(i, v.x, v.y, v.z);
        }
        soma.geometry.computeVertexNormals();
        groupB.add(soma);
        for(let i = 0; i < 12; i++) {
            const branch = new THREE.Mesh(new THREE.CylinderGeometry(0.02, 0.3, 10, 12), material.clone());
            branch.rotation.set(Math.random() * Math.PI, Math.random() * Math.PI, Math.random() * Math.PI);
            branch.translateY(5);
            groupB.add(branch);
        }
        const axon = new THREE.Mesh(new THREE.CylinderGeometry(0.12, 0.12, 20, 12), material.clone());
        axon.position.set(0, -10, 0);
        groupB.add(axon);
        groupB.scale.set(2.5, 2.5, 2.5);
        groupB.visible = false;
        scene.add(groupB);

        // --- MODEL C: HUMAN SKULL & CYBERNETIC CABLES ---
        const groupC = new THREE.Group();
        const skullGeo = new THREE.SphereGeometry(3, 128, 128);
        const skPos = skullGeo.attributes.position;
        for(let i = 0; i < skPos.count; i++) {
            v.fromBufferAttribute(skPos, i);
            const headMod = 1.0 + (v.y > 0 ? 0.35 : -0.25) + (Math.abs(v.x) < 0.6 ? 0.2 : 0);
            skPos.setXYZ(i, v.x * headMod * 1.25, v.y * headMod * 1.6, v.z * headMod * 1.15);
        }
        skullGeo.computeVertexNormals();
        const skull = new THREE.Mesh(skullGeo, material.clone());
        groupC.add(skull);
        const cableMat = new THREE.MeshStandardMaterial({ color: 0x00F0FF, emissive: 0x00F0FF, emissiveIntensity: 2.5 });
        for(let i = 0; i < 12; i++) {
            const pts = [];
            for(let j = 0; j < 12; j++) pts.push(new THREE.Vector3(Math.sin(i + j) * 3, Math.cos(i + j) * 3, -j * 4));
            const cable = new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(pts), 64, 0.1, 10, false), cableMat);
            cable.position.set(0, -1, -3);
            groupC.add(cable);
        }
        groupC.visible = false;
        scene.add(groupC);

        camera.position.z = 25;

        // 2. PARALLAX DRIFT & MOUSE TRACKING
        let mouseX = 0, mouseY = 0;
        document.addEventListener('mousemove', e => {
            mouseX = (e.clientX / window.innerWidth) * 2 - 1;
            mouseY = -(e.clientY / window.innerHeight) * 2 + 1;
            const reticle = document.getElementById('custom-cursor');
            if(reticle) { reticle.style.left = e.clientX + 'px'; reticle.style.top = e.clientY + 'px'; }
        });

        // 3. GSAP SCROLL BLENDING
        gsap.registerPlugin(ScrollTrigger);
        const mainTl = gsap.timeline({
            scrollTrigger: { trigger: "body", start: "top top", end: "bottom bottom", scrub: 1.5 }
        });
        mainTl.to(meshA.material, { opacity: 0, duration: 1, onUpdate: () => { meshA.visible = meshA.material.opacity > 0; } }, 0);
        mainTl.to(groupB, { visible: true, duration: 0.1 }, 0.5);
        groupB.children.forEach(m => mainTl.fromTo(m.material, { opacity: 0 }, { opacity: 1, duration: 1 }, 0.5));
        groupB.children.forEach(m => mainTl.to(m.material, { opacity: 0, duration: 1, onUpdate: () => { groupB.visible = m.material.opacity > 0; } }, 2));
        mainTl.to(groupC, { visible: true, duration: 0.1 }, 2.5);
        groupC.children.forEach(m => { if(m.material.color.getHex() === 0xBD00FF) mainTl.fromTo(m.material, { opacity: 0 }, { opacity: 1, duration: 1 }, 2.5); });

        // 4. ANIMATION LOOP
        function animate(time) {
            requestAnimationFrame(animate);
            noiseShaderMat.uniforms.time.value = time * 0.001;
            scene.position.x += (mouseX * 4.5 - scene.position.x) * 0.05;
            scene.position.y += (mouseY * 4.5 - scene.position.y) * 0.05;
            scene.rotation.y += (mouseX * 0.2 - scene.rotation.y) * 0.05;
            renderer.autoClear = false;
            renderer.clear();
            renderer.render(noiseScene, noiseCam);
            renderer.render(scene, camera);
        }
        animate(0);

        window.addEventListener('resize', () => {
            camera.aspect = window.innerWidth / window.innerHeight;
            camera.updateProjectionMatrix();
            renderer.setSize(window.innerWidth, window.innerHeight);
            noiseShaderMat.uniforms.resolution.value.set(window.innerWidth, window.innerHeight);
        });

    } catch(err) { console.error("Anatomical Engine Subsystem Failure:", err); }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
