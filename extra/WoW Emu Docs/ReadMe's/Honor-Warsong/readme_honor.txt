####################################################################################################################################
 Honor System by Spirit
####################################################################################################################################

Installation instructions:

- Copy everything from the included "www" directory.

- Copy everything from the included "scripts" directory.

- Open your "creatures.scp" and add this at the beginning:

	#include scripts/creatures_honor.scp

- Open your "areatriggers.scp". You need "script=Honor" for the following entries: 2527, 2530, 2532, 2534

- Open your "emu.conf" and add this (*** IMPORTANT *** leave an empty line at the very end of the file *** IMPORTANT ***):

	[client_addon SpiritHonor]
	enabled=1

  You need to install the addon to have notifications and information in the honor tab.
  You should redistribute the addon to your players (SpiritHonor.zip)
  You also need to enable Chronos (download page for Chronos: http://www.curse-gaming.com/mod.php?addid=594)
  Addons are to be installed in your client WoW directory: (...)\World of Warcraft\Interface\AddOns\

- There is a "languages" directory where you can find translations for several languages.
  Just add or replace the needed files and modify the "language" variable in scripts.conf accordingly.


Some notes:

- You may edit your racial leaders (damage, maxhealth), or they'll die too easily (creatures 4949, 3057, 10181, 1748, 2784, 3516).
  Also increase their respawn time so they don't get chainkilled.

- Diminishing return on consecutive kills is managed in memory, so if you do a .retcl or reboot the server, it is reseted.

- No world.save file is included, so you need to go in game and add spawns for Honoc NPCs
  in the Hall of Champions (creatures 40100 to 40113), and in the Hall of Legends (40200 to 40213).
  Or you could use a world.save with spawned Honor NPCs, like NuRRi's Final World V2.0

- Honor NPCs have a blue question mark over their head if you have the sufficient rank to buy their goods
  (may not show up immediately if you get a new rank while you are next to them).

- When you kill a player, honor is shared based on the amount of hits. If a mob is helping you kill a player, you have less share.
  For racial leaders or guards, it is always shared equally.

- You gain no honor if you are too far from the victim or dead.

- Type .honor help for information on the command usage.

- If you modify the configuration file while the server is running, you can load the new settings by typing ".honor reload".
  Note that some options can't be reloaded that way and you need ".retcl".

- This honor system remains external. That means the emu side honor rank check will not work for some items (especially mounts).
  You can fix this by disabling the "pvprankreq" fields in items.scp.
  Using a text editor, just replace all occurences of "pvprankreq=" to "//pvprankreq=" (that way, it will be easy if you want to revert).
  You will need to delete your WDB directory for the change to take effect.

- You should use a "classes.scp" with blizzlike health and mana.
  If your players have too much health, pvp battles will take forever and flag carriers will be unstoppable.

- During a fight, if your player opponent uses the log off exploit to have full health, type ".honor check" while he's reconnecting.
  The script will check whether your opponent is using the exploit, and if verified, he will commit suicide.
  This only works if you damaged him.


Latest updates can be found here: http://catvir.wgc-eden.com/phpBB2/viewtopic.php?t=98
