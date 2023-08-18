# baseball_portfolio Ben Scartz
This is a collection of baseball projects with the objectives of learning, practicing, and demonstrating code. Each project is described below and corresponds to a file above. The links below the titles attach R Markdown html files which display executed code and visualizations. 

## Mini Project 1: Statcast

This code uses the baseballr package's statcast_search() function. The function on its own returns pitch-by-pitch metrics from a given date range, but it cannot handle the payload of an entire season's worth of data. Therefore, this code loops the function through every day in a given season. The resulting data tables from this code allow for a wide span of analyses.

## Mini Project 2: LeMahieu Fastball Types
https://rpubs.com/bscartz/lemahieu-fastball-types

Question: What types of RH fastballs are most effective against DJ LeMahieu?

This project simulates a common task for baseball analysts. DJ LeMahieu was chosen at random. The code collects data for FBs that LeMahieu faced in 2021 and 2022, and it divides them into types based on horizontal and vertical movement profiles. It evaluates and compares LeMahieu's performance against each type. It concludes that LeMahieu struggles the most against low VB, high HB fastballs, which means that pitchers with high sinker usages would be most effective against him. This code could be used for any player, and it could be applied to bullpen matchup optimization strategies. It could also be used to make lineup decisions based on the fastball profile of the opponent's starting pitcher.

## Mini Project 3: Top 100 Prospects Re-rank
https://rpubs.com/bscartz/top-100-prospects-re-rank

Task: Re-rank the 2019 Fangraphs Top 100 prospects based on MLB production. Then, evaluate the accuracy of the original rankings.

This project can be used in hindsight to evaluate the performance of internal scouting operations. It can also be used to give context to the value of rankings. For example, By how much should a top 10 prospect be valued above a top 50 prospect? The project simulates this using the Fangraphs prospect rankings. It concludes that the prospect rankings provide some, but not an overwhelming indication of a player's future production. Therefore, a player ranked in the lower parts of the top 100 should be valued approximately as highly as one in the upper parts. This is especially true for pitchers and catchers. These insights can be used in trade and acquisition strategies.

