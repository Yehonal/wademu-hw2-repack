####################################################################################################################################
 Defense System by Spirit
####################################################################################################################################

The "Defense System" allows players to be defended by guards and npcs/mobs to be defended by their friends (chain aggro).
In the case of defending a player, two modes are availabe:

"player_defense=1", players have to click on the guards each time they want assistance. This mode is very light for the server.

"player_defense=2", no clicking needed, but more cpu intensive.
The more guards you have in the same location, the higher is the load on the cpu.
To properly set up this mode, you have to carefull follow these instructions:

- Set "player_defense=2" in "scripts.conf" under the "Defense" section.

- You can use either MasterScript or Neo2003's TCLPack from v0.80. For MasterScript, it should be loaded before the Honor System.

- Convert all your guards with the command ".defense generate full". A file called "creatures_corrected_guards.scp" will be generated,
  The generated file is sorted by entries, and all entries from #include directives are merged.
  You can then just replace your "creatures.scp" with the corrected one and ".rescp". You may want to backup your original file.
  If you just want to know what guards need correction, omit the "full" option (".defense generate"). The generated file will then only
  contain the corrected guards. If you don't want to merge all your creatures in one file, use ".defense generate noinclude",
  and add back your include lines in the generated file.

- Your guards need to be respawned for the change to take effect. A quick way to do that is to ".cleanup" then ".respawnall".



