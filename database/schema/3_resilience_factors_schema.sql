-- ===============================================================================
-- POSTGRESQL RESILIENCE FACTORS SCHEMA CREATION 
-- ==============================================================================
CREATE SCHEMA IF NOT EXISTS resilience_factors;
SET search_path TO resilience_factors, public;

-- ==============================================================================
-- 1. Tables creation, data insert and queries for evaluation of whether — and which — PCEs moderate the association between ACEs and negative outcomes analysis. 
-- Source: "Parenting-related positive childhood experiences, adverse childhood experiences, and mental health—Four sub-Saharan African countries"; Table 4 and 5
------------------------------------------------------------------------------------
--TABLES CREATION AND DATA INSERTS
-- Outcomes Table
CREATE TABLE outcomes (
    outcome_id SERIAL PRIMARY KEY,
    outcome_name VARCHAR(100) NOT NULL
);

INSERT INTO outcomes (outcome_name) VALUES
('Mental distress'), 
('Suicidal/self-harm'), 
('Substance use');

SELECT * FROM outcomes;

-- ACE Groups Table
CREATE TABLE ace_groups (
    ace_group_id SERIAL PRIMARY KEY,
    ace_group_label VARCHAR(20) UNIQUE NOT NULL  -- e.g., '0 ACEs', '1+ ACEs'
);

INSERT INTO ace_groups (ace_group_label) VALUES
('0 ACEs'), 
('1+ ACEs');

SELECT * FROM ace_groups;

-- PCE Types Table
CREATE TABLE pce_types (
    pce_type_id SERIAL PRIMARY KEY,
    pce_name VARCHAR(100) NOT NULL
);

INSERT INTO pce_types (pce_name) VALUES
('Strong mother–child relationship'),
('Strong father–child relationship'),
('High parental monitoring');

SELECT * FROM pce_types;

-- Study Results Table
CREATE TABLE study_results (
    result_id SERIAL PRIMARY KEY,
    outcome_id INT REFERENCES outcomes(outcome_id),
    ace_group_id INT REFERENCES ace_groups(ace_group_id),
    pce_type_id INT REFERENCES pce_types(pce_type_id),
    sex VARCHAR(6) NOT NULL,                     -- 'Male' or 'Female'
    pce_present BOOLEAN NOT NULL,
    aor NUMERIC(4,2),
    ci_low NUMERIC(4,2),
    ci_high NUMERIC(4,2),
    p_value NUMERIC(3,2)
);

INSERT INTO study_results
(outcome_id, ace_group_id, pce_type_id, sex, pce_present, aor, ci_low, ci_high, p_value)
VALUES
-- Strong mother–child relationship
(1, 2, 1, 'Female', TRUE, 0.70, 0.60, 0.90, 0.05),
(2, 2, 1, 'Female', TRUE, 0.60, 0.40, 0.90, 0.05),
(2, 2, 1, 'Male',   TRUE, 0.50, 0.20, 0.90, 0.05),
(3, 2, 1, 'Female', TRUE, 0.6, 0.4, 0.9, 0.05),
(3, 2, 1, 'Male',   TRUE, 0.70, 0.40, 1.20, NULL),

-- Strong father–child relationship
(1, 2, 2, 'Female', TRUE, 0.9, 0.6, 1.2, NULL),
(2, 2, 2, 'Female', TRUE, 0.8, 0.5, 1.3, NULL),
(2, 2, 2, 'Male',   TRUE, 0.40, 0.20, 0.70, 0.05),
(1, 2, 2, 'Female', TRUE, 0.90, 0.60, 1.70, NULL),
(3, 2, 2, 'Male',   TRUE, 0.60, 0.40, 0.80, 0.05),

-- High parental monitoring (Table 4)
(2, 2, 3, 'Female', TRUE, 1.1, 0.8, 1.2, NULL),
(2, 2, 3, 'Male', TRUE, 0.90, 0.50, 1.9, NULL),
(3, 2, 3, 'Female', TRUE, 0.9, 0.5, 1.4, NULL),
(3, 2, 3, 'Male', TRUE, 0.70, 0.50, 1.10, NULL),

-- High parental monitoring (Table 5 female stratified)
(1, 1, 3, 'Female', TRUE, 0.50, 0.30, 0.80, 0.05),
(1, 2, 3, 'Female', TRUE, 1.20, 0.80, 1.70, NULL);

SELECT * FROM study_results;


-- DATA QUERY ANALYSIS

