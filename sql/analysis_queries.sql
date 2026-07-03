USE Annotation


--Query 1 — Total tasks completed and avg time per annotator

SELECT 
    a.annotator_id,
    a.name,
    a.region,
    a.education_level,
    a.employment_type,
    COUNT(an.annotation_id)            AS total_annotations,
    ROUND(AVG(an.time_taken_minutes), 2) AS avg_time_per_task,
    ROUND(SUM(an.time_taken_minutes), 2) AS total_minutes_worked
FROM annotators a
JOIN annotations an ON a.annotator_id = an.annotator_id
GROUP BY 
    a.annotator_id, a.name, a.region, 
    a.education_level, a.employment_type
ORDER BY total_annotations DESC;


--Query 2 — Approval rate per annotator

SELECT
    a.name,
    a.education_level,
    COUNT(an.annotation_id)                                        AS total_submitted,
    SUM(CASE WHEN an.status = 'approved' THEN 1 ELSE 0 END)       AS approved,
    SUM(CASE WHEN an.status = 'rejected' THEN 1 ELSE 0 END)       AS rejected,
    SUM(CASE WHEN an.status = 'flagged'  THEN 1 ELSE 0 END)       AS flagged,
    ROUND(
        100.0 * SUM(CASE WHEN an.status = 'approved' THEN 1 ELSE 0 END) 
        / COUNT(an.annotation_id), 2
    )                                                               AS approval_rate_pct
FROM annotators a
JOIN annotations an ON a.annotator_id = an.annotator_id
GROUP BY a.name, a.education_level
ORDER BY approval_rate_pct DESC;

--Query 3 — Productivity vs accuracy (speed vs quality tradeoff)

SELECT
    a.name,
    ROUND(AVG(an.time_taken_minutes), 2)    AS avg_time_per_task,
    ROUND(AVG(an.confidence_score), 3)      AS avg_confidence,
    ROUND(
        100.0 * SUM(CASE WHEN an.status = 'approved' THEN 1 ELSE 0 END)
        / COUNT(an.annotation_id), 2
    )                                        AS approval_rate_pct,
    CASE 
        WHEN AVG(an.time_taken_minutes) < 8 
         AND AVG(an.confidence_score)  > 0.85 THEN 'High Performer'
        WHEN AVG(an.time_taken_minutes) > 14 
         AND AVG(an.confidence_score)  < 0.70 THEN 'Needs Support'
        ELSE 'Average'
    END                                      AS performance_tag
FROM annotators a
JOIN annotations an ON a.annotator_id = an.annotator_id
GROUP BY a.name
ORDER BY avg_confidence DESC;

--Label Quality Analysis

--Query 4 — Quality review pass/fail rate by task type

SELECT
    t.task_type,
    t.complexity_level,
    COUNT(qr.review_id)                                             AS total_reviews,
    SUM(CASE WHEN qr.review_result = 'pass' THEN 1 ELSE 0 END)     AS passed,
    SUM(CASE WHEN qr.review_result = 'fail' THEN 1 ELSE 0 END)     AS failed,
    ROUND(
        100.0 * SUM(CASE WHEN qr.review_result = 'pass' THEN 1 ELSE 0 END)
        / COUNT(qr.review_id), 2
    )                                                                AS pass_rate_pct
FROM tasks t
JOIN annotations an  ON t.task_id       = an.task_id
JOIN quality_reviews qr ON an.annotation_id = qr.annotation_id
GROUP BY t.task_type, t.complexity_level
ORDER BY pass_rate_pct ASC;

--Query 5 — Most common error types

SELECT
    error_type,
    COUNT(*)                             AS total_occurrences,
    ROUND(
        100.0 * COUNT(*) 
        / SUM(COUNT(*)) OVER(), 2
    )                                    AS pct_of_all_errors
FROM quality_reviews
WHERE error_type IS NOT NULL
GROUP BY error_type
ORDER BY total_occurrences DESC;

--Query 6 — Annotators with highest rejection + error rate (risk flagging)

SELECT
    a.name,
    a.education_level,
    a.region,
    COUNT(qr.review_id)                                              AS total_reviewed,
    SUM(CASE WHEN qr.review_result = 'fail' THEN 1 ELSE 0 END)      AS total_failures,
    ROUND(
        100.0 * SUM(CASE WHEN qr.review_result = 'fail' THEN 1 ELSE 0 END)
        / COUNT(qr.review_id), 2
    )                                                                 AS failure_rate_pct
FROM annotators a
JOIN annotations  an ON a.annotator_id  = an.annotator_id
JOIN quality_reviews qr ON an.annotation_id = qr.annotation_id
GROUP BY a.name, a.education_level, a.region
HAVING COUNT(qr.review_id) > 0
ORDER BY failure_rate_pct DESC;

