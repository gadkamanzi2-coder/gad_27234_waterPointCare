# Dataset Card – WaterPointCare Rwanda

## 1. Dataset Name

Water For People Rwanda Water Points Dataset (2021)

## 2. Original Dataset File

`water_points_rwanda_2021.xlsx`

## 3. Data Source

- **Provider:** Water For People
- **Platform:** Water Point Data Exchange (WPdx)
- **Source catalogue:** https://catalog.waterpointdata.org/datasets/wfp-rwanda-621f8339/index.html
- **Licence:** Creative Commons Attribution 4.0 (CC BY 4.0), as stated in the WPdx provider agreement documented in the project proposal.
- **File format:** Microsoft Excel Workbook (.xlsx)
- **File size:** 510,801 bytes
- **Project download date:** Not recorded in the available project files.

## 4. Dataset Description

This dataset contains information about water points in Rwanda. It includes geographical locations, technology types, service levels, functionality, number of users, water availability, water quantity and water quality.

The dataset provides historical water-point information for the WaterPointCare Rwanda database project.

## 5. Dataset Structure

- Main worksheet: `Transformed Data`
- Number of data rows: 2,062
- Number of columns: 39
- Unique non-empty water-point IDs: 2,061
- Exact duplicate rows: 0
- Total cells: 80,418

The workbook also contains an additional worksheet named `ESRI_MAPINFO_SHEET`, which is not used for the main dataset analysis.

## 6. What Does One Record Represent?

One row represents a water-point record containing its identification, location and associated service-level, functionality, water-quantity and water-quality observations.

The source contains `Instance Id` and `Unique ID`. In all 2,061 records with non-empty identifiers, both fields have identical values. Therefore, they are not treated as two independent identifiers.

The source does not provide a separate assessment identifier.

## 7. Geographic Coverage

The dataset contains records from three districts:

- Gicumbi
- Rulindo
- Kicukiro

The country represented is Rwanda.

The dataset covers sampled programme districts and should not be interpreted as a complete national water-point inventory.

## 8. Time Coverage

The assessment dates in the downloaded workbook range from:

- Earliest date: 1 January 2015
- Latest date: 17 June 2021

The date values are stored as Excel date/time serial values and will require conversion during database loading.

## 9. Main Information Available

The dataset contains information about:

- Water-point identification
- Geographic location and coordinates
- Water-point technology
- Level of service
- Water-point functionality
- Number of users
- Breakdowns and service interruptions
- Water availability and quantity
- Water quality
- Overall water-point condition

## 10. Project Use

WaterPointCare Rwanda will use this dataset as historical water-point information.

The proposed system will focus on:

1. Recording water-point details.
2. Recording new fault reports.
3. Assigning maintenance teams.
4. Tracking repair jobs.
5. Recording spare-part usage and repair costs.
6. Maintaining a history of fault-report status changes.

The historical dataset provides baseline water-point information. New operational fault and repair records will be entered through the proposed system rather than invented from the historical dataset.

## 11. Data Quality Assessment

The initial data quality assessment found the following:

| Check | Result |
|---|---:|
| Total data rows | 2,062 |
| Total columns | 39 |
| Total cells | 80,418 |
| Missing cells | 10,171 |
| Missing-cell percentage | 12.65% |
| Completely duplicated rows | 0 |
| Missing Unique ID values | 1 |
| Missing Instance Id values | 1 |
| Missing Date values | 1 |
| Missing Geo Level 2 values | 1 |

### Columns with the Most Missing Values

| Column | Missing values |
|---|---:|
| Tech Type UnImproved | 2,057 |
| Handpump flow rate | 1,690 |
| Breakage frequency | 1,488 |
| Breakage duration | 1,488 |
| Piped litres per person per day | 781 |
| Seconds to fill 20 liters | 409 |
| Water-quality measurement columns | 382 each |

### Other Observations

- One row is missing its Unique ID, Instance Id, Date and Geo Level 2.
- No completely duplicated rows were found.
- No repeated non-empty Unique ID or Instance Id values were found.
- One spelling inconsistency was identified: `yes` instead of `Yes`.
- Some missing values may be expected because certain fields apply only to particular technologies, such as handpumps or piped systems.
- Missing values will be investigated during Phase IV data cleaning.

### Record Count Note

The project proposal refers to 2,057 valid records reported in the WPdx catalogue. The downloaded workbook contains 2,062 data rows, including one row with missing identifiers.

These figures refer to different counts and should not be treated as identical.

## 12. Data Limitations

- The dataset is historical and its latest assessment date is June 2021.
- It covers sampled programme districts rather than the entire country.
- Some fields contain missing values.
- The dataset does not provide a complete operational history of fault reports, repair assignments or maintenance activities.
- The dataset does not provide an independent assessment identifier because `Instance Id` duplicates `Unique ID` in the complete records.
