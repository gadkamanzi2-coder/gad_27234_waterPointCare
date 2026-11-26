
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 07_load_tables.sql
    Purpose      : Transfer valid cleaned records into the
                   WATER_POINTS and WATER_POINT_ASSESSMENTS
                   tables.

    Source       : STAGING_WATER_POINTS_CLEAN
    Expected     : 2,061 valid water points and assessments.

    IMPORTANT:
    Run this script only after the tables, constraints,
    indexes, and staging data have been created and verified.
*/

SET ECHO ON;


/* 
   1. LOAD WATER POINTS
   */

/* Each valid Unique ID represents one water point.
   Instance Id is not used as a separate identifier because
   it duplicates Unique ID in the complete source records. */

INSERT INTO WATER_POINTS
(
    water_point_id,
    latitude,
    longitude,
    elevation,
    geo_level_1,
    geo_level_2,
    geo_level_3,
    geo_level_4,
    geo_level_5,
    geo_level_6,
    geo_level_7
)
SELECT DISTINCT
    TRIM(unique_id),

    TO_NUMBER(
        REPLACE(TRIM(latitude), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    TO_NUMBER(
        REPLACE(TRIM(longitude), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    TO_NUMBER(
        REPLACE(TRIM(elevation), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    geo_level_1,
    geo_level_2,
    geo_level_3,
    geo_level_4,
    geo_level_5,
    geo_level_6,
    geo_level_7

FROM STAGING_WATER_POINTS_CLEAN
WHERE row_quality_status = 'VALID';


/* 
   2. LOAD WATER POINT ASSESSMENTS
    */

/* Assessment IDs are generated automatically by Oracle.
   Every assessment is connected to its water point through
   water_point_id. */

INSERT INTO WATER_POINT_ASSESSMENTS
(
    water_point_id,
    assessment_date,
    level_of_service_score,
    level_of_service,
    has_improved_water_point,
    improved_technology,
    unimproved_technology,

    is_functional,
    is_source_protected,

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
    overall_condition_is_good
)
SELECT
    TRIM(unique_id),

    /* Support Excel serial dates and common date strings. */
    CASE
        WHEN REGEXP_LIKE(
            TRIM(source_date),
            '^[0-9]+(\.[0-9]+)?$'
        )
        THEN
            DATE '1899-12-30'
            + TO_NUMBER(
                TRIM(source_date)
                DEFAULT NULL ON CONVERSION ERROR
            )

        WHEN REGEXP_LIKE(
            TRIM(source_date),
            '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
        )
        THEN
            TO_DATE(
                SUBSTR(TRIM(source_date), 1, 10)
                DEFAULT NULL ON CONVERSION ERROR,
                'YYYY-MM-DD'
            )

        WHEN REGEXP_LIKE(
            TRIM(source_date),
            '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
        )
        THEN
            TO_DATE(
                TRIM(source_date)
                DEFAULT NULL ON CONVERSION ERROR,
                'MM/DD/YYYY'
            )

        ELSE NULL
    END,

    TO_NUMBER(
        REPLACE(TRIM(level_of_service_score), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    level_of_service,
    has_improved_water_point,
    improved_technology,
    unimproved_technology,

    /* Convert source indicators into Y/N values. */
    CASE
        WHEN UPPER(TRIM(functional_status))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(functional_status))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(source_is_protected))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(source_is_protected))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    TO_NUMBER(
        REPLACE(TRIM(number_of_users), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    CASE
        WHEN UPPER(TRIM(users_meet_standards))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(users_meet_standards))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(is_out_of_service_or_broken))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(is_out_of_service_or_broken))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(breakage_frequency_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(breakage_frequency_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(breakage_days_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(breakage_days_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(monthly_outage_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(monthly_outage_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(water_available_on_visit_day))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(water_available_on_visit_day))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    TO_NUMBER(
        REPLACE(TRIM(seconds_to_fill_20_litres), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    piped_or_handpump,

    TO_NUMBER(
        REPLACE(TRIM(handpump_flow_rate), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    TO_NUMBER(
        REPLACE(TRIM(piped_litres_per_person_per_day), ',', '')
        DEFAULT NULL ON CONVERSION ERROR
    ),

    CASE
        WHEN UPPER(TRIM(quantity_meets_standards))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(quantity_meets_standards))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(ecoli_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(ecoli_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(residual_chlorine_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(residual_chlorine_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(bacteria_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(bacteria_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(other_contaminant_present))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(other_contaminant_present))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(other_contaminant_meets_standard))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(other_contaminant_meets_standard))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(water_quality_meets_standards))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(water_quality_meets_standards))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END,

    CASE
        WHEN UPPER(TRIM(overall_condition_is_good))
             IN ('1', 'YES', 'Y', 'TRUE') THEN 'Y'
        WHEN UPPER(TRIM(overall_condition_is_good))
             IN ('0', 'NO', 'N', 'FALSE') THEN 'N'
        ELSE NULL
    END

FROM STAGING_WATER_POINTS_CLEAN
WHERE row_quality_status = 'VALID';


/* 
   3. COMMIT THE LOADED DATA
    */

COMMIT;


/* 
   4. VERIFY LOADED RECORD COUNTS
   */

PROMPT Water point records loaded:

SELECT COUNT(*) AS total_water_points
FROM WATER_POINTS;

PROMPT Water point assessments loaded:

SELECT COUNT(*) AS total_assessments
FROM WATER_POINT_ASSESSMENTS;


/* 
   5. VERIFY ASSESSMENT RELATIONSHIPS
   */

SELECT
    COUNT(*) AS assessments_without_water_point
FROM WATER_POINT_ASSESSMENTS a
LEFT JOIN WATER_POINTS w
    ON a.water_point_id = w.water_point_id
WHERE w.water_point_id IS NULL;


/* 
   END OF SCRIPT
 */

PROMPT Final water point data loading completed.
