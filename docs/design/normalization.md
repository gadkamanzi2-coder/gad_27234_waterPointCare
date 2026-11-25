
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
