library(baseballr)
library(tidyverse)

#load season data

load("G:/My Drive/Baseball/Summer 2023/R Projects/Data/Statcast2022.RData")

# Create player statcast data for subject. ex: Freddy Peralta, RHP, MIL

first_name <- 'Freddy'
last_name <- 'Peralta'
player_id <- playerid_lookup(last_name, first_name)$mlbam_id
player_data <- Statcast2022 %>%
  filter(pitcher == player_id)

# Create usage and pitch profile data for subject

pitch_usage <- data.frame()
all_pitches <- unique(Statcast2022$pitch_name)

for (pitch in all_pitches) {
  
  pitch_count <- sum(player_data$pitch_name == pitch)
  total_count <- nrow(player_data)
  
  usage <- round((pitch_count / total_count),2)
  
  player_pitch_data <- player_data %>%
    filter(pitch_name == pitch)
  
  avg_h_break <- round(mean(player_pitch_data$pfx_x) * 12,2)
  avg_v_break <- round(mean(player_pitch_data$pfx_z) * 12,2)
  avg_velo <- round(mean(player_pitch_data$release_speed),2)
  
  new_row <- data.frame(player_id = player_id,
                        pitch = pitch,
                        count = pitch_count,
                        usage = usage,
                        h_break = avg_h_break,
                        v_break = avg_v_break,
                        velo = avg_velo,
                        stringsAsFactors = FALSE)
  
  pitch_usage <- rbind(pitch_usage, new_row)
  
  
}

# Create same data for every other league pitcher

league_usage <- data.frame()
rh_data <- Statcast2022 %>%
  filter(p_throws == 'R')

all_pitcher <- unique(rh_data$pitcher)

for (guy in all_pitcher) {
  
  league_data <- Statcast2022 %>%
    filter(pitcher == guy)
  
  new_new <- data.frame()
  
  for (pitch in all_pitches) {
    
    pitch_count <- sum(league_data$pitch_name == pitch)
    total_count <- nrow(league_data)
    
    usage <- round((pitch_count / total_count),2)
    
    league_pitch_data <- league_data %>%
      filter(pitch_name == pitch)
    
    avg_h_break <- round(mean(league_pitch_data$pfx_x) * 12,2)
    avg_v_break <- round(mean(league_pitch_data$pfx_z) * 12,2)
    avg_velo <- round(mean(league_pitch_data$release_speed),2)
    
    new_row <- data.frame(player_id = guy,
                          pitch = pitch,
                          count = pitch_count,
                          usage = usage,
                          h_break = avg_h_break,
                          v_break = avg_v_break,
                          velo = avg_velo,
                          stringsAsFactors = FALSE)
    
    new_new <- rbind(new_new, new_row)
    
    
  }
  
  
  
  league_usage <- rbind(league_usage, new_new)
}

# Combine both tables with mlb_stats() table to retrieve name and team


mlb_stats_22 <- mlb_stats(stat_type =  'season', player_pool = 'All',
                          stat_group = 'pitching', season = 2022)

league_usage <- league_usage %>%
  left_join(mlb_stats_22, by = 'player_id') %>%
  select(player_id, player_first_name, player_last_name, position_name,
         team_name, everything(league_usage)) %>%
  filter(position_name == 'Pitcher') %>%  # remove position players
  select(-'position_name')



pitch_usage <- pitch_usage %>%
  left_join(mlb_stats_22, by = 'player_id') %>%
  select(player_id, player_first_name, player_last_name, position_name,
         team_name, everything(pitch_usage)) %>%
  filter(position_name == 'Pitcher') %>% 
  select(-'position_name')

# Mutate league table to calculate differences between league pitchers and subject pitcher

diff_table <- data.frame()

for (guy in all_pitcher) {
  
  other_usage <- league_usage %>% 
    filter(player_id == guy)
  
  other_diff <- data.frame()
  
  for (p in all_pitches) {
    
    
    
    other_pitch <- other_usage %>% 
      filter(pitch == p) 
    
    pitch_pitch <- pitch_usage %>% 
      filter(pitch == p)
    
    new_row <- other_pitch %>% 
      mutate(usage = usage - pitch_pitch$usage,
             h_break = h_break - pitch_pitch$h_break,
             v_break = v_break - pitch_pitch$v_break,
             velo = velo - pitch_pitch$velo)
    
    other_diff <- rbind(other_diff, new_row)
  }
  
  diff_table <- rbind(diff_table, other_diff)
  
}

## Create row for pythagorean difference in break

diff_table <- diff_table %>% 
  mutate(`break` = round(sqrt(h_break^2 + v_break^2),2))

# Create totals table to simplify and sort

totals <- diff_table %>% 
  group_by(player_id, player_first_name, player_last_name) %>% 
  summarize(
    total_usage = sum(abs(usage)),
    total_break = sum(`break`, na.rm = TRUE)
  )

# Select closest matches

matches <- league_usage %>% 
  filter(player_id %in% c(642547,680573,663474), count > 0)

# Visualize pitch data

matches %>% 
  ggplot(aes(x = h_break, y = v_break)) +
  geom_point(aes(color = player_last_name, shape = pitch, size = 3)) +
  geom_path(aes(group = pitch), color = 'gray', alpha = 1) +
  xlab('h_break (in)')+
  ylab('v_break (in)')+
  geom_vline(xintercept = 0, size = 1) +
  geom_hline(yintercept = 0, size = 1) +
  xlim(-25, 25) +
  ylim(-20, 25) +
  ggtitle('Pitch Mix By Pitcher') +
  guides(size = FALSE)

# Visualize usage by pitcher

matches %>% 
  ggplot(aes(x = pitch, y = usage, fill = player_last_name)) +
  geom_bar(position = 'dodge', stat = 'identity') +
  labs(title = 'Pitch Usage By Pitcher',
       x = 'Pitch Type',
       y = 'Usage',
       fill = 'Pitcher') +
  scale_fill_manual(values = c('McKenzie' = 'red', 'Peralta' = 'green', 'Woods Richardson' = 'blue')) +
  theme_minimal()