# From Data to Action: Improving Roadwork Scheduling in High-Traffic Areas
# --------------------------------------------------------------------------
# This file is a place to load any libraries and declare any global variables.

# ------------------------------------------------
# 1. Global Variables
# ------------------------------------------------

# Define the start and end of a "normal" week for analysis
normal_week_start <- as.POSIXct("2024-06-03 00:00:00")  # Start of the normal week
normal_week_end <- as.POSIXct("2024-06-09 23:59:00")    # End of the normal week

# Define the start and end of a "holiday" week for analysis
holiday_week_start <- as.POSIXct("2024-06-10 00:00:00") # Start of the holiday week
holiday_week_end <- as.POSIXct("2024-06-16 23:59:00")   # End of the holiday week

# ------------------------------------------------
# 2. Install/Load Libraries
# ------------------------------------------------

# Ensure the required packages are installed and loaded.
# If a package is not installed, it will be installed first, then loaded.

# Tools for working with data and creating plots
if (!require(tidyverse)) {       # Checks if the tidyverse package is already installed
  install.packages("tidyverse")  # Installs tidyverse if not installed
  library(tidyverse)             # Loads the tidyverse package
}

# To read tabular data files like CSV
if (!require(readr)) {            # Checks if the readr package is installed
  install.packages("readr")       # Installs readr if not installed
  library(readr)                  # Loads the readr package
}

# To work with dates and times
if (!require(lubridate)) {      # Checks if the lubridate package is installed
  install.packages("lubridate") # Installs lubridate if not installed
  library(lubridate)            # Loads the lubridate package
}

# To manipulate data (e.g., filtering, selecting columns)
if (!require(dplyr)) {          # Checks if the dplyr package is installed
  install.packages("dplyr")     # Installs dplyr if not installed
  library(dplyr)                # Loads the dplyr package
}

# To create charts and graphs
if (!require(ggplot2)) {        # Checks if the ggplot2 package is installed
  install.packages("ggplot2")   # Installs ggplot2 if not installed
  library(ggplot2)              # Loads the ggplot2 package
}

# To reshape and clean data (e.g., pivoting or handling missing values)
if (!require(tidyr)) {          # Checks if the tidyr package is installed
  install.packages("tidyr")     # Installs tidyr if not installed
  library(tidyr)                # Loads the tidyr package
}

# To read and process Parquet files
if (!require(arrow)) {          # Checks if the arrow package is installed
  install.packages("arrow")     # Installs arrow if not installed
  library(arrow)                # Loads the arrow package
}

# To perform rolling or sliding window calculations
if (!require(slider)) {         # Checks if the slider package is installed
  install.packages("slider")    # Installs slider if not installed
  library(slider)               # Loads the slider package
}

# ------------------------------------------------
# End of Script
# ------------------------------------------------
