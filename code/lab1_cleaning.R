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
  status = as.factor(status)
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
dt <- dt %>% select(!c(unit, longitude, latitude, siteid))

write_csv(dt, "data/processed/air_quality_tidy.csv")