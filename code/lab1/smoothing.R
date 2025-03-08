library(tidyverse)

df <- readRDS("data/processed/air_quality_tidy.rds")

df_grouped <- df %>%
  group_by(date = as.Date(date), county) %>%
  summarise(across(
    c(aqi, so2, co, o3, 'pm2.5', pm10, no2, nox, no, windspeed, winddirec), 
    ~median(.x, na.rm = TRUE))
  )

saveRDS(df_grouped, "data/processed/air_quality_smooth.rds")