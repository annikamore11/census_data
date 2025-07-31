# Demographic and Boundary Data From Census

An R script to query, clean, and prepare census demographic data and retrieve geometry boundaries for geographies of interest.

## Scripts:

-   `census_data.R`: a script to retrieve latest census demographic data for different geographies from the American Community Survey 5-year.
-   `shapefile_to_geoJSON.R`: A script to retrieve shapefiles for geographies of interest and filter and convert geometries to GeoJSON.

## Geography Levels:

| Geography                         | Files Included          |
|-----------------------------------|-------------------------|
| National                          | Demographic and GeoJSON |
| State                             | Demographic and GeoJSON |
| County                            | Demographic and GeoJSON |
| Congressional District            | Demographic and GeoJSON |
| State Legislative House District  | GeoJSON                 |
| State Legislative Senate District | GeoJSON                 |

## Demographic Fields:

### Population

| Field      | Description                          |
|------------|--------------------------------------|
| total_pop  | Total population                     |
| male_pop   | Total male population                |
| fem_pop    | Total female population              |
| pct_male   | Percent of population that is male   |
| pct_female | Percent of population that is female |

------------------------------------------------------------------------

### Race & Ethnicity

| Field           | Description                                                         |
|-------------------------|-----------------------------------------------|
| white_alone     | Population identifying as White alone                               |
| black_alone     | Population identifying as Black or African American alone           |
| am_indian_alone | Population identifying as American Indian or Alaska Native alone    |
| asian_alone     | Population identifying as Asian alone                               |
| pacificI_alone  | Population identifying as Native Hawaiian or Pacific Islander alone |
| other_alone     | Population identifying as some other race alone                     |
| two_or_more     | Population identifying as two or more races                         |
| pct_white       | Percent White alone                                                 |
| pct_black       | Percent Black or African American alone                             |
| pct_am_indian   | Percent American Indian or Alaska Native alone                      |
| pct_asian       | Percent Asian alone                                                 |
| pct_pacificI    | Percent Pacific Islander alone                                      |
| pct_other       | Percent other race alone                                            |
| pct_two_or_more | Percent two or more races                                           |

------------------------------------------------------------------------

### Marital Status

| Field            | Description                                     |
|------------------|-------------------------------------------------|
| pop_15_over      | Population aged 15 and over                     |
| males_divorced   | Divorced males                                  |
| females_divorced | Divorced females                                |
| pct_divorced     | Percent of population aged 15+ who are divorced |

------------------------------------------------------------------------

### Educational Attainment

| Field             | Description                                    |
|-------------------|------------------------------------------------|
| pop_25_over       | Population aged 25 and over                    |
| highschool_grad   | High school diploma holders                    |
| ged_alt_cred      | GED or alternative credential holders          |
| some_college_less | Some college, less than 1 year completed       |
| some_college_more | Some college, one or more years but no degree  |
| associates        | Associate’s degree holders                     |
| bachelors         | Bachelor’s degree holders                      |
| prof_school       | Professional school degree holders             |
| doctorate         | Doctorate degree holders                       |
| pct_hs_or_higher  | Percent with high school diploma/GED or higher |
| pct_ba_or_higher  | Percent with Associates degree or higher       |
| pct_doctorate     | Percent with a Doctorate degree                |

## Installation

-   Clone the repository
-   Add a `.Renviron` file with Census API key
-   Run the scripts with the current ACS release year to update output demographics and geometry files.
-   Download files from `data/` separately if no updates are needed.

### Required Packages

-   `tidycensus`
-   `dplyr`
-   `sf`
-   `tigris`
-   `tidyr`
-   `geojsonio`

## Update Schedule

The 2024 American Community Survey 5-year estimates is set to release December 11, 2024.

### Changes in Scripts

| Script                   | Change                                               |
|------------------------------------|------------------------------------|
| `census_data.R`          | Update `year` variables to most current release year |
| `shapefile_to_geoJSON.R` | Update `year` variables to match current ACS release |

## Usage

Each geography's csv attribute data can be joined with the corresponding geoJSON file by `GEOID` to get a full data set for each geography that includes both attribute and geometry data.

### .gitignore

Store any API keys in a `.Renviron` file, and add it to `.gitignore`.
