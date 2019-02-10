library(tidyverse)

cat("Calculating state population estimates from county data (2000-2010) ... ")

read_tsv(file.path("data-raw", "tidy-county-pops-2000-2010.tsv"),
         col_types = cols(), progress = FALSE) %>%
  group_by(year, state, hispanic_origin, race, sex, age_group) %>%
  summarize(pop = sum(pop)) %>%
  write_tsv(file.path("data-raw", "tidy-state-pops-2000-2010.tsv"))

cat("Done.\n")
