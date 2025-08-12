# Complete Zone Commands for "We Listen and We Try" World

## 🚀 Quick Setup Commands (Run First)

```
gamerule doDaylightCycle false
gamerule doWeatherCycle false
gamerule keepInventory true
gamerule doMobSpawning false
time set day
weather clear
```

## 🏗️ Zone 1: Communication Center (-100, 64, -100 to -50, 70, -50)

### Foundation and Walls
```
fill -100 64 -100 -50 64 -50 quartz_block
fill -100 65 -100 -50 70 -50 air
fill -100 65 -100 -100 70 -100 white_concrete
fill -50 65 -100 -50 70 -100 white_concrete
fill -100 65 -50 -100 70 -50 white_concrete
fill -50 65 -50 -50 70 -50 white_concrete
fill -100 71 -100 -50 71 -50 glass
```

### Interior Features
```
setblock -90 65 -90 crafting_table
setblock -60 65 -90 crafting_table
setblock -90 65 -60 crafting_table
setblock -60 65 -60 crafting_table
setblock -89 65 -89 oak_stairs 2
setblock -61 65 -89 oak_stairs 2
setblock -89 65 -61 oak_stairs 2
setblock -61 65 -61 oak_stairs 2
setblock -85 66 -85 wall_sign 2
setblock -65 66 -85 wall_sign 2
setblock -85 66 -65 wall_sign 2
setblock -65 66 -65 wall_sign 2
```

### Lighting
```
setblock -75 69 -75 glowstone
setblock -75 69 -85 glowstone
setblock -75 69 -65 glowstone
setblock -85 69 -75 glowstone
setblock -65 69 -75 glowstone
```

## 🌸 Zone 2: Empathy Garden (-50, 64, -100 to 0, 70, -50)

### Foundation and Flowers
```
fill -50 64 -100 0 64 -50 grass_block
fill -40 65 -80 -30 65 -70 cornflower
setblock -35 65 -75 cornflower
fill -20 65 -80 -10 65 -70 poppy
setblock -15 65 -75 poppy
fill -40 65 -60 -30 65 -50 lily_of_the_valley
setblock -35 65 -55 lily_of_the_valley
fill -20 65 -60 -10 65 -50 dandelion
setblock -15 65 -55 dandelion
```

### Trees for Meditation
```
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
```

### Water Features and Benches
```
setblock -25 65 -85 water
setblock -25 65 -84 water
setblock -25 65 -83 water
setblock -26 65 -84 water
setblock -24 65 -84 water
setblock -35 65 -85 oak_stairs 0
setblock -15 65 -85 oak_stairs 0
setblock -35 65 -55 oak_stairs 0
setblock -15 65 -55 oak_stairs 0
```

## ⚙️ Zone 3: Perseverance Workshop (0, 64, -100 to 100, 70, -50)

### Foundation and Challenge Areas
```
fill 0 64 -100 100 64 -50 stone_bricks
fill 0 65 -100 25 65 -75 air
fill 0 66 -100 25 66 -75 air
fill 0 67 -100 25 67 -75 air
fill 25 65 -100 50 65 -75 air
fill 25 66 -100 50 66 -75 air
fill 25 67 -100 50 67 -75 air
fill 50 65 -100 75 65 -75 air
fill 50 66 -100 75 66 -75 air
fill 50 67 -100 75 67 -75 air
fill 75 65 -100 100 65 -75 air
fill 75 66 -100 100 66 -75 air
fill 75 67 -100 100 67 -75 air
```

### Resource Stations
```
setblock 0 65 -75 chest
setblock 1 65 -75 stone 64
setblock 2 65 -75 oak_planks 64
setblock 3 65 -75 glass 32
setblock 5 65 -75 chest
setblock 6 65 -75 diamond_pickaxe
setblock 7 65 -75 diamond_axe
setblock 8 65 -75 diamond_shovel
setblock 10 65 -75 chest
setblock 11 65 -75 redstone 16
setblock 12 65 -75 redstone_torch 8
setblock 15 65 -75 chest
setblock 16 65 -75 clock
setblock 17 65 -75 compass
```

## 🏛️ Zone 4: Collaboration Arena (-100, 64, -50 to -50, 70, 0)

### Foundation and Stage
```
fill -100 64 -50 -50 64 0 polished_andesite
fill -95 65 -5 -55 65 -5 stone_bricks
fill -95 66 -5 -55 66 -5 stone_bricks
fill -95 67 -5 -55 67 -5 stone_bricks
setblock -75 70 -3 glowstone
setblock -85 70 -3 glowstone
setblock -65 70 -3 glowstone
```

