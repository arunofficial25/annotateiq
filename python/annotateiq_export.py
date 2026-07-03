import pyodbc
import pandas as pd
import urllib
from sqlalchemy import create_engine
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
TABLEAU  = os.path.join(BASE_DIR, 'tableau_data')
os.makedirs(TABLEAU, exist_ok=True)

from config import SERVER, DATABASE
import urllib
from sqlalchemy import create_engine

params = urllib.parse.quote_plus(
    f"DRIVER={{SQL Server}};"
    f"SERVER={SERVER};"
    f"DATABASE={DATABASE};"
    "Trusted_Connection=yes;"
)
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")
conn   = engine.connect()

# Export 1 — Annotator performance
pd.read_sql("""
    SELECT
        a.name, a.age, a.education_level, a.region,
        a.employment_type, a.hourly_rate_inr,
        COUNT(an.annotation_id)                              AS total_annotations,
        ROUND(AVG(an.time_taken_minutes), 2)                 AS avg_time_per_task,
        ROUND(AVG(an.confidence_score), 3)                   AS avg_confidence,
        ROUND(100.0 * SUM(CASE WHEN an.status = 'approved'
              THEN 1 ELSE 0 END)
              / NULLIF(COUNT(an.annotation_id),0), 2)        AS approval_rate_pct
    FROM annotators a
    JOIN annotations an ON a.annotator_id = an.annotator_id
    GROUP BY a.name, a.age, a.education_level, a.region,
             a.employment_type, a.hourly_rate_inr
""", conn).to_csv(os.path.join(TABLEAU, '1_annotator_performance.csv'), index=False)

# Export 2 — Project cost & quality
pd.read_sql("""
    SELECT
        p.project_name, p.annotation_type, p.client_industry,
        p.total_budget_inr,
        COUNT(an.annotation_id)                              AS total_annotations,
        ROUND(p.total_budget_inr /
              NULLIF(COUNT(an.annotation_id),0), 2)          AS cost_per_annotation,
        SUM(CASE WHEN an.status IN
            ('rejected','flagged') THEN 1 ELSE 0 END)        AS poor_quality_count,
        ROUND(100.0 * SUM(CASE WHEN an.status IN
            ('rejected','flagged') THEN 1 ELSE 0 END)
              / NULLIF(COUNT(an.annotation_id),0), 2)         AS poor_quality_pct,
        ROUND(p.total_budget_inr * (1.0 * SUM(CASE WHEN
            an.status IN ('rejected','flagged') THEN 1 ELSE 0 END)
              / NULLIF(COUNT(an.annotation_id),0)), 2)        AS wasted_budget_inr
    FROM projects p
    JOIN tasks       t  ON p.project_id = t.project_id
    JOIN annotations an ON t.task_id    = an.task_id
    GROUP BY p.project_name, p.annotation_type,
             p.client_industry, p.total_budget_inr
""", conn).to_csv(os.path.join(TABLEAU, '2_project_cost_quality.csv'), index=False)

# Export 3 — Automation risk
pd.read_sql("""
    SELECT
        t.task_type, t.complexity_level,
        p.client_industry, p.annotation_type,
        ar.repetitiveness_score, ar.complexity_score,
        ar.rule_based_score, ar.automation_risk_index,
        ar.estimated_replacement_years
    FROM tasks t
    JOIN automation_risk ar ON t.task_id    = ar.task_id
    JOIN projects        p  ON t.project_id = p.project_id
""", conn).to_csv(os.path.join(TABLEAU, '3_automation_risk.csv'), index=False)

# Export 4 — Workforce impact
pd.read_sql("""
    SELECT
        wi.economic_region, wi.avg_worker_literacy,
        wi.retraining_feasibility, wi.displacement_risk,
        wi.jobs_currently_needed, wi.projected_jobs_5yr,
        (wi.jobs_currently_needed - wi.projected_jobs_5yr) AS jobs_at_risk,
        p.project_name, p.client_industry
    FROM workforce_impact wi
    JOIN projects p ON wi.project_id = p.project_id
""", conn).to_csv(os.path.join(TABLEAU, '4_workforce_impact.csv'), index=False)

# Export 5 — Error analysis
pd.read_sql("""
    SELECT
        a.name, a.education_level, a.region,
        t.task_type, t.complexity_level,
        qr.review_result, qr.error_type,
        an.status, an.confidence_score,
        an.time_taken_minutes
    FROM quality_reviews  qr
    JOIN annotations  an ON qr.annotation_id = an.annotation_id
    JOIN annotators    a ON an.annotator_id  = a.annotator_id
    JOIN tasks         t ON an.task_id       = t.task_id
""", conn).to_csv(os.path.join(TABLEAU, '5_error_analysis.csv'), index=False)

conn.close()
print("✅ All 5 CSV files exported to tableau_data folder")