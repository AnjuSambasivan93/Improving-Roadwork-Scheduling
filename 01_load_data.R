# Source the setup script to load libraries and define global variables
source("00_setup.R")

# ------------------------------------------------
# 1. Load the datasets from the project folder
# ------------------------------------------------

# ------------------------------------------------
# 1.1 Load the Spark data
# ------------------------------------------------

# Load the Spark telecommunications data from a gzipped CSV file.
# Specify column types to ensure the SA2 code is read as a character to prevent truncation.
# The sa2 column is made a character to keep the zeros at the start, as SA2 codes are names, not numbers.
sp_data <- read_csv("sp_data.csv.gz", 
                    col_types = cols(
                      sa2 = col_character() # Treat the `sa2` column as a character type to preserve leading zeros
                    ))

# ------------------------------------------------
# 1.2 Load the Vodafone data
# ------------------------------------------------

# Load the Vodafone telecommunications data from a Parquet file.
# read_parquet() can’t rename columns while loading, so use rename() after loading.
vf_data <- read_parquet("vf_data.parquet")


# ------------------------------------------------
# 1.3 Load the SA2 (Statistical Area 2) data
# ------------------------------------------------

# Load the SA2 dataset, skipping the first 6 rows (metadata).
# Specify the 'Code' column as character to ensure it is correctly handled.
sa2_2023 <- read_csv("sa2_2023.csv", skip = 6, col_types = cols(
  Code = col_character() # Treat the Code column as a character type
))

# Remove the 3rd column, unnecessary for the analysis.
sa2_2023 <- sa2_2023[, -3]

# ------------------------------------------------
# 1.4 Load the SA2 to TA (Territorial Authority) concordance data
# ------------------------------------------------

# Load the SA2 to TA concordance file, skipping the first 7 rows (metadata).
# Assign custom column names for better clarity and consistency.
# Ensure the SA2 code is treated as a character type.
sa2_ta_concord <- read_csv("sa2_ta_concord_2023.csv", skip = 7, 
                           col_names = c("sa2_code", "sa2_name", "mapping_type", "ta_code", "ta_name"),
                           col_types = cols(
                             sa2_code = col_character() # Treat sa2_code as a character type
                           ))

# Drop the 6th column, which is unnecessary for the analysis.
sa2_ta_concord <- sa2_ta_concord[, -6]

# ------------------------------------------------
# 1.5 Load the subnational population estimates data
# ------------------------------------------------

# Load the population estimates dataset.
subnational_pop_est <- read_csv("subnational_pop_ests.csv")

# Remove unnecessary columns: the first 8, as well as the 4th and 5th columns.
# After removing columns 1 to 8, the code then removes the new 4th and 5th columns from the remaining dataset.
# Retain only the relevant data for analysis.
subnational_pop_est <- subnational_pop_est[, -c(1:8)][, -4][, -5]

# ------------------------------------------------
# 1.6 Load the urban/rural to indicator concordance data
# ------------------------------------------------

# Load the urban/rural indicator dataset, skipping the first 7 rows (metadata).
# Assign custom column names for clarity and specify column types.
urban_rural_indicator <- read_csv("urban_rural_to_indicator_2023.csv", skip = 7,
                                  col_names = c("ur_code", "ta_name", "mapping_type", "ur_indicator", "ur_type"),
                                  col_types = cols(
                                    ur_code = col_character() # Treat ur_code as a character type
                                  ))

# Remove the 6th column, which is not needed for the analysis.
urban_rural_indicator <- urban_rural_indicator[, -6]

# ------------------------------------------------
# 1.7 Load the urban/rural to SA2 concordance data
# ------------------------------------------------

# Load the urban/rural to SA2 concordance dataset, skipping the first 7 rows (metadata).
# Assign custom column names for clarity and specify column types for SA2 and UR codes.
urban_rural_sa2_concord <- read_csv("urban_rural_to_sa2_concord_2023.csv", skip = 7,
                                    col_names = c("sa2_code", "region_name", "mapping_type", "ur_code", "ur_name"),
                                    col_types = cols(
                                      sa2_code = col_character(),  
                                      ur_code = col_character() # Treat both sa2_code and ur_code as character types
                                    ))

# Remove the 6th column, which is unnecessary for the analysis.
urban_rural_sa2_concord <- urban_rural_sa2_concord[, -6]

# ------------------------------------------------
# Inspect the datasets to ensure they are loaded properly
# ------------------------------------------------

# Use the glimpse() function to quickly view the structure of each dataset.
# Uncomment the lines below to inspect each dataset.

# glimpse(sp_data)            # Inspect the Spark data
#  glimpse(vf_data)            # Inspect the Vodafone data
# glimpse(sa2_2023)           # Inspect the SA2 data
# glimpse(sa2_ta_concord)     # Inspect the SA2 to TA concordance data
# glimpse(subnational_pop_est) # Inspect the subnational population estimates
# glimpse(urban_rural_indicator) # Inspect the urban/rural indicator data
# glimpse(urban_rural_sa2_concord) # Inspect the urban/rural to SA2 concordance data

# ------------------------------------------------
# End of Script
# ------------------------------------------------
