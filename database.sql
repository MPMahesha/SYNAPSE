-- NeuroSyncBCI Database Schema & Seed Data
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

-- 2. Users Table
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
    date_of_birth DATE,
    clinical_status ENUM('PRE_OP', 'POST_OP', 'MAINTENANCE') DEFAULT 'PRE_OP'
);

-- 4. Pre-Op Screenings
CREATE TABLE pre_op_screenings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    moca_score INT, -- Montreal Cognitive Assessment (0-30)
    alsfrs_score INT, -- ALS Functional Rating Scale (0-48)
    screening_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- 5. Post-Op Hardware Metrics
CREATE TABLE hardware_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    snr DOUBLE, -- Signal-to-Noise Ratio (dB)
    impedance DOUBLE, -- kOhms
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- 6. Post-Op Decoding Metrics
CREATE TABLE decoding_metrics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    itr DOUBLE, -- Information Transfer Rate (bits/min)
    accuracy DOUBLE, -- %
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id)
);

-- IDEMPOTENT SEED DATA --

-- System Keys
INSERT INTO system_keys (key_value, role) VALUES 
('NS-CLINIC-2026-X79', 'CLINICIAN'),
('NS-ENG-2026-B42', 'ENGINEER'),
('NS-DEV-999', 'ENGINEER')
ON DUPLICATE KEY UPDATE role=VALUES(role);

-- Initial Administrative Root Identities
INSERT INTO users (email, password, role) VALUES 
('mahesha@neurosync.com', 'Admin123!', 'CLINICIAN'),
('mahesha.eng@neurosync.com', 'Admin123!', 'ENGINEER')
ON DUPLICATE KEY UPDATE password=VALUES(password), role=VALUES(role);

-- Patients
INSERT INTO patients (id, full_name, date_of_birth, clinical_status) VALUES 
(1, 'Elena Vance', '1985-05-12', 'PRE_OP'),
(2, 'Gordon Freeman', '1973-11-20', 'POST_OP'),
(3, 'Alyx Vance', '1998-03-04', 'POST_OP')
ON DUPLICATE KEY UPDATE full_name=VALUES(full_name), date_of_birth=VALUES(date_of_birth), clinical_status=VALUES(clinical_status);

-- Screenings
INSERT INTO pre_op_screenings (patient_id, moca_score, alsfrs_score) VALUES 
(1, 28, 42)
ON DUPLICATE KEY UPDATE moca_score=VALUES(moca_score), alsfrs_score=VALUES(alsfrs_score);

-- Historical Hardware Metrics (Gordon Freeman - Post Op)
INSERT INTO hardware_metrics (patient_id, snr, impedance, recorded_at) VALUES 
(2, 12.5, 45.2, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 11.8, 48.5, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 10.2, 52.1, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 9.5, 55.8, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 9.1, 58.2, NOW());

-- Historical Decoding Metrics (Gordon Freeman)
INSERT INTO decoding_metrics (patient_id, itr, accuracy, recorded_at) VALUES 
(2, 15.2, 88.5, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(2, 18.5, 90.1, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(2, 22.1, 92.4, DATE_SUB(NOW(), INTERVAL 2 DAY)),
(2, 25.8, 94.8, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 28.5, 96.2, NOW());
