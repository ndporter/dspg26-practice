# R practice 2026-06-02
# DSPG Tuesday (dplyr/tidyr/ggplot)
# Nathaniel Porter

library(tidyverse)

interviews <- read_csv(file='data-raw/SAFI_clean.csv',
                       na = "NULL")

# dplyr ----

# mean num of members and min num of members per village and assoc memb
#no missing values in membership
interviews |> 
  filter(!is.na(memb_assoc)) |> 
  group_by(village, memb_assoc) |> 
  summarize(mean_hh_memb = mean(no_membrs),
            min_hh_memb=min(no_membrs),
            n=n(),
            .groups = 'drop') |> 
  arrange(desc(n), desc(mean_hh_memb))

#interviews |> select(key_ID) works - whitespace including newlines doesn't matter to R

interviews |> 
  count(village, memb_assoc, sort=TRUE)

interviews |> 
  filter_out(is.na(memb_assoc)) |> 
  mutate(per_room = no_membrs/rooms) |> 
  summarize(mean_per_room = mean(per_room),
            min_rooms = min(rooms),
            hh=n(),
            .by = 'village') |> 
  arrange(desc(hh))

# tidyr ----

interviews_items_owned <- interviews |> 
  separate_longer_delim(items_owned, delim=';') |> 
  replace_na(list(items_owned="no_listed_items")) |> 
  mutate(items_logical = TRUE) |> 
  group_by(key_ID) |> 
  mutate(num_items = if_else(
    condition=items_owned=="no_listed_items",
    true=0,
    false=n())) |> 
  pivot_wider(names_from = items_owned,
              values_from = items_logical,
              values_fill = list(items_logical=FALSE))

interviews_plotting <- interviews_items_owned |> 
  separate_longer_delim(months_lack_food,
                        delim=';') |> 
  group_by(key_ID) |> #technically unnecessary because never ungrouped but helpful to put here to show more explicitly
  mutate(months_logical = TRUE,
         num_months_lack_food = if_else(months_lack_food == "none",
                                        true=0,
                                        false=n())) |>
  pivot_wider(names_from = months_lack_food,
              values_from = months_logical,
              values_fill = list(months_logical = FALSE))

# save data ----

write_csv(interviews_plotting, 'data/interviews_plotting.csv')
