import asyncio
import json
import random
import time
import numpy as np
from scipy.signal import butter, lfilter, welch
import websockets

# --- BCI Core Parameters ---
SAMPLING_RATE = 250  # Hz
CHANNELS = 8
WINDOW_SIZE = 250    # 1.0 second rolling window
BROADCAST_INTERVAL = 1/30  # 30Hz Refresh Rate
PORT = 8765

class NeuralMatrixProcessor:
    def __init__(self):
        # 5th Order Butterworth: 0.5Hz - 45Hz Bandpass
        self.b, self.a = butter(5, [0.5, 45], btype='bandpass', fs=SAMPLING_RATE)
        self.buffer = np.zeros((CHANNELS, WINDOW_SIZE))
        self.classes = ["Rest", "Left Hand Grip", "Right Hand Grip", "Mental Math"]

    def process_frame(self, raw_chunk):
        """Applies real-time DSP and Spectral Analysis."""
        # 1. Update Rolling Buffer
        self.buffer = np.roll(self.buffer, -1, axis=1)
        self.buffer[:, -1] = raw_chunk
        
        # 2. Digital Filtering
        filtered = lfilter(self.b, self.a, self.buffer, axis=-1)
        
        # 3. Spectral Decomposition (FFT / Welch)
        freqs, psd = welch(filtered, fs=SAMPLING_RATE, nperseg=WINDOW_SIZE)
        
        bands = {
            "delta": float(np.mean(psd[:, (freqs >= 0.5) & (freqs < 4)]) * 100),
            "theta": float(np.mean(psd[:, (freqs >= 4) & (freqs < 8)]) * 100),
            "alpha": float(np.mean(psd[:, (freqs >= 8) & (freqs < 13)]) * 100),
            "beta": float(np.mean(psd[:, (freqs >= 13) & (freqs < 30)]) * 100)
        }
        
        # 4. Mock Intent Decoding (NeuroGator Pipeline)
        intent, confidence = self.decode_intent(bands)
        
        return filtered[:, -1], bands, intent, confidence

    def decode_intent(self, bands):
        """Simulates a deep convolutional EEGNet inference loop."""
        # Heuristic: High Beta + Low Alpha usually correlates to motor activation
        if bands['beta'] > 18 and random.random() > 0.7:
            choice = random.choice(self.classes[1:])
            return choice, random.uniform(0.85, 0.99)
        return "Rest", 1.0

async def neural_stream_generator():
    """Generates synthetic EEG data with realistic rhythmic components."""
    t = 0
    while True:
        # Layering: 1/f noise + 10Hz Alpha + 22Hz Beta
        noise = np.random.normal(0, 4, CHANNELS)
        alpha = 12 * np.sin(2 * np.pi * 10 * t)
        beta = 6 * np.sin(2 * np.pi * 22 * t)
        
        yield noise + alpha + beta
        t += 1/SAMPLING_RATE
        await asyncio.sleep(1/SAMPLING_RATE)

async def broadast_server(websocket, path=None):
    """Main WebSocket loop broadcasting compressed telemetry packets."""
    print(f"[BCI_CORE] Connection Handshake: {websocket.remote_address}")
    processor = NeuralMatrixProcessor()
    
    try:
        async for raw_frame in neural_stream_generator():
            # Run the DSP/ML Pipeline
            voltages, spectral, intent, confidence = processor.process_frame(raw_frame)
            
            # Construct Compressed JSON Payload
            payload = {
                "ts": time.time(),
                "raw_voltages": voltages.tolist(),
                "spectral": spectral,
                "intent": {
                    "prediction": intent,
                    "confidence": confidence
                },
                "status": "NOMINAL"
            }
            
            await websocket.send(json.dumps(payload))
            await asyncio.sleep(BROADCAST_INTERVAL)
            
    except websockets.exceptions.ConnectionClosed:
        print(f"[BCI_CORE] Connection Severed")

async def main():
    print(f"--- SYNAPSE | NEURAL ML DAEMON v2.6.0 ---")
    print(f"Targeting WebSocket Broadcast on ws://localhost:{PORT}")
    async with websockets.serve(broadast_server, "localhost", PORT):
        await asyncio.Future()  # Run forever

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n[BCI_CORE] System Shutdown Initiated.")
