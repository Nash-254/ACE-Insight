# ACE Insight: Mapping Trauma, Impact & Resilience
_How one **stable and caring adult** can make a world of difference_

## Project Overview
This project explores the impact of **Adverse Childhood Experiences (ACEs)** on adult life and examines how **Positive Childhood Experiences (PCEs)** can help mitigate these effects. The analysis is based on report findings from the following regions:
1. **Global**: Africa, Asia, Europe, North & South America and Ocenia showing ACE prevalance percentage. Research was done on a variety of population groups, ages 18-65.
2. Five **Sub-Saharan African (SSA) countries**: Cote d'Ivoire, Kenya, Lesotho, Mozambique, and Namibia, focusing on associations and outcomes of ACEs and PCEs in young adults. Survey was conducted on young adults aged 18–24, male and female.
3. **Europe**: 28 countries focusing on health and financial cost in adults, male and female.
4. **United Kingdom (UK)**: four regions; Luton, Wales, Hertfordshire, and Northamptonshire, focusing on the mitigation effect of health-harming behaviours (HHBs) and lower mental well-being (LMWBs) caused by ACEs through continuous support from a trusted adult. Study was conducted on adults aged 18–69, male and female.

Cumulative ACEs (including emotional, physical, and sexual violence; witnessing interparental violence and violence in the community; and orphanhood) were defined by an integer count of the total number of individual ACEs (0 to 6). Weighted prevalence and adjusted odds ratios (AOR) were estimated.


