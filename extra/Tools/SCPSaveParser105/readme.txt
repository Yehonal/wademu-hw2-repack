SCP Save Parser

Note given the nature of this program, that it attempts to be able to everything you'd want, bug fixes are frequent! This isn't intended to be Noob friendly, but as I find ways to make this app work for people i post my findings here.

Consider this app the Swiss Army Knife of SCP/SAVE editing. Ugly, lots of things not entirely understood, but dam useful!

Current Version: 11
Download

DOWNLOAD NOW!

Now with a slightly more friendly inteface. Turn the hints on under the settings menu item.

CODE

Last "Stable" Version 9.13.0

Download:
http://filebeam.com/02c5e6e2e36b7de9adb18f5ae6d0f01f


Support:
[Support] SCP Save Parser

Application that parses SCP and Saves.

    * Can Split SCP by up to three criteria and can do partial matches. And by at specific elements.
    * Remove Entries containing a string (Can Do Specific Property Matches)
    * Replaces Occurences of value (Can Do Specific Property Matches)
    * Number Magic: Update Number Values in any SCP File
    * Apply the Number magic to specific element and also enforce a check on an element being in a list
    * Create A Formula: Update your items on a predefined formula
      - eg. for Items.scp - damage
      = damage + level - reqlevel
    * Merging!
    * Create an array, useful for formula or creating loot templates. Many uses for this
    * Use a text array for spliting and removing entries.
    * Re-Order Entries
    * Patch SCPSave Files, Load your file you want to update then under the merge options load the updated file. Select "Patch Operation" off you go. This will update and add entries to the source object from the merge object of the same ID/GUID
    * Exporting! You can specify specific fields to export - perfect for translators! Other people then just do a patch action!
    * Can rescurse through #include files.
    * Can Generate results or modified files to the same filepaths as stated in their include entries.
    * Split your results or modified files into multiple parts - perfect for the sharing the load with your team.
    * Update your creatures in world.save - health, mana, equips, model, resists
    * Tells you of orphaned spawns in your WS
    * Tells you of unspawned creatures and the number of spawned creatures in your WS
    * Respawn your Creatures
    * Navigate and Search, Easily
    * Fix VARITION in items
    * Export to TAB Delimited or CSV format. Including NULL values
    * Check References between SCP/SAVE Files are all those items listed as loot in loottemplates.scp really there? Check and found out!
    * Delete properties, either by property name or by property name and property value match. Very nice for those of you needing to remove AISCRIPT=

      Or what ever else you would want. Can also point a property to a custom defined array, useful in the case of want to substitute values of fields eg. spells



Using Number Magic is possible to change the values of any creature, item, etc. Even if the formating changes. Can specify if it's an array.

Remember the problems we had when people changed from setting mulitple values from x y to x..y - A Whole lot of tools stopped working.
So you can use to this change damages, health, prices a whole lot!

Not very Noob Friendly Yet - Probably NEVER!


Changelog:
10.5.0 to 11
Moved the Help Screen so it's a bit easier to find

