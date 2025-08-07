-- ===============================================================================
-- POSTGRESQL RESILIENCE FACTORS SCHEMA CREATION 
-- ==============================================================================
CREATE SCHEMA IF NOT EXISTS resilience_factors;
SET search_path TO resilience_factors, public;

-- ==============================================================================
-- 1. Tables creation, data insert and queries for PCEs moderation of the association between ACEs and negative outcomes in SSA 
-- Source: "Parenting-related positive childhood experiences, adverse childhood experiences, and mental health—Four sub-Saharan African countries"; Table 4
------------------------------------------------------------------------------------



----------------------------------------------------------------------------------
-- END of creation, data insert and queries for PCEs moderation of the association between ACEs and negative outcomes in SSA
-- ===============================================================================




-- ==============================================================================
-- 2. Tables creation, data insert and queries for Always Available Adult (AAA) Support vs ACEs, Health-Harming Behaviors (HHBs), and Lower Mental Well-Being (LMWB) 
-- Source: "Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences"; Table 1
------------------------------------------------------------------------------------

-- Main study demographics and outcomes summary table
CREATE TABLE resilience_factors.study_population_summary (
    category_type VARCHAR(50) NOT NULL,
    category_value VARCHAR(50) NOT NULL,
    n INTEGER NOT NULL,
    percentage DECIMAL(4,1),
    daily_smoking_pct DECIMAL(4,1) NOT NULL,
    poor_diet_pct DECIMAL(4,1) NOT NULL, -- ≤1 portion fruit/veg per day
    weekly_heavy_drinking_pct DECIMAL(4,1) NOT NULL,
    multiple_hhbs_pct DECIMAL(4,1) NOT NULL, -- ≥2 health-harming behaviors
    lower_mental_wellbeing_pct DECIMAL(4,1) NOT NULL,
    chi_square_statistic DECIMAL(8,3),
    p_value VARCHAR(10),
    PRIMARY KEY (category_type, category_value)
);

