# -----------------------------------------------------------------------

# ASSUMPTIONS
# CBD SA2 codes - Wellington
# 250800: Northland (Wellington City)
# 251000: Wellington Botanic Gardens
# 251300: Wellington University
# 251400: Wellington Central
# 255100: Strathmore (Wellington City)
# 259600: Oceanic Wellington Region # No ddevice data (Oceanic region)
# 259700: Inlet Wellington Harbour # No device data
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
# Define Constants and Assumptions
# -----------------------------------------------------------------------

# SA2 codes for Wellington CBD areas
sa2_codes <- c("250800", "251000", "251300", "251400", "255100")

# Define time ranges for normal and holiday weeks
normal_week_start <- as.POSIXct("2024-06-03 00:00:00", tz = "Pacific/Auckland")
normal_week_end <- as.POSIXct("2024-06-09 23:59:00", tz = "Pacific/Auckland")
holiday_week_start <- as.POSIXct("2024-06-10 00:00:00", tz = "Pacific/Auckland")
holiday_week_end <- as.POSIXct("2024-06-16 23:59:00", tz = "Pacific/Auckland")

# -----------------------------------------------------------------------
# Filter Wellington CBD Data
# -----------------------------------------------------------------------

# Filter the data to include only Wellington CBD SA2 codes
wellington_data <- result_data %>% filter(sa2_code %in% sa2_codes)

# -----------------------------------------------------------------------
# Plot Time Series for Wellington CBD Areas
# -----------------------------------------------------------------------

# Plot the time series for each SA2 code in Wellington
ggplot(wellington_data, aes(x = ts, y = device_cnt)) +
  geom_line(color = "blue") +  # Line plot for time series
  labs(title = "Device Counts in Wellington CBD Areas",
       x = "Time",
       y = "Device Count") +
  facet_wrap(~ sa2_code, scales = "free_y") +  # Separate plots for each SA2 code
  theme_minimal()

# -----------------------------------------------------------------------
# Analyze Device Counts During Normal and Holiday Weeks
# -----------------------------------------------------------------------

# Filter data for normal and holiday weeks
normal_week_data <- wellington_data %>%
  filter(ts >= normal_week_start & ts <= normal_week_end)

holiday_week_data <- wellington_data %>%
  filter(ts >= holiday_week_start & ts <= holiday_week_end)

# Summarize average device counts by SA2 code for normal and holiday weeks
normal_week_summary <- normal_week_data %>%
  group_by(sa2_code) %>%
  summarise(avg_device_cnt = mean(device_cnt))

holiday_week_summary <- holiday_week_data %>%
  group_by(sa2_code) %>%
  summarise(avg_device_cnt = mean(device_cnt))

# Combine the summaries for comparison
comparison_data <- rbind(
  mutate(normal_week_summary, week = "Normal Week"),
  mutate(holiday_week_summary, week = "Holiday Week")
)

# Plot the comparison
ggplot(comparison_data, aes(x = sa2_code, y = avg_device_cnt, fill = week)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Device Count: Normal Week vs Holiday Week",
       x = "SA2 Code",
       y = "Average Device Count",
       fill = "Week") +
  theme_minimal()

# -----------------------------------------------------------------------
# Analyze Device Counts by Daytime Hours (6:00 AM - 7:00 PM)
# -----------------------------------------------------------------------

# Filter data for daytime hours
daytime_data <- wellington_data %>%
  filter(hour(ts) >= 6 & hour(ts) < 19)

# Summarize average device counts by day of the week
daytime_summary <- daytime_data %>%
  mutate(day_of_week = weekdays(ts)) %>%
  group_by(day_of_week) %>%
  summarise(avg_device_count = mean(device_cnt))

