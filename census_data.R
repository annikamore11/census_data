library(tidycensus)
library(dplyr)
library(sf)
library(tigris)
library(tidyr)
options(tigris_use_cache = TRUE)

# Set Census API key 
census_api_key(Sys.getenv("CENSUS_API_KEY"), install = TRUE, overwrite = TRUE)

# Variable Selection
acs_vars <- load_variables(
  2023,
  dataset = c("acs5"),
  cache = TRUE
)

# Search for variables containing a specific word or search for descriptions based on variable code
pop_vars <- acs_vars %>%
  filter(grepl("B15003", name, ignore.case = TRUE))



# Choose variables 
variables_of_interest <- c(
  total_pop = "B01003_001",       # Total population
  female_pop = "B01001_026",      # Total population of females
  male_pop = "B01001_002",        # Total population of males
  
  white_alone = "B02001_002",     # Population White alone
  black_alone = "B02001_003",     # Population Black/African American alone
  am_indian_alone = "B02001_004", # Population American Indian and Alaska Native alone
  asian_alone = "B02001_005",     # Population Asian alone
  pacificI_alone = "B02001_006",  # Population Pacific Islander and Native Hawaiian alone
  other_alone = "B02001_007",     # Population Other alone 
  two_or_more = "B02001_008",     # Population Two or more races
  
  pop_15_over = "B12001_001",
  females_divorced = "B12001_019",
  males_divorced = "B12001_010",
  
  pop_25_over = "B15003_001",    # Population 25 and older
  highshool_grad = "B15003_017",  # Graduated highschool
  ged_alt_cred = "B15003_018",    # GED or alternative credential
  some_college_less = "B15003_019", # Some college, less than 1 year
  some_college_more = "B15003_020", # Some college, more than 1 year
  associates = "B15003_021",        # Associates degree
  bachelors = "B15003_022",         # Bachelors degree
  masters = "B15003_023",           # Masters degree
  prof_school = "B15003_024",       # Professional School degree
  doctorate = "B15003_025",          # Doctorate Degree
  
  med_household_income = "B19013_001"   # Median Household Income
)

############################ USA Table ###################################
us_pop_data <- get_acs(
  geography = "us",
  variables = variables_of_interest,
  year = 2023, 
  survey = "acs5"
)


us_clean <- us_pop_data %>%
  mutate(variable = recode(variable, !!!setNames(names(variables_of_interest), variables_of_interest))) %>%
  select(GEOID, NAME, variable, estimate)


# Pivot to wide format
us_final <- us_clean %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )

