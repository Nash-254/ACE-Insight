# ACE Insight: Mapping Trauma, Impact & Resilience

## Project Overview
This project explores the impact of **Adverse Childhood Experiences (ACEs)** on adult life and examines how **Positive Childhood Experiences (PCEs)** and **Always Available Adult (AAA)** support in childhood can help mitigate these effects. The analysis is based on report findings from the following regions:
1. **Global**: Africa, Asia, Europe, North & South America and Ocenia showing **ACE prevalance percentage**.
2. Five **Sub-Saharan African (SSA) countries**: Cote d'Ivoire, Kenya, Lesotho, Mozambique, and Namibia.
3. **Southern California**: adult members of Kaiser Permanente
4. **Europe**: 28 countries.
5.  **United Kingdom (UK)**: four regions; Luton, Wales, Hertfordshire, and Northamptonshire, 

Cumulative ACEs—encompassing abuse, neglect, household dysfuntion and other adversities like witnessing community violence and orphanhood—were quantified as an integer count ranging from 0 to 6. **Adjusted odds ratios (AORs)** with corresponding **95% confidence intervals (CIs)** were estimated, and associations were considered statistically significant at **p < 0.05**.


## Data Source
The data used in this project is drawn from **peer-reviewed journal articles** mainly from **PubMed Central (PMC)**, a free digital archive maintained by the **National Institutes of Health’s National of Medicine (NIH/NLM), USA**; https://www.ncbi.nlm.nih.gov/

