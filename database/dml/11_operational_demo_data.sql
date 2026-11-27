
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK

/*
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL
    Script       : 11_operational_demo_data.sql
    Purpose      : Insert clearly identified demonstration records
                   for operational tables and reporting views.

    IMPORTANT:
    These are illustrative demonstration records, not original
    records from the Rwanda water-point Excel dataset.
*/

-- 1. VERIFY DATABASE AND USER

SELECT USER AS current_user FROM dual;

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS current_container
FROM dual;


-- 2. INSERT MAINTENANCE TEAMS

INSERT INTO maintenance_teams
    (team_name, team_leader, contact_phone, email,
     service_area, team_status)
VALUES
    ('Kigali Water Maintenance Team',
     'Demo Team Leader 1', '0780000001',
     'demo.team1@example.com', 'Kigali', 'ACTIVE');

INSERT INTO maintenance_teams
    (team_name, team_leader, contact_phone, email,
     service_area, team_status)
VALUES
    ('Gicumbi Water Maintenance Team',
     'Demo Team Leader 2', '0780000002',
     'demo.team2@example.com', 'Gicumbi', 'ACTIVE');

INSERT INTO maintenance_teams
    (team_name, team_leader, contact_phone, email,
     service_area, team_status)
VALUES
    ('Rulindo Water Maintenance Team',
     'Demo Team Leader 3', '0780000003',
     'demo.team3@example.com', 'Rulindo', 'ACTIVE');


-- 3. INSERT SPARE PARTS

INSERT INTO spare_parts
    (part_name, part_description, part_category,
     unit_cost, quantity_in_stock, minimum_stock_level,
     part_status)
VALUES
    ('Pump Handle', 'Demonstration replacement handle',
     'Pump Component', 15000, 20, 5, 'AVAILABLE');

INSERT INTO spare_parts
    (part_name, part_description, part_category,
     unit_cost, quantity_in_stock, minimum_stock_level,
     part_status)
VALUES
    ('Rubber Seal', 'Demonstration pump sealing component',
     'Seal', 3000, 50, 10, 'AVAILABLE');

INSERT INTO spare_parts
    (part_name, part_description, part_category,
     unit_cost, quantity_in_stock, minimum_stock_level,
     part_status)
VALUES
    ('PVC Pipe', 'Demonstration water pipe',
     'Pipe', 8000, 30, 8, 'AVAILABLE');

INSERT INTO spare_parts
    (part_name, part_description, part_category,
     unit_cost, quantity_in_stock, minimum_stock_level,
     part_status)
VALUES
    ('Pump Rod', 'Demonstration replacement pump rod',
     'Pump Component', 12000, 15, 5, 'AVAILABLE');

INSERT INTO spare_parts
    (part_name, part_description, part_category,
     unit_cost, quantity_in_stock, minimum_stock_level,
     part_status)
VALUES
    ('Valve', 'Demonstration water control valve',
     'Valve', 6000, 25, 5, 'AVAILABLE');


-- 4. INSERT FAULT REPORTS

INSERT INTO fault_reports
    (water_point_id, report_date, fault_description,
     fault_category, priority, status, reported_by,
     contact_information)
VALUES
    ('Gicumbisurveys-9E7X58', DATE '2026-11-20',
     'Demonstration water pump handle is damaged',
     'Mechanical', 'High', 'RESOLVED',
     'Demo Reporter 1', '0780000011');

INSERT INTO fault_reports
    (water_point_id, report_date, fault_description,
     fault_category, priority, status, reported_by,
     contact_information)
VALUES
    ('Gicumbisurveys-9E7ZYG', DATE '2026-11-21',
     'Demonstration water point has a leaking seal',
     'Leakage', 'Medium', 'IN_PROGRESS',
     'Demo Reporter 2', '0780000012');

INSERT INTO fault_reports
    (water_point_id, report_date, fault_description,
     fault_category, priority, status, reported_by,
     contact_information)
VALUES
    ('Gicumbisurveys-9E8QZM', DATE '2026-11-22',
     'Demonstration water pipe is damaged',
     'Pipe Damage', 'Critical', 'ASSIGNED',
     'Demo Reporter 3', '0780000013');

INSERT INTO fault_reports
    (water_point_id, report_date, fault_description,
     fault_category, priority, status, reported_by,
     contact_information)
VALUES
    ('Gicumbisurveys-9E8SRB', DATE '2026-11-23',
     'Demonstration pump is not operating correctly',
     'Mechanical', 'High', 'OPEN',
     'Demo Reporter 4', '0780000014');

INSERT INTO fault_reports
    (water_point_id, report_date, fault_description,
     fault_category, priority, status, reported_by,
     contact_information)
VALUES
    ('Gicumbisurveys-9EAEM7', DATE '2026-11-24',
     'Demonstration water point requires inspection',
     'Inspection', 'Low', 'CLOSED',
     'Demo Reporter 5', '0780000015');


-- 5. INSERT REPAIR JOBS

INSERT INTO repair_jobs
    (fault_report_id, team_id, assigned_date, start_date,
     completion_date, repair_description, repair_status,
     repair_cost, technician_name, remarks)
SELECT f.fault_report_id, t.team_id,
       DATE '2026-11-20', DATE '2026-11-20',
       DATE '2026-11-21',
       'Demonstration replacement of damaged pump handle',
       'COMPLETED', 15000, 'Demo Technician 1',
       'Illustrative completed repair'
FROM fault_reports f
CROSS JOIN maintenance_teams t
WHERE f.water_point_id = 'Gicumbisurveys-9E7X58'
  AND t.team_name = 'Kigali Water Maintenance Team';