-- Shows which PCEs have a statistically significant protective effect (p < 0.05 and aOR < 1) for people with 1+ ACEs:

SELECT 
    p.pce_name,
    o.outcome_name,
    sr.sex,
    COUNT(*) AS significant_cases,
    ROUND(AVG(sr.aor), 2) AS avg_aor
FROM study_results sr
JOIN pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN outcomes o ON sr.outcome_id = o.outcome_id
JOIN ace_groups ag ON sr.ace_group_id = ag.ace_group_id
WHERE ag.ace_group_label = '1+ ACEs'
  AND sr.p_value IS NOT NULL
  AND sr.p_value <= 0.05
  AND sr.aor < 1
GROUP BY p.pce_name, o.outcome_name, sr.sex
ORDER BY avg_aor ASC;


-- Gives an overview of how protective each PCE is on average for males vs. females:
SELECT 
    p.pce_name,
    sr.sex,
    ROUND(AVG(sr.aor), 2) AS avg_aor,
    MIN(sr.aor) AS min_aor,
    MAX(sr.aor) AS max_aor
FROM study_results sr
JOIN pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN ace_groups ag ON sr.ace_group_id = ag.ace_group_id
WHERE ag.ace_group_label = '1+ ACEs'
GROUP BY p.pce_name, sr.sex
ORDER BY avg_aor ASC;


-- Focus on one PCE and see its effects on all measured outcomes:
SELECT 
    o.outcome_name,
    sr.sex,
    ag.ace_group_label,
    sr.aor,
    sr.ci_low,
    sr.ci_high,
    sr.p_value
FROM study_results sr
JOIN pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN outcomes o ON sr.outcome_id = o.outcome_id
JOIN ace_groups ag ON sr.ace_group_id = ag.ace_group_id
WHERE p.pce_name = 'Strong mother–child relationship'
ORDER BY sr.sex, ag.ace_group_label, o.outcome_name;
----------------------------------------------------------------------------------
-- END of creation, data insert and queries for evaluation of whether — and which — PCEs moderate the association between ACEs and negative outcomes in SSA.
-- ===============================================================================




-- ==============================================================================
-- 2. Tables creation, data insert and queries for Always Available Adult (AAA) Support vs ACEs, Health-Harming Behaviors (HHBs), and Lower Mental Well-Being (LMWB) analysis 
-- Source: "Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences"; Table 1
------------------------------------------------------------------------------------

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

-- Deprivation quintiles
INSERT INTO resilience_factors.deprivation_outcomes VALUES
(1, 'Affluent', 1884, 26.7, 14.0, 9.4, 8.0, 5.7, 11.4),
(2, 'Quintile_2', 1409, 20.0, 17.8, 11.5, 6.3, 7.0, 14.8),
(3, 'Quintile_3', 1444, 20.5, 19.5, 14.2, 7.7, 10.0, 16.5),
(4, 'Quintile_4', 1403, 19.9, 19.5, 14.3, 8.1, 9.1, 17.2),
(5, 'Deprived', 907, 12.9, 30.8, 16.1, 8.9, 13.8, 20.8);

SELECT * FROM resilience_factors.deprivation_outcomes;


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

('Deprivation', 'Daily_smoking', 112.981, '<0.001', 4, TRUE),
('Deprivation', 'Poor_diet', 35.957, '<0.001', 4, TRUE),
('Deprivation', 'Heavy_drinking', 6.230, '0.183', 4, FALSE),
('Deprivation', 'Multiple_HHBs', 60.510, '<0.001', 4, TRUE),
('Deprivation', 'Lower_mental_wellbeing', 49.141, '<0.001', 4, TRUE),


SELECT * FROM resilience_factors.statistical_tests;

-- DATA QUERY ANALYSIS

-- ACE vs AAA Effects Comparison
SELECT 
    'ACE_Effects' as category,
    ace_count_category as group_label,
    multiple_hhbs_rate as value
FROM resilience_factors.ace_exposure_outcomes
UNION ALL
SELECT 
    'AAA_Effects' as category,
    CASE WHEN aaa_support_available THEN 'With_AAA' ELSE 'Without_AAA' END,
    multiple_hhbs_rate
FROM resilience_factors.aaa_support_outcomes;
-------------------------------------
-- END of tables creation, data insert and queries or Always Available Adult (AAA) Support vs ACEs, Health-Harming Behaviors (HHBs), and Lower Mental Well-Being (LMWB) analysis
-- ===============================================================================
