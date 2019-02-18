library(tidyverse)
library(pdftools)  # used for scraping 1990-1999 data from a pdf

us_names <- c("United States", state.name, "District of Columbia", "Puerto Rico") %>%
  setNames(c("US", state.abb, "DC", "PR"))

parse_pre_1970s_txt <- function(url, year_cols_1, us_skip_1, state_skip_1, 
                                year_cols_2, us_skip_2, state_skip_2, state_n_max,
                                drop_vars = NULL) {
  raw_data <- read_file(url)
  
  us_data <- read_table(raw_data, col_names = c("us_abbr", year_cols_1), skip = us_skip_1, n_max = 1) %>%
    left_join(read_table(raw_data, col_names = c("us_abbr", year_cols_2), skip = us_skip_2, n_max = 1), by = "us_abbr") %>%
    mutate(us_abbr = recode(us_abbr, "U.S." = "US"))
  
  state_data <- read_table(raw_data, col_names = c("us_abbr", year_cols_1), skip = state_skip_1, n_max = state_n_max) %>%
    left_join(read_table(raw_data, col_names = c("us_abbr", year_cols_2), skip = state_skip_2, n_max = state_n_max), by = "us_abbr")
 
  bind_rows(us_data, state_data) %>%
    mutate(us_name = recode(us_abbr, !!! us_names)) %>%
    select(-one_of(c("us_abbr", drop_vars))) %>%
    gather(year, pop, -us_name) %>%
    mutate(year = as.integer(year), 
           pop = as.integer(1000 * pop))
}

pops <- list()

