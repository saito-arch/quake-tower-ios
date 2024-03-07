# What's this?
The objective of this game is to build the tallest tower possible in Japan.  
Japan's earthquakes cause damage to the tower and it collapses when its HP is reduced to 0.  
Through this game, you can gain knowledge about earthquakes that occur in Japan.

# Commands
## Build
Build a tower.  
Initial HP : 3  
Cost : 100 \[G\]
## Extend
Increase the tower's height by 1.  
Cost : 100 * 2 ^ ((Int)(height / 10)) \[G\]
## Reinforce
Increase both the tower's HP and maximum HP by 1 (up to 10).  
Cost : 100 * 2 ^ ((Int)(height / 10)) \[G\]
## Repair
Repair the tower with 5 HP.  
Cost : 100 * 2 ^ ((Int)(height / 10)) \[G\]

# Gold (G)
Gold is currency in this game.  
You get 50 G every half-day.  
You will also be rewarded every half-day depending on the towers you build.  
Reward : 50 * height \[G\]