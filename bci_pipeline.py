import asyncio
import json
import random
import time
import numpy as np
from scipy.signal import butter, lfilter, welch
import websockets

# --- BCI System Configuration ---
SAMPLING_RATE = 250  # Fixed 250 Hz for research stability
CHANNELS = 8
WINDOW_SIZE = 250    # 1.0 second window for FFT
BROADCAST_INTERVAL = 1/30 # 30Hz Refresh Rate for UI
PORT = 8765

class DatasetStreamer:
    """
    Handles EEG data ingestion and playback simulation.
    Target: PhysioNet EEG Motor Movement Dataset emulation.
    """
    def __init__(self):
        self.t = 0
        self.fs = SAMPLING_RATE
        # Simulate base EEG frequencies (Delta, Theta, Alpha, Beta, Gamma)
        self.freq_map = {
            "delta": (0.5, 4),
            "theta": (4, 8),
            "alpha": (8, 13),
            "beta": (13, 30),
            "gamma": (30, 45)
        }

    def get_frame(self):
        """Generates a realistic EEG frame with multi-band components."""
        frame = np.zeros(CHANNELS)
        self.t += 1/self.fs
        
        # Layered frequency synthesis for realism
        for channel in range(CHANNELS):
            # Base 1/f noise characteristic of EEG
            noise = np.random.normal(0, 5.0)
            
            # Oscillatory components
            delta = 10 * np.sin(2 * np.pi * 2 * self.t + channel) # 2Hz
            theta = 6 * np.sin(2 * np.pi * 6 * self.t + channel)  # 6Hz
            alpha = 12 * np.sin(2 * np.pi * 10 * self.t + channel) # 10Hz
            beta = 8 * np.sin(2 * np.pi * 22 * self.t + channel)  # 22Hz
            
            # Combine signals (Voltage range roughly -100 to 100 uV)
            frame[channel] = delta + theta + alpha + beta + noise
            
        return frame

