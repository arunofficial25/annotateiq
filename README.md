# 🏷️ AnnotateIQ — Workforce & Impact Analytics

<div align="center">

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Scikit-Learn](https://img.shields.io/badge/Scikit--Learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white)
![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=tableau&logoColor=white)

*"Behind every AI model is a human whose job it trained away."*

</div>

---

## 📌 Project Overview

**AnnotateIQ** is a full-stack data analytics project built on the AI annotation industry — the human workforce that labels data to train machine learning models. The project goes beyond standard productivity dashboards to ask a deeper question:

> **What happens to the workers who train the AI that replaces them?**

This project analyzes annotator productivity, label quality, project cost efficiency, automation risk modeling, and the social impact of AI-driven workforce displacement — all within an Indian labor market context.

---

## 🎯 Business Problem

AI companies depend on thousands of human annotators to label images, text, audio, and video. These workers — many from low-literacy, low-income backgrounds — are the invisible backbone of the AI revolution. Yet:

- The tasks they perform are **highly repetitive and rule-based**
- Automation models are **actively being trained on their own work**
- Workers with **low education have no retraining safety net**
- **64.09% of current annotation jobs** are projected to be displaced within 5 years

This project quantifies that reality using real-world domain knowledge and data analytics.

---

## 🗂️ Project Structure

```
AnnotateIQ/
│
├── 📁 sql/
│    ├── 01_schema.sql            ← all 7 CREATE TABLE statements
│    ├── annotators.sql
│    ├── projects.sql
│    ├── tasks.sql
│    ├── annotations.sql
│    ├── quality_reviews.sql
│    ├── automation_risk.sql
│    ├── workforce_impact.sql
│    └── analysis_queries.sql  ← all 11 queries
│   
│
├── 📁 python/
│   └── annotateiq_eda.py           # EDA + 5 visualizations + ML model
│   └── annotateiq_excel.py         # Automated Excel workbook generation
│   └── annotateiq_export.py        # CSV exports for Tableau
│
├── 📁 outputs/
│   ├── chart1_approval_by_education.png
│   ├── chart2_speed_vs_accuracy.png
│   ├── chart3_error_types.png
│   ├── chart4_automation_risk.png
│   ├── chart5_jobs_by_region.png
│   ├── chart6_feature_importance.png
│   └── AnnotateIQ_Cost_Report.xlsx
│
├── 📁 tableau_data/
│   ├── 1_annotator_performance.csv
│   ├── 2_project_cost_quality.csv
│   ├── 3_automation_risk.csv
│   ├── 4_workforce_impact.csv
│   └── 5_error_analysis.csv
│    └── Dashboard.twb
│
└── README.md
```

---

## 🧱 Database Schema

7 interconnected tables built in **SQL Server**:

| Table | Description |
|---|---|
| `annotators` | Worker profiles — age, education, region, pay rate |
| `projects` | AI training projects — industry, use case, budget |
| `tasks` | Individual labeling jobs with complexity scoring |
| `annotations` | Submitted labels with status and confidence score |
| `quality_reviews` | QA outcomes — pass, fail, error type |
| `automation_risk` | Task-level replaceability scoring (0–1 index) |
| `workforce_impact` | Regional displacement projections by literacy |

**Entity Relationship:**
```
annotators ──< annotations >── tasks ──< projects
annotations ──< quality_reviews
tasks       ──< automation_risk
projects    ──< workforce_impact
```

---

## 📊 Analysis Layers

### Layer 1 — Annotator Productivity
- Tasks completed, avg time per task, total hours worked
- Approval rate per annotator
- Speed vs accuracy tradeoff matrix
- Performance tagging: High Performer / Average / Needs Support

### Layer 2 — Label Quality & Agreement
- Pass/fail rate by task type and complexity
- Most common error types (wrong_label, boundary_error, missed_entity)
- High-risk annotator flagging by failure rate

### Layer 3 — Cost & Efficiency
- Cost per annotation per project
- Estimated wasted budget from poor quality labels
- ROI analysis of QA checkpoints

### Layer 4 — Automation Risk Modeling
- Random Forest classifier predicting risk category (Critical / High / Medium / Low)
- Feature importance: repetitiveness, complexity, rule-based score, replacement timeline
- Task-level risk index scoring (0–1 scale)

### Layer 5 — Social & Workforce Impact
- Jobs at risk by Indian region (North, South, West, Central)
- Literacy-based vulnerability indexing
- **Signature query:** Links individual worker education level to automation risk of their task

---

## 🔍 Key Findings

| Finding | Value |
|---|---|
| Overall displacement rate (5yr projection) | **64.09%** |
| Jobs currently in annotation workforce | **1,100** |
| Jobs projected to remain after automation | **395** |
| Jobs at risk | **705** |
| Highest risk tasks | `object_classification`, `vehicle_detection`, `sentiment_labeling` |
| Estimated replacement timeline (critical tasks) | **1–2 years** |
| Illiterate annotator approval rate | **0%** |
| Top wasted budget project | FactoryGuard Safety — **₹8,75,000** |
| Total wasted budget across all projects | **₹23,41,667** |
| Most common error type | `wrong_label` (50% of all errors) |

---

## 🤖 ML Model — Automation Risk Classifier

**Algorithm:** Random Forest Classifier
**Target:** Risk Category (Critical / High / Medium / Low)

**Features used:**
| Feature | Importance |
|---|---|
| `estimated_replacement_years` | ~22% |
| `complexity_encoded` | ~21% |
| `repetitiveness_score` | ~20% |
| `complexity_score` | ~19% |
| `rule_based_score` | ~18% |

**Key insight:** Estimated replacement timeline and task repetitiveness are the strongest predictors of automation vulnerability — not technical complexity alone.

---

## 📈 Visualizations

### Python Charts (Matplotlib / Seaborn)
| Chart | Insight |
|---|---|
| Approval Rate by Education Level | Illiterate = 0%, Secondary = 100% |
| Speed vs Accuracy Scatter | Clear performance cluster split by literacy |
| Error Type Distribution | wrong_label dominates at 50% |
| Automation Risk by Task | 4 task types cross the critical 0.75 threshold |
| Current vs Projected Jobs by Region | North India loses 70% of annotation jobs |
| Feature Importance (ML) | Balanced features; replacement years leads |

### Tableau Dashboards
**Dashboard 1 — Annotator Performance**
Approval rates, speed vs accuracy scatter, KPIs filtered by education and region

**Dashboard 2 — Quality & Cost Intelligence**
Wasted budget by project, treemap of quality rates, error type analysis

**Dashboard 3 — Workforce & Automation Risk**
Automation risk index by task, current vs projected jobs, displacement scatter by replacement timeline

---

## 💡 The Uncomfortable Truth

The annotation industry is caught in a paradox:

- Workers are hired to label data that trains AI
- That same AI is then used to automate their jobs
- The workers most at risk — illiterate, low-income, gig-contracted — are those with the least ability to retrain
- The "new jobs created by AI" argument is statistically true but geographically and educationally misaligned

This project puts numbers to that paradox.

> *"Because every job automated is a livelihood disrupted — and the disruption is never evenly distributed."*
> ~ Arun

---

## 🛠️ Tech Stack

| Tool | Usage |
|---|---|
| SQL Server | Schema design, data storage, 11 analysis queries |
| Python (pandas) | Data loading, transformation, EDA |
| Matplotlib / Seaborn | 6 analytical visualizations |
| Scikit-Learn | Random Forest automation risk classifier |
| OpenPyXL | Automated 5-sheet Excel cost report |
| Tableau Desktop | 3 interactive dashboards |

---

## ▶️ How to Run

### Prerequisites
```bash
pip install pyodbc pandas matplotlib seaborn scikit-learn openpyxl sqlalchemy
```

### Steps
```bash
# 1. Run SQL schema and inserts in SSMS
#    → sql/schema.sql
#    → sql/insert_data.sql

# 2. Run EDA + ML
python python/annotateiq_eda.py

# 3. Generate Excel report
python python/annotateiq_excel.py

# 4. Export Tableau CSVs
python python/annotateiq_export.py

# 5. Open Tableau Desktop → connect to tableau_data/ folder
```

---

## 👤 Author

**Arun** — Data Analyst
[github.com/arunofficial25](https://github.com/arunofficial25)

---

<div align="center">
<i>"Behind every AI model is a human whose job it trained away."</i>
</div>
