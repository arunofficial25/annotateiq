USE Annotation


CREATE TABLE annotations (
    annotation_id      INT PRIMARY KEY IDENTITY(1,1),
    task_id            INT,
    annotator_id       INT,
    label_submitted    NVARCHAR(MAX),
    time_taken_minutes DECIMAL(6,2),
    submitted_at       DATETIME,
    status             NVARCHAR(20)  CHECK (status IN ('pending', 'approved', 'rejected', 'flagged')),
    confidence_score   DECIMAL(4,3),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id),
    FOREIGN KEY (annotator_id) REFERENCES annotators(annotator_id)
);

INSERT INTO annotations (task_id, annotator_id, label_submitted, time_taken_minutes, submitted_at, status, confidence_score)
VALUES
(1,  1,  'box,pallet,box',         9.5,  '2023-01-15 10:30:00', 'approved',  0.880),
(1,  3,  'box,pallet,equipment',   7.8,  '2023-01-15 11:00:00', 'approved',  0.920),
(1,  9,  'box,box,box',            14.2, '2023-01-15 14:00:00', 'rejected',  0.550),
(2,  2,  'box,pallet',             3.5,  '2023-01-16 09:30:00', 'approved',  0.870),
(3,  6,  'negative',               4.1,  '2023-03-08 10:00:00', 'approved',  0.910),
(3,  14, 'positive',               6.8,  '2023-03-08 11:30:00', 'rejected',  0.480),
(4,  12, 'aspirin,100mg,fever',    14.5, '2023-03-09 09:00:00', 'approved',  0.930),
(4,  8,  'aspirin,fever',          18.2, '2023-03-09 10:30:00', 'flagged',   0.720),
(5,  5,  'browsing,picking',       22.0, '2023-05-20 09:30:00', 'approved',  0.860),
(6,  13, 'transcribed text here',  11.0, '2023-07-08 10:00:00', 'approved',  0.900),
(6,  11, 'transcribed text here',  15.5, '2023-07-08 11:30:00', 'flagged',   0.650),
(7,  4,  'complaint',              6.2,  '2023-07-09 09:00:00', 'approved',  0.880),
(8,  7,  'polygon_coords_here',    19.5, '2023-09-12 08:30:00', 'approved',  0.890),
(9,  16, 'no_violation',           8.5,  '2024-01-08 09:00:00', 'approved',  0.870),
(9,  19, 'violation_detected',     11.2, '2024-01-08 10:30:00', 'flagged',   0.700),
(10, 15, 'liability_clause_high',  7.1,  '2023-11-08 10:00:00', 'approved',  0.940),
(11, 20, 'vehicle,pedestrian',     4.5,  '2024-02-08 09:00:00', 'approved',  0.900),
(12, 3,  'fraudulent',             13.0, '2024-03-08 09:30:00', 'approved',  0.920),
(12, 17, 'legitimate',             16.8, '2024-03-08 11:00:00', 'rejected',  0.510),
(13, 10, 'open,close,point',       17.5, '2024-04-08 09:00:00', 'approved',  0.880);

DELETE FROM annotations;