library(tidyverse)

df <- readRDS("data/processed/air_quality_tidy.rds")

df_grouped <- df %>%
  group_by(date = as.Date(date), county, sitename) %>%
  summarise(across(
    c(aqi, so2, co, o3, 'pm2.5', pm10, no2, nox, no, windspeed, winddirec), 
    ~median(.x, na.rm = TRUE)
  )) %>%
  ungroup()

# See notes/air_quality_reform.md
reform_date <- as.Date("21-11-2017", "%d-%m-%Y")
df_grouped$after_reform <- ifelse(df_grouped$date >= reform_date, TRUE, FALSE)

saveRDS(df_grouped, "data/processed/air_quality_smooth.rds")