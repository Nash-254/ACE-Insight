-- ===============================================================================
-- POSTGRESQL ACE IMPACT SCHEMA CREATION 
-- ==============================================================================
CREATE SCHEMA IF NOT EXISTS ace_impact;
SET search_path TO ace_impact, public;

-- ===============================================================================
-- 1. Table creation, data insert and queries for dose-response pattern and gender-specific differences in young adults (18-24)) of 5 SSA countries analysis
-- Source: "Adverse Childhood Experiences and Associations with Mental Health,Substance Use, and Violence Perpetration among Young Adults in sub-Saharan Africa"; Table 3
----------------------------------------------------------------------------------
-- TABLE CREATION
CREATE TABLE ace_impact.ace_associations (
    id SERIAL PRIMARY KEY,
    ace_category VARCHAR(30),
    ace_exposure_group VARCHAR(10),
    sex VARCHAR(6),
    n INTEGER,
    crude_or NUMERIC(5,2),
    crude_ci_low NUMERIC(5,2),
    crude_ci_high NUMERIC(5,2),
    aor NUMERIC(5,2),
    aor_ci_low NUMERIC(5,2),
    aor_ci_high NUMERIC(5,2),
    p_value NUMERIC(5,3)
);

-- DATA INSERTION
-- Suicidal/self-harm
INSERT INTO ace_impact.ace_associations VALUES
(1, 'Suicidal/self-harm', '0', 'Female', 167, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'Suicidal/self-harm', '1-2', 'Female', 636, 1.18, 0.76, 1.84, 1.20, 0.76, 1.89, NULL),
(3, 'Suicidal/self-harm', '>=3', 'Female', 452, 3.31, 2.13, 5.15, 3.58, 2.29, 5.60, 0.001),
(4, 'Suicidal/self-harm', '0', 'Male', 132, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(5, 'Suicidal/self-harm', '1-2', 'Male', 132, 2.38, 1.18, 4.82, 2.29, 1.12, 4.65, 0.05),
(6, 'Suicidal/self-harm', '>=3', 'Male', 105, 6.94, 3.59, 13.43, 6.59, 3.41, 12.73, 0.001),

-- Psych distress
(7, 'Psych distress', '0', 'Female', 616, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(8, 'Psych distress', '1-2', 'Female', 1828, 2.25, 1.70, 2.98, 2.21, 1.65, 2.96, 0.001),
(9, 'Psych distress', '>=3', 'Female', 874, 5.59, 3.95, 7.91, 5.55, 3.89, 7.91, 0.001),
(10, 'Psych distress', '0', 'Male', 107, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(11, 'Psych distress', '1-2', 'Male', 585, 1.89, 1.15, 3.10, 1.90, 1.18, 3.06, 0.05),
(12, 'Psych distress', '>=3', 'Male', 292, 3.16, 1.73, 5.77, 3.09, 1.70, 5.61, 0.01),

-- Substance use
(13, 'Substance use', '0', 'Female', 188, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(14, 'Substance use', '1-2', 'Female', 560, 1.53, 0.94, 2.49, 1.50, 0.91, 2.48, NULL),
(15, 'Substance use', '>=3', 'Female', 261, 1.90, 1.17, 3.08, 1.84, 1.11, 3.06, 0.05),
(16, 'Substance use', '0', 'Male', 139, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(17, 'Substance use', '1-2', 'Male', 582, 1.87, 1.24, 2.83, 1.97, 1.29, 3.01, 0.01),
(18, 'Substance use', '>=3', 'Male', 284, 2.49, 1.56, 3.99, 2.68, 1.69, 4.25, 0.001),

-- Violence perp
(19, 'Violence perp', '0', 'Female', 80, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(20, 'Violence perp', '1-2', 'Female', 586, 5.24, 3.03, 9.06, 5.27, 3.02, 9.21, 0.001),
(21, 'Violence perp', '>=3', 'Female', 421, 7.60, 4.46, 12.95, 7.62, 4.45, 13.05, 0.001),
(22, 'Violence perp', '0', 'Male', 44, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(23, 'Violence perp', '1-2', 'Male', 449, 4.92, 2.67, 9.06, 5.22, 2.88, 9.48, 0.001),
(24, 'Violence perp', '>=3', 'Male', 270, 7.52, 3.98, 14.23, 8.29, 4.34, 15.83, 0.001);

-- VERIFY DATA INTEGRITY
SELECT * FROM ace_impact.ace_associations;

------------------------------------------------------------------------------------------------------
-- DATA QUERY ANALYSIS
-- Dose-response relationship query
WITH ordered AS (
    SELECT 
        ace_category,
        sex,
        CASE 
            WHEN ace_exposure_group = '0' THEN 0
            WHEN ace_exposure_group = '1-2' THEN 1
            WHEN ace_exposure_group = '>=3' THEN 2
        END AS exposure_level,
        ace_exposure_group,
        aor
    FROM ace_associations
    WHERE aor IS NOT NULL
)
SELECT 
    ace_category,
    sex,
    ace_exposure_group,
    aor,
    aor - LAG(aor) OVER (PARTITION BY ace_category, sex ORDER BY exposure_level) AS change_from_prev
FROM ordered
ORDER BY ace_category, sex, exposure_level;
----------------------------------------------------------------------------------
-- END of table creation, data insert and queries for dose-response pattern and gender-specific differences in young adults (18-24)) of 5 SSA countries analysis
-- ===============================================================================


-- ===============================================================================
-- 2. Table creation, data insert and queries for associations between self-reported mental health outcomes and ACEs in adults
-- Source: "Unpacking the impact of adverse childhood experiences on adult mental health"; Table 2
----------------------------------------------------------------------------------
-- TABLE CREATION
CREATE TABLE ace_impact.ace_mental_health_associations (
    id SERIAL PRIMARY KEY,
    ace_type VARCHAR(50) NOT NULL,
    outcome_type VARCHAR(50) NOT NULL,
    odds_ratio DECIMAL(4,2) NOT NULL,
    ci_lower DECIMAL(4,2) NOT NULL,
    ci_upper DECIMAL(4,2) NOT NULL,
    adjustment_note TEXT
);

-- DATA INSERT
INSERT INTO ace_impact.ace_mental_health_associations (ace_type, outcome_type, odds_ratio, ci_lower, ci_upper, adjustment_note) VALUES
-- Drug Use (lifetime)
('Sexual Abuse', 'Drug Use (lifetime)', 1.75, 1.49, 2.04, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Abuse', 'Drug Use (lifetime)', 1.88, 1.55, 2.28, 'Adjusted for age, race, sex, education, marital status'),
('Physical Abuse', 'Drug Use (lifetime)', 1.75, 1.51, 2.01, 'Adjusted for age, race, sex, education, marital status'),
('Physical Neglect', 'Drug Use (lifetime)', 1.20, 0.95, 1.51, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Neglect', 'Drug Use (lifetime)', 1.73, 1.45, 2.05, 'Adjusted for age, race, sex, education, marital status'),
('Mother Treated Violently', 'Drug Use (lifetime)', 1.39, 1.15, 1.67, 'Adjusted for age, race, sex, education, marital status'),
('Household Mental Illness', 'Drug Use (lifetime)', 1.76, 1.51, 2.06, 'Adjusted for age, race, sex, education, marital status'),
('Incarcerated Household Member', 'Drug Use (lifetime)', 1.57, 1.22, 2.02, 'Adjusted for age, race, sex, education, marital status'),
('Household Substance Abuse', 'Drug Use (lifetime)', 1.82, 1.59, 2.10, 'Adjusted for age, race, sex, education, marital status'),
('Parental Separation/Divorce', 'Drug Use (lifetime)', 1.47, 1.27, 1.70, 'Adjusted for age, race, sex, education, marital status'),
('Spanking', 'Drug Use (lifetime)', 1.63, 1.42, 1.88, 'Adjusted for age, race, sex, education, marital status'),

-- Moderate to Heavy Drinking (past 12 months)
('Sexual Abuse', 'Heavy Drinking', 1.52, 1.29, 1.78, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Emotional Abuse', 'Heavy Drinking', 1.46, 1.15, 1.83, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Physical Abuse', 'Heavy Drinking', 1.48, 1.27, 1.72, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Physical Neglect', 'Heavy Drinking', 1.54, 1.23, 1.92, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Emotional Neglect', 'Heavy Drinking', 1.39, 1.15, 1.68, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Mother Treated Violently', 'Heavy Drinking', 1.34, 1.08, 1.64, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Household Mental Illness', 'Heavy Drinking', 1.33, 1.12, 1.57, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Incarcerated Household Member', 'Heavy Drinking', 1.33, 0.99, 1.77, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Household Substance Abuse', 'Heavy Drinking', 1.93, 1.66, 2.25, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Parental Separation/Divorce', 'Heavy Drinking', 1.14, 0.96, 1.34, 'Adjusted for age, race, education, marital status (sex omitted)'),
('Spanking', 'Heavy Drinking', 1.40, 1.22, 1.61, 'Adjusted for age, race, education, marital status (sex omitted)'),

-- Suicide Attempt (lifetime)
('Sexual Abuse', 'Suicide Attempt', 3.63, 2.78, 4.74, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Abuse', 'Suicide Attempt', 5.59, 4.22, 7.37, 'Adjusted for age, race, sex, education, marital status'),
('Physical Abuse', 'Suicide Attempt', 2.89, 2.22, 3.77, 'Adjusted for age, race, sex, education, marital status'),
('Physical Neglect', 'Suicide Attempt', 3.73, 2.71, 5.09, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Neglect', 'Suicide Attempt', 4.11, 3.13, 5.39, 'Adjusted for age, race, sex, education, marital status'),
('Mother Treated Violently', 'Suicide Attempt', 2.51, 1.86, 3.37, 'Adjusted for age, race, sex, education, marital status'),
('Household Mental Illness', 'Suicide Attempt', 5.42, 4.13, 7.15, 'Adjusted for age, race, sex, education, marital status'),
('Incarcerated Household Member', 'Suicide Attempt', 2.93, 2.02, 4.16, 'Adjusted for age, race, sex, education, marital status'),
('Household Substance Abuse', 'Suicide Attempt', 2.26, 1.72, 2.96, 'Adjusted for age, race, sex, education, marital status'),
('Parental Separation/Divorce', 'Suicide Attempt', 1.72, 1.30, 2.26, 'Adjusted for age, race, sex, education, marital status'),
('Spanking', 'Suicide Attempt', 2.20, 1.65, 2.97, 'Adjusted for age, race, sex, education, marital status'),

-- Depressed Affect (past 12 months)
('Sexual Abuse', 'Depressed Affect', 1.44, 1.24, 1.67, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Abuse', 'Depressed Affect', 1.90, 1.57, 2.30, 'Adjusted for age, race, sex, education, marital status'),
('Physical Abuse', 'Depressed Affect', 1.67, 1.45, 1.92, 'Adjusted for age, race, sex, education, marital status'),
('Physical Neglect', 'Depressed Affect', 1.34, 1.09, 1.65, 'Adjusted for age, race, sex, education, marital status'),
('Emotional Neglect', 'Depressed Affect', 1.84, 1.56, 2.16, 'Adjusted for age, race, sex, education, marital status'),
('Mother Treated Violently', 'Depressed Affect', 1.33, 1.10, 1.59, 'Adjusted for age, race, sex, education, marital status'),
('Household Mental Illness', 'Depressed Affect', 1.98, 1.70, 2.29, 'Adjusted for age, race, sex, education, marital status'),
('Incarcerated Household Member', 'Depressed Affect', 1.17, 0.90, 1.50, 'Adjusted for age, race, sex, education, marital status'),
('Household Substance Abuse', 'Depressed Affect', 1.50, 1.30, 1.72, 'Adjusted for age, race, sex, education, marital status'),
('Parental Separation/Divorce', 'Depressed Affect', 1.25, 1.08, 1.45, 'Adjusted for age, race, sex, education, marital status'),
('Spanking', 'Depressed Affect', 1.24, 1.08, 1.41, 'Adjusted for age, race, sex, education, marital status');

-- VERIFY DATA INTEGRITY
SELECT * FROM ace_impact.ace_mental_health_associations;

-- DATA QUERY ANALYSIS
SELECT 
    ace_type,
    outcome_type,
    odds_ratio,
    ci_lower,
    ci_upper,
    CASE 
        WHEN ci_lower > 1.0 THEN 'Significant Positive Association'
        WHEN ci_upper < 1.0 THEN 'Significant Negative Association'
        ELSE 'Non-significant'
    END as significance
FROM ace_impact.ace_mental_health_associations
WHERE ci_lower > 1.0 OR ci_upper < 1.0
ORDER BY odds_ratio DESC;
----------------------------------------------------------------------------------
-- END of creation, data insert and queries for associations between self-reported mental health outcomes and ACEs
-- ===============================================================================


-- ==============================================================================
-- 3. Table creation, data insert and queries for ACE Cost Analysis for European Countries
-- Source: "Health and financial costs of adverse childhood experiences in 28 European countries_a systematic review and meta-analysis"; Table 4
---------------------------------------------------------------------------------

--TABLE CREATION
CREATE TABLE ace_impact.country_costs (
    country TEXT PRIMARY KEY,
    population_millions NUMERIC,
    gdp_per_capita_usd NUMERIC,
    ace_dalys_thousands NUMERIC,
    ace_costs_billion_usd NUMERIC,
    percent_gdp NUMERIC
);

-- DATA INSERT
INSERT INTO ace_impact.country_costs (country, population_millions, gdp_per_capita_usd, ace_dalys_thousands, ace_costs_billion_usd, percent_gdp)
VALUES
    ('Albania', 2.9, 5352.9, 79.7, 0.4, 2.8),
    ('Belgium', 11.5, 46116.7, 162.6, 7.5, 1.4),
    ('Czech Republic', 10.7, 23101.8, 246.5, 5.7, 2.3),
    ('Denmark', 5.8, 59822.1, 136.0, 8.1, 2.3),
    ('Finland', 5.5, 48685.9, 225.2, 11.0, 4.1),
    ('France', 67.1, 40493.9, 939.4, 38.0, 1.4),
    ('Germany', 83.1, 46258.9, 2796.6, 129.4, 3.4),
    ('Greece', 10.7, 19582.5, 123.8, 2.4, 1.2),
    ('Hungary', 9.8, 16475.7, 239.1, 3.9, 2.4),
    ('Ireland', 4.9, 78661.0, 97.8, 7.7, 2.0),
    ('Italy', 60.3, 33189.6, 916.2, 30.4, 1.5),
    ('Latvia', 1.9, 17836.4, 105.0, 1.9, 5.5),
    ('Lithuania', 2.8, 19455.5, 93.0, 1.8, 3.3),
    ('Moldova', 2.7, 4498.5, 107.6, 0.5, 4.0),
    ('Montenegro', 0.6, 8832.0, 13.0, 0.1, 2.1),
    ('Netherlands', 17.3, 52447.8, 536.2, 28.1, 3.1),
    ('North Macedonia', 2.1, 6093.1, 31.6, 0.2, 1.5),
    ('Norway', 5.3, 75419.6, 145.7, 11.0, 2.7),
    ('Poland', 38.0, 15595.2, 941.5, 14.7, 2.5),
    ('Romania', 19.4, 12919.5, 660.5, 8.5, 3.4),
    ('Russia', 144.4, 11585.0, 4312.4, 50.0, 2.9),
    ('Serbia', 6.9, 7402.4, 191.9, 1.4, 2.8),
    ('Spain', 47.1, 29613.7, 565.9, 16.8, 1.2),
    ('Sweden', 10.3, 51610.1, 117.9, 6.1, 1.1),
    ('Switzerland', 8.6, 81993.7, 250.5, 20.5, 2.9),
    ('Turkey', 83.4, 9042.5, 926.5, 8.4, 1.1),
    ('Ukraine', 44.4, 3659.0, 2538.9, 9.3, 6.0),
    ('United Kingdom', 66.8, 42300.3, 1858.7, 78.6, 2.8);

-- VERIFY DATA INTEGRITY
SELECT * from ace_impact.country_costs;


-- DATA QUERY ANALYSIS
-- ACE costs as a percentage of GDP with DALYs
SELECT 
    country,
    gdp_per_capita_usd,
    percent_gdp,
    ace_dalys_thousands
FROM ace_impact.country_costs
ORDER BY percent_gdp DESC;
--------------------------------------------------------------------------------
-- END of Table creation, data insert and queries for ACE Cost Analysis for European Countries
-- =============================================================================
