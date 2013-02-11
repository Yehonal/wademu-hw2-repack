Here is some basic information about the tool and the quest system, 
I made it in a FAQ style.

- smartwork

----------------------------------------------------------

Q: What does that tool do?


A: It's an Editor for quests + script which should handle all Quests that can 
   be created or modified with the editor. It's supposed to fully replace the 
   old script chaos, the pavkam plugin and QDBM/QDB and can therefore import 
   the whole QDB.

Q: What is QDB and where do I get it?

A: QDB/QDBM was the first attempt to put all quest related data into a database instead 
   of having it hardcoded in countless scripts and additonal data files. It required
   special modification for the emu to be used and was not easy to modify. It is no 
   longer required as most of todays databases for wowemu have been patched for
   use with WOWQT and MasterScript.

Q: What do all the options in the file menu mean?

A: 

New Quest: Create a new quest.

Open DB: 

   Loads the creatues.scp, the items.scp, the areatriggers.scp, the gameobjects.scp,
   and the npctext.scp and the menus.txt (if present).

Save DB: Saves and updated the files named above.

Import QDB: 

   Imports quests and NPC jobs and dialogs from QDB, not important anymore.

Import Quest Texts: 

   Imports texts from another quests.scp or any other file that 
   contains quest sections and text keys, all other data is ignored

Import Quests:

   Imports quests from another quest file, it'S the counter part of "export quests"

Import Item Texts:

   Imports texts from a given item file, that means item names and descripts, 
   all other data is ignored and the current item stats ar kept.

Export Quests:

   Exports all quests with a given marker. You can define an own marker in 
   options/preferences. All new quests you create and old quests with no 
   marker that you modify get automatically your marker. This is the counter 
   part of "Import Quests"

Export Quest Texts:

   This is the counter part of "Import Quest Texts", you can export the texts
   of all quests in your data base and translate them externally or give them
   somebody to translate.

Export Item Texts:
  
  This is the counter part of "Import Item Texts", it saves all item names and 
  item descriptions to a file that can be translated externally.

Exit: Ends the program, don't forget to save if you changes something!

Q: What does the option "Remove unused scripts" in the options menu?

A: The emu loads a lot of scripts which are assigned to events, NPC, items
   or objects. This option tries to move all script which are replaced by 
   the MasterScript after importing QDB.

Q: What is the MasterScript?

A: The MasterScript is a generic script which can replace all default quest 
   scripts for quests that were defined in QDB when importing it. It 
   furthermore controls the dialogs and job options of all NPCs that use it.
   It must be located in the scripts/tcl directory of your emu.

Q: Is there any way to influence the way in which the script works?

A: Yes, the script has a lot of comments and other information for advanced 
   users in its header. Bellow this you can find a small settings section.

Q: The tool seems to modify the npcflags each time I save the DB - why this?

A: The npcflags of NPCs that a controlled by the tool or the script are 
   updated each time you save the DB. This is a complex process. 
   Basically the tool checks which job an npc has (key: npcjobs) and 
   then whether the NPC has a dialog assigned or is quest involved.

Q: How do I create an escort quest?

A: Firstly you need to create the actual escort quest using WoWQT or if you are a very experienced user you can also directly edit the involved SCPs (quests and creatures). 

Back in game you now need to create a sequence of especially prepared waypoints. This can be done with the .qr command comming with MasterScript. You must know what quest ID you want to use and what point ID to start from. Ensure that waypoint IDs not already exist! 

Example for quest 111000 with first wp 20000:

.qr start q111000 20000  

(walk to the first WP)

.qr addwp delay=15 text=Follow me! 

(walk to next WP)

.qr addwp

(walk to next WP)

.qr addwp text=Oh, what a nice day!
  
(walk to next WP)

.qr addwp delay=10

(walk to next WP)

.qr addwp comment=That's my funny comment!

(walk to last WP)

.qr addwp text=Ok, here we are!
.qr save

To abort type: .qr abort

Note that you can add optional key=value parameters to all .qr addwp commands, these parameters will be written into the new waypoint's section. Currently only the following keys ae finally during the quest processed by MasterScript:

delay: time to wait at the WP in seconds

text: text to say when reaching the WP

tactic: only used if the SmartAI is loaded, activates a given tactic

After saving the quest route with .qr save, the recorded waypoints will be added to the waypoints_quest.scp, make sure that you have an inlude line for this file in 
your main waypoints.scp!


Note: 

For exploration quests the exploration of an areatrigger must be the only objective.

What all the files are for?

* quests.scp is independed and contains all quest parameters, WoWQT updates all other files if necessary, you only have to ensure that stuff is spawned and required items drop. Furthermore, as the quest.scp contains all parameters, it can be read by any future processor and very likely be used for other emus too, then a tool similiar too MasterScript would be needed, that could even be "hardcoded" while I doubt that neos TCL could be used for anything else.

* the creatures.scp contains MasterScript specific job keys and also keys for the greeting npctext IDs, see this.

* the dialogs.txt contains all gossip dialogs, it's basically a list of dialog options with 2 answers, a positive (option requirements met) and a negative (reqs not met). Each answer can have up to 10 alternative texts which are randomly choosen. Although those texts can be put directly into the menus.txt, it's better to use npctext IDs whenever it's possible. The current version of WoWQT creates such a menus.txt file using orginal npctext IDs, so dialogs get automatically translated if the the npctexts.scp is translated. Btw. in UWC the old QDB texts are still imported, I couldn't see that they are used anywhere, so you can get rid of that file.

* finally we have the msgs.def, that's the last true relict of QDB, it contains place holders of options texts of gossip dialogs. That is bascially similiar too npctexts if I think about it and maybe I should have converted it exactly too such a system. But for now we use it as it was with the plugin. You should understand that npctexts are only used by npcs, that means these are the unclickable texts at top in a dialog. Therefore the things that the player says, so the stuff what he asks the NPC is no npctexts and must be stored elsewhere and so this is kept in the msgs.def. So in the best case we have absolutely no texts in the menus.txt but only npctext ids for what npcs said and placeholders (of the msgs.def) for what the player says. So only npctext.scp and msgs.def must be translated. 


Notice also that this quest system can not cover all quests but most of the pure kill, delivery, exploration and escort quests. Some quests are too special to be covered by that generic system, for example the well known "lazy peons" quest. Other quests like escort quests may be supported in future. But actually for those few quests which can not be covered by that system, special tcl scripts are still required. So I wonder why neo has not focussed on this. Instead as far as I see it has pack doesn't have any functionallity that MasterScript not has.


Last updated: 2006-10-31 by smartwork
 
