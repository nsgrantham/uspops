library(tidyverse)

tidy_state_population_data_tsvs <- file.path("data", "processed", 
          c("state-population-data-1970-1980.tsv", "state-population-data-1981-1989.tsv",
            "state-population-data-1990-1999.tsv", "state-population-data-2000-2010.tsv",
            "state-population-data-2011-2017.tsv"))

tidy_state_population_data_tsvs %>% 
  map_dfr(read_tsv) %>%
  select(year, state, hispanic_origin, race, sex, age_group, population) %>%
  write_tsv(file.path("data", "processed", "state-population-data-1970-2017.tsv"))
