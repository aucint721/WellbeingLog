# Minecraft Education: Sustainable Community Challenge
# Function File: sustainable_community_structures.mcfunction
# This file contains all commands to build the PBL world automatically

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
# ZONE 1: RESEARCH LIBRARY (-100, 64, -100 to -50, 70, -50)
# ========================================

# Build library foundation
fill -100 64 -100 -50 64 -50 stone_bricks
fill -100 65 -100 -50 70 -50 air

# Build library walls
fill -100 65 -100 -100 70 -100 stone_bricks
fill -50 65 -100 -50 70 -100 stone_bricks
fill -100 65 -50 -100 70 -50 stone_bricks
fill -50 65 -50 -50 70 -50 stone_bricks

# Add library roof
fill -100 71 -100 -50 71 -50 dark_oak_stairs

# Add interior features
# Bookshelves
fill -95 65 -95 -85 68 -85 bookshelf
fill -65 65 -95 -55 68 -85 bookshelf
fill -95 65 -65 -85 68 -55 bookshelf
fill -65 65 -65 -55 68 -55 bookshelf

# Crafting tables
setblock -90 65 -90 crafting_table
setblock -60 65 -90 crafting_table
setblock -90 65 -60 crafting_table
setblock -60 65 -60 crafting_table

# Furnaces
setblock -88 65 -88 furnace
setblock -62 65 -88 furnace
setblock -88 65 -62 furnace
setblock -62 65 -62 furnace

# Add lighting
setblock -75 69 -75 glowstone
setblock -75 69 -85 glowstone
setblock -75 69 -65 glowstone
setblock -85 69 -75 glowstone
setblock -65 69 -75 glowstone

# ========================================
# ZONE 2: PLANNING AREA (-50, 64, -100 to 0, 70, -50)
# ========================================

# Create planning zone foundation
fill -50 64 -100 0 64 -50 stone

# Add team spaces with different colored wool
# Team 1 - Blue
fill -40 65 -80 -30 65 -70 wool 11
setblock -35 65 -75 wool 11

# Team 2 - Red
fill -20 65 -80 -10 65 -70 wool 14
setblock -15 65 -75 wool 14

# Team 3 - Green
fill -40 65 -60 -30 65 -50 wool 13
setblock -35 65 -55 wool 13

# Team 4 - Yellow
fill -20 65 -60 -10 65 -50 wool 4
setblock -15 65 -55 wool 4

# Add whiteboards (signs)
setblock -35 66 -75 wall_sign 2
setblock -15 66 -75 wall_sign 2
setblock -35 66 -55 wall_sign 2
setblock -15 66 -55 wall_sign 2

# Add graph paper areas (wool grid)
# Team 1 graph paper
fill -38 65 -78 -32 65 -72 wool 0
fill -38 65 -78 -32 65 -72 wool 8 replace wool 0

# Team 2 graph paper
fill -18 65 -78 -12 65 -72 wool 0
fill -18 65 -78 -12 65 -72 wool 8 replace wool 0

# Team 3 graph paper
fill -38 65 -58 -32 65 -52 wool 0
fill -38 65 -58 -32 65 -52 wool 8 replace wool 0

# Team 4 graph paper
fill -18 65 -58 -12 65 -52 wool 0
fill -18 65 -58 -12 65 -52 wool 8 replace wool 0

# ========================================
# ZONE 3: BUILDING AREAS (0, 64, -100 to 100, 70, -50)
# ========================================

# Create building zone foundation
fill 0 64 -100 100 64 -50 grass_block

# Add resource stations
# Stone station
setblock 0 65 -75 chest
setblock 1 65 -75 stone 64
setblock 2 65 -75 stone 64
setblock 3 65 -75 stone 64

# Wood station
setblock 5 65 -75 chest
setblock 6 65 -75 oak_planks 64
setblock 7 65 -75 oak_planks 64
setblock 8 65 -75 oak_planks 64

# Glass station
setblock 10 65 -75 chest
setblock 11 65 -75 glass 32
setblock 12 65 -75 glass 32

# Redstone station
setblock 15 65 -75 chest
setblock 16 65 -75 redstone 16
setblock 17 65 -75 redstone 16

# Tool stations
setblock 20 65 -75 chest
setblock 21 65 -75 diamond_pickaxe
setblock 22 65 -75 diamond_axe
setblock 23 65 -75 diamond_shovel

