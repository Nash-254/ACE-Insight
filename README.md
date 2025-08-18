# ACE Insight: Mapping Trauma, Impact & Resilience

## Project Overview
This project investigates how **Adverse Childhood Experiences (ACEs)** shape outcomes in adulthood, and how **Positive Childhood Experiences (PCEs)** and the presence of an **Always Available Adult (AAA) during childhood** can **buffer** and **reduce** these **impacts**. The analysis draws on report findings from multiple regions worldwide, offering a comparative view of prevalence, impact, and resilience factors. The analysis is based on report findings from the following regions:
1. **Global**: Africa, Asia, Europe, North & South America and Ocenia showing **ACE prevalance percentage**. 24 countries were analyzed.
2. **Sub-Saharan African (SSA) countries**: Five countries; Cote d'Ivoire, Kenya, Lesotho, Mozambique, and Namibia.
3. **Southern California**: adult members of Kaiser Permanente.
4. **Europe**: 28 countries.
5.  **United Kingdom (UK)**: four regions; Luton, Wales, Hertfordshire, and Northamptonshire.

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
- **TDB**: Trauma Driven Behaviours
- **HHB**: Health-Harming Behaviour
- **LMWB**: Lower Mental Well-Being
- **SSA**: Sub-Saharan Africa
- **GDP**: Gross Domestic Product
- **DALYs**: Disability-Adjusted Life Year (Years lost & Years lived with illness or disabilty).
- **AOR**: Adjusted Odds Ratio; shows the odds of the occurence of an event while accounting for other factors. Lower is better.
- **CI**: Confidence Interval; A range where the true answer likely is, usually at 95%. A narrower gap means more precision.


## Schema Design
The database is organized into thematic schemas, each containing structured tables optimized for storing and querying the study datasets. All tables include primary keys, appropriate data types, and constraints to ensure referential integrity and facilitate cross-study analysis. Data was sourced from specific tables in the articles.

**1. `ace_prevalence` Schema; 1 table**

Stores global ACE prevalence data by geographic region and country.
-	**Table**: `ace_prevalence_by_region`
-	**Purpose**: Capture prevalence percentages across continents, with metadata such as year, population group, and data source.
________________________________________
**2. `ace_impact` Schema; 3 tables**

Houses multiple datasets analyzing the effects of ACEs and their impact.

**a. Table**: `ace_associations`
- **Purpose**: Store adjusted odds ratios (AORs), confidence intervals, and p-values for health and behavioral outcomes in young adults (18–24) in five Sub-Saharan African countries.

**b. Table**: `ace_mental_health_associations`
- **Purpose**: Link specific ACE types to adult mental health outcomes with ORs and CIs, adjusted for demographic covariates.

**c. Table**: `country_costs`
- **Purpose**: Quantify the economic burden of ACEs in European countries as GDP loss.
________________________________________
**3. `resilience_factors` Schema; 6 tables**

The resilience schema is divided into two thematic areas: Positive Childhood Experiences (PCE) and Always Available Adult (AAA). Each area contains dedicated tables to store outcome measures, ACE grouping information, resilience factor types, and statistical associations.

**a. Positive Childhood Experiences (PCE); 4 tables**

**i. Table**: `outcomes`
- **Purpose**: Define measurable life or health outcomes assessed in PCE-related studies.

**ii. Table**: `ace_groups`
 - **Purpose**: Classify participants into ACE exposure categories for analysis.

**iii. Table**: `pce_types`
- Purpose: Define categories of positive childhood experiences assessed in the dataset.

**iv. Table**: `study_results`
- **Purpose**: Store statistical associations between PCEs and outcomes, stratified by ACE groups and other covariates.

**b. Always Available Adult (AAA); 2 tables**

**i. Table**: `ace_count`
- **Purpose**: Record ACE exposure counts for participants in AAA resilience analyses.

**ii Table**: `aaa_support`
- **Purpose**: Store associations between AAA access in childhood and measured outcomes, stratified by ACE exposure.

For a detailed schema design, see [Detailed Schema Design](/notebooks/full_schema_design.md) markdown document.

## Data Analysis
### 1. PREVALENCE OF ACEs
Analysis begins with showing the prevalance of ACEs across the globe using a global analysis of the various research done per continent basis. Findings show that there's a high prevalance in low-income and middle-income countries at the 80+ percentile and high-income countries at the 35+ percentile.

See [ACE Prevalence % by Region notebook](/notebooks/1.ACE_Prevalence_%25_by_Region_notebook.ipynb) for detailed steps.


