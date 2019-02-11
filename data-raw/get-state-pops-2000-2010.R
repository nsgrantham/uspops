library(tidyverse)

cat("Calculating state population data from county population data for 2000 to 2010 ... ")

read_tsv(file.path("data-raw", "county-pops-2000-2010.tsv"),
         col_types = cols(), progress = FALSE) %>%
  group_by(year, state, hispanic_origin, race, sex, age_group) %>%
  summarize(pop = sum(pop)) %>%
  write_tsv(file.path("data-raw", "state-pops-2000-2010.tsv"))

cat("Done.\n")
