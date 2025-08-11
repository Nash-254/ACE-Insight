-- ===============================================================================
-- POSTGRESQL RESILIENCE FACTORS SCHEMA CREATION 
-- ==============================================================================
CREATE SCHEMA IF NOT EXISTS resilience_factors;
SET search_path TO resilience_factors, public;

-- ==============================================================================
-- 1. Tables creation, data insert and queries for evaluation of whether — and which — PCEs moderate the association between ACEs and negative outcomes analysis. 
-- Source: "Parenting-related positive childhood experiences, adverse childhood experiences, and mental health—Four sub-Saharan African countries"; Table 4 and 5
------------------------------------------------------------------------------------
--TABLES CREATION
-- Outcomes Table
CREATE TABLE resilience_factors.outcomes (
    outcome_id SERIAL PRIMARY KEY,
    outcome_name VARCHAR(100) NOT NULL
);

-- ACE Groups Table
CREATE TABLE resilience_factors.ace_groups (
    ace_group_id SERIAL PRIMARY KEY,
    ace_group_label VARCHAR(20) UNIQUE NOT NULL  -- e.g., '0 ACEs', '1+ ACEs'
);

-- PCE Types Table
CREATE TABLE resilience_factors.pce_types (
    pce_type_id SERIAL PRIMARY KEY,
    pce_name VARCHAR(100) NOT NULL
);

-- Study Results Table
CREATE TABLE resilience_factors.study_results (
    result_id SERIAL PRIMARY KEY,
    outcome_id INT REFERENCES resilience_factors.outcomes(outcome_id),
    ace_group_id INT REFERENCES resilience_factors.ace_groups(ace_group_id),
    pce_type_id INT REFERENCES resilience_factors.pce_types(pce_type_id),
    sex VARCHAR(6) NOT NULL,                     -- 'Male' or 'Female'
    pce_present BOOLEAN NOT NULL,
    aor NUMERIC(4,2),
    ci_low NUMERIC(4,2),
    ci_high NUMERIC(4,2),
    p_value NUMERIC(3,2)
);

-- DATA INSERTS
INSERT INTO resilience_factors.outcomes (outcome_name) VALUES
('Mental distress'), 
('Suicidal/self-harm'), 
('Substance use');

INSERT INTO resilience_factors.ace_groups (ace_group_label) VALUES
('0 ACEs'), 
('1+ ACEs');

INSERT INTO resilience_factors.pce_types (pce_name) VALUES
('Strong mother–child relationship'),
('Strong father–child relationship'),
('High parental monitoring');

INSERT INTO resilience_factors.study_results
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

-- VERIFY DATA INTEGRITY
SELECT * FROM resilience_factors.outcomes;
SELECT * FROM resilience_factors.ace_groups;        
SELECT * FROM resilience_factors.pce_types;
SELECT * FROM resilience_factors.study_results;

----------------------------------------------------------------------------------
-- DATA QUERY ANALYSIS
-- MAIN QUERY
-- Shows which PCEs have a statistically significant protective effect (p < 0.05 and aOR < 1) for people with 1+ ACEs
SELECT 
    p.pce_name,
    o.outcome_name,
    sr.sex,
    COUNT(*) AS significant_cases,
    ROUND(AVG(sr.aor), 2) AS avg_aor
FROM resilience_factors.study_results sr
JOIN resilience_factors.pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN resilience_factors.outcomes o ON sr.outcome_id = o.outcome_id
JOIN resilience_factors.ace_groups ag ON sr.ace_group_id = ag.ace_group_id
WHERE ag.ace_group_label = '1+ ACEs'
  AND sr.p_value IS NOT NULL
  AND sr.p_value <= 0.05
  AND sr.aor < 1
GROUP BY p.pce_name, o.outcome_name, sr.sex
ORDER BY avg_aor ASC;

--- BONUS QUERIES
-- Gives an overview of how protective each PCE is on average for males vs. females:
SELECT 
    p.pce_name,
    sr.sex,
    ROUND(AVG(sr.aor), 2) AS avg_aor,
    MIN(sr.aor) AS min_aor,
    MAX(sr.aor) AS max_aor
FROM resilience_factors.study_results sr
JOIN resilience_factors.pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN resilience_factors.ace_groups ag ON sr.ace_group_id = ag.ace_group_id
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
FROM resilience_factors.study_results sr
JOIN resilience_factors.pce_types p ON sr.pce_type_id = p.pce_type_id
JOIN resilience_factors.outcomes o ON sr.outcome_id = o.outcome_id
JOIN ace_groups ag ON sr.ace_group_id = ag.ace_group_id
WHERE p.pce_name = 'Strong mother–child relationship'
ORDER BY sr.sex, ag.ace_group_label, o.outcome_name;
----------------------------------------------------------------------------------
-- END of tables creation, data insert and queries for evaluation of whether — and which — PCEs moderate the association between ACEs and negative outcomes analysis.
-- ===============================================================================



-- ==============================================================================
-- 2. Tables creation, data insert and queries for Always Available Adult (AAA) Support vs ACEs, Health-Harming Behaviors (HHBs), and Lower Mental Well-Being (LMWB) analysis.
-- Source: "Does continuous trusted adult support in childhood impart life-course resilience against adverse childhood experiences"; Table 1
------------------------------------------------------------------------------------
--TABLES CREATION
-- ACE Count Table
CREATE TABLE resilience_factors.ace_count(
    id SERIAL PRIMARY KEY,
    ace_count TEXT,           -- '0', '1', '2-3', '4+'
    n INT,
    daily_smoking NUMERIC(4,1),
    low_fruitveg NUMERIC(4,1),
    weekly_heavy_drinking NUMERIC(4,1),
    two_plus_hhb NUMERIC(4,1),  -- health-harming behaviours
    low_mental_wellbeing NUMERIC(4,1)
);

