#HW2 portals and commands
#
namespace eval portal1 {
proc QueryQuest { obj player questid } { 
set level [GetLevel $player]
if { $level < 60} {
Say $player 0 "I have to be level 60 to enter"
}
if { $level >= 60 } {
Teleport $player 1 4611.963379 -3862.521484 944.183716
}
}
}

namespace eval portal2 { 
proc QueryQuest { obj player questid } { 
Teleport $player 1 4562.013184 -3933.503662 942.294617
} 
}

namespace eval portal3 { 
proc QueryQuest { obj player questid } { 
Teleport $player 1 4847.452637 -1775.041870 1162.198975
} 
}

namespace eval portal4 { 
proc QueryQuest { obj player questid } { 
Teleport $player 1 4780.978516 -1687.779279 1147.734131
} 
}

namespace eval portal5 {
proc QueryQuest { obj player questid } { 
Teleport $player 1 4879.525391 -3124.612061 1188.9
} 
}

namespace eval portal6 {
proc QueryQuest { obj player questid } { 
Teleport $player 1 4578.7 -3103.8 993
} 
}

#Portali capitali
namespace eval darnassusportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { 
Teleport $player 1 9951.75 2254.50 1335.42

} else { Say $player 0 "I can't use it...it's for the alliance faction!" }
}
}

namespace eval stormwindportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { 
Teleport $player 0 -9050.870117 445.458008 93.055801

} else { Say $player 0 "I can't use it...it's for the alliance faction!" }
}
}

namespace eval ironforgeportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { 
Teleport $player 0 -5023.00 -830.06 495.32

} else { Say $player 0 "I can't use it...it's for the alliance faction!" }
}
}


namespace eval orgrimmarportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { 
Teleport $player 1 1381.77 -4371.16 26.02

} else { Say $player 0 "I can't use it...it's for the horde faction!" }
}
}

namespace eval thunderbluffportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { 
Teleport $player 1 -1285.417847 176.522873 129.993927

} else { Say $player 0 "I can't use it...it's for the horde faction!" }
}
}

namespace eval undercityportale {
proc QueryQuest { obj player questid } { 
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { 
Teleport $player 0 1849.69 235.70 66.66

} else { Say $player 0 "I can't use it...it's for the horde faction!" }
}
}


#ARATHI by Yehonal

namespace eval arathibasin { 
proc QueryQuest { obj player questid } { 
Teleport $player 529 1182.28 1183.18 -45.255
} 
}

#Naxxramas

namespace eval naxxramas { 
proc QueryQuest { obj player questid } { 
Teleport $player 0 3132.701660 -3731.424072 138.657410
} 
}


namespace eval frostwyrm { 
proc QueryQuest { obj player questid } { 
Teleport $player 533 3498.27 -5349.45 144.967 3.71577  
} 
} 





namespace eval Draenor1 {
proc QueryQuest { obj player questid}  {
Teleport $player 0 -14993 12719 61
}
}

namespace eval Draenor2 {
proc QueryQuest { obj player questid}  {
Teleport $player 0 -11853.6 -3197.44 -27.2186
}
}

namespace eval GMCity {
proc QueryQuest { npc player questid}  {
Teleport $player 451 16329.17 16321 69
}
}

namespace eval Naxx {
proc QueryQuest { npc player questid}  {
Teleport $player 533 3005.87 -3435.01 293.882
}
}





#  by HW2
#  permette di kikkare fuori dal gioco tutti gli ally o tutti gli horde
#  it will kick every ally or horde!


::Custom::AddCommand "kerysha" ::WoWEmu::Commands::kerysha 5

namespace eval hw2cmd { 

proc ::WoWEmu::Commands::kerysha { player cargs } {

set target [ ::GetSelection $player ]

set option [lindex $cargs 0]

switch $cargs {

"kukally" {
    foreach { player_id } [Custom::GetKnownPlayers] {
        if { [::GetPlevel $player_id] < 4 }  { if { [::Custom::GetPlayerSide $player_id] == 0 } {
            ::KickPlayer $player_id
        }
    }
  }
}

"kukhorde" {
    foreach { player_id } [Custom::GetKnownPlayers] {
        if { [::GetPlevel $player_id] < 4 }  { if { [::Custom::GetPlayerSide $player_id] == 1 } {
            ::KickPlayer $player_id
        }
    }
  }
}




              }

       }

}

###################gdr - rpg command#########

proc ::act { player cargs } {



 Say $player 0 "|cff00ff00** $cargs **|r" 1

}


::Custom::AddCommand "act" "::act"





################### List of All Commands by ACC level ###############


::Custom::AddCommand "spcommands" ::WoWEmu::Commands::spcommand 0

