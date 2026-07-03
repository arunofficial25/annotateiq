import pyodbc
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# ── Path setup ──────────────────────────────────────────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT   = os.path.join(BASE_DIR, 'outputs')
os.makedirs(OUTPUT, exist_ok=True)

# ── DB Connection ────────────────────────────────────────────
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

print("✅ Connected to Annotation database")

# ── Load data from SQL ───────────────────────────────────────
annotators_df = pd.read_sql("""
    SELECT 
        a.annotator_id, a.name, a.age, a.education_level,
        a.region, a.employment_type, a.hourly_rate_inr,
        COUNT(an.annotation_id)                          AS total_annotations,
        ROUND(AVG(an.time_taken_minutes), 2)             AS avg_time_per_task,
        ROUND(AVG(an.confidence_score), 3)               AS avg_confidence,
        ROUND(100.0 * SUM(CASE WHEN an.status = 'approved' THEN 1 ELSE 0 END)
              / COUNT(an.annotation_id), 2)              AS approval_rate_pct
    FROM annotators a
    JOIN annotations an ON a.annotator_id = an.annotator_id
    GROUP BY 
        a.annotator_id, a.name, a.age, a.education_level,
        a.region, a.employment_type, a.hourly_rate_inr
""", conn)

quality_df = pd.read_sql("""
    SELECT
        t.task_type, t.complexity_level,
        p.client_industry, p.annotation_type,
        an.status, an.confidence_score, an.time_taken_minutes,
        qr.review_result, qr.error_type,
        ar.automation_risk_index, ar.estimated_replacement_years,
        a.education_level, a.region
    FROM annotations an
    JOIN tasks            t  ON an.task_id       = t.task_id
    JOIN projects         p  ON t.project_id     = p.project_id
    JOIN quality_reviews  qr ON an.annotation_id = qr.annotation_id
    JOIN automation_risk  ar ON t.task_id        = ar.task_id
    JOIN annotators       a  ON an.annotator_id  = a.annotator_id
""", conn)

workforce_df = pd.read_sql("""
    SELECT
        wi.economic_region, wi.avg_worker_literacy,
        wi.retraining_feasibility, wi.displacement_risk,
        wi.jobs_currently_needed, wi.projected_jobs_5yr,
        (wi.jobs_currently_needed - wi.projected_jobs_5yr) AS jobs_at_risk,
        p.project_name, p.client_industry, p.annotation_type
    FROM workforce_impact wi
    JOIN projects p ON wi.project_id = p.project_id
""", conn)

print("✅ Data loaded successfully")
print(f"   Annotators : {len(annotators_df)} rows")
print(f"   Quality    : {len(quality_df)} rows")
print(f"   Workforce  : {len(workforce_df)} rows")

# ─── EDA Visualizations ───────────────────────────────────────
sns.set_style("darkgrid")
PALETTE = "coolwarm"

# ── Chart 1: Approval Rate by Education Level ────────────────
fig, ax = plt.subplots(figsize=(8, 5))
edu_order = ['illiterate', 'primary', 'secondary', 'graduate']
sns.barplot(
    data=annotators_df,
    x='education_level', y='approval_rate_pct',
    order=edu_order, palette=PALETTE, ax=ax
)
ax.set_title('Approval Rate by Education Level', fontsize=14, fontweight='bold')
ax.set_xlabel('Education Level')
ax.set_ylabel('Approval Rate (%)')
for bar in ax.patches:
    ax.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 0.5,
        f'{bar.get_height():.1f}%',
        ha='center', fontsize=10
    )
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart1_approval_by_education.png'), dpi=150)
plt.show()

# ── Chart 2: Avg Time vs Confidence Score (Scatter) ──────────
fig, ax = plt.subplots(figsize=(8, 5))
scatter = ax.scatter(
    annotators_df['avg_time_per_task'],
    annotators_df['avg_confidence'],
    c=annotators_df['approval_rate_pct'],
    cmap='coolwarm', s=100, edgecolors='black', linewidth=0.5
)
plt.colorbar(scatter, label='Approval Rate (%)')
for _, row in annotators_df.iterrows():
    ax.annotate(row['name'].split()[0],
                (row['avg_time_per_task'], row['avg_confidence']),
                fontsize=7, alpha=0.8)
ax.set_title('Speed vs Accuracy per Annotator', fontsize=14, fontweight='bold')
ax.set_xlabel('Avg Time per Task (mins)')
ax.set_ylabel('Avg Confidence Score')
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart2_speed_vs_accuracy.png'), dpi=150)
plt.show()

