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
    // Custom Tactical Cursor
    const cursor = document.getElementById('custom-cursor');
    document.addEventListener('mousemove', e => {
        cursor.style.left = e.clientX + 'px';
        cursor.style.top = e.clientY + 'px';
    });
    document.addEventListener('mousedown', () => cursor.classList.add('cursor-hover'));
    document.addEventListener('mouseup', () => cursor.classList.remove('cursor-hover'));

    // Inverse Parallax Background
    const parallaxBg = document.getElementById('parallax-bg');
    document.addEventListener('mousemove', e => {
        const moveX = (e.clientX - window.innerWidth / 2) / 50;
        const moveY = (e.clientY - window.innerHeight / 2) / 50;
        parallaxBg.style.transform = `translate(${-moveX}px, ${-moveY}px)`;
    });

    // Three.js 3D Morphing Particle Engine
    const container = document.getElementById('canvas-container');
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    container.appendChild(renderer.domElement);

    const particleCount = 6000;
    const geometry = new THREE.BufferGeometry();
    const positions = new Float32Array(particleCount * 3);

    // Initial State: High-Fidelity 3D Brain Point Cloud
    const brainPoints = new Float32Array(particleCount * 3);
    for (let i = 0; i < particleCount; i++) {
        let x, y, z;
        const u = Math.random();
        const v = Math.random();
        const theta = 2 * Math.PI * u;
        const phi = Math.acos(2 * v - 1);
        
        // Complex Brain geometry logic: Lobed Ellipsoid
        const r = 3 + (Math.sin(theta * 3) * 0.15) + (Math.cos(phi * 4) * 0.1);
        x = r * Math.sin(phi) * Math.cos(theta) * 1.3; // Frontal expansion
        y = r * Math.sin(phi) * Math.sin(theta);
        z = r * Math.cos(phi) * 0.9;

        brainPoints[i*3] = x;
        brainPoints[i*3+1] = y;
        brainPoints[i*3+2] = z;
        
        positions[i*3] = x;
        positions[i*3+1] = y;
        positions[i*3+2] = z;
    }

    geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
    const material = new THREE.PointsMaterial({ 
        color: 0xBD00FF, 
        size: 0.025, 
        transparent: true, 
        opacity: 0.8,
        blending: THREE.AdditiveBlending 
    });
    const points = new THREE.Points(geometry, material);
    scene.add(points);

    camera.position.z = 8;

    // STATE 2: Neuron (Branching Network Structure)
    const neuronPoints = new Float32Array(particleCount * 3);
    for (let i = 0; i < particleCount; i++) {
        const angle = (i / particleCount) * Math.PI * 2 * 20;
        const radius = (i / particleCount) * 4;
        neuronPoints[i*3] = Math.cos(angle) * radius * (Math.random() + 0.5);
        neuronPoints[i*3+1] = Math.sin(angle) * radius * (Math.random() + 0.5);
        neuronPoints[i*3+2] = (Math.random() - 0.5) * 2;
    }

    // STATE 3: Silicon Chip (Geometric Grid)
    const chipPoints = new Float32Array(particleCount * 3);
    const side = Math.floor(Math.sqrt(particleCount));
    for (let i = 0; i < particleCount; i++) {
        chipPoints[i*3] = ((i % side) - side/2) * 0.18;
        chipPoints[i*3+1] = (Math.floor(i / side) - side/2) * 0.18;
        chipPoints[i*3+2] = (Math.random() - 0.5) * 0.05;
    }

    gsap.registerPlugin(ScrollTrigger);

    // Scroll-Driven Morph Timeline
    const mainTl = gsap.timeline({
        scrollTrigger: {
            trigger: "body",
            start: "top top",
            end: "bottom bottom",
            scrub: 2.5
        }
    });

    // Morph Brain -> Neuron
    mainTl.to(positions, {
        endArray: neuronPoints,
        duration: 3,
        onUpdate: () => geometry.attributes.position.needsUpdate = true
    }, 0);

    // Morph Neuron -> Chip
    mainTl.to(positions, {
        endArray: chipPoints,
        duration: 3,
        onUpdate: () => geometry.attributes.position.needsUpdate = true
    }, 3);

    // Dynamic Color Shift (Purple -> Cyan)
    mainTl.to(material.color, { r: 0, g: 0.94, b: 1, duration: 6 }, 0);

    // Mouse drift listener
    let targetX = 0, targetY = 0;
    document.addEventListener('mousemove', e => {
        targetX = (e.clientX - window.innerWidth / 2) / 250;
        targetY = (e.clientY - window.innerHeight / 2) / 250;
    });

    function renderLoop() {
        requestAnimationFrame(renderLoop);
        points.rotation.y += 0.001;
        points.rotation.x = gsap.utils.interpolate(points.rotation.x, targetY, 0.05);
        points.rotation.y = gsap.utils.interpolate(points.rotation.y, targetX, 0.05);
        renderer.render(scene, camera);
    }
    renderLoop();

    window.addEventListener('resize', () => {
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
erHeight);
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
