
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 04_views.sql
    Purpose      : Create reporting, summary, and read-only views.
*/

SET ECHO ON;

/* 
   1. REPORTING VIEW
    */

/* Combines water point, fault report, repair job,
   and maintenance team information. */

CREATE OR REPLACE VIEW vw_fault_repair_report AS
SELECT
    wp.water_point_id,
    wp.geo_level_1,
    wp.geo_level_2,
    wp.geo_level_3,
    fr.fault_report_id,
    fr.report_date,
    fr.fault_category,
    fr.priority,
    fr.status AS fault_status,
    rj.repair_job_id,
    rj.repair_status,
    rj.repair_cost,
    mt.team_name,
    mt.team_leader
FROM WATER_POINTS wp
JOIN FAULT_REPORTS fr
    ON wp.water_point_id = fr.water_point_id
LEFT JOIN REPAIR_JOBS rj
    ON fr.fault_report_id = rj.fault_report_id
LEFT JOIN MAINTENANCE_TEAMS mt
    ON rj.team_id = mt.team_id;


/* 
   2. SUMMARY VIEW
    */

/* Counts fault reports grouped by their status
   and priority. Useful for operational reporting. */

CREATE OR REPLACE VIEW vw_fault_status_summary AS
SELECT
    status,
    priority,
    COUNT(*) AS total_fault_reports
FROM FAULT_REPORTS
GROUP BY status, priority;


/* 
   3. PROTECTED READ-ONLY VIEW
   */

/* Provides basic water point location information.
   WITH READ ONLY prevents INSERT, UPDATE, and DELETE
   operations through this view. */

CREATE OR REPLACE VIEW vw_water_point_directory AS
SELECT
    water_point_id,
    latitude,
    longitude,
    geo_level_1,
    geo_level_2,
    geo_level_3,
    geo_level_4,
    geo_level_5,
    geo_level_6,
    geo_level_7
FROM WATER_POINTS
WITH READ ONLY;


/* 
   END OF SCRIPT
    */

PROMPT All three WaterPointCare views have been created.

