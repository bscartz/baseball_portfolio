library(baseballr)
library(tidyverse)
library(readxl)
library(psych)
library(olsrr)

# Load prospect ranking and statistics spreadsheets from Fangraphs

top_prospects_19 <- read_excel('top_prospects_data.xlsx', sheet = 'top_prospects_19')

top_prospects_23 <- read_excel('top_prospects_data.xlsx', sheet = 'top_prospects_23')

## Remove players who are still ranked prospects in 2023

top_prospects_19 <- top_prospects_19 %>%
                      anti_join(top_prospects_23, by = "Name")

batter_stats <- read_excel('top_prospects_data.xlsx', sheet = 'batter_stats') %>%
  select(Name, G, WAR)

batter_stats$WAR_162 <- batter_stats$WAR / (batter_stats$G / 162)

pitcher_stats <- read_excel('top_prospects_data.xlsx', sheet = 'pitcher_stats') %>%
  select(Name, IP, WAR)

pitcher_stats$WAR_200 <- pitcher_stats$WAR / (pitcher_stats$IP / 200)

joined_table <- top_prospects_19 %>%
  left_join(batter_stats, by = 'Name') %>%
  left_join(pitcher_stats, by = 'Name') %>%
  select(Rk, Name, Position, G, IP, WAR_162, WAR_200, Age)

## Combine WAR_162 (batters) and WAR_200 (pitchers)

joined_table$WAR_season <- if_else(joined_table$G >= 81 | joined_table$IP >= 100,
                              coalesce(joined_table$WAR_162, 0) + 
                              coalesce(joined_table$WAR_200, 0),
                              0)

joined_table <- joined_table %>%
  select(Rk, Name, Position, WAR_season, G, IP, WAR_162, WAR_200, Age)

joined_table <- joined_table %>%
rename(Rank2019 = Rk)

## Create 2023 approximate age column

joined_table$Age <- round(joined_table$Age,0) + 4

# Re-rank prospects based on MLB production

joined_table <- joined_table %>%
  arrange(desc(WAR_season), desc((coalesce(G, 0) * (200 / 162)) + coalesce(IP, 0)), Age) %>%
  mutate(Rerank = row_number())

joined_table <- joined_table %>%
  select(Rerank, Rank2019, Name, Position, Age, WAR_season, WAR_162, WAR_200, G, IP)

print(joined_table[1:20,])

# Analyze ranking accuracy by position

of_vector <- c('CF', 'RF', 'LF')
inf_vector <- c('1B', '2B', '3B', 'SS')
p_vector <- c('RHP', 'LHP')

joined_table$Pos_group <- if_else(joined_table$Position %in% of_vector, 'OF',
                            if_else(joined_table$Position %in% inf_vector, 'INF',
                              if_else(joined_table$Position %in% p_vector, 'P', 
                                if_else(joined_table$Position == 'C', 'C', 'other'))))
  
position_group_frequency <- table(joined_table$Pos_group) 

print(position_group_frequency)

## Correlation for entire data set

joined_table %>%
  ggplot(aes(x = Rank2019, y = Rerank)) +
  geom_point() +
  geom_smooth(method = 'lm') + 
  labs(title = 'Rank2019 vs Rerank')

corr_result <- corr.test(joined_table$Rank2019, joined_table$Rerank)

print(corr_result)

## Correlation for Outfielders

of_table <- joined_table %>%
              filter(Pos_group == 'OF')

of_table %>%
  ggplot(aes(x = Rank2019, y = Rerank)) +
  geom_point() +
  geom_smooth(method = 'lm') + 
  labs(title = 'Outfielders')

of_corr_result <- corr.test(of_table$Rank2019, of_table$Rerank)

print(of_corr_result)

## Infielders

inf_table <- joined_table %>%
  filter(Pos_group == 'INF')

inf_table %>%
  ggplot(aes(x = Rank2019, y = Rerank)) +
  geom_point() +
  geom_smooth(method = 'lm') + 
  labs(title = 'Infielders')

inf_corr_result <- corr.test(inf_table$Rank2019, inf_table$Rerank)

print(inf_corr_result)

## Pitchers

p_table <- joined_table %>%
  filter(Pos_group == 'P')

p_table %>%
  ggplot(aes(x = Rank2019, y = Rerank)) +
  geom_point() +
  geom_smooth(method = 'lm') + 
  labs(title = 'Pitchers')

p_corr_result <- corr.test(p_table$Rank2019, p_table$Rerank)

print(p_corr_result)

## Catchers

c_table <- joined_table %>%
  filter(Pos_group == 'C')

c_table %>%
  ggplot(aes(x = Rank2019, y = Rerank)) +
  geom_point() +
  geom_smooth(method = 'lm') + 
  labs(title = 'Catchers')

c_corr_result <- corr.test(c_table$Rank2019, c_table$Rerank)

print(c_corr_result)