proc ::WoWEmu::Commands::spcommand { player cargs } {

set plevel [ ::GetPlevel $player ]


set option [lindex $cargs 0]

switch $cargs {
   
   "" {  ::Texts::Get " Select plevel: .spcommands 0 , 1 , 2 , 3 , 4 , 5 , 6 " }


   "0" {


   if { $plevel >= 0 } { ::Texts::Get " 
commands:

help              - for other core commands
act               - rpg text
getout            - to evade from textures fallen
bug               - to create a bug note of an object for server
callpet           - to call your hunter pet 
dismiss           - to dismiss your hunter pet 
tame              - to tame a pet
isgm              - to control if the player selected is a gm
problem           - to report a problem with another player to the server
arena enter/leave - to enter in arena 
refresh           - to refresh your state
guru              - to enter in a guru event
free              - to leave the jail
roll              - read the guide to roll the loot
sharequest        - to share quest
stat              - for statsystem
pvp  enter/leave  - to enter in arena -default disabled-
pass              - to change your account password 
trollblood        - troll's regeneration
healthstone       - warlock healthstone
recc              - reincarnation -shaman spell-
guards            - call guards to help
" }

}


   "1" {


		if { $plevel >= 1 } {
			  ::Texts::Get "
commands:

no specific commands for this lvl

" } else { return [ ::Texts::Get " You don't have the permission for this "] } }

   "2" {
	        if { $plevel >= 2 } {
			  ::Texts::Get "
commands:

kick            - to kick out a player  
clearqflags     - to clear qflags of selected player
+qflag          - add a qflag
-qflag          - clear a qflag
res             - to resurrect a player /g .res to resurrect your self
accinfo         - account information of a selected player
chpass          - change account password of a selected player
cast            - .cast 'spellid' to cast a spell
emote           - .emote 'emoteid' 
go              - .go map x y z   
gospawn         - to go at the spawn of a selected creature 
arena           - close or open arena default enable 
pvp  open/close - disable or enable pvp enter/close command default disable 
ctf help        - Help about warsong commands
" }    else { return [ ::Texts::Get " You don't have the permission for this "] } }

    "3" {
 		if { $plevel >= 3 } {
			  ::Texts::Get "

tele            - .tele 'locationname' to go in a specific location
 
" }  else { return [ ::Texts::Get " You don't have the permission for this "] } }

     
    "4" {
                if { $plevel >= 4 } {
			  ::Texts::Get "
commands:

+ban           - .+ban 'accountname' to ban an account
+lock          - .+lock 'accountname' to lock an account
-ban           - .-ban 'accountname' to unban an account
-lock          - .-lock 'accountname' to unlock an account
aggro   off/on - to disable/enable aggro on your GM       
damage  off/on - to disable/enable damage on your GM -not tested-
repu           - to change reputation with a selected npc
kickban        - kick and ban a selected player
additem        - to add an item in backpack of selected character
addmoney       - to add money to a selected player
addtele        - .addtele 'name' to add a location name with your player's cordinate  
delitem        - .delitem 'id'  to del an item of a selected player
delmoney       - to del money on a selected player
deltele        - to del a created location 
ban            - ban system
aohelp         - it shows AO commands 
jail           - to jail someone
isjailed       - check
wall           - for the aggro trought the wall
addswp         - to create a talking waypoint
addwp          - to create a waypoint
setwp          - set a waypoint for a npc
showwp         - show the waypoints from selected npc
startway       - startway for the npc
endway         - endway for the npc
mergewp        - not tested
sc             - snake commands config.
scdb           - snake commands database config.
.imit 7 'text' - mark a player and type it, 7 is for common, 0 is for all.... try it out, max is 33
visible        - it rend you visible
invisible      - it rend you invisible
langall        - to learn all languages
learnall       - to learn all gm spells
learnallsp     - to learn all class spells
listbugs       - read the list of bugs
listtele       - read the list of location
untalent       - reset talent points for a selected player with a formula by level for cost - .untalent free for free service -
ctf help       - Help about warsong commands

" }  else { return [ ::Texts::Get " You don't have the permission for this "] } }

     "5" {
                 if { $plevel >= 5 } {
			  ::Texts::Get "
commands:

kerysha kukally / kukhorde - to kick out all ally or horde
setmessage     - broadcast  without GM name
b              - broadcast  with GM name


" }  else { return [ ::Texts::Get " You don't have the permission for this "] } }
        

      "6" {

                 if { $plevel >= 6 } {      
::Texts::Get "
commands:

delallcorp    - to del all corps -not tested-
importchar    - to import a character from a file
byte          - no information 
adddyn        - to add a dynamic object -only for test- 
+acc          - .+acc 'name' 'password' to add an account
-acc          - .-acc 'name' to del an account
acclist       - to show account list
banlist       - to show the ban list
plevel        - set account level of a selected player
setpassword   - to change admin pass in adminpass.conf
changepassword- to change admin pass in adminpass.conf
jailconf      - configurations for jail system
ws            - for world.save lock/unlock
pickpocketdb  - for pickpocket system
wp helps      - pewex waypoint system commands 
eval          - no information for eval 
flag1         - no information for flag1  
movelog       - no information for movelog 
pingmm        - no information for pingmm     
test          - no information for test    
test2         - no information for test2    
honor ranking - commands for honor system

" ] 
        }  else { return [ ::Texts::Get " You don't have the permission for this "] } }
        

}
}







