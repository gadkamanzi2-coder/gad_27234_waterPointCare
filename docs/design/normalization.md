
# WaterPointCare Rwanda
## Phase II: Data Sourcing, Normalization and Logical Design

# Task 3: Entity Identification

## 3.1 Introduction

The purpose of this task is to identify the main entities required for the WaterPointCare Rwanda database.

The system will organize water-point information and support the management of fault reports, maintenance teams, repair activities, spare parts and maintenance history.

The Rwanda 2021 water-point dataset provides historical information about water points and their assessments. However, it does not provide a complete operational history of fault reporting and repair activities. Therefore, the database will combine the historical assessment data with additional entities needed to support the proposed maintenance-management process.

## 3.2 Identified Entities

The following entities have been identified:

| No. | Entity | Purpose |
|---|---|---|
| 1 | WATER_POINTS | Stores the identity and geographical location of each physical water point. |
| 2 | WATER_POINT_ASSESSMENTS | Stores historical and future assessment information about water-point condition, functionality, service level, quantity and water quality. |
| 3 | FAULT_REPORTS | Stores problems reported about water points, including the report date, description and status. |
| 4 | MAINTENANCE_TEAMS | Stores information about teams responsible for carrying out maintenance activities. |
| 5 | REPAIR_JOBS | Stores repair activities associated with reported faults, including assignments and repair outcomes. |
| 6 | SPARE_PARTS | Stores information about spare parts available for maintenance activities. |
| 7 | REPAIR_PART_USAGE | Records the spare parts and quantities used in individual repair jobs. |
| 8 | STATUS_AUDIT_LOG | Stores the history of status changes for reported faults. |

## 3.3 Description of the Entities

### 1. WATER_POINTS

Represents a physical water point. It stores identifying and geographical information such as the water-point identifier, coordinates, elevation and administrative location.

The source dataset contains both Instance Id and Unique ID. Analysis shows that these fields have identical values in all 2,061 complete records. Therefore, Instance Id will not be treated as an independent assessment identifier. In the proposed database, each assessment will receive a database-generated assessment_id and will be linked to its water point through water_point_id.

### 2. WATER_POINT_ASSESSMENTS

Represents an inspection or assessment performed on a water point.

It stores assessment dates, service-level information, technology observed, functionality, water availability, user information, water quantity, water quality and overall condition.

The source dataset's `Instance Id` identifies an assessment record. Each assessment will be associated with a water point.

### 3. FAULT_REPORTS

Represents a problem reported about a water point. It allows the system to record what went wrong, when the problem was reported and its current status.

A fault report is an operational record. It is not the same as a historical assessment in the Rwanda dataset.

### 4. MAINTENANCE_TEAMS

Represents a team responsible for responding to reported water-point faults and carrying out repair work.

### 5. REPAIR_JOBS

Represents maintenance or repair work carried out in response to a reported fault. It records the assigned team, repair dates, work performed and repair outcome.

### 6. SPARE_PARTS

Represents spare parts that may be required when repairing water points. It supports the management of spare-part information and availability.

### 7. REPAIR_PART_USAGE

Represents the use of spare parts during repair jobs. This entity resolves the many-to-many relationship between repair jobs and spare parts because one repair job may use several parts, and one type of spare part may be used in many repair jobs.

### 8. STATUS_AUDIT_LOG

Records changes in the status of fault reports. It helps maintain a history of reported problems and supports tracking of the maintenance process.

## 3.4 Initial Relationships Between Entities

The following relationships are proposed:

1. One WATER_POINT can have many WATER_POINT_ASSESSMENTS. Each assessment belongs to one water point.
2. One WATER_POINT can have many FAULT_REPORTS. Each fault report concerns one water point.
3. One FAULT_REPORT can be associated with one or more REPAIR_JOBS. Each repair job addresses one reported fault.
4. One MAINTENANCE_TEAM can be assigned to many REPAIR_JOBS. Each repair job is assigned to one maintenance team once assigned.
5. One REPAIR_JOB can use many SPARE_PARTS, and one SPARE_PART can be used in many REPAIR_JOBS. REPAIR_PART_USAGE resolves this many-to-many relationship.
6. One FAULT_REPORT can have many STATUS_AUDIT_LOG records. Each status history record belongs to one fault report.


## 3.5 Entity Identification Conclusion

Eight entities have been identified for the proposed database design.

The WATER_POINTS and WATER_POINT_ASSESSMENTS entities will organize the historical Rwanda dataset and support future assessments.

The remaining six entities will support the original project objective of managing fault reports, maintenance assignments, repair activities, spare parts and maintenance history.

This design provides a foundation for developing a normalized relational database that supports the WaterPointCare Rwanda system.