Other sources include:
1. [ScienceDirect.com](https://www.sciencedirect.com/)
2. [ISPCAN](https://ispcan.org/)

It is important to note that, due to the region-specific focus of individual reports and articles, not all regions are represented across all tables. As such, each analysis is confined to the scope of the source from which the data was derived.


## Project Objectives
The project seeks to highlight:

**1. ACE Prevalence**:

Captures global ACE prevalence data across different regions. Research was done on a variety of population groups, ages 18-65 [^1]

**2. ACE Impact**

&nbsp;&nbsp;&nbsp;&nbsp; **i.	ACEs on young adults' life outcomes**: Aggregated data from five SSA countries, showing correlations between ACEs and negative life outcomes, specifically focusing on **dose-response** pattern and **gender-specific differences**. Survey was conducted on young adults aged 18–24. [^2]

&nbsp;&nbsp;&nbsp;&nbsp;**ii.	ACEs and adult mental health**: Analyzes the associations between self-reported mental health outcomes and ACEs from adult members of Kaiser Permanente in southern California. [^3]

&nbsp;&nbsp;&nbsp;&nbsp;**iii. Economic cost of ACEs**: Data from 28 European countries analyzing the economic **impact of ACEs on national GDP**. [^4]

**3. Resilience factors**

&nbsp;&nbsp;&nbsp;&nbsp; **i. PCEs**: Evaluated whether — and which — PCEs
moderate the association between ACEs and these outcomes in sub-Saharan Africa. Survey data from young adults, ages 18–24 years[^5]

&nbsp;&nbsp;&nbsp;&nbsp; **ii. AAA Support**: focuses on health-harming behaviours (HHBs) and lower mental well-being (LMWBs) caused by ACEs and investigates whether **continuous support from a trusted adult during childhood** can build resilience, mitigating these negative effects. Study was conducted on adults aged 18–69. [^6]

## Tools & Technologies Used
A hybrid approach integrated **SQL’s efficiency** in data extraction, schema design, and structured data management with **Python’s powerful statistical analysis** and **rich visualization** capabilities, delivering a workflow that was both efficient and insight-driven.
- **PostgreSQL**: Schema design and initial data analysis using SQL.
- **Python**: Main programming language used.
  - **SQLAlchemy + psycopg2**: For working with SQL databases directly within Python; database connection and analysis queries.
  - **Pandas**: For analyzing data and visualization Integration.
  - **Matplotlib**: For creating basic charts and graphs.
  - **Seaborn**: For more advanced and visually appealing plots.
- **VS Code**: Integrated Development Environment (IDE) for scripting and data handling.
- **Jupyter Notebooks**: An interactive environment for combining code, text, and visuals in one document.
- **Git & GitHub**: Version control.


## Abbreviations
- **ACE**: Adverse Childhood Experiences
- **PCE**: Positive Childhood Experiences
- **AAA**: Always Available Adult support in childhood
- **TDB**: Trauma Drive Behaviours
- **HHB**: Health-Harming Behaviour
- **LMWB**: Lower Mental Well-Being
- **SSA**: Sub-Saharan Africa
- **GDP**: Gross Domestic Product
- **AOR**: Adjusted Odds Ratio
- **CI**: Confidence Interval


## Schema Design
The database is organized into thematic schemas, each containing structured tables optimized for storing and querying the study datasets. All tables include primary keys, appropriate data types, and constraints to ensure referential integrity and facilitate cross-study analysis. Data was sourced from specific tables in the articles.

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
  - `ace_type` (VARCHAR) – ACE category (e.g., emotional abuse).
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


## Data Analysis
### 1. Prevalance of ACEs
Analysis begins with showing the prevalance of ACEs across the globe using a global analysis of the various research done per continent basis. Findings show that there's a high prevalance in low-income and middle-income countries at the 80+ percentile and high-income countries at the 35+ percentile.

See [ACE Prevalence % by Region notebook](/notebooks/ACE_Prevalence_%25_by_Region_notebook.ipynb) for detailed steps.

![ACE prevalence %](/visuals/1.ACE_Prevalence_by_Country.png)

## Insights
- This suggests **ACE prevalence is a widespread issue globally** rather than isolated to specific regions.
- The high rates in many African countries could indicate **systemic socioeconomic stressors**, historical trauma, or under-resourced social systems.
- Countries with unexpectedly high prevalence outside Africa may need **targeted policy reviews** and public health interventions.
- The **lack of countries with <30%** prevalence in the dataset suggests that **Adverse Childhood Experiences are common globally**, and **prevention strategies must be cross-cultural**.


### 2. Impact of ACEs
Next is to analyze the impact that the ACEs have on adult life, outcomes and finacial costs. 

### 3. Mitigation role of PCEs (Resilience)

## Insights and Recommendations 


###  References
[^1]: ChatGPT Analysis
[^2]: [Adverse Childhood Experiences and Associations in SSA, Table 3](https://pmc.ncbi.nlm.nih.gov/articles/PMC11160582/)
```Brown C, Nkemjika S, Ratto J, Dube SR, Gilbert L, Chiang L, Picchetti V, Coomer R, Kambona C, McOwen J, Akani B, Kamagate MF, Low A, Manuel P, Agusto A, Annor FB. Adverse Childhood Experiences and Associations with Mental Health, Substance Use, and Violence Perpetration among Young Adults in sub-Saharan Africa. Child Abuse Negl. 2024 Apr;150:106524. doi: 10.1016/j.chiabu.2023.106524. Epub 2023 Oct 26. PMID: 38854869; PMCID: PMC11160582.```
[^3]: [Unpacking the impact of ACEs on adult mental health, Table 2](https://pmc.ncbi.nlm.nih.gov/articles/PMC6007802/#S14) ```Merrick MT, Ports KA, Ford DC, Afifi TO, Gershoff ET, Grogan-Kaylor A. Unpacking the impact of adverse childhood experiences on adult mental health. Child Abuse Negl. 2017 Jul;69:10-19. doi: 10.1016/j.chiabu.2017.03.016. Epub 2017 Apr 15. PMID: 28419887; PMCID: PMC6007802.```
[^4]: [Health and financial costs of adverse childhood experiences in 28 European countries, Table 4](https://pmc.ncbi.nlm.nih.gov/articles/PMC8573710/) ```Hughes K, Ford K, Bellis MA, Glendinning F, Harrison E, Passmore J. Health and financial costs of adverse childhood experiences in 28 European countries: a systematic review and meta-analysis. Lancet Public Health. 2021 Nov;6(11):e848-e857. doi: 10.1016/S2468-2667(21)00232-2. PMID: 34756168; PMCID: PMC8573710.```
[^5]: [Parenting-related Positive Childhood Experiences (PCEs), Table 4 & 5](https://pmc.ncbi.nlm.nih.gov/articles/PMC11264190/) ```Seya MS, Matthews S, Zhu L, Brown C, Lefevre A, Agathis N, Chiang LF, Annor FB, McOwen J, Augusto A, Manuel P, Kamagate MF, Nobah MT, Coomer R, Kambona C, Low A. Parenting-related positive childhood experiences, adverse childhood experiences, and mental health-Four sub-Saharan African countries. Child Abuse Negl. 2024 Apr;150:106493. doi: 10.1016/j.chiabu.2023.106493. Epub 2023 Oct 14. PMID: 37839988; PMCID: PMC11264190.```
[^6]: [Always Available Adult (AAA)suppport, Table 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC5364707/#Sec8) ```Bellis MA, Hardcastle K, Ford K, Hughes K, Ashton K, Quigg Z, Butler N. Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences - a retrospective study on adult health-harming behaviours and mental well-being. BMC Psychiatry. 2017 Mar 23;17(1):110. doi: 10.1186/s12888-017-1260-z. Erratum in: BMC Psychiatry. 2017 Apr 13;17(1):140. doi: 10.1186/s12888-017-1305-3. PMID: 28335746; PMCID: PMC5364707.```