**Insights**
- This suggests **ACE prevalence is a widespread issue globally** rather than isolated to specific regions.
- The high rates in many African countries could indicate **systemic socioeconomic stressors**, historical trauma, or under-resourced social systems.
- The **lack of countries with <30%** prevalence in the dataset suggests that **Adverse Childhood Experiences are common globally**, and **prevention strategies must be cross-cultural**.

![ACE prevalence %](/visuals/1.ACE_Prevalence_by_Country.png)
***Figure 1. ACE Prevalence % by Country***

### 2. IMPACT OF ACEs
Next is to analyze the impact that the ACEs have on adult life, outcomes and financial costs. 

See [ACE Impact notebook](/notebooks/2.ACE_Impact_notebook.ipynb) for detailed steps.

**a. Dose-response pattern in young adults**

**Insights**
- Findings reinforce that **multiple ACE exposures dramatically elevate risk** for serious behavioral and mental health outcomes.
- The **dose–response trend** indicates that even more ACE result to higher outcomes while reductions could yield substantial health benefits.
- The **largest effect sizes** are for **violence perpetration**, followed by **suicidal/self-harm behaviors**, then **psychological distress**, and lastly **substance use**.

![Dose-response pattern and Gender-specific differences](/visuals/2.1.Dose-response_pattern_and_Gender_specific_differences.png)
***Figure 2.1. Dose-response pattern and Gender specific differences***

**b. HHB and LMH in adults mental health due to ACEs**

**Insights**
- **Emotional trauma (abuse/neglect)** shows **stronger associations than physical trauma**
- **Suicide attempts** have the **most severe associations** with ACEs
- All significant associations show increased risk (no protective factors identified)
- Household dysfunction (mental illness, substance abuse) creates substantial risk

![Self-reported mental health outcomes vs ACEs](/visuals/2.2.Self-reported_%20mental_health_outcomes_and_ACEs.png)
***Figure 2.2. Self-reported mental health outcomes and ACEs***

**c. Cost to GDP of ACEs**

**Insights**
1. **Wealth is not a shield**: Finland, despite high GDP per capita, has one of the highest proportional losses (4.1%).
2. **Large economies, high absolute costs**: Germany ($129.4B) and France ($38B) have massive total ACE costs despite moderate % GDP losses.
3. Countries with **high DALYs** attributed to ACEs are loosing a large workforce therefore **lower productivity affecting GDP**.

![Impact of ACEs on nationalGDP](/visuals/2.3.Impact_of_ACEs_on_national_GDP.png)
***Figure 2.3. Impact of ACEs on national GDP***

### 3. RESILIENCE FACTORS
Finally, the project explores how Positive Childhood Experiences (PCEs) and the presence of an Always Available Adult (AAS) can buffer against the harmful impacts of ACEs, nurturing resilience and empowering healthier, more fulfilling adult lives.

See [Resilience Factors notebook](/notebooks/3.Resilience_Factors_notebook.ipynb) for detailed steps.

### A. Positive Childhood Experiences (PCEs)
___

**Insights**
- **Strong father-child relationships** were **protective for males** against suicidal/self-harm (aOR ~0.40) and substance use (aOR ~0.60), suggesting this PCE is highly impactful for this subgroup.
- **Strong mother-child relationships** lowered odds of mental distress (aOR ~0.70), suicidal/self-harm behaviors (aOR ~0.60), and substance use in some cases.
- Effects were significant mainly when p < 0.05 and aOR < 1, indicating reduced odds of adverse outcomes.
  
![PCEs with significant protective effect](/visuals/3.1.PCEs_with_significant_protective_effect.png)
***Figure 3.1. PCEs with significant protective effect***

### B. Always Available Adult (AAA) support

**Insights**
  - **Low mental well-being** is less than half (9% for Yes vs 21% No) when AAA support is present.
  - **Two or more health-harming** behaviours drop from 10.5% (No AAA) to 6.2% (Yes AAA).
  - **Daily smoking** is reduced by ~6 percentage points.
___
The trend lines make it clear that as ACE count increases, the rates of all negative outcomes rise sharply, especially for smoking and low mental well-being;
![ACE WITHOUT AAA Support vs Adult Health Outcomes](/visuals/3.2.1.ACE_WITHOUT_AAA%20Support_vs_Adult_Health_Outcomes.png)
***Figure 3.2.1. ACE WITHOUT AAA Support vs Adult Health Outcomes***

Having **AAA support** (1) consistently aligns with **lower percentages** of all negative outcomes.
![ACE WITH AAA Support vs Adult Health Outcomes](/visuals/3.2.2.ACE_WITH_AA_Support_vs_Adult_Health_Outcomes.png)
***Figure 3.2.2. ACE WITH AAA support vs Adult Health Outcomes***