## 4. Normalization Process

### 4.1 Unnormalized Form (UNF)

The original Excel dataset is treated as the Unnormalized Form (UNF), because it is the starting structure before applying normalization rules.

The dataset contains 2,062 rows and 39 columns. Each row represents a water-point record containing identification, geographical location, technology, service-level, functionality, user and water-quality information.

The following are three actual records from the original dataset. The table shows selected columns for readability; the original dataset retains all 39 columns.

| Unique ID | Date | Latitude | Longitude | District (Geo Level 2) | Geo Level 3 | Geo Level 4 | Improved Technology | System Type | Users |
|---|---|---:|---:|---|---|---|---|---|---:|
| Gicumbisurveysgp1-3FB72Q | 2015-01-01 | -1.6008708 | 29.9591314 | Gicumbi | Miyove | Mubuga | Protected Spring | Handpump | 50 |
| Gicumbisurveysgp5-3FBBHQ | 2015-01-01 | -1.6424203 | 30.2116447 | Gicumbi | Ruvune | Cyandaro | Protected Spring | Handpump | 200 |
| Gicumbisurveysgp5-3FBDDC | 2015-01-01 | -1.5801203 | 30.0695289 | Gicumbi | Ruvune | Rebero | Protected Spring | Handpump | 312 |

**UNF observation:**

The raw dataset stores water-point identification, geographical details and assessment information together in one wide table. This makes it harder to manage water points separately from their assessments when the system grows.

Initial inspection did not identify a clear list of multiple values stored in a single field. Therefore, we will not invent repeating groups or claim that they exist without evidence.

**Normalization objective:** Organize the information into related tables while preserving the original water-point information and supporting future fault reporting, repair assignments and maintenance history.

### 4.2 First Normal Form (1NF)

A relational table satisfies First Normal Form (1NF) when each column contains atomic values, each record can be uniquely identified, and there are no repeating groups.

**Analysis of the actual dataset**

The original dataset was examined to determine whether its fields contain multiple values or repeating groups.

The analysis found that:

1. The dataset contains 2,061 non-empty `Unique ID` values, and all 2,061 values are unique.
2. The inspected text fields do not contain comma-, semicolon- or pipe-separated lists of multiple values.
3. Each assessment attribute is stored in its own column.
4. No repeating groups of columns were identified.

However, one row has a missing `Unique ID` and `Instance Id`, although it contains some other values. This row cannot be reliably identified as a water-point record. It will be preserved in the original raw dataset and investigated during Phase IV data cleaning.

**1NF decision**

The 2,061 identifiable records satisfy the atomic-value and unique-identifier requirements of 1NF. No column splitting is required at this stage because the inspected fields do not contain repeating groups or multiple values in a single cell.

The unidentified row is flagged for investigation rather than being assigned an invented water-point identifier.

**Dependency removed:** No repeating-group dependency was identified, so no table split was necessary to achieve 1NF.

### 4.3 Second Normal Form (2NF)

A table satisfies Second Normal Form (2NF) when it is already in First Normal Form (1NF) and every non-key attribute depends on the whole candidate key. This rule prevents partial dependencies.

**Analysis of the actual dataset**

The dataset uses `Unique ID` as its candidate key. Each of the 2,061 non-empty values is unique.

The candidate key consists of only one column. Therefore, there cannot be a partial dependency on part of a composite key.

For example, the following attributes are associated with the complete `Unique ID`:

| Unique ID | Date | District | Improved Technology | System Type | Users |
|---|---|---|---|---|---:|
| Gicumbisurveysgp1-3FB72Q | 2015-01-01 | Gicumbi | Protected Spring | Handpump | 50 |
| Gicumbisurveysgp5-3FBBHQ | 2015-01-01 | Gicumbi | Protected Spring | Handpump | 200 |
| Gicumbisurveysgp5-3FBDDC | 2015-01-01 | Gicumbi | Protected Spring | Handpump | 312 |

**2NF decision**

The identifiable records already satisfy 2NF because the candidate key is a single column and no partial dependency is possible.

No table split is required to remove partial dependencies at this stage.

**Dependency removed:** No partial dependency was identified because the candidate key contains only one attribute. Therefore, no split was necessary to achieve 2NF.

### 4.4 Third Normal Form (3NF)

A table satisfies Third Normal Form (3NF) when it is already in Second Normal Form (2NF) and contains no transitive dependencies. Non-key attributes must depend on the key, the whole key, and nothing but the key.

**Analysis of the actual dataset**

The dataset was examined for possible dependencies between non-key attributes.

The geographical columns (`Geo Level 1` to `Geo Level 7`) describe administrative locations. However, the observed values do not establish a consistently reliable parent-to-child relationship across all geographical levels. Therefore, separate geographical reference tables will not be created based only on assumptions about these columns.