### Team Meeting Areas
```
fill -95 65 -45 -85 65 -35 air
setblock -90 65 -40 crafting_table
fill -85 65 -45 -75 65 -35 air
setblock -80 65 -40 crafting_table
fill -75 65 -45 -65 65 -35 air
setblock -70 65 -40 crafting_table
fill -65 65 -45 -55 65 -35 air
setblock -60 65 -40 crafting_table
```

### Feedback Stations and Gardens
```
setblock -90 65 -30 crafting_table
setblock -80 65 -30 crafting_table
setblock -70 65 -30 crafting_table
setblock -60 65 -30 crafting_table
fill -95 65 -25 -85 65 -15 grass_block
setblock -90 65 -20 oak_sapling
fill -75 65 -25 -65 65 -15 grass_block
setblock -70 65 -20 birch_sapling
```

## 👥 NPCs and Characters

### Communication NPCs
```
summon villager -75 65 -75 {CustomName:"Coach Emma",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"book",Count:1},sell:{id:"emerald",Count:1}}]}}
summon villager -80 65 -80 {CustomName:"Dr. Listen",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"paper",Count:1},sell:{id:"emerald",Count:1}}]}}
summon villager -70 65 -70 {CustomName:"Ms. Try",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"stick",Count:1},sell:{id:"emerald",Count:1}}]}}
summon villager -25 65 -25 {CustomName:"Friend Felix",Profession:1,Career:1,Offers:{Recipes:[{buy:{id:"apple",Count:1},sell:{id:"emerald",Count:1}}]}}
```

## 📊 Assessment and Teams Setup

### Scoreboard Objectives
```
scoreboard objectives add listening dummy
scoreboard objectives add trying dummy
scoreboard objectives add empathy dummy
scoreboard objectives add collaboration dummy
```

### Team Creation
```
scoreboard teams add Team1 "Team 1 - Listeners"
scoreboard teams add Team2 "Team 2 - Encouragers"
scoreboard teams add Team3 "Team 3 - Problem Solvers"
scoreboard teams add Team4 "Team 4 - Communicators"
scoreboard teams option Team1 color blue
scoreboard teams option Team2 color red
scoreboard teams option Team3 color green
scoreboard teams option Team4 color yellow
```

## 🛠️ Resources and Tools

### Give Resources to All Players
```
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
```

## 🎯 Command Blocks for Automation

### Assessment System
```
setblock -75 65 -25 command_block
setblock -70 65 -25 command_block
setblock -65 65 -25 command_block
```

### Encouragement System
```
setblock -25 65 -75 command_block
setblock -20 65 -75 command_block
```

### Team Management
```
setblock -30 65 -75 command_block
setblock -35 65 -75 command_block
```

## 🎉 Welcome Messages

### Theme Display
```
title @a title {"text":"We Listen and We Try","color":"blue","bold":true}
title @a subtitle {"text":"Week 6 - Communication & Empathy","color":"green"}
```

### Chat Messages
```
tellraw @a {"text":"Welcome to Week 6: We Listen and We Try!","color":"gold"}
tellraw @a {"text":"Today we focus on:","color":"yellow"}
tellraw @a {"text":"• Listening with our hearts","color":"aqua"}
tellraw @a {"text":"• Trying even when it's hard","color":"aqua"}
tellraw @a {"text":"• Supporting our teammates","color":"aqua"}
tellraw @a {"text":"• Learning from our mistakes","color":"aqua"}
```

## 📋 How to Use These Commands

### Step-by-Step Process:

1. **Open Minecraft Education Edition**
2. **Create a new flat world** with these settings:
   - World Type: Flat
   - Biome: Plains
   - Weather: Clear
   - Time: Day
   - Difficulty: Peaceful
   - Classroom Mode: Enabled

3. **Copy and paste commands in this order:**
   - Quick Setup Commands (first)
   - Zone 1: Communication Center
   - Zone 2: Empathy Garden
   - Zone 3: Perseverance Workshop
   - Zone 4: Collaboration Arena
   - NPCs and Characters
   - Assessment and Teams Setup
   - Resources and Tools
   - Command Blocks for Automation
   - Welcome Messages

4. **Save your world** as "Week6_ListenAndTry"

### Tips:
- **Run commands in order** - They build on each other
- **Wait for each command** to complete before running the next
- **Test with a few students** before using with the whole class
- **Customize as needed** for your specific requirements

## 🎯 Ready to Use!

After running all these commands, you'll have a complete "We Listen and We Try" world with:
- ✅ Communication Center with NPCs
- ✅ Empathy Garden with meditation spaces
- ✅ Perseverance Workshop with challenge areas
- ✅ Collaboration Arena with presentation stage
- ✅ Teams and assessment system
- ✅ Resources and tools for students
- ✅ Encouragement messages throughout

**Your Week 6 PBL world is ready to go!** 🚀


