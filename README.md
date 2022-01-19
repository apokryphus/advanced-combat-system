# advanced-combat-system
Combat overhaul mod for The Witcher 3. 

Enables the player to use a wide variety of NPC animations and abilities, both in and out of combat.

<p align="center">
<a href="http://www.youtube.com/watch?feature=player_embedded&v=Puc5b5c0lWc
" target="_blank"><img src="http://img.youtube.com/vi/Puc5b5c0lWc/0.jpg" 
alt="ADVANCED COMBAT SYSTEM" width="640" height="360" border="10" /></a>
  </p>
 <p align="center">
  Video showcasing a previous version of the mod.
 </p>
 
## INSTALLATION
- Latest version can be found in [releases](https://github.com/apokryphus/advanced-combat-system/releases).
- Download zip from latest version.
- Place ```dlcACS``` in dlc folder.
- Place ```mod_ACS``` and ```mod_ACS_Effects``` in mods folder. 
- ***Run script merger.***

### mod_ACS_Effects is OPTIONAL. Mod works without it, but some attacks/abilities won't have effects to them.
- It replaces player.w2ent, and this version does not come with compatibility edits for stuff like ```E3 Quen```.
- If you do use it, remember to set priority for it over other mods. 
### Compatibility edits will not be publicly released.
- Ask me for the compatibility version for E3 Quen if you want it.
### mod_ACS_JumpExtend is also optional. It increases the player's jump height by about 15 meters. 
- Jumping while sprinting will jump further and higher than jumping while idle. 
- Jumping while sliding will jump the furthest. 
- Don't put this in your mods folder if you don't have a custom camera mod like immersive cam since I didn't write one for this yet. 
- Or do, if you enjoy watching Geralt fly off screen every time he jumps. Who am I to tell you how to play this game?

<div align="center">

# INDEX

### [1. FISTS](#1-fists-1)
### [2. ARMED](#2-armed-1)
### [3. ELEMENTAL COMBO SYSTEM](#3-elemental-combo-system-1)
### [4. ELEMENTAL REND SYSTEM](#4-elemental-rend-system-1)
### [5. GUARD SKILLS](#5-guard-skills-1)
### [6. TAUNT SYSTEM](#6-taunt-system-1)
### [7. MOVEMENT SYSTEM](#7-movement-system-1)
### [8. SPECIAL ABILITIES](#8-special-abilities-1)
### [9. USING CUSTOM WEAPONS FROM VANILLA GAME OR OTHER MODS](#9-using-custom-weapons-from-vanilla-game-or-other-mods-1)
### [10. COOLDOWN ADJUSTMENT](#10-cooldown-adjustment-1)
### [11. COMPATIBILITY](#11-compatibility-1)
### [12. CONTACT ME](#12-contact-me-1)
</div>

## 1. FISTS
- Completely replaced by vampire claw attacks, regardless of sign.
## 2. ARMED
Selecting different signs while holding a weapon will change Geralt's moveset and grant him different weapons, depending on selected sign. 
- Light attacks switch to ```primary weapons```.
- Heavy attacks switch to ```secondary weapons```.
### Default Weapons
Default weapons included within ACS are split between silver and steel versions, based on whether equipped weapon is silver or steel. 
- Weapons ```evolve``` according to equipped weapon's level and rarity.
- Igni sign shows actual/real weapon equipped.
#### Weapon Tier System
- **Level 1 Weapons**
   - Weapon level 1-10 ***OR*** ``Common`` type weapons.
- **Level 2 Weapons**
   - Weapon level 11-20 ***AND*** weapon rarity above ``Common``.
- **Level 3 Weapons**
   - Weapon level 21+ ***AND*** weapon rarity equal to or above ``Relic``.
### Movesets
- All moveset damage is based on ``currently equipped weapon in inventory``. 
- Select weapons have ``increased range``. 
- Quen, Axii, Yrden, Aard each have a ``special attack``, replacing ``Whirl``. ```Requires Whirl to use```.
- Rend remains unchanged.
- ```Holding down W key```, while attacking with ``light attacks``, ``heavy attacks``, or ``special attacks`` will alter attack moveset. 
- ```Range of opponent```, will also alter attack moveset (ie. holding down W while attacking with Axii heavy attacks at close range will slap your target)
#### Igni 
- Light Attacks = **Default Geralt light attacks**
  - Heavy Attacks = **Default Geralt heavy attacks**
#### Quen
- Light Attacks = **Olgierd/1-hand-sword**
  - Heavy Attacks = **Spear/Staff**
#### Axii
- Light Attacks = **Eredin/2-hand-sword**
  - Heavy Attacks = **Gregoire de Gorgon**
#### Yrden
- Light Attacks = **Imlerith/Caranthir**
  - Heavy Attacks = **Hammer**
#### Aard
- Light Attacks = **Dettlaff/Bruxa**
  - Heavy Attacks = **Axe**
## 3. ELEMENTAL COMBO SYSTEM
``Successfully damaging an enemy`` while holding a ``primary weapon`` in a specific stance will ``prime`` the enemy for a ``detonation effect``, which will be activated upon ``successfully damaging the enemy`` with a subsequent attack while holding the ``secondary weapon``.

This works both ways for all signs except for Igni, meaning that attacks while holding the ``secondary weapon`` will also ``prime`` the enemy for a ``detonation effect``, which will be detonated upon attacking while holding the ``primary weapon``.

Enemies need to be ``primed`` again after detonating an effect.
### Igni
- Light attack/Any attack action after attacking with light attack:
  - Passive: None.
  - Primes enemy.
  - Detonation effect: None.
- Heavy attack/Any attack action after attack with heavy attack:
  - Passive: None.
  - Does not prime enemy.
  - Detonation: Detonates an ``explosion`` in a small radius, blasting enemies back and ``burning`` them. 
### Axii
- Primary weapon:
  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: Calls down ``frost orbs`` from the sky that target enemies in a small radius, dealing damage and applying a ``slowdown frost`` debuff to enemies.
- Secondary weapon:
  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: ``Freezes`` enemies in a small radius around the player.
### Aard
- Primary weapon:
  - Passive: Attacks grant ``life-steal`` equal to 5% of damage dealt.
  - Primes enemy.
  - Detonation: Attack grants ``life-steal`` equal to 50% of damage dealt, and infects enemies with ``poison`` in a small radius.
- Secondary weapon:
  - Passive: Attacks have a chance to apply ``slowdown frost``. 
  - Primes enemy.
  - Detonation: Detonates an ``explosion`` that causes ``confusion`` to enemies in a small radius.
### Quen
- Primary weapon:
  - Passive: Attacks cause ``bleeding`` and have a chance to apply ``blindness``.
  - Primes enemy.
  - Detonation: Summons a ``sand storm`` that applies ``blindness`` to enemies in a small radius.
- Secondary weapon:
  - Passive: Attacks have a chance to ``slow`` enemies.
  - Primes enemy.
  - Detonation: Summons a ``sand pillar`` that applies ``paralysis`` to enemies in a small radius.
### Yrden
- Primary weapon:
  - Passive: Attacks ``stagger`` enemies.
  - Primes enemy.
  - Detonation: Calls down ``magic missiles`` from the sky that target enemies in a small radius, dealing damage and applying a ``health drain debuff``.
- Secondary weapon:
  - Passive: Attacks apply knockdown.
  - Primes enemy.
  - Detonation: Calls down ``lightning`` and blasts enemies away in a small radius.
## 4. ELEMENTAL REND SYSTEM
Releasing rend while holding ``secondary weapons`` have addtional effects. In Igni's case, this is activated by attacking with heavy attack once, and then using rend. 
Requires the rend skill to use. 
### Igni:
- Releases a single ``Ifrit golem's fire line`` in front of the player on first cast, burning and dealing minor damage to all enemies it comes into contact. 
  - Subsequent rends increase the number of fire lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - Resets back to one after the third rend. 
### Axii:
- Releasss a single ``Eredin's ice line`` in front of the player on first cast, slowing and dealing minor damage to all enemies it comes into contact with, with a chance of freezing the enemy. 
  - Subsequent rends increase the number of ice lines, the second increasing to ``three``, and the third increasing to ``five``. 
  - The chance of freezing increases with the increase of ice lines. 
  - Resets back to one after the third rend. 
### Aard:
- Releasss a single ``stone golem's rock line`` in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of rock lines, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 
### Quen:
- Causes giant ``Leshen roots`` to erupt in front of the player on first cast, staggering and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of roots, the second increasing to three, and the third increasing to five.
  - Resets back to one after the third rend. 
### Yrden:
- Releasss a single ``cloud giant's shockwave`` in front of the player on first cast, knocking down and dealing minor damage to all enemies it comes into contact with. 
  - Subsequent rends increase the number of shockwaves, the second increasing to ``three``, and the third increasing to ``five``.
  - Resets back to one after the third rend. 
## 5. GUARD SKILLS
### Igni
```W key + Guard``` = Counter-swing
### Aard
```W key + Guard``` = Ethereal/Bruxa Shout
### Quen
```W key + Guard``` = Olgierd's pocket sand
### Yrden
```W key + Guard``` = Single target lightning
### Axii
```W key + Guard``` = Stab/Kick-swing
### Any Sign
``` W key + Doubletap Guard``` = Kick

```S key + Doubletap Guard (After using shades summon) ```= Push

``` S key + Guard``` = Punch
## 6. TAUNT SYSTEM
```Releasing guard``` or ```switching weapons (signs)``` while ```standing still``` with no movement keys held ```(WASD)``` will perform a taunt. 
- Taunts change based on what weapon is held. 
- Enemies in a ```10 meter radius``` around the player will be taunted.
- After 0.5 seconds, enemies will be taunted one by one in 0.5 second intervals, increasing their ```moral, stamina, and focus```. 
- Enemies will increase their speed anywhere from ```25% to 75%```. 
- This is marked when they stagger and play the ```demonic possession effect``` (black swirling effect around their heads). 
- They will also receive a small ```health regen``` amongst other things. 
- Only the first taunt will ```stagger``` enemies.
- Subsequent taunts on a taunted enemy will only replenish their ```morale, focus, and stamina```.
## 7. MOVEMENT SYSTEM
### Bruxa Dash
```Doubletap Sprint```
- Dashes a fixed distance forward, alternating a little bit left or right.
- Bruxa dash serves as a ``reset button`` to many things. Use it to dash out of ``wraith mode``, ``bruxa bite``, or generally anything you might encounter. 
- Bruxa dash while in exploration will dash further than dashing in combat. 
- Bruxa dash distance is reduced while the player is interior.
### Wraith Mode
```Witcher sense + Sprint```
- Can only be used out of combat.
- Enables the player to ignore collision and fly through the air.
- Don't use this to fly out of locations during certain quests. May break a few quest triggers that will prevent you from progressing the game. 
### Bruxa Leap Attack
```W key + Doubletap Sprint```
- Can only be used in combat.
- Leaps at your targeted enemy, dealing damage.
- Bruxa leap attack is capable of targeting airborn enemies.
- Leaping from the air onto enemies will send out a ``shockwave around the enemy``, erupting ``stone pillars`` and blasting enemies back in a 6-meter radius around the player.
- Leaping from the air onto enemies during certain ``rainy weather conditions`` will additionally call down ``lighting strikes`` upon enemies, and leave an ``electrical field`` that burns enemies in a 6-meter radius around the player.
### Bruxa Dodge Slide
```S key + Dodge```
- Can only be used in combat.
- Slides the player back a fixed distance away from the targeted enemy.
- Replaced with a different type of dodge when on cooldown.
### Wild Hunt Blink
```S key + Roll```
- Eredin's short range teleport.
- Can only be used in combat.
- Teleports the player behind your targeted enemy. 
- Wild Hunt Blink will occasionally freeze enemies based on timing and chance.
- Don't use this while near the edge of a terrain. Might teleport you somewhere you don't want to be.
### Bruxa Dodges
```Doubletap S key``` = Bruxa dodge back center

```Doubletap A key``` = Bruxa dodge back left

```Doubletap D key``` = Bruxa dodge back right

- Nothing really to say about these. Dodge like a vampire.
### Regular Dodges
The player's regular dodges have special effects and apply negative buffs on enemies.
- Negative buffs do not stack on themselves, but will stack on each other.
#### Igni
- Small chance to applying burning.
#### Axii
- Small chance to apply slowdown freeze.
#### Quen
- Small chance to cause confusion.
#### Aard
- Small chance to cause bleeding.
#### Yrden
- Small chance to cause paralysis.
## 8. SPECIAL ABILITIES
### Bruxa bite
```Double tap W``` while locked on a target will perform a bruxa bite attack. It's that thing where bruxae jump on Geralt and suck his blood. 
- Bruxa bite deals ```200 flat damage``` and returns this value to the player as ```health```.
- ```Doubletap sprint``` to release victim.
### Hijack:
Bruxa bite is capable of ```hijacking``` certain enemy movements.
#### Current enemy list:
- Harpies
- Siren
- Wyvern
- Dracolizard
- Gryphon
- Basilisk
- Garkain
- Shaelmaar
#### Controls:
- ```Holding down W``` while pressing ```A or D``` will nudge the creature to go either left or right. 
- ```Release W``` to nudge it forward. 
- Be aware, the creature will attempt to fight you for control. 
- ***Best if paired with a camera mod that centers Geralt during combat. I didn't write one for this yet.***
### Caretaker Shades
```S + Double tap Guard``` will summon Caretaker shades around the player in a wide radius. 
- Shades will distract enemies, as other enemies will attempt to kill them, while also provide a source of life-steal for claws. 
- Shades do not attack, and will die in one hit. 
- Shades will automatically move towards the player if player is nearby, or move towards the closest enemy.
 - Shades summoning can only be used once per combat, being replaced by a push/shove attack after being used.
- The player will summon more shades when at less than 50% health. 
- The higher the level the player is, the more shades will be summoned. 
#### Lvl 10 or less 
- 1 shade normal, 2 shades at 50% or less health.
#### Lvl 11 to 15
- 2 shades normal, 5 shades at 50% or less health.
#### Lvl 16 to 20
- 3 shades normal, 7 shades at 50% or less health.
#### Lvl 21 to 25
- 5 shades normal, 10 shades at 50% or less health.
#### Lvl 26 or more 
- 7 shades normal, 15 shades at 50% or less health.
#### Lvl 26 or more: 
- 7 shades normal, 15 shades at 50% or less health.
## 9. USING CUSTOM WEAPONS FROM VANILLA GAME OR OTHER MODS
- Open ```mod_ACS/content/scripts/local/ACS_Primary_Weapon_Switch.ws``` or ```mod_ACS/content/scripts/local/ACS_Secondary_Weapon_Switch.ws```.
- Do your best.
## 10. COOLDOWN ADJUSTMENT
- Open ```mod_ACS/content/scripts/local/ACS_Cooldown_Settings.ws```and follow instructions to further customize cooldowns to your liking. 
## 11. COMPATIBILITY
- Disclaimer: I don't use this version personally.
- Ghost mode merges fine.
- Not sure about EE.
## 12. CONTACT ME
- Don't. If you really have to, find me in the Wolven Workshop discord server. I may or may not reply.
