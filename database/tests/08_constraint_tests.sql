
/*
    Student Name : Gad Kamanzi
    Student ID   : 27234
    Group        : B
    Project      : WaterPointCare Rwanda
    Course       : INSY 8311 - Database Development with PL/SQL

    Script       : 08_constraint_tests.sql
    Purpose      : Demonstrate primary key, NOT NULL, UNIQUE,
                   FOREIGN KEY, and CHECK constraint enforcement.

    IMPORTANT:
    Run after the tables and constraints have been created.
    Test records are rolled back and are not retained.
*/

SET ECHO ON;
SET SERVEROUTPUT ON;


/* 
   1. START TEST TRANSACTION
    */

SAVEPOINT constraint_test_start;


/* 
   2. TEST CONSTRAINT ENFORCEMENT
   */

DECLARE

    PROCEDURE expect_error
    (
        p_test_name     IN VARCHAR2,
        p_sql           IN VARCHAR2,
        p_expected_code IN NUMBER
    )
    IS
        v_actual_code NUMBER;
    BEGIN
        EXECUTE IMMEDIATE p_sql;

        DBMS_OUTPUT.PUT_LINE(
            'FAIL: ' || p_test_name ||
            ' - Invalid operation was accepted.'
        );

    EXCEPTION
        WHEN OTHERS THEN
            v_actual_code := SQLCODE;

            IF v_actual_code = p_expected_code THEN
                DBMS_OUTPUT.PUT_LINE(
                    'PASS: ' || p_test_name ||
                    ' - Expected Oracle error ' ||
                    TO_CHAR(ABS(p_expected_code))
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE(
                    'FAIL: ' || p_test_name ||
                    ' - Unexpected Oracle error ' ||
                    TO_CHAR(ABS(v_actual_code)) ||
                    ': ' || SQLERRM
                );
            END IF;
    END expect_error;

BEGIN

    DBMS_OUTPUT.PUT_LINE(
        '===== WATERPOINTCARE CONSTRAINT TESTS ====='
    );


    /* -----------------------------------------------------
       TEST 1: PRIMARY KEY
       ORA-00001 = unique constraint violated
       ----------------------------------------------------- */

    INSERT INTO WATER_POINTS
    (
        water_point_id,
        latitude,
        longitude
    )
    VALUES
    (
        'GAD_TEST_PK_27234',
        -1.9500,
        30.0600
    );

    expect_error(
        'PRIMARY KEY - duplicate water point ID',
        q'[INSERT INTO WATER_POINTS
           (water_point_id, latitude, longitude)
           VALUES
           ('GAD_TEST_PK_27234', -1.9500, 30.0600)]',
        -1
    );


    /* 
       TEST 2: NOT NULL
       ORA-01400 = cannot insert NULL
       */

    expect_error(
        'NOT NULL - missing water point ID',
        q'[INSERT INTO WATER_POINTS
           (water_point_id, latitude, longitude)
           VALUES
           (NULL, -1.9500, 30.0600)]',
        -1400
    );


    /* 
       TEST 3: UNIQUE
       ORA-00001 = unique constraint violated
        */

    INSERT INTO MAINTENANCE_TEAMS
    (
        team_name
    )
    VALUES
    (
        'GAD_TEST_TEAM_27234'
    );

    expect_error(
        'UNIQUE - duplicate maintenance team name',
        q'[INSERT INTO MAINTENANCE_TEAMS
           (team_name)
           VALUES
           ('GAD_TEST_TEAM_27234')]',
        -1
    );


    /*
       TEST 4: FOREIGN KEY
       ORA-02291 = parent key not found
        */

    expect_error(
        'FOREIGN KEY - nonexistent water point',
        q'[INSERT INTO FAULT_REPORTS
           (water_point_id, fault_description,
            fault_category, priority)
           VALUES
           ('NONEXISTENT_WATER_POINT_27234',
            'Constraint test fault',
            'TEST',
            'Low')]',
        -2291
    );


    /* 
       TEST 5: CHECK CONSTRAINT - LATITUDE
       ORA-02290 = check constraint violated
        */

    expect_error(
        'CHECK - latitude outside valid range',
        q'[INSERT INTO WATER_POINTS
           (water_point_id, latitude, longitude)
           VALUES
           ('GAD_TEST_LAT_27234', 95, 30)]',
        -2290
    );


    /* 
       TEST 6: CHECK CONSTRAINT - FAULT PRIORITY
       ORA-02290 = check constraint violated
       */

    expect_error(
        'CHECK - invalid fault priority',
        q'[INSERT INTO FAULT_REPORTS
           (water_point_id, fault_description,
            fault_category, priority)
           VALUES
           ('GAD_TEST_PK_27234',
            'Invalid priority test',
            'TEST',
            'URGENT')]',
        -2290
    );


    DBMS_OUTPUT.PUT_LINE(
        '===== CONSTRAINT TESTS FINISHED ====='
    );

END;
/


/* 
   3. DISPLAY CONSTRAINT STATUS
    */

PROMPT Constraint names and validation status:

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
   4. ROLLBACK TEST RECORDS
 */

ROLLBACK TO constraint_test_start;

PROMPT Constraint test records rolled back.
PROMPT No test records were permanently retained.


