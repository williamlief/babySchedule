library(dplyr)
library(stringr)
library(ggplot2)
library(lubridate)

# Get all messages - this runs a shell script to pull the imessage database
system("sh data_pull.sh")

# function convert time from unix to hour and decimal minutes
convert_time <- function(x) {
  time = parse_date_time(x, "%R") 
  h = hour(time)
  h = ifelse(h < 8, h + 12, h)
  m = minute(time)
  time = h + m/60
  return(time)
}

# Privacy screening - phone number and names not being exposed to internet
phone_numbers <- source("private/phone.R")[[1]]
names <- source("private/names.r")[[1]]

# Read and process data
df <- readr::read_csv("messages.csv") %>%
  filter(id %in% phone_numbers, 
         str_detect(text, regex("[0-9]{1,2}:[0-9]{2}")) & 
           str_detect(text, regex("Diaper|Nap|Bottle", ignore_case = TRUE))) %>% 
  tidyr::separate_rows(text, sep = "\n") %>% 
  mutate(
    text = tolower(text),
    baby = case_when(
      str_detect(text, tolower(names[1])) ~ names[1],
      str_detect(text, tolower(names[2])) ~  names[2]),
    event = case_when(
      str_detect(text, "diaper|poo|pee") ~ "Diaper",
      str_detect(text, "walk") ~ "Walk",
      str_detect(text, "bottle|oz") ~ "Bottle",
      str_detect(text, "nap") ~ "Nap",
      TRUE ~ "Other"
    ),
    volume = str_remove(str_extract(text, "[0-9]{1} ?oz"), "oz"),
    t1 = str_extract(text, "[0-9]{1,2}:[0-9]{2}"),
    start_time = convert_time(t1),
    t2 = str_remove(str_extract(text, "-[0-9]{1,2}:[0-9]{2}"), "-"),
    end_time = convert_time(t2),
    day = lubridate::wday(date, label = TRUE),
    week = lubridate::isoweek(date)
  ) %>% 
  select(date, week, day, baby, event, volume, start_time, end_time, text) %>% 
  mutate(baby = ifelse(row_number() >= 141 & row_number() <= 214, names[1], baby), # time without baby2, name left off
         end_time = ifelse(is.na(end_time), start_time + .25, end_time), # events without end times automatically assigned 15 minutes
         ymin = case_when( # adjust y axis for graphing two babies in vertical stack
           baby == names[1] ~ 0, 
           baby == names[2] ~ 0.5,
           TRUE ~ 0
         ), 
         ymax = ifelse(is.na(baby), 1, ymin + 0.5)
  )

saveRDS(df, "message_data.RDS")