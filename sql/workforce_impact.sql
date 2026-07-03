USE Annotation

CREATE TABLE workforce_impact (
    impact_id              INT PRIMARY KEY IDENTITY(1,1),
    project_id             INT,
    jobs_currently_needed  INT,
    projected_jobs_5yr     INT,
    avg_worker_literacy    NVARCHAR(20)  CHECK (avg_worker_literacy IN ('low', 'medium', 'high')),
    retraining_feasibility NVARCHAR(20)  CHECK (retraining_feasibility IN ('low', 'medium', 'high')),
    economic_region        NVARCHAR(100),
    displacement_risk      NVARCHAR(20)  CHECK (displacement_risk IN ('low', 'medium', 'high', 'critical')),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

INSERT INTO workforce_impact (project_id, jobs_currently_needed, projected_jobs_5yr, avg_worker_literacy, retraining_feasibility, economic_region, displacement_risk)
VALUES
(1,  120, 30,  'low',    'low',    'North India',  'critical'),
(2,  80,  40,  'high',   'high',   'South India',  'medium'),
(3,  150, 50,  'medium', 'medium', 'West India',   'high'),
(4,  60,  35,  'medium', 'medium', 'North India',  'medium'),
(5,  200, 80,  'low',    'low',    'Central India','high'),
(6,  180, 40,  'low',    'low',    'West India',   'critical'),
(7,  50,  30,  'high',   'high',   'South India',  'low'),
(8,  100, 25,  'medium', 'low',    'North India',  'critical'),
(9,  70,  45,  'high',   'high',   'West India',   'medium'),
(10, 90,  20,  'low',    'low',    'North India',  'critical');