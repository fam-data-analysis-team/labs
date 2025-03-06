library(tidyverse)
library(anytime)
library(naniar)

dt <- read_csv(
  "data/raw/air_quality.csv",
  na = c("", "-", "ND"),
  col_types = c(date = "character")
)

# Fix date format
dt$date <- anytime(dt$date)

# Convert text to factors
dt <- dt %>% mutate(
  sitename = as.factor(sitename),
  county = as.factor(county),
  pollutant = as.factor(pollutant),
  status = factor(status, levels=c("Good", "Moderate", "Unhealthy for Sensitive Groups", "Unhealthy", "Very Unhealthy", "Hazardous"))
)

# Replace code numbers with NA
dt <- dt %>%
  replace_with_na(replace = list(
    aqi = -1,
    so2 = -999,
    co = -999,
    o3 = -999,
    pm10 = -999,
    pm2.5 = -999,
    winddirec = 990
  ))

# Remove unnecessary columns
dt <- dt %>% select(!c(pollutant, unit, longitude, latitude, siteid, o3_8hr, co_8hr, pm2.5_avg, pm10_avg, so2_avg))

# See notes/air_quality_reform.md
reform_date <- as.Date("21-11-2017", "%d-%m-%Y")
dt <- dt %>% add_column(
  after_reform = ifelse(dt$date >= reform_date, TRUE, FALSE))

# Normalize winddirec - make 360 deg to be 0 deg
dt$winddirec <- dt$winddirec %>% replace(dt$winddirec == 360, 0)

dir.create("data/processed", recursive = TRUE)
saveRDS(dt, "data/processed/air_quality_tidy.RDS")