# ── Chart 3: Error Type Distribution ─────────────────────────
error_counts = (
    quality_df[quality_df['error_type'].notna()]
    ['error_type'].value_counts()
)
fig, ax = plt.subplots(figsize=(7, 5))
sns.barplot(x=error_counts.values, y=error_counts.index, palette='Reds_r', ax=ax)
ax.set_title('Most Common Annotation Error Types', fontsize=14, fontweight='bold')
ax.set_xlabel('Count')
ax.set_ylabel('Error Type')
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart3_error_types.png'), dpi=150)
plt.show()

# ── Chart 4: Automation Risk by Task Type ────────────────────
risk_by_task = (
    quality_df.groupby('task_type')['automation_risk_index']
    .mean().sort_values(ascending=False).reset_index()
)
fig, ax = plt.subplots(figsize=(10, 5))
sns.barplot(
    data=risk_by_task,
    x='automation_risk_index', y='task_type',
    palette='YlOrRd', ax=ax
)
ax.set_title('Automation Risk Index by Task Type', fontsize=14, fontweight='bold')
ax.set_xlabel('Automation Risk Index (0–1)')
ax.set_ylabel('Task Type')
ax.axvline(x=0.75, color='red', linestyle='--', label='Critical Threshold')
ax.legend()
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart4_automation_risk.png'), dpi=150)
plt.show()

# ── Chart 5: Jobs at Risk by Region ──────────────────────────
region_impact = (
    workforce_df.groupby('economic_region')
    [['jobs_currently_needed', 'projected_jobs_5yr', 'jobs_at_risk']]
    .sum().reset_index()
)
fig, ax = plt.subplots(figsize=(9, 5))
x = range(len(region_impact))
width = 0.35
ax.bar([i - width/2 for i in x], region_impact['jobs_currently_needed'],
       width, label='Current Jobs', color='steelblue')
ax.bar([i + width/2 for i in x], region_impact['projected_jobs_5yr'],
       width, label='Projected (5yr)', color='tomato')
ax.set_xticks(list(x))
ax.set_xticklabels(region_impact['economic_region'], rotation=15)
ax.set_title('Current vs Projected Jobs by Region', fontsize=14, fontweight='bold')
ax.set_ylabel('Number of Jobs')
ax.legend()
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart5_jobs_by_region.png'), dpi=150)
plt.show()

print("✅ All 5 charts saved to outputs folder")

# ML Model: Automation Risk Predictor

from sklearn.ensemble        import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics         import classification_report, confusion_matrix
from sklearn.preprocessing   import LabelEncoder

# ── Load ML data ─────────────────────────────────────────────
ml_df = pd.read_sql("""
    SELECT
        ar.repetitiveness_score,
        ar.complexity_score,
        ar.rule_based_score,
        ar.automation_risk_index,
        t.complexity_level,
        ar.estimated_replacement_years,
        CASE
            WHEN ar.automation_risk_index >= 0.80 THEN 'Critical'
            WHEN ar.automation_risk_index >= 0.60 THEN 'High'
            WHEN ar.automation_risk_index >= 0.40 THEN 'Medium'
            ELSE                                       'Low'
        END AS risk_category
    FROM automation_risk ar
    JOIN tasks t ON ar.task_id = t.task_id
""", conn)

# ── Encode categorical ────────────────────────────────────────
le = LabelEncoder()
ml_df['complexity_encoded'] = le.fit_transform(ml_df['complexity_level'])

features = [
    'repetitiveness_score', 'complexity_score',
    'rule_based_score', 'complexity_encoded',
    'estimated_replacement_years'
]
X = ml_df[features]
y = ml_df['risk_category']

# ── Train/Test Split ──────────────────────────────────────────
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# ── Train Model ───────────────────────────────────────────────
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)

print("\n📊 Classification Report:")
print(classification_report(y_test, y_pred, zero_division=0))

# ── Feature Importance Chart ──────────────────────────────────
feat_imp = pd.Series(model.feature_importances_, index=features).sort_values()
fig, ax = plt.subplots(figsize=(8, 5))
feat_imp.plot(kind='barh', color='steelblue', ax=ax)
ax.set_title('Feature Importance — Automation Risk Model',
             fontsize=14, fontweight='bold')
ax.set_xlabel('Importance Score')
plt.tight_layout()
plt.savefig(os.path.join(OUTPUT, 'chart6_feature_importance.png'), dpi=150)
plt.show()

print("✅ ML model complete")
conn.close()