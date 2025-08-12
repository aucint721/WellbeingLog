# Minecraft Education: "We Listen and We Try" Week 6
# Function File: listen_and_try_structures.mcfunction
# This file contains all commands to build the communication and empathy world

# ========================================
# WORLD SETUP COMMANDS
# ========================================

# Set world settings
gamerule doDaylightCycle false
gamerule doWeatherCycle false
gamerule keepInventory true
gamerule doMobSpawning false
time set day
weather clear

# ========================================
# ZONE 1: COMMUNICATION CENTER (-100, 64, -100 to -50, 70, -50)
# ========================================

# Build communication center foundation
fill -100 64 -100 -50 64 -50 quartz_block
fill -100 65 -100 -50 70 -50 air

# Build center walls
fill -100 65 -100 -100 70 -100 white_concrete
fill -50 65 -100 -50 70 -100 white_concrete
fill -100 65 -50 -100 70 -50 white_concrete
fill -50 65 -50 -50 70 -50 white_concrete

# Add glass roof for transparency
fill -100 71 -100 -50 71 -50 glass

# Add interior features
# Meeting tables
setblock -90 65 -90 crafting_table
setblock -60 65 -90 crafting_table
setblock -90 65 -60 crafting_table
setblock -60 65 -60 crafting_table

# Chairs (stairs)
setblock -89 65 -89 oak_stairs 2
setblock -61 65 -89 oak_stairs 2
setblock -89 65 -61 oak_stairs 2
setblock -61 65 -61 oak_stairs 2

# Whiteboards (signs)
setblock -85 66 -85 wall_sign 2
setblock -65 66 -85 wall_sign 2
setblock -85 66 -65 wall_sign 2
setblock -65 66 -65 wall_sign 2

# Add lighting
setblock -75 69 -75 glowstone
setblock -75 69 -85 glowstone
setblock -75 69 -65 glowstone
setblock -85 69 -75 glowstone
setblock -65 69 -75 glowstone

# ========================================
# ZONE 2: EMPATHY GARDEN (-50, 64, -100 to 0, 70, -50)
# ========================================

# Create garden foundation
fill -50 64 -100 0 64 -50 grass_block

# Add flowers for each team
# Team 1 - Blue flowers
fill -40 65 -80 -30 65 -70 cornflower
setblock -35 65 -75 cornflower

# Team 2 - Red flowers
fill -20 65 -80 -10 65 -70 poppy
setblock -15 65 -75 poppy

# Team 3 - Green flowers
fill -40 65 -60 -30 65 -50 lily_of_the_valley
setblock -35 65 -55 lily_of_the_valley

# Team 4 - Yellow flowers
fill -20 65 -60 -10 65 -50 dandelion
setblock -15 65 -55 dandelion

# Add trees for meditation spaces
setblock -45 65 -75 oak_log
setblock -45 66 -75 oak_log
setblock -45 67 -75 oak_log
setblock -45 68 -75 oak_leaves
setblock -44 68 -75 oak_leaves
setblock -46 68 -75 oak_leaves
setblock -45 68 -74 oak_leaves
setblock -45 68 -76 oak_leaves

setblock -5 65 -75 oak_log
setblock -5 66 -75 oak_log
setblock -5 67 -75 oak_log
setblock -5 68 -75 oak_leaves
setblock -4 68 -75 oak_leaves
setblock -6 68 -75 oak_leaves
setblock -5 68 -74 oak_leaves
setblock -5 68 -76 oak_leaves

# ========================================
# ZONE 3: AGE-SPECIFIC CHALLENGE AREAS (0, 64, -100 to 100, 70, -50)
# ========================================

# Prep-Year 2: Simple Building Challenges
# Basic house building area
fill 0 64 -100 25 64 -50 sand
fill 0 65 -100 25 70 -50 air

# Simple house templates
# House 1 - Basic structure
setblock 5 65 -80 oak_planks
setblock 5 66 -80 oak_planks
setblock 5 67 -80 oak_planks
setblock 4 67 -80 oak_planks
setblock 6 67 -80 oak_planks
setblock 5 67 -79 oak_planks
setblock 5 67 -81 oak_planks

# House 2 - Simple shelter
setblock 15 65 -80 stone
setblock 15 66 -80 stone
setblock 15 67 -80 stone
setblock 14 67 -80 stone
setblock 16 67 -80 stone

