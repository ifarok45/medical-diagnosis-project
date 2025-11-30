# ==============================================================
# STREAMLIT APP: Healthcare Chronic Disease Predictor
# ==============================================================

import streamlit as st
import pandas as pd
import numpy as np
import joblib
from datetime import datetime

st.set_page_config(page_title="Chronic Disease Predictor", layout="wide")

# --- Load model ---
@st.cache_resource
def load_model():
    model = joblib.load("models/chronic_disease_predictor.pkl")
    return model

model = load_model()

st.title("🏥 Chronic Disease Prediction App")
st.write("Upload your healthcare data tables (Patients, Encounters, Conditions, Medications, Observations) "
         "to predict if patients are likely to develop a chronic condition within 5 years.")

# --- File uploads ---
patients_file = st.file_uploader("📄 Upload Patients CSV", type=["csv"])
encounters_file = st.file_uploader("📄 Upload Encounters CSV", type=["csv"])
conditions_file = st.file_uploader("📄 Upload Conditions CSV", type=["csv"])
medications_file = st.file_uploader("📄 Upload Medications CSV", type=["csv"])
observations_file = st.file_uploader("📄 Upload Observations CSV", type=["csv"])

# ==========================================================
# HELPER FUNCTION: rename uploaded columns to training schema
# ==========================================================
def rename_columns(df, mapping):
    df = df.rename(columns={k: v for k, v in mapping.items() if k in df.columns})
    return df

# Mappings based on your provided names
patients_map = {
    "BIRTHDATE": "Birthdate",
    "DEATHDATE": "Deathdate",
    "MARITAL": "Marital",
    "RACE": "Race",
    "ETHNICITY": "Ethnicity",
    "GENDER": "Gender",
    "HEALTHCARE_EXPENSES": "Healthcare_Expenses",
    "HEALTHCARE_COVERAGE": "Healthcare_Coverage",
}
encounters_map = {
    "START": "StartDT",
    "STOP": "StopDT",
    "PATIENT": "Patient",
    "ENCOUNTERCLASS": "EncounterClass",
    "CODE": "Code",
    "DESCRIPTION": "Description",
    "BASE_ENCOUNTER_COST": "Base_Encounter_Cost",
    "TOTAL_CLAIM_COST": "Total_Claim_Cost",
    "PAYER_COVERAGE": "Payer_Coverage",
    "REASONCODE": "ReasonCode",
    "REASONDESCRIPTION": "ReasonDescription"
}
conditions_map = {"START": "StartDT", "STOP": "StopDT", "PATIENT": "Patient", "DESCRIPTION": "Description"}
medications_map = {
    "START": "StartDT", "STOP": "StopDT", "PATIENT": "Patient",
    "DESCRIPTION": "Description", "TOTALCOST": "TotalCost",
    "DISPENSES": "Dispenses"
}
observations_map = {
    "DATE": "ObsDT", "PATIENT": "Patient", "DESCRIPTION": "OBS_DESCRIPTION", "VALUE": "ValueNum"
}

