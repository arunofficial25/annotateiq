USE Annotation

CREATE TABLE automation_risk (
    risk_id                    INT PRIMARY KEY IDENTITY(1,1),
    task_id                    INT,
    repetitiveness_score       DECIMAL(4,3),
    complexity_score           DECIMAL(4,3),
    rule_based_score           DECIMAL(4,3),
    automation_risk_index      DECIMAL(4,3),
    estimated_replacement_years INT,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id)
);

INSERT INTO automation_risk (task_id, repetitiveness_score, complexity_score, rule_based_score, automation_risk_index, estimated_replacement_years)
VALUES
(1,  0.850, 0.400, 0.780, 0.820, 2),
(2,  0.920, 0.200, 0.900, 0.910, 1),
(3,  0.800, 0.300, 0.850, 0.850, 2),
(4,  0.500, 0.800, 0.400, 0.450, 6),
(5,  0.600, 0.750, 0.500, 0.520, 5),
(6,  0.700, 0.500, 0.650, 0.680, 3),
(7,  0.750, 0.450, 0.700, 0.720, 3),
(8,  0.550, 0.820, 0.430, 0.470, 7),
(9,  0.780, 0.480, 0.720, 0.740, 3),
(10, 0.650, 0.600, 0.580, 0.610, 4),
(11, 0.880, 0.250, 0.850, 0.870, 1),
(12, 0.580, 0.780, 0.450, 0.490, 6),
(13, 0.480, 0.850, 0.380, 0.420, 8);