# ========================================
# ZONE 4: PRESENTATION AUDITORIUM (-100, 64, -50 to -50, 70, 0)
# ========================================

# Build auditorium foundation
fill -100 64 -50 -50 64 0 stone_bricks

# Create seating area (stairs)
fill -90 65 -40 -60 65 -10 stone_brick_stairs 0
fill -90 66 -40 -60 66 -10 stone_brick_stairs 0
fill -90 67 -40 -60 67 -10 stone_brick_stairs 0

# Create stage
fill -95 65 -5 -55 65 -5 stone_bricks
fill -95 66 -5 -55 66 -5 stone_bricks
fill -95 67 -5 -55 67 -5 stone_bricks

# Add stage lighting
setblock -75 70 -3 glowstone
setblock -85 70 -3 glowstone
setblock -65 70 -3 glowstone

# Create exhibition spaces
fill -95 65 -45 -85 65 -35 air
fill -85 65 -45 -75 65 -35 air
fill -75 65 -45 -65 65 -35 air
fill -65 65 -45 -55 65 -35 air

# Add peer review areas
setblock -90 65 -30 crafting_table
setblock -80 65 -30 crafting_table
setblock -70 65 -30 crafting_table
setblock -60 65 -30 crafting_table

# ========================================
# COMMAND BLOCKS AND AUTOMATION
# ========================================

# Assessment system command blocks
setblock -75 65 -25 command_block
setblock -70 65 -25 command_block
setblock -65 65 -25 command_block

# Resource management command blocks
setblock 0 65 -75 command_block
setblock 5 65 -75 command_block
setblock 10 65 -75 command_block
setblock 15 65 -75 command_block

# Progress tracking command blocks
setblock -25 65 -75 command_block
setblock -20 65 -75 command_block

# ========================================
# NPCs AND DIALOGUE SYSTEM
# ========================================

# Research NPCs
summon villager -75 65 -75 {CustomName:"Dr. Green",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"book",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -80 65 -80 {CustomName:"Prof. Waters",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"water_bucket",Count:1},sell:{id:"emerald",Count:1}}]}}

summon villager -70 65 -70 {CustomName:"Ms. Solar",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"glowstone",Count:1},sell:{id:"emerald",Count:1}}]}}

# Assessment NPCs
summon villager -25 65 -25 {CustomName:"Coach Sarah",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"paper",Count:1},sell:{id:"emerald",Count:1}}]}}

# ========================================
# SCOREBOARD SETUP
# ========================================

# Create scoreboard objectives
scoreboard objectives add sustainability dummy
scoreboard objectives add innovation dummy
scoreboard objectives add collaboration dummy
scoreboard objectives add documentation dummy

# ========================================
# TEAM SETUP
# ========================================

# Create teams
scoreboard teams add Team1 "Team 1 - Architects"
scoreboard teams add Team2 "Team 2 - Engineers"
scoreboard teams add Team3 "Team 3 - Environmentalists"
scoreboard teams add Team4 "Team 4 - Community Planners"

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

# ========================================
# WORLD COMPLETE MESSAGE
# ========================================

# Display welcome message
title @a title {"text":"Sustainable Community Challenge","color":"blue","bold":true}
title @a subtitle {"text":"PBL Project Ready!","color":"green"}

# Send instructions to chat
tellraw @a {"text":"Welcome to the Sustainable Community Challenge!","color":"gold"}
tellraw @a {"text":"Your mission: Design a sustainable community for 1000 residents","color":"yellow"}
tellraw @a {"text":"Visit the Research Library to learn about sustainability","color":"aqua"}
tellraw @a {"text":"Work with your team in the Planning Area","color":"aqua"}
tellraw @a {"text":"Build your community in the Building Zones","color":"aqua"}
tellraw @a {"text":"Present your work in the Auditorium","color":"aqua"}

# ========================================
# SAFETY AND GUIDELINES SIGNS
# ========================================

# Add safety guidelines signs
setblock -75 66 -95 wall_sign 2
setblock -35 66 -75 wall_sign 2
setblock 0 66 -75 wall_sign 2
setblock -75 66 -5 wall_sign 2

# ========================================
# WORLD COMPLETE - READY FOR PBL
# ========================================

# Final confirmation
tellraw @a {"text":"World setup complete! PBL project ready to begin.","color":"green","bold":true}


