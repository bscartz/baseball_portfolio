library(baseballr)

# Create Statcast data for an entire season to be used in analysis
# Function must be looped by day to handle large payload

# Create Original Statcast table
Statcast2022 <- statcast_search(start_date = '2022-04-07', 
                            end_date = '2022-04-07') # opening day

# Define while loop variables
start <- as.Date('2022-04-08')
end <- as.Date('2022-11-05') # final day of World Series
d <- start

#Add each date to table
while (d <= end) {
  day <- statcast_search(start_date = d, 
                         end_date = d)
  
  # Check if there were any games played on the day
  if (nrow(day) > 0) {
    Statcast2022 <- rbind(Statcast2022, day)
    print(d)
  }
  
  d <- d + 1
}

# Add 'barrel' column 
Statcast2022$barrel <- code_barrel(Statcast2022[, c('launch_angle', 'launch_speed')])$barrel

# Add 'true_zone' column

Statcast2022$true_zone <- ifelse(Statcast2022$plate_z < Statcast2022$sz_top & 
                                 Statcast2022$plate_z > Statcast2022$sz_bot &
                                 Statcast2022$plate_x < (0.83) &
                                 Statcast2022$plate_x > (-0.83),
                                 'strike','ball')

