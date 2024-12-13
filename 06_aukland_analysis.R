# -----------------------------------------------------------------------

# ASSUMPTIONS
# CBD SA2 codes - Aukland
# 132700: Hobson Ridge North     
# 133200: Queen Street           
# 133400: Hobson Ridge Central   
# 133800: Hobson Ridge South     
# 134100: Queen Street South West
# Normal week:
#   Start: "2024-06-03 00:00:00"
#   End:   "2024-06-09 23:59:00"
# Holiday week:
#   Start: "2024-06-10 00:00:00"
#   End:   "2024-06-16 23:59:00"
# num devices = num people in that area at that time
# day time = 6am to 7pm, monday to saturday

# -----------------------------------------------------------------------


# -----------------------------------------------------------------------
# Auckland CBD Analysis: Device Count During Normal and School Holiday Weeks
# -----------------------------------------------------------------------

# Define SA2 codes that represent Auckland CBD areas
# These SA2 codes correspond to key Auckland CBD locations
auckland_sa2_codes <- c("133200", "132700", "134100", "133400", "133800")

# Filter the result_data to include only rows corresponding to Auckland CBD areas
auckland_data <- result_data %>% filter(sa2_code %in% auckland_sa2_codes)

# -----------------------------------------------------------------------
# Classify Data by Week Type (Normal vs School Holidays)
# -----------------------------------------------------------------------

# Add a new column to classify each timestamp into normal or school holiday weeks
auckland_data <- auckland_data %>%
  mutate(week_type = case_when(
    ts >= normal_week_start & ts <= normal_week_end ~ "normal",         # Normal week
    ts >= holiday_week_start & ts <= holiday_week_end ~ "school_holidays", # School holidays
    TRUE ~ "other"  # For timestamps outside the specified ranges
  ))

# -----------------------------------------------------------------------
# Ensure Timestamps are in POSIXct Format
# -----------------------------------------------------------------------

# Convert the `ts` column to POSIXct format to ensure consistent time zone handling
auckland_data <- auckland_data %>%
  mutate(ts = as.POSIXct(ts, tz = "Pacific/Auckland"))

# -----------------------------------------------------------------------
# Analyze Hourly Device Counts
# -----------------------------------------------------------------------

# Calculate the average device count per hour for each week type (normal or school holidays)
hourly_avg <- auckland_data %>%
  mutate(hour = lubridate::hour(ts)) %>%  # Extract the hour from the timestamp
  group_by(week_type, hour) %>%           # Group by week type and hour
  summarise(avg_device_cnt = mean(device_cnt, na.rm = TRUE)) %>%  # Calculate average device count
  ungroup()

# Plot the hourly average device counts for normal vs school holiday weeks
auckland_hourly_avg_plot <- ggplot(hourly_avg, aes(x = hour, y = avg_device_cnt, color = week_type)) +
  geom_line() +
  labs(title = "Auckland Hourly Device Count During Normal vs. School Holidays",
       x = "Hour of the Day",
       y = "Average Device Count",
       color = "Week Type") +
  theme_minimal()

# Display the plot
auckland_hourly_avg_plot

# -----------------------------------------------------------------------
# Analyze Daytime Device Counts
# -----------------------------------------------------------------------

# Define daytime hours (7:00 AM to 7:00 PM)
day_start <- 7
day_end <- 19

# Add columns for hour and day of the week
auckland_data <- auckland_data %>%
  mutate(hour = hour(ts),                                      # Extract the hour from the timestamp
         day_of_week = wday(ts, label = TRUE, abbr = FALSE))  # Get the day of the week

# Filter for daytime hours and calculate average device counts by day of the week and week type
daytime_cnt <- auckland_data %>%
  filter(hour >= day_start & hour < day_end) %>%  # Keep only daytime rows
  group_by(week_type, day_of_week) %>%            # Group by week type and day of the week
  summarise(avg_device_cnt = mean(device_cnt, na.rm = TRUE)) %>%  # Calculate average device count
  ungroup()

# -----------------------------------------------------------------------
# Visualize Daytime Device Counts by Day of the Week
# -----------------------------------------------------------------------

# Create a bar chart to compare daytime device counts by day of the week and week type
auckland_daytime_avg_plot <- ggplot(daytime_cnt, aes(x = day_of_week, y = avg_device_cnt, fill = week_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Auckland Average Device Count by Day of the Week (Daytime Hours)",
       x = "Day of the Week",
       y = "Average Device Count",
       fill = "Week Type") +
  theme_minimal()

# Display the plot
auckland_daytime_avg_plot

# ------------------------------------------------
# End of script
# ------------------------------------------------