Refernece Checking, set the property you wish to check eg. loot=
Load the reference file and set the reference header to [loottemplate and hey presto! Although I know RegEdit has already made an AWESOME program to do, I figured I may as well add the functionality smile.gif

Delete Properties, reverse of Add Properties. A bit more advanced.

Fixed some progress bar glitches


10.4.0 to 10.5.0
The Export feature would make bogus data if the property count was higher than the entry list count.
Added limited help, under the about button.

10.3.0 to 10.4.0
Now with extended exporting options, export your SCP and SAVES to CSV or Tab Delimited Format and import them into a MySQL Database (for use with Luddy and Mangos).

    * To Export to Tab Delimited format:
    * Open File and Parse
    * Click on "Export / Create Array"
    * Set the Export Type to "Select Specific Properties"
    * Check "Include NULL Outputs"
    * Check "Include Values From Property..." (checked by default)
    * Click the "ALL" Button
    * Check "TAB Delimited"
    * Click "Create Array"

10.0.0 to 10.3.0
Added the fixed variations under 'Do Stuff' -> Items Tab
Look in the menu bar for a cool Navigation feature, allows you easily add, delete, view, edit and find individual entries.

9.15.0 to 10.0.0
World Spawn Operations now work properly - CAUTION for advanced users only
Unlock your WS and spawn something, anything. This is so that the Last GUID in your WS doesn't clash with another GUID in the EMU. Save and do the world respawn option

Navigate! Parse your file and select Navigate from the menu bar.

9.14.0 to 9.15.0
Added Insert Option Allows you to add a property to all the objects in your result set eg.
spell=16722 1 0 -1 0 -1

World Respawn Option still experimental

9.13.0 to 9.14.0
Added the Creature Respawn Option - Careful!
Hopefully fixed the errors like '-2132.4334 232131 is not an integer'

9.12.0 to 9.13.0
Check and correct bogus properties eg. n?me= when parsing
Split into separate files on a property (under the split tab)
eg. create induvidual files for all creatures that belong to a faction (faction=)

9.11.0 to 9.12.0
Fixed an error when doing number magic and specify an element to match -fixed thanks to commykipp for his patience smile.gif
Added an option when splitting to ignore any // comments. Effectively the comments will be ignored when comparing.

9.10.0 to 9.11.0
Added the "Element must be in list" option for Number Magic
Added "Find"

9.9.0 to 9.10.0
Added some counting options when updating the WS

9.7.0 to 9.9.0
Added the search for specific element when splitting by properties eg.
looking for all quests where you have to kill kobold vermin [Creature 6]
Split by Property KILL=
Criteria 6 no partial matches or use a list
check the option "Only Check Element number" and 1 in this case
kill=6 10 -- kill 10 Kobold Vermin

Added the Randomisation of Models to NPC World.Save Update where in creatures.scp you've got
MODEL=100,101,103
The updated NPCs of that entry will randomly have one of those models - eg. the guards


9.4.0 to 9.7.0
World.Save Update - fixes and improvements. When updating NPC entries the properties are now listed in the exact order the Emu expects them in - Thanks to Damian for the assist.

9.3.0 to 9.4.0
World.Save Update -BETA
Fixed a bug with simple math - thanks to commykipp

9.2.3 to 9.3.0
A lot of BugFixes!

Able to now when doing "Number Magic" on a property that is an array of more than 1 number you can now specify to only update a certain element in the array. Handy when wanting to update loottempletes eg.
loot=23300 0.200
As you dont want to change the item, just the drop chance - so set the number to "only process the 2 number in the array"


9.2.2 to 9.2.3
Fixed a bug with splitting by specifc criteria and property when the property was a header eg. [quest
9.2.1 to 9.2.2

Fixed incorrect positive matches when evaluating a string as a header eg.
[Quest and QuestFlags

9.2.0 to 9.2.1
Fixed some *$%! crazy ###### stupid logic in the Patch Merge function - sorry about that
Added the "Add Properties - Not Replace" Option when Patching. when getting a patch entry, it will add the properties to the source item. No updating of previous properties.

eg.

Source:
[item 10000]
Coolness=1000
Money=202

Patch:
[item 10000]
Monkey=501
Monkey=23

With "Add Properties - Not Replace" you'll get:
[item 10000]
Coolness=1000
Money=202
Monkey=501
Monkey=23

I will need to add a remove properties from Item routine.

9.1.0 to 9.2.0
Option to Include #include
Splitting your Matching Results / Modified into multiple files perfect for sharing updates and corrections amoungest your team.

9.0.0 to 9.1.0
Exporting! Also Extended Array creation to support multiple fields exporting

8.1.4 to 9.0.0
Version Numbers are screwed anyhow
Patch SCPSave Files, Load your file you want to update then under the merge options load the updated file. Select "Patch Operation" off you go. This will update and add entries to the source object from the merge object of the same ID/GUID.
When Selecting properies click the "All" button and all properties found the file are added to the list. Much easier than typing them out. - Thanks blackaxe744

8.1.3 to 8.1.4
Added Re-order Functions
Added a XYZ threshold when checking World.Save for Dupes. If two spawners/spawns have the same entry and are within a certain distance of another, it will be considered a Dupe.

8.1.2 to 8.1.3
Fixed a bug with partial matches when splitting and using a list

8.1.0 to 8.1.2
Fixed a bug with split by list and using more than one criteria

8.0.0 to 8.1.0
Minor Bugfixes
Optimised some comparison code

7.1.0 to 8.0.0
Mergining
Inteface Changes
Extended the Select/Remove Entries functions

7.0.0 to 7.1.0
Fixed an error with simple maths, updating already updated array elements
Fixed the progress display for simple maths

6.00 to 7.00
Added Formula
Extended the Remove/Replace Function

5.00 to 6.00
Added: Do Stuff
Number Magic

4.00 to 5.00
Improved the Speed, it's now really fast!


--------------------------------------------------------------------
Usage Examples
--------------------------------------------------------------------

Use:
Parse the Items.scp to find all weapons.

Object Header:
[item

Criteria:
Class=2

This outputs two files:

items.output (these are the matching items)
items.modified (this is a copy of the original file without the matching entries)

-----------------------------------------------------------

Use: Parse World.Save to Update SpawnTimes

1 ) Fire up the tool!
Load SCP/Save

2 ) Set the Header to:
[OBJECT]

3 ) Then Click:
Process

4 ) Once it's done processing, you can then split the file (to remove any unwanted entries) but I assume you want to keep all your current entries.

