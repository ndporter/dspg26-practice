# plotting DSPG 2026
# Nathaniel Porter
# June 2, 2026

library(tidyverse)
interviews_plotting <- read_csv('data/interviews_plotting.csv')

# scatterplots ----

interviews_plotting |> 
  ggplot(mapping=aes(x=no_membrs,y=num_items)) +
  geom_point(alpha=0.5)

interviews_plotting |> 
  ggplot(aes(x=no_membrs,y=num_items)) +
  geom_jitter(alpha=0.7, width=0.2, height=0.2)

#setting color
interviews_plotting |> 
  ggplot(aes(x=no_membrs,y=num_items)) +
  geom_jitter(alpha=0.7, width=0.2, height=0.2, color='dodgerblue')

#mapping color and shape
interviews_plotting |> 
  filter_out(is.na(memb_assoc)) |> 
  ggplot(aes(x=no_membrs,y=num_items, color=village, shape=memb_assoc)) +
  geom_jitter(alpha=0.7, width=0.2, height=0.2)

interviews_plotting |> 
  filter_out(is.na(memb_assoc)) |> 
  ggplot(aes(x=no_membrs,y=num_items, color=village, shape=memb_assoc)) +
  geom_jitter(alpha=0.7, width=0.2, height=0.2) +
  scale_colour_viridis_d(option='inferno')

# boxplot ----

interviews_plotting |> 
  ggplot(aes(x=respondent_wall_type,y=rooms)) +
  geom_boxplot()

interviews_plotting |> 
  count(respondent_wall_type)

interviews_plotting |> 
  filter(respondent_wall_type!='cement') |> 
  ggplot(aes(x=respondent_wall_type,y=rooms)) +
  geom_boxplot(outliers=FALSE, alpha=0) +
  geom_jitter(aes(color=village),
              width=0.2,
              height=0)

# barplot ----

interviews_plotting |> 
  ggplot(aes(x=respondent_wall_type)) +
  geom_bar()

interviews_plotting |> 
  ggplot(aes(y=respondent_wall_type)) +
  geom_bar()

interviews_plotting |> 
  ggplot(aes(y=fct_infreq(respondent_wall_type))) +
  geom_bar()

interviews_plotting |> 
  ggplot(aes(y=fct_infreq(respondent_wall_type))) +
  geom_bar(aes(fill=village)) +
  labs(y='Wall Type', x=NULL, fill="Village") +
  theme_minimal()

ggsave(filename = 'fig/village_walls_bar.png', height=8, width=7)
