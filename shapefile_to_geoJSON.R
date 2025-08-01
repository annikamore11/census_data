# Load libraries
library(sf)
library(tigris)
library(geojsonio)

# Optional: prevent tigris from showing messages
options(tigris_use_cache = TRUE)

# Download 2024 congressional districts (CB = cartographic boundary, simplified)
states <- states(cb = TRUE, year = 2024)
con_districts <- congressional_districts(cb = TRUE, year = 2024)
st_house_districts <- state_legislative_districts(cb = TRUE, house = "lower", year = 2024)
st_senate_districts <- state_legislative_districts(cb = TRUE, house = "upper", year = 2024)
counties <- counties(cb = TRUE, year = 2024)

# Function to get US boundary
get_us_boundary <- function(states) {
  usa_geom <- st_union(states)
  st_sf(GEOID = 1, geometry = usa_geom)
}

# Select geometries
usa_sf <- get_us_boundary(states)

states_geom <- states %>% select(GEOID, geometry)
con_districts_geom <- con_districts %>% select(GEOID, geometry)
st_house_geom <- st_house_districts %>% select(GEOID, NAMELSAD, geometry)
st_senate_geom <- st_senate_districts %>% select(GEOID, NAMELSAD, geometry)
counties_geom <- counties %>% select(GEOID, geometry)


# Export to GeoJSON
geojson_write(states_geom, file = "data/geometry/states_geom_2024.geojson")
geojson_write(con_districts_geom, file = "data/geometry/con_district_geom_2024.geojson")
geojson_write(st_house_geom, file = "data/geometry/house_district_geom_2024.geojson")
geojson_write(st_senate_geom, file = "data/geometry/senate_district_geom_2024.geojson")
geojson_write(counties_geom, file = "data/geometry/counties_geom_2024.geojson")
geojson_write(usa_sf, file = "data/geometry/us_geom_2024.geojson")












