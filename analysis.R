library("tidyverse")
library("janitor")
library("readxl")

content_index <- read_csv("content_index.csv", col_types = "c") %>% mutate(content = str_trim(content) %>% str_to_lower())
other_communities <- read_csv("other_communities.csv", col_types = "c")

df <- read_excel("P_and_E_data.xlsx") %>% 
  clean_names() %>% 
  unite("content", c(42:57), na.rm = TRUE) %>% 
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
    ),
    content = case_when(
      content == "Arts & Crafts" ~ "arts & craft",
      !is.na(content) ~ str_trim(content) %>% str_to_lower()
    ),
    content_other = case_when(
      content %in% content_index$content ~ "Selection",
      !content %in% content_index$content ~ "Other",
    )
  )
