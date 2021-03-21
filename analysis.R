library("dplyr")
library("janitor")
library("readxl")

df <- read_excel("P_and_E_data.xlsx") %>% 
  clean_names() %>% 
  mutate(
    location_is_library = case_when(
      where_was_the_session_delivered == "Community library" ~ TRUE,
      where_was_the_session_delivered != "Community library" ~ FALSE
    ),
    delivery_agent = case_when(
      was_the_session_co_delivered_with_other_library_teams_or_other_partners == "Yes" ~ "Co-delivered",
      who_delivered_the_session == "The library’s team" ~ "Library",
      who_delivered_the_session != "The library's team" ~ "External"
    )
  )


