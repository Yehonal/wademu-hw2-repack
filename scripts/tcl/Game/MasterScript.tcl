# StartTCL: n
#
# MasterScript.tcl v3.5.5 (c) 2005-2007 by smartwork
#
#
# Generic QuestScript which should be able to handle all currently working
# quest types and offers also an easy to use menu creation system for NPCs.
# It must be given to all quest-involved NPCs, items, objects and areatriggers
# which is automatically done by my WoW Quest Tool. With version 3.2 it has
# been modified for Startup-TCL by spirit who also added some improvements
# mainly regarding cheat-protection which has later been enhanced by me, so if
# AutoBan.tcl is used, a cheater will also get banned for quest cheats now.
#
# Some information for manual editing of the scp files:
#
# quests.scp:
#
# explore=<areatrigger>  # explore missions, must be the only objective
# disabled=<0|1>         # optional, if 1 the quest will not be started
# precompletion=<text>   # optional, text which is shown right before completion
# requirements           # optional:
#   example: requirements=r1|3|4|7 c8 q123 q567 s99:100
#   means: required races 1,3,4 or 7 (=alliance), required class 8 (mage),
#          required quests 123 and 567, required skill 99 at level 100 or above
#
# Experimental escort quest "hack":
#
# A new objective key called "escort" has been introduced, it defines the
# first WP of the escort route. This route can be created with the new
# command .qr where the result will be stored in the waypoints_quest.scp,
# so you have to include this file. Type .qr to see the usage. Unlike other
# quests, escort quests CAN be shared, all players who want to escort the NPC
# must quickly talk to him as long as he is close to the start WP. When he
# reaches the destination WP, he will finish the quest for all involved players
# and wait a short while before retuning to the startwp.
#
# Example (objective only): escort=20000
#
# Descriptions, reward etc. can be edited using WoWQT, it will simply treat
# it as exploration quest and not perform any extensive checks. So basically
# you can create an exploration quest in WoWQT and and this excort line. It is
# not nescessary to manually assign the startwp to the NPC or its SP. The
# startwp is actally only used to teleport the NPC finally back to its start
# location.
#
# script relevant keys in the other scp files:
#
# creatures.scp, gameobjects.scp and items.scp:
#
# starts_quests=<questid> ... <questid> # list of startable quests
# finishes_quests=<questid> ... <questid> # list of finishable quests
#
# creatures.scp:
#
# npcjobs=[vendor] [banker] [trainer[x]] [taxi] [guildmaster] [innkeeper]
# (x of trainer is class number can be omitted for job/weapons/generic trainers)
# The brackets mean that all are optional values, so they must be omitted!!!
#
# areatriggers.scp: completes_quest=<questid>
# items.scp: startquest=<questid>
# gameobjects.scp: sound1=<questid>
# Note: sound1 and startquest are default keys used by wad emu, their quest ids
#       will be automaticallyed added to their starts_quests list
#
# npctext.scp: contains the default greeting messages for all npcs
# msgs.def: Defines the translation for standard messages, see the file
# menus.txt: Defines the menus for NPCs, also pretty easy format, see the file
#
# Exported functions (=global usable in other scripts):
#
# Translate player key defaultval - see header comment of this function
# EvalText player atext - returns are string with replaced and
#                         translated place holders
#
# Note: Auctioneers and Tabard Vendors can currently have no special Chat
# options due to technical limits
#
# - smartwork                                e-mail: smart.guy@gmx.de
#

#######  SETTINGS  ###########

namespace eval MasterScript {

  # Here you can control some aspects of the script by setting some variables.
  # All recommeded values are for a "blizz-like" behaviour.

  # set this to 1 if you want that train  options for class trainers only appear
  # if class can be trained by the npc, recommended: 1
  variable strict_trainers 1

  # set the allowed maximum number of primary professions here (0 = unlimited),
  # recommended: 2
  variable prim_prof_limit 2

  # set this to 1 if an NPC who is asked for training by a class which he can't
  # train should end the dialog, has only effect if strict_trainers is 0
  variable wrong_trainers_end_gossip 1

  # set this to get a marker on the minimap if a nearby NPC can finish a quest,
  # recommended: 1
  variable NpcPOI_enabled 1

  # set this to auto-add a good bye option for NPC dialogs, recommended: 0
  variable add_goodbye_option 0

  # NPCs who can finish a quest later but have currently nothing to say,
  # will display a notask-default message. Set this to 1 if the this message
  # should be said instead of displayed in dialog, recommended: 0
  variable say_notask_message 0

  # this npctext message will be displayed if nothing else defined
  variable default_greeting_id 1228

  # set this to have default reputation when reputation key is missing
  variable default_reputation 1

  # specify log file here to enable logging of completed quests, or use ""
  variable log_file "logs/masterscript.log"
}

##### List of message keys (see msgs.def) used in this script

# syntax ins msgs.def:
#
# race/class/key                Some Text here in a single line
#
# "*" matches all classes or races
#
# In the list below I'll use the Question Mark "?" for keys who are looked
# up for the current race and class, it has no function in the msgs.def
# which comes originally from QDB! If no key matching the class and race is
# found, a global key (*/*/key) will be searched. If this is also not found,
# a default value will be used. Note that you can have multiple versions of
# messages in the msgs.def. If there are several vesions, a random one will
# be choosen each time a player talks to the NPC.

# general keys:
#
# */*/BindPointUpdated - used by NPCs after setting a new bindpoint for a player
# ?/?/PlayerRevived   - used by spirit healers after a player is resurrected
# ?/?/noclass - used by trainers if they can't train that class
# ?/?/noquestsavail - used by quest items and GOs if no quests are available
# ?/?/MsgPPLimitReached - said by trainers if prim_prof_limit is reached
# ?/?/qoskippedquest - used by quest items & GOs if current quest can be skipped
# ?/?/skippedquest - used by NPCs if current quest can be skipped
# ?/?/goodbye - the good-bye option

# class names:

# */*/ClassWarrior
# */*/ClassHunter
# */*/ClassPaladin
# */*/ClassRogue
# */*/ClassPriest
# */*/ClassShaman
# */*/ClassMage
# */*/ClassWarlock
# */*/ClassDruid

# supported placeholders in dialogs:
#
# $b - line break (0d 0a)
# $c - class name, translated using the keys listed above
# $n - name of player's character

# npc jobs: these are the chat options that a players gets when talking to NPCs
# which have jobs. Note that these are in most cases class and race specific.
# Furthermore the old QDB keys for these jobs are still supported.

# ?/?/auctioneer    - currently unused because of not scriptable
# ?/?/banker
# ?/?/guildmaster
# ?/?/innkeeper     - innkeeper option to set new bind point (=bind Hearthstone)
# ?/?/repairer      - used only if NPC is marked as repairer but not as vendor
# ?/?/spirithealer  - for the "revive my spirit" option
# ?/?/taxi          - taxi NPCs of any kind, mostly unused
# ?/?/trainer       - generic trainer
# ?/?/ctrainer      - class trainer
# ?/?/vendor        - generic vendor

# Exported (=global useable) functions
proc Translate {player key defaultval} {
  # translates string with the data of the msgs.def
  # key must be <id> or <class>.<id>  or <race>.<class>.id
  # if no race or class is given, these values are taken from the $player
  # if no exact match is found is found for $race.$class.$id, this function
  # searches down to 0.0.$id furthermore the class placeholder $c will
  # be replaced with the player's classname
  set prace [GetRace $player]
  set pclass [GetClass $player]
  set keylist [split $key .]
  switch [llength $keylist] {
    3         {set krace [lindex $keylist 0]; set kclass [lindex $keylist 1]}
    2         {set krace $prace; set kclass [lindex $keylist 1]}
    default   {set krace $prace; set kclass $pclass}
  }
  set id [string tolower [lindex $keylist end end]]

  set varname "msg.$krace.$kclass.$id"
  set found [info exists ::messages::$varname]

  if {!$found && ($krace != 0)} {
   set varname "msg.0.$kclass.$id"
   set found [info exists ::messages::$varname]
  }
  if {!$found && ($kclass != 0)} {
     set varname "msg.$krace.0.$id"
     set found [info exists ::messages::$varname]
  }
  if {!$found && ($krace != 0) && ($kclass != 0)} {
     set varname "msg.0.0.$id"
     set found [info exists ::messages::$varname]
  }
  if {!$found
  } then { set result $defaultval
  } else {
    set idx [expr {int(rand()*[llength [set ::messages::$varname]])}]
    set result [lindex [set ::messages::$varname] $idx]
  }

  # replace class placeholders
  if [regexp -nocase {\$c\M} $result] {
    switch $pclass {
      1   {set cn warrior}
      2   {set cn paladin}
      3   {set cn hunter}
      4   {set cn rogue}
      5   {set cn priest}
      7   {set cn shaman}
      8   {set cn mage}
      9   {set cn warlock}
      11  {set cn druid}
      default {set cn ""}
    }
    set cn [Translate $player 0.0.$cn $cn]
    set cn [Translate $player "0.0.Class$cn" $cn]
    regsub -nocase -all {\$c\M} $result $cn result
  }
  # replace line break place holders
  regsub -nocase -all {\$b\M} $result "\x0d\x0a" result

  # replace name place holders
  regsub -nocase -all {\$n\M} $result [GetName $player] result

  return $result
}

