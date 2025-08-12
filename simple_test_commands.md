# Simple Test Commands - Start Here!

## 🎯 **First, Let's Test if Commands Work**

### **Step 1: Create World**
1. Open **Minecraft Education Edition**
2. Click **"Create New World"**
3. Set these **exact** settings:
   - **World Type:** Flat
   - **Biome:** Plains
   - **Game Mode:** Creative
   - **Cheats:** ON
   - **Classroom Mode:** Enabled

### **Step 2: Test Basic Commands**
Open chat (press T) and try these **one at a time**:

```
/gamemode creative
```
(Should say "Set own game mode to Creative Mode")

```
/op @s
```
(Should say "Made @s a server operator")

```
/setblock ~ ~ ~ stone
```
(Should place a stone block where you're standing)

```
/fill ~ ~ ~ ~5 ~ ~5 stone
```
(Should create a 5x5 square of stone blocks)

## ✅ **If These Work - Continue to Building**

### **Step 3: Simple Zone 1 Test**
```
/fill -100 64 -100 -50 64 -50 quartz_block
```
(Should create a foundation)

```
/fill -100 65 -100 -50 70 -50 air
```
(Should clear the inside)

```
/fill -100 65 -100 -100 70 -100 white_concrete
```
(Should create one wall)

### **Step 4: Add Basic Features**
```
/setblock -90 65 -90 crafting_table
```
(Should place a crafting table)

```
/setblock -75 69 -75 glowstone
```
(Should place lighting)

## ❌ **If Commands Don't Work**

### **Check These Settings:**
1. **Are you in Creative Mode?** (F3 should show "Game Mode: Creative")
2. **Are cheats enabled?** (Check world settings)
3. **Are you the operator?** (Try `/op @s` again)

### **Alternative: Manual Building**
If commands fail, build manually:

1. **Go to coordinates** -100, 64, -100
2. **Place quartz blocks** in a 50x50 square
3. **Place white concrete** for walls
4. **Place glass** for roof
5. **Place crafting tables** inside

## 🔍 **What Error Messages Are You Seeing?**

**Common errors and solutions:**

- **"Unknown command"** → Check if you're in Creative Mode
- **"You don't have permission"** → Enable cheats and use `/op @s`
- **"No blocks changed"** → Check coordinates, try `/tp -100 64 -100` first
- **"Command too long"** → Break into smaller commands

## 🚀 **Quick Fix Commands**

Try these in order:

```
/gamemode creative
/op @s
/tp -100 64 -100
/fill -100 64 -100 -50 64 -50 quartz_block
```

**Tell me:**
1. **What happens when you try the test commands?**
2. **What error messages do you see?**
3. **Are you in Creative Mode?**
4. **Are cheats enabled?**

This will help me give you the exact solution! 🎯