--Cost & Efficiency

--Query 7 — Cost per annotation per project

SELECT
    p.project_name,
    p.annotation_type,
    p.total_budget_inr,
    COUNT(an.annotation_id)                                           AS total_annotations,
    ROUND(
        p.total_budget_inr / NULLIF(COUNT(an.annotation_id), 0), 2
    )                                                                  AS cost_per_annotation_inr
FROM projects p
JOIN tasks     t  ON p.project_id    = t.project_id
JOIN annotations an ON t.task_id    = an.task_id
GROUP BY p.project_name, p.annotation_type, p.total_budget_inr
ORDER BY cost_per_annotation_inr DESC;

--Query 8 — Cost of poor quality (rejected + failed annotations)

SELECT
    p.project_name,
    COUNT(an.annotation_id)                                            AS total_annotations,
    SUM(CASE WHEN an.status IN ('rejected','flagged') THEN 1 ELSE 0 END) AS poor_quality_count,
    ROUND(
        100.0 * SUM(CASE WHEN an.status IN ('rejected','flagged') THEN 1 ELSE 0 END)
        / COUNT(an.annotation_id), 2
    )                                                                   AS poor_quality_pct,
    ROUND(
        p.total_budget_inr * 
        (1.0 * SUM(CASE WHEN an.status IN ('rejected','flagged') THEN 1 ELSE 0 END)
        / NULLIF(COUNT(an.annotation_id), 0)), 2
    )                                                                   AS estimated_wasted_budget_inr
FROM projects p
JOIN tasks       t  ON p.project_id    = t.project_id
JOIN annotations an ON t.task_id       = an.task_id
GROUP BY p.project_name, p.total_budget_inr
ORDER BY estimated_wasted_budget_inr DESC;

--Automation Risk

--Query 9 — Most at-risk tasks for automation

SELECT
    t.task_type,
    t.complexity_level,
    p.client_industry,
    p.ai_use_case,
    ar.automation_risk_index,
    ar.estimated_replacement_years,
    CASE
        WHEN ar.automation_risk_index >= 0.80 THEN 'Critical Risk'
        WHEN ar.automation_risk_index >= 0.60 THEN 'High Risk'
        WHEN ar.automation_risk_index >= 0.40 THEN 'Medium Risk'
        ELSE                                       'Low Risk'
    END                               AS risk_category
FROM tasks t
JOIN automation_risk ar ON t.task_id    = ar.task_id
JOIN projects        p  ON t.project_id = p.project_id
ORDER BY ar.automation_risk_index DESC;

--Social & Workforce Impact

--Query 10 — Jobs at risk by region and literacy level

SELECT
    wi.economic_region,
    wi.avg_worker_literacy,
    wi.retraining_feasibility,
    wi.displacement_risk,
    SUM(wi.jobs_currently_needed)     AS current_jobs,
    SUM(wi.projected_jobs_5yr)        AS projected_jobs,
    SUM(wi.jobs_currently_needed) 
    - SUM(wi.projected_jobs_5yr)      AS jobs_at_risk,
    ROUND(
        100.0 * (SUM(wi.jobs_currently_needed) - SUM(wi.projected_jobs_5yr))
        / NULLIF(SUM(wi.jobs_currently_needed), 0), 2
    )                                  AS displacement_pct
FROM workforce_impact wi
GROUP BY 
    wi.economic_region, 
    wi.avg_worker_literacy,
    wi.retraining_feasibility,
    wi.displacement_risk
ORDER BY displacement_pct DESC;

--Query 11 — The full picture: who trains the AI that replaces them

SELECT
    a.name                              AS annotator_name,
    a.education_level,
    a.region,
    a.employment_type,
    t.task_type,
    ar.automation_risk_index,
    ar.estimated_replacement_years,
    CASE
        WHEN ar.automation_risk_index >= 0.80 
         AND a.education_level IN ('illiterate','primary') THEN 'CRITICAL — No safety net'
        WHEN ar.automation_risk_index >= 0.60 
         AND a.education_level IN ('illiterate','primary') THEN 'HIGH — Vulnerable'
        WHEN ar.automation_risk_index >= 0.60 
         AND a.education_level IN ('secondary','graduate') THEN 'MEDIUM — Can retrain'
        ELSE                                                     'LOW — Manageable'
    END                                 AS human_impact_rating
FROM annotators    a
JOIN annotations   an ON a.annotator_id = an.annotator_id
JOIN tasks          t ON an.task_id      = t.task_id
JOIN automation_risk ar ON t.task_id    = ar.task_id
ORDER BY ar.automation_risk_index DESC;

--END