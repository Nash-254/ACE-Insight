-- ===============================================================================
-- POSTGRESQL ACE PREVALENCE SCHEMA CREATION 
-- ===============================================================================
CREATE SCHEMA IF NOT EXISTS ace_prevalence;
SET search_path TO ace_prevalence, public;

-- ============================================================================
-- Table creation, data insert and queries for ACE Prevalence % by Region
-- Based on various global surveys and studies
-------------------------------------------------------------------------------

CREATE TABLE ace_prevalence.ace_prevalence_by_region (
    id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    continent VARCHAR(50),
    ace_prevalence_percent DECIMAL(5,2),
    population_group VARCHAR(100),
    data_source TEXT,
    year INT
);


INSERT INTO ace_prevalence.ace_prevalence_by_region 
(region_name, continent, ace_prevalence_percent, population_group, data_source, year)
VALUES 
-- Africa
('South Africa', 'Africa', 88.00, 'Young adults (18–24)', 'UNICEF and CDC Report on Sub-Saharan Africa', 2019),
('Kenya', 'Africa', 79.00, 'Adolescents aged 13–24', 'CDC VACS - Kenya', 2010),
('Nigeria', 'Africa', 70.50, 'University students', 'Nigerian Journal of Psychiatry - ACEs Survey', 2017),
('Zambia', 'Africa', 75.00, 'Young adults (18–24)', 'CDC VACS - Zambia', 2014),

-- North America
('United States', 'North America', 61.00, 'General adult population', 'CDC Behavioral Risk Factor Surveillance System (BRFSS)', 2019),
('Canada', 'North America', 66.00, 'Adults (18–64)', 'Canadian Community Health Survey (CCHS)', 2014),

-- South America
('Colombia', 'South America', 69.00, 'Young adults (18–24)', 'UNICEF and CDC Violence Against Children Survey (VACS)', 2019),
('Brazil', 'South America', 63.00, 'University students', 'Brazilian Journal of Psychiatry - ACE Study', 2016),

-- Europe
('Germany', 'Europe', 37.00, 'Adults aged 18–65', 'European ACE Study - Germany Arm', 2014),
('Hungary', 'Europe', 49.00, 'General adult population', 'ACE International Questionnaire (ACE-IQ) Hungary Study', 2018),
('United Kingdom','Europe' , 54.00, 'General population', 'Public Health England, Bellis et al.', 2015),
('Ireland', 'Europe', 57.60, 'Young adults aged 20', 'Growing Up in Ireland cohort study (GUI)', 2024),

-- Asia
('India', 'Asia', 41.40, 'University students', 'National Mental Health Survey India', 2016),
('Philippines', 'Asia', 80.00, 'Young adults (18–24)', 'UNICEF Philippines National Baseline Study', 2016),
('China', 'Asia', 56.80, 'Rural adults aged 18–45', 'Journal of Affective Disorders - ACE China Study', 2017),
('Pakistan', 'Asia', 64.00, 'General population', 'BMC Public Health - Pakistan ACE Study', 2018),

-- Oceania
('Australia', 'Oceania', 56.00, 'General adult population', 'Australian Child Maltreatment Study', 2023),
('New Zealand', 'Oceania', 62.00, 'Adults aged 18–64', 'New Zealand Family Violence Clearinghouse', 2019);

INSERT INTO ace_prevalence.ace_prevalence_by_region 
(region_name, continent, ace_prevalence_percent, population_group, data_source, year)
VALUES 

('Namibia', 'Africa', 68.00, 'Adolescents & young adults (VACS)', 'Namibia VACS / national reports', 2019),
('Russia', 'Europe', 84.60, 'Young adults / higher education sample', 'WHO / national ACE survey (Kachaeva et al.)', 2004),
('Uganda', 'Africa', 72.00, 'Adolescents & young adults (VACS)', 'Uganda VACS / national reports', 2015),
('Malawi', 'Africa', 74.00, 'Adolescents & young adults (VACS)', 'Malawi VACS / national reports', 2013),
('Mozambique', 'Africa', 70.00, 'Adolescents & young adults', 'Mozambique VACS / national studies', 2019),
('Lesotho', 'Africa', 80.00, 'Adolescents & young adults (VACS)', 'Lesotho VACS / national reports', 2019);

SELECT * FROM ace_prevalence.ace_prevalence_by_region;
----------------------------------------------------------------------------------
-- END of creation, data insert and queries for ACE Prevalence % by Region
-- ===============================================================================