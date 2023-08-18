library(baseballr)
library(tidyverse)

# Create FB Data for DJ LeMahieu

lemahieu <- playerid_lookup('LeMahieu', 'DJ')
lemahieu_id <- lemahieu$mlbam_id

lemahieu2022 <- Statcast2022 %>%
   filter(batter == lemahieu_id)

lemahieu2021 <- Statcast2021 %>%
   filter(batter == lemahieu_id)

lemahieu2122 <- rbind(lemahieu2022, lemahieu2021)

## Add true zone column

lemahieu2122$true_zone <- if_else(lemahieu2122$plate_z < lemahieu2122$sz_top & 
                                    lemahieu2122$plate_z > lemahieu2122$sz_bot &
                                    lemahieu2122$plate_x < (0.83) &
                                    lemahieu2122$plate_x > (-0.83),
                                  'strike','ball')

## Add edge column

lemahieu2122$edge <- if_else(
  (lemahieu2122$plate_z > lemahieu2122$sz_top - 0.24 & 
     lemahieu2122$plate_z < lemahieu2122$sz_top + 0.24 &
     lemahieu2122$plate_x > -1.07 &
     lemahieu2122$plate_x < 1.07) |
    (lemahieu2122$plate_z > lemahieu2122$sz_bot - 0.24 & 
       lemahieu2122$plate_z < lemahieu2122$sz_bot + 0.24 &
       lemahieu2122$plate_x > -1.07 &
       lemahieu2122$plate_x < 1.07) |
    (lemahieu2122$plate_z < lemahieu2122$sz_top + 0.24 & 
       lemahieu2122$plate_z > lemahieu2122$sz_bot - 0.24 &
       lemahieu2122$plate_x > -1.07 &
       lemahieu2122$plate_x < -0.59) |
    (lemahieu2122$plate_z < lemahieu2122$sz_top + 0.24 & 
       lemahieu2122$plate_z > lemahieu2122$sz_bot - 0.24 &
       lemahieu2122$plate_x < 1.07 &
       lemahieu2122$plate_x > 0.59), 1,0)

# Separate RHP and LHP  Fastball data

lemahieu2122_rh_fb <- lemahieu2122 %>%
  filter((pitch_type == 'FF' | pitch_type == 'SI') & p_throws == 'R')

lemahieu2122_lh_fb <- lemahieu2122 %>%
  filter((pitch_type == 'FF' | pitch_type == 'SI') & p_throws == 'L')

# Plot FBs

lemahieu2122_rh_fb %>%
  ggplot(aes(x = pfx_x*12, y = pfx_z*12))+
  geom_point(aes(color = pitch_type)) +
  xlab('h_break (in)')+
  ylab('v_break (in)')+
  geom_vline(xintercept = 0, size = 1) +
  geom_hline(yintercept = 0, size = 1) +
  xlim(-25, 25) +
  ylim(-15, 25) +
  ggtitle('RH Fastballs')

# Divide into categories

median_rh_pfx_x <- lemahieu2122_rh_fb %>%
  summarize(median_rh_pfx_x = median(pfx_x, na.rm = TRUE)) %>%
  pull(median_rh_pfx_x)

median_rh_pfx_z <- lemahieu2122_rh_fb %>%
  summarize(median_rh_pfx_z = median(pfx_z, na.rm = TRUE)) %>%
  pull(median_rh_pfx_z)

lemahieu2122_rh_fb$fb_type <- 
  if_else(lemahieu2122_rh_fb$pfx_z > median_rh_pfx_z &
          lemahieu2122_rh_fb$pfx_x < median_rh_pfx_x, 'h_ride_h_run',
      if_else(lemahieu2122_rh_fb$pfx_z > median_rh_pfx_z &
              lemahieu2122_rh_fb$pfx_x > median_rh_pfx_x, 'h_ride_l_run',
        if_else(lemahieu2122_rh_fb$pfx_z < median_rh_pfx_z &
                  lemahieu2122_rh_fb$pfx_x < median_rh_pfx_x, 'l_ride_h_run',
                'l_ride_l_run')
))

lemahieu2122_rh_fb <- lemahieu2122_rh_fb[!is.na(lemahieu2122_rh_fb$fb_type), ]

fb_type_counts <- table(lemahieu2122_rh_fb$fb_type)
print(fb_type_counts)

# Plot by category

