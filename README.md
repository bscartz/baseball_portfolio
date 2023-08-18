# baseball_portfolio Ben Scartz
This is a collection of baseball projects with the objectives of learning, practicing, and demonstrating code. Each project is described below and corresponds to a file above. The links below the titles attach R Markdown html files which display executed code and visualizations. 

## Mini Project 1: Statcast

This code uses the baseballr package's statcast_search() function. The function on its own returns pitch-by-pitch metrics from a given date range, but it cannot handle the payload of an entire season's worth of data. Therefore, this code loops the function through every day in a given season. The resulting data tables from this code allow for a wide span of analyses.

## Mini Project 2: LeMahieu Fastball Types
https://rpubs.com/bscartz/lemahieu-fastball-types

Question: What types of RH fastballs are most effective against DJ LeMahieu?

This project simulates a common task for baseball analysts. DJ LeMahieu was chosen at random. The code collects data for FBs that LeMahieu faced in 2021 and 2022, and it divides them into types based on horizontal and vertical movement profiles. It evaluates and compares LeMahieu's performance against each type. It concludes that LeMahieu struggles the most against low VB, high HB fastballs, which means that pitchers with high sinker usages would be most effective against him. This code could be used for any player, and it could be applied to bullpen matchup optimization strategies. 



