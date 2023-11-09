# baseball_portfolio Ben Scartz
This is a collection of baseball projects with the objectives of learning, practicing, and demonstrating code. Several are meant to simulate ad hoc projects conducted by analysts. Each project is described below and corresponds to a file above. The links below the titles attach R Markdown html files which display executed code and visualizations. 

## Project 1: ChatGPT for Scouting Report Analysis
(see file above)

Purpose: to summarize and discuss scouting reports in a simple, conversational manner.

This program creates a customized version of ChatGPT to pull summative pieces of information from scouting reports. It tunes the chat bot using the scouting reports and other key pieces of information. It is not meant to provide in-depth analysis, but it is effective in guiding and streamlining the learning process. The contents of this document include a model for standard summarization, text-only analysis, and multilingual analysis.


### Mini Project 1: Statcast
https://rpubs.com/bscartz/statcast

Task: Create a season’s worth of Statcast data stored as a single table for analysis

This code uses the baseballr package's statcast_search() function. The function on its own returns pitch-by-pitch metrics from a given date range, but it cannot handle the payload of an entire season's worth of data. Therefore, this code loops the function through every day in a given season. The resulting data tables from this code allow for a wide span of analyses.

### Mini Project 2: Pitcher Comps
https://rpubs.com/bscartz/pitcher-comps

Task: Create a system to match pitchers with other pitchers around the league who most closely resemble their arsenals and characteristics.

This project evaluates pitchers' usage rates and pitch characteristics. Given a subject, it identifies pitchers around the league who have the most similar characteristics. This allows staff to find useful bases for comparison, which can be applied to player development, advance scouting, and pro scouting evaluation. This project uses Freddy Peralta as the subject and identifies Triston McKenzie and Simeon Woods Richardson as useful comps. If it were framed for all three players as subjects, the following are examples of applications.

Peralta: Observe how McKenzie approaches certain hitters. With what pitches and sequences has McKenzie found success against Peralta’s upcoming opponents? In McKenzie’s dominant 2022 season, on what pitches and sequences did he rely most?

McKenzie: Unlike McKenzie, Peralta features a CH. What does this add to his arsenal, and should McKenzie explore adding a similar pitch?

Woods Richardson: For a young prospect, these comparisons to big leaguers can be especially valuable. Woods Richarson should follow these pitchers closely, particularly Peralta, to mimic aspects of their approach and development.

### Mini Project 3: Python MLB Playoff Simulator
(see file above)

Task: Create a tool to simulate the outcome of the MLB playoffs.

This project creates a tool in Python to simulate the MLB playoffs. It first creates a program to simulate based on random selection for each game. Then, it weights the random selection based on regular season wins. 

### Mini Project 4: LeMahieu Fastball Types
https://rpubs.com/bscartz/lemahieu-fastball-types

Question: What types of RH fastballs are most effective against DJ LeMahieu?

This project simulates a common task for baseball analysts. DJ LeMahieu was chosen at random. The code collects data for FBs that LeMahieu faced in 2021 and 2022, and it divides them into types based on horizontal and vertical movement profiles. It evaluates and compares LeMahieu's performance against each type. It concludes that LeMahieu struggles the most against low VB, high HB fastballs, which means that pitchers with high sinker usages would be most effective against him. This code could be used for any player, and it could be applied to bullpen matchup optimization strategies. It could also be used to make lineup decisions based on the fastball profile of the opponent's starting pitcher.

### Mini Project 5: Top 100 Prospects Re-rank
https://rpubs.com/bscartz/top-100-prospects-re-rank

Task: Re-rank the 2019 Fangraphs Top 100 prospects based on MLB production. Then, evaluate the accuracy of the original rankings.

This project can be used in hindsight to evaluate the performance of internal scouting operations. It can also be used to give context to the value of rankings. For example, By how much should a top 10 prospect be valued above a top 50 prospect? The project simulates this using the Fangraphs prospect rankings. It concludes that the prospect rankings provide some, but not an overwhelming indication of a player's future production. Therefore, a player ranked in the lower parts of the top 100 should be valued approximately as highly as one in the upper parts. This is especially true for pitchers and catchers. These insights can be used in trade and acquisition strategies.

### Mini Project 6: Top 5 Starting Pitchers in Baseball
https://rpubs.com/bscartz/top-5-pitchers

Question: Who are the five best starting pitchers in Major League Baseball right now (ignore contract status, age, etc)?

This project begins with a brief statistical analysis over the last two seasons to pick ten candidates. It then summarizes a video scouting evaluation to determine the final order. The statistical analysis highlights xwOBA-against, K%, and BB%. The scouting analysis steps away from the metrics; it grades pitches on a 20-80 scale and comments on approach, sequencing, and other qualitative factors. 

### Mini Project 7: Extra Bases
https://rpubs.com/bscartz/extra-bases

Task: Identify the players who are the most aggressive and successful baserunners out of the batters box

This project creates a generalized additive model (GAM) to estimate "expected bases" on every hit in play. This is similar to xSLG, but it does not factor in outs and home runs. This allows the model to focus on baserunning out of the batters box. The expected bases for each hit in play is compared to the hitter's actual game event (single, double, or triple). These results are summarized, and players are ranked based on most extra bases over the course of the season. 


