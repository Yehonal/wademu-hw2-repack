####################################################################################################################################
 Honor System by Spirit
####################################################################################################################################

Latest updates can be found on CatVir's forum: http://catvir.mooo.com/


	*********************************
	*** INSTALLATION INSTRUCTIONS ***
	*********************************

Installation instructions:

- Copy everything from the included "www" directory.

- Copy everything from the included "scripts" directory.

- Open your "creatures.scp" and add this at the beginning:

	#include scripts/creatures_honor.scp

- Open your "areatriggers.scp". You need "script=Honor" for the following entries: 2527, 2530, 2532, 2534

- Open your "emu.conf" or "addons.conf" and add this (*** IMPORTANT *** leave an empty line at the very end of the file *** IMPORTANT ***):

[client_addon SpiritHonor]
enabled=1
crc=0EDBA10C1
pub=2V7+2WPUz2Bqg/bwjzsay5MCcNcG9oHSEGzyQDKDBzi2lubhSX3Y80tXDy1ukmOXIr429d4/ar5xtIFLRFj/dF0gKjgHVuVCXsyZ3xJYzdjq3Eavy9YsPd/6Y9HVh5MwGaU2JZ6OuBVUD6VqjApyMeAVshDinoJWOT/B4JWQAsbZlSL0nYn9RhZTgwImJBLUsbCY4oPdzqEsu19vM655hHYuVEaoGItsWh0PwHv0fNpKSW7wYApqCNivaAwbdHkktQIaCzqgJwIN6SAlW9IXkc5PXoGAiw+gi6fiSGT/EoRHIF0FmbyL9toYtMCccdggeUGqVJG9rJEWA8dAm/f86w==

  You need to install the addon to have notifications and information about honor in the character and inspect tab.
  You should redistribute the addon to your players (SpiritHonor.zip)
  You also need to enable Chronos (download page for Chronos: http://www.curse-gaming.com/mod.php?addid=594)
  Addons are to be installed in your client WoW directory: (...)\World of Warcraft\Interface\AddOns\

- Apply "spell-patch.txt" to your spell.dbc with DBC-Patcher.

- Make sure your maps are correctly extracted.

- There is a "languages" directory where you can find translations for several languages.
  Just add or replace the needed files and modify the "language" variable in scripts.conf accordingly.

- Honor data can be stored either in a directory or in a SQL database (SQLite, MySQL, etc.)
  In the case of the directory, you can disable the "use_sqldb" option.
  In the case of SQL, you need to download and install the latest version of SQLdb from CatVir's forum.


	****************************
	*** SOME IMPORTANT NOTES ***
	****************************

- You need to spawn the Honoc NPCs if you don't have them in your world.save file.
  Hall of Champions (Alliance): Spawn creatures 40100 to 40113
  Rank 1 to 5 outside (40100 to 40104), and rank 6 to 14 inside (40105 to 40113).
  Hall of Legends (Horde): Likewise, Spawn creatures 40200 to 40213.
  Use them instead of the original vendors.

- This honor system remains external. That means the emu side honor rank check will not work for some items (especially mounts).
  You can fix that by disabling the "pvprankreq" fields in items.scp.
  Using a text editor, just replace all occurences of "pvprankreq=" to "//pvprankreq=" (that way, it will be easy if you want to revert).
  You will need to delete your WDB directory for the changes to take effect.

- You may edit your racial leaders (damage, maxhealth), or they'll die too easily (creatures 4949, 3057, 10181, 1748, 2784, 3516).
  Increase their respawn time so they don't get chainkilled. Using melee spell casting for mobs and anti-root scripts is also a good idea.

- You should use a "classes.scp" with blizzlike health and mana.
  If your players have too much health, pvp battles will take forever and flag carriers will be unstoppable.

- Honor gain is calculated according to your level/rank and your victim's level/rank.
  You gain no honor for killing a player or an NPC if your level is much higher (when your victim's level is displayed in grey color).
  You gain no honor if you are dead or if you are too far from the victim.

- When you kill a player, honor is shared based on the amount of hits. If a mob is helping you kill a player, you have less share.
  For racial leaders or guards, it is always shared equally, but level difference calculations still apply.

- If you modify the configuration file while the server is running, you can load the new settings by typing ".honor reload".
  Note that some options can't be reloaded that way and you need ".retcl".

- Type .honor help for information about the command usage.


	************************
	*** ABOUT LOAD ORDER ***
	************************

The general rule is to load scripts in the following order:
1) Everything under WoWEmu, AI and SpellEffects (AI.tcl, Commands.tcl, etc.)
2) Custom.tcl
3) All other tcl/tbc scripts

The recommended way to deal with load order is to use the "Start-TCL Startup System", available on CatVir's forum.
As an alternative, you can try adding "-" (load first), or "_" (load last) as the first character to filenames.


	**********************
	*** HOW TO UPGRADE ***
	**********************

Use the upgrade instructions below if you want to check your installation or if you are having problems.
A general rule however is to make sure you have no duplicate or unneeded files, especially if files have been renamed or removed.


 *** Upgrade from versions before v3.90 ***

Search your tcl files for lines containing "Honor::" or "Warsong::" and remove them all.

In startup.tcl, remove:

(In proc WoWEmu::CalcXP)
	if { [Honor::IsRacialLeader $victim] } { Honor::RacialLeaderKilled $killer $victim
	} elseif { [Honor::IsCivilian $killer $victim] } { Honor::DishonorableKill $killer }

(In proc WoWEmu::DamageReduction)
	Honor::HitCount $player $mob

(In proc WoWEmu::OnPlayerDeath)
	Warsong::OnPlayerDeath $player $killer
	Honor::CalcRatings $player $killer

(In proc WoWEmu::OnPlayerResurrect)
	Warsong::OnPlayerResurrect $player

(In proc SpellEffects::SPELL_EFFECT_TELEPORT_UNITS)
	Warsong::OnPlayerTP $to $from $spellid

In startup.tcl or AI.tcl, remove:

(In proc AI::CanUnAgro)
	if { [Honor::IsRacialLeader $npc] } { Honor::RacialLeaderDetect $npc $victim }

If you have a really messed up installation, you may rather start from the original WoWEmu scripts or other repacks known to work.


	*** Upgrade from other Honor Systems ***

Remove any code/file from other honor systems/warsong battleground scripts in startup.tcl, AI.tcl and Commands.tcl.

Files you should delete, as they can conflict (this list may be not exhaustive):
HonorHall.tcl
HonorNPC.tcl
E2BF.tcl
E2BM1.tcl
E2BM2.tcl
E2RF.tcl
Event2.tcl


	***************************************
	*** SOME SERVER OPTIMIZATION TRICKS ***
	***************************************

- Use simple and fast AI::CanAgro/CanUnAgro and WoWEmu::DamageReduction procedures. T
  Those are the most called by the emu, so their lack of optimization can have a critical impact on performance.

- Use a small world.save, or at least one with not too many spawns in the same areas.

- If you have many players (100+), try increasing sleep timings.
  Example (you may try smaller or higher values):
    world_sleep_ms=750
    network_sleep_ms=200

- Use loglevel=2 (or higher) to have less information displayed in the console window. That reduces cpu usage.

- You can disable pp system with .ppoff, or you could try turning on pploadoff and ppoff, but that can cause problems.