Click:
Process

5 ) Now we are going to Do Stuff in particular we want to do some Number Magic so click the tick box.

6 ) Set the Property Header to:
SPAWNTIME

7 ) Set It is An Array of:[b] 2 Numbers
Separated by a [b][SPACE] (inputted by default)

8 ) Set any other rounding options (which I would recommend in this case to round to whole numbers)

9 ) Now you can either do a Simple Maths Operation.
eg: Add 30 Seconds to all Spawns

check Do Maths and + by Amount 30

or

You can use the formula builder which is more work, but a better idea. As you can setup an array to update the spawntime based on the [OBJECT] property Entry.

---------------------------------------------------------
Cleaning Up World.Save

   1. Load Your World.Save
   2. Set the Header to [OBJECT] and Process
   3. Make sure create modified file is checked and set the criteria for split is SPAWN and allow partial matches.
   4. Process
   5. You'll then be prompted to save the remainder (containing at the point all spawned creatures/object and no spawn points)
   6. Then Process Again To Save your Output (SpawnPoints)
   7. Re-open the app
   8. Load the Modified File (the one with the spawned creatures/objects)
   9. Now your split criteria will be LINK (allowing partial matches) as we have removed all spawnpoints and this criteria will remove all creatures and objects that have a spawnpoint
  10. In other words the result file, will be all the creatures/objects without a spawnpoint!
  11. You won't need to create a modified filem so process
  12. Then Process Again to get your results saved
  13. At this point, backup your world.save and take your last results and load that as your world.save
  14. Go to each of those parentless critters, destroy them and add a spawner to spawn a new instance that has a parent
  15. Now open your new world.save and the first results (the one with only the spawners) and add them together - to make New New World.Save
  16. Load into your new new world.save and .RespawnAll you may have to visit each area to force the emu to update
  17. But then you'll have cleaned up world.save
  18. Well as clean as they get

---------------------------------------------------------

Merging World Saves:

Note
VERY IMPORTANT
Merging saves is only recommended if you wish to populate spawns in an area that isn't presently populated in your save. Additionally I recommended only merging saves that are based on the same world.save. Reason being:
in Bobs World Save, marshall mc bride is spawned inside northsire abbey
in Joes World Save, marshall mc bride is spawned outside the north abbey under the tree

The We Aren't Dupes because we aren't standing in the same place even though we have the same name problem
Update You can now set a XYZ threshold, so spawners/spawns with the same Entry and within a certain distance of another (between the source file and the merge file) will considered a dupe!

My app does do dupe checking. But you can land up with a whole lot of Dupe Vendors standing with in five feet of another. So be sure to set the XYZ threshold to 5 (feet)

My app does do dupe checking, but if a value like XYZ differs - no dupe. So you can land up with a whole lot of Dupe Vendors standing with in five feet of another.

Note it is possible to remove all spawns/spawned Quest/Vendor/Elite/Trainers from a save thus eliminate the The We Aren't Dupes because we aren't standing in the same place even though we have the same name problem

Also, you need to effectively unspawn your world, why? Because spawn creatures ten to move around, again The We Aren't Dupes because we aren't standing in the same place even though we have the same name problem

It is just practise, if it exists in the world - it should have a parent spawner.

Additionally we need to decide if we want to use applications like the world compressor. And then all those on world.save dev do it, as if one person uses this app and another doesn't they will have mismatches.

