
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 10_validation.sql
    Purpose      : Validate data loading, relationships,
                   constraints, and project views.

    IMPORTANT:
    Run after all required tables, data, and views
    have been created and populated.
*/

SET ECHO ON;


/*
   1. VERIFY CURRENT DATABASE AND USER
*/

PROMPT Current database:

SELECT
    SYS_CONTEXT('USERENV', 'DB_NAME') AS database_name,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS container_name,
    USER AS current_user
FROM DUAL;


/*
   2. VERIFY RECORD COUNTS
*/

PROMPT Original staging records:

SELECT COUNT(*) AS raw_records
FROM STAGING_WATER_POINTS_RAW;

PROMPT Cleaned staging records:

SELECT COUNT(*) AS cleaned_records
FROM STAGING_WATER_POINTS_CLEAN;

PROMPT Valid staging records:

SELECT COUNT(*) AS valid_records
FROM STAGING_WATER_POINTS_CLEAN
WHERE row_quality_status = 'VALID';

PROMPT Invalid staging records:

SELECT COUNT(*) AS invalid_records
FROM STAGING_WATER_POINTS_CLEAN
WHERE row_quality_status IS NULL
   OR row_quality_status <> 'VALID';

PROMPT Final water points:

SELECT COUNT(*) AS total_water_points
FROM WATER_POINTS;

PROMPT Final assessments:

SELECT COUNT(*) AS total_assessments
FROM WATER_POINT_ASSESSMENTS;


/*
   3. COMPARE VALID STAGING RECORDS WITH FINAL TABLES
*/

SELECT
    (SELECT COUNT(*)
     FROM STAGING_WATER_POINTS_CLEAN
     WHERE row_quality_status = 'VALID')
        AS valid_staging_records,

    (SELECT COUNT(*)
     FROM WATER_POINTS)
        AS loaded_water_points,

    (SELECT COUNT(*)
     FROM WATER_POINT_ASSESSMENTS)
        AS loaded_assessments
FROM DUAL;


/*
   4. CHECK ORPHAN ASSESSMENTS

   An orphan assessment references a water point
   that does not exist. Expected result: 0.
*/

SELECT
    COUNT(*) AS orphan_assessments
FROM WATER_POINT_ASSESSMENTS a
LEFT JOIN WATER_POINTS w
    ON a.water_point_id = w.water_point_id
WHERE w.water_point_id IS NULL;


/*
   5. CHECK DUPLICATE WATER POINT IDENTIFIERS
*/

SELECT
    water_point_id,
    COUNT(*) AS occurrences
FROM WATER_POINTS
GROUP BY water_point_id
HAVING COUNT(*) > 1;


/*
   CHECK VALID STAGING RECORDS NOT LOADED

   Expected result after successful loading: 0.
*/

SELECT
    COUNT(*) AS valid_records_not_loaded
FROM STAGING_WATER_POINTS_CLEAN s
WHERE s.row_quality_status = 'VALID'
  AND NOT EXISTS
  (
      SELECT 1
      FROM WATER_POINTS w
      WHERE w.water_point_id = TRIM(s.unique_id)
  );


/*
   6. CHECK REQUIRED VALUES
*/

SELECT
    COUNT(*) AS missing_water_point_ids
FROM WATER_POINTS
WHERE water_point_id IS NULL;

SELECT
    COUNT(*) AS missing_assessment_ids
FROM WATER_POINT_ASSESSMENTS
WHERE assessment_id IS NULL;

SELECT
    COUNT(*) AS missing_assessment_dates
FROM WATER_POINT_ASSESSMENTS
WHERE assessment_date IS NULL;

SELECT
    COUNT(*) AS missing_assessment_water_point_ids
FROM WATER_POINT_ASSESSMENTS
WHERE water_point_id IS NULL;


/*
   7. CHECK GEOGRAPHICAL DATA
*/

SELECT
    COUNT(*) AS invalid_latitudes
FROM WATER_POINTS
WHERE latitude IS NOT NULL
  AND (latitude < -90 OR latitude > 90);

SELECT
    COUNT(*) AS invalid_longitudes
FROM WATER_POINTS
WHERE longitude IS NOT NULL
  AND (longitude < -180 OR longitude > 180);


/*
   8. CHECK FOREIGN KEY RELATIONSHIPS
*/

PROMPT Checking foreign-key relationships:

SELECT
    'WATER_POINT_ASSESSMENTS' AS child_table,
    'WATER_POINTS' AS parent_table,
    COUNT(*) AS orphan_records
