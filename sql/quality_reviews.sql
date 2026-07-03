USE Annotation


CREATE TABLE quality_reviews (
    review_id          INT PRIMARY KEY IDENTITY(1,1),
    annotation_id      INT,
    reviewer_id        INT,
    review_result      NVARCHAR(20)  CHECK (review_result IN ('pass', 'fail', 'needs_revision')),
    error_type         NVARCHAR(100),
    reviewed_at        DATETIME,
    feedback_notes     NVARCHAR(MAX),
    FOREIGN KEY (annotation_id) REFERENCES annotations(annotation_id),
    FOREIGN KEY (reviewer_id) REFERENCES annotators(annotator_id)
);

INSERT INTO quality_reviews (annotation_id, reviewer_id, review_result, error_type, reviewed_at, feedback_notes)
VALUES
(34, 3,  'pass',           NULL,             '2023-01-16 09:00:00', 'Accurate bounding boxes'),
(35, 6,  'pass',           NULL,             '2023-01-16 09:30:00', 'Good classification'),
(36, 3,  'fail',           'wrong_label',    '2023-01-16 10:00:00', 'Annotator confused all objects as boxes'),
(37, 12, 'pass',           NULL,             '2023-01-17 09:00:00', 'Clean output'),
(38, 15, 'pass',           NULL,             '2023-03-09 09:00:00', 'Correct sentiment'),
(39, 15, 'fail',           'wrong_label',    '2023-03-09 09:30:00', 'Misread negative tone as positive'),
(40, 12, 'pass',           NULL,             '2023-03-10 09:00:00', 'All entities correctly extracted'),
(41, 12, 'fail',           'missed_entity',  '2023-03-10 09:30:00', 'Dosage was missed in extraction'),
(42, 6,  'pass',           NULL,             '2023-05-21 09:00:00', 'Actions correctly tagged'),
(43, 18, 'pass',           NULL,             '2023-07-09 09:00:00', 'Transcription accurate'),
(44, 18, 'fail',           'boundary_error', '2023-07-09 09:30:00', 'Several words missed in transcription'),
(45, 4,  'pass',           NULL,             '2023-07-10 09:00:00', 'Intent correctly identified'),
(46, 7,  'pass',           NULL,             '2023-09-13 09:00:00', 'Polygon boundaries well drawn'),
(47, 20, 'pass',           NULL,             '2024-01-09 09:00:00', 'No violation correctly identified'),
(48, 20, 'needs_revision', 'boundary_error', '2024-01-09 09:30:00', 'Violation detected but region imprecise'),
(49, 15, 'pass',           NULL,             '2023-11-09 09:00:00', 'Clause type correctly identified'),
(50, 3,  'pass',           NULL,             '2024-02-09 09:00:00', 'Clean detection output'),
(51, 6,  'pass',           NULL,             '2024-03-09 09:00:00', 'Fraud correctly flagged'),
(52, 6,  'fail',           'wrong_label',    '2024-03-09 09:30:00', 'Legitimate transaction mislabeled as fraud'),
(53, 12, 'pass',           NULL,             '2024-04-09 09:00:00', 'All gestures correctly tagged');