## Data Source
The data used in this project is drawn from peer-reviewed reports and articles available on:
1. **PubMed Central (PMC)**, a free digital archive maintained by the **National Institutes of Health’s National of Medicine (NIH/NLM), USA**; https://www.ncbi.nlm.nih.gov/
2. [ScienceDirect.com](https://www.sciencedirect.com/)
3. [ISPCAN](https://ispcan.org/)

It is important to note that, due to the region-specific focus of individual reports and articles, not all regions are represented across all tables. As such, each analysis is confined to the scope of the source from which the data was derived.


## Project Objectives
The project seeks to highlight:
1. The **prevalence of ACEs** among adults
2. The **impact of ACEs** on their lives
3. The **resilience factors** and their effects on mitigating trauma driven behaviours (TDB)

## Tools & Technologies Used
A hybrid approach integrated **SQL’s efficiency** in data extraction, schema design, and structured data management with **Python’s powerful statistical analysis** and **rich visualization** capabilities, delivering a workflow that was both efficient and insight-driven.
- **PostgreSQL**: Schema design and initial data analysis using SQL.
- **Python**: Main programming language used.
  - **SQLAlchemy + psycopg2**: For working with SQL databases directly within Python; database connection and analysis queries.
  - **Pandas**: For handling and analyzing data.
  - **Matplotlib**: For creating basic charts and graphs.
  - **Seaborn**: For more advanced and visually appealing plots.
- **VS Code**: Integrated Development Environment (IDE) for scripting and data handling.
- **Jupyter Notebooks**: An interactive environment for combining code, text, and visuals in one document.
- **Git & GitHub**: Version control and collaboration.
- **Power BI**: Interactive data visualization with dynamic drill-down capabilities.


## Abbreviations
- **ACE**: Adverse Childhood Experience
- **PCE**: Positive Childhood Experiences
- **AAA**: Always Available Adult support in childhood
- **TDB**: Trauma Drive Behaviours
- **HHB**: Health-Harming Behaviour
- **LMWB**: Lower Mental Well-Being
- **SSA**: Sub-Saharan Africa
- **GDP**: Gross Domestic Product,
- **AOR**: Adjusted Odds Ratio
- **CI**: Confidence Interval


## Schema Design
The first step is to create the database and define the schemas that will support the analysis. The following schema titles serve as a guide, reflecting the complexity and thematic scope of the data:
1. **ACE Prevalance** 
   - ***ACE prevalance by region***: Captures global ACE prevalence data across different regions [^1]
2. **ACE Impact**
   1. ***ACEs on young adults' life outcomes***: Aggregated data from five SSA countries, showing correlations between ACEs and negative life outcomes [^2]
   2. ***Economic cost of ACEs***: Data from 28 European countries analyzing the economic impact of ACEs on national GDP. [^3]
   3. ***ACEs and adult mental health***: Analyzes the relationship between ACE scores and adult mental health outcomes. [^4]
3. **Resilience factors**
   - ***PCEs***:Evaluates whether — and which — PCEs moderate the association between ACEs and negative outcomes.[^5] 
   - ***AAA Support***:  analyze if access to a trusted adult in childhood is associated with reduced impacts of ACEs [^6]


## Data Analysis
### 1. Prevalance of ACEs
Analysis begins with showing the prevalance of ACEs across the globe using a global analysis of the various research done per continent basis. Findings show that there's a high prevalance in low-income and middle-income countries at the 80+ percentile and high-income countries at the 40+ percentile.

>[!NOTE] Insert query & charts

### 2. Impact of ACEs

### 3. Mitigation role of PCEs (Resilience)

## Insights and Recommendations 


###  References
[^1]: ChatGPT Analysis
[^2]: [Adverse Childhood Experiences and Associations in SSA, Table 3](https://pmc.ncbi.nlm.nih.gov/articles/PMC11160582/)
```Brown C, Nkemjika S, Ratto J, Dube SR, Gilbert L, Chiang L, Picchetti V, Coomer R, Kambona C, McOwen J, Akani B, Kamagate MF, Low A, Manuel P, Agusto A, Annor FB. Adverse Childhood Experiences and Associations with Mental Health, Substance Use, and Violence Perpetration among Young Adults in sub-Saharan Africa. Child Abuse Negl. 2024 Apr;150:106524. doi: 10.1016/j.chiabu.2023.106524. Epub 2023 Oct 26. PMID: 38854869; PMCID: PMC11160582.```
[^3]: [Health and financial costs of adverse childhood experiences in 28 European countries, Table 4](https://pmc.ncbi.nlm.nih.gov/articles/PMC8573710/) ```Hughes K, Ford K, Bellis MA, Glendinning F, Harrison E, Passmore J. Health and financial costs of adverse childhood experiences in 28 European countries: a systematic review and meta-analysis. Lancet Public Health. 2021 Nov;6(11):e848-e857. doi: 10.1016/S2468-2667(21)00232-2. PMID: 34756168; PMCID: PMC8573710.```
[^4]: [Unpacking the impact of ACEs on adult mental health, Table 2](https://pmc.ncbi.nlm.nih.gov/articles/PMC6007802/#S14) ```Merrick MT, Ports KA, Ford DC, Afifi TO, Gershoff ET, Grogan-Kaylor A. Unpacking the impact of adverse childhood experiences on adult mental health. Child Abuse Negl. 2017 Jul;69:10-19. doi: 10.1016/j.chiabu.2017.03.016. Epub 2017 Apr 15. PMID: 28419887; PMCID: PMC6007802.```
[^5]: [Parenting-related Positive Childhood Experiences(PCEs), Table 4 & 5](https://pmc.ncbi.nlm.nih.gov/articles/PMC11264190/) ```Seya MS, Matthews S, Zhu L, Brown C, Lefevre A, Agathis N, Chiang LF, Annor FB, McOwen J, Augusto A, Manuel P, Kamagate MF, Nobah MT, Coomer R, Kambona C, Low A. Parenting-related positive childhood experiences, adverse childhood experiences, and mental health-Four sub-Saharan African countries. Child Abuse Negl. 2024 Apr;150:106493. doi: 10.1016/j.chiabu.2023.106493. Epub 2023 Oct 14. PMID: 37839988; PMCID: PMC11264190.```
[^6]: [Always Available Adult(AAA)suppport, Table 1](https://pmc.ncbi.nlm.nih.gov/articles/PMC5364707/#Sec8) ```Bellis MA, Hardcastle K, Ford K, Hughes K, Ashton K, Quigg Z, Butler N. Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences - a retrospective study on adult health-harming behaviours and mental well-being. BMC Psychiatry. 2017 Mar 23;17(1):110. doi: 10.1186/s12888-017-1260-z. Erratum in: BMC Psychiatry. 2017 Apr 13;17(1):140. doi: 10.1186/s12888-017-1305-3. PMID: 28335746; PMCID: PMC5364707.```
