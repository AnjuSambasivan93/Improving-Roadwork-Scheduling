# Load the data loading script to import datasets
source("01_load_data.R")  
# Ensure this script loads `sp_data`, `vf_data`, and `sa2_ta_concord`

# ------------------------------------------------
# 1. Rename columns for consistency and clarity
# ------------------------------------------------

# Rename columns in Spark data
sp_data <- sp_data %>%
  rename(
    ts = ts,               # Keep the timestamp column as `ts`
    sa2_code = sa2,        # Rename `sa2` to `sa2_code`
    device_cnt = cnt       # Rename `cnt` to `device_cnt`
  )

# Rename columns in Vodafone data
vf_data <- vf_data %>%
  rename(
    ts = dt,                # Rename 'dt' to 'ts' for timestamps
    sa2_code = area,        # Rename 'area' to 'sa2_code'
    device_cnt = devices    # Rename 'devices' to 'device_cnt'
  )

# ------------------------------------------------
# 2. Convert timestamps to NZST
# ------------------------------------------------

# Convert timestamps in Spark data
sp_data <- sp_data %>%
  mutate(ts = with_tz(ts, tzone = "Pacific/Auckland"))

# Convert timestamps in Vodafone data
vf_data <- vf_data %>%
  mutate(ts = as.POSIXct(ts, tz = "Pacific/Auckland"))

# ------------------------------------------------
# 3. Handle missing values
# ------------------------------------------------

# Remove rows with missing values
sp_data <- sp_data %>%
  drop_na()

vf_data <- vf_data %>%
  drop_na()

# ------------------------------------------------
# 4. Remove duplicate rows
# ------------------------------------------------

# Remove duplicate rows in Spark data
sp_data <- sp_data %>%
  group_by(ts, sa2_code, device_cnt) %>%
  filter(row_number() == 1) %>%
  ungroup()

# Remove duplicate rows in Vodafone data
vf_data <- vf_data %>%
  group_by(ts, sa2_code, device_cnt) %>%
  filter(row_number() == 1) %>%
  ungroup()

# ------------------------------------------------
# 5. Combine datasets and aggregate device counts
# ------------------------------------------------

# Combine Spark and Vodafone data
combined_data <- bind_rows(sp_data, vf_data)

# Ensure timestamps in the combined dataset are in NZST
combined_data <- combined_data %>%
  mutate(ts = with_tz(ts, tzone = "Pacific/Auckland"))

# Aggregate the device count by timestamp and SA2 code
aggregated_data <- combined_data %>%
  group_by(ts, sa2_code) %>%
  summarise(device_cnt = sum(round(device_cnt, 2), na.rm = TRUE)) %>%
  ungroup()

# ------------------------------------------------
# 6. Add TA code using SA2 to TA concordance
# ------------------------------------------------

# Add TA codes to the aggregated data
result_data <- aggregated_data %>%
  left_join(sa2_ta_concord %>% select(sa2_code, ta_code), by = "sa2_code")

# ------------------------------------------------
# 7. Output the cleaned dataset as a gzipped CSV file
# ------------------------------------------------

# Specify the output file name
output_file <- "cleaned_dataset.csv.gz"

# Write the cleaned data to a gzipped CSV file
write.csv(result_data, gzfile(output_file), row.names = FALSE)

glimpse(result_data)

# ------------------------------------------------
# End of script
# ------------------------------------------------
