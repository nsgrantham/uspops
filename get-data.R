library(tidyverse)
library(pdftools)

us_names <- c("United States", state.name, "District of Columbia", "Puerto Rico") %>%
  setNames(c("US", state.abb, "DC", "PR"))

pops <- list()

raw_data_1980s <- read_file("https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st8090ts.txt")

pops[["1980s"]] <- read_table(raw_data_1980s, col_names = c("us_abbr", "1980", "1981", "1982", "1984"), skip = 10, n_max = 52) %>%
  left_join(read_table(raw_data_1980s, col_names = c("us_abbr", "1985", "1986", "1987", "1988", "1989", "census_1990"), skip = 69, n_max = 118), by = "us_abbr") %>%
  mutate(us_name = recode(us_abbr, !!! us_names)) %>%
  select(-census_1990, -us_abbr) %>%
  gather(year, pop, -us_name)

pops[["1990s"]] <- pdf_text("https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/co-est2001-12-00.pdf") %>%
  str_split("\n") %>%
  unlist() %>%
  str_replace("USA", "United States") %>%
  Filter(function(x) any(startsWith(x, us_names)), .) %>%
  str_replace_all(",", "") %>%
  str_split("\\s+") %>%
  lapply(function(x) {
    rev_x = rev(x)
    us_name = paste(rev_x[length(x):13], collapse = " ")
    pop_values = rev_x[12:1]
    c(us_name, pop_values)
  }) %>%
  do.call(rbind, .) %>%
  as_tibble() %>%
  magrittr::set_colnames(c("us_name", "base_1990", "1990", "1991", "1992", "1993", "1994",
                           "1995", "1996", "1997", "1998", "1999", "census_2000")) %>%
  select(-base_1990, -census_2000) %>%
  gather(year, pop, -us_name) %>%
  mutate(pop = as.numeric(pop))

pops[["2000s"]] <- read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2000-2009/national/totals/nst_est2009_alldata.csv") %>%
  filter(NAME %in% us_names) %>%
  select(us_name = NAME,
         `2000` = POPESTIMATE2000,
         `2001` = POPESTIMATE2001,
         `2002` = POPESTIMATE2002,
         `2003` = POPESTIMATE2003,
         `2004` = POPESTIMATE2004,
         `2005` = POPESTIMATE2005,
         `2006` = POPESTIMATE2006,
         `2007` = POPESTIMATE2007,
         `2008` = POPESTIMATE2008) %>%
  gather(year, pop, -us_name)

pops[["2010s"]] <- read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/national/totals/nst-est2018-alldata.csv") %>%
  filter(NAME %in% us_names) %>%
  select(us_name = NAME,
         `2010` = POPESTIMATE2010,
         `2011` = POPESTIMATE2011,
         `2012` = POPESTIMATE2012,
         `2013` = POPESTIMATE2013,
         `2014` = POPESTIMATE2014,
         `2015` = POPESTIMATE2015,
         `2016` = POPESTIMATE2016,
         `2017` = POPESTIMATE2017,
         `2018` = POPESTIMATE2018) %>%
  gather(year, pop, -us_name)

us_pops <- bind_rows(pops) %>%
  filter(us_name == "United States") %>%
  select(-us_name)

save(us_pops, file = file.path("data", "us_pops.rda"))

state_pops <- bind_rows(pops) %>%
  filter(us_name != "United States") %>%
  select(year, state = us_name, pop)

save(state_pops, file = file.path("data", "state_pops.rda"))