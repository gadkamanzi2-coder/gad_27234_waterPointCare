
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 06_clean.sql
    Purpose      : Clean and standardize staging data,
                   identify incomplete records, and
                   prepare records for final loading.

    IMPORTANT:
    The original staging table is not modified.
*/

SET ECHO ON;

/* 
   1. CREATE CLEANED STAGING TABLE
   */

CREATE TABLE STAGING_WATER_POINTS_CLEAN AS
WITH NORMALIZED_DATA AS
(
    SELECT
        TRIM(instance_id) AS instance_id,
        TRIM(source_date) AS source_date,
        TRIM(unique_id) AS unique_id,

        TRIM(latitude) AS latitude,
        TRIM(longitude) AS longitude,
        TRIM(elevation) AS elevation,

        TRIM(geo_level_1) AS geo_level_1,
        TRIM(geo_level_2) AS geo_level_2,
        TRIM(geo_level_3) AS geo_level_3,
        TRIM(geo_level_4) AS geo_level_4,
        TRIM(geo_level_5) AS geo_level_5,
        TRIM(geo_level_6) AS geo_level_6,
        TRIM(geo_level_7) AS geo_level_7,

        TRIM(level_of_service_score)
            AS level_of_service_score,

        TRIM(level_of_service) AS level_of_service,

        TRIM(has_improved_water_point)
            AS has_improved_water_point,

        TRIM(improved_technology) AS improved_technology,
        TRIM(unimproved_technology) AS unimproved_technology,

        TRIM(functional_status) AS functional_status,
        TRIM(source_is_protected) AS source_is_protected,

        TRIM(number_of_users) AS number_of_users,
        TRIM(users_meet_standards) AS users_meet_standards,

        TRIM(is_out_of_service_or_broken)
            AS is_out_of_service_or_broken,

        TRIM(breakage_frequency_meets_standard)
            AS breakage_frequency_meets_standard,

        TRIM(breakage_days_meets_standard)
            AS breakage_days_meets_standard,

        TRIM(monthly_outage_meets_standard)
            AS monthly_outage_meets_standard,

        TRIM(water_available_on_visit_day)
            AS water_available_on_visit_day,

        TRIM(seconds_to_fill_20_litres)
            AS seconds_to_fill_20_litres,

        TRIM(piped_or_handpump) AS piped_or_handpump,

        TRIM(handpump_flow_rate) AS handpump_flow_rate,

        TRIM(piped_litres_per_person_per_day)
            AS piped_litres_per_person_per_day,

        TRIM(quantity_meets_standards)
            AS quantity_meets_standards,

        TRIM(ecoli_meets_standard) AS ecoli_meets_standard,

        TRIM(residual_chlorine_meets_standard)
            AS residual_chlorine_meets_standard,

        TRIM(bacteria_meets_standard)
            AS bacteria_meets_standard,

        CASE
            WHEN LOWER(TRIM(other_contaminant_present)) = 'yes'
            THEN 'Yes'
            ELSE TRIM(other_contaminant_present)
        END AS other_contaminant_present,

        TRIM(other_contaminant_meets_standard)
            AS other_contaminant_meets_standard,

        TRIM(water_quality_meets_standards)
            AS water_quality_meets_standards,

        TRIM(overall_condition_is_good)
            AS overall_condition_is_good

    FROM STAGING_WATER_POINTS_RAW
),
CHECKED_DATA AS
(
    SELECT
        n.*,
        COUNT(n.unique_id) OVER
            (PARTITION BY n.unique_id) AS id_occurrences
    FROM NORMALIZED_DATA n
)
SELECT
    instance_id,
    source_date,
    unique_id,

    latitude,
    longitude,
    elevation,

    geo_level_1,
    geo_level_2,
    geo_level_3,
    geo_level_4,
    geo_level_5,
    geo_level_6,
    geo_level_7,

    level_of_service_score,
    level_of_service,
    has_improved_water_point,

    improved_technology,
    unimproved_technology,

    functional_status,
    source_is_protected,

    number_of_users,
    users_meet_standards,

    is_out_of_service_or_broken,
    breakage_frequency_meets_standard,
    breakage_days_meets_standard,
    monthly_outage_meets_standard,

    water_available_on_visit_day,
    seconds_to_fill_20_litres,
    piped_or_handpump,

    handpump_flow_rate,
    piped_litres_per_person_per_day,

    quantity_meets_standards,
    ecoli_meets_standard,
    residual_chlorine_meets_standard,
    bacteria_meets_standard,

    other_contaminant_present,
    other_contaminant_meets_standard,

    water_quality_meets_standards,
    overall_condition_is_good,

    CASE
        WHEN unique_id IS NULL
            THEN 'INVALID: MISSING UNIQUE ID'

        WHEN source_date IS NULL
            THEN 'INVALID: MISSING DATE'

        WHEN id_occurrences > 1
            THEN 'INVALID: DUPLICATE UNIQUE ID'

        ELSE 'VALID'
    END AS row_quality_status

FROM CHECKED_DATA;


/* 
   2. CHECK ORIGINAL AND CLEANED ROW COUNTS
    */

PROMPT Original staging row count:

SELECT COUNT(*) AS original_rows
FROM STAGING_WATER_POINTS_RAW;

PROMPT Cleaned staging row count:

SELECT COUNT(*) AS cleaned_rows
FROM STAGING_WATER_POINTS_CLEAN;


/* 
   3. CHECK RECORD QUALITY
   */

PROMPT Records grouped by quality status:

SELECT
    row_quality_status,
    COUNT(*) AS total_records
FROM STAGING_WATER_POINTS_CLEAN
GROUP BY row_quality_status
ORDER BY row_quality_status;


/* 
   4. CHECK MISSING IDENTIFIERS AND DATES
    */

SELECT
    COUNT(*) AS missing_unique_ids
FROM STAGING_WATER_POINTS_CLEAN
WHERE unique_id IS NULL;

SELECT
    COUNT(*) AS missing_dates
FROM STAGING_WATER_POINTS_CLEAN
WHERE source_date IS NULL;


/* 
   5. CHECK DUPLICATE IDENTIFIERS
    */

SELECT
    unique_id,
    COUNT(*) AS occurrences
FROM STAGING_WATER_POINTS_CLEAN
WHERE unique_id IS NOT NULL
GROUP BY unique_id
HAVING COUNT(*) > 1;


/* 
   6. VERIFY SPELLING STANDARDIZATION
   */

SELECT
    other_contaminant_present,
    COUNT(*) AS total_records
FROM STAGING_WATER_POINTS_CLEAN
GROUP BY other_contaminant_present
ORDER BY other_contaminant_present;


/* 
   7. END OF SCRIPT
  */

PROMPT Data cleaning and quality checks completed.
PROMPT Original staging data has been preserved.