pops[["1900s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st0009ts.txt",
  year_cols_1 = as.character(1900:1905), us_skip_1 = 17, state_skip_1 = 23,
  year_cols_2 = as.character(1906:1909), us_skip_2 = 75, state_skip_2 = 81,
  state_n_max = 49
)

pops[["1910s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st1019ts.txt",
  year_cols_1 = as.character(1910:1915), us_skip_1 = 17, state_skip_1 = 23,
  year_cols_2 = as.character(1916:1919), us_skip_2 = 75, state_skip_2 = 81,
  state_n_max = 49
)

pops[["1920s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st2029ts.txt",
  year_cols_1 = as.character(1920:1925), us_skip_1 = 17, state_skip_1 = 23,
  year_cols_2 = as.character(1926:1929), us_skip_2 = 75, state_skip_2 = 81,
  state_n_max = 49
)

pops[["1930s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st3039ts.txt",
  year_cols_1 = as.character(1930:1935), us_skip_1 = 17, state_skip_1 = 23,
  year_cols_2 = as.character(1936:1939), us_skip_2 = 76, state_skip_2 = 81,
  state_n_max = 49
)

pops[["1940s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st4049ts.txt",
  year_cols_1 = as.character(1940:1945), us_skip_1 = 14, state_skip_1 = 21,
  year_cols_2 = as.character(1946:1949), us_skip_2 = 73, state_skip_2 = 79,
  state_n_max = 49
)

# Although Alaska and Hawaii officially joined the US in 1959, their 
# population estimates are included beginning in 1950.
pops[["1950s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st5060ts.txt",
  year_cols_1 = c("1950_census", as.character(1950:1954)), us_skip_1 = 17, state_skip_1 = 27,
  year_cols_2 = c(as.character(1955:1959), "1960_census"), us_skip_2 = 82, state_skip_2 = 92,
  state_n_max = 51, drop_vars = c("1950_census", "1960_census")
)

pops[["1960s"]] <- parse_pre_1970s_txt(
  "https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st6070ts.txt",
  year_cols_1 = c("1960_census", as.character(1960:1964)), us_skip_1 = 17, state_skip_1 = 24,
  year_cols_2 = c(as.character(1965:1969), "1970_census"), us_skip_2 = 80, state_skip_2 = 86,
  state_n_max = 51, drop_vars = c("1960_census", "1970_census")
)

raw_data_1970s <- read_file("https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st7080ts.txt")

pops[["1970s"]] <- read_table(raw_data_1970s, col_names = c("fips", "us_abbr", as.character(1970:1974)), skip = 14, n_max = 52) %>%
  left_join(read_table(raw_data_1970s,  col_names = c("fips", "us_abbr", as.character(1975:1979), "census_1980"), skip = 67, n_max = 52), by = "us_abbr") %>%
  mutate(us_name = recode(us_abbr, !!! us_names)) %>%
  select(-fips.x, -fips.y, -census_1980, -us_abbr) %>%
  gather(year, pop, -us_name) %>%
  mutate(year = as.integer(year),
         pop = as.integer(pop))

raw_data_1980s <- read_file("https://www2.census.gov/programs-surveys/popest/tables/1980-1990/state/asrh/st8090ts.txt")

pops[["1980s"]] <- read_table(raw_data_1980s, col_names = c("us_abbr", as.character(1980:1984)), skip = 10, n_max = 52) %>%
  left_join(read_table(raw_data_1980s, col_names = c("us_abbr", as.character(1985:1989), "census_1990"), skip = 69, n_max = 52), by = "us_abbr") %>%
  mutate(us_name = recode(us_abbr, !!! us_names)) %>%
  select(-census_1990, -us_abbr) %>%
  gather(year, pop, -us_name) %>%
  mutate(year = as.integer(year),
         pop = as.integer(pop))

pops[["1990s"]] <- pdf_text("https://www2.census.gov/programs-surveys/popest/tables/1990-2000/intercensal/st-co/co-est2001-12-00.pdf") %>%
  str_split("\n") %>%
  unlist() %>%
  str_replace("USA", "United States") %>%
  Filter(function(x) any(startsWith(x, us_names)), .) %>%
  str_replace_all(",", "") %>%
  str_split("\\s+") %>%  # split on any number of whitespace characters
  lapply(function(x) {
    rev_x <- rev(x)
    us_name <- paste(rev_x[length(x):13], collapse = " ")
    pop_values <- rev_x[12:1]
    c(us_name, pop_values)
  }) %>%
  do.call(rbind, .) %>%
  magrittr::set_colnames(c("us_name", "base_1990", as.character(1990:1999), "census_2000")) %>%
  as_tibble() %>%
  select(-base_1990, -census_2000) %>%
  gather(year, pop, -us_name) %>%
  mutate(year = as.integer(year), 
         pop = as.integer(pop))

pops[["2000s"]] <- read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2000-2009/national/totals/nst_est2009_alldata.csv",
                            col_types = cols(), progress = FALSE) %>%
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
         `2008` = POPESTIMATE2008,
         `2009` = POPESTIMATE2009) %>%
  gather(year, pop, -us_name) %>%
  mutate(year = as.integer(year),
         pop = as.integer(pop))

pops[["2010s"]] <- read_csv("https://www2.census.gov/programs-surveys/popest/datasets/2010-2018/national/totals/nst-est2018-alldata.csv",
                            col_types = cols(), progress = FALSE) %>%
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
  gather(year, pop, -us_name) %>%
  mutate(year = as.integer(year),
         pop = as.integer(pop))

us_pops <- bind_rows(pops) %>%
  filter(us_name == "United States") %>%
  select(-us_name)

save(us_pops, file = file.path("data", "us_pops.rda"))

state_pops <- bind_rows(pops) %>%
  filter(us_name != "United States") %>%
  select(year, state = us_name, pop)

# Quick check to see if the sum of the state populations  
# is approximately equal to the aggregate US population.
# (US population 2010-2018 does not include Puerto Rico)
state_pops %>%
  filter(state != "Puerto Rico") %>%
  group_by(year) %>%
  summarize(pop = sum(pop)) %>%
  left_join(us_pops, by = "year", suffix = c("_us", "_state_sum")) %>%
  mutate(within_tenth_percent = (0.999 * pop_state_sum < pop_us) && (pop_us < 1.001 * pop_state_sum)) %>%
  pull(within_tenth_percent) %>%
  all()  # TRUE

save(state_pops, file = file.path("data", "state_pops.rda"))
