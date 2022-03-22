<div align="center">

# advanced-combat-system
  
  Combat overhaul mod for The Witcher 3. 

Enables the player to use a wide variety of NPC animations and abilities, both in and out of combat.
  
  </div>

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Puc5b5c0lWc
" target="_blank"><img src="http://img.youtube.com/vi/Puc5b5c0lWc/0.jpg" 
alt="ADVANCED COMBAT SYSTEM" width="640" height="480" border="10" /></a>
  </p>
 <p align="center">
  Video showcasing a previous version of the mod. Bear in mind, the mod has changed quite a bit since the video was released. 
 </p>

## REQUIREMENTS
- Both **Hearts of Stone** and **Blood & Wine** DLCs are required.
- A PC not made out of wood. 

## INSTALLATION
- Latest version can be found in [releases](https://github.com/apokryphus/advanced-combat-system/releases).
- Download zip from latest version.
- Place ```dlc_ACS``` in dlc folder.
- Place EITHER ```mod_ACS_EVOLVING_WEAPONS```  OR  ```mod_ACS_STATIC_WEAPONS ``` in mods folder. 
- **DO NOT put both of them in.**
- ***Run script merger.***
- If you run into conflicts during the merging process, try to make sure that all the code between `// ACS ++` and `// ACS  - -` are selected in the final output. 

### mod_ACS_JumpExtend is optional. It increases the player's jump height by about 15 meters. 
- Jumping while sprinting will jump further and higher than jumping while idle. 
- Jumping while sliding will jump the furthest. 
- Don't put this in your mods folder if you don't have a custom camera mod like immersive cam since I didn't write one for this yet. 
- Or do, if you enjoy watching Geralt fly off screen every time he jumps. Who am I to tell you how to play this game?

## PREFACE

  The best way to enjoy this mod to its fullest extent is to install every mod you can find that increases difficulty in The Witcher 3. This mod does some things that help with this, like the taunt system. 
  
  [Aeltoth's Random Encounters Reworked](https://github.com/Aelto/tw3-random-encounters-reworked) is a good place to start. 
  
  All extra NPC animations and abilities included within this mod are able to cancel each other out. 
  
  This is by design, since some NPC animations are way too long to be properly used in combat without this feature.
  
  It is highly encouraged to use this feature as much as you can. 
  
  It is also highly encouraged to alternate between light and heavy attacks, as well as switch signs often, since there are systems built around this way of playing. 
  
  Of course, once again, you are more than welcome to disregard whatever I just said and play the game however you want. 
  
<div align="center">
  
# INDEX

### [1. FISTS](#1-fists-1)
### [2. ARMED](#2-armed-1)
### [3. ELEMENTAL COMBO SYSTEM](#3-elemental-combo-system-1)
### [4. ELEMENTAL REND SYSTEM](#4-elemental-rend-system-1)
### [5. PARRY SKILLS](#5-parry-skills-1)
### [6. TAUNT SYSTEM](#6-taunt-system-1)
### [7. MOVEMENT SYSTEM](#7-movement-system-1)
### [8. SPECIAL ABILITIES](#8-special-abilities-1)
### [9. USING CUSTOM WEAPONS FROM VANILLA GAME OR OTHER MODS](#9-using-custom-weapons-from-vanilla-game-or-other-mods-1)
### [10. COOLDOWN ADJUSTMENT](#10-cooldown-adjustment-1)
### [11. COMPATIBILITY](#11-compatibility-1)
### [12. Q&A](#12-qa-1)
### [13. CONTACT ME](#13-contact-me-1)
</div>

## 1. FISTS
Completely replaced by vampire claw attacks, regardless of sign.
- Vampire claws deal 5% to 10% maximum health damage to red health enemies, and 10% to 20% maximum health damage to monsters.
- Attacks apply bleeding and heals for 2.5% of the player's maximum health.
- ```Light attacks``` are light vampire strikes. 
- ```Heavy attacks``` are heavy vampire strikes.
- ```W + light attack``` are vampire claw combos.
- ```W + heavy attack``` are vampire dash attacks.
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 2. ARMED
Selecting different signs while holding a weapon will change Geralt's moveset and grant him different weapons, depending on selected sign. 
- Light attacks switch to ```primary weapons```.
- Heavy attacks switch to ```secondary weapons```.
### || Default Weapons ||
- Default weapons included within ACS are split between silver and steel versions, based on whether equipped weapon is silver or steel. 
- Weapons ```evolve``` according to equipped weapon's level and rarity.
- Igni sign shows actual/real weapon equipped.
#### - Weapon Tier System
- **Tier I Weapons**
   - Weapon level 1-10 ***OR*** ``Common`` type weapons.
- **Tier II Weapons**
   - Weapon level 11-20 ***AND*** weapon rarity above ``Common``.
- **Tier III Weapons**
   - Weapon level 21+ ***AND*** weapon rarity equal to or above ``Relic``.

<blockquote class="imgur-embed-pub" lang="en" data-id="a/zWgAgd4"  ><a href="//imgur.com/a/zWgAgd4">Advanced Combat System - Tier III Weapons</a></blockquote>
 
### || Movesets ||
- All moveset damage is based on ``currently equipped weapon in inventory``. 
- Select weapons have ``increased range``. 
- Quen, Axii, Yrden, Aard each have a ``special attack``, replacing ``Whirl``. ```Requires Whirl to use```.
- ```Holding down W key``` while attacking with ``light attacks``, ``heavy attacks``, or ``special attacks`` will alter attack moveset. 
- ```Range of opponent``` will also alter attack moveset (ie. holding down W while attacking with Axii heavy attacks at close range will slap your target).
#### - Igni
- ```Light Attack``` = **Default Geralt light attacks**
- ```Heavy Attack``` = **Default Geralt heavy attacks**
#### - Quen
- ```Light Attack``` = **Olgierd/1-Hand-Sword Single Strikes**
   - ```W key + Light Attack``` = **Olgierd Pirouette Spinning Strikes**
- ```Heavy Attacks``` = **Spear/Staff/Halberd Single Strikes**
   - ```W key + Heavy Attack``` = **Spear AOE Whirling Attacks**
- ``` Special Attack (Whirl)``` = **Olgierd Combo Strikes**
  - ```W key + Special Attack (Whirl)``` = **Olgierd Shadow Dash**
#### - Axii
- ```Light Attack``` = **Eredin/2-Hand-Sword Single Strikes**
   - ```W key + Light Attack``` = **Short Eredin/Caretaker Combo Strikes**
- ```Heavy Attacks``` = **Gregoire de Gorgon Single Strikes**
   - ```W key + Heavy Attack``` = **Gregoire de Gorgon/1-Hand Sword Combo Strikes**
- ``` Special Attack (Whirl)``` = **Long Eredin Combo Strikes**
  - ```W key + Special Attack (Whirl)``` = **Caretaker Charge Attack (Releases a shockwave at the end)**
#### - Yrden
- ```Light Attack``` = **Imlerith/Caranthir/1-Hand-Mace Single Strikes**
   - ```W key + Light Attack``` = **Imlerith/Caretaker Sweeping Strikes**
- ```Heavy Attacks``` = **1-Hand-Hammer Single Strikes**
   - ```W key + Heavy Attack``` = **2-Hand-Hammer Strikes**
- ``` Special Attack (Whirl)``` = **Imlerith Berserk Sweeping Strikes**
  - ```W key + Special Attack (Whirl)``` = **Imlerith Berserk Single Strike**
#### - Aard
- ```Light Attack``` = **Dettlaff/Bruxae Vampire Single Strikes**
   - ```W key + Light Attack``` = **Dettlaff Vampire Combo Attacks**
- ```Heavy Attacks``` = **1-Hand-Axe/1-Hand-Mace Single Strikes**
   - ```W key + Heavy Attack``` = **2-Hand-Axe Strikes**
- ``` Special Attack (Whirl)``` = **Dettlaff Vampire Spinning Attack**
  - ```W key + Special Attack (Whirl)``` = **Dettlaff Vampire Dash Strike**
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 3. ELEMENTAL COMBO SYSTEM
``Successfully damaging an enemy`` while holding a ``primary weapon`` in a specific stance will ``prime`` the enemy for a ``detonation effect``, which will be activated upon ``successfully damaging the enemy`` with a subsequent attack while holding the ``secondary weapon``.

This works both ways for all signs except for Igni, meaning that attacks while holding the ``secondary weapon`` will also ``prime`` the enemy for a ``detonation effect``, which will be detonated upon attacking while holding the ``primary weapon``.

Enemies need to be ``primed`` again after detonating an effect.
### || Igni ||
- Light attack/Any attack action after attacking with light attack:
  - Passive: None.
  - Primes enemy.
  - Detonation effect: None.
- Heavy attack/Any attack action after attack with heavy attack:
  - Passive: None.
  - Does not prime enemy.
  - Detonation: Detonates an ``explosion`` in a small radius, blasting enemies back and ``burning`` them. 
### || Axii ||
- Primary weapon:
  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: Calls down ``frost orbs`` from the sky that target enemies in a small radius, dealing damage and applying a ``slowdown frost`` debuff to enemies.
- Secondary weapon:
  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: ``Freezes`` enemies in a small radius around the player.
### || Aard ||
- Primary weapon:
  - Passive: Attacks grant ``healing`` equal to 2.5% of the player's maximum health.
  - Primes enemy.
  - Detonation: Attack grants ``healing`` equal to 25% of the player's maximum health, and infects enemies with ``poison`` in a small radius.
- Secondary weapon:
  - Passive: Attacks have a chance to apply ``stagger``. 
  - Primes enemy.
  - Detonation: Detonates an ``explosion`` that causes ``confusion`` to enemies in a small radius.
### || Quen ||
- Primary weapon:
  - Passive: Attacks cause ``bleeding`` and have a chance to apply ``blindness``.
  - Primes enemy.
  - Detonation: Summons a ``sand storm`` that applies ``blindness`` to enemies in a small radius.
- Secondary weapon:
  - Passive: Attacks have a chance to ``slow`` enemies.
  - Primes enemy.
  - Detonation: Summons a ``sand pillar`` that applies ``paralysis`` to enemies in a small radius.
### || Yrden ||
- Primary weapon:
  - Passive: Attacks ``stagger`` enemies.
  - Primes enemy.
  - Detonation: Calls down ``magic missiles`` from the sky that target enemies in a small radius, dealing damage and applying a ``health drain debuff``.
- Secondary weapon:
  - Passive: Attacks apply knockdown.
  - Primes enemy.
  - Detonation: Calls down ``lightning`` and blasts enemies away in a small radius.
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 4. ELEMENTAL REND SYSTEM
Releasing rend while holding ``secondary weapons`` have addtional effects. In Igni's case, this is activated by attacking with heavy attack once, and then using rend. 
Requires the rend skill to use. 
### || Igni ||
- Releases a single ``Ifrit golem's fire line`` in front of the player on first cast, burning and dealing minor damage to all enemies it comes into contact. 
  - Subsequent rends increase the number of fire lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - Resets back to one after the third rend. 
### || Axii ||
- Releasss a single ``Eredin's ice line`` in front of the player on first cast, slowing and dealing minor damage to all enemies it comes into contact with, with a chance of freezing the enemy. 
  - Subsequent rends increase the number of ice lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - The chance of freezing increases with the increase of ice lines. 
  - Resets back to one after the third rend. 
### || Aard ||
- Releasss a single ``stone golem's rock line`` in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of rock lines, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 
### || Quen ||
- Causes giant ``Leshen roots`` to erupt in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of roots, the second increasing to three, and the third increasing to five.
  - Resets back to one after the third rend. 
### || Yrden ||
- Releasss a single ``cloud giant's shockwave`` in front of the player on first cast, knocking down and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of shockwaves, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 5. PARRY SKILLS
### || Igni ||
```W key + Parry/Counterattack``` = Counter-swing
### || Aard ||
```W key + Parry/Counterattack``` = Bruxa biting attack
### || Quen ||
```W key + Parry/Counterattack``` = Olgierd's pocket sand
### || Yrden ||
```W key + Parry/Counterattack``` = Single target lightning
### || Axii ||
```W key + Parry/Counterattack``` = Stab/Kick-swing
### || Any Sign ||
``` W key + Doubletap Parry/Counterattack``` = Kick

```A key + Parry/Counterattack ``` = Push

``` D key + Parry/Counterattack``` = Punch

### || Vampire Claws ||
```W key + Parry/Counterattack``` = Bruxa biting attack

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 6. TAUNT SYSTEM
```Switching weapons (signs, default is mouse-wheel on PC)``` while ```standing still``` with no movement keys held ```(WASD)``` will perform a taunt. 
- Taunts change based on what weapon is held. 
- Enemies in a ```10 meter radius``` around the player will be taunted.
- After 0.5 seconds, enemies will be taunted one by one in 0.5 second intervals, increasing their ```moral, stamina, and focus```. 
- Enemies will increase their speed anywhere from ```25% to 75%```. 
- This is marked when they stagger and play the ```demonic possession effect``` (black swirling effect around their heads). 
- They will also receive a small ```health regen``` amongst other things. 
- Only the first taunt will ```stagger``` enemies.
- Subsequent taunts on a taunted enemy will only replenish their ```morale, focus, and stamina```.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 7. MOVEMENT SYSTEM
### || Bruxa Dash ||
```Doubletap Sprint```
- Dashes a fixed distance forward, alternating a little bit left or right.
- Bruxa dash serves as a ``reset button`` to many things. Use it to dash out of ``wraith mode``, ``bruxa bite``, or generally anything you might encounter. 
- Bruxa dash while in exploration will dash further than dashing in combat. 
- Bruxa dash distance is reduced while the player is interior.
### || Wraith Mode ||
```Witcher sense + Sprint```
- Can only be used out of combat.
- Enables the player to ignore collision, phase through walls, and fly through the air.
- Hold the jump button to fly directly upwards.
- Don't use this to fly out of locations during certain quests. May break a few quest triggers that will prevent you from progressing the game. 
### || Bruxa Leap Attack ||
```W key + Doubletap Sprint```
- Can only be used in combat.
- Leaps at your targeted enemy, dealing damage.
- Bruxa leap attack is capable of targeting airborn enemies.
- Leaping from the air onto enemies will send out a ``shockwave around the enemy``, erupting ``stone pillars`` and blasting enemies back in a 6-meter radius around the player.
- Leaping from the air onto enemies during certain ``rainy weather conditions`` will additionally call down ``lighting strikes`` upon enemies, and leave an ``electrical field`` that burns enemies in a 6-meter radius around the player.
### || Bruxa Dodge Slide ||
```S key + Dodge```
- Can only be used in combat.
- Slides the player back a fixed distance away from the targeted enemy.
- Replaced with a different type of dodge when on cooldown.
### || Wild Hunt Blink ||
```S key + Roll```
- Eredin's short range teleport.
- Can only be used in combat.
- Teleports the player behind your targeted enemy. 
- Wild Hunt Blink will occasionally freeze enemies based on timing and chance.
- Don't use this while near the edge of a terrain. Might teleport you somewhere you don't want to be.
### || Bruxa Dodges ||
```Doubletap S key``` = Bruxa dodge back center

```Doubletap A key``` = Bruxa dodge back left

```Doubletap D key``` = Bruxa dodge back right

- Nothing really to say about these. Dodge like a vampire.
### || Regular Dodges ||
The player's regular dodges have special effects and apply negative buffs on enemies.
- Negative buffs do not stack on themselves, but will stack on each other.
#### - Igni
- Small chance to applying burning.
#### - Axii
- Small chance to apply slowdown freeze.
#### - Quen
- Small chance to cause confusion.
#### - Aard
- Small chance to cause bleeding.
#### - Yrden
- Small chance to cause paralysis.
 
 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 8. SPECIAL ABILITIES
### || Axii Shield ||
Holding down the ```Parry/Counterattack button``` while holding the Axii primary weapon will grant the player a shield. Default shield is Imlerith's shield. The shield can be changed by going into ACS_Shield.ws and following instructions. 
- Axii shield blocks most enemy attacks, but blows from big monsters, such as fiends, will still go through, though the damage is reduced, and will also not knock the player down. 
- Attack animations change into 1-hand style while Axii shield is held. 

### || Aspect of the Hym ||
Double-tapping and holding down ```Parry/Counterattack``` while holding the Axii primary weapon will summon a hym around the player. Release `Parry/Counterattack` to dismiss the hym. 
- The hym can only be summoned in ```darkness``` (10PM to 2AM) or if the player is in a ```dark place``` (caves etc.)
- An offering of ```30%``` of the player's current health must be given to the hym in order to summon it each time. If you ever hear whisperings in your ear, telling you that you can keep dismissing the hym and resummoning it to infinitely decrease your own health but not kill you, you may heed it. Only if you're into that sort of thing though. I don't judge. This pleases the hym, and you'd like that, wouldn't you?
- While the hym is active, all of the player's attacks gain ```extra range```. 

### || Bruxa camouflage ||
 ```Double-tapping and holding down Parry/Counterattack``` while vampire claws are equipped triggers Bruxa camouflage.
   - 5% current health is continuously drained while camouflage is active. 
   - Enemies close to the player will notice the player, while enemies farther away will not. 
   - The lower the enemy's health is, the greater their fear, which will be reflected in their reaction towards the camouflaged player. 
   - Only works on humans. Monsters behave normally. 

### || Bruxa bite ||
```Double tap W``` while locked on a target will perform a bruxa bite attack. It's that thing where bruxae jump on Geralt and suck his blood. 
- Bruxa bite deals ```200 flat damage``` and returns this value to the player as ```health```.
- ```Doubletap sprint``` to release victim.
### || Hijack ||
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
- ***Best if paired with a camera mod that centers Geralt during combat. I didn't write one for this yet.***
### || Caretaker Shades ||
```S + Double tap Parry/Counterattack``` will summon Caretaker shades around the player in a wide radius. 
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
```S Key + Parry/Counterattack``` while ```hard locked``` on a target (default key Z) at ```close range``` will cause the player to channel a fraction of the power of the Toad, vomiting on all enemies in a small area in front of the player.
- Can only be used while the player is on the ```ground```.
- Toad vomit deals current health percentage damage as ```poison damage```, but ```executes``` the enemy at a certain health threshold.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Aspect of the Djinn (Single Target) ||
```S Key + Parry/Counterattack``` while ```hard locked``` on a target (default key Z) at ```medium to long range``` will cause the player to channel a fraction of the power of a djinn and shoot a beam of lightning at the target.
- Can only be used while the player is on the``` ground```.
- Extra targets at close range and close to the beam of lightning will be hit.
- Djinn lightning deals current health percentage damage as ```direct damage```, but ```executes``` the enemy at a certain health threshold. 
- Targets have a small chance to burn.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Aspect of the Djinn (Multi Target) ||
```S Key + Parry/Counterattack``` while ```hard locked``` on a target (default key Z) at ```medium to long range``` will cause the player to channel more of the power of a djinn and shoot beams of lightning at the ```five``` closest targets to the player.
- Can only be used while the player is in the ```air```.
- Djinn lightning deals current health percentage damage as ```direct damage```, but ```executes``` the enemy at a certain health threshold. 
- Targets have a small chance to burn.
- Damage is capable of generating critical hits, based on player's critical hit chance.

### || Summoned Wolves ||
Double-tapping and holding down ```Parry/Counterattack``` while holding the Quen primary weapon will summon three wolves around the enemy. Release ```Parry/Counterattack``` to dismiss the wolves. 

### || Summoned Shadow Centipedes ||
Double-tapping and holding down ```Parry/Counterattack``` while holding the Quen primary weapon while the player is below ```50%``` health will summon three shadow centipedes around the enemy. Release ```Parry/Counterattack``` to dismiss the centipedes. 

### || Phantom Swords ||
```S + Parry/Counterattack``` while in combat and not hard locked to enemy summons five phantom swords. 
- First cast summons the swords, second cast fires the swords. 
- Swords cost 25% current health to summon.
- Sword damage is literally the player's light attacks. This means landing all five swords on the enemy = five light attacks at once. 
- This also means that it can be comboed with other attacks through the elemental combo system. 
- Swords destroy shields.
- Swords will disarm an opponent if they happen to hit their weapon hand. 

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 9. USING CUSTOM WEAPONS FROM VANILLA GAME OR OTHER MODS
- Open ```mod_ACS/content/scripts/local/ACS_Primary_Weapon_Switch.ws``` or ```mod_ACS/content/scripts/local/ACS_Secondary_Weapon_Switch.ws```.
- Do your best.

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 10. COOLDOWN ADJUSTMENT
- Open ```mod_ACS/content/scripts/local/ACS_Cooldown_Settings.ws```and follow instructions to further customize cooldowns to your liking. 

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 11. COMPATIBILITY
- Disclaimer: I don't use this version personally.
- Ghost mode merges fine.
- Not sure about EE.
- Magic Spells has a few incompatibilities, like weapon buffs. This requires adding code to scripts within Magic Spells to fix this. 

 <div align="right">
  
##### [Return to Index](#index)
  
  </div>
  
## 12. Q&A
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
  
## 13. CONTACT ME
- Don't. If you really have to, find me in the Wolven Workshop discord server. I may or may not reply.

 <div align="center">

# Please do not upload this mod anywhere else without my explicit permission.
  
##### [Return to Index](#index)
  
  </div>