# Years 3-6: Team Collaboration Challenges
# Team building area
fill 25 64 -100 50 64 -50 grass_block
fill 25 65 -100 50 70 -50 air

# Team challenge stations
# Communication tower challenge
setblock 30 65 -80 command_block
setblock 35 65 -80 command_block
setblock 40 65 -80 command_block

# Bridge building challenge
fill 30 64 -70 45 64 -70 water
setblock 30 65 -70 oak_planks
setblock 35 65 -70 oak_planks
setblock 40 65 -70 oak_planks
setblock 45 65 -70 oak_planks

# Years 7-10: Advanced Problem-Solving
# Complex engineering area
fill 50 64 -100 75 64 -50 stone
fill 50 65 -100 75 70 -50 air

# Redstone engineering challenges
setblock 55 65 -80 redstone_lamp
setblock 60 65 -80 redstone_lamp
setblock 65 65 -80 redstone_lamp
setblock 70 65 -80 redstone_lamp

# Advanced building challenges
setblock 55 65 -70 command_block
setblock 60 65 -70 command_block
setblock 65 65 -70 command_block
setblock 70 65 -70 command_block

# ========================================
# ZONE 4: ADDITIONAL CHALLENGE AREAS (75, 64, -100 to 100, 70, -50)
# ========================================

# Creative expression area
fill 75 64 -100 100 64 -50 wool
fill 75 65 -100 100 70 -50 air

# Art stations
setblock 80 65 -80 easel
setblock 85 65 -80 easel
setblock 90 65 -80 easel
setblock 95 65 -80 easel

# Music and rhythm area
setblock 80 65 -70 note_block
setblock 85 65 -70 note_block
setblock 90 65 -70 note_block
setblock 95 65 -70 note_block

# ========================================
# ZONE 5: FEEDBACK AND REFLECTION (-100, 64, -50 to -50, 70, 0)
# ========================================

# Add feedback stations
setblock -90 65 -30 crafting_table
setblock -80 65 -30 crafting_table
setblock -70 65 -30 crafting_table
setblock -60 65 -30 crafting_table

# Create reflection gardens
# Garden 1
fill -95 65 -25 -85 65 -15 grass_block
setblock -90 65 -20 oak_sapling

# Garden 2
fill -75 65 -25 -65 65 -15 grass_block
setblock -70 65 -20 birch_sapling

# Garden 3
fill -55 65 -25 -45 65 -15 grass_block
setblock -50 65 -20 spruce_sapling

# Garden 4
fill -95 65 -5 -85 65 5 grass_block
setblock -90 65 0 jungle_sapling

# ========================================
# ZONE 6: ASSESSMENT AND TRACKING (-50, 64, -50 to 0, 70, 0)
# ========================================

# Assessment center
fill -50 64 -50 0 64 0 stone_bricks
fill -50 65 -50 0 70 0 air

# Progress tracking boards
setblock -40 66 -40 wall_sign 2
setblock -30 66 -40 wall_sign 2
setblock -20 66 -40 wall_sign 2
setblock -10 66 -40 wall_sign 2

# Team achievement displays
setblock -35 66 -30 wool 11
setblock -25 66 -30 wool 14
setblock -15 66 -30 wool 13
setblock -5 66 -30 wool 4

# ========================================
# COMMAND BLOCKS AND AUTOMATION
# ========================================

# Communication system command blocks
setblock -75 65 -25 command_block
setblock -70 65 -25 command_block
setblock -65 65 -25 command_block

# Encouragement system command blocks
setblock -25 65 -75 command_block
setblock -20 65 -75 command_block

# Team management command blocks
setblock -30 65 -75 command_block
setblock -35 65 -75 command_block

# Age-specific challenge command blocks
setblock 10 65 -75 command_block
setblock 20 65 -75 command_block
setblock 30 65 -75 command_block
setblock 40 65 -75 command_block

# Assessment tracking command blocks
setblock -35 65 -35 command_block
setblock -25 65 -35 command_block
setblock -15 65 -35 command_block
setblock -5 65 -35 command_block

# ========================================
# NPCs AND DIALOGUE SYSTEM
# ========================================

