library(tidyverse)

df <- readRDS("data/processed/air_quality_tidy.rds")

trimmed_df <- df[df$date %>% format("%Y") %>% as.numeric() >= 2023, ]
trimmed_df %>% saveRDS("data/processed/air_quality_trimmed.rds")