library(tidyverse)
library(here)

df <- read_csv(here("data", "raw", "population.csv"))

df <- df %>% mutate(
  county = as.factor(county),
  pop_2020 = as.integer(pop_2020),
  density = pop_2020 / area
)

saveRDS(df, here("data", "processed", "population.RDS"))