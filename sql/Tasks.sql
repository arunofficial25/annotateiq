USE Annotation


CREATE TABLE tasks (
    task_id            INT PRIMARY KEY IDENTITY(1,1),
    project_id         INT,
    task_type          NVARCHAR(100),
    complexity_level   NVARCHAR(20)  CHECK (complexity_level IN ('low', 'medium', 'high')),
    estimated_minutes  DECIMAL(5,2),
    instructions       NVARCHAR(MAX),
    created_at         DATETIME,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO tasks (project_id, task_type, complexity_level, estimated_minutes, instructions, created_at)
VALUES
(1, 'bounding_box',        'medium', 8.00,  'Draw boxes around all objects on conveyor belt',         '2023-01-12 09:00:00'),
(1, 'object_classification','low',   3.00,  'Classify each boxed object as box, pallet or equipment', '2023-01-12 09:00:00'),
(2, 'sentiment_labeling',  'low',    4.00,  'Label medical text as positive, negative or neutral',    '2023-03-05 10:00:00'),
(2, 'entity_extraction',   'high',   15.00, 'Extract drug names, dosages and conditions from reports','2023-03-05 10:00:00'),
(3, 'action_recognition',  'high',   20.00, 'Tag customer actions: browsing, picking, returning',     '2023-05-18 08:30:00'),
(4, 'audio_transcription', 'medium', 10.00, 'Transcribe Hindi speech to text accurately',            '2023-07-05 09:00:00'),
(4, 'intent_labeling',     'medium', 6.00,  'Label caller intent: complaint, query or request',      '2023-07-05 09:00:00'),
(5, 'polygon_annotation',  'high',   18.00, 'Draw polygons around diseased crop regions',            '2023-09-10 08:00:00'),
(6, 'safety_violation_tag','medium', 9.00,  'Tag frames where safety gear is missing',               '2024-01-05 09:00:00'),
(7, 'clause_classification','medium',7.00,  'Classify legal clauses by type and risk level',         '2023-11-05 10:00:00'),
(8, 'vehicle_detection',   'low',    4.00,  'Draw boxes around vehicles and pedestrians',            '2024-02-05 08:00:00'),
(9, 'fraud_labeling',      'high',   12.00, 'Label transactions as fraudulent or legitimate',        '2024-03-05 09:00:00'),
(10,'gesture_tagging',     'high',   16.00, 'Tag hand gestures: open, close, point, grab',           '2024-04-05 08:00:00');