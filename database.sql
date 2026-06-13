-- NEUROSYNC BCI Unified Database Schema
DROP DATABASE IF EXISTS neurosync_bci_db;
CREATE DATABASE neurosync_bci_db;
USE neurosync_bci_db;

-- 1. System Registration Keys
CREATE TABLE system_keys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    key_value VARCHAR(50) UNIQUE NOT NULL,
    role ENUM('CLINICIAN', 'ENGINEER') NOT NULL,
    is_used BOOLEAN DEFAULT FALSE
);

-- 2. Users Table (Aligned with exact constraints: id, email, password, role)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('CLINICIAN', 'ENGINEER') NOT NULL,
    otp VARCHAR(10),
    otp_expiry TIMESTAMP NULL
);

-- 3. Patients Table
CREATE TABLE patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    clinical_status ENUM('PRE_OP', 'POST_OP', 'MAINTENANCE') DEFAULT 'PRE_OP'
);

-- 4. Metrics
CREATE TABLE hardware_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    snr DOUBLE,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- SEED DATA --
INSERT INTO system_keys (key_value, role) VALUES 
('NS-CLINIC-2026-X79', 'CLINICIAN'),
('NS-ENG-2026-B42', 'ENGINEER');

-- Seed Credentials (Passwords are updated to secure strings)
INSERT INTO users (email, password, role) VALUES 
('mahesha@neurosync.com', 'N3uroSync_Mahesha_2026!', 'CLINICIAN'),
('engineer@mahesha.com', 'BCI_Telemetry_Core_2026!', 'ENGINEER')
ON DUPLICATE KEY UPDATE password=VALUES(password);

-- Initial Patients
INSERT INTO patients (id, full_name, clinical_status) VALUES 
(1, 'Elena Vance', 'PRE_OP'),
(2, 'Gordon Freeman', 'POST_OP');
