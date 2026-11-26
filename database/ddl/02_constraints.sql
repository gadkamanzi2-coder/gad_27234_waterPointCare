
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 02_constraints.sql
    Purpose      : Add primary keys, foreign keys, unique constraints,
                   and check constraints to all project tables.
*/

SET ECHO ON;

/* =========================================================
   1. PRIMARY KEY CONSTRAINTS
   ========================================================= */

ALTER TABLE WATER_POINTS
ADD CONSTRAINT pk_water_points
PRIMARY KEY (water_point_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT pk_water_point_assessments
PRIMARY KEY (assessment_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE FAULT_REPORTS
ADD CONSTRAINT pk_fault_reports
PRIMARY KEY (fault_report_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE MAINTENANCE_TEAMS
ADD CONSTRAINT pk_maintenance_teams
PRIMARY KEY (team_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE REPAIR_JOBS
ADD CONSTRAINT pk_repair_jobs
PRIMARY KEY (repair_job_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE SPARE_PARTS
ADD CONSTRAINT pk_spare_parts
PRIMARY KEY (part_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT pk_repair_part_usage
PRIMARY KEY (repair_part_usage_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE STATUS_AUDIT_LOG
ADD CONSTRAINT pk_status_audit_log
PRIMARY KEY (audit_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;


/* 
   2. UNIQUE CONSTRAINTS
   */

ALTER TABLE MAINTENANCE_TEAMS
ADD CONSTRAINT uq_maintenance_teams_team_name
UNIQUE (team_name)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT uq_repair_part_usage_job_part
UNIQUE (repair_job_id, part_id)
USING INDEX TABLESPACE WATERPOINTCARE_IDX
ENABLE VALIDATE;


/* 
   3. FOREIGN KEY CONSTRAINTS
  */

/* Assessments belong to existing water points.
   Delete rule: NO ACTION (default Oracle behaviour). */

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT fk_assessments_water_points
FOREIGN KEY (water_point_id)
REFERENCES WATER_POINTS (water_point_id)
ENABLE VALIDATE;


/* Fault reports belong to existing water points.
   Delete rule: NO ACTION. */

ALTER TABLE FAULT_REPORTS
ADD CONSTRAINT fk_fault_reports_water_points
FOREIGN KEY (water_point_id)
REFERENCES WATER_POINTS (water_point_id)
ENABLE VALIDATE;


/* Repair jobs must belong to an existing fault report.
   Delete rule: NO ACTION. */

ALTER TABLE REPAIR_JOBS
ADD CONSTRAINT fk_repair_jobs_faults
FOREIGN KEY (fault_report_id)
REFERENCES FAULT_REPORTS (fault_report_id)
ENABLE VALIDATE;


/* A maintenance team can be deleted while its repair jobs
   remain. The team_id in those repair jobs becomes NULL.
   Delete rule: SET NULL. */

ALTER TABLE REPAIR_JOBS
ADD CONSTRAINT fk_repair_jobs_teams
FOREIGN KEY (team_id)
REFERENCES MAINTENANCE_TEAMS (team_id)
ON DELETE SET NULL
ENABLE VALIDATE;


/* When a repair job is deleted, its part-usage records
   are also deleted.
   Delete rule: CASCADE. */

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT fk_usage_repair_jobs
FOREIGN KEY (repair_job_id)
REFERENCES REPAIR_JOBS (repair_job_id)
ON DELETE CASCADE
ENABLE VALIDATE;


/* Spare parts cannot be deleted while usage records refer
   to them.
   Delete rule: NO ACTION. */

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT fk_usage_spare_parts
FOREIGN KEY (part_id)
REFERENCES SPARE_PARTS (part_id)
ENABLE VALIDATE;


/* Audit records must belong to existing fault reports.
   Delete rule: NO ACTION. */

ALTER TABLE STATUS_AUDIT_LOG
ADD CONSTRAINT fk_audit_fault_reports
FOREIGN KEY (fault_report_id)
REFERENCES FAULT_REPORTS (fault_report_id)
ENABLE VALIDATE;


/* 
   4. WATER POINT CHECK CONSTRAINTS
   */

ALTER TABLE WATER_POINTS
ADD CONSTRAINT ck_water_points_latitude
CHECK (latitude BETWEEN -90 AND 90)
ENABLE VALIDATE;

ALTER TABLE WATER_POINTS
ADD CONSTRAINT ck_water_points_longitude
CHECK (longitude BETWEEN -180 AND 180)
ENABLE VALIDATE;


/* 
   5. ASSESSMENT CHECK CONSTRAINTS
  */

/* Numerical values cannot be negative. */

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_service_score
CHECK (level_of_service_score >= 0)
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_users_num
CHECK (number_of_users >= 0)
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_fill_time
CHECK (seconds_to_fill_20_litres >= 0)
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_flow_rate
CHECK (handpump_flow_rate >= 0)
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_piped_qty
CHECK (piped_litres_per_person_per_day >= 0)
ENABLE VALIDATE;


/* Indicator columns accept only Y or N.
   NULL values remain permitted where the source has no data. */

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_functional
CHECK (is_functional IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_protected
CHECK (is_source_protected IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_users
CHECK (users_meet_standards IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_broken
CHECK (is_out_of_service_or_broken IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_freq
CHECK (breakage_frequency_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_days
CHECK (breakage_days_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_outage
CHECK (monthly_outage_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_available
CHECK (water_available_on_visit_day IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_quantity
CHECK (quantity_meets_standards IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_ecoli
CHECK (ecoli_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_chlorine
CHECK (residual_chlorine_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_bacteria
CHECK (bacteria_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_contam
CHECK (other_contaminant_present IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_contam_std
CHECK (other_contaminant_meets_standard IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_quality
CHECK (water_quality_meets_standards IN ('Y', 'N'))
ENABLE VALIDATE;

ALTER TABLE WATER_POINT_ASSESSMENTS
ADD CONSTRAINT ck_assess_condition
CHECK (overall_condition_is_good IN ('Y', 'N'))
ENABLE VALIDATE;


/* 
   6. FAULT REPORT CHECK CONSTRAINTS
   */

ALTER TABLE FAULT_REPORTS
ADD CONSTRAINT ck_fault_reports_priority
CHECK (priority IN ('Low', 'Medium', 'High', 'Critical'))
ENABLE VALIDATE;

ALTER TABLE FAULT_REPORTS
ADD CONSTRAINT ck_fault_reports_status
CHECK (status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS',
                  'RESOLVED', 'CLOSED'))
ENABLE VALIDATE;


/*
   7. MAINTENANCE TEAM CHECK CONSTRAINT
   */

ALTER TABLE MAINTENANCE_TEAMS
ADD CONSTRAINT ck_maintenance_team_status
CHECK (team_status IN ('ACTIVE', 'INACTIVE'))
ENABLE VALIDATE;


/* 
   8. REPAIR JOB CHECK CONSTRAINTS
    */

ALTER TABLE REPAIR_JOBS
ADD CONSTRAINT ck_repair_jobs_status
CHECK (repair_status IN ('PENDING', 'ASSIGNED',
                         'IN_PROGRESS', 'COMPLETED',
                         'CANCELLED'))
ENABLE VALIDATE;

ALTER TABLE REPAIR_JOBS
ADD CONSTRAINT ck_repair_jobs_cost
CHECK (repair_cost >= 0)
ENABLE VALIDATE;


/* 
   9. SPARE PART CHECK CONSTRAINTS
   */

ALTER TABLE SPARE_PARTS
ADD CONSTRAINT ck_spare_parts_cost
CHECK (unit_cost >= 0)
ENABLE VALIDATE;

ALTER TABLE SPARE_PARTS
ADD CONSTRAINT ck_spare_parts_stock
CHECK (quantity_in_stock >= 0)
ENABLE VALIDATE;

ALTER TABLE SPARE_PARTS
ADD CONSTRAINT ck_spare_parts_min_stock
CHECK (minimum_stock_level >= 0)
ENABLE VALIDATE;

ALTER TABLE SPARE_PARTS
ADD CONSTRAINT ck_spare_parts_status
CHECK (part_status IN ('AVAILABLE', 'UNAVAILABLE'))
ENABLE VALIDATE;


/* 
   10. REPAIR PART USAGE CHECK CONSTRAINTS
*/

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT ck_usage_quantity
CHECK (quantity_used > 0)
ENABLE VALIDATE;

ALTER TABLE REPAIR_PART_USAGE
ADD CONSTRAINT ck_usage_unit_cost
CHECK (unit_cost_at_use >= 0)
ENABLE VALIDATE;


/* 
   11. STATUS AUDIT LOG CHECK CONSTRAINTS
   */

ALTER TABLE STATUS_AUDIT_LOG
ADD CONSTRAINT ck_audit_old_status
CHECK (old_status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS',
                      'RESOLVED', 'CLOSED'))
ENABLE VALIDATE;

ALTER TABLE STATUS_AUDIT_LOG
ADD CONSTRAINT ck_audit_new_status
CHECK (new_status IN ('OPEN', 'ASSIGNED', 'IN_PROGRESS',
                      'RESOLVED', 'CLOSED'))
ENABLE VALIDATE;



PROMPT All primary keys, foreign keys, unique constraints,
PROMPT and check constraints have been defined.
