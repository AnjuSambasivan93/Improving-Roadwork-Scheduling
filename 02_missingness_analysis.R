# Load the data loading script to import datasets
source("01_load_data.R")


# ------------------------------------------------
# 1. Missingness analysis for Spark data (`sp_data`)
# ------------------------------------------------

# Check for missing values in the Spark data
total_missing_sp <- sum(is.na(sp_data))              # Total missing values
missing_per_column_sp <- colSums(is.na(sp_data))     # Missing values by column
missing_per_column_sp
total_missing_sp

# Result-1: Total missing values: 14,157 in `device_cnt` column.

# ------------------------------------------------
# 4. Missingness analysis for Vodafone data (`vf_data`)
# ------------------------------------------------

# Check for missing values in the Vodafone data
total_missing_vf <- sum(is.na(vf_data))              # Total missing values
missing_per_column_vf <- colSums(is.na(vf_data))     # Missing values by column
missing_per_column_vf
total_missing_vf

# Result-2: Total missing values: 14,157 in `device_cnt` column.

# ------------------------------------------------
# 2. Missingness analysis for other datasets
# ------------------------------------------------

# Result-3: # No missing values in any of these below datasets.

# SA2 data (`sa2_2023`)
total_missing_sa2 <- sum(is.na(sa2_2023))             # Total missing values
missing_per_column_sa2 <- colSums(is.na(sa2_2023))    # Missing values by column
missing_per_column_sa2
total_missing_sa2 

# SA2 to TA Concordance data (`sa2_ta_concord`)
total_missing_sa2_ta <- sum(is.na(sa2_ta_concord))       # Total missing values
missing_per_column_sa2_ta <- colSums(is.na(sa2_ta_concord)) # Missing values by column
missing_per_column_sa2_ta
total_missing_sa2_ta

# Subnational Population Estimates data (`subnational_pop_est`)
total_missing_pop <- sum(is.na(subnational_pop_est))  # Total missing values
missing_per_column_pop <- colSums(is.na(subnational_pop_est)) # Missing values by column
missing_per_column_pop 
total_missing_pop

# Urban/Rural Indicator data (`urban_rural_indicator`)
total_missing_urban_rural <- sum(is.na(urban_rural_indicator))    # Total missing values
missing_per_column_urban_rural <- colSums(is.na(urban_rural_indicator)) # Missing values by column
missing_per_column_urban_rural
total_missing_urban_rural

# Urban/Rural to SA2 Concordance data (`urban_rural_sa2_concord`)
total_missing_urban_sa2 <- sum(is.na(urban_rural_sa2_concord))   # Total missing values
missing_per_column_urban_sa2 <- colSums(is.na(urban_rural_sa2_concord)) # Missing values by column
missing_per_column_urban_sa2
total_missing_urban_sa2

# ------------------------------------------------
# End of script
# ------------------------------------------------