# Communication NPCs
summon villager -75 65 -75 {CustomName:"Coach Emma",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"book",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -80 65 -80 {CustomName:"Dr. Listen",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"paper",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -70 65 -70 {CustomName:"Ms. Try",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"stick",Count:1},sell:{id:"emerald",Count:1}}]}}

# Support NPCs
summon villager -25 65 -25 {CustomName:"Friend Felix",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"apple",Count:1},sell:{id:"emerald",Count:1}}]}}

# Age-specific guide NPCs
summon villager 10 65 -75 {CustomName:"Teacher Sam",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"dirt",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager 35 65 -75 {CustomName:"Coach Alex",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"stone",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager 60 65 -75 {CustomName:"Mentor Jordan",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"redstone",Count:1},sell:{id:"emerald",Count:1}}]}}

# ========================================
# ENHANCED SCOREBOARD SETUP
# ========================================

# Create scoreboard objectives
scoreboard objectives add listening dummy
scoreboard objectives add trying dummy
scoreboard objectives add empathy dummy
scoreboard objectives add collaboration dummy
scoreboard objectives add problemsolving dummy
scoreboard objectives add creativity dummy
scoreboard objectives add leadership dummy
scoreboard objectives add reflection dummy

# ========================================
# ENHANCED TEAM SETUP
# ========================================

# Create teams
scoreboard teams add Team1 "Team 1 - Listeners"
scoreboard teams add Team2 "Team 2 - Encouragers"
scoreboard teams add Team3 "Team 3 - Problem Solvers"
scoreboard teams add Team4 "Team 4 - Communicators"

# Set team colors
scoreboard teams option Team1 color blue
scoreboard teams option Team2 color red
scoreboard teams option Team3 color green
scoreboard teams option Team4 color yellow

# ========================================
# AGE-SPECIFIC RESOURCE DISTRIBUTION
# ========================================

# Give starting resources to all players
give @a stone 64
give @a oak_planks 64
give @a glass 32
give @a redstone 16
give @a diamond_pickaxe 1
give @a diamond_axe 1
give @a diamond_shovel 1
give @a bucket 1
give @a book 1
give @a paper 16

# Age-specific additional resources
# Prep-Year 2: Simple building materials
give @a wool 32
give @a carpet 16
give @a flowers 16

# Years 3-6: Team collaboration tools
give @a signs 8
give @a item_frame 4
give @a map 1

# Years 7-10: Advanced materials
give @a observer 4
give @a piston 8
give @a sticky_piston 4
give @a repeater 8
give @a comparator 4

# ========================================
# ENHANCED THEME MESSAGES AND ENCOURAGEMENT
# ========================================

# Display welcome message
title @a title {"text":"We Listen and We Try","color":"blue","bold":true}
title @a subtitle {"text":"Week 6 - Communication & Empathy","color":"green"}

# Send theme messages to chat
tellraw @a {"text":"Welcome to Week 6: We Listen and We Try!","color":"gold"}
tellraw @a {"text":"Today we focus on:","color":"yellow"}
tellraw @a {"text":"• Listening with our hearts","color":"aqua"}
tellraw @a {"text":"• Trying even when it's hard","color":"aqua"}
tellraw @a {"text":"• Supporting our teammates","color":"aqua"}
tellraw @a {"text":"• Learning from our mistakes","color":"aqua"}

# Age-specific welcome messages
tellraw @a {"text":"Prep-Year 2: Build simple houses and work together!","color":"light_purple"}
tellraw @a {"text":"Years 3-6: Complete team challenges and communicate!","color":"light_blue"}
tellraw @a {"text":"Years 7-10: Solve complex problems and lead your team!","color":"yellow"}

# ========================================
# ENHANCED ENCOURAGEMENT SYSTEM
# ========================================

# Positive reinforcement messages
tellraw @a {"text":"Remember: Every voice matters!","color":"green"}
tellraw @a {"text":"Great listening! Keep trying!","color":"green"}
tellraw @a {"text":"Mistakes help us learn and grow!","color":"green"}
tellraw @a {"text":"We're stronger when we work together!","color":"green"}

# Age-specific encouragement
tellraw @a {"text":"Little builders: You're doing amazing!","color":"light_purple"}
tellraw @a {"text":"Team players: Great collaboration!","color":"light_blue"}
tellraw @a {"text":"Leaders: You're inspiring others!","color":"yellow"}

