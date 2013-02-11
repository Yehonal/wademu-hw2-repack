####################################################################################################################################
 Defense System by Spirit
####################################################################################################################################

The "Defense System" allows players to be defended by guards and npcs/mobs to be defended by their friends (chain aggro).
In the case of defending players, one click mode and two auto modes are availabe:

"player_defense=1", players have to click on the guards each time they want assistance. This mode is very light for the server.

"player_defense=2" or "player_defense=3", no clicking needed, but more cpu intensive.
The more guards you have in the same location, the higher is the load on the cpu.
Mode 2 is faster than mode 3, but is approximative when evaluating distances, and doesn't work with player_reputation/switch_aggro.
To properly set up this mode, you have to carefull follow these instructions:

- Set "player_defense=2" (or 3) in "scripts.conf" under the "Defense" section.

- Auto mode requires a quest system. You can either use MasterScript or Neo2003's TCLPack.
  For MasterScript, it has to be loaded before the Honor System.

- Convert all your guards with the command ".defense generate full". A file called "creatures_corrected_guards.scp" will be generated,
  The generated file is sorted by sections, and all entries from #include directives are merged.
  You can then just replace your "creatures.scp" with the corrected one and ".rescp". You may want to backup your original file.
  If you just want to know what guards need correction, omit the "full" option (".defense generate"). The generated file will then only
  contain the corrected guards. If you don't want to merge all your creatures in one file, use ".defense generate noinclude",
  and add back your include lines in the generated file.

- Your guards need to be respawned for the change to take effect. A quick way to do that is to ".cleanup" then ".respawnall".