us_final <- us_final %>% 
  mutate(
    pct_female = female_pop / total_pop * 100,
    pct_male = male_pop / total_pop * 100,
    
    pct_white = white_alone / total_pop * 100,
    pct_black = black_alone / total_pop * 100,
    pct_am_indian = am_indian_alone / total_pop * 100,
    pct_asian = asian_alone / total_pop * 100,
    pct_pacificI = pacificI_alone / total_pop * 100,
    pct_other = other_alone / total_pop * 100,
    pct_two_or_more = two_or_more / total_pop * 100,
    
    pct_divorced = (females_divorced + males_divorced) / pop_15_over,

    pct_hs_or_higher = (highshool_grad + ged_alt_cred + some_college_less + some_college_more +
      associates + bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_ba_or_higher = (bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_doctorate = doctorate / pop_25_over * 100
  )



############################ County Table ###################################
counties_pop_data <- get_acs(
  geography = "county",
  variables = variables_of_interest,
  year = 2023, 
  survey = "acs5"
)


counties_clean <- counties_pop_data %>%
  mutate(variable = recode(variable, !!!setNames(names(variables_of_interest), variables_of_interest))) %>%
  select(GEOID, NAME, variable, estimate)


# Pivot to wide format
counties_final <- counties_clean %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )

counties_final <- counties_final %>% 
  mutate(
    pct_female = female_pop / total_pop * 100,
    pct_male = male_pop / total_pop * 100,
    
    pct_white = white_alone / total_pop * 100,
    pct_black = black_alone / total_pop * 100,
    pct_am_indian = am_indian_alone / total_pop * 100,
    pct_asian = asian_alone / total_pop * 100,
    pct_pacificI = pacificI_alone / total_pop * 100,
    pct_other = other_alone / total_pop * 100,
    pct_two_or_more = two_or_more / total_pop * 100,
    
    pct_divorced = (females_divorced + males_divorced) / pop_15_over,
    
    pct_hs_or_higher = (highshool_grad + ged_alt_cred + some_college_less + some_college_more +
                          associates + bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_ba_or_higher = (bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_doctorate = doctorate / pop_25_over * 100
  )


counties_final <- counties_final %>%
  separate(NAME, into = c("NAME", "state_name"), sep = ", ", remove = TRUE)


############################ Congressional District Table ###################################
cd_pop_data <- get_acs(
  geography = "congressional district",
  variables = variables_of_interest,
  year = 2023, 
  survey = "acs5"
)


cd_clean <- cd_pop_data %>%
  mutate(variable = recode(variable, !!!setNames(names(variables_of_interest), variables_of_interest))) %>%
  select(GEOID, variable, NAME, estimate)


# Pivot to wide format
cd_final <- cd_clean %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )

cd_final <- cd_final %>% 
  mutate(
    pct_female = female_pop / total_pop * 100,
    pct_male = male_pop / total_pop * 100,
    
    pct_white = white_alone / total_pop * 100,
    pct_black = black_alone / total_pop * 100,
    pct_am_indian = am_indian_alone / total_pop * 100,
    pct_asian = asian_alone / total_pop * 100,
    pct_pacificI = pacificI_alone / total_pop * 100,
    pct_other = other_alone / total_pop * 100,
    pct_two_or_more = two_or_more / total_pop * 100,
    
    pct_divorced = (females_divorced + males_divorced) / pop_15_over,
    
    pct_hs_or_higher = (highshool_grad + ged_alt_cred + some_college_less + some_college_more +
                          associates + bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_ba_or_higher = (bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_doctorate = doctorate / pop_25_over * 100
  )


cd_final <- cd_final %>%
  separate(NAME, into = c("NAME", "state_name"), sep = ", ", remove = TRUE)



############################ State Table ###################################
state_pop_data <- get_acs(
  geography = "state",
  variables = variables_of_interest,
  year = 2023, 
  survey = "acs5"
)


state_clean <- state_pop_data %>%
  mutate(variable = recode(variable, !!!setNames(names(variables_of_interest), variables_of_interest))) %>%
  select(GEOID, NAME, variable, estimate)


# Pivot to wide format
state_final <- state_clean %>%
  pivot_wider(
    names_from = variable,
    values_from = estimate
  )

state_final <- state_final %>% 
  mutate(
    pct_female = female_pop / total_pop * 100,
    pct_male = male_pop / total_pop * 100,
    
    pct_white = white_alone / total_pop * 100,
    pct_black = black_alone / total_pop * 100,
    pct_am_indian = am_indian_alone / total_pop * 100,
    pct_asian = asian_alone / total_pop * 100,
    pct_pacificI = pacificI_alone / total_pop * 100,
    pct_other = other_alone / total_pop * 100,
    pct_two_or_more = two_or_more / total_pop * 100,
    
    pct_divorced = (females_divorced + males_divorced) / pop_15_over,
    
    pct_hs_or_higher = (highshool_grad + ged_alt_cred + some_college_less + some_college_more +
                          associates + bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_ba_or_higher = (associates + bachelors + masters + prof_school + doctorate) / pop_25_over * 100,
    pct_doctorate = doctorate / pop_25_over * 100
  )


######################## Write Files To CSV ##############################

write.csv(us_final, "data/attribute/US_level_census_data.csv", row.names = FALSE)
write.csv(counties_final, "data/attribute/county_level_census_data.csv", row.names = FALSE)
write.csv(cd_final, "data/attribute/congressional_district_level_census_data.csv", row.names = FALSE)
write.csv(state_final, "data/attribute/state_level_census_data.csv", row.names = FALSE)


write.csv(us_final, "/Users/annikamore/Desktop/Data Directories/open_data/example_data/US_level_census_data.csv", row.names = FALSE)
write.csv(counties_final, "/Users/annikamore/Desktop/Data Directories/open_data/example_data/county_level_census_data.csv", row.names = FALSE)
write.csv(cd_final, "/Users/annikamore/Desktop/Data Directories/open_data/example_data/congressional_district_level_census_data.csv", row.names = FALSE)
write.csv(state_final, "/Users/annikamore/Desktop/Data Directories/open_data/example_data/state_level_census_data.csv", row.names = FALSE)