INSERT INTO repair_jobs
    (fault_report_id, team_id, assigned_date, start_date,
     repair_description, repair_status, repair_cost,
     technician_name, remarks)
SELECT f.fault_report_id, t.team_id,
       DATE '2026-11-22', DATE '2026-11-23',
       'Demonstration replacement of leaking seal',
       'IN_PROGRESS', 3000, 'Demo Technician 2',
       'Illustrative repair in progress'
FROM fault_reports f
CROSS JOIN maintenance_teams t
WHERE f.water_point_id = 'Gicumbisurveys-9E7ZYG'
  AND t.team_name = 'Gicumbi Water Maintenance Team';

INSERT INTO repair_jobs
    (fault_report_id, team_id, assigned_date,
     repair_description, repair_status, repair_cost,
     technician_name, remarks)
SELECT f.fault_report_id, t.team_id,
       DATE '2026-11-23',
       'Demonstration inspection and replacement of damaged pipe',
       'ASSIGNED', 8000, 'Demo Technician 3',
       'Illustrative assigned repair'
FROM fault_reports f
CROSS JOIN maintenance_teams t
WHERE f.water_point_id = 'Gicumbisurveys-9E8QZM'
  AND t.team_name = 'Rulindo Water Maintenance Team';

INSERT INTO repair_jobs
    (fault_report_id, team_id, assigned_date,
     repair_description, repair_status, repair_cost,
     technician_name, remarks)
SELECT f.fault_report_id, t.team_id,
       DATE '2026-11-24',
       'Demonstration pump inspection',
       'PENDING', 0, 'Demo Technician 4',
       'Illustrative pending repair'
FROM fault_reports f
CROSS JOIN maintenance_teams t
WHERE f.water_point_id = 'Gicumbisurveys-9E8SRB'
  AND t.team_name = 'Kigali Water Maintenance Team';


-- 6. INSERT REPAIR PART USAGE

INSERT INTO repair_part_usage
    (repair_job_id, part_id, quantity_used,
     unit_cost_at_use, usage_date, remarks)
SELECT r.repair_job_id, p.part_id, 1,
       15000, DATE '2026-11-21',
       'Demonstration pump handle replacement'
FROM repair_jobs r
CROSS JOIN spare_parts p
WHERE r.repair_description =
      'Demonstration replacement of damaged pump handle'
  AND p.part_name = 'Pump Handle';

INSERT INTO repair_part_usage
    (repair_job_id, part_id, quantity_used,
     unit_cost_at_use, usage_date, remarks)
SELECT r.repair_job_id, p.part_id, 1,
       3000, DATE '2026-11-23',
       'Demonstration seal replacement'
FROM repair_jobs r
CROSS JOIN spare_parts p
WHERE r.repair_description =
      'Demonstration replacement of leaking seal'
  AND p.part_name = 'Rubber Seal';

INSERT INTO repair_part_usage
    (repair_job_id, part_id, quantity_used,
     unit_cost_at_use, usage_date, remarks)
SELECT r.repair_job_id, p.part_id, 1,
       8000, DATE '2026-11-23',
       'Demonstration pipe replacement'
FROM repair_jobs r
CROSS JOIN spare_parts p
WHERE r.repair_description =
      'Demonstration inspection and replacement of damaged pipe'
  AND p.part_name = 'PVC Pipe';


-- 7. INSERT STATUS AUDIT HISTORY

INSERT INTO status_audit_log
    (fault_report_id, old_status, new_status,
     changed_at, changed_by, change_remarks)
SELECT fault_report_id, 'OPEN', 'ASSIGNED',
       TIMESTAMP '2026-11-20 09:00:00',
       'DEMO_ADMIN', 'Illustrative assignment history'
FROM fault_reports
WHERE water_point_id = 'Gicumbisurveys-9E7X58';

INSERT INTO status_audit_log
    (fault_report_id, old_status, new_status,
     changed_at, changed_by, change_remarks)
SELECT fault_report_id, 'ASSIGNED', 'IN_PROGRESS',
       TIMESTAMP '2026-11-20 11:00:00',
       'DEMO_ADMIN', 'Illustrative repair started'
FROM fault_reports
WHERE water_point_id = 'Gicumbisurveys-9E7X58';

INSERT INTO status_audit_log
    (fault_report_id, old_status, new_status,
     changed_at, changed_by, change_remarks)
SELECT fault_report_id, 'IN_PROGRESS', 'RESOLVED',
       TIMESTAMP '2026-11-21 15:00:00',
       'DEMO_ADMIN', 'Illustrative repair completed'
FROM fault_reports
WHERE water_point_id = 'Gicumbisurveys-9E7X58';


-- 8. COMMIT DEMONSTRATION DATA

COMMIT;


-- 9. VERIFY INSERTED RECORDS

SELECT 'FAULT_REPORTS' AS table_name, COUNT(*) AS total
FROM fault_reports
UNION ALL
SELECT 'MAINTENANCE_TEAMS', COUNT(*) FROM maintenance_teams
UNION ALL
SELECT 'REPAIR_JOBS', COUNT(*) FROM repair_jobs
UNION ALL
SELECT 'SPARE_PARTS', COUNT(*) FROM spare_parts
UNION ALL
SELECT 'REPAIR_PART_USAGE', COUNT(*) FROM repair_part_usage
UNION ALL
SELECT 'STATUS_AUDIT_LOG', COUNT(*) FROM status_audit_log;