proc EvalText {player atext} {
# replaces (=translates) placeholders (words with leading $) in the given string
  set sidx 0
  while {[set p [string first "$" $atext $sidx]]>-1} {
    set endp [string first " " $atext $p]
    if {$endp<0
    } then {set endp [expr [string length $atext]-1]
    } else {incr endp -1}
    if {$endp>$p} {
      set placeholder [string range $atext $p $endp]
      set key [string range $placeholder 1 end]
      set s [Translate $player $key $placeholder]
      set atext [string replace $atext $p $endp $s]
      # remove quotes
      regsub -all {"} $atext {'} atext
    }
    if {$endp == "end"} then {break} else {set sidx $endp}
  }
  return $atext
}

# the following 3 functions can be used to store data (variables) into qflags,
# so data linked to a specific object will not get lost on .retcl
proc GetQFlagData {mob varname} {
  set result ""
  foreach qflag [join [GetQFlags $mob]] {
    set params [split $qflag °]
    if {[llength $params] < 2 || [lindex $params 0] != $varname} continue
    if {[set result [lrange $params 1 end]] != ""} break
  }
  return $result
}

proc ClearQFlagData {mob varname} {
  set qflags [join [GetQFlags $mob]]

  foreach qflag $qflags {
    set qflist [split $qflag °]
    if {[llength $qflist] < 2 || [lindex $qflist 0] != $varname} continue
    ClearQFlag $mob $qflag
  }
}

proc SetQFlagData {mob varname value} {
  # no way to clear qflags with spaces, so we need another seperator here,
  # pipe is no good idea too as it is used for color codes, so for now: °
  ClearQFlagData $mob $varname
  regsub -nocase -all { } "$varname $value" ° qflag
  SetQFlag $mob $qflag
}

### register some dummy functions for older emus if needed ##

if {[lsearch [info commands] "AddItem"] == -1} {
  proc AddItem { player itemid } {
    Say $player 0 "AddItem is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "ChangeMoney"] == -1} {
  proc ChangeMoney { player value } {
    Say $player 0 "ChangeMoney is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "CastSpell"] == -1} {
  proc CastSpell { from to spellid } {
    if {[GetLevel $from] > 0
    } then { set mob $from
    } elseif {[GetLevel $to] > 0} {set mob $to
    } else {set mob ""}
    if {$mob != ""} {
      Say $mob 0 "CastSpell is not supported by this emu version!"
    }
  }
}

if {[lsearch [info commands] "GetName"] == -1} {
  proc GetName { player } {
    return "\$n"
  }
}

if {[lsearch [info commands] "GetObjectType"] == -1} {
  proc GetObjectType { obj } {
    if {[GetLevel $obj] != 0} { return 3} {
      set obj_entry [GetEntry $obj]
      set scpfile "items.scp"
      set isection "item $obj_entry"
      set osection "gameobj $obj_entry"
      set val [GetScpValue $scpfile $isection "class"]
      if {$val == ""} {return 5} {
        set fquests [join [GetScpValue $scpfile $isection "finishes_quests"]]
        set squests [join [GetScpValue $scpfile $isection "starts_quests"]]
        if {($fquests == "") && ($squests == "") &&
           ([GetScpValue "gameobjects.scp" $osection "sound1"] != "") &&
           ([GetScpValue "gameobjects.scp" $osection "type"] == 2)} {
          return 5; # obj is gameobject
        }
        return 1; # obj is item
      }
    }
  }
}

if {[lsearch [info commands] "GetSkill"] == -1} {
  variable prim_prof_limit 0; # must be ignored for older emus
  proc GetSkill { player skillid } {
    return 300
  }
}

if {[lsearch [info commands] "Emote"] == -1} {
  proc Emote { mob emoteid } {
    Say $mob 0 "Emotes are not supported by this emu version!"
  }
}

if {[lsearch [info commands] "EmoteState"] == -1} {
  proc EmoteState { mob esid } {
    Say $mob 0 "EmoteState is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "LearnSpell"] == -1} {
  proc LearnSpell { player spellid } {
    Say $player 0 "LearnSpell is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "NpcPOI"] == -1} {
  proc NpcPOI { player npc onoff } {
    Say $npc 0 "NpcPOI is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "SendPOI"] == -1} {
  proc SendPOI { player flags x y type unk text } {
    Say $player 0 "SendPOI is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "SetSkill"] == -1} {
  proc SetSkill { player skillid min max } {
    Say $player 0 "SetSkill is not supported by this emu version!"
  }
}

if {[lsearch [info commands] "TaxistList"] == -1} {
  proc SetSkill { player npc } {
    Say $npc 0 "Error: TaxistList is not supported by this emu version!"
  }
}

#########  CODE (actual script) ###########

namespace eval MasterScript {

variable debug 0
variable default_npctext 3055

if {[info exists debug] && $debug} {

proc deb { obj s } {
  if {[GetObjectType $obj] == 3} {Say $obj 0 $s} {puts "$s"}
}

} else {

proc deb { obj s } {}

}

proc CleanupKnownPlayers { newplayer } {
  variable kplayers

  # cleanup known players
  set cs [clock seconds]
  set memorytime 1800
  if [info exists kplayers] {
    set new_kplayers ""
    foreach kplayer $kplayers {
      set plid [lindex $kplayer 0]
      set ts [lindex $kplayer 1]
      if {($plid != $newplayer) && ([expr $ts + $memorytime] > $cs)
      } then { lappend new_kplayers $kplayer
      } else {
        variable opts$plid
        variable jobs$plid
        variable quests$plid
        if [info exists opts$plid] {unset opts$plid}
        if [info exists jobs$plid] {unset jobs$plid}
        if [info exists quests$plid] {unset quests$plid}
      }
    }
    set kplayers $new_kplayers
  }
  lappend kplayers "$newplayer [clock seconds]"
}

proc GetGreetingID {obj player} {
  variable default_greeting_id
  set qtgid ""
  if {[GetObjectType $obj] == 3} {
    # different and alternative greetings are possible for npcs
    set section "creature [GetEntry $obj]"
    set qtgreqs [join [GetScpValue "creatures.scp" $section "qtgreqs"]]
    if {[CheckReqs $player $qtgreqs $obj]
    } {set qtgids [join [GetScpValue "creatures.scp" $section "qtgids0"]]
    } {set qtgids [join [GetScpValue "creatures.scp" $section "qtgids1"]]}
    set idx [expr {int(rand()*[llength $qtgids])}]
    set qtgid [lindex $qtgids $idx]
  }
  if [string is integer $qtgid] {return $qtgid} {return $default_greeting_id}
}

proc OnGossip { obj player gossipid } {
  # unknown when this is triggered, but it is for certain GOs instead of
  # QueryQuest and it seems that the gossipID is the (default) questid then
  QueryQuest $obj $player $gossipid
  return 0
}

proc GossipHello { npc player } {
  deb $npc "GossipHello player: $player npc: $npc"

  CleanupKnownPlayers $player

  variable opts$player ""
  variable jobs$player ""
  variable quests$player ""

  # gossip and quest processing
  set squests [lindex [GetStartableQuests $npc $player] 0]
  set fquests [GetFinishableQuests $npc $player]
  set fquests "[lindex $fquests 0] [lindex $fquests 1]"
  set quests$player [string trim "$squests $fquests"]

  set jobs$player [GetJobOptions $npc $player]
  GossipSelect $npc $player 0
}

proc GossipSelect {obj player option} {
  # note: GossipSelect currently works only for NPCs but as soon as
  # obj can also be GO or Item, menus should work for those too
  variable opts$player
  variable jobs$player
  variable quests$player
  variable add_goodbye_option
  if {![info exists opts$player]} {
    # prevent errors due to global reset of variables after a a retcl while
    # beeing in dialog with a NPC
    SendGossipComplete $player
    return
  }

  set npctext ""; set npcemote ""
  set end_gossip 0
  set out ""
  set objtype [GetObjectType $obj]

  deb $obj "GossipSelect - option: $option "

  switch $objtype {
    1       {set mprefix ITM}
    3       {set mprefix NPC; set npc $obj}
    5       {set mprefix OBJ}
    default {set mprefix UNK}
  }
  append mprefix [GetEntry $obj]

  # processing of clicked option if any
  if {[set opts$player] == ""
  } then {
      # display main menu and greeting if dialog just opened
      set mid 0
      set npctext [GetGreetingID $obj $player]
      if {$objtype == 3} {
        set section "creature [GetEntry $npc]"
        set qtgemote [join [GetScpValue "creatures.scp" $section "qtgemote"]]
        set npcemote $qtgemote
      }
  } else {
     set clicked_opt [lindex [set opts$player] $option]
     if {[llength $clicked_opt] == 1
     } { # if it's not an option but only a link, process it that way
         set mid $clicked_opt
     } {
        # full processing of last clicked option
        foreach {reqs answerids0 answerids1 link0 link1 emote0 emote1\
                 tcl0 tcl1 icon text} $clicked_opt {break}
        if {($reqs == "") || [CheckReqs $player $reqs $obj]
        } then {
            # requirements are met, process answer0
            set idx [expr {int(rand()*[llength $answerids0])}]
            set answerid [lindex $answerids0 $idx]
            set mid $link0
            set emoteid $emote0
            set tcl_action $tcl0
        } else {
            # requirements are not met, process answer1
            set idx [expr {int(rand()*[llength $answerids1])}]
            set answerid [lindex $answerids1 $idx]
            set mid $link1
            set emoteid $emote1
            set tcl_action $tcl1
        }
        if {[string is integer $emoteid] && ([GetObjectType $obj] == 3)} {
          set npcemote $emoteid
        }

        if {[string is integer $answerid]
        } {set npctext $answerid
        } {set npctext [GetGreetingID $obj $player]}

        if {$tcl_action != ""} {
          if [catch {eval $tcl_action} errorstring] {
            puts ""
            puts "WARNING: got error processing TCL action for \
                  'moption $mprefix[GetEntry $obj].$mid'"
            puts "ERROR: $errorstring"
            puts "ACTION: $tcl_action"
          }
        }
        # if {$mid == ""} {set mid "ExitGossip"}
     }
  }

  # build new (=current) menu
  switch -glob $mid {
    BankerList   {BankerList $player $obj}
    ExitGossip   {set end_gossip 1}
    PetitionList {PetitionList $player $obj}
    Resurrect    {Resurrect $player $obj
                  if {$objtype==3} {
                    Say $obj 0 [Translate $player PlayerRevived "So be it!"]
                  }
                  set end_gossip 1
                 }
    SelectQuest* {QuestSelect $obj $player [lindex [split $mid _] 1]}
    SetBindpoint {SetBindpoint $player $obj
                  CastSpell $obj $player 3286; ConsumeItem $player 6948 1; AddItem $player 6948
                  Say $obj 0 [Translate $player 0.0.BindPointUpdated "So be it\
                          - from now your hearthstone will take you back here!"]
                  SendGossipComplete $player
                 }
    TrainerList  {ShowTrainerList $player $obj}
    TaxistList   {TaxistList $player $obj}
    VendorList   {VendorList $player $obj}
    default {
      # there must always an npctext be defined für SendGossip
      if {$npctext == ""} {set npctext [GetGreetingID $obj $player]}
      set out "\{npctext $npctext\}"

      # get current menu options
      if {$mid == ""
      } { set menu [set opts$player]
      } { if ![info exists menus::$mprefix.$mid] {set menu ""} {
           set menu [set menus::$mprefix.$mid]
         }
      }
      set opts$player ""

      # insert quest and job options at the top of the main menu
      if {$mid == 0} {
        if {[set quests$player] != ""} {
          if {($menu == "") && ([set jobs$player] == "")
          } { eval "SendQuestsList $player $obj [set quests$player]"
              return
          } { foreach quest [set quests$player] {lappend out "quest $quest"}}
        }

        foreach joboption [set jobs$player] {
          lappend out "text [lindex $joboption 0]\
                       \"[lindex $joboption 1]\""
          lappend opts$player [lindex $joboption 2]
        }
      }

      # build gossip menu
      if {$menu != ""} {
        # menu: <option> ... <option>
        # option: <requirements> <answerids0> <answerids1> <link0>
        #         <link1> <emote0> <emote1> <tcl0> tcl1> <iconid> <text>

        set plevel [GetLevel $player]
        foreach moption $menu {
          foreach {reqs answerids0 answerids1 link0 link1 emote0 emote1\
                   tcl0 tcl1 icon text} $moption {break}
          if {($link1 != "") || ($answerids1 != "") || ($tcl1 != "") ||
              ($emote1 != "")
          } then {set has_answer1 1
          } else {set has_answer1 0}
          if {$has_answer1 || [CheckReqs $player $reqs $obj]} {
            set opt_text [EvalText $player $text]
            lappend out "text $icon \"$opt_text\""
            lappend opts$player $moption
          }
        }
      }

      if {[llength $out] == 1} {
          # if nothing to display, check if player has incomplete quests
          # that can be finished later by the npc but for which no incomplete
          # text is defined, so the NPC will display the no(multi)task message
          if {[GetObjectType $obj] == 3
          } { set fquests [GetFinishableQuests $obj $player]
              set len [llength [lindex $fquests 2]]
              if {$len > 1
              } then {set msg [Translate $player nomultitask "Go and complete\
                               the tasks that you were given!"]
              } elseif {$len > 0
                   } { set msg [Translate $player notask "What are you waiting\
                                for? You have some work to do!"]
              } else {set msg ""}
              if {$msg != ""} {
                variable say_notask_message
                if {$say_notask_message
                } { Say $obj 0 $msg; set end_gossip 1
                } { lappend out "text 0 \"$msg\""
                    lappend opts$player ExitGossip
                }
              }
          }
      }

      if !$end_gossip {
        if {($add_goodbye_option) && ([GetObjectType $obj] == 3) && ($mid==0)} {
          if {[llength $out] == 1
          } { lappend out "text 0 \"[Translate $player goodbye "Good bye!"]\""
          } {
              # add line break to last option if needed and then the gb option
              set lastoption [lindex $out end]
              set lastoption [string range $lastoption 0 end-1]
              if {[string range $lastoption end-3 end]!="\x0d\x0a\x0d\x0a"} {
                append lastoption "\x0d\x0a\x0d\x0a"
              }
              append lastoption \"
              set out [lreplace $out end end $lastoption]
              lappend out "text 0 \"[Translate $player goodbye "Good bye!"]\""
              lappend opts$player ExitGossip
          }
        }
        eval "SendGossip $player $obj $out"
      }
    # end of default
    }
  }
  if {$end_gossip} {SendGossipComplete $player}
  # emote at last to prevent interruption by chat actions
  if {($objtype==3) && [string is integer $npcemote]} {Emote $npc $npcemote}
}

proc ChatAvailable {obj player} {
  # check whether object has a dialog (=main menu) and whether player matches
  # the requirements of at least one of its options

  set result 0
  switch [GetObjectType $obj] {
    1       {set mprefix ITM}
    3       {set mprefix NPC}
    5       {set mprefix OBJ}
    default {set mprefix UNK}
  }
  append mprefix [GetEntry $obj]
  set mid 0; # 0 = main menu

  if [info exists menus::$mprefix.$mid] {
    set menu [set menus::$mprefix.$mid]
    set section "creature [GetEntry $obj]"
    set qtnpcflags [join [GetScpValue "creatures.scp" $section "qtnpcflags"]]
    if {[lsearch [string tolower $qtnpcflags] noblueqm] == -1} {
      # menu: <option> ... <option>
      # option: <requirements> <answerids0> <answerids1> <link0> <link1>
      # <emote0> <emote1> <tcl0> tcl1> <iconid> <text>
      foreach moption $menu {
        set reqs [lindex $moption 0]
        if {$reqs == "" || [CheckReqs $player $reqs $obj]} {
          set result 1
          break
        }
      }
    }
  }
  return $result
}

proc ShowTrainerList {player npc} {
  variable wrong_trainers_end_gossip

  set prace [GetRace $player]
  set pclass [GetClass $player]
  set section "creature [GetEntry $npc]"
  set npcjobs [join [GetScpValue creatures.scp $section npcjobs]]
  set npcjobs [string tolower $npcjobs]

  if {([lsearch $npcjobs trainer]>-1) || ([lsearch $npcjobs trainer$pclass]>-1)
  } then {TrainerList $player $npc
  } else {
    set reply [Translate $player $prace.$pclass.noclass\
              "Do I look like a \$C trainer?"]
    if {[info exists wrong_trainers_end_gossip] &&
        ($wrong_trainers_end_gossip == 1)
    } then { SendGossipComplete $player; Say $npc 0 $reply
    } else { eval "SendGossip $player $npc {text 0 \"$reply\"}" }
  }
}

proc QueryQuest { obj player questid } {
  # called for GOs and items if you click on them and also if you click
  # at quest options in dialogs with NPCs
  deb $obj "QueryQuest obj=$obj player=$player questid=$questid"
  if {[GetObjectType $obj] == 3
  } {QuestSelect $obj $player $questid
  } {
    set squests [lindex [GetStartableQuests $obj $player] 0]
    set fquests [GetFinishableQuests $obj $player]
    set fquests "[lindex $fquests 0] [lindex $fquests 1]"
    set allquests [string trim "$squests $fquests"]

    if {[lsearch $allquests $questid]>-1
    } then { QuestSelect $obj $player $questid
    } else {
      if {[llength $fquests]>0
      } then { QuestSelect $obj $player [lindex $fquests 0]
      } elseif {[llength $squests]>0
               } {QuestSelect $obj $player [lindex $squests 0]
      } else {
        # prepare Gossip with item or object which is not fully supported
        # currently by wowemu
        variable opts$player ExitGossip
        variable jobs$player ""
        variable quests$player ""
        set msg [Translate $player noquestsavail "No quests available."]
        eval "SendGossip $player $obj {text 0 \"$msg\"}"
      }
    }
  }
}

proc QuestStatus {npc player} {
  deb $npc "QuestStatus"

  if {![::Custom::PlayerIsAlive $player]} {return 0}

  set fquests [GetFinishableQuests $npc $player]

  if {[lindex $fquests 0] != ""
  } then { set result 5; # yellow (?) mark - quests can be finished
           variable NpcPOI_enabled
           if $NpcPOI_enabled {NpcPOI $player $npc 1}
  } else {
     set squests [GetStartableQuests $npc $player]
     if {[lindex $squests 0] != ""
     } then {set result 4; # yellow (!) mark - quests available
     } elseif {([lindex $fquests 1] != "") ||
               ([lindex $fquests 2] != "") } {set result 3; # gray (?)
     } elseif {[lindex $squests 1] != ""} {set result 1; # gray (!)
     } elseif {[ChatAvailable $npc $player]} { set result 7; # blue (?)
     } else {set result 0}
  }

  return $result
}

proc QuestHello { npc player } {
  deb $npc "QuestHello"
  GossipHello $npc $player
}

proc QuestSelect { obj player questid } {
  set qs [GetQuestStatus $player $questid]
  set fquests [GetFinishableQuests $obj $player]
  set section "quest $questid"
  set qname [join [GetScpValue "quests.scp" $section "name"]]

  deb $obj "QuestSelect questid=$questid Status=$qs)"

  if {[lsearch [lindex $fquests 0] $questid]>-1
  } then {
      # finish completed quests
      set qtflags [join [GetScpValue "quests.scp" $section "qtflags"]]
      if {[lsearch $qtflags "skip"]>-1
      } then {
          # no precomp. possible for status=1 skip-quests, so directly to reward
          RequestReward $obj $player $questid

      } else {
        set precompletion [join [GetScpValue quests.scp $section precompletion]]
        if {$precompletion != ""
        } { SendQuestRequestItems $player $obj $questid $qname $precompletion
        } { RequestReward $obj $player $questid }
      }
  } elseif {[lsearch [lindex $fquests 1] $questid]>-1} {
       # show incomplete information (and required items) if available
       set incomplete [join [GetScpValue "quests.scp" $section "incomplete"]]
       if {$incomplete != ""
       } {SendQuestRequestItems $player $obj $questid $qname $incomplete}

  } else {SendQuestDetails $player $obj $questid }; # start new quest
}

proc QuestAccept { obj player questid } {
  variable opts$player
  deb $obj "QuestAccept obj: [GetGuid $obj] player: $player questid: $questid"

  # Check whether player can really start this quest.
  # Warning: This check may under certain cirumstances fail if player accepts
  # an escort quest while the NPC is just at the moment of accepting already
  # too far away from start point (TODO)
  set squests [lindex [GetStartableQuests $obj $player] 0]
  if {[lsearch $squests $questid] == -1} {
    set reason "[GetName $player] (level [GetLevel $player]) used a cheat to\
                start an invalid quest (ID: $questid)"
    BanPlayer $player $reason $obj $questid
  }

  set section "quest $questid"
  # if quest is skipped, display complete-now-info
  set qtflags [join [GetScpValue "quests.scp" $section "qtflags"]]
  if {[lsearch $qtflags "skip"] > -1} {
    if {[GetObjectType $obj] != 3
    } then { # note: non-NPCs can not trigger GossipSelect correctly
        set skipinfo "This quest is not supported yet. Please click again at\
                      the object to complete it now."
        set skippedinfo [Translate $player 0.0.qoskippedquest $skipinfo]
    } else {
      set skipinfo "This quest is not supported yet. Please click HERE at\
                    this text complete it now."
      set skippedinfo [Translate $player 0.0.skippedquest $skipinfo]
    }
    # as the quest is now started, it can be finished with the next
    # call to QuestSelect
    set opts$player "SelectQuest_$questid"
    eval "SendGossip $player $obj {text 0 \"$skippedinfo\"}"

  } else {
    # if the quest is an escort quest, we now send the NPC on its way
    if {[GetObjectType $obj] == 3} {
      set startwp [lindex [GetScpValue quests.scp "quest $questid" escort] 0 0]
      if [string is integer -strict $startwp] {
        # tell npc what he is doing or where to go and who escorts him
        set edata [GetQFlagData $obj escort_data]
        if {$edata != ""} {
          lappend edata $player
        } else {
          set edata [list $startwp $questid $player]
          SetWayPoint $obj $startwp
        }
        SetQFlagData $obj escort_data $edata
      }
    }
  }
}

proc CanComplete {obj player questid} {
  # called when player is going to complete quest to check whether a cheat
  # was used to finish the quest, returns 0 and bans player if so,
  # returns 1 otherwise
  set finishable_quests [GetFinishableQuests $obj $player]
  set qlist [lindex $finishable_quests 0]
  set qlist2 [lindex $finishable_quests 1]
  set section "quest $questid"
  set qtflags [string tolower [join [GetScpValue quests.scp $section qtflags]]]
  set ban_reason ""
  set prefix "[GetName $player] (level [GetLevel $player])"

  # check whether quest was really completable
  if {[lsearch $qlist $questid] < 0} {
    # Normally if a quest is not in the first list returned by
    # GetFinishAbleQuest, it's also not finishable but there is an emu problem:
    # For some devliver quests which give you the only items to deliver
    # at quest start, the status returnd by the API function GetQuestStatus
    # will never change to 1, see comments for GetFinishableQuests, so it is
    # in this very special case not possible to determine 100% which QuestStatus
    # the player must have without extending he format of the quests.scp.
    # So as the player is going to complete the quest here, this function
    # allows it for now to prevent false cheat alarms or warnings.
    set section "quest $questid"
    set deliver_item [join [GetScpValue "quests.scp" $section "deliver"]]
    set source_item [join [GetScpValue "quests.scp" $section "src_item"]]
    if {$source_item == "" || $deliver_item == "" ||
        [lsearch $qlist2 $questid] < 0} {
      set ban_reason "$prefix used a cheat to complete quest $questid"
    }
  }

  # check whether player tried to repeat a non-repeatable quest
  if {$ban_reason == ""} {
    if {([GetQFlag $player Q$questid] || [GetQFlag $player q$questid]) &&
        [lsearch $qtflags "repeatable"] < 0} {
      set ban_reason "$prefix tried to repeat a non-repeatable quest"
    }
  }

  if {$ban_reason == ""} {
    return 1
  } else {
    BanPlayer $player $ban_reason $obj $questid
    return 0
  }
}

proc BanPlayer {player reason {obj 0} {questid 0}} {
  variable log_file

  if [namespace exists ::AutoBan] {
    Say $player 0 "OMG, I'm banned!"
    ::AutoBan::Ban $obj $player $questid $reason 4
  } elseif {[info exists log_file] && $log_file != ""} {
          Custom::Log $reason $log_file
  } else {
    set timestamp [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
    set warnings [open "logs/warnings2.log" a]
    puts $warnings "$timestamp $reason"
    close $warnings
  }
}

proc RequestReward { obj player questid } {
  deb $obj "RequestReward for $questid "
  variable log_file
  # verify that player really can compelete the quest
  if ![CanComplete $obj $player $questid] return

  set section "quest $questid"
  set qname [join [GetScpValue "quests.scp" $section "name"]]
  set completion_text [join [GetScpValue "quests.scp" $section "completion"]]

  if {$completion_text == ""
  } then {SendQuestReward $player $obj $questid
  } else {SendQuestReward $player $obj $questid $qname $completion_text}
}

proc QuestChooseReward { obj player questid choose  } {
  # called after accepting reward
  deb $obj "QuestChooseReward"

  # it's not possible to prevent the emu from rewarding the player for a
  # quest that he has completed using a "hack", but we can auto-ban him...
  if ![CanComplete $obj $player $questid] return

  variable NpcPOI_enabled
  variable default_reputation
  variable log_file

  # log completed quest
  if {[info exists log_file] && $log_file != ""} {
    Custom::Log "[GetName $player] (level [GetLevel $player]) has just completed quest $questid." $log_file
  }

  if {([GetObjectType $obj] == 3) && $NpcPOI_enabled} {NpcPOI $player $obj 0}

  # set q-flag and reputation
  SetQFlag $player Q$questid
  set repu [GetScpValue "quests.scp" "quest $questid" "reputation"]

  # default reputation if reputation key is missing
  if {[string is integer -strict $repu]} {
    ::WoWEmu::QuestRepReward $player $obj $repu $questid
  } elseif {$default_reputation} {
    set reward_xp [GetScpValue "quests.scp" "quest $questid" "reward_xp"]
    if {[string is integer -strict $reward_xp]} {
      set repu [expr {$reward_xp/15}]
      ::WoWEmu::QuestRepReward $player $obj $repu $questid
    } else {
      set level [lindex [GetScpValue "quests.scp" "quest $questid" "levels"] 0 0]
      if {[string is integer -strict $level]} {
        set repu [expr {$level*5}]
        ::WoWEmu::QuestRepReward $player $obj $repu $questid
      }
    }
  }

  # give player the reward spell if any
  set rewspell [GetScpValue "quests.scp" "quest $questid" "reward_spell"]
  if {([string is integer $rewspell]) &&
      ([lsearch [info commands] "LearnSpell"]>-1)
  } {LearnSpell $player $rewspell}

  # give player the reward buff if any
  set rewbuff [GetScpValue "quests.scp" "quest $questid" "reward_buff"]
  if {([string is integer $rewbuff]) &&
      ([lsearch [info commands] "CastSpell"]>-1)
  } {
    # CastSpell seems not to work for item, at least not if they are
    # source items, so cast from player to itself instead,
    # todo: test what's about with GOs in this case
    if {[GetObjectType $obj] == 1} {
      ::CastSpell $player $player $rewbuff
    } else {
      ::CastSpell $obj $player $rewbuff
    }
  }

  set next_quest [GetScpValue "quests.scp" "quest $questid" "next_quest"]
  if {($next_quest == "") ||
      ([lsearch [lindex [GetStartableQuests $obj $player] 0] $next_quest] == -1)
  } { # send dummy gossip because for status=3 quests the reward window
      # may not close automatically, even if SendGossipComplete is called
      set npctext [GetGreetingID $obj $player]
      SendGossip $player $obj {text $npctext}
      SendGossipComplete $player
  } {SendQuestDetails $player $obj $next_quest}
}

proc AreaTrigger { player trigger_number } {
  set section "areatrigger $trigger_number"
  set quests [GetScpValue "areatriggers.scp" $section "completes_quest"]
  foreach quest $quests {
    set qs [GetQuestStatus $player $quest]
    if {($qs<4) && ($qs>1)} {SendQuestComplete $player $quest}
  }
}

proc LoadMessages {} {
  if [namespace exists ::messages] {namespace delete ::messages}
  namespace eval ::messages { }
  set msgdef "scripts/msgs.def"
  if [file exists $msgdef] {
    set msgfile [open $msgdef r]
    while {![eof $msgfile]} {
      gets $msgfile line
      set line [string trim $line]
      # insert a slash in front of tcl control chars
      # regsub -all {[\[\]\{\}\\]} $line {\\&} line
      regsub -all {"} $line {'} line

      if {($line == "") || ([string first "/" $line] == 0)} {continue}
      set keyblock [lindex $line 0]
      set key [split $keyblock /]
      set val [string trim [string range $line [string length $keyblock] end]]
      set varname "msg."
      switch [lindex $key 0] {
        human     {append varname 1.}
        orc       {append varname 2.}
        dwarf     {append varname 3.}
        nightelf  {append varname 4.}
        undead    {append varname 5.}
        tauren    {append varname 6.}
        gnome     {append varname 7.}
        troll     {append varname 8.}
        default   {append varname 0.}
      }
      switch [lindex $key 1] {
        warrior   {append varname 1.}
        paladin   {append varname 2.}
        hunter    {append varname 3.}
        rogue     {append varname 4.}
        priest    {append varname 5.}
        shaman    {append varname 7.}
        mage      {append varname 8.}
        warlock   {append varname 9.}
        druid     {append varname 11.}
        default   {append varname 0.}
      }
      switch  [lindex $key 2] {
       auction {append varname auctioneer}
       bank    {append varname banker}
       guild   {append varname guildmaster}
       inn     {append varname innkeeper}
       revive  {append varname spirithealer}
       trade   {append varname vendor}
       train   {append varname ctrainer; # class trainer}
       ttrain  {append varname trainer;  # weapon and job trainers}
       default {append varname [string tolower [lindex $key 2]]}
      }
      lappend ::messages::$varname $val
    }
    close $msgfile
  }
}

proc CanTrain { npc player} {
  # Note: The following implementation is very restrictiv as it also disables
  # multi-job trainers that would exceed the given limit if they teach the
  # player all primary profession they can. In that case the player will not
  # get new skills from them even if they belong to a profession that the
  # player has. Example: If player who has learned Mining and Herbalism and
  # talks to a combined Herbalism/Alchemist trainer will get no training options
  # as he could learn a new primary profession too there.
  variable prim_prof_limit
  if {$prim_prof_limit == 0} {return 1}

                # Bla Alc Enc Her Lea Min Ski Tai Eng
  set primprofs  "164 171 333 182 165 186 393 197 202"

  set section "creature [GetEntry $npc]"
  set qtnpcflags [join [GetScpValue "creatures.scp" $section "qtnpcflags"]]
  set npcprofs ""
  foreach flag $qtnpcflags {
    if {[string first "prof" [string tolower $flag]] == 0} {
      set npcprof [string range $flag 4 end]
      if {[lsearch $primprofs $npcprof]>-1} {lappend npcprofs $npcprof}
    }
  };

  set player_pprofs ""
  foreach prof $primprofs {
    if {[GetSkill $player $prof] > 0 } {lappend player_pprofs $prof}
  }

  set newjobs ""
  foreach prof $npcprofs {
    if {[lsearch $player_pprofs $prof] == -1} {lappend newjobs $prof}
  }
  deb $npc "player_pprofs: $player_pprofs npcprofs: $npcprofs newjobs: $newjobs"
  return [expr [llength $newjobs]+[llength $player_pprofs] <= $prim_prof_limit]
}

proc GetDistance {mob pos} {
  if {[llength $pos] < 3} {return 50000}
  foreach {map1 x1 y1 z1} [::GetPos $mob] break
  if {[llength $pos] < 4} {
    foreach {x2 y2 z2} $pos break
  } else {
    foreach {map2 x2 y2 z2} $pos break
    if {$map1 != $map2} {return 500000}
  }
  return [expr {int(sqrt(($x1 - $x2) * ($x1 - $x2) + ($y1 - $y2) * ($y1 - $y2) +
                         ($z1 - $z2) * ($z1 - $z2)))}]
}

proc GetJobOptions {npc player} {
  variable strict_trainers
  variable prim_prof_limit
  set result ""
  set prace [GetRace $player]
  set pclass [GetClass $player]
  set section "creature [GetEntry $npc]"
  set npcjobs [join [GetScpValue "creatures.scp" $section "npcjobs"]]
  set npcjobs [string tolower $npcjobs]
  set trainer_found 0
  set unable_to_train 0

  foreach npcjob $npcjobs {
    switch -glob -- $npcjob {
      auctioneer   { set optiontext  "Wanna auction something";
                     set icon 8; set link ExitGossip}
      banker       { set optiontext "I wanna to make some bank transactions";
                     set icon 6; set link BankerList }
      guildmaster  { set optiontext "I am interested in guilds";
                     set icon 4; set link PetitionList }
      innkeeper    { set optiontext "Make this inn your home";
                     set icon 4; set link SetBindpoint }
      healer        -
      spirithealer { set optiontext "Please revive my spirit";
                     set icon 4; set link Resurrect }
      repairer     { # as repairers are always also traders, add no option here
                     # if the NPC is already marked as vendor
                     if {[lsearch $npcjobs "vendor"]==-1
                     } {
                       set optiontext "I want to browse your goods!";
                       set icon 1; set link VendorList
                     } {continue}
                   }
      taxi         { set optiontext "I want continue my journey";
                     set icon 3; set link TaxistList }

      trainer*     { if {$trainer_found} {continue}
                     if ![CanTrain $npc $player] {
                       set unable_to_train 1
                       continue
                     }
                     if {$strict_trainers && ($npcjob != "trainer") &&
                         ($npcjob != "trainer$pclass")} {continue}
                     set optiontext "Teach me please!";
                     # if npc is also a generic trainer this gets priority
                     if {$npcjob != "trainer"} {
                       if {[lsearch $npcjobs "trainer"]>-1
                       } {set npcjob "trainer"} {set npcjob "ctrainer"}
                     }
                     set icon 2; set link TrainerList
                     set trainer_found 1
                   }
      vendor       { set optiontext "I want to browse your goods!";
                     set icon 1; set link VendorList }
      default      { set optiontext "I need some help...";
                     set icon 7; set link ExitGossip}
    }
    set optiontext "[Translate $player $npcjob $optiontext]\x0d\x0a\x0d\x0a"

    # jobs: <option> ... <option>
    # option: <iconid> <text> <link>
    if {$optiontext != ""} {lappend result [list $icon $optiontext $link]}
  }
  if $unable_to_train {
    Say $npc 0 [format [Translate $player MsgPPLimitReached \
     "You have already %d primary professions, \
      I can't teach you more."] $prim_prof_limit]
  }
  return $result
}

proc GetStartableQuests {obj player} {
  # returns 2 lists: the list of right-now startable quests and the list
  # of quests which can be started if players matches the level requirements if
  # all other requirements are already fulfilled

  set obj_entry [GetEntry $obj]
  set obj_type [GetObjectType $obj]
  switch $obj_type {
    1       { set scpfile "items.scp"
              set section "item $obj_entry"
              set default_quest [GetScpValue $scpfile $section "startquest"]
            }
    5       { set scpfile "gameobjects.scp"
              set section "gameobj $obj_entry"
              set default_quest [GetScpValue $scpfile $section "sound1"]
            }
    default { set scpfile "creatures.scp"
              set section "creature $obj_entry"
              set default_quest ""
            }
  }
  set squests [join [GetScpValue $scpfile $section "starts_quests"]]

  # Items and GOs have special keys (startquest and sound1) which trigger quest
  # processing and provide a quest ID. The key must exist even if the object 
  # only finishes the quest, so now it must be determined now whether it's the
  # quest starter, the finisher or both. Note the WoWQT may omit the 
  # starts_quests key when the object can only start one quest while the 
  # finishes_quests key always exists as soon as the object finishes a quest.
  if {$default_quest != ""} {
    set fquests [join [GetScpValue $scpfile $section "finishes_quests"]]  
    set starter [GetScpValue quests.scp "quest $default_quest" "started_by"]
    set finisher [GetScpValue quests.scp "quest $default_quest" "finished_by"]
    if {[lsearch [concat $squests $fquests] $default_quest] == -1 ||
        $starter == $finisher} {
      lappend squests $default_quest
    }
  }

  set plevel [GetLevel $player]
  set avail ""; set notyetavail "";

  foreach quest $squests {
    set section "quest $quest"
    set qtflags [join [GetScpValue "quests.scp" $section "qtflags"]]

    # check quest status
    if {([GetQuestStatus $player $quest] != 4) ||
        (([GetQFlag $player q$quest] || [GetQFlag $player Q$quest]) &&
         ([lsearch $qtflags "repeatable"]==-1))
    } then continue

    # check whether disabled
    if {[lsearch $qtflags "disabled"]>-1} {continue}

    # check requirements
    set requirements [join [GetScpValue "quests.scp" $section "requirements"]]
    if ![CheckReqs $player $requirements $obj] {continue}

    # check whether escort quest and NPC near to start WP
    if {[GetObjectType $obj] == 3} {
      set start_wp [lindex [GetScpValue quests.scp $section escort] 0 0]
      if [string is integer -strict $start_wp] {
        set startpos [join [GetScpValue waypoints.scp "point $start_wp" pos]]
        if {[GetDistance $obj $startpos] > 20} continue
        # check whether NPC is already on an escort mission
        set edata [GetQFlagData $obj escort_data]
        if {$edata != "" && [lindex $edata 0] != $quest} continue
      }
    }

    # check whether event (=unique) quest
    if {[info exists uquests_enabled] && $uquests_enabled} {
      set qunique [join [GetScpValue "quests.scp" $section "unique"]]
      if {($qunique == 1) &&
          (([info exists uquests_started]) &&
           ([lindex $uquests_started $quest] > -1))
      } then continue;
    }

    # check player level
    set qlevels [join [GetScpValue "quests.scp" $section "levels"]]
    if {$plevel<[lindex $qlevels 0]
    } then {lappend notyetavail $quest
    } else {lappend avail $quest}
  }
  return [list $avail $notyetavail]
}

proc CheckReqs {player requirements {obj 0}} {
  set plevel [GetLevel $player]
  set prace [GetRace $player]
  set pclass [GetClass $player]
  set reqsok 1

  foreach elem $requirements {
    set rtype [string range [string tolower $elem] 0 0]
    if {$rtype == "!"
    } then { set logop "!"
             set rtype [string range $elem 1 1]
             set elem [string range $elem 2 end]
    } else { set logop ""; set elem [string range $elem 1 end] }
    set ps [split $elem |]
    switch $rtype {
      r { # check race reqs
          if {[lsearch $ps $prace]==-1} {set reqsok 0}
        }

      c { # check class reqs
          if {[lsearch $ps $pclass]==-1} {set reqsok 0}
        }
      l { # level reqs, format: l<minlevel>-<maxlevel> OR l<minlvl>..<maxlvl> OR
          #                     l<minlevel>
          set minlevel ""
          set maxlevel ""
          if {[string first "-" $ps] > -1} {
            foreach {minlevel maxlevel} [split $ps -] break
          } else {
            foreach {minlevel dummy maxlevel} [split $ps ..] break
          }
          set reqsok [expr {[string is integer -strict $minlevel] &&
                            $plevel >= $minlevel &&
                            (![string is integer -strict $maxlevel] || 
                             $maxlevel <= $minlevel || $plevel <= $maxlevel)}]
        }
      p { # check reputation level
          if {!$obj || [GetObjectType $obj] != 3 ||
              ![string is integer -strict $ps]} {
            set reqsok 0
          } else {
            set repu [::GetReputation $player $obj]
            set repu_stages "42000 21000 9000 3000 0 -3000 -6000"
            set repu_level 4
            foreach repu_stage $repu_stages {
              if {$repu < $repu_stage} {incr repu_level -1} break
            }
            if {$repu_level < $ps} {set reqsok 0}
          }
        }
      q { # check quest reqs
          set reqsok 0
          foreach rq $ps {
            # check whether required quest has been completed before and
            # in case of the not operator also whether it has been started
            if [string is integer -strict $rq] {
              if {([GetQFlag $player Q$rq] || [GetQFlag $player q$rq]) ||
                  (($logop == "!") && ([GetQuestStatus $player $rq] < 4))} {
                set reqsok 1
                break
              }
            } else {
              set reqsok [GetQFlag $player $rq]
              if $reqsok break
            }  
          }
        }
      s { # check skill reqs, format: s<skillid>:<slevel>
          set reqsok 0;
          foreach rs $ps {
            set rsid [lindex [split $rs :] 0]
            set rslvl [lindex [split $rs :] 1]
            if {[GetSkill $player $rsid] >= $rslvl} {
              set reqsok 1
              break
            }
          }
        }
      default {set reqsok 1}
    }
    set reqsok [expr $logop$reqsok]
    if !$reqsok {break}
  }
  return $reqsok
}

proc GetFinishableQuests { obj player } {
  # returns the list of right-now finishable quests, the list of incomplete
  # quests with incomplete-text which can be finished if they become complete
  # and the list of later finishable started quests without incomplete text,
  # which have been started by the NPC:
  # {finishable} {later finishable with itext} {later finishable w/o itext}
  set obj_entry [GetEntry $obj]
  set obj_type [GetObjectType $obj]
  switch $obj_type {
    1       { set scpfile "items.scp"
              set section "item $obj_entry"
              set default_quest [GetScpValue $scpfile $section "startquest"]
            }
    5       { set scpfile "gameobjects.scp"
              set section "gameobj $obj_entry"
              set default_quest [GetScpValue $scpfile $section "sound1"]
            }
    default { set scpfile "creatures.scp"
              set section "creature $obj_entry"
              set default_quest ""
            }
  }
  set fquests [join [GetScpValue $scpfile $section "finishes_quests"]]
  set squests [join [GetScpValue $scpfile $section "starts_quests"]]

  if {($default_quest != "") &&
      ([lsearch [concat $squests $fquests] $default_quest]==-1)
  } {lappend squests $default_quest}

  set finishable ""; set incomplete ""; set incomplete2 "";
  foreach fquest $fquests {
    set qs [GetQuestStatus $player $fquest]
    if {$qs < 1 || $qs > 3} continue
    set section "quest $fquest"
    set deststatus 3
    set qtflags [join [GetScpValue "quests.scp" $section "qtflags"]]
    if {[lsearch $qtflags "skip"]<0} {
      if {[join [GetScpValue "quests.scp" $section "kill"]] != ""
      } then { set mtype "kill"
      } else {
        if {[join [GetScpValue "quests.scp" $section "explore"]] != "" ||
            [join [GetScpValue "quests.scp" $section "escort"]] != ""
        } then { set mtype "explore"
        } else { set mtype "" }
      }
      if { $mtype != ""
      } then { set deststatus 1
      } else {
        set deliveritem [join [GetScpValue "quests.scp" $section "deliver"]]
        set victim [join [GetScpValue "quests.scp" $section "kill"]]
        if {($deliveritem != "") && ($victim =="")} {
          # deliver quests normaly require q-status 1, but there is a
          # special case: if you right after accepting the quest already have
          # all items to deliver, either because they are source items or the
          # item which started the quest, you never get q-status 1
          # Unfortunately here is currently no way to check if there are more
          # deliver keys so if you get items to deliver at start and also have
          # to find some more, the items to find may get ignored and the quest
          # can be finished without them
          set started_by [join [GetScpValue "quests.scp" $section "started_by"]]
          if {[string tolower [string range $started_by 0 2]] == "itm"
          } then { set start_item [string range $started_by 3 end]
          } else { set start_item "" }

          set source_item [join [GetScpValue "quests.scp" $section "src_item"]]
          if {[llength $start_item] == 1} {lappend start_item 1}
          if {[llength $source_item] == 1} {lappend source_item 1}
          if {[llength $deliveritem] == 1} {lappend deliveritem 1}
          if {($source_item != $deliveritem) && ($start_item != $deliveritem)} {
            set deststatus 1
          }
          set mtype "deliver"
        }
      }
    }

    if {$qs <= $deststatus
    } then { lappend finishable $fquest
    } else {
      # add to incomplete if quests that are later finishable by current object
      if {$qs == 3} {
        if {($mtype != "explore") &&
           ([join [GetScpValue "quests.scp" $section "incomplete"]] != "")
        } then {lappend incomplete $fquest; #not exploration and has itext
        } elseif {($obj_type == 3) && ([lsearch $squests $fquest] > -1)}  {
           lappend incomplete2 $fquest
        }
      }
    }
  }
  # process skipped quests which normally are not finished by this object
  foreach squest $squests {
    if {([lsearch $finishable $squest] == -1) &&
        ([lsearch "2 3" [GetQuestStatus $player $squest]]>-1)
    } then {
      set section "quest $squest"
      set qtflags [join [GetScpValue "quests.scp" $section "qtflags"]]
      if {[lsearch $qtflags "skip"]>-1} {lappend finishable $squest}
    }
  }

  return [list $finishable $incomplete $incomplete2]
}

proc CmdQuestRoute {player cargs} {
  variable quest_route
  variable quest_route_data
  variable quest_route_info
  set subcommand [lindex $cargs 0]
  set cargs [lrange $cargs 1 end]
  set QUEST_WP_FILE "scripts/waypoints_quests.scp"

  switch $subcommand {
    start {
      # example: .qr start q111000 20000
      if [info exists quest_route_info] {
        foreach {starter quest startwp} $quest_route_info break
        return "There is already a quest route under work by $starter for quest\
                $quest starting with WP $startwp, you must enter .qr abort to\
                delete it."
      }

      foreach {quest startwp} $cargs break
      if {[llength $cargs] < 2 ||
          ![string is integer -strict $startwp] ||
          [string tolower [string range $quest 0 0]] != "q" ||
          ![string is integer -strict [string range $quest 1 end]]} {
        return "Syntax: .qr start q<id> <startwp>"
      }
      set quest [string range $quest 1 end]
      set quest_name [join [GetScpValue "quests.scp" "quest $quest" "name"]]
      if {$quest_name == ""} {
        return "Error: Quest not found."
      }
      set quest_route ""
      set quest_route_data ""
      set quest_route_info [list [GetName $player] $quest $startwp]
      rename ::WoWEmu::Commands::retcl ::WoWEmu::Commands::retcl_original
      proc ::WoWEmu::Commands::retcl {player cargs} {
        set txt "retcl is disabled due to quest route creation\
                by [GetName $player], type .qr abort to abort it."
        return "[::Custom::Color $txt AQUA]"
      }
      return "OK, new escort route started for quest $quest ('$quest_name')\
             starting at WP $startwp. Use .qr addwp to add more points,\
             .qr save to save it and .qr abort to cancel it."
    }

    abort {
      if [info exists quest_route_info] {
        foreach {starter quest startwp} $quest_route_info break
        unset quest_route
        unset quest_route_data
        unset quest_route_info
        rename ::WoWEmu::Commands::retcl ""
        rename ::WoWEmu::Commands::retcl_original ::WoWEmu::Commands::retcl
        return "Escort route for quest $quest deleted."
      } else {
        return "No quest route was started!"
      }
    }

    addwp {
      if ![info exists quest_route_info] {return "No route started!"}
      foreach {starter quest startwp} $quest_route_info break
      if {$starter != [GetName $player]} {
        return "Error: You can't add WPs to a quest route started by another\
                GM ($starter)!"
      }
      lappend quest_route [lrange [GetPos $player] 1 end]
      set wpc [llength $quest_route]
      set cur_id [expr $wpc + $startwp - 1]

      # check for additonal key=value pairs to save with the point, strings
      # with spaces are allowed as values, values with "=" chars are forbidden      
      set cargs [split $cargs =]
      set key [lindex $cargs 0]
      set cargs [lrange $cargs 1 end]
      set cnt 1
      set cur_pd ""
      foreach elem $cargs {
        if {$key == ""} break
        if {$cnt < [llength $cargs]
        } then {set val [lrange $elem 0 end-1]
        } else {set val $elem}
        incr cnt
        if {$val == ""} break
        lappend cur_pd "$key=$val"
        set key [lindex $elem end]     
      }
      lappend quest_route_data $cur_pd
      # puts "qrd: $quest_route_data"
      return "OK, WP #$wpc with ID $cur_id added."
    }

    save {
      if ![info exists quest_route_info] {return "No route started!"}
      foreach {starter quest startwp} $quest_route_info break
      if {$starter != [GetName $player]} {
        return "Error: You can't save a quest route started by another\
                GM ($starter)! Use .qr abort to delete it if needed."
      }
      if {[llength $quest_route] < 2} {
        return "Error: Not enough WPs, add more!"
      }

      set cur_id $startwp
      set last_xyz [lindex $quest_route end]
      set hwpscp [open $QUEST_WP_FILE a]
	    foreach xyz $quest_route {
	      set point_data [lindex $quest_route_data 0]
	      set quest_route_data [lrange $quest_route_data 1 end]
	      puts $hwpscp "\[point $cur_id\]"
	      puts $hwpscp "pos=$xyz"
	      puts $hwpscp "quest=$quest"
        foreach line $point_data {puts $hwpscp $line}

	      puts $hwpscp "next=$cur_id"
	      if {$xyz != $last_xyz} {puts $hwpscp "next_qwp=[expr $cur_id + 1]"}
	      puts $hwpscp "script=::MasterScript::OnWaypointReached"
	      puts $hwpscp ""
	      incr cur_id
      }
	    close $hwpscp
	    unset quest_route
	    unset quest_route_data
	    unset quest_route_info
	    rename ::WoWEmu::Commands::retcl ""
	    rename ::WoWEmu::Commands::retcl_original ::WoWEmu::Commands::retcl
      return "OK, quest route saved."
    }
    default {
      return "Usage:[Custom::Color ".qr \[ start \| addwp \| save \| abort \]"\
                     white]"
    }
  }
}

proc OnWaypointReached {npc} {
  set locked_until [GetQFlagData $npc locked_until]
  set edata [GetQFlagData $npc escort_data]
  set wp [lindex $edata 0]
  set quest [lindex $edata 1]
  set escort [lrange $edata 2 end]

  # if invalid data or other error, abort quest route
  if ![string is integer -strict $wp] {
    SetWayPoint $npc {}
    return
  }
  set wp_section "point $wp"
  set wp_pos [join [GetScpValue waypoints.scp $wp_section pos]]
  # script often gets triggered although the NPC has not exactly reached the WP
  if {[GetDistance $npc $wp_pos] > 0} return

  # if no lock exists, the NPC has just reached the WP, time to process delay,
  # connect to AI and do other stuff if any
  if ![string is integer -strict $locked_until] {
    set delay [GetScpValue waypoints.scp $wp_section delay]
    if [string is integer -strict $delay] {
      set locked_until [expr [clock seconds] + $delay]
      SetQFlagData $npc locked_until $locked_until
    } else {
      set locked_until 0
    }
    set txt [join [GetScpValue waypoints.scp $wp_section "text"]]
    if {$txt != ""} {Say $npc 0 $txt}
    # tactic processing, requires SmartAI
    if [namespace exists ::SmartAI] {
      set tactic [GetScpValue waypoints.scp $wp_section "tactic"]
      if {[string is integer -strict $tactic] &&
          [set npcobj [::SmartAI::GetMobObject $npc]] != ""} {
        $npcobj SwitchTactic $tactic
      }
    }
  }

  # if NPC is "locked", simply do nothing and wait for next loop
  if {[clock seconds] <= $locked_until} return
  ClearQFlagData $npc locked_until

  set next_wp [GetScpValue waypoints.scp $wp_section next_qwp]

  # if a next WP is defined, then move on
  if [string is integer -strict $next_wp] {
    set edata [concat $next_wp $quest $escort]
    SetQFlagData $npc escort_data $edata
    SetWayPoint $npc $next_wp
    return
  }

  # if there is no active quest, it must have ended and NPC will teleported back
  if ![string is integer -strict $quest] {
    ClearQFlagData $npc escort_data
    ClearQFlagData $npc locked_until
    SetWayPoint $npc {}    
    return
  }

  # if no "actual" next wp is defined, the quest ends
  foreach player $escort {
    if {[Distance $npc $player] < 35} {SendQuestComplete $player $quest}
  }
  set edata $wp
  SetQFlagData $npc escort_data $edata

  # set new (additional) lock to give players a chance to talk to the NPC
  set locked_until [expr [clock seconds] + 30]
  SetQFlagData $npc locked_until $locked_until
}

proc LoadMenus { } {
  if [namespace exists menus] {namespace delete menus}
  namespace eval menus {
    set dfile "scripts/dialogs.txt"
    if ![file exists $dfile] {set dfile "scripts/menus.txt"}
    if [file exists $dfile] {
      set menfile [open $dfile r]
      set mid ""; set text ""
      while {![eof $menfile]} {
        gets $menfile line
        set line [string trim $line]
        # check if entry start
        if {([string length $line]>14) &&
            ([string range $line 0 8] == "\[moption ") &&
            ([string range $line end end] == "\]") &&
            ([set nid [string trim [string range $line 9 end-1]]] != "")
        } then {
                if {($mid != "") && ($text != "")} {
                  lappend $mid [list $reqs $answerids0 $answerids1\
                    $link0 $link1 $emote0 $emote1 $tcl0 $tcl1 $icon $text]
                }
                set mid [string replace $nid 0 2\
                        [string toupper [string range $nid 0 2]]]
                set answerids0 ""; set answerids1 ""; set emote0 "";
                set emote1 ""; set icon ""; set link0 ""; set link1 "";
                set text "";set tcl0 ""; set tcl1 ""; set reqs "";

                  # check if key=value
        } elseif {($mid != "") &&  ([set p [string first "=" $line]]>3)} {

           set key [string tolower [string range $line 0 [expr $p - 1]]]
           set val [string range $line [expr $p + 1] end]
           # remove quotes
           set orgval $val
           regsub -all {"} $val {'} val

           if {$key != ""} {
             switch -glob $key {
               answer0*      -
               answer1*     {continue; # only answerid is important here}
               link         {set link0 $val}
               tcl0*        {append tcl0 "$orgval\x0d\x0a"}
               tcl1*        {append tcl1 "$orgval\x0d\x0a"}
               requirements {set reqs $val}
               default      {set $key $val}
             }
           }
        }
        if {[eof $menfile] && ($text != "")} {
          lappend $mid [list $reqs $answerids0 $answerids1 $link0 $link1\
                        $emote0 $emote1 $tcl0 $tcl1 $icon $text]
        }
      }; # while
      close $menfile
    }
  }; # namespace menus
}
# script initialization
LoadMessages;
LoadMenus;

::Custom::AddCommand {"qr" ::MasterScript::CmdQuestRoute 4}

variable VERSION 3.5.5
variable loadinfo "MasterScript v$VERSION by smartwork loaded"
if {![info exists ::VERBOSE] || $::VERBOSE > 0} {
  puts "[Custom::LogPrefix]$loadinfo"
}
StartTCL::Provide MasterScript $VERSION
#--- end of namespace MasterScript ---
}




namespace eval Friends {

	# defaults (if you have scripts.conf, use it to change values)
	variable SERVER_UPDATING 1
	variable LIST_LIMIT 50

	variable VERSION 0.60
	variable USE_CONF_FILE 1

	if { $USE_CONF_FILE } { ::Custom::LoadConf }

	if { [info procs ::Custom::ReadOnline] != "" } {
		proc Commands { player cargs } {
			set count 0
			set answer "FRIENDLIST_UPDATE"
			Custom::ReadOnline
			foreach friend_name $cargs {
				# name race class level map zone
				append answer "," [join [Custom::GetOnlineData $friend_name] ","]
				if { [incr count] >= $::Friends::LIST_LIMIT } { break }
			}
			return $answer
		}
		if { !$SERVER_UPDATING } { proc Commands { args } {} }
		Custom::AddCommand "friends" "Friends::Commands"
	} else {
		proc Commands { args } {}
	}

	::StartTCL::Provide
}









