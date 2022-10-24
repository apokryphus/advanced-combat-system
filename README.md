![snek_red_orig](https://user-images.githubusercontent.com/98017171/197616716-4e69b8cb-3c5d-4563-8e23-60b368f6736e.png)

<div align="center">

Combat animation overhaul mod for The Witcher 3.
 </div>
 
 # OVERVIEW
The primary purpose of this mod is to enable the player to use all humanoid NPC combat animations available in the game.

The NPC animations are organized into 8 unique extra movesets:
- Olgierd + 1-Hand Sword
- Spear + Staff + Halberd
- Eredin + Shield + 1-Hand Sword
- Gregoire de Gorgon + 2-Hand Sword
- Imlerith + Caranthir + Caretaker
- 1-Hand Hammer + 2-Hand Hammer
- Dettlaff + Bruxa 
- 1-Hand Axe + 2-Hand Axe

Geralt's default moveset/behavior/animations are available for use at any time.
ACS does not edit them in any way, and allows for full compatibility with other mods that alter them.

Each ACS moveset comes with:
- Its own unique combos, abilities, counter-attacks, and weapon arts. 
- Its own set of dodges, rolls, hit animations, parry animations, death animations, and weapon-holding/passive behavior animations.

Additionally, the mod allows for higher vampire claw combat and abilities while the player is unarmed.
Can be toggled on or off in the mod menu, or set to apply only when the player has certain items equipped.

Also adds bow/arrow combat with special arrows and abilities, though is limited by weapon mode.

All extra animations included within ACS allow for animation canceling, meaning you can start another dodge/roll/evade/attack before the current one finishes.
This is by design, since some NPC animations are too long in duration to be used properly by humans without this feature, and I see no need to append the animations when they can be canceled. This does not mean, however, that the animations were completely suited for human use, and to that end I had to modify them somewhat. 

That being said, the animations are still quite complex and require a bit of timing as well as practice to use them effectively, especially for certain movesets.

Easy to perform, hard to master.

Depending on which weapon mode option is selected through the mod's Main Settings menu, the player may choose to play the game using one of the following modes:
- Switch movesets based upon selected sign (Axii, Yrden, Aard, Igni, Quen) and performing light/heavy attacks, which transforms the player's in-hand weapon to match the moveset applied.
- Select in the mod menu a desired moveset for the player's steel weapon and silver weapon, in which the player's in-hand weapon will transform to match the moveset.
- Mix and match in the mod menu different combat animations to create your own unique moveset, in which the player's in-hand weapon will transform accordingly to each animation set.
- Restrict the player to only use these special movesets when certain weapons/items are equipped.

Addtionally, the mod:
- Comes with a whole host of different offensive and defensive abilities / combo systems, either enabled/disabled through the mod menu, or tied to specific movesets/weapons.
- Allows the player to use special movement systems to traverse the world of The Witcher 3, available both in combat and out of combat.
- Incorporates a number of bugfixes not covered by other modders, such as fixing weapons not making impact sounds when applying debuffs to enemies. 
- Interfaces with other potential weapon DLCs (Shades of Iron, Exotic Arsenal, and more) that you may have installed, and applies the appropriate animations to certain weapons when they are equipped.
- Adds additional NPC weapons into the game as enemy loot, in which you may equip to gain access to the movesets.
- Improves human enemy AI, with a dynamic behavior system that makes every encounter a potentially deadly one. 
- Adds numerous custom enemies and bosses into the game world with their own mechanics and systems in place.

ACS is:
- Highly configurable through its mod menu, and just about every aspect can be modified to suit the player's needs.
- Relatively easy to merge in terms of scripts.
- Does not cause blurry dialogue loading screen from prolonged usage.
- Can be installed or uninstalled at any time.
- Is just about compatible with almost any overhaul/mod you can find.
  
# REQUIREMENTS
- Both **Hearts of Stone** and **Blood & Wine** DLCs are required.

# INSTALLATION

## Automatic Installation: 
Easy installer script that downloads and installs the mod automatically.
- Download this [script](https://github.com/apokryphus/advanced-combat-system/releases/download/supplement-v1.0.0/ACS_INSTALL_SCRIPT_RIGHT_CLICK_TO_RUN_WITH_POWERSHELL.ps1) and place it directly in your **The Witcher 3 installation folder**. 
- If your game is on Steam, then the folder path might look something like: 
  - **C:\Program Files (x86)\Steam\steamapps\common\The Witcher 3**
- If your game is on GOG, then the folder path might looking something like: 
  - **C:\Program Files (x86)\GOG Galaxy\Games\The Witcher 3 Wild Hunt GOTY**
- If you see the folders **bin**, **content**, and **dlc**, then the script is in the correct place.
- Right click the script and click **Run with PowerShell**.

## Manual Installation: 
For those that prefer to install manually.
- Latest and previous versions of the mod can be found in [releases](https://github.com/apokryphus/advanced-combat-system/releases).
- Download zip from [latest version](https://github.com/apokryphus/advanced-combat-system/releases/latest). First link under **Assets**. Do not download the source code.
- Drag and drop all 3 folders in the zip file (**dlc**, **mods**, and **bin**) into your Witcher 3 installation folder.

## After Installation:
- Run [***script merger***](https://www.nexusmods.com/witcher3/mods/484) and merge the scripts if you have other script mods installed. It should auto-merge in most cases. 
- If not, remember to pick and include the code from ACS.
- If you don't know how to use the script merger, please read through this [guide](https://aelto.github.io/tw3-notes/misc/merging/index.html) by Aeltoth, author of RER. 
- Use either [mod limit fix](https://www.nexusmods.com/witcher3/mods/3643) or [mod limit adjuster](https://www.nexusmods.com/witcher3/mods/3711) if your game does not start.

## Updating the mod:
- Run the automatic installer again, or go into **mods\mod_ACS** , click on the file **CLICK_ME_TO_UPDATE.bat**, and follow its instructions. 






# 

<div align="center">
  
# INDEX

### [1. MENU](#1-menu-1)
### [2. FISTS](#2-fists-1)
### [3. ARMED](#3-armed-1)
### [4. ELEMENTAL COMBO SYSTEM](#4-elemental-combo-system-1)
### [5. ELEMENTAL REND SYSTEM](#5-elemental-rend-system-1)
### [6. PARRY SKILLS](#6-parry-skills-1)
### [7. TAUNT SYSTEM](#7-taunt-system-1)
### [8. ENEMIES](#8-enemies-1)
### [9. MOVEMENT SYSTEM](#9-movement-system-1)
### [10. ARMOR SYSTEM](#10-armor-system-1)
### [11. SPECIAL ABILITIES](#11-special-abilities-1)
### [12. COOLDOWN ADJUSTMENT](#12-cooldown-adjustment-1)
### [13. STAMINA](#13-stamina-1)
### [14. COMPATIBILITY](#14-compatibility-1)
### [15. Q&A](#15-qa-1)
### [16. CONTACT ME](#16-contact-me-1)
</div>


# 1. MENU
ACS has four primary weapon modes, Armiger Mode, Focus Mode, Hybrid Mode, and Equipment Mode. 
- Modes are selected in the Main Settings menu.

![ArmigerModeSwitch](https://user-images.githubusercontent.com/98017171/170869647-aa5088ed-ce5a-41ae-8ac5-9111e4996b0d.PNG)
![FocusModeSwitch](https://user-images.githubusercontent.com/98017171/170869651-effeed07-264f-4e6f-b4fe-4e51510a888a.PNG)
![HybridModeSwitch](https://user-images.githubusercontent.com/98017171/170869653-2f390681-0a8d-43de-8262-607742b4ecf7.PNG)
![EquipmentModeSwitch](https://user-images.githubusercontent.com/98017171/170869650-7b41321a-7530-4e4e-959f-12329e0a7c52.PNG)

## Armiger Mode: 

How the mod functions as showcased in the weapon demo videos below, where selecting different signs and attacking with light attack or heavy attack changes Gerry's weapons/attack moveset. 

When Armiger Mode is selected in the Main Settings menu, navigate to the Armiger Mode menu to change whether you want Static Weapons or Evolving Weapons, and to optionally select the movesets/weapons for each sign.

Explanation for Static Weapons and Evolving Weapons is provided in the Armed section below.

![3](https://user-images.githubusercontent.com/98017171/170868519-7c6f5125-b008-4b8c-a59f-112cfce6004a.PNG)

## Focus Mode: 

When Focus Mode is selected in the Main Settings menu, navigate to the Focus Mode menu. 

There, you can select the weapon of your choice out of the nine available weapons that you want to use for silver weapon and steel weapon. The weapon's stats are taken from whatever weapon you have equipped in your inventory.

There are different weapons for silver and steel.

The weapons are:
- Default Geralt sword
- Olgierd sabre / Ofieri sabre
- Eredin longsword / Shield (Holding down parry will bring out a shield. Attacks while shield is active have their own set of animations.)
- Imlerith hammer / Caretaker shovel (Scythe for evolving weapons option)
- Claws
- Spear / Guisarme
- Colossal sword
- Cyclop's weapon / Cloud giant's weapon
- Greataxe / Warhammer

Each weapon has its own unique combat animations for: 
- Light Attack
- W (Forward) + Light Attack
- Heavy Attack
- W (Forward) + Heavy Attack
- Special Attack (Whirl)
- W (Forward) + Special Attack (Whirl)
- Counterattack/Parry Skill
- W (Forward) + Counterattack/Parry Skill
 
 ![FocusModeMenu](https://user-images.githubusercontent.com/98017171/170869806-1c212df8-2281-4292-ad56-1e17e19e011e.PNG)

 ## Hybrid Mode: 
 
Upon selection of Hybrid Mode in the Main Settings menu, navigate to the Hybrid Mode Settings panel. 

There, you can customize your own array of attacks for:

- Light Attack
- W (Forward) + Light Attack
- Heavy Attack
- W (Forward) + Heavy Attack
- Special Attack (Whirl)
- W (Forward) + Special Attack (Whirl)
- Counterattack/Parry Skill

![1](https://user-images.githubusercontent.com/98017171/170868475-b9cbd75b-cefc-4db5-a250-06b619e10c4c.PNG)
 
 ## Equipment Mode: 
 
 Upon selection of Equipment Mode in the Main Settings menu, equipping certain items will change the player's moveset. 
 
 Enemies will drop special ACS weapons as loot, which grants access to the movesets.

ACS also supports weapon DLCs made by other mod authors, which include (but not limited to) the majority of the weapons from:

- Shades of Iron
https://discord.com/channels/728022548796801064/728023281558618214/964947835986509854

- Exotic Arsenal
https://www.nexusmods.com/witcher3/mods/4074

- NPC Weapons Mod V1.01 (Note that this mod causes bugs. ACS already includes the majority of these weapons)
https://www.nexusmods.com/witcher3/mods/930

- Lethal Baguettes
https://www.nexusmods.com/witcher3/mods/5937

- COMICALLY LARGE SPOON
https://www.nexusmods.com/witcher3/mods/4924

- Warglaives
https://discord.com/channels/728022548796801064/776240617335816263/927252884196827208

- Scythe
https://discord.com/channels/728022548796801064/776240617335816263/909033164020785152

### Item list and their respective animations:
	
### -----Vampire Claws (Unarmed/Fists)-----

Vanilla:
- Hen Gadith Gloves
- Tesha Mutna Gloves

Shades of Iron:
- Kara Gloves

### ------Eredin/1-Hand Sword/Shield-----

Vanilla:
- Winter's Blade

Shades of Iron:
- Kingslayer
- Frostmourne
- Sinner
- Voidblade
- Bloodshot
- Gorgonslayer

Exotic Arsenal:
- spirit
- soul
- chakram
- luani
- bajinn roh
- silver roh

NPC Weapons Mod V1.01:
- NPC Eredin Swordx
- S_NPC Eredin Swordx
- q402_item__epic_swordx
- S_q402_item__epic_swordx
- sq304_powerful_sword
- S_sq304_powerful_sword

### -----Olgierd/1-Hand Sword-----

Vanilla:
- Iris

Shades of Iron:
- Rakuyo
- Vulcan
- Flameborn
- Bloodletter
- Eagle Sword
- Lion Sword
- Cursed Khopesh

Exotic Arsenal:
- stiletto
- stiletto_silver
- sickle
- sickle_silver
- claw sabre
- talon sabre
- jaggat
- serrator
- crescent
- crescent_silver
- rapier
- rapier_silver
- venasolak
- hjaven
- wrisp
- skinner

### -----Imlerith/Caranthir/Caretaker-----

Vanilla:
- Caretaker Shovel
- Knight Mace 1
- Knight Mace 2
- Knight Mace 3

NPC Weapons Mod V1.01:
- Imlerith Macex
- S_Imlerith Macex

Scythe:
- scythe steel
- scythe silver

### -----Sword Claws-----

Shades of Iron:
- Knife 
- Kukri

Exotic Arsenal:
- dagger1
- dagger1_silver
- dagger2
- dagger2_silver
- dagger3
- dagger3_silver

Warglavies:
- gla_1
- gla_2
- gla_3
- gla_a
- gla_b
- gla_c

### -----Spear/Staff/Halberd-----

Shades of Iron:
- Heavenspire
- Guandao
- Hellspire
	
Exotic Arsenal:
- naginata
- naginata_silver
- glaive
- glaive_silver

NPC Weapons Mod V1.01:
- Spear 1
- S_Spear 1
- Spear 2
- S_Spear 2
- Halberd 1
- S_Halberd 1
- Halberd 2
- S_Halberd 2
- Guisarme 1
- S_Guisarme 1
- Guisarme 2
- S_Guisarme 2
- Staff
- S_Staff
- Oar
- S_Oar
- Pitchfork
- S_Pitchfork
- Rake
- S_Rake
- Caranthil Staff
- S_Caranthil

### -----Gregoire de Gorgon-----

Shades of Iron:
- Realmdrifter Blade
- Realmdrifter Divider
- Claymore
- Icarus Tears
- Hades Grasp
- Graveripper
- Oblivion
- Dragonbane
- Crownbreaker
- Beastcutter
- Blackdawn
- Pridefall

Exotic Arsenal:
- greatsword1
- greatsword1_silver
- greatsword2
- greatsword2_silver
- greatsword3
- greatsword3_silver
- orkur
- maltonge

### -----Hammer (1-Hand/2-Hand)-----

NPC Weapons Mod V1.01:
- Twohanded Hammer 1
- S_Twohanded Hammer 1
- Twohanded Hammer 2
- S_Twohanded Hammer 2
- Great Axe 1
- S_Great Axe 1
- Great Axe 2
- S_Great Axe 2
- Lucerne Hammer
- S_Lucerne Hammer
- Wild Hunt Hammer
- S_Wild Hunt Hammer

Lethal Baguettes:
- great baguette

COMICALLY LARGE SPOON
- Spoon
- NGP Spoon

### -----Axe (1-Hand/2-Hand)-----

Vanilla:
- W_Axe01
- W_Axe02
- W_Axe03
- W_Axe04
- W_Axe05
- W_Axe06
- W_Mace01
- W_Mace02

Shades of Iron:
- Ares
- Haoma
- Doomblade

Exotic Arsenal:
- kama
- kama_silver

NPC Weapons Mod V1.01:
- Mace 1
- S_Mace 1
- Mace 2
- S_Mace 2
- Axe 1
- S_Axe 1
- Axe 2
- S_Axe 2
- Dwarven Axe
- S_Dwarven Axe
- Dwarven Hammer
- S_Dwarven Hammer
- Pickaxe
- S_Pickaxe
- Shovel
- S_Shovel
- Scythe
- S_Scythe
- Fishingrodx
- S_Fishingrodx
- Wild Hunt Axe
- S_Wild Hunt Axe
- Q1_ZoltanAxe2hx
- S_Q1_ZoltanAxe2hx

Lethal Baguettes:
- smol baguette
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 2. FISTS
When Armiger Mode, Focus Mode, or Hybrid Mode is selected, there are three options for fists, available for selection in the Main Settings menu:
- Normal fists
- Vampire claws
- Shockwave fists

Equipment Mode disables this setting, and the animations are applied only when specific items are equipped. 

### Vampire Claws

https://user-images.githubusercontent.com/98017171/160662412-115d9641-c9e8-4232-aa8a-70df9c829bb5.mp4

- Vampire claws are automatically equipped when attacking while unarmed.
- Vampire claws retract once the player is `out of combat`, or equips a weapon.
- Vampire claws deal `5% - 10%` maximum health damage to `red health enemies`, and `10% - 20%` maximum health damage to `monsters`. This damage can be modified in the Damage Settings menu.
- Attacks apply `bleeding` and `heals for 2.5%` of the player's maximum health.
- ```Light attacks``` are light vampire strikes. 
- ```Heavy attacks``` are heavy vampire strikes.
- ```W + light attack``` are vampire claw combos.
- ```W + heavy attack``` are vampire dash attacks.

Vampire Claw Parries:
- Vampire claw parries blocks 90% of the damage dealt to the player.
- Will block as long as the player has stamina.
- Drains 5% of the player's stamina on each block.
- Drains 50% of the player's stamina if the player takes lethal damage. Will block full damage.

 ### Shockwave Fists
 - Every punch releases a shock wave in front of the player.
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 3. ARMED

### || Static/Evolving Weapons ||
Depending on whether **Static Weapons** or **Evolving Weapons** are selected in **Armiger Mode Settings** , the **Focus Mode Settings**, or the **Hybrid Mode Settings**, the player will have slightly different weapons. These are purely cosmetic changes, and do not have any impact on gameplay.

- For **STATIC WEAPONS**:
  -  Weapons will not change how they look.
    - Steel: 
      - Olgierd Moveset: Iris
      - Eredin/Shield Moveset: Eredin's sword, modified to be double sided
      - Imlerith/Caretaker/Caranthir Moveset: Caretaker's spade
      - Dettlaff Moveset: Steel Sword Claws, fully evolved
      - Spear Moveset: Ofieri Spear
      - Gregoire Moveset: Gregoire de Gorgon's Sword
      - Hammer Moveset: Golyat's Weapon
      - Axe Moveset: Wild hunt Hammer
    - Silver:
      - Olgierd Moveset: Ofieri Sabre
      - Eredin/Shield Moveset: Eredin's sword, modified to be double sided
      - Imlerith/Caretaker/Caranthir Moveset: Imlerith's Hammer
      - Dettlaff Moveset: Silver Sword Claws, fully evolved
      - Spear Moveset: Guisarme
      - Gregoire Moveset: Gregoire de Gorgon's Sword
      - Hammer Moveset: Cloud Giant's Weapon
      - Axe Moveset: Wild hunt Axe
      
- For **EVOLVING WEAPONS**: 
   - Weapon level and/or rarity will change how each of the weapons look. 
   - There are different silver and steel versions of each weapon, dependent upon if Geralt is holding a silver or steel weapon. 

#### - Weapon Tier Appearance System For Evolving Weapons
- **Tier I Weapon Appearance**
   - Weapon level 1-10 ***OR*** ``Common`` type weapons.
- **Tier II Weapon Appearance**
   - Weapon level 11-20 ***AND*** weapon rarity above ``Common``.
- **Tier III Weapon Appearance**
   - Weapon level 21+ ***AND*** weapon rarity equal to or above ``Relic``.

#### - Miscellaneous Info
- ACS moveset weapons will display the runes and enchantments of the weapon you currently have equipped in your inventory, if it is supported on the weapon.
- The Severance enchantment increases the range of **all** attacks from ACS movesets. 

# Armiger Mode Movesets
While in Armiger Mode, selecting different signs while holding a weapon will change Geralt's moveset and grant him different weapons, depending on selected sign. 

- Two movesets are paired with each other for Light Attacks and Heavy Attacks, the former being the primary and the latter being the secondary:
  - Olgierd Moveset + Spear Moveset
  - Eredin/Shield Moveset + Gregoire Moveset
  - Imlerith/Caretaker/Caranthir Moveset + Hammer Moveset
  - Dettlaff Moveset + Axe Moveset

- Light attacks switch to ```primary weapons```.
- Heavy attacks switch to ```secondary weapons```.

The **Armiger Mode** menu allows the player to modify which weapon corresponds to which sign. 

- All moveset damage is based on ``currently equipped weapon in inventory``. 
- Select weapons have ``increased range``. 
- All extra movesets each have a ``special light attack``, replacing ``Whirl``. ```Requires Whirl to use```.
- ```Holding down W (Forward) key``` while attacking with ``light attacks``, ``heavy attacks``, or ``special light attacks`` will alter attack moveset. 
- There are two modes for combos:
  - Sequential: Combos will follow a pattern, and repeat once reaching the last move in the set. 
  - Randomized/Distance Based: The ```range/distance of opponent``` from the player will alter attack moveset.
- The Olgierd moveset/weapon, Eredin/Shield moveset/weapon, and Gregoire moveset/weapon possess the ability to perform automatic finishers on enemies.
- All other moveset/weapons do not have automatic finishers, and will instead attempt to ``dismember`` the enemy.

### || Olgierd Moveset + Spear Moveset ||
```Light Attack``` = **Olgierd/1-Hand-Sword Single Strikes**

https://user-images.githubusercontent.com/98017171/160676910-294ac31c-556f-4beb-842f-a6685c82913a.mp4

```W Key (Forward) + Light Attack``` =  **Olgierd Pirouette Spinning Strikes**

https://user-images.githubusercontent.com/98017171/160677368-b6b7c6a6-35f7-480d-8ab3-28f92dea93b0.mp4

``` Heavy Attack``` = **Spear/Staff/Halberd Single Strikes**

https://user-images.githubusercontent.com/98017171/160677687-e602ec1d-aa84-49e4-a2bf-8d2bacb3d2c1.mp4

```W Key (Forward) + Heavy Attack``` = **Spear/Staff Whirling Attacks**

https://user-images.githubusercontent.com/98017171/160678147-45d19fc2-1981-440d-a133-2066e07d0e4e.mp4

```Special Light Attack``` = **Olgierd Combo Strikes**

https://user-images.githubusercontent.com/98017171/160678621-ab99bf65-ffc4-42b8-bf21-fd8b827eb8c0.mp4

```W key (Forward) + Special Light Attack``` = **Olgierd Shadow Dash**

https://user-images.githubusercontent.com/98017171/160678864-53fe2588-92c8-4ca2-a593-3bb256c47ad3.mp4

If the player has full adrenaline and full stamina, Umbral Slash End is available for use for Olgierd weapon's special attack ( Forward (W) + Special Light Attack (Whirl) ). Consumes all of the player's adrenaline and stamina on use.

https://user-images.githubusercontent.com/98017171/185812044-85b1c060-3fbb-4e5f-8826-41a2f445a05f.mp4

### || Eredin/Shield Moveset + Gregoire Moveset ||
```Light Attack``` = **Eredin/2-Hand-Sword Single Strikes**

https://user-images.githubusercontent.com/98017171/160680639-ff9b7022-b90e-48e2-8c02-9a08085447ef.mp4

```W Key (Forward) + Light Attack``` = **Short Eredin/Caretaker Combo Strikes**

https://user-images.githubusercontent.com/98017171/160683127-07a6d741-7bec-4a1c-a95a-cf9ec596f175.mp4

``` Heavy Attack``` = **Gregoire de Gorgon Single Strikes**

https://user-images.githubusercontent.com/98017171/160684397-be431ec7-2fdb-4012-aa6e-d3a0de9c18ac.mp4

``` W Key (Forward) + Heavy Attack``` =  **Gregoire de Gorgon/1-Hand Sword Combo Strikes**
 
https://user-images.githubusercontent.com/98017171/160684822-937c4289-56bc-4432-9f84-52239e5ae88e.mp4

```Special Light Attack``` = **Long Eredin Combo Strikes**

https://user-images.githubusercontent.com/98017171/160685054-93d2ed63-646a-458b-a614-f47480218c07.mp4

```W key (Forward) + Special Light Attack``` = **Caretaker Charge Attack (Releases shockwave at the end)**
 
https://user-images.githubusercontent.com/98017171/160685411-8ac56299-e0c6-46ee-b478-e8656ecc21d5.mp4
 
### || Imlerith/Caretaker/Caranthir Moveset + Hammer Moveset ||
```Light Attack``` = **Imlerith/Caranthir/1-Hand-Mace Single Strikes**

https://user-images.githubusercontent.com/98017171/160686653-618c58c0-89bf-4cc2-924b-2613da5d16d6.mp4

```W Key (Forward) + Light Attack``` = **Imlerith/Caretaker Sweeping Strikes**

https://user-images.githubusercontent.com/98017171/160687119-3ce03d42-4080-4724-b2eb-a94edac6316d.mp4

``` Heavy Attack``` = **1-Hand-Hammer Single Strikes**

https://user-images.githubusercontent.com/98017171/160687643-f545102c-b5c1-4213-bbbe-5fd71f25470b.mp4

``` W Key (Forward) + Heavy Attack``` =  **2-Hand-Hammer Strikes**
 
https://user-images.githubusercontent.com/98017171/160688181-edcf0db7-1b22-4a66-b88a-2689f7a0de13.mp4

```Special Light Attack``` = **Imlerith Berserk Sweeping Strikes**

https://user-images.githubusercontent.com/98017171/160688598-beb200ff-815f-4bf8-bd9f-14cc58b43db6.mp4

```W key (Forward) + Special Light Attack``` = **Imlerith Berserk Single Strike**

https://user-images.githubusercontent.com/98017171/160689106-f12a2adf-12b0-4b70-8813-6e161a18753d.mp4

### || Dettlaff Moveset + Axe Moveset||
```Light Attack``` = **Dettlaff/Bruxae Vampire Single Strikes**

https://user-images.githubusercontent.com/98017171/160690590-aa30332b-c7a5-4fb8-bd8a-5b9d124e0a60.mp4

```W Key (Forward) + Light Attack``` = **Dettlaff Vampire Combo Attacks**
  
https://user-images.githubusercontent.com/98017171/160690649-cfdcd4b5-c965-42e9-b6ae-d7cd113795d9.mp4

``` Heavy Attack``` = **1-Hand-Axe/1-Hand-Mace Single Strikes**

https://user-images.githubusercontent.com/98017171/160690680-f9dbce99-b8aa-462c-8633-423fb2706a43.mp4

``` W Key (Forward) + Heavy Attack``` = **2-Hand-Axe Strikes**
 
https://user-images.githubusercontent.com/98017171/160690713-311c39d5-6c3a-43f6-ad1e-69b32c937cb3.mp4

```Special Light Attack``` = **Dettlaff Vampire Spinning Attack**

https://user-images.githubusercontent.com/98017171/160690934-5866f450-e439-454e-ba91-0d7f069c8ff3.mp4

```W key (Forward) + Special Light Attack``` = **Dettlaff Vampire Dash Strike**
 
https://user-images.githubusercontent.com/98017171/160690963-92a91bc4-2f7f-498c-8776-338828df5170.mp4

# Focus Mode / Hybrid Mode / Equipment Mode Movesets
- All moveset damage is once again based on ``currently equipped weapon in inventory``. 
- Select weapons have ``increased range``.

- Each weapon/moveset has its own unique:
- `Light Attack` 
- `W + Light Attack`
- `Heavy Attack`
- `W + Heavy Attack`
- `Special Attack (Whirl)`
- `W + Special Attack (Whirl)`
- `Counterattack`
- `W + Counterattack`

- Combo modes (Sequential or Randomized/Distance based) will also follow the setting determined in the Main Settings Menu. 
- Eredin/Shield, Olgierd, and Gregoire's moveset possess the ability to perform automatic finishers on enemies.
- All other weapons do not have automatic finishers, and will instead attempt to ``dismember`` the enemy, unless triggering a manual finisher.

<div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 4. ELEMENTAL COMBO SYSTEM
When this option is enabled in the Main Settings menu, it allows the player's weapon to produce additional effects.

When ``successfully damaging an enemy`` while holding a ``primary weapon`` in a specific stance, the player will ``prime`` the enemy for a ``detonation effect``, which will be activated upon ``successfully damaging the enemy`` with a subsequent attack while holding the ``secondary weapon``.

This works both ways for all signs except for Geralt's default weapon, meaning that attacks while holding the ``secondary weapon`` will also ``prime`` the enemy for a ``detonation effect``, which will be detonated upon attacking while holding the ``primary weapon``.

- Enemies `primed` for detonation display a `marker` above them.
- Detonation consumes all markers.
- Markers disappear after combat if not consumed.
- Detonation requires at least 1/3 of the adrenaline bar.
- Every detonation consumes 1/3 of the adrenaline bar, meaning the player can hold 3 detonation charges at max adrenaline.
- Detonation effects at max adrenaline have longer effects duration on enemies and wider range. 
- Weapons passive effect activation chance scales with adrenaline in intervals of 1/3, 2/3, and max, with the chances of activation being 12%, 25%, and 50% respectively.

**The above only applies to Armiger Mode. In other modes, the only part of the system active is the weapons passive effects part, which produces the player's selected sign's effect instead.** 

# Armiger Mode Elemental Combo System Showcase

### || Default Geralt Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160706837-26190f5c-1fe9-4346-aea1-40bfb0130e4b.mp4

- Light attack/Any attack action after attacking with light attack:
  - Passive: None.
  - Primes enemy.
  - Detonation effect: None.

- Heavy attack/Any attack action after attack with heavy attack:
  - Passive: None.
  - Does not prime enemy.
  - Detonation: Detonates an ``explosion`` in a small radius, blasting enemies back and ``burning`` them. 
  
### || Eredin/Shield ||

https://user-images.githubusercontent.com/98017171/160708267-ab0a1ce6-735b-491f-af6a-f1181160044a.mp4

  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: Calls down ``frost orbs`` from the sky that target enemies in a small radius, dealing damage and applying a ``slowdown frost`` debuff to enemies.
  
### || Gregoire Moveset ||

https://user-images.githubusercontent.com/98017171/160707580-ba7d2bb4-1672-40f1-9b36-c2671f395ab7.mp4

  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: ``Freezes`` enemies in a small radius around the player.
  
### || Dettlaff Moveset ||
  
https://user-images.githubusercontent.com/98017171/190864773-24551dd1-c550-491e-ba7b-d6dad790d31a.mp4

  - Passive: Attacks grant ``healing`` equal to 2.5% of the player's maximum health.
  - Primes enemy.
  - Detonation: Causes blood to spill out from nearby enemies, inducing bleeding and staggers for 0.5 seconds. Range and bleed duration increases depending upon what the player's adrenaline levels are.
  
### || Axe Moveset ||

https://user-images.githubusercontent.com/98017171/190864803-6e69c231-6bd3-434b-a87e-d478ba827d7e.mp4

  - Passive: Attacks have a chance to apply ``stagger``. 
  - Primes enemy.
  - Detonation: Summons water pillars from under nearby enemies, causing confusion. Range and confusion duration increases depending upon what the player's adrenaline levels are.
  
### || Olgierd Moveset ||

https://user-images.githubusercontent.com/98017171/160707139-88343713-90b9-4add-adfc-f8c4672919e1.mp4

  - Passive: Attacks have a chance to apply ``blindness``.
  - Primes enemy.
  - Detonation: Summons a ``sand storm`` that applies ``blindness`` to enemies in a small radius.
  
### || Spear Moveset ||

https://user-images.githubusercontent.com/98017171/160707039-e92e0259-97dd-4114-ae04-d6c6e88b904a.mp4

  - Passive: Attacks have a chance to ``slow`` enemies.
  - Primes enemy.
  - Detonation: Summons a ``sand pillar`` that applies ``paralysis`` to enemies in a small radius.
  
### || Imlerith/Caranthir/Caretaker Moveset ||

https://user-images.githubusercontent.com/98017171/160708407-74163f58-dbc2-43c2-8788-6acf14c8753a.mp4

  - Passive: Attacks have a chance to``stagger`` enemies.
  - Primes enemy.
  - Detonation: Calls down ``magic missiles`` from the sky that target enemies in a small radius, dealing damage and applying a ``health drain debuff``.
  
### || Hammer Moveset ||

https://user-images.githubusercontent.com/98017171/160708354-9f5c8761-4b3c-4fcf-8ea9-b15c5aa8957f.mp4

  - Passive: Attacks have a chance to apply `knockdown`.
  - Primes enemy.
  - Detonation: Calls down ``lightning`` and blasts enemies away in a small radius.
  
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 5. ELEMENTAL REND SYSTEM
When this option is enabled in the **Main Settings** menu, releasing rend while holding certain weapons have addtional effects.
- Requires the rend skill to use.
- Elemental rend can only be activated at max adrenaline.  

### || Geralt's Default Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160715053-2a699ea6-1843-4011-9610-775eb6aee11b.mp4

- Heavy attack once first to use.
- Releases a single ``Ifrit golem's fire line`` in front of the player on first cast, burning and dealing minor damage to all enemies it comes into contact. 
  - Subsequent rends increase the number of fire lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - Resets back to one after the third rend. 
  
### || Gregoire Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160715026-4f6e7aa9-2291-4819-9d6c-b2e668ea669f.mp4

- Releases a single ``Eredin's ice line`` in front of the player on first cast, slowing and dealing minor damage to all enemies it comes into contact with, with a chance of freezing the enemy. 
  - Subsequent rends increase the number of ice lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - The chance of freezing increases with the increase of ice lines. 
  - Resets back to one after the third rend. 
  
### || Axe Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160715147-b14f5e73-b657-4f09-a1fe-262303a480c8.mp4

- Releases a single ``stone golem's rock line`` in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of rock lines, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 

### || Spear Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160715091-450a77cb-094e-4646-a14b-fb8e0c00a8ae.mp4

- Causes giant ``Leshen roots`` to erupt in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of roots, the second increasing to three, and the third increasing to five.
  - Resets back to one after the third rend. 
  
### || Imlerith/Caranthir/Caretaker Moveset/Weapon ||

https://user-images.githubusercontent.com/98017171/160715122-cbd65c80-de43-4ddd-8d1c-48f88af98175.mp4

- Releases a single ``cloud giant's shockwave`` in front of the player on first cast, knocking down and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of shockwaves, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 
  
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 6. PARRY SKILLS
### General Use/Available at all times

#### || Kick ||
``` W key + Doubletap Parry/Counterattack``` 

https://user-images.githubusercontent.com/98017171/160710004-34d677b9-b2b5-460e-9c2d-aa48ca54fad2.mp4

#### || Dagger Strike ||
```Hold down Light Attack + Parry/Counterattack``` 

https://user-images.githubusercontent.com/98017171/194230815-c825dfca-2bbc-4f02-bbf0-d8db503f8701.mp4

#### || Push ||
``` A key or D key + Parry/Counterattack``` 

https://user-images.githubusercontent.com/98017171/160710326-7fd55ee7-26e0-4b21-b3be-4193b6f239a5.mp4

### Weapon Specific
#### || Default Geralt Sword ||
```W key + Parry/Counterattack``` = Counter-swing

https://user-images.githubusercontent.com/98017171/160709655-d6d671b6-61b5-418a-a52a-ead5a15bc377.mp4

#### || Sword Claws ||
```W key + Parry/Counterattack``` = Bruxa biting attack

https://user-images.githubusercontent.com/98017171/194232665-5954a800-f0dc-4c8f-9042-bf3405a680e4.mp4

#### || Olgierd Weapon ||
```W key + Parry/Counterattack``` = Olgierd's pocket sand + Elbow strike

https://user-images.githubusercontent.com/98017171/160709715-7aff3242-81fb-4878-9c75-b09d6ef29877.mp4

#### || Imlerith/Caretaker/Scythe Weapon ||
```W key + Parry/Counterattack``` = Two-hand parry

https://user-images.githubusercontent.com/98017171/194232880-ed0fa762-b7a1-4642-96e8-5b88b6b83337.mp4

#### || Eredin Weapon ||
```W key + Parry/Counterattack``` = Kick/Stab/Kick-swing

https://user-images.githubusercontent.com/98017171/194233151-74c727a1-be35-40a3-bbef-e9ec27ad6541.mp4

#### || Spear Weapon ||
```W key + Parry/Counterattack``` = Spear Special

https://user-images.githubusercontent.com/98017171/194233600-262900f1-0647-41c2-8a27-c07a28912dab.mp4

#### || Gregoire Weapon ||
```W key + Parry/Counterattack``` = Hilt Bash

https://user-images.githubusercontent.com/98017171/194233815-f599b193-e645-4262-8b68-836b0cd0bcb6.mp4

#### || Gregoire Weapon ||
```W key + Parry/Counterattack``` = Hilt Bash

#### || Giant Weapon ||
```W key + Parry/Counterattack``` = AOE Strike + Lightning

https://user-images.githubusercontent.com/98017171/194234119-abae6703-783a-43ce-af66-2806302c90c8.mp4

#### || Axe Weapon ||
```W key + Parry/Counterattack``` = Axe Special

https://user-images.githubusercontent.com/98017171/194234327-3ae84cdd-61d7-48ea-9540-5cb39dad355c.mp4

#### || Vampire Claws ||
```W key + Parry/Counterattack``` = Bruxa biting attack

https://user-images.githubusercontent.com/98017171/160710417-9baeec91-c4a1-472b-b218-f0c1a90e755c.mp4

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 7. TAUNT SYSTEM
```Switching weapons (signs, default button is mouse-wheel on PC)``` while ```standing still``` with no movement keys held ```(WASD)``` will perform a taunt. 

Out of combat:
- If the taunt system is enabled in the menu options, and the option ```I WANNA PLAY GWENT``` is enabled, Geralt will go around asking people to play gwent with him when the taunt button is pressed. 

In combat:
- If the taunt system is enabled in the menu options, and the option ```Combat Taunt``` is enabled, enemies will be taunted in combat. 
- Taunts change based on what weapon is held. 
- ```5 enemies``` in a ```5 meter radius``` around the player will be taunted.
- After 0.75 seconds, enemies will be taunted one by one in 0.25 second intervals, have their levels ```reduced by around 1/2```, increasing their ```moral, stamina, and focus```. 
- Enemies will increase their speed anywhere from ```5% to 25%```. 
- They will also receive a small ```health regen``` amongst other things. 
- Taunted enemies will now apply knockdown and bleeding if they manage to hit the player.
- When they reach ```25% health through player damage```, taunted enemies have a ```75% chance``` to man up, leveling up to ```twice the player's level```, as well as gain ```max stamina and morale``` again. 
- Or the enemy will have a ```25% chance``` of accepting their failure and ```lose all stamina and morale```, as well as become ```paralyzed with fear```. 
- In other mods that remove enemy levels, they'll just gain stamina, morale, and speed boost. 
- In W3EE, they'll have increased damage instead when at 25% health. 
- Subsequent taunts on a taunted enemy will only replenish their ```morale, focus, and stamina```, and make them play a taunt animation.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
 
# 8. ENEMIES

## Dynamic Enemy Behavior System 

https://user-images.githubusercontent.com/98017171/196608085-fd4a751c-e4dc-45ed-b67e-e35ad288053e.mp4

The Dynamic Enemy Behavior System applies to all non-quest human type enemies carrying one-handed weapons:
  - Stage 1: If the enemy is hit by the player with an attack/repel leaving them with anywhere between 75% - 50% health, the enemy will swap their original 1-handed behavior to either witcher behavior or 2-handed behavior. 
  - Stage 2: If the enemy is hit by the player with an attack/repel leaving them with anywhere lower than 50% health but between 50% - 25% health: 
    - If the enemy had swapped to witcher behavior in Stage 1, they will now have a 75% chance to swap their behavior to 2-handed behavior, or a 25% chance to swap their behavior to shielded combat behavior. 
    - If the enemy had swapped to 2-handed behavior in Stage 1, they will now have a 75% chance to swap their behavior to witcher behavior, or a 25% chance to swap their behavior to shielded combat behavior. 
    - If the player is in a state of parrying while the enemy is swapping behavior in Stage 2, then the enemy will have a 75% chance of swapping to shielded combat behavior instead, and 25% chance of swapping to either witcher behavior or 2-handed behavior, dependent upon which one was swapped to first in Stage 1.
    - If the enemy was originally carrying a shield, and their shield was not destroyed or dropped by the time they reach Stage 2, then they will not have a chance to switch to shielded combat behavior at all, and instead will swap to either witcher behavior or 2-handed behavior, dependent upon which one was swapped to first in Stage 1.
 
 ## Guards 
 
 Guards cannot kill the player / knock the player unconscious.
  - Instead, each hit that would kill the player will cause the player to start losing money, up to 10% of the player's total amount of money per hit on Death March.
  - If the player has no money, the guard will heal to full health instead.
 
 ## Forest God
 
**Berstuk the Forgotten Forest God** has infested the world of The Witcher 3.

- He can be found in all maps except for the White Orchard maps and Wyzima.
  - Velen: Where Kernun is located.
  - Skellige: Where the Woodland Spirit is located.
  - Spiral: The portal of the Poison Forest.
  - Toussaint: Trastamara Estate.
  - Kaer Morhen: Ruined Keep.
  - Isle of the Mists: [REDACTED]

- Berstuk is extremely tough, and should be approached with caution. He is also very hostile, and will relentlessly chase the player or any other prey in his immediate surroundings. 
- The Forest God has a number of mechanics involved, which will require skills, thinking, and some luck from the player to defeat him without cheating.
- Upon death, Berstuk additionally drops a vast sum of crowns and assorted precious gems. 
- If **Shades of Iron** is installed, instead of gems he will drop one random Radiant quality armor and one random Radiant quality weapon.
- Berstuk will respawn each time the player changes maps (eg. Velen <---> Skellige).
 
 ## Forest God Shadows

As long as the Forest God is alive on a map, there is a 10% chance his Shadow will appear after any fight. 

- The chances of a Shadow spawning can be modified in the Main Settings menu.
- The Shadow cannot spawn more than once every 7 minutes. 
- This chance of the Shadow appearing will ignore the value set in the Main Settings menu and increase to 30% **if the player has any items to do with leshens in their inventory**. 
- Shadows drop emeralds and leshen mutagen upon death. 
 
 ## Ice Titans

Nine ice titans roam the Skellige Islands.


<div align="right">
  
##### [Return to Index](#index)
  
</div>
  
# 9. MOVEMENT SYSTEM
### || Bruxa Dash ||

https://user-images.githubusercontent.com/98017171/160713938-ec49b801-a8d8-42ce-ba20-865e4ec08a61.mp4

Out of Combat: ```Hold Sprint + Forward (W)``` or ```Hold Sprint + Doubletap Forward (W)```

In Combat: ```Doubletap + Dodge```
- Dashes a fixed distance forward, alternating a little bit left or right.
- Bruxa dash serves as a ``reset button`` to many things. Use it to dash out of ``wraith mode``, ``bruxa bite``, or generally anything you might encounter. 
- Bruxa dash while in exploration will dash further than dashing in combat. 
- Bruxa dash distance is reduced while the player is interior.

### || Wraith Mode ||

https://user-images.githubusercontent.com/98017171/160714014-cfb75b10-6d9d-48cd-9234-8482649a7ca7.mp4

```Witcher Sense + Hold Sprint + Forward (W)``` or ```Witcher Sense + Hold Sprint + Doubletap Forward (W)```
- Can only be used out of combat.
- Enables the player to ignore collision, phase through walls, and fly through the air.
- Hold the jump button to fly directly upwards.
- Don't use this to fly out of locations during certain quests. May break a few quest triggers that will prevent you from progressing the game. 

### || Bruxa Leap Attack ||

https://user-images.githubusercontent.com/98017171/160714180-15b2173a-3a95-4d3c-8846-c6b6e4a2edd3.mp4

```Doubletap Forward (W) in combat while not holding sprint key```
- Can only be used in combat.
- Leaps at your targeted enemy, dealing damage.
- Bruxa leap attack is capable of targeting airborn enemies.

### || Bruxa Leap Attack (Air) ||

https://user-images.githubusercontent.com/98017171/160728891-9edba35f-b10d-424d-a1e3-3e750a9cdc4c.mp4

- Leaping from the air onto enemies will send out a ``shockwave around the enemy``, erupting ``stone pillars`` and blasting enemies back in a 6-meter radius around the player.
- Leaping from the air onto enemies during certain ``weather conditions`` will additionally call down ``lighting strikes`` upon enemies, and leave an ``electrical field`` that burns enemies in a 6-meter radius around the player.

### || Dodge Slide ||
```S key + Dodge```
- Can only be used in combat.
- Slides the player back a fixed distance away from the targeted enemy.
- Replaced with a different type of dodge when on cooldown.
- Vampire movesets have a different dodge slide. 

### || Teleport Dodge ||

https://user-images.githubusercontent.com/98017171/160714398-64ea6a4e-bd67-45af-a628-218202df3263.mp4

```Doubletap + Roll```
- Each weapon/moveset has their own teleport dodge.
- Can only be used in combat.
- Teleports the player behind your targeted enemy. 
- Don't use this while near the edge of a terrain. Might teleport you somewhere you don't want to be.

### || Bruxa Dodges ||

https://user-images.githubusercontent.com/98017171/160714536-2449dd4e-f198-4980-a643-c3b2e76daa05.mp4

```Doubletap S key``` = Bruxa dodge back center

```Doubletap A key``` = Bruxa dodge back left

```Doubletap D key``` = Bruxa dodge back right

- Nothing really to say about these. Dodge like a vampire.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>

# 10. ARMOR SYSTEM

 - While wielding an ACS weapon or using an ACS moveset, the player's armor is enhanced. Enemies scoring a hit on the player will have a chance to have a small percentage of that damage reflected back at them. 
 - The chances of this happening is based upon the type of armor the player is wearing:
    - Heavy armor: 55% chance
    - Medium armor: 35% chance
    - Light armor: 15% chance
- Each time this occurs, the damage is reduced by a certain amount, but will consume 15% of the player's max stamina.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 11. SPECIAL ABILITIES
  
 <div align="center">
 
### Special Abilities Index
#### [Shield](#-shield-)
#### [Aspect of the Hym](#-aspect-of-the-hym-)
#### [Bruxa Camouflage](#-bruxa-camouflage-)
#### [Bruxa Bite](#-bruxa-bite-)
#### [Caretaker Shades](#-caretaker-shades-)
#### [Aspect of the Toad](#-aspect-of-the-toad-)
#### [Aspect of the Djinn (Single Target)](#-aspect-of-the-djinn-single-target-)
#### [Aspect of the Djinn (Multi Target)](#-aspect-of-the-djinn-multi-target-)
#### [Summoned Wolves](#-summoned-wolves-)
#### [Summoned Shadow Centipedes](#-summoned-shadow-centipedes-)
#### [Phantom Swords](#-phantom-swords-)
#### [Necromancy](#-necromancy-)
#### [Bat Swarm](#-bat-swarm-)
#### [Weapon Arts](#-weapon-arts-)
#### [Bow](#-bow-)
  </div>

### || Shield ||

https://user-images.githubusercontent.com/98017171/160716954-8f446bf6-8557-4c2f-9388-26daf4674b34.mp4

Holding down the ```Parry/Counterattack button``` while using the Eredin + Shield moveset will grant the player a shield. Default shield is Imlerith's shield. 
- Shield blocks all damage to the player as long as the player has stamina.
- Drains 10% of the player's stamina on each block.
- The player cannot dodge or roll while the shield is active.
 - Drains 50% of the player's stamina if the player takes lethal damage. Will block full damage.
 
### || Aspect of the Hym ||

https://user-images.githubusercontent.com/98017171/160717021-c0664cbb-ae76-46cd-97a7-e53ae91d3a51.mp4

Double-tapping and holding down ```Parry/Counterattack``` while using the Eredin + Shield moveset will summon a hym around the player. Release `Parry/Counterattack` to dismiss the hym. 
- The hym can only be summoned in ```darkness``` (10PM to 2AM) or if the player is in a ```dark place``` (caves etc.)
- An offering of ```30%``` of the player's current health must be given to the hym in order to summon it each time. If you ever hear whisperings in your ear, telling you that you can keep dismissing the hym and resummoning it to infinitely decrease your own health but not kill you, you may heed it. Only if you're into that sort of thing though. I don't judge. This pleases the hym, and you'd like that, wouldn't you?
- The hym is a sadistic creature, and deals 50 flat damage + 14.5% to 20% missing health damage to its targets in a wide range around the player.

### || Bruxa Camouflage ||

https://user-images.githubusercontent.com/98017171/160717113-1faadd81-1fe4-4cfe-83d2-30fd1a840235.mp4

 ```Double-tapping and holding down Parry/Counterattack``` while equipped with vampire claws triggers Bruxa camouflage.
   - 5% current health is continuously drained while camouflage is active. Health drain is halved if the player stands still.
   - The player can dash, attack, and do special abilities when in Bruxa Stealth mode. Doing a vampire dash attack or attacking while not having vampire claws equipped reveals the player.
   - Enemies close to the player will notice the player, while enemies farther away will not. 
   - The lower the enemy's health is, the greater their fear, which will be reflected in their reaction towards the camouflaged player. 
   - Only works on humans. Monsters behave normally. 
   
### || Bruxa Bite ||

https://user-images.githubusercontent.com/98017171/160717152-306eca70-803e-4426-b8a0-7bbe6aa5ee74.mp4

```Doubletap W``` while locked on a target will perform a bruxa bite attack. It's that thing where bruxae jump on Geralt and suck his blood. 
- Bruxa bite deals ```10% - 20%``` percentage health damage and heals for `10%` the player's max health. 
- Executes the enemy if they are below 10% health. 
- ```Doubletap sprint (Bruxa Dash)``` to release victim.
- Requires full stamina and full adrenaline. Resets adrenaline to 0 after use. 

### || Hijack ||

https://user-images.githubusercontent.com/98017171/160717219-21fd73d6-e570-4f41-be5d-bd7f2255ea57.mp4

Bruxa bite is capable of ```hijacking``` certain enemy movements.
#### - Current enemy list:
- Harpies
- Siren
- Wyvern
- Dracolizard
- Gryphon
- Basilisk
- Garkain
- Shaelmaar
#### - Controls:
- ```Holding down W``` while pressing ```A or D``` will nudge the creature to go either left or right. 
- ```Release W``` to nudge it forward. 
- Be aware, the creature will attempt to fight you for control. 

### || Caretaker Shades ||

https://user-images.githubusercontent.com/98017171/160717269-4160cc55-9ede-48b7-859e-ef46ac50c730.mp4

```S + Doubletap Parry/Counterattack``` will summon Caretaker shades around the player in a wide radius. 
- Shades will distract enemies, as other enemies will attempt to kill them, while also provide a source of ``life-steal`` for claws. 
- Shades do not attack, and will die in one hit. 
- Shades will automatically move towards the player if player is nearby, or move towards the closest enemy.
 - Shades summoning can only be used ```once per combat```, being replaced by a push/shove attack after used.
- The player will summon more shades when at less than ```50% health```. 
- The ```higher``` the level the player is, the more shades will be summoned. 
#### - Player level 10 or less 
- 1 shade normal, 2 shades at 50% or less health.
#### - Player level 11 to 15
- 2 shades normal, 5 shades at 50% or less health.
#### - Player level 16 to 20
- 3 shades normal, 7 shades at 50% or less health.
#### - Player level 21 to 25
- 5 shades normal, 10 shades at 50% or less health.
#### - Player level 26 or more 
- 7 shades normal, 15 shades at 50% or less health.

### || Aspect of the Toad ||

https://user-images.githubusercontent.com/98017171/160717341-c70abdd8-bb7e-4100-b765-0356c44a737c.mp4

```S Key + Parry/Counterattack``` while ```hard locked``` on a target (default key Z) at ```close range``` will cause the player to channel a fraction of the power of the Toad, vomiting on all enemies in a small area in front of the player.
- Requires full stamina and full adrenaline. Resets adrenaline to 0 after use. 
- Can only be used while the player is on the ```ground```.
- Toad vomit deals current health percentage damage as ```poison damage```, but ```executes``` the enemy at a certain health threshold.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Aspect of the Djinn (Single Target) ||

https://user-images.githubusercontent.com/98017171/160717385-c14ca798-d499-4a2e-ba01-cf170fdc227f.mp4

```S Key + Parry/Counterattack``` while ```hard locked``` on a target (default key Z) at ```medium to long range``` will cause the player to channel a fraction of the power of a djinn and shoot a beam of lightning at the target.
- Requires full stamina and full adrenaline. Resets adrenaline to 0 after use. 
- Can only be used while the player is on the``` ground```.
- Extra targets at close range and close to the beam of lightning will be hit.
- Djinn lightning deals current health percentage damage as ```direct damage```, but ```executes``` the enemy at a certain health threshold. 
- Targets have a small chance to burn.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Aspect of the Djinn (Multi Target) ||

https://user-images.githubusercontent.com/98017171/160717440-e181962d-78c4-4351-9472-2d737db72973.mp4

```Parry/Counterattack``` while at ```medium to long range``` will cause the player to channel more of the power of a djinn and shoot beams of lightning at the ```five``` closest targets to the player.
- Requires full stamina and full adrenaline. Resets adrenaline to 0 after use. 
- Can only be used while the player is in ```wraith mode```.
- Djinn lightning deals current health percentage damage as ```direct damage```, but ```executes``` the enemy at a certain health threshold. 
- Targets have a small chance to burn.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Summoned Wolves ||

https://user-images.githubusercontent.com/98017171/160717477-a79bbed0-0d6e-4f78-9cd1-9acc0a24d06e.mp4

Double-tapping and holding down ```Parry/Counterattack``` while holding the Quen primary weapon will summon three wolves around the enemy. Release ```Parry/Counterattack``` to dismiss the wolves. 

### || Summoned Shadow Centipedes ||

https://user-images.githubusercontent.com/98017171/160717525-9793dfac-53d6-49da-a28b-a6e8078f8347.mp4

Double-tapping and holding down ```Parry/Counterattack``` while holding the Quen primary weapon while the player is below ```50%``` health will summon three shadow centipedes around the enemy. Release ```Parry/Counterattack``` to dismiss the centipedes. 

### || Summoned Swords ||

https://user-images.githubusercontent.com/98017171/160717565-dd950a02-ad4b-4d23-9654-199e4350caf1.mp4

```W + Doubletap + Parry/Counterattack``` while in combat and not hard locked to enemy summons five Summoned Swords. 
- First cast summons the swords, second cast fires the swords. 
- Swords cost 2/3 current adrenaline/focus to fire.
- Sword damage is literally the player's light attacks. This means landing all five swords on the enemy = five light attacks at once. 
- This also means that it can be comboed with other attacks through the elemental combo system. 
- Swords destroy shields.
- Swords will disarm an opponent if they happen to hit their weapon hand. 

### || Necromancy ||
If enabled in the Special Abilities menu, double-tapping ```Parry/Counterattack``` while using the Imlerith/Caretaker/Caranthir moveset will allow the player to raise the dead.

When the player is above 50% health:

https://user-images.githubusercontent.com/98017171/168326595-89aa7b64-8421-4ec4-9ebd-ce856954df78.mp4

- A maximum of 10 corpses can be revived as revenants, in a 10 meter radius around the player.
- Humans cost 5% current health each to be revived.
- Small to regular sized monsters cost 7.5% current health each, while bigger monsters cost 20% current health each.
- Revenants have reduced health, but are very aggressive.
- Recasting the summoning WILL NOT destroy all active revenants.
- Revenants can be revived indefinitely.

When the player is below 50% health:

https://user-images.githubusercontent.com/98017171/168327611-e899c7fe-4e69-485a-91ce-49e28e871988.mp4

- The player will create skeleton soldiers from corpses instead.
- A maximum of 15 skeleton soldiers can be created in a 20 meter radius around the player.
- Each soldier costs 10% current health to summon.
- Soldiers are aggressive, fast, and vary in size.
- Recasting the summoning WILL destroy all active skeleton soldiers.

All revenants and skeleton soldiers are destroyed if the player leaves combat.

### || Bat Swarm ||

https://user-images.githubusercontent.com/98017171/171998778-2f4cc15e-842e-4922-b8a6-ec2601be3c3e.mp4

`Double-tap + hold parry + sword claws`

- The player summons a horde of bats. When active, the player's stamina will rapidly drain, but successful damaging attacks on enemies will regain a small percentage of the player's max stamina. 
- The swarm dissipates when the player has no stamina left. 
- Surrounding enemies will be `pulled` towards the player, be continuously damaged for a tiny percentage of their health, have a large chance to be affected by `bleeding`, and a very small chance to be affected by `blindness`. 
- Swarm executes when the enemy health drops below 5%. 

### || Weapon Arts ||
`Back (S key) + light attack` activates Weapon Arts for all movesets.

#### Vampire claws: Sonic Scream

https://user-images.githubusercontent.com/98017171/185811967-d19efc2b-4e6c-4720-b21c-792f730a50f3.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Deals enemy missing health damage. The lower the enemy's health is, the greater the damage.

#### Olgierd weapon: Umbral Slash

https://user-images.githubusercontent.com/98017171/185811978-be29a57b-4db4-4607-8356-6dae26b6d067.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Deals weapon damage + small amount of enemy max health damage. 
 
#### Spear weapon: Stormspear

https://user-images.githubusercontent.com/98017171/190557814-2b8df83d-bfef-48aa-b007-6a980d00bb9b.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Deals weapon damage + small amount of enemy max health damage. 
 - Immobilizes enemies.
 
#### Eredin weapon: Sparagmos

https://user-images.githubusercontent.com/98017171/185811985-e5b55bca-5646-45dc-a656-aaf792e5bc56.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Deals weapon damage + small amount of enemy max health damage. 
 - Causes burning.
 
#### Gregoire weapon: Judgement

https://user-images.githubusercontent.com/98017171/190557909-351a5141-65ea-4e91-a995-ad6f7cf35dbf.mp4

 - Can only be activated if the player has a full adrenaline bar. 
 - Consumes all adrenaline on use.
 - Deals enemy missing health damage. The lower the enemy's health is, the greater the damage.
 
Imlerith weapon: Crescent Caress

https://user-images.githubusercontent.com/98017171/185811996-6547834a-74e7-4c7d-8884-af1717607a5e.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Pulls enemy towards player location. 
 
Giant weapon: Earthshaker

https://user-images.githubusercontent.com/98017171/190557982-9509906b-fe52-40a8-b732-f3c620bb312e.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - First and second stomp staggers enemies. Third stomp knocks enemies down.
 
Sword Claw weapon: Flying Rabies

https://user-images.githubusercontent.com/98017171/190557713-88edbb03-fb76-41a1-be3e-f90fdaa0ac79.mp4

 - Can only be activated if the player has a full adrenaline bar. 
 - Consumes all adrenaline on use.
 - Deals enemy missing health damage. The lower the enemy's health is, the greater the damage.
 
Axe weapon: Waterpulse

https://user-images.githubusercontent.com/98017171/190558043-ffcaa934-5abc-48f4-b072-75cacb056f5e.mp4

 - Can only be activated if the player has at least 1/3 of the adrenaline bar. 
 - Consumes 1/3 of the adrenlaine bar on each use.
 - Landing all three waves will knock enemies down.
 
### || Bow ||
Bows are attached to heavy attack weapons in Armiger Mode. While in armiger mode and in combat with the heavy attack weapon equipped, double tap and hold down parry, then perform heavy attacks to use bow. 

#### Stationary Shot
https://user-images.githubusercontent.com/98017171/185868442-1f3cdaae-f00c-4c22-99c4-65d14f9870f6.mp4

- Firing arrows while stationary takes longer to wind-up, but will deal the full damage of your equipped weapon. Additionally, if the player is outdoors, it will unleash a rain of arrows at the enemy location if the arrow hits an enemy. Drains 3x the amount of stamina for a heavy attack for each arrow.

#### Movement Shot

https://user-images.githubusercontent.com/98017171/185868682-f909c877-5d4d-476b-bea1-a7b6ac684e58.mp4

- Firing arrows while any movement key is held down will quick fire arrows that deal only a small percentage of the enemy's max health. Every third arrow fired this way is twice the speed of the first two arrows, deals true damage, and applies a debuff for 1 second specific to the sign the player currently has selected. Drains the amount of stamina for a light attack for each arrow.
- Igni: Burns
- Axii: Freezes
- Aard: Knockdown
- Quen: Paralyze
- Yrden: Slowdown

<div align="right">
 
##### [Return to Index](#index)
  
  </div>
  
# 12. COOLDOWN ADJUSTMENT
- Open ```mod_ACS/content/scripts/local/ACS_Cooldown_Settings.ws```and follow instructions to further customize cooldowns to your liking. 

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 13. STAMINA
- Attacks/dodges/special abilities/counter attacks now have a minimum stamina requirement to use. 
- This feature can be toggled off in the Main Settings menu. 
- In vanilla, this doesn't create much of a difference, since attacks/dodges do not consume stamina. However, when used together with other gameplay overhauls that affect this, such as GM and W3EE, it creates a limitation on how many attacks/dodges you can do until you run out of stamina, which is a staple feature to these overhauls.
- You can tweak how much stamina is used for attacks and dodges by using the stamina settings from the overhauls. My mod takes their settings. 

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 14. COMPATIBILITY
- Most likely completely conflict free in terms of scripts.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
# 15. Q&A
### || Is this mod considered lore friendly and immersive?
- Very.

### || Are you lying?
- Yes.

 ### || Can I install or uninstall this mod mid game?
- Yes.

### || How easy is this to merge with other mods?
- In my experience, and the experience of others who have installed this mod, very easy. It's designed to do so due to my own modlist. 

### || I heard/experienced some animation mods cause long loading screens. Does this mod do that?
- No. The reason that some animation mods cause long loading screens is because they edit a file called ```pc_gameplay.w2beh```. This mod uses the DLC method, which mounts the extra animations onto the player without directly editing that file. 

### || Does this mod cause that weird twitching behavior for guards holding polearm weapons common to some animation mods?
- No. The reason for that is because of the method those animation mods edit the way the player holds their weapon. This mod does not do that. 

### || Will this mod affect Ciri's animations?
- No. The extra animations are mounted onto Geralt only. Ciri's animations are untouched. I'd consider adding more animations to her, but the player doesn't get to play as her very often anyways, so what's the point?

### || Can you make a version without the magic stuff?
- Maybe. Depends on my mood.

### || Can you make The Witcher 3 E3/VGX 2013 Lore-Friendly Immersive Reworked Animations Redux?
- I will kill you.
  
 <div align="right">
  
 ##### [Return to Index](#index)
  
  </div>
  
# 16. CONTACT ME
- Don't. If you really have to, find me in the Wolven Workshop discord server. I may or may not reply.

 <div align="center">

# Please do not upload this mod anywhere else without my explicit permission.
  
##### [Return to Index](#index)
  
  </div>
