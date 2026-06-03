# R Practice DSPG 2026
# Nathaniel Porter
# 2026-06-01

#load tidyverse
library(tidyverse)


# Getting started ---------------------------------------------------------

#download data
# download.file(
#   "https://raw.githubusercontent.com/datacarpentry/r-socialsci/main/episodes/data/SAFI_clean.csv",
#   "data-raw/SAFI_clean.csv", mode = "wb"
# )

#read data in
interviews <- read_csv(
  file="data-raw/SAFI_clean.csv", 
  na = "NULL"
)

#examine the dataframe
class(interviews)
glimpse(interviews)
head(interviews)
tail(interviews)
summary(interviews)
str(interviews)
str(interviews$liv_count)

#use square brackets for location
interviews[1, 2]
interviews[1:3, 5]
interviews[ , 1:3]
interviews[ , -1]

#accessing variables by name
interviews$village
interviews["village"]

area_hectares <- 1.0
area_acres <- area_hectares*2.47
area_hectares <- 2.5 #does not update area_acres

round(3.14159)
args(round)
?round
round(3.14159, digits=2)
round(3.14159, digits=-1)
round(42, digits=-1)

hh_members <- c(3,7,10,6)
respondent_wall_type <- c("muddaub","burntbricks","sunbricks")
key_id <- c("1","2","3")
#key_id[1]+key_id[2]
hh_members[1:2]
hh_members[(length(hh_members)-2):length(hh_members)] #does not work like python

hh_members <- c(hh_members, "NULL") #changes type
hh_members <- c(3,7,10,6)
logi_vec <- c(TRUE, FALSE, TRUE)
c(1, logi_vec)
c("word",logi_vec)
hh_members <- c(hh_members, NA)
NaN #missing (not a number)

mean(c(1,2,3))
mean(hh_members)
mean(hh_members, na.rm=TRUE)
max(hh_members, na.rm=TRUE)
hh_members[!is.na(hh_members)]
na.omit(hh_members)

respondent_floor_type <- factor(c("earth","cement","cement","earth"))
levels(respondent_floor_type)
respondent_floor_type

days_of_week <- factor(
  c("Monday","Tuesday","Wednesday","Thursday","Monday"),
  levels=c("Monday","Tuesday","Wednesday","Thursday"),
  ordered=TRUE
  )

# as.character(days_of_week)
# as.numeric(days_of_week)
# hh_fact <- factor(hh_members)
# as.numeric(hh_fact)
hh_num <- as.numeric(as.character(hh_fact))

dates <- interviews$interview_date
str(dates)
interviews$day <- day(dates)
interviews$month <- month(dates)
interviews$year <- year(dates)
dates[1]+30 #adds 30 seconds
dates[1]+months(1) #adds 1 month

#interviews <- read_csv("data-raw/SAFI_clean.csv")

# dplyr ----

interviews <- read_csv(
  file="data-raw/SAFI_clean.csv", 
  na = "NULL"
)

#select columns
select(interviews, village, no_membrs, months_lack_food, memb_assoc)
select(interviews, village:years_liv)

#filter rows based on data
glimpse(filter(interviews, 
       village=="Chirodzo",
       rooms > 1,
       no_meals > 2))

interviews |>
  select(-key_ID) |> 
  filter(village=="Chirodzo",
         rooms > 1,
         no_meals > 2)

interviews |>
  select(-key_ID) |> 
  filter(village=="Chirodzo" | village=="Ruaca")

interviews |>
  select(-key_ID) |> 
  filter(village=="Chirodzo" & rooms > 1) #same as using a comma

#mutate creates new columns based on existing columns
interviews |> 
  mutate(people_per_room = no_membrs / rooms) |> 
  glimpse()

#create people per room but only for cases where family is member of an irrigation association (memb_assoc=="yes")

interviews |> 
  filter(memb_assoc=="yes") |> 
  select(-memb_assoc) |> 
  mutate(people_per_room = no_membrs / rooms) |> 
  glimpse()
  
#throws error because column removed before filter
# interviews |> 
#   select(-memb_assoc) |> 
#   filter(memb_assoc=="yes") |> 
#   mutate(people_per_room = no_membrs / rooms) |> 
#   glimpse()

means_no_memb <- interviews |> 
  group_by(village, memb_assoc) |> 
  summarize(mean_no_membrs = mean(no_membrs),
            .groups = "drop")

write_csv(x = means_no_memb,
          file = "data/means_no_memb.csv")
