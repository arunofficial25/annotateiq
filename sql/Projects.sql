USE Annotation


CREATE TABLE projects (
    project_id         INT PRIMARY KEY IDENTITY(1,1),
    project_name       NVARCHAR(150),
    client_industry    NVARCHAR(100),
    annotation_type    NVARCHAR(20)  CHECK (annotation_type IN ('text', 'image', 'video', 'audio', 'mixed')),
    ai_use_case        NVARCHAR(200),
    start_date         DATE,
    end_date           DATE,
    total_budget_inr   DECIMAL(12,2),
    status             NVARCHAR(20)  CHECK (status IN ('active', 'completed', 'paused'))
);

INSERT INTO projects (project_name, client_industry, annotation_type, ai_use_case, start_date, end_date, total_budget_inr, status)
VALUES
('WareBot Vision',        'Robotics',     'image', 'Object detection for warehouse robots',         '2023-01-10', '2023-06-30', 1200000.00, 'completed'),
('MediScan NLP',          'Healthcare',   'text',  'Medical report classification for diagnostics', '2023-03-01', '2023-09-30', 950000.00,  'completed'),
('RetailEye Analytics',   'Retail',       'video', 'Customer behavior tracking in stores',          '2023-05-15', '2024-01-15', 1500000.00, 'completed'),
('VoiceBot Hindi',        'Telecom',      'audio', 'Hindi speech recognition for IVR systems',     '2023-07-01', '2024-03-31', 800000.00,  'active'),
('AgriDrone Detect',      'Agriculture',  'image', 'Crop disease detection via drone imagery',     '2023-09-01', '2024-06-30', 1100000.00, 'active'),
('FactoryGuard Safety',   'Manufacturing','video', 'Worker safety violation detection in factories','2024-01-01', '2024-08-31', 1750000.00, 'active'),
('LegalDoc Classifier',   'Legal',        'text',  'Contract clause classification for law firms',  '2023-11-01', '2024-05-31', 700000.00,  'completed'),
('TrafficFlow AI',        'Smart Cities', 'video', 'Vehicle and pedestrian detection for signals',  '2024-02-01', NULL,         2000000.00, 'active'),
('FraudShield Banking',   'Finance',      'text',  'Transaction anomaly labeling for fraud AI',    '2024-03-01', NULL,         850000.00,  'active'),
('RoboArm Gesture',       'Robotics',     'image', 'Hand gesture recognition for robotic arms',    '2024-04-01', NULL,         1300000.00, 'active');