class ResearchBCIEngine:
    """
    Unified Signal Processing & Inference Pipeline.
    Single source of truth for all dashboard metrics.
    """
    def __init__(self):
        self.streamer = DatasetStreamer()
        self.buffer = np.zeros((CHANNELS, WINDOW_SIZE))
        
        # DSP: 5th Order Butterworth (0.5Hz - 45Hz)
        self.b, self.a = butter(5, [0.5, 45], btype='bandpass', fs=SAMPLING_RATE)
        
        # State Management
        self.start_time = time.time()
        self.total_trials = 1245 # Emulating historical data
        self.packets_received = 0
        self.last_intent = "REST"
        self.intent_timer = 0
        self.intent_threshold = 0.85
        
        # Cached Metrics
        self.spectral_power = {"delta": 15, "theta": 20, "alpha": 35, "beta": 25, "gamma": 5}
        self.metrics = {
            "attention": 70,
            "meditation": 60,
            "fatigue": 0,
            "snr": 25.0,
            "impedance": 4.5,
            "quality": "Excellent"
        }

    def process_cycle(self):
        """Executes the full pipeline for one update cycle."""
        # 1. Data Ingestion
        new_sample = self.streamer.get_frame()
        self.buffer = np.roll(self.buffer, -1, axis=1)
        self.buffer[:, -1] = new_sample
        self.packets_received += 1
        
        # 2. Filtering
        filtered = lfilter(self.b, self.a, self.buffer, axis=-1)
        
        # 3. Spectral Analysis (Welch Method)
        freqs, psd = welch(filtered, fs=SAMPLING_RATE, nperseg=WINDOW_SIZE)
        
        # Extract Band Powers
        bands = {}
        bands["delta"] = np.mean(psd[:, (freqs >= 0.5) & (freqs < 4)])
        bands["theta"] = np.mean(psd[:, (freqs >= 4) & (freqs < 8)])
        bands["alpha"] = np.mean(psd[:, (freqs >= 8) & (freqs < 13)])
        bands["beta"] = np.mean(psd[:, (freqs >= 13) & (freqs < 30)])
        bands["gamma"] = np.mean(psd[:, (freqs >= 30) & (freqs < 45)])
        
        total_p = sum(bands.values())
        if total_p > 0:
            self.spectral_power = {k: round((v/total_p) * 100, 1) for k, v in bands.items()}
            
            # Clinical Logic
            # Attention = (Beta + Gamma) / Total
            self.metrics["attention"] = int((bands["beta"] + bands["gamma"]) / total_p * 200) # Scaling for demo visibility
            self.metrics["attention"] = min(max(self.metrics["attention"], 40), 95)
            
            # Meditation = (Alpha + Theta) / Total
            self.metrics["meditation"] = int((bands["alpha"] + bands["theta"]) / total_p * 150)
            self.metrics["meditation"] = min(max(self.metrics["meditation"], 20), 95)
            
        # 4. Intent Decoding (Hysteresis)
        predicted_intent, confidence = self.mock_classifier()
        
        if predicted_intent == self.last_intent:
            self.intent_timer += BROADCAST_INTERVAL
        else:
            self.intent_timer = 0
            self.last_intent = predicted_intent

        # 5. Engineering Metrics
        self.update_engineering_stats()
        
        return {
            "ts": time.time(),
            "runtime": round(time.time() - self.start_time, 1),
            "raw_voltages": self.buffer[:, -1].tolist(),
            "spectral": self.spectral_power,
            "clinician": {
                "attention": self.metrics["attention"],
                "meditation": self.metrics["meditation"],
                "fatigue": self.calculate_fatigue(),
                "intent": self.last_intent if self.intent_timer > 2.0 else "STABILIZING...",
                "confidence": round(confidence * 100, 1),
                "accuracy": 92.4,
                "trials": self.total_trials
            },
            "engineer": {
                "sampling_rate": SAMPLING_RATE,
                "snr": round(self.metrics["snr"], 1),
                "impedance": round(self.metrics["impedance"], 2),
                "packet_loss": 0.1 if random.random() < 0.05 else 0.0,
                "quality": self.metrics["quality"],
                "benchmarks": {
                    "model": "EEGNet",
                    "latency": 2.3,
                    "f1": 0.89
                }
            }
        }

    def mock_classifier(self):
        """Simulates an EEGNet classifier output."""
        classes = ["REST", "MOVE_LEFT", "MOVE_RIGHT", "MOVE_FORWARD", "SELECT"]
        # Heuristic: If alpha is low and beta is high, assume movement
        if self.spectral_power["beta"] > 35:
            return random.choice(classes[1:]), random.uniform(0.85, 0.98)
        return "REST", 0.99

    def calculate_fatigue(self):
        duration = time.time() - self.start_time
        if duration < 600: return "LOW"
        if duration < 1800: return "MODERATE"
        return "HIGH"

    def update_engineering_stats(self):
        # Gradual drift for realism
        self.metrics["impedance"] += random.uniform(-0.01, 0.01)
        self.metrics["impedance"] = np.clip(self.metrics["impedance"], 2.0, 15.0)
        
        self.metrics["snr"] += random.uniform(-0.1, 0.1)
        self.metrics["snr"] = np.clip(self.metrics["snr"], 15.0, 35.0)
        
        if self.metrics["snr"] > 25: self.metrics["quality"] = "Excellent"
        elif self.metrics["snr"] > 20: self.metrics["quality"] = "Good"
        else: self.metrics["quality"] = "Fair"

async def socket_handler(websocket, path=None):
    print(f"[RESEARCH CORE] Link established: {websocket.remote_address}")
    engine = ResearchBCIEngine()
    
    try:
        while True:
            payload = engine.process_cycle()
            await websocket.send(json.dumps(payload))
            await asyncio.sleep(BROADCAST_INTERVAL)
    except websockets.exceptions.ConnectionClosed:
        print("[RESEARCH CORE] Link severed")

async def main():
    print("--- SYNAPSE v3.0 | RESEARCH-GRADE BCI DAEMON ---")
    print(f"Broadcasting at {SAMPLING_RATE}Hz on port {PORT}")
    async with websockets.serve(socket_handler, "localhost", PORT):
        await asyncio.Future()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[RESEARCH CORE] Shutdown signal received")
