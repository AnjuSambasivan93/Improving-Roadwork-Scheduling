# -----------------------------------------------------------------------

# ASSUMPTIONS
# CBD SA2 codes - Christchurch
# 326600 - Christchurch Central
# 325700 - Christchurch Central-West
# 327000 - Christchurch Central-East
# 325800 - Christchurch Central-North
# 327100 - Christchurch Central-South
# Normal week:
#   Start: "2024-06-03 00:00:00"
#   End:   "2024-06-09 23:59:00"
# Holiday week:
#   Start: "2024-06-10 00:00:00"
#   End:   "2024-06-16 23:59:00"
# num devices = num people in that area at that time
# day time = 6am to 7pm, monday to saturday

# -----------------------------------------------------------------------

# Christchurch CBD SA2 codes
christchurch_cbd_sa2_codes <- c("326600", "325700", "327000", "325800", "327100")

# Define time ranges for normal and holiday weeks
normal_week_start_time <- as.POSIXct("2024-06-03 00:00:00", tz = "Pacific/Auckland")
normal_week_end_time <- as.POSIXct("2024-06-09 23:59:00", tz = "Pacific/Auckland")

holiday_week_start_time <- as.POSIXct("2024-06-10 00:00:00", tz = "Pacific/Auckland")
holiday_week_end_time <- as.POSIXct("2024-06-16 23:59:00", tz = "Pacific/Auckland")

# Custom function to convert 12-hour time format to 24-hour format
convert_time_12_to_24 <- function(time_12_hour_format) {
  temp_time <- paste("2000-01-01", time_12_hour_format)  # Append a dummy date to the time
  hour(ymd_hm(temp_time))                               # Extract the hour using lubridate
}

# -----------------------------------------------------------------------
# Filter and Classify Data
# -----------------------------------------------------------------------

# Filter data for Christchurch CBD areas
filtered_cbd_data <- result_data %>% 
  filter(sa2_code %in% christchurch_cbd_sa2_codes)

# Add a new column to classify timestamps into week types (normal, school holidays, other)
classified_cbd_data <- filtered_cbd_data %>%
  mutate(week_category = case_when(
    ts >= normal_week_start_time & ts <= normal_week_end_time ~ "normal",
    ts >= holiday_week_start_time & ts <= holiday_week_end_time ~ "school_holidays",
    TRUE ~ "other"  # For timestamps outside the defined ranges
  ))

# Filter data for daytime hours (7:00 AM to 7:00 PM)
daytime_cbd_data <- classified_cbd_data %>%
  mutate(hour_of_day = hour(ts)) %>%  # Extract hour from timestamp
  filter(hour_of_day >= convert_time_12_to_24("7:00 AM"),
         hour_of_day <= convert_time_12_to_24("7:00 PM")) %>%
  select(-hour_of_day)  # Remove the temporary column

# -----------------------------------------------------------------------
# Calculate Daily Averages and Totals
# -----------------------------------------------------------------------

# Group data by day and calculate daily averages and totals
daily_cbd_summary <- classified_cbd_data %>%
  group_by(day = as_date(ts)) %>%  # Convert timestamps to dates for grouping
  summarise(avg_device_count = mean(device_cnt), 
            total_device_count = sum(device_cnt))

# -----------------------------------------------------------------------
# Sliding Window Analysis for Multi-Day Construction
# -----------------------------------------------------------------------

# Define the length of construction projects in days
construction_project_days <- 2

# Calculate totals and averages for sliding windows of days
sliding_window_analysis <- daily_cbd_summary %>%
  mutate(sliding_window_total = slide_index_sum(
    x = total_device_count,   # Sum device counts over a sliding window
    i = day,
    after = days(construction_project_days),
    complete = TRUE
  )) %>%
  mutate(sliding_window_avg = sliding_window_total / construction_project_days)  # Calculate range averages

# -----------------------------------------------------------------------
# Analyze Daytime Data
# -----------------------------------------------------------------------

# Group daytime data by day and calculate averages and totals
daytime_cbd_summary <- daytime_cbd_data %>% 
  group_by(day = as_date(ts)) %>%  # Group by date
  summarise(avg_device_count = mean(device_cnt), total_device_count = sum(device_cnt)) %>%  # Calculate daily averages and totals
  mutate(week_category = case_when(
    day >= normal_week_start_time & day <= normal_week_end_time ~ "normal",
    day >= holiday_week_start_time & day <= holiday_week_end_time ~ "school_holidays",
    TRUE ~ "other"
  )) %>%
  group_by(week_category, day_of_week = wday(day, label = TRUE, abbr = FALSE))  # Group by week type and day of the week

# -----------------------------------------------------------------------
# Create Plots
# -----------------------------------------------------------------------

# Plot daily average counts as a line chart
daily_avg_plot <- ggplot(data = daily_cbd_summary, aes(x = day, y = avg_device_count)) + 
  geom_line() +
  scale_x_date(date_breaks = "1 day", date_labels = "%d\n%B") +
  labs(title = "Daily Average Device Count in Christchurch CBD",
       x = "Date",
       y = "Average Device Count") +
  theme_minimal()

daily_avg_plot

# Plot daytime device counts as a bar chart
chch_daytime_avg_plot <- ggplot(data = daytime_cbd_summary, aes(x = day_of_week, y = avg_device_count, fill = week_category)) + 
  geom_bar(position = "dodge", stat = "identity") + 
  labs(title = "Christchurch Average Device Count by Day of the Week (Daytime Hours)",
       x = "Day of the Week",
       y = "Average Device Count",
       fill = "Week Type") +
  theme_minimal()

chch_daytime_avg_plot

# -----------------------------------------------------------------------
# Hourly Average Analysis and Plot
# -----------------------------------------------------------------------

# Calculate hourly averages for each week type
hourly_avg_summary <- classified_cbd_data %>%
  mutate(hour_of_day = hour(ts)) %>%  # Extract hour from timestamp using lubridate
  group_by(week_category, hour_of_day) %>%  # Group by week type and hour
  summarise(avg_device_count = mean(device_cnt, na.rm = TRUE)) %>%  # Calculate average device count
  ungroup()

# Plot hourly average device counts
chch_hourly_avg_plot <- ggplot(hourly_avg_summary, aes(x = hour_of_day, y = avg_device_count, color = week_category)) +
  geom_line() +
  labs(title = "Christchurch Hourly Device Count During Normal vs. School Holidays",
       x = "Hour of the Day",
       y = "Average Device Count",
       color = "Week Type") +
  theme_minimal()

chch_hourly_avg_plot

# ------------------------------------------------
# End of script
# ------------------------------------------------