# ==========================================================
# PROCESS AND PREDICT
# ==========================================================
if all([patients_file, encounters_file, conditions_file, medications_file, observations_file]):

    # --- Read and rename ---
    patients = rename_columns(pd.read_csv(patients_file), patients_map)
    encounters = rename_columns(pd.read_csv(encounters_file), encounters_map)
    conditions = rename_columns(pd.read_csv(conditions_file), conditions_map)
    medications = rename_columns(pd.read_csv(medications_file), medications_map)
    observations = rename_columns(pd.read_csv(observations_file), observations_map)

    st.success("✅ All files uploaded and standardized!")

    # --- Datetime conversions ---
    for df, cols in [(patients, ['Birthdate']),
                     (encounters, ['StartDT', 'StopDT']),
                     (conditions, ['StartDT', 'StopDT']),
                     (medications, ['StartDT', 'StopDT']),
                     (observations, ['ObsDT'])]:
        for c in cols:
            if c in df.columns:
                df[c] = pd.to_datetime(df[c], errors='coerce')

    # --- Feature engineering (same as training) ---
    patients['AGE'] = (pd.Timestamp('today') - patients['Birthdate']).dt.days // 365

    encounters['length_of_stay'] = (encounters['StopDT'] - encounters['StartDT']).dt.days
    enc_features = encounters.groupby('Patient').agg({
        'Base_Encounter_Cost': 'mean',
        'Total_Claim_Cost': 'mean',
        'length_of_stay': 'mean',
        'Code': 'count'
    }).rename(columns={
        'Base_Encounter_Cost': 'avg_base_cost',
        'Total_Claim_Cost': 'avg_claim_cost',
        'length_of_stay': 'avg_stay',
        'Code': 'encounter_count'
    })

    chronic_keywords = [
        'hypertension','diabetes','asthma','heart','cardio','chronic',
        'arthritis','obesity','renal','copd','hyperlipidemia','stroke','cancer','disease'
    ]
    conditions['is_chronic'] = conditions['Description'].astype(str).str.lower().apply(
        lambda x: any(k in x for k in chronic_keywords)
    )
    cond_features = conditions.groupby('Patient').agg({
        'Description': 'count',
        'is_chronic': 'mean'
    }).rename(columns={
        'Description': 'num_conditions',
        'is_chronic': 'chronic_ratio'
    })

    med_features = medications.groupby('Patient').agg({
        'Description': 'count',
        'TotalCost': 'mean',
        'Dispenses': 'mean'
    }).rename(columns={
        'Description': 'num_meds',
        'TotalCost': 'avg_med_cost',
        'Dispenses': 'avg_dispenses'
    })

    # --- Ensure ValueNum is numeric ---
    if 'ValueNum' in observations.columns:
        observations['ValueNum'] = pd.to_numeric(observations['ValueNum'], errors='coerce')

    # Group only valid numeric values
    obs_features = (
        observations.groupby('Patient')['ValueNum']
        .mean(numeric_only=True)
        .rename('avg_observation_value')
    )


    # --- Merge all features ---
    features = (
        patients.set_index('Id')
        .join(enc_features)
        .join(med_features)
        .join(cond_features)
        .join(obs_features)
    )

    # --- Keep same columns used in training ---
    required_cols = [
        'AGE','Gender','Race','Ethnicity','Marital',
        'Healthcare_Expenses','Healthcare_Coverage',
        'encounter_count','avg_base_cost','avg_claim_cost','avg_stay',
        'num_meds','avg_med_cost','avg_dispenses',
        'num_conditions','chronic_ratio','avg_observation_value'
    ]
    for col in required_cols:
        if col not in features.columns:
            features[col] = np.nan

    features = features[required_cols]

    # --- Predict ---
    preds = model.predict(features)
    probs = model.predict_proba(features)[:, 1]

    results = pd.DataFrame({
        'Patient_ID': features.index,
        'Predicted_Class': preds,
        'Chronic_Risk_Probability': np.round(probs, 3)
    })

    st.subheader("🔍 Prediction Results")
    st.dataframe(results)













# ==========================================================
# DASHBOARD: Visualization of Model Results
# ==========================================================

import seaborn as sns
import matplotlib.pyplot as plt
# 🔧 Global Matplotlib style (keeps charts compact and readable)
plt.rcParams.update({'font.size': 8, 'axes.titlesize': 5, 'axes.labelsize': 4})

# Merge results back with patient data for richer visuals
# ==========================================================
# SAFETY: Build dashboard data if not in memory
# ==========================================================
if 'features' in locals():
    dashboard_df = features.join(results.set_index("Patient_ID"))
elif 'patients' in locals():
    # fallback if we only have results and patients
    st.warning("⚠️ 'features' dataset not found; using limited patient info for visualization.")
    dashboard_df = patients.set_index('Id').join(results.set_index("Patient_ID"), how="inner")
else:
    st.error("❌ Missing feature dataset. Make sure preprocessing runs before visualization.")
    st.stop()

# ================================================================
# 📊 CHRONIC RISK ANALYSIS DASHBOARD SECTION
# ================================================================
import streamlit as st
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# --- Global style (small, consistent visuals) ---
plt.rcParams.update({
    'font.size': 7,
    'axes.titlesize': 9,
    'axes.labelsize': 7,
    'xtick.labelsize': 6,
    'ytick.labelsize': 6,
    'figure.autolayout': True
})

st.markdown("## 📈 Chronic Disease Risk Analysis Dashboard")

# ================================================================
# KPI METRICS
# ================================================================
st.subheader("📌 Overview Metrics")
col1, col2, col3 = st.columns(3)
col1.metric("Total Patients", f"{len(dashboard_df):,}")
col2.metric("High Risk Patients", f"{(dashboard_df['Predicted_Class'].sum()/len(dashboard_df)*100):.1f}%")
col3.metric("Avg Risk Probability", f"{dashboard_df['Chronic_Risk_Probability'].mean():.2f}")