-- AAA Support Table
CREATE TABLE resilience_factors.aaa_support(
    id SERIAL PRIMARY KEY,
    aaa_support BOOLEAN,      -- TRUE = Yes, FALSE = No
    n INT,
    daily_smoking NUMERIC(4,1),
    low_fruitveg NUMERIC(4,1),
    weekly_heavy_drinking NUMERIC(4,1),
    two_plus_hhb NUMERIC(4,1),  -- health-harming behaviours
    low_mental_wellbeing NUMERIC(4,1)
);

-- DATA INSERTS
INSERT INTO resilience_factors.ace_count
(ace_count, n, daily_smoking, low_fruitveg, weekly_heavy_drinking, two_plus_hhb, low_mental_wellbeing)
VALUES
-- ACE count
('0', 3964, 14.1, 10.5, 5.7, 5.6, 11.5),
('1', 1271, 18.3, 13.5, 8.3, 8.5, 14.2),
('2-3', 1086, 22.3, 13.0, 9.4, 9.8, 18.1),
('4+', 726, 43.4, 22.3, 15.6, 22.9, 35.4);

-- AAA support
INSERT INTO resilience_factors.aaa_support 
(aaa_support, n, daily_smoking, low_fruitveg, weekly_heavy_drinking, two_plus_hhb, low_mental_wellbeing)
VALUES
(TRUE, 3273, 16.0, 9.8, 7.1, 6.2, 9.0),
(FALSE, 3774, 21.9, 15.1, 8.3, 10.5, 21.1);

-- VERIFY DATA INTEGRITY
SELECT * FROM resilience_factors.ace_count;
SELECT * FROM resilience_factors.aaa_support;

---------------------------------------------------------------------------------------
-- DATA QUERY ANALYSIS
-- ACE Count vs outcomes
SELECT
    CASE ace_count
        WHEN '0' THEN 0
        WHEN '1' THEN 1
        WHEN '2-3' THEN 2.5
        WHEN '4+' THEN 4
    END AS group_num,
    ace_count AS group_label,
    outcome,
    percentage
FROM resilience_factors.ace_count
CROSS JOIN LATERAL (
    VALUES
        ('daily_smoking', daily_smoking),
        ('low_fruitveg', low_fruitveg),
        ('weekly_heavy_drinking', weekly_heavy_drinking),
        ('two_plus_hhb', two_plus_hhb),
        ('low_mental_wellbeing', low_mental_wellbeing)
) AS v(outcome, percentage)
ORDER BY group_num, outcome;


-- AAA Support vs outcomes
SELECT
    CASE aaa_support WHEN TRUE THEN 1 WHEN FALSE THEN 0 END AS group_num,
    CASE aaa_support WHEN TRUE THEN 'Yes' WHEN FALSE THEN 'No' END AS group_label,
    outcome,
    percentage
FROM resilience_factors.aaa_support
CROSS JOIN LATERAL (
    VALUES
        ('daily_smoking', daily_smoking),
        ('low_fruitveg', low_fruitveg),
        ('weekly_heavy_drinking', weekly_heavy_drinking),
        ('two_plus_hhb', two_plus_hhb),
        ('low_mental_wellbeing', low_mental_wellbeing)
) AS v(outcome, percentage)
ORDER BY group_num DESC, outcome;
----------------------------------------------------------------------------------
-- END of tables creation, data insert and queries for Always Available Adult (AAA) Support vs ACEs, Health-Harming Behaviors (HHBs), and Lower Mental Well-Being (LMWB) analysis
-- ===============================================================================


SELECT 
    CASE ace_count
        WHEN '0' THEN 0
        WHEN '1' THEN 1
        WHEN '2-3' THEN 2.5
        WHEN '4+' THEN 4
    END AS group_num,
    ace_count AS group_label,
    'ACE_Count' AS category,
    outcome,
    percentage
FROM ace_count
CROSS JOIN LATERAL (
    VALUES
        ('daily_smoking', daily_smoking),
        ('low_fruitveg', low_fruitveg),
        ('weekly_heavy_drinking', weekly_heavy_drinking),
        ('two_plus_hhb', two_plus_hhb),
        ('low_mental_wellbeing', low_mental_wellbeing)
) AS v(outcome, percentage)

UNION ALL

SELECT 
    CASE aaa_support WHEN TRUE THEN 1 WHEN FALSE THEN 0 END AS group_num,
    CASE aaa_support WHEN TRUE THEN 'Yes' WHEN FALSE THEN 'No' END AS group_label,
    'AAA_Support' AS category,
    outcome,
    percentage
FROM aaa_support
CROSS JOIN LATERAL (
    VALUES
        ('daily_smoking', daily_smoking),
        ('low_fruitveg', low_fruitveg),
        ('weekly_heavy_drinking', weekly_heavy_drinking),
        ('two_plus_hhb', two_plus_hhb),
        ('low_mental_wellbeing', low_mental_wellbeing)
) AS v(outcome, percentage)
ORDER BY outcome, category, group_num;



