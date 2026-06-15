<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NeuroSync | Neural Matrix Gateway</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/ScrollTrigger.min.js"></script>
    <style>
        :root { --accent: #BD00FF; --cyan: #00F0FF; }
        body, html { margin: 0; padding: 0; width: 100%; height: 100%; background: #000; color: #fff; font-family: 'Inter', sans-serif; overflow-x: hidden; }
        #webgl-canvas { position: fixed; top: 0; left: 0; z-index: -1; pointer-events: none; }
        .scroll-container { position: relative; min-height: 400vh; }
        section { height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center; text-align: center; }
        .auth-panel { background: rgba(10, 10, 15, 0.85); backdrop-filter: blur(20px); border: 1px solid rgba(189, 0, 255, 0.2); padding: 40px; border-radius: 8px; box-shadow: 0 0 50px rgba(189, 0, 255, 0.1); width: 350px; }
        h1 { font-size: 3.5rem; letter-spacing: 0.8rem; text-transform: uppercase; margin: 0; color: var(--cyan); text-shadow: 0 0 20px rgba(0, 240, 255, 0.3); }
        .tagline { color: var(--accent); letter-spacing: 0.3rem; font-weight: 300; margin-top: 10px; }
        input { width: 100%; padding: 12px; margin: 10px 0; background: #000; border: 1px solid #333; color: #fff; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 15px; margin-top: 20px; background: linear-gradient(45deg, var(--accent), var(--cyan)); border: none; color: #fff; font-weight: 900; letter-spacing: 2px; cursor: pointer; text-transform: uppercase; transition: transform 0.3s; }
        button:hover { transform: scale(1.02); box-shadow: 0 0 20px var(--accent); }
        .error-overlay { color: #ff3333; font-size: 0.8rem; margin-top: 10px; text-transform: uppercase; letter-spacing: 1px; }
    </style>
</head>
<body>
    <canvas id="webgl-canvas"></canvas>

    <div class="scroll-container">
        <section id="hero">
            <h1>NEUROSYNC</h1>
            <p class="tagline">SYNAPSE CORE TELEMETRY</p>
            <p style="margin-top: 50px; opacity: 0.5;">SCROLL TO INITIALIZE LINK</p>
        </section>

        <section id="auth">
            <div class="auth-panel">
                <h2 style="margin-top: 0; letter-spacing: 2px;">NEURAL ACCESS</h2>
                <% if(request.getParameter("error") != null) { %>
                    <div class="error-overlay">Handshake Failed: <%= request.getParameter("error").replace("_", " ") %></div>
                <% } %>
                <form action="login" method="POST">
                    <input type="email" name="email" placeholder="NEURAL IDENTITY (EMAIL)" required>
                    <input type="password" name="password" placeholder="SECURITY KEY" required>
                    <button type="submit">Establish Connection</button>
                </form>
                <div style="margin-top: 20px; font-size: 0.7rem; opacity: 0.6;">
                    NEW SUBJECT? <a href="auth/register" style="color: var(--cyan); text-decoration: none; font-weight: bold;">PROVISION IDENTITY</a>
                </div>
            </div>
        </section>

        <section id="specs">
            <div style="max-width: 600px; padding: 40px; background: rgba(0,0,0,0.5); backdrop-filter: blur(10px);">
                <h3 style="color: var(--cyan);">HARDWARE MATRIX v2.6</h3>
                <p style="text-align: left; font-size: 0.9rem; line-height: 1.6; color: #aaa;">
                    Utilizing asymmetric neural ingestion protocols. 8-channel EEG at 250Hz. 
                    Deep predictive intent decoding via NeuroGator pipeline. 
                    Real-time spectral FFT stabilization.
                </p>
            </div>
        </section>
    </div>

    <script>
        try {
            const scene = new THREE.Scene();
            const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
            const renderer = new THREE.WebGLRenderer({ canvas: document.getElementById('webgl-canvas'), antialias: true, alpha: true });
            renderer.setSize(window.innerWidth, window.innerHeight);
            renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
            renderer.setClearColor(0x000000, 1.0);

            // --- Cinematic Film Grain Shader ---
            const grainVertexShader = `varying vec2 vUv; void main() { vUv = uv; gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0); }`;
            const grainFragmentShader = `uniform float uTime; varying vec2 vUv; float random(vec2 p) { return fract(sin(dot(p.xy ,vec2(12.9898,78.233))) * 43758.5453); } void main() { float grain = random(vUv + uTime) * 0.05; gl_FragColor = vec4(vec3(grain), 0.1); }`;
            const grainMat = new THREE.ShaderMaterial({ uniforms: { uTime: { value: 0 } }, vertexShader: grainVertexShader, fragmentShader: grainFragmentShader, transparent: true, depthTest: false });
            const grainMesh = new THREE.Mesh(new THREE.PlaneGeometry(2, 2), grainMat);
            const grainScene = new THREE.Scene();
            const grainCamera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);
            grainScene.add(grainMesh);

            // --- Lighting ---
            const ambient = new THREE.AmbientLight(0xffffff, 0.3);
            const point = new THREE.PointLight(0x00F0FF, 1.5);
            point.position.set(5, 5, 5);
            scene.add(ambient, point);

            const mat = new THREE.MeshStandardMaterial({ color: 0xBD00FF, roughness: 0.22, metalness: 0.3, emissive: 0x110022 });

            // meshA: Brain (Spherical Harmonics)
            const brainGeo = new THREE.SphereGeometry(3, 128, 128);
            const brainPos = brainGeo.attributes.position;
            const meshA = new THREE.Mesh(brainGeo, mat);
            scene.add(meshA);

            // meshB: Neuron (Soma + Dendrites)
            const meshB = new THREE.Group();
            const soma = new THREE.Mesh(new THREE.IcosahedronGeometry(0.8, 1), mat);
            meshB.add(soma);
            for(let i=0; i<12; i++) {
                const angle = (i/12) * Math.PI * 2;
                const curve = new THREE.CatmullRomCurve3([new THREE.Vector3(0,0,0), new THREE.Vector3(Math.cos(angle)*1.5, Math.sin(angle)*1.5, Math.random()), new THREE.Vector3(Math.cos(angle)*4, Math.sin(angle)*4, Math.random()*2)]);
                meshB.add(new THREE.Mesh(new THREE.TubeGeometry(curve, 32, 0.05, 8, false), mat));
            }
            meshB.position.set(10, 0, -10);
            scene.add(meshB);

            // meshC: Cybernetic Skull (Cyan Splines)
            const meshC = new THREE.Group();
            const cyanMat = new THREE.MeshBasicMaterial({ color: 0x00F0FF, transparent: true, opacity: 0.6 });
            for(let i=0; i<12; i++) {
                const points = [];
                for(let j=0; j<20; j++) {
                    const p = j/20;
                    points.push(new THREE.Vector3(Math.sin(p*Math.PI)*2.5 + (Math.random()-0.5)*0.2, Math.cos(p*Math.PI)*3.5, Math.sin(p*Math.PI*2)*1.2 + i*0.2));
                }
                meshC.add(new THREE.Mesh(new THREE.TubeGeometry(new THREE.CatmullRomCurve3(points), 64, 0.015, 8, false), cyanMat));
            }
            meshC.position.set(-10, 0, -15);
            scene.add(meshC);

            camera.position.z = 12;

            function animate() {
                requestAnimationFrame(animate);
                const time = performance.now() * 0.001;
                grainMat.uniforms.uTime.value = time;

                // Brain Wave Deformation
                for(let i=0; i<brainPos.count; i++) {
                    const v = new THREE.Vector3().fromBufferAttribute(brainPos, i).normalize();
                    const noise = Math.sin(v.x*3 + time) * Math.cos(v.y*3 + time) * 0.15;
                    const sagittal = Math.abs(v.x) < 0.15 ? -0.2 : 0;
                    const scale = 3 + noise + sagittal;
                    brainPos.setXYZ(i, v.x*scale, v.y*scale, v.z*scale);
                }
                brainPos.needsUpdate = true;
                
                meshA.rotation.y += 0.003;
                meshB.rotation.z -= 0.002;
                meshC.rotation.y += 0.001;

                renderer.autoClear = true;
                renderer.render(scene, camera);
                renderer.autoClear = false;
                renderer.render(grainScene, grainCamera);
            }
            animate();

            gsap.registerPlugin(ScrollTrigger);
            const tl = gsap.timeline({ scrollTrigger: { trigger: ".scroll-container", start: "top top", end: "bottom bottom", scrub: 1 } });
            tl.to(meshA.position, { x: -8, z: -5, duration: 1 })
              .to(meshA, { opacity: 0, duration: 0.5, onUpdate: () => { if(meshA.opacity <= 0.01) meshA.visible = false; else meshA.visible = true; } }, 0.5)
              .to(meshB.position, { x: 0, z: 0, duration: 1 }, 0.5)
              .to(meshC.position, { x: 0, z: -5, duration: 1 }, 1.5);

            window.addEventListener('resize', () => {
                camera.aspect = window.innerWidth / window.innerHeight;
                camera.updateProjectionMatrix();
                renderer.setSize(window.innerWidth, window.innerHeight);
            });
        } catch (e) { console.error("WebGL Safeguard:", e); document.body.style.background = "#050505"; }
    </script>
</body>
</html>
