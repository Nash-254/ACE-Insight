## Detailed Schema Design

**1. `ace_prevalence` Schema**

Stores global ACE prevalence data by geographic region and country.
-	**Table**: `ace_prevalence_by_region`
-	**Purpose**: Capture prevalence percentages across continents, with metadata such as year, population group, and data source.
-	**Key Fields**:
    - `region_name` (VARCHAR) – Name of the country or subregion.
    - `continent` (VARCHAR) – Continent classification.
    - `ace_prevalence_percent` (DECIMAL) – Percentage prevalence of ACEs.
    - `population_group` (VARCHAR) – Demographic group surveyed.
    - `data_source` (TEXT) – Study or survey reference.
    - `year` (INT) – Year of data collection.
________________________________________
**2. `ace_impact` Schema**

Houses multiple datasets analyzing the effects of ACEs and their impact.

**a. Table**: `ace_associations`
- **Purpose**: Store adjusted odds ratios (AORs), confidence intervals, and p-values for health and behavioral outcomes in young adults (18–24) in five Sub-Saharan African countries.
- **Key Fields**:
  - `ace_category` (VARCHAR) – Outcome category (e.g., suicidal/self-harm).
  - `ace_exposure_group` (VARCHAR) – ACE exposure level (0, 1–2, ≥3).
  - `sex` (VARCHAR) – Participant gender.
  - `aor`, `aor_ci_low`, `aor_ci_high` (NUMERIC) – Adjusted odds ratio and CI bounds.
  - `p_value` (NUMERIC) – Statistical significance indicator.
  - 
**b. Table**: `ace_mental_health_associations`
- **Purpose**: Link specific ACE types to adult mental health outcomes with ORs and CIs, adjusted for demographic covariates.
- **Key Fields**:
  - `ace_type` (VARCHAR) – ACE category (e.g., emotional abuse).a
  - `outcome_type` (VARCHAR) – Associated adult outcome (e.g., heavy drinking).
  - `odds_ratio`, `ci_lower`, `ci_upper` (DECIMAL) – Effect size metrics.
  - `adjustment_note` (TEXT) – Adjustment factors applied in analysis.
  
**c. Table**: `country_costs`
- **Purpose**: Quantify the economic burden of ACEs in European countries as GDP loss.
- **Key Fields**:
  - `country` (TEXT) – Country name (primary key).
  - `population_millions` (NUMERIC) – Population size.
  - `gdp_per_capita_usd` (NUMERIC) – GDP per capita in USD.
  - `ace_dalys_thousands` (NUMERIC) – Disability-adjusted life years lost due to ACEs.
  - `ace_costs_billion_usd` (NUMERIC) – Estimated financial cost.
  - `percent_gdp` (NUMERIC) – Share of GDP lost.
________________________________________
**3. `resilience_factors` Schema**

The resilience schema is divided into two thematic areas: Positive Childhood Experiences (PCE) and Always Available Adult (AAA). Each area contains dedicated tables to store outcome measures, ACE grouping information, resilience factor types, and statistical associations.

**a. Positive Childhood Experiences (PCE)**

**i. Table**: `outcomes`
- **Purpose**: Define measurable life or health outcomes assessed in PCE-related studies.
- **Key Fields**:
  - `outcome_id` (SERIAL, PK) – Unique outcome identifier.
  - `outcome_name` (VARCHAR) – Name of the measured outcome (e.g., “High mental well-being”).
  - `outcome_description` (TEXT) – Detailed description of the outcome variable.

**ii. Table**: `ace_groups`
 - **Purpose**: Classify participants into ACE exposure categories for analysis.
- **Key Fields**:
  - `ace_group_id` (SERIAL, PK) – Unique group identifier.
  - `ace_group_label` (VARCHAR) – Exposure level label (e.g., 0 ACEs, 1–3 ACEs, 4+ ACEs).
  - `ace_count_min` / `ace_count_max` (INT) – Range of ACE counts defining the group.

**iii. Table**: `pce_types`
- Purpose: Define categories of positive childhood experiences assessed in the dataset.
- **Key Fields**:
  - `pce_type_id` (SERIAL, PK) – Unique identifier for each PCE category.
  - `pce_name` (VARCHAR) – Name of the PCE factor (e.g., “Supportive family relationships”).
  - `pce_description` (TEXT) – Explanation of what the PCE entails.

**iv. Table**: `study_results`
- **Purpose**: Store statistical associations between PCEs and outcomes, stratified by ACE groups and other covariates.
- **Key Fields**:
  - `result_id` (SERIAL, PK) – Unique result entry identifier.
  - `pce_type_id` (FK) – References pce_types.
  - `outcome_id` (FK) – References outcomes.
  - `ace_group_id` (FK) – References ace_groups.
  - `sex` (VARCHAR) – Gender category of participants.
  - `aor` (NUMERIC) – Adjusted odds ratio.
  - `ci_lower` / `ci_upper` (NUMERIC) – 95% confidence interval bounds.
  - `p_value `(NUMERIC) – Significance level.
  - `data_source` (TEXT) – Reference to the originating study or survey.

**b. Always Available Adult (AAA)**

**i. Table**: `ace_count`
- **Purpose**: Record ACE exposure counts for participants in AAA resilience analyses.
- **Key Fields**:
  - `participant_id` (SERIAL, PK) – Unique participant record.
  - `ace_count` (INT) – Total ACEs reported.
  - `ace_group_label` (VARCHAR) – Category label based on ACE count (0, 1–3, 4+).

**ii Table**: `aaa_support`
- **Purpose**: Store associations between AAA access in childhood and measured outcomes, stratified by ACE exposure.
- **Key Fields**:
  - `record_id` (SERIAL, PK) – Unique result record.
  - `ace_group_label` (VARCHAR) – Exposure group label.
  - `aaa_access` (BOOLEAN) – Whether the participant had continuous AAA support.
  - `outcome_name` (VARCHAR) – Health or behavioral outcome being analyzed.
  - `aor` (NUMERIC) – Adjusted odds ratio.
  - `ci_lower` / `ci_upper` (NUMERIC) – 95% confidence interval bounds.
  - `p_value` (NUMERIC) – Significance level.
  - `data_source` (TEXT) – Reference to the study or survey source