-- ACE exposure patterns with outcomes
CREATE TABLE resilience_factors.ace_exposure_outcomes (
    ace_count_category VARCHAR(10) NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- AAA support patterns with outcomes  
CREATE TABLE resilience_factors.aaa_support_outcomes (
    aaa_support_available BOOLEAN NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Regional variation in outcomes
CREATE TABLE resilience_factors.regional_outcomes (
    region VARCHAR(50) NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Socioeconomic deprivation effects
CREATE TABLE resilience_factors.deprivation_outcomes (
    deprivation_quintile INTEGER NOT NULL PRIMARY KEY CHECK (deprivation_quintile BETWEEN 1 AND 5),
    quintile_description VARCHAR(20) NOT NULL,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Age group patterns
CREATE TABLE resilience_factors.age_group_outcomes (
    age_category VARCHAR(10) NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Sex-based differences
CREATE TABLE resilience_factors.sex_outcomes (
    sex VARCHAR(10) NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Ethnicity patterns
CREATE TABLE resilience_factors.ethnicity_outcomes (
    ethnicity VARCHAR(20) NOT NULL PRIMARY KEY,
    participant_count INTEGER NOT NULL,
    population_percentage DECIMAL(4,1) NOT NULL,
    daily_smoking_rate DECIMAL(4,1) NOT NULL,
    poor_diet_rate DECIMAL(4,1) NOT NULL,
    heavy_drinking_rate DECIMAL(4,1) NOT NULL,
    multiple_hhbs_rate DECIMAL(4,1) NOT NULL,
    lower_mwb_rate DECIMAL(4,1) NOT NULL
);

-- Statistical test results
CREATE TABLE resilience_factors.statistical_tests (
    variable_category VARCHAR(50) NOT NULL,
    outcome_measure VARCHAR(50) NOT NULL,
    chi_square_statistic DECIMAL(8,3) NOT NULL,
    p_value VARCHAR(10) NOT NULL,
    degrees_of_freedom INTEGER,
    statistical_significance BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (variable_category, outcome_measure)
);

-- DATA INSERT

-- Overall study population
INSERT INTO resilience_factors.study_population_summary (category_type, category_value, n, percentage, daily_smoking_pct, poor_diet_pct, weekly_heavy_drinking_pct, multiple_hhbs_pct, lower_mental_wellbeing_pct) VALUES
('Overall', 'All_Participants', 7047, NULL, 19.1, 12.6, 7.7, 8.5, 15.5);

SELECT * FROM resilience_factors.study_population_summary;

-- ACE exposure patterns
INSERT INTO resilience_factors.ace_exposure_outcomes VALUES
('0', 3964, 56.3, 14.1, 10.5, 5.7, 5.6, 11.5),
('1', 1271, 18.0, 18.3, 13.5, 8.3, 8.5, 14.2),
('2-3', 1086, 15.4, 22.3, 13.0, 9.4, 9.8, 18.1),
('4+', 726, 10.3, 43.4, 22.3, 15.6, 22.9, 35.4);

SELECT * FROM resilience_factors.ace_exposure_outcomes;

-- AAA support patterns
INSERT INTO resilience_factors.aaa_support_outcomes VALUES
(TRUE, 3273, 46.4, 16.0, 9.8, 7.1, 6.2, 9.0),
(FALSE, 3774, 53.6, 21.9, 15.1, 8.3, 10.5, 21.1);

SELECT * FROM resilience_factors.aaa_support_outcomes;

-- Regional outcomes
INSERT INTO resilience_factors.regional_outcomes VALUES
('Luton', 1334, 18.9, 18.1, 10.9, 4.0, 6.7, 14.5),
('Wales', 1819, 25.8, 22.3, 20.2, 12.7, 14.7, 19.4),
('Hertfordshire', 2421, 34.4, 17.7, 10.0, 7.1, 6.9, 13.8),
('Northamptonshire', 1473, 20.9, 18.5, 9.2, 5.9, 5.3, 14.4);

SELECT * FROM resilience_factors.regional_outcomes;

-- Deprivation quintiles
INSERT INTO resilience_factors.deprivation_outcomes VALUES
(1, 'Affluent', 1884, 26.7, 14.0, 9.4, 8.0, 5.7, 11.4),
(2, 'Quintile_2', 1409, 20.0, 17.8, 11.5, 6.3, 7.0, 14.8),
(3, 'Quintile_3', 1444, 20.5, 19.5, 14.2, 7.7, 10.0, 16.5),
(4, 'Quintile_4', 1403, 19.9, 19.5, 14.3, 8.1, 9.1, 17.2),
(5, 'Deprived', 907, 12.9, 30.8, 16.1, 8.9, 13.8, 20.8);

SELECT * FROM resilience_factors.deprivation_outcomes;

-- Age categories
INSERT INTO resilience_factors.age_group_outcomes VALUES
('18-29', 1630, 23.1, 26.0, 19.6, 12.2, 15.8, 16.3),
('30-39', 1423, 20.2, 19.7, 9.1, 6.6, 6.8, 15.7),
('40-49', 1401, 19.9, 17.6, 11.9, 7.5, 6.9, 14.8),
('50-59', 1215, 17.2, 21.2, 11.6, 8.1, 7.9, 15.9),
('60-69', 1378, 19.6, 10.1, 9.6, 3.6, 3.8, 14.5);

SELECT * FROM resilience_factors.age_group_outcomes;

-- Sex differences  
INSERT INTO resilience_factors.sex_outcomes VALUES
('Female', 3815, 54.1, 15.5, 9.0, 4.0, 5.1, 15.2),
('Male', 3232, 45.9, 23.4, 16.9, 12.1, 12.6, 15.8);

SELECT * FROM resilience_factors.sex_outcomes;

-- Ethnicity patterns
INSERT INTO resilience_factors.ethnicity_outcomes VALUES
('White', 5976, 84.8, 20.9, 13.0, 8.9, 9.4, 16.0),
('Other_ethnicities', 1071, 15.2, 9.4, 10.8, 1.5, 3.9, 12.5);

SELECT * FROM resilience_factors.ethnicity_outcomes;

-- Statistical test results from Table 1
INSERT INTO resilience_factors.statistical_tests VALUES
('ACE_count', 'Daily_smoking', 348.569, '<0.001', 3, TRUE),
('ACE_count', 'Poor_diet', 78.990, '<0.001', 3, TRUE),
('ACE_count', 'Heavy_drinking', 91.334, '<0.001', 3, TRUE),
('ACE_count', 'Multiple_HHBs', 237.714, '<0.001', 3, TRUE),
('ACE_count', 'Lower_mental_wellbeing', 275.819, '<0.001', 3, TRUE),

('AAA_support', 'Daily_smoking', 39.187, '<0.001', 1, TRUE),
('AAA_support', 'Poor_diet', 45.067, '<0.001', 1, TRUE),
('AAA_support', 'Heavy_drinking', 3.914, '0.048', 1, TRUE),
('AAA_support', 'Multiple_HHBs', 41.286, '<0.001', 1, TRUE),
('AAA_support', 'Lower_mental_wellbeing', 196.572, '<0.001', 1, TRUE),

('Region', 'Daily_smoking', 16.035, '0.001', 3, TRUE),
('Region', 'Poor_diet', 128.410, '<0.001', 3, TRUE),
('Region', 'Heavy_drinking', 96.317, '<0.001', 3, TRUE),
('Region', 'Multiple_HHBs', 122.030, '<0.001', 3, TRUE),
('Region', 'Lower_mental_wellbeing', 28.739, '<0.001', 3, TRUE),

('Deprivation', 'Daily_smoking', 112.981, '<0.001', 4, TRUE),
('Deprivation', 'Poor_diet', 35.957, '<0.001', 4, TRUE),
('Deprivation', 'Heavy_drinking', 6.230, '0.183', 4, FALSE),
('Deprivation', 'Multiple_HHBs', 60.510, '<0.001', 4, TRUE),
('Deprivation', 'Lower_mental_wellbeing', 49.141, '<0.001', 4, TRUE),

('Age', 'Daily_smoking', 128.350, '<0.001', 4, TRUE),
('Age', 'Poor_diet', 101.589, '<0.001', 4, TRUE),
('Age', 'Heavy_drinking', 82.286, '<0.001', 4, TRUE),
('Age', 'Multiple_HHBs', 160.650, '<0.001', 4, TRUE),
('Age', 'Lower_mental_wellbeing', 2.394, '0.664', 4, FALSE),

('Sex', 'Daily_smoking', 71.136, '<0.001', 1, TRUE),
('Sex', 'Poor_diet', 98.374, '<0.001', 1, TRUE),
('Sex', 'Heavy_drinking', 159.336, '<0.001', 1, TRUE),
('Sex', 'Multiple_HHBs', 128.351, '<0.001', 1, TRUE),
('Sex', 'Lower_mental_wellbeing', 0.639, '0.424', 1, FALSE),

('Ethnicity', 'Daily_smoking', 76.788, '<0.001', 1, TRUE),
('Ethnicity', 'Poor_diet', 3.702, '0.054', 1, FALSE),
('Ethnicity', 'Heavy_drinking', 68.912, '<0.001', 1, TRUE),
('Ethnicity', 'Multiple_HHBs', 34.359, '<0.001', 1, TRUE),
('Ethnicity', 'Lower_mental_wellbeing', 8.440, '<0.001', 1, TRUE);

SELECT * FROM resilience_factors.statistical_tests;


-- 2. AAA Protection Effectiveness Analysis  
SELECT 
    CASE 
        WHEN aaa_support_available THEN 'AAA Support Available' 
        ELSE 'No AAA Support' 
    END as support_status,
    participant_count,
    population_percentage,
    daily_smoking_rate,
    multiple_hhbs_rate,
    lower_mwb_rate,
    -- Protection factors (how much lower risk is with AAA)
    ROUND(21.9 / daily_smoking_rate, 2) as smoking_protection_factor,
    ROUND(10.5 / multiple_hhbs_rate, 2) as hhb_protection_factor,
    ROUND(21.1 / lower_mwb_rate, 2) as mwb_protection_factor
FROM resilience_factors.aaa_support_outcomes
ORDER BY aaa_support_available DESC;


-- Key ACE-AAA comparison view
CREATE VIEW resilience_factors.ace_aaa_risk_comparison AS
SELECT 
    'ACE_Risk_Gradient' as analysis_type,
    ace_count_category,
    participant_count,
    population_percentage,
    multiple_hhbs_rate,
    lower_mwb_rate,
    -- Calculate risk ratios relative to 0 ACEs
    ROUND(multiple_hhbs_rate / 5.6, 2) as hhb_risk_ratio_vs_no_ace,
    ROUND(lower_mwb_rate / 11.5, 2) as mwb_risk_ratio_vs_no_ace
FROM resilience_factors.ace_exposure_outcomes
UNION ALL
SELECT 
    'AAA_Protection_Effect' as analysis_type,
    CASE WHEN aaa_support_available THEN 'With_AAA_Support' ELSE 'Without_AAA_Support' END as ace_count_category,
    participant_count,
    population_percentage,
    multiple_hhbs_rate,
    lower_mwb_rate,
    -- Calculate protection ratios
    ROUND(6.2 / multiple_hhbs_rate, 2) as hhb_risk_ratio_vs_no_ace, -- Using AAA group as reference
    ROUND(9.0 / lower_mwb_rate, 2) as mwb_risk_ratio_vs_no_ace
FROM resilience_factors.aaa_support_outcomes
ORDER BY analysis_type, ace_count_category;
----------------------------------------------------------------------------------
-- END of tableS creation, data insert and queries on young adults life outcomes of 5 SSA countries
-- ===============================================================================
