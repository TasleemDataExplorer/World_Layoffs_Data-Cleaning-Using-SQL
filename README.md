# World Layoffs Data Cleaning using SQL


## Project Overview

This project focuses on cleaning and preparing a real-world layoffs dataset using MySQL.
The raw dataset contained duplicate records, inconsistent text values, incorrect date formats, and missing data. The goal was to transform the raw data into a clean, structured format suitable for analysis and visualization.

This project demonstrates practical SQL data cleaning techniques commonly used in real business environments.

## Dataset Description
The dataset includes global layoff information with the following columns:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

## Tools Used
- MySQL
- SQL Window Functions
- Common Table Expressions (CTEs)

## Data Cleaning Steps Performed

**1.** Created a Staging Table

To avoid modifying the original dataset, a staging table was created and populated with raw data.

**2.** Identified and Removed Duplicate Records

- Duplicates were detected using a ROW_NUMBER() window function across all relevant columns.
- A new staging table was created to store duplicate flags
- Rows with row_num > 1 were deleted
- This ensured only unique records remained.

**3.** Standardized Text Data

Several columns contained inconsistent formatting.

***Actions taken***
- Trimmed extra spaces from company names
- Standardized industry values (e.g., multiple “crypto” variations → Crypto)
- Cleaned country names (e.g., United States. → United States)

**4.** Converted Date Column

The date column was stored as text.
It was converted into a proper DATE format using STR_TO_DATE() and then modified to a DATE data type.

**5.** Handled Missing and Null Values

- Identified rows where both total_laid_off and percentage_laid_off were null
- These rows were removed as they provided no meaningful information
- Blank industry values were converted to NULL
- Missing industry values were populated by matching company and location records
- This step improved data completeness and consistency.

**6.** Removed Unnecessary Columns

After cleaning, the helper column row_num was dropped as it was no longer required.

## Final Outcome

- Duplicate records removed
- Text fields standardized
- Dates converted to proper format
- Missing values handled logically
- Dataset cleaned and ready for analysis or visualization

## Key Skills Demonstrated
- SQL data cleaning
- Window functions
- CTEs
- Data standardization
- Handling missing and inconsistent data
- Real world data preparation workflow
