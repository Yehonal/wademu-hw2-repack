DBC Tool
--------

just a small tool i wrote to examine the wow client db files.

backup your DBCTool_fielddefs.ini if you defined you own definition!
the included ini is for wowclient 1.4.0

field definitions you have done are saved to "DBCTool_fielddefs.ini". please post
your ini's at the link below, so i can include your settings in future releases:

	http://www.blizzhackers.com/viewtopic.php?t=280437

changelog

v0.5b
-----
- the area and overlay names are used for the map functions (instead of
  the internal names)
- clicking on an overlay blends it in/out
- you can load the minimap as a layer for a wmo. pretty cool since im
  using the alphabits from the overlays itself (doent discard the whole
  background). the layer is "under" the overlays, so you can blend them
  in over the minimap. the slider is for the masteralpha
- now all entries from map.dbc are loadable in the map window (but not all
  maps have minimaps)
- coordinates in map window
- its possible to load only an area from a map (eg. kalimdor/teldrasil)
- mousewheel zooms and dragging

v0.5a
-----
- fixed the wmo tilebug and removed a nasty memleak
- added coordinate display on mousemove
- added another map window (minimap)

v0.5
----
- dropped opengl displaymode, using blp2decode.dll and gdi now
- added singed integer column types
- changed binary column type to binary32, binary24, binary16, binary8, binary4
  and a small binary length autodetection routine (a few definitions of these
  new types are included
- small value stats per column, can help determine what info the column holds
- hint display on grid. header=type, lookup cell=lookup value
- non found lookup values are displayed a bit smarter
- mpq container column in stat page
- played around with wmo's, check sandbox menu. some maps are not displayed
  correcty, does anyone have info on how the tiles should be arranged?
- small improvements and bugfixes i forgot about

v0.4
----
- treeview instead of tabflood
- stat page when selecting the treeview's root entry
- unloading of files (contextmenu)
- new grid (dont ask about the performace :( )
- sort by column (asc/desc)
- fix 1st column
- find dialog for whole grid/row/column
- lookup search by column!
- included a nice fielddefs ini for wowclient 1.4.0 (spell.dbc fields moved)
- tons of bugfixes

v0.3
----
- blp preview
- small interface improvements like autoloading
- lot of bugfixes and better error handling (spellmechanic.dbc from 1.4.0 is in
  mpqlistfile but not present itself?)

v0.2
----
- dbc's can now be read directly out of mpq files (with support for patch.mpq)
- wow file mode, read mpq path from registry
- small interface cleanup. contextmenu holds only columnbased functions
- detect column types/csv export possible for all loaded dbc's
- auto columntitle on lookup
- no lookuptext if lookup value=0 and lookup id not found
- doubleclick cell copies value to clipboard
- binary string fixed and truncated (bytewise)
- included a few fielddefs (check the faction, area/map and taxi tabs)
- some minor bugfixes, maybe even some new functions... but cant remember ;)

regards,
noisehole