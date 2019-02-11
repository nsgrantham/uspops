library(tidyverse)

cat("Calculating state population data from county population data for 1990 to 1999 ... ")

read_tsv(file.path("data-raw", "county-pops-1990-1999.tsv"), 
         col_types = cols(), progress = FALSE)  %>%
  group_by(year, state, hispanic_origin, race, sex, age_group) %>%
  summarize(pop = sum(pop)) %>%
  write_tsv(file.path("data-raw", "state-pops-1990-1999.tsv"))

cat("Done.\n")