For the Distributor

   1. Run The Parser and Process
   2. Under the Split tab. Check Create Modified File (This is the file we want).The Selection Criteria: LINK=
   3. Your modified file will contain only spawnpoints now. You can close the Application.
   4. Rename World.Modified to something Like WorldHyjal205.Save
   5. Distribute the File



For The "Client"

   1. Open the Parser, load your world.save (for heaven sake make a backup)
   2. Process
   3. The Under the Merge Tab
   4. Load File from Merge, The Distributors File
   5. Check: Do In Depth Comparison. Append Items with Conflicting IDs, is GUID
   6. Make Sure that the drop-down is: Item Property - this be automatically selected if the load file has .save entry
   7. The check "Is World.Save" will compare identifying features of World Save Items (entry, XYZ, CTYPE, MAP) rather than doing a string by string comparison (which is more accurate, but will take much much longer)
   8. Merge
   9. Hope like ###### it works

----------------------------------------
Re-Ordering Items and Updating ID Dependant Properties

Say you want to re-order a whole bunch of waypoints... example:

CODE

//Darnassus: Ancient Protector patrol near entry gate (bl!zzlike)

[point 100549]
pos=9983.927734 2051.208252 1328.492554
next=100550

[point 100550]
pos=9980.979492 2045.898438 1328.240112
next=100550,100550,100550,100550,100550,100551