## Recommendations

Generally, the short- and long-term ***effects of childhood trauma can be significantly reduced by the presence of a consistent, caring adult**. There is an urgent need for more initiatives that equip mentors—parents, guardians, caregivers, and educators—with the knowledge and skills to recognize and effectively respond to trauma in children as well as in adults. Some recommendations are:

**1. Prevent Adverse Childhood Experiences (ACEs)**
   - Invest in early interventions to reduce abuse, neglect, and household dysfunction.

**2. Ensure Every Child Has a Trusted Adult (AAA Support)**
- Expand mentoring, counseling, and community programs that connect children to consistent supportive adults.

**3. Integrate ACE & AAA Screening in Services**
- Include ACE and AAA history in health, education, and social service assessments to guide targeted support.

**4. Target Support in High-Risk Communities**
- Focus prevention and AAA support initiatives where ACE prevalence is highest to maximize impact.

Intervention strategies may need **gender-specific targeting** — especially around violence prevention in males and mental health support in females.

## Conclusion
**Adverse Childhood Experiences (ACEs)** are a **pervasive global challenge**, leaving **deep and lasting scars**—yet they remain too often overlooked. This project brings global data together to reveal the scale, patterns, and consequences of ACEs—and to show that **change is possible**. With greater awareness and early, targeted action, we can **transform ACEs from a silent burden into an urgent call for prevention, resilience, and hope**.

###  References
[^1]: ChatGPT  and Claude Analysis
[^2]: [Adverse Childhood Experiences and Associations in SSA, Table 3](https://pmc.ncbi.nlm.nih.gov/articles/PMC11160582/)
```Brown C, Nkemjika S, Ratto J, Dube SR, Gilbert L, Chiang L, Picchetti V, Coomer R, Kambona C, McOwen J, Akani B, Kamagate MF, Low A, Manuel P, Agusto A, Annor FB. Adverse Childhood Experiences and Associations with Mental Health, Substance Use, and Violence Perpetration among Young Adults in sub-Saharan Africa. Child Abuse Negl. 2024 Apr;150:106524. doi: 10.1016/j.chiabu.2023.106524. Epub 2023 Oct 26. PMID: 38854869; PMCID: PMC11160582.```
[^3]: [Unpacking the impact of ACEs on adult mental health, Table 2](https://pmc.ncbi.nlm.nih.gov/articles/PMC6007802/#S14) ```Merrick MT, Ports KA, Ford DC, Afifi TO, Gershoff ET, Grogan-Kaylor A. Unpacking the impact of adverse childhood experiences on adult mental health. Child Abuse Negl. 2017 Jul;69:10-19. doi: 10.1016/j.chiabu.2017.03.016. Epub 2017 Apr 15. PMID: 28419887; PMCID: PMC6007802.```
[^4]: [Health and financial costs of adverse childhood experiences in 28 European countries, Table 4](https://pmc.ncbi.nlm.nih.gov/articles/PMC8573710/) ```Hughes K, Ford K, Bellis MA, Glendinning F, Harrison E, Passmore J. Health and financial costs of adverse childhood experiences in 28 European countries: a systematic review and meta-analysis. Lancet Public Health. 2021 Nov;6(11):e848-e857. doi: 10.1016/S2468-2667(21)00232-2. PMID: 34756168; PMCID: PMC8573710.```
[^5]: [Parenting-related Positive Childhood Experiences (PCEs), Table 4 & 5](https://pmc.ncbi.nlm.nih.gov/articles/PMC11264190/) ```Seya MS, Matthews S, Zhu L, Brown C, Lefevre A, Agathis N, Chiang LF, Annor FB, McOwen J, Augusto A, Manuel P, Kamagate MF, Nobah MT, Coomer R, Kambona C, Low A. Parenting-related positive childhood experiences, adverse childhood experiences, and mental health-Four sub-Saharan African countries. Child Abuse Negl. 2024 Apr;150:106493. doi: 10.1016/j.chiabu.2023.106493. Epub 2023 Oct 14. PMID: 37839988; PMCID: PMC11264190.```
[^6]: [Always Available Adult (AAA) suppport, Table 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC5364707/#Sec8) ```Bellis MA, Hardcastle K, Ford K, Hughes K, Ashton K, Quigg Z, Butler N. Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences - a retrospective study on adult health-harming behaviours and mental well-being. BMC Psychiatry. 2017 Mar 23;17(1):110. doi: 10.1186/s12888-017-1260-z. Erratum in: BMC Psychiatry. 2017 Apr 13;17(1):140. doi: 10.1186/s12888-017-1305-3. PMID: 28335746; PMCID: PMC5364707.```