# ================================================================
# DEMOGRAPHIC INSIGHTS
# ================================================================
st.markdown("### 👩‍⚕️ Demographic Insights")

dashboard_df['AgeGroup'] = pd.cut(
    dashboard_df['AGE'], 
    bins=[0,30,45,60,75,100],
    labels=['<30','30-45','45-60','60-75','75+']
)

col1, col2 = st.columns(2)

with col1:
    fig, ax = plt.subplots(figsize=(3.5, 2.5))
    sns.barplot(data=dashboard_df, x='AgeGroup', y='Chronic_Risk_Probability',
                palette='coolwarm', ax=ax)
    ax.set_title("Average Risk by Age Group")
    st.pyplot(fig, use_container_width=False)

with col2:
    fig, ax = plt.subplots(figsize=(3.5, 2.5))
    sns.barplot(data=dashboard_df, x='Chronic_Risk_Probability', y='Gender',
                palette='viridis', ax=ax)
    ax.set_title("Average Risk by Gender")
    st.pyplot(fig, use_container_width=False)

# ================================================================
# FINANCIAL INSIGHTS
# ================================================================
st.markdown("### 💵 Financial Impact Analysis")

col3, col4 = st.columns(2)

with col3:
    if 'Healthcare_Expenses' in dashboard_df.columns:
        fig, ax = plt.subplots(figsize=(3.5, 2.5))
        sns.barplot(data=dashboard_df, x='Predicted_Class', y='Healthcare_Expenses',
                    palette='Set2', ax=ax)
        ax.set_title("Avg Healthcare Expenses by Risk")
        ax.set_xlabel("Predicted Class (0=Low, 1=High)")
        st.pyplot(fig, use_container_width=False)

with col4:
    # Correlation between cost features and risk
    corr_cols = [col for col in [
        'Healthcare_Expenses', 'Healthcare_Coverage', 
        'avg_base_cost', 'avg_claim_cost', 'avg_med_cost',
        'Chronic_Risk_Probability'
    ] if col in dashboard_df.columns]

    if len(corr_cols) > 2:
        corr = dashboard_df[corr_cols].corr()
        fig, ax = plt.subplots(figsize=(3.5, 2.5))
        sns.heatmap(corr, annot=True, fmt=".2f", cmap='coolwarm', ax=ax)
        ax.set_title("Correlation: Cost Features vs Risk")
        st.pyplot(fig, use_container_width=False)

# ================================================================
# CLINICAL INSIGHTS (OPTIONAL)
# ================================================================
st.markdown("### 🧪 Clinical Insights")

# Create two equal columns
col1, col2 = st.columns(2)

with col1:
    if 'chronic_ratio' in dashboard_df.columns:
        fig, ax = plt.subplots(figsize=(3.5, 2.5))
        sns.scatterplot(
            data=dashboard_df, 
            x='chronic_ratio', 
            y='Chronic_Risk_Probability',
            hue='Predicted_Class', 
            palette='coolwarm', 
            alpha=0.7, 
            ax=ax
        )
        ax.set_title("Chronic Ratio vs Predicted Risk")
        st.pyplot(fig, use_container_width=False)

with col2:
    if 'avg_observation_value' in dashboard_df.columns:
        fig, ax = plt.subplots(figsize=(3.5, 2.5))
        sns.scatterplot(
            data=dashboard_df, 
            x='avg_observation_value', 
            y='Chronic_Risk_Probability',
            hue='Predicted_Class', 
            palette='mako', 
            alpha=0.7, 
            ax=ax
        )
        ax.set_title("Observation Values vs Risk")
        st.pyplot(fig, use_container_width=False)


# ================================================================
# TOP 10 HIGH-RISK PATIENTS TABLE
# ================================================================
st.markdown("### 🚨 Top 10 Highest Risk Patients")

top10 = (
    dashboard_df[['AGE','Gender','Race','Healthcare_Expenses',
                  'Healthcare_Coverage','Chronic_Risk_Probability']]
    .sort_values('Chronic_Risk_Probability', ascending=False)
    .head(10)
    .reset_index()
)

st.dataframe(top10.style.background_gradient(subset=['Chronic_Risk_Probability'], cmap='Reds'), use_container_width=True)