# ========================================
# ENHANCED GUIDELINES AND SAFETY SIGNS
# ========================================

# Add communication guidelines signs
setblock -75 66 -95 wall_sign 2
setblock -35 66 -75 wall_sign 2
setblock 0 66 -75 wall_sign 2
setblock -75 66 -5 wall_sign 2

# Add perseverance guidelines signs
setblock -70 66 -95 wall_sign 2
setblock -30 66 -75 wall_sign 2
setblock 5 66 -75 wall_sign 2
setblock -70 66 -5 wall_sign 2

# Age-specific guideline signs
setblock 10 66 -95 wall_sign 2
setblock 35 66 -95 wall_sign 2
setblock 60 66 -95 wall_sign 2

# ========================================
# ENHANCED ACTIVITY STATIONS
# ========================================

# Listening stations
setblock -85 65 -85 note_block
setblock -65 65 -85 note_block
setblock -85 65 -65 note_block
setblock -65 65 -65 note_block

# Trying stations (challenge areas)
setblock 10 65 -75 command_block
setblock 20 65 -75 command_block
setblock 30 65 -75 command_block
setblock 40 65 -75 command_block

# Empathy stations (reflection areas)
setblock -90 65 -20 oak_sapling
setblock -70 65 -20 birch_sapling
setblock -50 65 -20 spruce_sapling
setblock -30 65 -20 jungle_sapling

# Age-specific activity stations
setblock 55 65 -80 command_block
setblock 60 65 -80 command_block
setblock 65 65 -80 command_block
setblock 70 65 -80 command_block

# ========================================
# ENHANCED ASSESSMENT SYSTEM
# ========================================

# Daily progress tracking
scoreboard objectives add daily_listening dummy
scoreboard objectives add daily_trying dummy
scoreboard objectives add daily_collaboration dummy

# Weekly achievement tracking
scoreboard objectives add weekly_goals dummy
scoreboard objectives add weekly_reflection dummy

# Team performance metrics
scoreboard objectives add team_communication dummy
scoreboard objectives add team_problemsolving dummy
scoreboard objectives add team_creativity dummy

# ========================================
# ENHANCED WORLD COMPLETE MESSAGE
# ========================================

# Final confirmation
tellraw @a {"text":"Week 6 world setup complete!","color":"green","bold":true}
tellraw @a {"text":"Ready to listen, learn, and try together!","color":"gold"}

# ========================================
# ENHANCED DAILY ENCOURAGEMENT
# ========================================

# Morning message
tellraw @a {"text":"Good morning! Today we practice listening and trying.","color":"blue"}
tellraw @a {"text":"Remember: We grow when we listen and learn when we try!","color":"green"}

# Afternoon check-in
tellraw @a {"text":"How are you listening to your teammates today?","color":"yellow"}
tellraw @a {"text":"What have you tried that didn't work? What did you learn?","color":"yellow"}

# End of day reflection
tellraw @a {"text":"Great work today! What did you learn about listening?","color":"purple"}
tellraw @a {"text":"What will you try differently tomorrow?","color":"purple"}

# ========================================
# ENHANCED WEEKLY PROGRESS TRACKING
# ========================================

# Week 6 progress milestones
tellraw @a {"text":"Week 6 Progress Check:","color":"gold","bold":true}
tellraw @a {"text":"• Day 1-2: Communication skills","color":"aqua"}
tellraw @a {"text":"• Day 3-4: Team collaboration","color":"aqua"}
tellraw @a {"text":"• Day 5: Problem-solving challenges","color":"aqua"}
tellraw @a {"text":"• Day 6-7: Reflection and growth","color":"aqua"}

# ========================================
# WORLD COMPLETE - READY FOR WEEK 6
# ========================================

# Final setup confirmation
tellraw @a {"text":"Week 6 PBL world ready! Let's listen and try together!","color":"green","bold":true}
tellraw @a {"text":"All zones completed: Communication, Empathy, Challenges, Assessment","color":"gold"}
tellraw @a {"text":"Age-appropriate activities for Prep-Year 10","color":"gold"}
tellraw @a {"text":"Enhanced tracking and encouragement systems active","color":"gold"}
tellraw @a {"text":"Ready for school-wide access during Week 6!","color":"green","bold":true}


