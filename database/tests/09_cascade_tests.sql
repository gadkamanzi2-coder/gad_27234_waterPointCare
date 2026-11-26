
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 09_cascade_tests.sql
    Purpose      : Demonstrate NO ACTION, SET NULL,
                   and ON DELETE CASCADE behaviour.

    IMPORTANT:
    Test records are rolled back after testing.
*/

SET ECHO ON;
SET SERVEROUTPUT ON;


/* 
   1. CREATE TEST RECORDS
   */

SAVEPOINT delete_test_start;

DECLARE
    v_water_point_id VARCHAR2(100)
        := 'GAD_DELETE_TEST_27234';

    v_fault_id NUMBER;
    v_team_id NUMBER;
    v_repair_id NUMBER;
    v_part_id NUMBER;

    v_team_reference NUMBER;
    v_usage_count NUMBER;

    PROCEDURE expect_delete_error
    (
        p_test_name IN VARCHAR2,
        p_sql       IN VARCHAR2
    )
    IS
    BEGIN
        EXECUTE IMMEDIATE p_sql;

        DBMS_OUTPUT.PUT_LINE(
            'FAIL: ' || p_test_name ||
            ' - deletion was unexpectedly accepted.'
        );

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN
                DBMS_OUTPUT.PUT_LINE(
                    'PASS: ' || p_test_name ||
                    ' - Oracle prevented parent deletion.'
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE(
                    'FAIL: ' || p_test_name ||
                    ' - unexpected error: ' || SQLERRM
                );
            END IF;
    END expect_delete_error;

BEGIN

    /* Create a test water point. */
    INSERT INTO WATER_POINTS
    (
        water_point_id,
        latitude,
        longitude
    )
    VALUES
    (
        v_water_point_id,
        -1.9500,
        30.0600
    );

    /* Create a fault report. */
    INSERT INTO FAULT_REPORTS
    (
        water_point_id,
        fault_description,
        fault_category,
        priority
    )
    VALUES
    (
        v_water_point_id,
        'Test fault for deletion rules',
        'TEST',
        'Medium'
    )
    RETURNING fault_report_id INTO v_fault_id;


    /* Create a maintenance team. */
    INSERT INTO MAINTENANCE_TEAMS
    (
        team_name,
        team_status
    )
    VALUES
    (
        'GAD_DELETE_TEAM_27234',
        'ACTIVE'
    )
    RETURNING team_id INTO v_team_id;


    /* Create a repair job assigned to that team. */
    INSERT INTO REPAIR_JOBS
    (
        fault_report_id,
        team_id,
        repair_description,
        repair_status
    )
    VALUES
    (
        v_fault_id,
        v_team_id,
        'Test repair for deletion rules',
        'ASSIGNED'
    )
    RETURNING repair_job_id INTO v_repair_id;


    /* Create a spare part. */
    INSERT INTO SPARE_PARTS
    (
        part_name,
        quantity_in_stock,
        minimum_stock_level,
        part_status
    )
    VALUES
    (
        'GAD_DELETE_PART_27234',
        10,
        2,
        'AVAILABLE'
    )
    RETURNING part_id INTO v_part_id;


    /* Link the spare part to the repair job. */
    INSERT INTO REPAIR_PART_USAGE
    (
        repair_job_id,
        part_id,
        quantity_used
    )
    VALUES
    (
        v_repair_id,
        v_part_id,
        1
    );


    DBMS_OUTPUT.PUT_LINE(
        'Test records created successfully.'
    );


    /* 
       2. TEST NO ACTION
*/

    /* A spare part cannot be deleted while a usage record
       still references it. */

    expect_delete_error(
        'NO ACTION - referenced spare part',
        'DELETE FROM SPARE_PARTS WHERE part_id = ' ||
        TO_CHAR(v_part_id)
    );


    /* A fault report cannot be deleted while a repair job
       still references it. */

    expect_delete_error(
        'NO ACTION - fault report with repair job',
        'DELETE FROM FAULT_REPORTS WHERE fault_report_id = ' ||
        TO_CHAR(v_fault_id)
    );


    /*
       3. TEST SET NULL
     */

    DELETE FROM MAINTENANCE_TEAMS
    WHERE team_id = v_team_id;

    SELECT team_id
    INTO v_team_reference
    FROM REPAIR_JOBS
    WHERE repair_job_id = v_repair_id;

    IF v_team_reference IS NULL THEN
        DBMS_OUTPUT.PUT_LINE(
            'PASS: SET NULL - repair job remains and team_id is NULL.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'FAIL: SET NULL - team reference was not cleared.'
        );
    END IF;


    /* =====================================================
       4. TEST CASCADE
       ===================================================== */

    DELETE FROM REPAIR_JOBS
    WHERE repair_job_id = v_repair_id;

    SELECT COUNT(*)
    INTO v_usage_count
    FROM REPAIR_PART_USAGE
    WHERE repair_job_id = v_repair_id;

    IF v_usage_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'PASS: CASCADE - part usage records were deleted.'
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'FAIL: CASCADE - part usage records still exist.'
        );
    END IF;


    /* The spare part can now be deleted because its usage
       record was removed by CASCADE. */

    DELETE FROM SPARE_PARTS
    WHERE part_id = v_part_id;


    /* The fault report can now be deleted because its
       repair job has been removed. */

    DELETE FROM FAULT_REPORTS
    WHERE fault_report_id = v_fault_id;


    /* Finally delete the test water point. */

    DELETE FROM WATER_POINTS
    WHERE water_point_id = v_water_point_id;


    DBMS_OUTPUT.PUT_LINE(
        'Referential deletion tests completed.'
    );

END;
/


/* 
   5. ROLLBACK TEST RECORDS
   */

ROLLBACK TO delete_test_start;

PROMPT All referential deletion test records rolled back.
PROMPT Original project data has not been changed.


