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

# Add water features
setblock -25 65 -85 water
setblock -25 65 -84 water
setblock -25 65 -83 water
setblock -26 65 -84 water
setblock -24 65 -84 water

# Add reflection spots (benches)
setblock -35 65 -85 oak_stairs 0
setblock -15 65 -85 oak_stairs 0
setblock -35 65 -55 oak_stairs 0
setblock -15 65 -55 oak_stairs 0

# ========================================
# ZONE 3: PERSEVERANCE WORKSHOP (0, 64, -100 to 100, 70, -50)
# ========================================

# Create workshop foundation
fill 0 64 -100 100 64 -50 stone_bricks

# Add challenge areas
# Bridge building zone
fill 0 65 -100 25 65 -75 air
fill 0 66 -100 25 66 -75 air
fill 0 67 -100 25 67 -75 air

# Tower construction zone
fill 25 65 -100 50 65 -75 air
fill 25 66 -100 50 66 -75 air
fill 25 67 -100 50 67 -75 air

# Maze creation zone
fill 50 65 -100 75 65 -75 air
fill 50 66 -100 75 66 -75 air
fill 50 67 -100 75 67 -75 air

# Machine building zone
fill 75 65 -100 100 65 -75 air
fill 75 66 -100 100 66 -75 air
fill 75 67 -100 100 67 -75 air

# Add resource stations
# Building materials
setblock 0 65 -75 chest
setblock 1 65 -75 stone 64
setblock 2 65 -75 oak_planks 64
setblock 3 65 -75 glass 32

# Tools
setblock 5 65 -75 chest
setblock 6 65 -75 diamond_pickaxe
setblock 7 65 -75 diamond_axe
setblock 8 65 -75 diamond_shovel

# Redstone for machines
setblock 10 65 -75 chest
setblock 11 65 -75 redstone 16
setblock 12 65 -75 redstone_torch 8

# Testing equipment
setblock 15 65 -75 chest
setblock 16 65 -75 clock
setblock 17 65 -75 compass

# ========================================
# ZONE 4: COLLABORATION ARENA (-100, 64, -50 to -50, 70, 0)
# ========================================

# Build arena foundation
fill -100 64 -50 -50 64 0 polished_andesite

# Create presentation stage
fill -95 65 -5 -55 65 -5 stone_bricks
fill -95 66 -5 -55 66 -5 stone_bricks
fill -95 67 -5 -55 67 -5 stone_bricks

# Add stage lighting
setblock -75 70 -3 glowstone
setblock -85 70 -3 glowstone
setblock -65 70 -3 glowstone

# Create team meeting areas
# Team 1 meeting space
fill -95 65 -45 -85 65 -35 air
setblock -90 65 -40 crafting_table

# Team 2 meeting space
fill -85 65 -45 -75 65 -35 air
setblock -80 65 -40 crafting_table

# Team 3 meeting space
fill -75 65 -45 -65 65 -35 air
setblock -70 65 -40 crafting_table

# Team 4 meeting space
fill -65 65 -45 -55 65 -35 air
setblock -60 65 -40 crafting_table

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

# ========================================
# NPCs AND DIALOGUE SYSTEM
# ========================================

# Communication NPCs
summon villager -75 65 -75 {CustomName:"Coach Emma",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"book",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -80 65 -80 {CustomName:"Dr. Listen",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"paper",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -70 65 -70 {CustomName:"Ms. Try",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"stick",Count:1},sell:{id:"emerald",Count:1}}]}}

# Support NPCs
summon villager -25 65 -25 {CustomName:"Friend Felix",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"apple",Count:1},sell:{id:"emerald",Count:1}}]}}

# ========================================
# SCOREBOARD SETUP
# ========================================

# Create scoreboard objectives
scoreboard objectives add listening dummy
scoreboard objectives add trying dummy
scoreboard objectives add empathy dummy
scoreboard objectives add collaboration dummy

# ========================================
# TEAM SETUP
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
# RESOURCE DISTRIBUTION
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

# ========================================
# THEME MESSAGES AND ENCOURAGEMENT
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

# ========================================
# ENCOURAGEMENT SYSTEM
# ========================================

# Positive reinforcement messages
tellraw @a {"text":"Remember: Every voice matters!","color":"green"}
tellraw @a {"text":"Great listening! Keep trying!","color":"green"}
tellraw @a {"text":"Mistakes help us learn and grow!","color":"green"}
tellraw @a {"text":"We're stronger when we work together!","color":"green"}

# ========================================
# GUIDELINES AND SAFETY SIGNS
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

# ========================================
# ACTIVITY STATIONS
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

# ========================================
# WORLD COMPLETE MESSAGE
# ========================================

# Final confirmation
tellraw @a {"text":"Week 6 world setup complete!","color":"green","bold":true}
tellraw @a {"text":"Ready to listen, learn, and try together!","color":"gold"}

# ========================================
# DAILY ENCOURAGEMENT
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
# WORLD COMPLETE - READY FOR WEEK 6
# ========================================

# Final setup confirmation
tellraw @a {"text":"Week 6 PBL world ready! Let's listen and try together!","color":"green","bold":true}


