import asyncio
import websockets
import json
import time
import numpy as np
from scipy import signal

# --- DSP FILTERING ENGINE ---
def apply_dsp_filters(raw_data_chunk, filter_state=True):
    try:
        if not filter_state:
            return raw_data_chunk + np.random.normal(0, 50, raw_data_chunk.shape)
        
        fs = 250
        nyq = 0.5 * fs
        low = 0.1 / nyq
        high = 100 / nyq
        b, a = signal.butter(4, [low, high], btype='band')
        filtered = signal.lfilter(b, a, raw_data_chunk, axis=-1)
        
        for notch_freq in [50, 60]:
            w0 = notch_freq / nyq
            b, a = signal.iirnotch(w0, 30)
            filtered = signal.lfilter(b, a, filtered, axis=-1)
        return filtered
    except Exception as e:
        print(f"DSP Error: {e}")
        return raw_data_chunk

# Global state
FILTER_STATE = True

async def neural_broadcast(websocket):
    print(f"Connection established with {websocket.remote_address}")
    frame_id = 0
    try:
        while True:
            start_time = time.perf_counter()
            
            # Simulated EEG 4-ch data
            raw_chunk = np.random.normal(0, 10, (4, 1))
            processed = apply_dsp_filters(raw_chunk, FILTER_STATE)
            
            # Simulated Inference
            predicted_intent = np.random.choice(["RESTING", "MOVE_LEFT", "MOVE_RIGHT"])
            confidence = float(np.random.uniform(0.85, 0.99))
            latency = (time.perf_counter() - start_time) * 1000
            
            payload = {
                "telemetry_header": {"timestamp": int(time.time() * 1000), "frame_id": frame_id},
                "signal_matrix": {
                    "ch1": float(processed[0, 0]),
                    "ch2": float(processed[1, 0]),
                    "ch3": float(processed[2, 0]),
                    "ch4": float(processed[3, 0])
                },
                "electrode_matrix_deltas": list(np.random.uniform(-1, 1, 144)),
                "decoder_analytics": {
                    "predicted_intent": predicted_intent,
                    "confidence_score": round(confidence, 4),
                    "inference_latency_ms": round(latency, 2)
                }
            }
            
            await websocket.send(json.dumps(payload))
            frame_id += 1
            await asyncio.sleep(0.04) # 25Hz
    except websockets.exceptions.ConnectionClosed:
        print("Connection closed by client.")

async def control_handler(websocket):
    global FILTER_STATE
    async for message in websocket:
        try:
            data = json.loads(message)
            if data.get("command") == "TOGGLE_DSP":
                FILTER_STATE = data.get("state", True)
                print(f"CONTROL -> DSP Filter: {FILTER_STATE}")
        except Exception as e:
            print(f"Control error: {e}")

async def main():
    print("Initializing Fault-Tolerant Neural Daemon...")
    try:
        async with websockets.serve(neural_broadcast, "localhost", 8765):
            print("Python Neural Core active on ws://localhost:8765")
            await asyncio.Future() # Run forever
    except Exception as e:
        print(f"Critical Daemon Error: {e}")

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Daemon terminated by user.")
