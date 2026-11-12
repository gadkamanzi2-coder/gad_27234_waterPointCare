

**Project Title:** Rwanda Community Water Point Functionality and Maintenance Tracking System

**Student Name:** Gad Kamanzi

**Student ID:** 27234

**Course:** INSY 8311 - Database Development with PL/SQL

**Research Area:** Community Water Supply, Water Point Functionality and Maintenance Management

---

## 1. Introduction

This research focuses on problems related to community water points in Rwanda, especially water points that stop working or require regular maintenance.

Community water points such as boreholes, hand pumps and public taps are important because people depend on them to access drinking water. However, some water points experience breakdowns, and repairing them can take time.

The purpose of this project is to develop an Oracle database system that helps record water points, report breakdowns, assign maintenance teams, track repairs and generate maintenance reports.

The research below uses academic papers, official Rwanda statistics, an existing water information platform, a real dataset and Oracle technical documentation.

---

## 2. Research Sources

| # | Source (APA) | Type | Link | Key Finding | Gap it Shows |
|---|---|---|---|---|---|
| 1 | Murray, A. L., Stone, G., Yang, A. R., Lawrence, N. F., Matthews, H., & Kayser, G. L. (2024). Rural water point functionality estimates and associations: Evidence from nine countries in sub-Saharan Africa and South Asia. *Water Resources Research, 60*, e2023WR034679. | Research Paper | https://doi.org/10.1029/2023WR034679 | The study examined 1,805 water points in nine countries. It found that 79% of older water points and 92% of newer water points were functional. Water points with active management committees and people responsible for maintenance were more likely to remain functional. | The study explains factors that affect water point functionality. Our project will complement this type of monitoring with a system for recording breakdown reports, assigning repair jobs and tracking completed maintenance. |
| 2 | Nagel, C., Beach, J., Iribagiza, C., & Thomas, E. A. (2015). Evaluating cellular instrumentation on rural handpumps to improve service delivery: A longitudinal study in rural Rwanda. *Environmental Science & Technology, 49*(24), 14292–14300. | Research Paper | https://doi.org/10.1021/acs.est.5b04077 | The researchers installed 181 water pump sensors in three provinces of Rwanda. Their study found that the maintenance model using sensor information and technician dispatch achieved a median repair time of about 21 days, compared with approximately 152 days under the normal maintenance model. | The research shows the importance of monitoring and responding quickly to breakdowns. Our project focuses on a simple database workflow for recording faults, assigning maintenance teams and following repair progress. |
| 3 | National Institute of Statistics of Rwanda. (2025). *EICV7: Main Indicators Report 2023/24*. https://statistics.gov.rw/statistical-publications/poverty-and-social-protection/eicv7-main-indicators-report-202324 | Government Report / Statistics | https://statistics.gov.rw/statistical-publications/poverty-and-social-protection/eicv7-main-indicators-report-202324 | The report shows that 89.7% of Rwandan households used improved drinking water sources in 2023/24. Public taps and standpipes were among the most commonly used sources. | The report provides information about household access to improved water. However, household access statistics do not show the repair history or current maintenance status of each individual water point. |
| 4 | Water Point Data Exchange. (n.d.). *About WPdx*. https://www.waterpointdata.org/about/ | Existing System / Information Platform | https://www.waterpointdata.org/about/ | WPdx is an existing platform that collects, shares and provides access to water point information. It also provides tools for analysing water access and identifying water points that may need rehabilitation or maintenance attention. | The public description focuses on sharing water data and decision-support tools. Our project will demonstrate a focused maintenance management workflow, including fault reporting, repair assignments, spare-part usage and maintenance records. |
| 5 | Water For People. (2021). *Water For People_Rwanda_2021* [Data set]. Water Point Data Exchange. https://catalog.waterpointdata.org/datasets/wfp-rwanda-621f8339/index.html | Dataset / Data Source | https://catalog.waterpointdata.org/datasets/wfp-rwanda-621f8339/index.html | The dataset contains 2,057 valid water point records from Water For People sampling districts in Rwanda. Its reporting dates range from January 2015 to June 2021. It provides real water point information that can help populate the project's database. | The dataset is historical and covers sampled districts rather than the entire country. It does not provide a complete record of all future breakdowns and repair activities. Additional maintenance records will therefore be needed. |
| 6 | Oracle. (2024). *Oracle Database PL/SQL Language Reference, 21c* (F31827-07). https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/ | Technical Documentation | https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/ | Oracle documentation explains how PL/SQL is used to write procedures, functions, packages, cursors, triggers and exception-handling code in an Oracle database. | The documentation explains the technical features of PL/SQL but does not provide the business rules for community water point maintenance. These rules must be designed and implemented as part of this project. |

---

## 3. Summary of Research Findings

The research shows that keeping community water points functional requires proper monitoring, maintenance and quick responses to breakdowns.

The Rwanda study by Nagel et al. (2015) demonstrates that better monitoring and technician response can reduce the time required to repair water pumps.

The study by Murray et al. (2024) also shows that proper management and having people responsible for maintenance are associated with better water point functionality.

The Rwanda EICV7 report provides useful statistics about household access to improved drinking water, while the WPdx platform provides an existing example of how water point information can be collected and analysed.

The Water For People Rwanda dataset will provide an initial source of real water point records for the project. Oracle PL/SQL documentation will guide the database development.

## 4. Identified Research Gap

Based on the reviewed sources, this project will focus on building a simple database system that connects water point information with maintenance activities.

The proposed system will focus on the following areas:

1. Recording community water points and their details.
2. Recording breakdown reports.
3. Assigning maintenance teams to reported problems.
4. Recording repair activities and spare parts used.
5. Updating water point functionality after repairs are verified.
6. Generating reports about pending repairs, completed repairs and maintenance costs.

The project is not intended to replace existing national water information platforms. It will demonstrate a focused maintenance management solution using Oracle Database and PL/SQL.



## 5. Conclusion

The reviewed sources demonstrate that water point functionality and maintenance are important issues in rural water service delivery.

The proposed Rwanda Community Water Point Functionality and Maintenance Tracking System will use Oracle Database and PL/SQL to organize water point information and manage maintenance records.

The system is expected to improve the organization of breakdown reports, repair assignments and maintenance history within the scope of the project.

---

