
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 03_indexes.sql
    Purpose      : Create indexes to improve database query
                   performance and foreign-key operations.
*/

SET ECHO ON;


/* 
   1. FOREIGN KEY INDEXES
   */

/* Assessments searched by water point. */
CREATE INDEX idx_assess_water_point
ON WATER_POINT_ASSESSMENTS (water_point_id)
TABLESPACE WATERPOINTCARE_IDX;


/* Fault reports searched by water point. */
CREATE INDEX idx_fault_water_point
ON FAULT_REPORTS (water_point_id)
TABLESPACE WATERPOINTCARE_IDX;


/* Repair jobs searched by fault report. */
CREATE INDEX idx_repair_fault
ON REPAIR_JOBS (fault_report_id)
TABLESPACE WATERPOINTCARE_IDX;


/* Repair jobs searched by maintenance team. */
CREATE INDEX idx_repair_team
ON REPAIR_JOBS (team_id)
TABLESPACE WATERPOINTCARE_IDX;


/* Part usage searched by spare part.
   The repair_job_id column is already covered by
   the leading column of the unique composite index
   created by the unique constraint in 02_constraints.sql. */

CREATE INDEX idx_usage_part
ON REPAIR_PART_USAGE (part_id)
TABLESPACE WATERPOINTCARE_IDX;


/* Audit records searched by fault report. */
CREATE INDEX idx_audit_fault
ON STATUS_AUDIT_LOG (fault_report_id)
TABLESPACE WATERPOINTCARE_IDX;


/* 
   2. COMPOSITE INDEX
   */

/* Supports queries filtering fault reports by status
   and arranging or filtering them by report date. */

CREATE INDEX idx_fault_status_date
ON FAULT_REPORTS (status, report_date)
TABLESPACE WATERPOINTCARE_IDX;


/* 
   3. ADDITIONAL SEARCH INDEX
    */

/* Supports searches for repair jobs by their status. */

CREATE INDEX idx_repair_status
ON REPAIR_JOBS (repair_status)
TABLESPACE WATERPOINTCARE_IDX;


/* 
   4. FUNCTION-BASED UNIQUE INDEX
  
 */
/* Prevents team names that differ only in letter case.
   Example: Water Team and WATER TEAM cannot both exist. */

CREATE UNIQUE INDEX ux_team_name_upper
ON MAINTENANCE_TEAMS (UPPER(team_name))
TABLESPACE WATERPOINTCARE_IDX;


PROMPT All WaterPointCare indexes have been created.
