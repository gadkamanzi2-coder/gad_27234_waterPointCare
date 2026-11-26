
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 05_staging_load.sql
    Purpose      : Create a staging table for importing the
                   original Rwanda water-point dataset.

    Source       : water_points_rwanda_2021.xlsx
    Source rows  : 2,062
    Source fields: 39

    IMPORTANT:
    All source columns are VARCHAR2 so that the original
    values can be imported before data cleaning.
*/

SET ECHO ON;


/* 
   1. CREATE RAW STAGING TABLE
   */

CREATE TABLE STAGING_WATER_POINTS_RAW
(
    instance_id                         VARCHAR2(4000),
    source_date                         VARCHAR2(4000),
    unique_id                           VARCHAR2(4000),

    latitude                            VARCHAR2(4000),
    longitude                           VARCHAR2(4000),
    elevation                           VARCHAR2(4000),

    geo_level_1                         VARCHAR2(4000),
    geo_level_2                         VARCHAR2(4000),
    geo_level_3                         VARCHAR2(4000),
    geo_level_4                         VARCHAR2(4000),
    geo_level_5                         VARCHAR2(4000),
    geo_level_6                         VARCHAR2(4000),
    geo_level_7                         VARCHAR2(4000),

    level_of_service_score              VARCHAR2(4000),
    level_of_service                    VARCHAR2(4000),
    has_improved_water_point            VARCHAR2(4000),

    improved_technology                 VARCHAR2(4000),
    unimproved_technology               VARCHAR2(4000),

    functional_status                   VARCHAR2(4000),
    source_is_protected                 VARCHAR2(4000),

    number_of_users                     VARCHAR2(4000),
    users_meet_standards                VARCHAR2(4000),

    is_out_of_service_or_broken         VARCHAR2(4000),
    breakage_frequency_meets_standard   VARCHAR2(4000),
    breakage_days_meets_standard        VARCHAR2(4000),
    monthly_outage_meets_standard       VARCHAR2(4000),

    water_available_on_visit_day        VARCHAR2(4000),
    seconds_to_fill_20_litres           VARCHAR2(4000),
    piped_or_handpump                   VARCHAR2(4000),

    handpump_flow_rate                  VARCHAR2(4000),
    piped_litres_per_person_per_day     VARCHAR2(4000),

    quantity_meets_standards            VARCHAR2(4000),
    ecoli_meets_standard                VARCHAR2(4000),
    residual_chlorine_meets_standard    VARCHAR2(4000),
    bacteria_meets_standard             VARCHAR2(4000),

    other_contaminant_present           VARCHAR2(4000),
    other_contaminant_meets_standard    VARCHAR2(4000),

    water_quality_meets_standards       VARCHAR2(4000),
    overall_condition_is_good           VARCHAR2(4000)
)
TABLESPACE WATERPOINTCARE_DATA;


/* 
   2. VERIFY STAGING TABLE STRUCTURE
   */

DESC STAGING_WATER_POINTS_RAW;




PROMPT Raw staging table definition completed.
PROMPT Import the original Excel dataset using SQL Developer.
