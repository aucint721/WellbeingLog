# Minecraft Education World Import Instructions

## 📁 What You Have

I've created these files for you:
- `listen_and_try_world.mcworld` - World specifications and settings
- `listen_and_try_structures.mcfunction` - Commands to build the world
- `minecraft_pbl_guide.md` - General PBL guide
- `minecraft_pbl_templates.md` - Lesson plans and templates

## 🎮 How to Build Your "We Listen and We Try" World

### **Option 1: Manual Building (Recommended)**

#### **Step 1: Create New World**
1. Open **Minecraft Education Edition**
2. Click **"Create New World"**
3. Set these settings:
   - **World Type:** Flat
   - **Biome:** Plains
   - **Weather:** Clear
   - **Time:** Day
   - **Difficulty:** Peaceful
   - **Classroom Mode:** Enabled

#### **Step 2: Build the Zones**
Use the coordinates and commands from `listen_and_try_structures.mcfunction`:

**Zone 1: Communication Center (-100, 64, -100 to -50, 70, -50)**
```
/fill -100 64 -100 -50 64 -50 quartz_block
/fill -100 65 -100 -50 70 -50 air
/fill -100 65 -100 -100 70 -100 white_concrete
/fill -50 65 -100 -50 70 -100 white_concrete
/fill -100 65 -50 -100 70 -50 white_concrete
/fill -50 65 -50 -50 70 -50 white_concrete
/fill -100 71 -100 -50 71 -50 glass
```

**Zone 2: Empathy Garden (-50, 64, -100 to 0, 70, -50)**
```
/fill -50 64 -100 0 64 -50 grass_block
/fill -40 65 -80 -30 65 -70 cornflower
/fill -20 65 -80 -10 65 -70 poppy
/fill -40 65 -60 -30 65 -50 lily_of_the_valley
/fill -20 65 -60 -10 65 -50 dandelion
```

**Zone 3: Perseverance Workshop (0, 64, -100 to 100, 70, -50)**
```
/fill 0 64 -100 100 64 -50 stone_bricks
/fill 0 65 -100 25 65 -75 air
/fill 25 65 -100 50 65 -75 air
/fill 50 65 -100 75 65 -75 air
/fill 75 65 -100 100 65 -75 air
```

**Zone 4: Collaboration Arena (-100, 64, -50 to -50, 70, 0)**
```
/fill -100 64 -50 -50 64 0 polished_andesite
/fill -95 65 -5 -55 65 -5 stone_bricks
/fill -95 66 -5 -55 66 -5 stone_bricks
/fill -95 67 -5 -55 67 -5 stone_bricks
```

#### **Step 3: Add NPCs**
```
/summon villager -75 65 -75 {CustomName:"Coach Emma",Profession:1,Career:1}
/summon villager -80 65 -80 {CustomName:"Dr. Listen",Profession:1,Career:1}
/summon villager -70 65 -70 {CustomName:"Ms. Try",Profession:1,Career:1}
/summon villager -25 65 -25 {CustomName:"Friend Felix",Profession:1,Career:1}
```

#### **Step 4: Set Up Scoreboards**
```
/scoreboard objectives add listening dummy
/scoreboard objectives add trying dummy
/scoreboard objectives add empathy dummy
/scoreboard objectives add collaboration dummy
```

#### **Step 5: Create Teams**
```
/scoreboard teams add Team1 "Team 1 - Listeners"
/scoreboard teams add Team2 "Team 2 - Encouragers"
/scoreboard teams add Team3 "Team 3 - Problem Solvers"
/scoreboard teams add Team4 "Team 4 - Communicators"
/scoreboard teams option Team1 color blue
/scoreboard teams option Team2 color red
/scoreboard teams option Team3 color green
/scoreboard teams option Team4 color yellow
```

#### **Step 6: Give Resources**
```
/give @a stone 64
/give @a oak_planks 64
/give @a glass 32
/give @a redstone 16
/give @a diamond_pickaxe 1
/give @a diamond_axe 1
/give @a diamond_shovel 1
/give @a bucket 1
/give @a book 1
/give @a paper 16
```

### **Option 2: Using the Function File**

#### **Step 1: Create Function File**
1. In your world, create a **datapack**
2. Add the commands from `listen_and_try_structures.mcfunction` to a function file
3. Run the function with: `/function your_datapack:listen_and_try_structures`

### **Option 3: Copy-Paste Commands**

You can copy and paste these commands directly into the chat:

#### **Quick Setup Commands:**
```
gamerule doDaylightCycle false
gamerule doWeatherCycle false
gamerule keepInventory true
gamerule doMobSpawning false
time set day
weather clear
```

#### **Build Commands:**
```
fill -100 64 -100 -50 64 -50 quartz_block
fill -100 65 -100 -50 70 -50 air
fill -100 65 -100 -100 70 -100 white_concrete
fill -50 65 -100 -50 70 -100 white_concrete
fill -100 65 -50 -100 70 -50 white_concrete
fill -50 65 -50 -50 70 -50 white_concrete
fill -100 71 -100 -50 71 -50 glass
```

## 🎯 Recommended Approach

**For Week 6 "We Listen and We Try":**

1. **Start with Option 1 (Manual Building)** - This gives you the most control
2. **Use the coordinates** from the files to build each zone
3. **Add NPCs and set up teams** as described
4. **Test the world** with a few students first
5. **Customize as needed** for your specific class

## 📋 What to Copy

**Copy these commands from the files:**

1. **From `listen_and_try_structures.mcfunction`:**
   - All the `/fill` commands for building
   - All the `/summon` commands for NPCs
   - All the `/scoreboard` commands for teams
   - All the `/give` commands for resources

2. **From `listen_and_try_world.mcworld`:**
   - World settings
   - Zone descriptions
   - Learning objectives
   - Assessment criteria

## 🚀 Quick Start

**If you want to get started quickly:**

1. **Create a new flat world** in Minecraft Education Edition
2. **Copy the building commands** from `listen_and_try_structures.mcfunction`
3. **Paste them into chat** one by one
4. **Add NPCs** using the summon commands
5. **Set up teams** using the scoreboard commands
6. **Save the world** as "Week6_ListenAndTry"

## 💡 Tips

- **Start small** - Build one zone at a time
- **Test with students** - Make sure everything works
- **Customize** - Adapt the world to your specific needs
- **Save frequently** - Don't lose your work
- **Use Classroom Mode** - For better student management

The files provide the blueprint - you build the actual world in Minecraft Education Edition!


