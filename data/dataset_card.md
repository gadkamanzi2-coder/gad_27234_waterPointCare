# Dataset Card – WaterPointCare Rwanda

## 1. Dataset Name
Rwanda Water Points Dataset (2021)

## 2. Dataset File
`water_points_rwanda_2021(1).xlsx`

## 3. Dataset Description
This dataset contains information about water points in Rwanda. It includes their locations, technology types, service levels, functionality, number of users, water availability, water quantity and water quality.

The dataset will help our project understand the condition of water points and provide background information for the WaterPointCare Rwanda system.

## 4. Dataset Structure
- Main worksheet: `Transformed Data`
- Number of records: 2,062
- Number of columns: 39
- Unique non-empty water-point IDs: 2,061
- Exact duplicate rows: 0

## 5. Geographic Coverage
The dataset contains water points from three districts:
- Gicumbi
- Rulindo
- Kicukiro

The country recorded in the dataset is Rwanda.

## 6. Time Coverage
The assessment dates range from 1 January 2015 to 17 June 2021.

## 7. Main Information Available
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

## 8. Initial Data Quality Observation
The dataset contains 10,171 missing cells, representing approximately 12.65% of all cells.

There are no completely duplicated rows. One record has missing values across its fields, including its water-point ID.

Some missing values may be normal because certain columns apply only to specific water-point technologies, such as handpumps or piped systems. These cases will be investigated during data cleaning.

## 9. Project Use
WaterPointCare Rwanda will use this dataset as historical water-point information.

Our system will focus on reporting water-point faults, assigning maintenance teams, tracking repair jobs, recording spare-part usage and keeping a history of status changes.

The historical dataset will provide useful information about water points, while the operational system will manage new fault reports and maintenance activities.


