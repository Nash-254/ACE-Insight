-- ===============================================================================
-- POSTGRESQL ACE IMPACT SCHEMA CREATION 
-- ==============================================================================
CREATE SCHEMA IF NOT EXISTS ace_impact;
SET search_path TO ace_impact, public;

-- ===============================================================================
-- 1. Table creation, data insert and queries for young adults life outcomes of 5 SSA countries analysis
-- Source: "Adverse Childhood Experiences and Associations with Mental Health,Substance Use, and Violence Perpetration among Young Adults insub-Saharan Africa"; Table 3
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- END of creation, data insert and queries for young adults life outcomes of 5 SSA countries analysis
-- ===============================================================================


-- ==============================================================================
-- 2. Table creation, data insert and queries for ACE Cost Analysis for European Countries
-- Source: "Health and financial costs of adverse childhood experiences in 28 European countries_a systematic review and meta-analysis"; Table 4
---------------------------------------------------------------------------------

--TABLE CREATION
CREATE TABLE ace_impact.europe_ace_costs (
    id SERIAL PRIMARY KEY,
    country_name VARCHAR(50),
    population_millions DECIMAL(10,2) NOT NULL,
    gdp_per_capita_usd_2019 DECIMAL(10,2) NOT NULL,
    ace_attributable_dalys_thousands DECIMAL(10,2) NOT NULL,
    ace_attributable_costs_usd_billion DECIMAL(10,2) NOT NULL,
    equivalent_percent_of_gdp DECIMAL(5,2) NOT NULL
);

-- DATA INSERT
INSERT INTO ace_impact.europe_ace_costs (
    country_name,
    population_millions,
    gdp_per_capita_usd_2019,
    ace_attributable_dalys_thousands,
    ace_attributable_costs_usd_billion,
    equivalent_percent_of_gdp
) VALUES
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

-- Create indexes for better query performance
CREATE INDEX idx_population ON ace_impact.europe_ace_costs(population_millions);
CREATE INDEX idx_gdp_per_capita ON ace_impact.europe_ace_costs(gdp_per_capita_usd_2019);
CREATE INDEX idx_ace_costs ON ace_impact.europe_ace_costs(ace_attributable_costs_usd_billion);
CREATE INDEX idx_gdp_percentage ON ace_impact.europe_ace_costs(equivalent_percent_of_gdp);

-- VERIFY DATA INTEGRITY
SELECT * FROM ace_impact.europe_ace_costs;


-- DATA QUERY ANALYSIS

-- Top 5 countries by ACE costs
SELECT country_name, ace_attributable_costs_usd_billion 
FROM ace_impact.europe_ace_costs 
ORDER BY ace_attributable_costs_usd_billion DESC 
LIMIT 5;

-- Countries with highest ACE costs as percentage of GDP
SELECT country_name, equivalent_percent_of_gdp
FROM ace_impact.europe_ace_costs 
ORDER BY equivalent_percent_of_gdp DESC 
LIMIT 5;

-- Summary statistics
SELECT 
    COUNT(*) as total_countries,
    ROUND(AVG(population_millions), 1) as avg_population_millions,
    ROUND(AVG(gdp_per_capita_usd_2019), 0) as avg_gdp_per_capita,
    ROUND(SUM(ace_attributable_costs_usd_billion), 1) as total_ace_costs_billion,
    ROUND(AVG(equivalent_percent_of_gdp), 1) as avg_percent_gdp
FROM ace_impact.europe_ace_costs;

-- Countries with highest population and ACE costs
SELECT country_name, population_millions, gdp_per_capita_usd_2019, ace_attributable_costs_usd_billion 
FROM ace_impact.europe_ace_costs
ORDER BY population_millions DESC, ace_attributable_costs_usd_billion DESC;
--------------------------------------------------------------------------------
-- END of Table creation, data insert and queries for ACE Cost Analysis for European Countries
-- =============================================================================    



-- ===============================================================================
-- 3. Table creation, data insert and queries for associations between self-reported mental health outcomes and ACEs
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