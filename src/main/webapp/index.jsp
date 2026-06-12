<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuroSyncBCI | The Future of Neural Interfacing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <style>
        body { background-color: #020204; overflow-x: hidden; }
        #canvas-container { position: fixed; top: 0; left: 0; width: 100%; height: 100vh; z-index: -1; pointer-events: none; }
        .hero-section { height: 100vh; display: flex; align-items: center; justify-content: center; text-align: center; background: radial-gradient(circle at center, rgba(189, 0, 255, 0.05) 0%, transparent 70%); }
        .content-section { padding: 100px 0; min-height: 80vh; display: flex; align-items: center; opacity: 0; transform: translateY(50px); }
        .neon-text-cyan { color: #00F0FF; text-shadow: 0 0 10px #00F0FF; }
        .neon-text-purple { color: #BD00FF; text-shadow: 0 0 10px #BD00FF; }
        .glass-card-landing { background: rgba(18, 19, 26, 0.8); border: 1px solid rgba(0, 240, 255, 0.2); backdrop-filter: blur(15px); border-radius: 20px; padding: 40px; }
        .carousel-item { padding: 20px; }
        .feature-icon { font-size: 3rem; margin-bottom: 20px; display: block; }
    </style>
</head>
<body>

<div id="canvas-container"></div>

<nav class="navbar navbar-expand-lg navbar-dark fixed-top px-4" style="background: rgba(2, 2, 4, 0.8); backdrop-filter: blur(10px);">
    <a class="navbar-brand neon-text-purple" href="#">NEUROSYNC<span class="neon-text-cyan">BCI</span></a>
    <div class="ms-auto">
        <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-neon-purple me-2">Portal Access</a>
        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-neon-cyan">Enrollment</a>
    </div>
</nav>

<section class="hero-section">
    <div class="container" id="hero-content">
        <h1 class="display-1 fw-bold mb-3 neon-text-purple">NEURAL SYNC</h1>
        <p class="lead text-muted mb-5" style="letter-spacing: 5px;">TRANS-HUMAN COGNITIVE BRIDGING</p>
        <div class="d-flex justify-content-center gap-3">
            <button class="btn btn-outline-info px-5 py-3 rounded-pill" onclick="gsap.to(window, {scrollTo: '#about', duration: 1})">Explore Protocol</button>
        </div>
    </div>
</section>

<section id="about" class="content-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <div class="glass-card-landing">
                    <h2 class="neon-text-cyan mb-4">Fundamental BCI Concepts</h2>
                    <p class="text-light">Brain-Computer Interfaces (BCI) establish a direct communication pathway between an enhanced or wired brain and an external device. NeuroSync utilizes high-density ECoG arrays to decode intentional neural firing patterns into actionable digital commands.</p>
                    <ul class="list-unstyled mt-4 text-muted">
                        <li><i class="bi bi-cpu text-info"></i> High-Fidelity Signal Processing</li>
                        <li><i class="bi bi-activity text-info"></i> Real-time Neural Decoding</li>
                        <li><i class="bi bi-shield-lock text-info"></i> Biometric Encryption</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="content-section">
    <div class="container text-end">
        <div class="row justify-content-end">
            <div class="col-md-6">
                <div class="glass-card-landing" style="border-color: rgba(189, 0, 255, 0.3);">
                    <h2 class="neon-text-purple mb-4">Historical Milestones</h2>
                    <p class="text-light">From early EEG experiments in the 1970s to the modern era of implanted CMOS-based neural lace, the journey of BCI has been defined by the pursuit of bandwidth. NeuroSync represents the 4th generation of clinical interfaces, achieving >300 bpm information transfer rates.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="content-section">
    <div class="container">
        <h2 class="text-center mb-5 neon-text-cyan">Enterprise Ecosystem</h2>
        <div id="capabilityCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <div class="glass-card-landing text-center">
                        <span class="feature-icon neon-text-purple">01</span>
                        <h4>Clinical Rehabilitation</h4>
                        <p>Restoring motor function and communication to patients with severe neuromuscular disorders through intentional-mapping protocols.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="glass-card-landing text-center">
                        <span class="feature-icon neon-text-cyan">02</span>
                        <h4>Cognitive Augmentation</h4>
                        <p>Expanding human memory and processing capacity via direct cloud-linked neural nodes and synthetic co-processors.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <div class="glass-card-landing text-center">
                        <span class="feature-icon neon-text-magenta">03</span>
                        <h4>Secure Tele-Operation</h4>
                        <p>High-bandwidth control of complex industrial robotics across zero-latency neural networks.</p>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#capabilityCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#capabilityCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </div>
    </div>
</section>

<footer class="py-5 text-center text-muted border-top border-secondary">
    <p>&copy; 2026 NeuroSync Neural Systems. Authorized Personnel Only.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    gsap.registerPlugin(ScrollTrigger);

    // Three.js Brain Scene
    const container = document.getElementById('canvas-container');
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    container.appendChild(renderer.domElement);

    // Create a wireframe sphere (representing neural node network)
    const geometry = new THREE.IcosahedronGeometry(3, 15);
    const material = new THREE.MeshBasicMaterial({ 
        color: 0xBD00FF, 
        wireframe: true, 
        transparent: true, 
        opacity: 0.3 
    });
    const brain = new THREE.Mesh(geometry, material);
    scene.add(brain);

    // Add glowing points (nodes)
    const pointsGeometry = new THREE.IcosahedronGeometry(3.1, 2);
    const pointsMaterial = new THREE.PointsMaterial({ color: 0x00F0FF, size: 0.05 });
    const points = new THREE.Points(pointsGeometry, pointsMaterial);
    scene.add(points);

    camera.position.z = 8;

    // Mouse Interaction
    let mouseX = 0, mouseY = 0;
    document.addEventListener('mousemove', (e) => {
        mouseX = (e.clientX - window.innerWidth / 2) / 100;
        mouseY = (e.clientY - window.innerHeight / 2) / 100;
    });

    function animate() {
        requestAnimationFrame(animate);
        brain.rotation.y += 0.002;
        points.rotation.y -= 0.001;

        gsap.to(brain.rotation, { x: mouseY * 0.5, y: mouseX * 0.5, duration: 1 });
        gsap.to(points.rotation, { x: -mouseY * 0.3, y: -mouseX * 0.3, duration: 1 });

        renderer.render(scene, camera);
    }
    animate();

    // Scroll Animations
    gsap.utils.toArray('.content-section').forEach(section => {
        gsap.to(section, {
            scrollTrigger: {
                trigger: section,
                start: "top 80%",
                end: "bottom 20%",
                toggleActions: "play none none reverse"
            },
            opacity: 1,
            y: 0,
            duration: 1.5,
            ease: "power4.out"
        });
    });

    // Parallax Brain
    gsap.to(brain.position, {
        scrollTrigger: {
            trigger: "body",
            start: "top top",
            end: "bottom bottom",
            scrub: 1
        },
        y: -5,
        z: -2
    });
</script>

</body>
</html>