The dataset also contains water-point information and assessment information in the same wide record. Although the current source has one identifiable record per `Unique ID`, the WaterPointCare Rwanda system must support multiple assessments of the same physical water point over time.

For this reason, the logical database design separates the information into:

**1. WATER_POINTS**

Stores information that identifies and describes the physical water point, including its identifier and geographical location.

**2. WATER_POINT_ASSESSMENTS**

Stores observations recorded during inspections, including assessment date, service level, functionality, water availability, quantity and water-quality information. Each assessment will have its own `assessment_id` and will reference its water point using `water_point_id`.

This design allows a water point to have multiple assessment records without duplicating its permanent identification and location information.

**3NF decision**

The identifiable source records use a single-column candidate key, and no confirmed transitive dependency requiring a geographical table split was established from the inspected values. The separation of water-point information from assessment information is adopted to support the operational and historical requirements of the proposed system.

The final logical design will keep attributes with the entities they describe and use primary and foreign keys to connect the related tables.

**Dependency removed:** No confirmed transitive dependency was identified that requires a geographical table split. The separation of `WATER_POINTS` and `WATER_POINT_ASSESSMENTS` is a system-design decision to support multiple assessments over time, rather than a claimed correction of a proven source-data dependency.

## 5. Source-to-Target Field Mapping

This section maps all 39 columns from the original `water_points_rwanda_2021.xlsx` dataset to the proposed WaterPointCare Rwanda database.

The mapping separates physical water-point information from assessment observations. It also identifies redundant fields and conversions required during Phase IV data cleaning.

### 5.1 Water-point identification and location

| No. | Original Excel column | Target table | Target column | Action |
|---:|---|---|---|---|
| 1 | Instance Id | Not stored separately | — | Redundant: identical to `Unique ID` in all 2,061 complete records |
| 2 | Date | WATER_POINT_ASSESSMENTS | assessment_date | Convert Excel date value to DATE |
| 3 | Unique ID | WATER_POINTS | water_point_id | Use as the source identifier and primary key |
| 4 | Latitude | WATER_POINTS | latitude | Convert to NUMBER |
| 5 | Longitude | WATER_POINTS | longitude | Convert to NUMBER |
| 6 | Elevation | WATER_POINTS | elevation | Convert to NUMBER |
| 7 | Geo Level 1 | WATER_POINTS | geo_level_1 | Preserve geographical level |
| 8 | Geo Level 2 | WATER_POINTS | geo_level_2 | Preserve geographical level |
| 9 | Geo Level 3 | WATER_POINTS | geo_level_3 | Preserve geographical level |
| 10 | Geo Level 4 | WATER_POINTS | geo_level_4 | Preserve geographical level |
| 11 | Geo Level 5 | WATER_POINTS | geo_level_5 | Preserve geographical level |
| 12 | Geo Level 6 | WATER_POINTS | geo_level_6 | Preserve; investigate missing values |
| 13 | Geo Level 7 | WATER_POINTS | geo_level_7 | Preserve; investigate missing values |

### 5.2 Water-point technology and assessment information

| No. | Original Excel column | Target table | Target column | Action |
|---:|---|---|---|---|
| 14 | Level Of Service Score | WATER_POINT_ASSESSMENTS | level_of_service_score | Convert to NUMBER |
| 15 | Level Of Service | WATER_POINT_ASSESSMENTS | level_of_service | Preserve category |
| 16 | Has Improved Water Point (1) | WATER_POINT_ASSESSMENTS | is_improved | Convert source value to a consistent flag |
| 17 | Tech Type Improved | WATER_POINTS | technology_type | Use as technology classification when applicable |
| 18 | Tech Type UnImproved | WATER_POINTS | technology_type | Use as technology classification when applicable |
| 19 | Water Point is Functional or not greater than 3 months without service | WATER_POINT_ASSESSMENTS | is_functional | Standardize functional status |
| 20 | Water Point Source is Protected | WATER_POINT_ASSESSMENTS | source_is_protected | Standardize source protection value |
| 21 | # of Users | WATER_POINT_ASSESSMENTS | number_of_users | Convert to NUMBER |
| 22 | # of Users Meets Standards (1) | WATER_POINT_ASSESSMENTS | users_meet_standard | Standardize assessment result |
| 23 | Water Point/System Out Of Service Or Broken? | WATER_POINT_ASSESSMENTS | is_broken | Standardize yes/no result |
| 24 | Water Point/System Number Of Times Broken Is Equal to Oncer Per Month or Less | WATER_POINT_ASSESSMENTS | breakage_frequency_meets_standard | Standardize assessment result |
| 25 | Water Point/System Number Of Days Broken Is One Day Or Less | WATER_POINT_ASSESSMENTS | breakage_duration_meets_standard | Standardize assessment result |
| 26 | Water Point/ System Out Of Service For One Day Or Less Per Month In The Last Year | WATER_POINT_ASSESSMENTS | monthly_downtime_meets_standard | Standardize assessment result |
| 27 | Water Is Available On The Day Of The Visit (1) | WATER_POINT_ASSESSMENTS | water_available_on_visit | Standardize yes/no result |
| 28 | Seconds to fill 20 liters | WATER_POINT_ASSESSMENTS | seconds_to_fill_20l | Convert to NUMBER |
| 29 | Piped or handpump? | WATER_POINTS | system_type | Preserve system classification |
| 30 | FOR HANDPUMPS ONLY — Handpump flow rate in L/s | WATER_POINT_ASSESSMENTS | handpump_flow_rate_lps | Convert to NUMBER; applicable to handpumps |
| 31 | FOR PIPED ONLY — Liters per person per day | WATER_POINT_ASSESSMENTS | liters_per_person_per_day | Convert to NUMBER; applicable to piped systems |
| 32 | Quantity Of Water Available Meets Standards (1) | WATER_POINT_ASSESSMENTS | quantity_meets_standard | Standardize assessment result |