FROM WATER_POINT_ASSESSMENTS a
WHERE NOT EXISTS
(
    SELECT 1
    FROM WATER_POINTS w
    WHERE w.water_point_id = a.water_point_id
)

UNION ALL

SELECT
    'FAULT_REPORTS',
    'WATER_POINTS',
    COUNT(*)
FROM FAULT_REPORTS fr
WHERE NOT EXISTS
(
    SELECT 1
    FROM WATER_POINTS w
    WHERE w.water_point_id = fr.water_point_id
)

UNION ALL

SELECT
    'REPAIR_JOBS',
    'FAULT_REPORTS',
    COUNT(*)
FROM REPAIR_JOBS rj
WHERE NOT EXISTS
(
    SELECT 1
    FROM FAULT_REPORTS fr
    WHERE fr.fault_report_id = rj.fault_report_id
)

UNION ALL

SELECT
    'REPAIR_JOBS',
    'MAINTENANCE_TEAMS',
    COUNT(*)
FROM REPAIR_JOBS rj
WHERE rj.team_id IS NOT NULL
  AND NOT EXISTS
(
    SELECT 1
    FROM MAINTENANCE_TEAMS mt
    WHERE mt.team_id = rj.team_id
)

UNION ALL

SELECT
    'REPAIR_PART_USAGE',
    'REPAIR_JOBS',
    COUNT(*)
FROM REPAIR_PART_USAGE u
WHERE NOT EXISTS
(
    SELECT 1
    FROM REPAIR_JOBS rj
    WHERE rj.repair_job_id = u.repair_job_id
)

UNION ALL

SELECT
    'REPAIR_PART_USAGE',
    'SPARE_PARTS',
    COUNT(*)
FROM REPAIR_PART_USAGE u
WHERE NOT EXISTS
(
    SELECT 1
    FROM SPARE_PARTS sp
    WHERE sp.part_id = u.part_id
)

UNION ALL

SELECT
    'STATUS_AUDIT_LOG',
    'FAULT_REPORTS',
    COUNT(*)
FROM STATUS_AUDIT_LOG al
WHERE NOT EXISTS
(
    SELECT 1
    FROM FAULT_REPORTS fr
    WHERE fr.fault_report_id = al.fault_report_id
);


/*
   9. VERIFY ALL CONSTRAINTS
*/

PROMPT Constraint status:

SELECT
    table_name,
    constraint_name,
    constraint_type,
    status,
    validated
FROM USER_CONSTRAINTS
WHERE table_name IN
(
    'WATER_POINTS',
    'WATER_POINT_ASSESSMENTS',
    'FAULT_REPORTS',
    'MAINTENANCE_TEAMS',
    'REPAIR_JOBS',
    'SPARE_PARTS',
    'REPAIR_PART_USAGE',
    'STATUS_AUDIT_LOG'
)
ORDER BY table_name, constraint_type, constraint_name;


/*
   Show any constraints that are not enabled or validated.
   Expected result: no rows.
*/

SELECT
    table_name,
    constraint_name,
    status,
    validated
FROM USER_CONSTRAINTS
WHERE table_name IN
(
    'WATER_POINTS',
    'WATER_POINT_ASSESSMENTS',
    'FAULT_REPORTS',
    'MAINTENANCE_TEAMS',
    'REPAIR_JOBS',
    'SPARE_PARTS',
    'REPAIR_PART_USAGE',
    'STATUS_AUDIT_LOG'
)
AND
(
    status <> 'ENABLED'
    OR validated <> 'VALIDATED'
);


/*
   10. TEST REPORTING VIEW
*/

SELECT *
FROM vw_fault_repair_report
FETCH FIRST 10 ROWS ONLY;


/*
   11. TEST SUMMARY VIEW
*/

SELECT *
FROM vw_fault_status_summary
ORDER BY status, priority;


/*
   12. TEST READ-ONLY DIRECTORY VIEW
*/

SELECT *
FROM vw_water_point_directory
FETCH FIRST 10 ROWS ONLY;


/*
   13. SUMMARY BY GEOGRAPHICAL AREA
*/

SELECT
    geo_level_2 AS district,
    COUNT(*) AS total_water_points
FROM WATER_POINTS
GROUP BY geo_level_2
ORDER BY total_water_points DESC;


/*
   14. ASSESSMENT SUMMARY
*/

SELECT
    level_of_service,
    COUNT(*) AS total_assessments
FROM WATER_POINT_ASSESSMENTS
GROUP BY level_of_service
ORDER BY total_assessments DESC;


PROMPT WaterPointCare validation checks completed.