lemahieu2122_rh_fb %>%
  ggplot(aes(x = pfx_x*12, y = pfx_z*12))+
  geom_point(aes(color = fb_type)) +
  xlab('h_break (in)')+
  ylab('v_break (in)')+
  geom_vline(xintercept = 0, size = 1) +
  geom_hline(yintercept = 0, size = 1) +
  geom_vline(xintercept = median_rh_pfx_x*12, size = 1, color = 'gray') +
  geom_hline(yintercept = median_rh_pfx_z*12, size = 1, color = 'gray') + 
  xlim(-25, 25) +
  ylim(-15, 25) +
  ggtitle('RH Fastballs')

# Create Statistics Table 

# Create label vectors

swing_vector <- c('hit_into_play', 'swinging_strike_blocked', 'swinging_strike', 'foul_tip', 'foul')
contact_vector <- c('hit_into_play', 'foul')
bip_vector <- c('line_drive', 'ground_ball', 'fly_ball', 'popup')
fb_types <- unique(lemahieu2122_rh_fb$fb_type)

# Create empty data frame for lemahieu_rh_fb_stats
lemahieu_rh_fb_stats <- data.frame()

for (fb in fb_types) {
  filtered_data <- lemahieu2122_rh_fb %>%
    filter(fb_type == fb)
  
  pitch_count <- nrow(filtered_data)  
  swing_count <- sum(filtered_data$description %in% swing_vector)
  contact_count <- sum(filtered_data$description %in% contact_vector)
  bip_count <- sum(filtered_data$bb_type %in% bip_vector)
  
  ### Calculate xWOBAsw
  
  xwobasw <- sum(filtered_data$estimated_woba_using_speedangle, na.rm = TRUE) / 
                  swing_count
  
  ### Calculate Contact Rate
  
  contact_rate <- contact_count / swing_count
  
  ### Calculate Line Drive Rate
  
  ld_rate <- (sum(filtered_data$bb_type == 'line_drive')) / bip_count
  
  ### Calculate Fly Ball Rate
  
  fb_rate <- (sum(filtered_data$bb_type == 'fly_ball')) / bip_count
  
  ### Calculate Ground Ball Rate
  
  gb_rate <- (sum(filtered_data$bb_type == 'ground_ball')) / bip_count
  
  ### Calculate edge ZOsw
  
  filtered_data_edge <- filtered_data %>%
    filter(edge == 1)
  
  z_swing_edge <- sum(filtered_data_edge$description %in% swing_vector & 
                        filtered_data_edge$true_zone == 'strike', na.rm = TRUE) /
    sum(filtered_data_edge$description %in% swing_vector)
  
  o_swing_edge <- sum(filtered_data_edge$description %in% swing_vector & 
                        filtered_data_edge$true_zone == 'ball', na.rm = TRUE) /
    sum(filtered_data_edge$description %in% swing_vector)
  
  zo_swing_edge <- z_swing_edge - o_swing_edge
  
  ### Create a new row for each pitch type
  
  new_row <- data.frame(FB_Type = fb,
                        n = pitch_count,
                        xWOBAsw = xwobasw,
                        CON = contact_rate,
                        FB = fb_rate,
                        LD = ld_rate,
                        GB = gb_rate,
                        ZOedge = zo_swing_edge)
  
  ### Append the new row to the data frame
  
  lemahieu_rh_fb_stats <- rbind(lemahieu_rh_fb_stats, new_row)
}

print(lemahieu_rh_fb_stats)

# Visualize xWOBAsw

lemahieu_rh_fb_stats %>%
  ggplot(aes(x = FB_Type, y = xWOBAsw, fill = FB_Type)) +
  geom_bar(stat = 'identity')+
  ggtitle('xWOBAsw by FB Type')

# Visualize ZOedge

lemahieu_rh_fb_stats %>%
  ggplot(aes(x = FB_Type, y = ZOedge, fill = FB_Type)) +
  geom_bar(stat = 'identity')+
  ggtitle('Plate Discipline by FB Type')

# Visualize FB/GB/LD

lemahieu_rh_fb_stats_long <- lemahieu_rh_fb_stats %>%
  select( -c(n, ZOedge, CON)) %>%
  gather(key = type, value = value, -FB_Type)

lemahieu_rh_fb_stats_long$type <- factor(lemahieu_rh_fb_stats_long$type, 
                                         levels = c("FB", "LD", "GB"))

ggplot(lemahieu_rh_fb_stats_long, aes(x = FB_Type, y = value, fill = type)) +
  geom_bar(position = 'dodge', stat = 'identity') +
  labs(title = 'Hit Trajectory by FB Type',
       x = 'Pitch Type',
       y = 'Value',
       fill = 'BIP Type') +
  scale_fill_manual(values = c('FB' = 'yellow', 'LD' = 'orange', 'GB' = 'red')) +
  theme_minimal()