### 5.3 Water-quality and overall condition information

| No. | Original Excel column | Target table | Target column | Action |
|---:|---|---|---|---|
| 33 | E Coli Meets Standard | WATER_POINT_ASSESSMENTS | ecoli_meets_standard | Standardize assessment result |
| 34 | Residual Chlorine Meets Standard | WATER_POINT_ASSESSMENTS | residual_chlorine_meets_standard | Standardize assessment result |
| 35 | Bacteria Meets Standard | WATER_POINT_ASSESSMENTS | bacteria_meets_standard | Standardize assessment result |
| 36 | Other contaminant of concern at Water Point? | WATER_POINT_ASSESSMENTS | other_contaminant_observation | Preserve observation and standardize case |
| 37 | Other Contaminant of Concern Meets Standard | WATER_POINT_ASSESSMENTS | other_contaminant_meets_standard | Standardize assessment result |
| 38 | Water Quality Meets Standards (1) (E-Coli, Bacteria, Residual...) | WATER_POINT_ASSESSMENTS | water_quality_meets_standard | Preserve overall water-quality result |
| 39 | Water Point/System In Good Overall Condition and Functioning | WATER_POINT_ASSESSMENTS | overall_condition_good | Standardize assessment result |

### 5.4 Fields generated by the proposed database

Some target fields do not exist in the original Excel file. They will be generated by the database or entered through the WaterPointCare application.

| Target table | Target column | Source |
|---|---|---|
| WATER_POINT_ASSESSMENTS | assessment_id | Database-generated primary key |
| WATER_POINT_ASSESSMENTS | water_point_id | Foreign key referencing WATER_POINTS |
| FAULT_REPORTS | report_id | Generated when a user submits a fault report |
| MAINTENANCE_TEAMS | team_id | Generated when a maintenance team is registered |
| REPAIR_JOBS | repair_job_id | Generated when a repair job is created |
| SPARE_PARTS | spare_part_id | Generated when a spare part is registered |
| REPAIR_PART_USAGE | usage_id | Generated when parts are assigned to repair jobs |
| STATUS_AUDIT_LOG | audit_id | Generated when a report status change is recorded |

The operational tables will receive records through the system's own activities. They will not be populated with invented information from the assessment dataset.

### 5.5 Phase IV data-cleaning checklist

The following transformations must be performed when loading the raw data into the database:

1. Convert the Excel `Date` values into valid database dates.
2. Convert numerical fields such as latitude, longitude, elevation, number of users, service score, flow rate and water quantity into appropriate numeric values.
3. Standardize yes/no and other assessment-result values into consistent representations.
4. Investigate the row with missing `Unique ID` and `Instance Id` before deciding whether it should be loaded into the main tables.
5. Handle missing values according to their meaning. For example, handpump flow rate may be blank for piped systems.
6. Standardize the observed spelling variation `yes` to `Yes`.
7. Preserve the original Excel file unchanged in `data/raw/`.
8. Keep the original source fields in the staging table so that the cleaning process can be checked and traced.

**Source-to-target mapping conclusion**

All 39 original Excel columns have been accounted for. `Instance Id` is not stored as a separate target identifier because it duplicates `Unique ID` in all 2,061 complete records. The remaining source information is mapped to `WATER_POINTS` or `WATER_POINT_ASSESSMENTS`. Additional operational tables will be populated through the WaterPointCare system.