# Plot the daytime summary
ggplot(daytime_summary, aes(x = reorder(day_of_week, avg_device_count), y = avg_device_count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Avg Device Count During Daytime (6:00 AM - 7:00 PM)",
       x = "Day of the Week",
       y = "Average Device Count") +
  theme_minimal()

# -----------------------------------------------------------------------
# Analyze Device Counts by Nighttime Hours (7:00 PM - 6:00 AM)
# -----------------------------------------------------------------------

# Filter data for nighttime hours
nighttime_data <- wellington_data %>%
  filter(hour(ts) < 6 | hour(ts) >= 19)

# Summarize average device counts by day of the week
nighttime_summary <- nighttime_data %>%
  mutate(day_of_week = weekdays(ts)) %>%
  group_by(day_of_week) %>%
  summarise(avg_device_count = mean(device_cnt))

# Plot the nighttime summary
ggplot(nighttime_summary, aes(x = reorder(day_of_week, avg_device_count), y = avg_device_count)) +
  geom_bar(stat = "identity", fill = "darkblue") +
  labs(title = "Avg Device Count During Nighttime (7:00 PM - 6:00 AM)",
       x = "Day of the Week",
       y = "Average Device Count") +
  theme_minimal()

# -----------------------------------------------------------------------
# Compare Daytime vs Nighttime Device Counts
# -----------------------------------------------------------------------

# Add a column to classify timestamps as "Day" or "Night"
wellington_data <- wellington_data %>%
  mutate(time_period = case_when(
    hour(ts) >= 6 & hour(ts) < 19 ~ "Day",
    TRUE ~ "Night"
  ))

# Summarize average device counts by day of the week and time period
day_night_summary <- wellington_data %>%
  mutate(day_of_week = weekdays(ts)) %>%
  group_by(day_of_week, time_period) %>%
  summarise(avg_device_count = mean(device_cnt))

# Plot the day vs night comparison
ggplot(day_night_summary, aes(x = reorder(day_of_week, avg_device_count), y = avg_device_count, fill = time_period)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Device Count: Day vs Night",
       x = "Day of the Week",
       y = "Average Device Count",
       fill = "Time Period") +
  theme_minimal()

# -----------------------------------------------------------------------
# Analyze Device Counts by Day of the Week and CBD Areas
# -----------------------------------------------------------------------

# Add day of the week column to the data
wellington_data <- wellington_data %>%
  mutate(day_of_week = wday(ts, label = TRUE, abbr = FALSE))

# Plot device counts by day of the week and SA2 code
ggplot(wellington_data, aes(x = day_of_week, y = device_cnt, fill = sa2_code)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Device Counts by SA2 Code and Day of the Week",
       x = "Day of the Week",
       y = "Device Count",
       fill = "SA2 Code") +
  theme_minimal()

# -----------------------------------------------------------------------
# Analyze Hourly Device Counts During Normal and Holiday Weeks
# -----------------------------------------------------------------------

# Add a new column `week_type` to classify each timestamp into a specific week type
wellington_data <- wellington_data %>%
  mutate(week_type = case_when(
    ts >= normal_week_start & ts <= normal_week_end ~ "normal",
    ts >= holiday_week_start & ts <= holiday_week_end ~ "school_holidays",
    TRUE ~ "other"
  ))

# Add a column for hour of the day
hourly_avg <- wellington_data %>%
  mutate(hour = lubridate::hour(ts)) %>%
  group_by(week_type, hour) %>%
  summarise(avg_device_cnt = mean(device_cnt, na.rm = TRUE))

# Plot hourly average device counts
wellington_hourly_avg_plot <- ggplot(hourly_avg, aes(x = hour, y = avg_device_cnt, color = week_type)) +
  geom_line() +
  labs(title = "Wellington Hourly Device Count: Normal vs Holiday Weeks",
       x = "Hour of the Day",
       y = "Average Device Count",
       color = "Week Type") +
  theme_minimal()

wellington_hourly_avg_plot

# -----------------------------------------------------------------------
# Analyze Device Counts by Day of the Week for Daytime Hours
# -----------------------------------------------------------------------

# Add daytime hours and group by week type and day of the week
wellington_daytime_summary <- wellington_data %>%
  filter(hour(ts) >= 6 & hour(ts) < 19) %>%  # Filter for daytime hours
  group_by(week_type, day_of_week) %>%
  summarise(avg_device_cnt = mean(device_cnt, na.rm = TRUE))

# Plot the daytime device counts by day of the week
wellington_daytime_avg_plot <- ggplot(wellington_daytime_summary, aes(x = day_of_week, y = avg_device_cnt, fill = week_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Wellington Average Device Count by Day of the Week",
       x = "Day of the Week",
       y = "Average Device Count",
       fill = "Week Type") +
  theme_minimal()

wellington_daytime_avg_plot

glimpse(wellington_data)

# ------------------------------------------------
# End of script
# ------------------------------------------------
