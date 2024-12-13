# From Data to Action: Improving Roadwork Scheduling in High-Traffic Areas

## Objective
This project aims to determine the optimal timing for scheduling roadworks in the Central Business Districts (CBDs) of Auckland, Wellington, and Christchurch. By analyzing telecommunications data, the goal is to identify periods with lower population density to minimize disruptions.
## Tools and Libraries

- **R Programming Language**: Utilized for data manipulation, analysis, and visualization.
- **Tidyverse**: A collection of R packages (including `dplyr`, `ggplot2`, and `readr`) for data science tasks.
- **Lubridate**: Facilitates the handling and parsing of date-time data.
- **ggplot2**: Employed for creating detailed and customizable visualizations.
- **Arrow**: For reading and writing Parquet files.
- **Slider**: For sliding window operations.

## Key Functions Used

- `read_csv()`: Reads CSV files into R as data frames.
- `read_parquet()`: Imports Parquet files into R.
- `mutate()`: Adds or modifies columns in a data frame.
- `filter()`: Selects rows based on specified conditions.
- `group_by()` and `summarise()`: Aggregate data to compute summary statistics.
- `left_join()`: Merges two data frames based on a common key.
- `ggplot()`: Creates complex plots using a layered grammar of graphics.
- `as.POSIXct()`: To handle date-time conversions.
- `summarise()`: To create summary statistics.

## Tasks Completed

1. **Data Loading and Preparation**:
   - Imported multiple datasets, including telecommunications data from Spark and Vodafone, SA2 area data, and concordance files.
   - Ensured proper data types for columns, especially for codes that should be treated as character strings to preserve leading zeros.
   - Inspected datasets for structure and content accuracy.

2. **Missingness Analysis**:
   - Identified and quantified missing values across datasets.
   - Found that the `device_cnt` column had 14,157 missing values in both Spark and Vodafone datasets.
   - Confirmed no missing values in other datasets.

3. **Data Cleaning and Transformation**:
   - Renamed columns for consistency across datasets.
   - Converted timestamps to New Zealand Standard Time (NZST).
   - Handled missing values by removing rows with NA entries.
   - Removed duplicate rows to ensure data integrity.

4. **Data Aggregation and Merging**:
   - Combined Spark and Vodafone datasets into a unified dataset.
   - Aggregated device counts by timestamp and SA2 code.
   - Merged aggregated data with SA2 to Territorial Authority (TA) concordance to append TA codes.

5. **Analysis and Visualization**:
   - Filtered data for specific CBD SA2 codes in Christchurch, Wellington, and Auckland.
   - Defined normal and holiday weeks for comparative analysis.
   - Classified data into week categories and filtered for daytime hours (6 AM to 7 PM, Monday to Saturday).
   - Calculated daily averages and totals of device counts.
   - Performed sliding window analysis for multi-day periods.
   - Created visualizations to depict device count patterns across different times and areas.

## Output
 The analysis provided insights into population patterns within the CBDs during normal and school holiday weeks. Visualizations highlighted periods with lower device counts, suggesting optimal times for scheduling roadworks to minimize public disruption. The findings assist in strategic planning for road maintenance activities in urban centers.



