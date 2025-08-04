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
| pct_male   | Percent of population that is male   |
| pct_female | Percent of population that is female |

------------------------------------------------------------------------

### Race & Ethnicity

| Field           | Description                                                         |
|--------------------------|----------------------------------------------|
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
| pct_divorced     | Percent of population aged 15+ who are divorced |

------------------------------------------------------------------------

### Educational Attainment

| Field             | Description                                    |
|-------------------|------------------------------------------------|
| pct_hs_or_higher  | Percent with high school diploma/GED or higher |
| pct_ba_or_higher  | Percent with Associates degree or higher       |
| pct_doctorate     | Percent with a Doctorate degree                |

------------------------------------------------------------------------

### Income

| Field             | Description                                    |
|-------------------|------------------------------------------------|
| med_household_income  | Median household income in the past 12 months (2023 Inflation-Adjusted Dollars) |

------------------------------------------------------------------------

### Health Insurance

| Field             | Description                                    |
|-------------------|------------------------------------------------|
| pct_uninsured  | Percent with no health insurance coverage |

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

- The 2024 American Community Survey (ACS) 5-year estimates are set to release December 11, 2025.
- TIGER/Line shapefiles are updated more frequently. The most current shapefiles should be used for displaying geographic boundaries in web applications.
- During a redistricting cycle (e.g., prior to the 2022 elections), consider displaying two maps: 
  - One showing **candidates** with **redrawn districts** using post-redistricting shapefiles (e.g., 2022).
  - Another showing **current elected officials** using **pre-redistricting** shapefiles (e.g., 2020–2021).
- See the [Important Considerations](#important-considerations) section for guidance on handling data–boundary misalignment.

### Changes in Scripts

| Script                   | Change                                                  |
|--------------------------|----------------------------------------------------------|
| `census_data.R`          | Update `year` variables to the most recent ACS release   |
| `shapefile_to_geoJSON.R` | Update `year` variables to match desired boundary year   |

## Usage

Each geography's CSV attribute data can be joined with the corresponding GeoJSON file using the `GEOID` field. This creates a unified dataset containing both demographic attributes and geographic geometries.

## Important Considerations

- The ACS data used in this project is from 2023, while the geographic boundaries shown are based on the more recent 2024 shapefiles. Minor mismatches may occur where data does not perfectly align with boundary definitions.

- Major redistricting is not expected until after the 2030 Census, and newly drawn districts won’t take effect until the 2032 elections. Until then, most boundary changes will be minor.

- During redistricting years (e.g., 2030–2032), there may be discrepancies between the ACS data vintage and the latest boundary definitions:
  - If the most current shapefiles reflect redistricted boundaries but the latest ACS data predates those changes (e.g., 2031 ACS + 2032 shapefiles), make a note that congressional district data may not fully align with redrawn districts.
  - This is especially relevant in the years immediately following the decennial census, when some states adopt new boundaries at different times.



### .gitignore

Store any API keys in a `.Renviron` file, and add it to `.gitignore`.
