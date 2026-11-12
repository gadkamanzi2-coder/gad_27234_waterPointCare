# Project Proposal

**Project Title:** Rwanda Community Water Point Functionality and Maintenance Tracking System  
**Student:** Gad Kamanzi  
**Student ID:** 27234  
**Course:** INSY 8311 – Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Academic Year:** 2026–2027

## 1. Problem Statement

Community water points such as boreholes, hand pumps and public taps are important sources of drinking water in Rwanda. When a water point breaks down, it is important to record the problem, assign a repair team, follow the repair work and update the water point's condition. If these details are kept in separate or paper-based records, it can be difficult to follow repair progress and review maintenance history.

Research supports the value of monitoring and responsive maintenance. In a rural Rwanda study, Nagel et al. (2015) found that a maintenance approach using sensor information to dispatch technicians had a shorter median repair time than the normal approach. Murray et al. (2024) also found that water-point functionality is associated with factors including management and maintenance responsibility. NISR (2025) reports that 89.7% of Rwandan households use improved drinking-water sources.

## 2. Proposed Solution and Objectives

This project will develop an Oracle database system to organize water-point information and manage maintenance activities. Users will be able to record a breakdown, assign a maintenance team, track repair work, record spare parts and costs, update the water point's status after repair, and view reports. The project is an academic prototype; it will not connect to pump sensors or provide automatic real-time monitoring.

Main objective: To design and implement an Oracle database system for recording water-point details and tracking maintenance activities. Specific objectives are to import and organize available water-point records, record breakdown reports, assign teams and track repair jobs,  record spare parts and repair costs; and  produce reports on waterpoint status, pending repairs, completed repairs and repair duration.

## 3. Data Source

The initial data source is Water For People_Rwanda_2021, available through the Water Point Data Exchange (WPdx) catalogue. The catalogue reports 2,057 valid records, with report dates from 3 January 2015 to 19 June 2021. The data was collected through cluster sampling in Water For People programme districts in Rwanda, so it is not a complete or current national inventory (Water For People, 2021). These records will provide baseline water-point information new fault and repair records will be entered into the proposed system.

WPdx describes its repository as open data. Its provider agreement states that submitted data is licensed to WPdx under Creative Commons Attribution 4.0. The project will acknowledge Water For People and WPdx and follow the applicable terms when using or sharing the dataset (Water Point Data Exchange, n.d.).

## 4. Planned Database Tables

The database will have seven main tables: WATER_POINTS (water-point details and current status); FAULT_REPORTS (reported problems); MAINTENANCE_TEAMS (repair team details); REPAIR_JOBS (assignments, dates, status and costs); SPARE_PARTS (parts and stock); REPAIR_PART_USAGE (parts used for each repair); and STATUS_AUDIT_LOG (important status changes). One water point can have many fault reports. Teams can receive many repair jobs. REPAIR_PART_USAGE connects repair jobs with spare parts. The final design will be normalized during the database design phase.

## 5. Planned PL/SQL Features

Procedures will record faults, assign teams, complete repairs and update stock. Functions will calculate repair duration and count pending jobs. Cursors will retrieve pending and completed repairs for reports. A package will group maintenance procedures and functions. Triggers will update water-point status after a completed repair and record important changes in the audit log. Exceptions and validation rules will prevent invalid values, such as negative costs or quantities. These features will be developed in Oracle Database 21c (Oracle, 2024).

## 6. Planned Innovation

The planned innovation is an Oracle APEX interactive dashboard and maintenance application connected to the Oracle database. It will provide forms to enter water points and breakdown reports, screens to assign teams and record repairs, and dashboard reports showing water-point status, pending and completed repairs, and maintenance costs. PL/SQL will enforce the business rules, while APEX will provide the user interface. The application will be demonstrated live using the project's Oracle data.

## References

Murray, A. L., Stone, G., Yang, A. R., Lawrence, N. F., Matthews, H., & Kayser, G. L. (2024). Rural water point functionality estimates and associations: Evidence from nine countries in sub-Saharan Africa and South Asia. Water Resources Research, 60(2), e2023WR034679. https://doi.org/10.1029/2023WR034679

Nagel, C., Beach, J., Iribagiza, C., & Thomas, E. A. (2015). Evaluating cellular instrumentation on rural handpumps to improve service delivery: A longitudinal study in rural Rwanda. Environmental Science & Technology, 49(24), 14292–14300. https://doi.org/10.1021/acs.est.5b04077

National Institute of Statistics of Rwanda. (2025). EICV7: Main indicators report 2023/24. https://statistics.gov.rw/statistical-publications/poverty-and-social-protection/eicv7-main-indicators-report-202324

Oracle. (2024). Oracle Database PL/SQL Language Reference (21c, F31827-07). https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/

Water For People. (2021). Water For People_Rwanda_2021 [Data set]. Water Point Data Exchange. https://catalog.waterpointdata.org/datasets/wfp-rwanda-621f8339/index.html

Water Point Data Exchange. (n.d.). About WPdx and data submission policy. https://www.waterpointdata.org/about/; https://www.waterpointdata.org/share-data/
