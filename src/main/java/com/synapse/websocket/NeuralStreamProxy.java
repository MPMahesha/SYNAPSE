package com.synapse.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.net.URI;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@ServerEndpoint("/neuralstream")
public class NeuralStreamProxy {

    private static final Set<Session> browserSessions = Collections.synchronizedSet(new HashSet<>());
    private static Session pythonSession = null;
    private static final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private static boolean pythonConnected = false;

    static {
        // Background task to ensure Python connection or send fallback mock data
        scheduler.scheduleAtFixedRate(NeuralStreamProxy::checkAndHealConnection, 0, 5, TimeUnit.SECONDS);
    }

    @OnOpen
    public void onOpen(Session session) {
        browserSessions.add(session);
        System.out.println("Browser Session Opened: " + session.getId());
    }

    @OnClose
    public void onClose(Session session) {
        browserSessions.remove(session);
        System.out.println("Browser Session Closed: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        // Forward control commands to Python
        if (pythonConnected && pythonSession != null && pythonSession.isOpen()) {
            pythonSession.getAsyncRemote().sendText(message);
        }
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket Proxy Error on session " + (session != null ? session.getId() : "null") + ": " + throwable.getMessage());
    }

    private static void checkAndHealConnection() {
        if (!pythonConnected) {
            try {
                WebSocketContainer container = ContainerProvider.getWebSocketContainer();
                container.connectToServer(new Endpoint() {
                    @Override
                    public void onOpen(Session session, EndpointConfig config) {
                        pythonSession = session;
                        pythonConnected = true;
                        System.out.println("Linked to Python Daemon on port 8765");
                        session.addMessageHandler(String.class, NeuralStreamProxy::broadcastToBrowsers);
                    }

                    @Override
                    public void onClose(Session session, CloseReason closeReason) {
                        pythonConnected = false;
                        System.out.println("Python Daemon Link Severed: " + closeReason);
                    }

                    @Override
                    public void onError(Session session, Throwable thr) {
                        pythonConnected = false;
                        System.err.println("Python Link Error: " + thr.getMessage());
                    }
                }, ClientEndpointConfig.Builder.create().build(), URI.create("ws://localhost:8765"));
            } catch (Exception e) {
                pythonConnected = false;
                broadcastFallback();
            }
        }
    }

    private static void broadcastToBrowsers(String message) {
        synchronized (browserSessions) {
            browserSessions.forEach(s -> {
                if (s.isOpen()) s.getAsyncRemote().sendText(message);
            });
        }
    }

    private static void broadcastFallback() {
        // If Python is down, send baseline mock to keep frontend alive
        String mock = "{\"telemetry_header\":{\"timestamp\":" + System.currentTimeMillis() + ",\"frame_id\":-1},\"signal_matrix\":{\"ch1\":0.0,\"ch2\":0.0},\"electrode_matrix_deltas\":[],\"decoder_analytics\":{\"predicted_intent\":\"STANDBY\",\"confidence_score\":0.0,\"inference_latency_ms\":0.0}}";
        broadcastToBrowsers(mock);
    }
}
