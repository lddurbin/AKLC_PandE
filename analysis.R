library("dplyr")
library("janitor")
library("readxl")
library("tidyr")

df <- read_excel("P_and_E_data.xlsx") %>% 
  clean_names() %>% 
  mutate(
    location_is_library = case_when(
      where_was_the_session_delivered == "Community library" ~ "Inside a library",
      where_was_the_session_delivered != "Community library" ~ "Outside a library"
    ),
    location = case_when(
      !is.na(in_which_community_library_was_the_session_delivered) ~ in_which_community_library_was_the_session_delivered,
      !is.na(in_which_community_place_venue_was_the_session_delivered) ~ in_which_community_place_venue_was_the_session_delivered,
      !is.na(where_was_the_session_delivered) ~ where_was_the_session_delivered,
      !is.na(how_was_the_session_delivered) ~ how_was_the_session_delivered
    ),
    delivery_group = case_when(
      was_the_session_co_delivered_with_other_library_teams_or_other_partners == "Yes" ~ "Co-delivered",
      who_delivered_the_session == "The library’s team" ~ "Library",
      who_delivered_the_session != "The library's team" ~ "External"
    )
  ) %>% 
  unite("content", c(42:57), na.rm = TRUE)