You to re-order a file of waypoints where the IDs [point xxxxxx] are completely out of sequence. But you also need to update the next= propery so it's still valid..

   1. Open Parser ver 8.1.4 and Higher
   2. Load Your File and Parse
   3. Go to 'Do Stuff' and Select 'Number Magic'
   4. Property Header: next=
   5. is an array of, lets say 10 be sure we get everything
   6. Array separator is a ,
   7. Click "Formula" and Click "..."
   8. in the formula builder, set the header to: [point
   9. Set the operation to: -
  10. Array of: 1
  11. Separator leave blank
  12. (btw you need to click on the + to add items to the formula)
  13. Click 'Done'
  14. Click 'Do Stuff'
  15. An output file will be created, close the parser
  16. Reopen the parser and open and parser the outputted file and parse
  17. then under the tab 'Select / Split / Merge' select the tab 'Re-Ordered'
  18. Type in the ID you want to start from eg. 500
  19. click 're-order'
  20. Go to 'Do Stuff' and Select 'Number Magic'
  21. Property Header: next=
  22. is an array of, lets say 10 be sure we get everything
  23. Array separator is a ,
  24. Click "Formula" and Click "..."
  25. in the formula builder, set the header to: [point
  26. Set the operation to: + note that it's addition this time
  27. Array of: 1
  28. Separator leave blank
  29. (btw you need to click on the + to add items to the formula)
  30. Click 'Done'
  31. Click 'Do Stuff'
  32. Get your result file - all done!



eg. Result
CODE

//Darnassus: Ancient Protector patrol near entry gate (bl!zzlike)

[point 9994]
pos=9983.927734 2051.208252 1328.492554
next=9995

[point 9995]
pos=9980.979492 2045.898438 1328.240112
next=9995,9995,9995,9995,9995,9996

------------------------------------------------------------------
Patching a SCP - Translation Example

English Item Which has all the properties:
CODE

[item 225001]
name=A Nice Smelling Potion
description=This potion really Smells nice.
class=12
reqlevel=1
classes=07FF
races=01FF
model=983
durability=25
stackable=1
bonding=4
material=1


German Item, which only has the updated descriptions (babelfish translation - so don't laugh to much!)
CODE

[item 225001]
name=Ein Nizza Riechender Trank
description=Dieser Trank riecht wirklich nett.


and you want this:

CODE

[item 225001]
name=Ein Nizza Riechender Trank
description=Dieser Trank riecht wirklich nett.
class=12
reqlevel=1
classes=07FF
races=01FF
model=983
durability=25
stackable=1
bonding=4
material=1


Do this:

   1. Open SCP Parser
   2. "Load SCP Save" and open your English File
   3. Click "Parse"
   4. Then click on the tab "Select/Split/Merge"
   5. Click on the tab "Merge"
   6. Click on "Load File To Merge"
   7. Check the Option "Do Patch Operation"
   8. Click "Merge"
   9. Once it's done you'll be prompted to enter a filename for the new merged file.

Another Translation Example
If you have two files of gameobjects, one German and Another English. Say you want to take the Names from the German file and put them into the English one.

    * Load the App.
    * Open the German GameObjects and Parse
    * Then Go to the Tab 'Export / Create Array'
    * Set the Export Type to: Export Items
    * Then the Check Box 'Include Values from Property..' Must be ticked (should be by default)
    * You can either type the name of the property and click the + button or click the 'all' button and remove the fields you don't want. I recommend the second option.
    * Click 'Create Array'
    * Save the Results to a file eg. GermanGONames
      (??? DuitslandGONaame - My German is bad very bad - I know english, bad english and baby dutch smile.gif )
    * Reset or Close and Reopen the App.
    * Load the English File and Parse
    * Then Click on the tab 'Select / split / merge'
    * Click on Merge and Load the GermanGONames file you made last time. Click the option 'Do Patch Operation' and click Merge.

-----------------------------------------------------------------
Extracting Items and generating a merchant sell list

   1. Load up the items.scp and parse
   2. Do a split -Selection Criteria: CLASS=2 for weapons, be sure to unset allow partial matches.
   3. Do another split- Selection Criteria: LEVEL= and check the option "Value Must be" and select < 11 this will give you all the items that are level below level 11.
   4. Do any other splits you need like race requirements etc. etc. etc.
   5. So now in memory you have all the weapons that have reqlevel below 11, now to make it something useful
   6. Click on "Export/Create Array"
   7. Click on ID - Single Line
   8. Check "prepend text" and set the prepend text to: sell=
   9. Check "Comment Property Property with //"
  10. Check "Includes Values from Property" and in the space type: NAME= and click the + button to add it to the list.
  11. Create Array this will create a text file with lines like:
      sell=233 // Awesome Blade of Cutting
      sell=234 // Potions of Caffiene
      sell=289 // Boots of ###### Kicking
      etc. etc.
  12. You can take this info and add to creatures that are vendors

-----------------------------------------------------------------

Changing Drop Chances in your LootTemplates

   1. Open the application and load the loottempletes.scp and check the "Load Includes" option
   2. Click on Parse
   3. Now if you wish you can some splitting, but in this case I wouldn't recommended it. So click on the tab "Do Stuff"
   4. Click the Option "Number Magic"
   5. Set the property header to: LOOT=
   6. it is an array of 2 numers
   7. Separated by a [SPACE] - inputted by default
   8. Check the option "Only Process the 2 Number in the Array" as you don't want to change the item dropped, just the drop rate
   9. Now you can either use a formula or simple math - in this example I am going to use simple math, so check "Do Simple Math"
  10. Do Maths and * by Amount 1.2
  11. Check what ever rounding options you want
  12. and in this example I am going to set the min value to 1, so that my players (all 5 of them) will actually see those items dropped! So the lowest drop chance will be 1%
  13. Then Click "Do Stuff"
  14. Then Go to "Actions" - "Generate Result Files #includes" and go to all your folders with your loottempletes and rename the .results to .scp

-----------------------------------------------------------------
Updating drop values for items required in quests

   1. Open your quests
   2. Parse
   3. Go to "Export / Create Array"
   4. Export Type: Dont include GUID or ID
   5. Check Include Values from (checked by default)
   6. Deliver= and click the + button
   7. check the option "only include element number" and set it to 1
   8. click create array and save to QuestITems.txt
   9. Then close and re-open
  10. then open your loottempletes.scp
  11. parse
  12. then go to "do stuff"
  13. check number magic
  14. property header: loot=
  15. is an array of 2 numbers separated by a [SPACE]
  16. check "Only Update the" 2 element in the array
  17. check "Element 1 Must be in list"
  18. click load list and load QuestItems.txt
  19. check simple maths and * by 10000
  20. check round Result to Whole Numbers
  21. check max result and set that to 100
  22. do stuff
  23. generate results
  24. NOTE this will change all drops of any item required for a quest to 100% so think about this, you may want to split your loottempletes up a bit

-----------------------------------------------------------------

At no time your original file is modified.

At the end of processing a count of all entires is added as a comment at the top of the file. Make any needed changes and then SAVE!

This tool is really rudimentry, I hope to develop more efficient tools for specific SCP's and Saves later.