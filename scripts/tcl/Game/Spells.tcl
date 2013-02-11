#SPELLS.TCL

#
# StartTCL: z
#


#  Ritual of Summoning
#  by HW2
# V.1.5  - controllo istance e tempo di ricarica

namespace eval ::ritualofsummoning { }

# controllo instance 
   proc ::Custom::IsInDoors { from } { 
      variable ALLOWED_MAPS {0 1 30 209 309 451 489 529}

      set map [lindex [GetPos $from] 0] 
      if { [lsearch $ALLOWED_MAPS $map] >= 0 } { 
         return 0 
      } 
      return 1 
   }
 
# fine

#
# Altri controlli utili:
# if { [GetHealthPCT $to] >= 100 } {  } else { return [ ::Texts::Get "Il player selezionato deve prima curarsi" ] }
#

proc ::ritualofsummoning::Ritual { from } { 
  
  set to [ ::GetSelection $from ]
  
  set side [::Custom::GetPlayerSide $to]

     
     if { [ ::GetObjectType $to ] != 4 } {return [::Say $from 0 "I must select a player" ]}
     if { [::Custom::IsInDoors $from] } { return [ ::Say $from 0 "I can't teleport him inside here" ]} 
     if { [::Custom::GetPlayerSide $from] != $side } { return [ ::Texts::Get "The selected player is of the opposite faction" ] }
     if { [::GetQFlag $to hooked] || [::GetQFlag $from hooked] } {return [::Say $from 0 "I can't! I'm in combat! ." ] }
     if { [ ::GetQFlag $from "jailed" ] } {return [::Say $from 0 "I can't teleport him, he is jailed" ] }

       set now [ clock seconds ]
       if { [ file exists "data/warlock_ros/[GetName $from]" ] } {
       set handle [open "data/warlock_ros/[GetName $from]" r]
       gets $handle ros_time
       close $handle 

     if { [expr { $now - $ros_time }] < 600  } { return [::Say $from 0 "[expr { $now - $ros_time  }] sec. past, is too soon! I have to wait that the 600 seconds expire"]}
     if { [ConsumeItem $from 6265 1] == 0 } { return [::Say $from 0 "There isn't a Soulshard in my backpack" ] }
     
      set handle [open "data/warlock_ros/[GetName $from]" w]
      puts $handle $now
      close $handle
     
   variable rofpos
   set player_name [::GetName $from]
   set rofpos($player_name) [ lindex [ ::GetPos $from ] ]
   foreach { m x y z } $rofpos($player_name) {}
   ::Teleport $to $m $x $y $z 


} else {
     
     if { [ConsumeItem $from 6265 1] == 0 } { return [::Say $from 0 "There isn't a Soulshard in my backpack" ] }

     set handle [open "data/warlock_ros/[GetName $from]" w]
     puts $handle $now
     close $handle

   variable rofpos
   set player_name [::GetName $from]
   set rofpos($player_name) [ lindex [ ::GetPos $from ] ]
   foreach { m x y z } $rofpos($player_name) {}
   ::Teleport $to $m $x $y $z 

   }
}


proc ::ritualofsummoning::Init { } {


::Custom::AddLegacySpellScript {   

  698  { ritualofsummoning::Ritual $from }
}

}

::ritualofsummoning::Init



#HW2 fix

namespace eval Risorgo {

::Custom::AddCommand "recc" ::WoWEmu::Commands::recc 0

proc ::WoWEmu::Commands::recc { player cargs } {
if { [GetHealthPCT $player] <= 0 } {
if { [GetClass $player] == 7 && [ConsumeItem $player 17030 1] != 0 } {
set lvl [::GetLevel $player]
AddItem $player 17030 1
if { $lvl < 30 } { return [ ::Texts::Get "Reincarnation can be used at 30 lvl" ] }
set now [clock seconds]
if { [ file exists "data/shaman_res/[GetName $player]" ] } {
set handle [open "data/shaman_res/[GetName $player]" r]
gets $handle res_time
close $handle
if { [expr { $now - $res_time }]>=3600 } {
Say $player 0 " Revive now!"
ConsumeItem $player 17030 1
ClearQFlag $player IsDead
Resurrect $player
CastSpell $player $player 15007
set handle [open "data/shaman_res/[GetName $player]" w]
puts $handle $now
close $handle
} else { Say $player 0 "[expr { $now - $res_time }] sec., you have to wait an hour!"}
} else {
Say $player 0 "Revive now!"
ConsumeItem $player 17030 1
ClearQFlag $player IsDead
Resurrect $player
CastSpell $player $player 15007
set handle [open "data/shaman_res/[GetName $player]" w]
puts $handle $now
close $handle
}
} else {return [ ::Texts::Get "This is a shaman command, and..have you got an Anhk reagent?" ]}
} else {return [::Custom::Color [ ::Texts::Get "You can use this command in the guild chat if you are die!"] "RED" ]}
}
}



::Custom::AddCommand {	
	"give_rage" ::WoWEmu::Commands::give_rage 0
}

#
# The command for the Rage System
#

proc ::WoWEmu::Commands::give_rage { player cargs } { 

 if { ![ ::GetClass $player ] == 1 || ![ ::GetClass $player ] == 5  } { return}
	CastSpell $player $player 12696
	return
}

namespace eval soulstone {
    proc vol { to from } {
        set currenttime [clock seconds]
        set PName [GetName $from]
        set Tadd [open "data/soulstone/$PName" w]
        puts $Tadd $currenttime
        close $Tadd
        SetQFlag $from soulstone
    }
}

proc ::soulstone::Init { } {
    if { [ info exists "::StartTCL::VERSION" ] } {

        ::Custom::AddLegacySpellScript {
        20707 { soulstone::vol $to $from }
    20762 { soulstone::vol $to $from }
    20763 { soulstone::vol $to $from }
    20764 { soulstone::vol $to $from }
    20765 { soulstone::vol $to $from }
              

        }
    }
}

::soulstone::Init


#
# Additional Spells & Effects script v2.1 (c) Delfin
# creds: seatleson, BAD, DayDream
#
# ====================================
#
# 07-10-2006 Reorganised by AceIndy
#
# Start-TCL 0.9.4 compatible
#
# Fully Autonomous
#

##########
#
# defined namespace
#

### Script Namespaces ###
namespace eval ::Stealth {
    StartTCL::Provide

    variable ::Stealth::PlayerState
    variable ::Stealth::Spells
  array set ::Stealth::Spells {
             1784
             1785
             1786
             1787
             8822
            30831
            30991
            31526
            31621
            32199
            32615
            34189
    }
}

#
# Stealth
#
proc ::Stealth::OnCastStealth { to from spellid } {
    ::SetQFlag $from stealth
}

#
# ClearQflag and break stealthmode
#
proc ::Stealth::BreakStealth { player } {
    ::ClearQFlag $player stealth
    ::CastSpell $player $player 12844
}

#
# Init Procedure
#
proc ::Stealth::Init { } {
    if { [ info exists "::StartTCL::VERSION" ] } {
        ::Custom::HookProc "::AI::CanAgro" {; if { [ ::GetQFlag $victim stealth ] } { return 0 } }
        ::Custom::HookProc "::WoWEmu::DamageReduction" {; if { [ ::GetQFlag $player stealth ] } { ::Stealth::BreakStealth $player } }
        ::Custom::AddSpellScript "::Stealth::OnCastStealth" [ array names ::Stealth::Spells ]
    } else {
        # setup the system to deal with these spells as usual
    }
}

::Stealth::Init


# ====================================
#
# PickPocket script v0.9.4 by skel
#
# ====================================
#

#######################################
#
# defined namespaces
#
package require SQLdb


#######################################
#
# namespace ::Pickpocket
#
namespace eval ::Pickpocket {
    # Enable (1) / disable (0) debugging info
    variable DEBUG 0
    
    variable VERSION 0.9.4
    variable NAME "Pickpocket"
    
    # Cooldown (in seconds) to pickpocket skill
    variable cooldown 60
    
    # SQLdb handle
    variable handle [ ::SQLdb::openSQLdb ]
}


#######################################
#
# procedure ::Pickpocket::doPick
#
#
proc ::Pickpocket::doPick { from to } {
    # Vars
    set target_entry [ ::GetEntry $to ]
    set player_level [ ::GetLevel $from ]
    set player_name [ ::GetName $from ]
    set player_skill 1
    set target_level [ ::GetLevel $to ]    
    set level_diff [ expr abs($target_level - $player_level) ]
    set current_time [ clock seconds ]
    set max_skill [ expr ($player_level * 5 ) ]
    set last_pick 60

    variable handle
    variable DEBUG
    variable cooldown

    # To complete some quests giving the right item
    switch $target_entry {
        6846 { if { [ ::GetQuestStatus $from 2206 ] == 3 } { ::AddItem $from 7675 } }
        6909 { if { [ ::GetQuestStatus $from 2242 ] == 3 } { ::AddItem $from 7737 } }
        6494 { if { [ ::GetQuestStatus $from 1858 ] == 3 } { ::AddItem $from 7208 } }
        6497 { if { [ ::GetQuestStatus $from 1886 ] == 3 } { ::AddItem $from 7231 } }
        7051 { if { [ ::GetQuestStatus $from 2539 ] == 3 } { ::AddItem $from 7923 } }
        6188 { if { [ ::GetQuestStatus $from 8234 ] == 3 } { ::AddItem $from 19775 } }
        8766 { if { [ ::GetQuestStatus $from 8235 ] == 3 } { ::AddItem $from 20023 } }
        6768 { if { [ ::GetQuestStatus $from 8236 ] == 3 } { ::AddItem $from 20022 } }
        5719 { if { [ ::GetQuestStatus $from 8236 ] == 3 } { ::AddItem $from 20022 } }
        7287 { if { [ ::GetQuestStatus $from 2478 ] == 3 } { ::AddItem $from 8072 } }
        default {}
    }

    
    # Check into the database for some register about the player and his last pick
    # If not present create a new entry
    if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT `player_name` FROM `pickpocket` WHERE ( `player_name`='$player_name' ) LIMIT 1" ] } {
        ::SQLdb::querySQLdb $handle "INSERT INTO `pickpocket` ( `player_name`, `last_pick`, `player_skill` )\
            VALUES ( '$player_name', '$last_pick', '$player_skill' )"
    # If present get the lastest values
    } else {
        set last_pick [ ::SQLdb::querySQLdb $handle "SELECT `last_pick` FROM `pickpocket` WHERE ( `player_name`='$player_name' ) LIMIT 1" ]
        set player_skill [ ::SQLdb::querySQLdb $handle "SELECT `player_skill` FROM `pickpocket` WHERE ( `player_name`='$player_name' ) LIMIT 1" ]
    }
    set time_diff [ expr $current_time - $last_pick ]
    
    if { [ ::GetObjectType $to ] == 3 } {
        set target_type [ ::GetScpValue "creatures.scp" "creature $target_entry" "type" ]
        set target_name [ ::GetScpValue "creatures.scp" "creature $target_entry" "name" ]

        if { $target_type == 7 } {
            set object_type_modifier 1

            if { $target_level > 60 } {
                set item_list 8888887
                set item_chance 15
            } elseif { $target_level > 50 } {
                set item_list 8888886
                set item_chance 10
            } elseif { $target_level > 40 } {
                set item_list 8888885
                set item_chance 10
            } elseif { $target_level > 30 } {
                set item_list 8888884
                set item_chance 20
            } elseif { $target_level > 20 } {
                set item_list 8888883
                set item_chance 15
            } elseif { $target_level > 10 } {
                set item_list 8888882
                set item_chance 12
            } elseif { $target_level > 0 } {
                set item_list 8888881
                set item_chance 10
            }
        } else {
            Say $from 0 "|cFFF0002F Nothing to rob"
            ::SQLdb::querySQLdb $handle "UPDATE `pickpocket` SET `last_pick`='$current_time' WHERE ( `player_name`='$player_name' )"
            return
        }
    } else {
        set object_type_modifier 10.0
    }
    

    # Check cooldown time
    if { $time_diff >= $cooldown } {
        if { $target_level >= $player_level } {
            set ratio [ expr ( $target_level * 10 + $player_skill * 10 ) / ( ( $level_diff + 1 ) * 1.0 ) ]
        } else {
            set ratio [ expr ( $target_level * 10 + $player_skill * 10 ) / ( $level_diff * $object_type_modifier ) ]
        }
                
        set random [ expr { int( rand() * $ratio * 2 ) } ]
                

        # Debugging info
        if { $DEBUG } {
            puts "pickpocket: ratio=$ratio"
            puts "pickpocket: random=$random"
               puts "pickpocket: max_skill=$max_skill"
               puts "pickpocket: player_skill=$player_skill"
            puts "pickpocket: target_type=$target_type"
            puts "pickpocket: object_type=[ ::GetObjectType $to ]"
            puts "pickpocket: item_list=$item_list"
        }


        if { $random < $max_skill } {
            # Increase the skill
            if { $player_skill < $max_skill } {
                incr player_skill

                ::SQLdb::querySQLdb $handle "UPDATE `pickpocket` SET `player_skill`='$player_skill' WHERE ( `player_name`='$player_name' )"

                Say $from 0 "|c005555ff Your skill in Pickpocket has increased to $player_skill"
                
            # To avoid null responses when the player is at maximum skill of his level
            # Don't display the message when he is at level 300 in pickpocket also
            } elseif { $player_skill == $max_skill && $player_skill < 300 } {
                Say $from 0 "|c005555ff You have reached the maximum skill in Pickpocket for your level"
            }
        } else {
            # Change the money
            ::ChangeMoney $from $random
            
            if { $random > 100 } {
                set unit "silver"
                set random [ expr $random / 100 ]
            } elseif { $random > 1000 } {
                set unit "gold"
                set random [ expr $random / 1000 ]
            } else {
                set unit "bronze"
            }
    
            set expr1 [ expr int( rand() * 1000 ) + $player_skill ]
            set expr2 [ expr 1000 - $item_chance * 10 ]
    
            if { $expr1 >= $expr2 } {
                set item [ lindex $item_list [ expr int( rand() * [ llength $item_list ] ) ] ]
                ::AddItem $from $item
            
                # Thanks to skitey to add the item name instead the code here =)    
                set itname [ ::GetScpValue "items.scp" "item $item" "name" ]
                        Say $from 0 "I've got one $itname"
            }
                
            Say $to 0 "I'm feeling something strange... Oh, my God, I lost $random $unit!"
        }
    
        # Update the database with last pick time
        ::SQLdb::querySQLdb $handle "UPDATE `pickpocket` SET `last_pick`='$current_time' WHERE ( `player_name`='$player_name' )"
    } else {
        Say $from 0 "|cff008000 I need to wait  [ expr $cooldown - $time_diff ]  seconds"
    }
}


########################################
#
# procedure ::Pickpocket::db
#
#
proc ::Pickpocket::db { player cargs } {
    variable handle
    variable NAME
    variable VERSION
    
    switch -- [ lindex $cargs 0 ] {
        "create" {
            if { ! [ ::SQLdb::existsSQLdb $handle `pickpocket` ] } {
                ::SQLdb::querySQLdb $handle "CREATE TABLE `pickpocket` ( `player_name` TEXT, `player_skill` INTEGER, `last_pick` INTEGER )"
                    
                # register to SQLdb table
                if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT * FROM `$::SQLdb::NAME` WHERE ( `name` = '$NAME' ) LIMIT 1" ] } {
                    ::SQLdb::querySQLdb $handle "INSERT INTO `$::SQLdb::NAME` ( `name`, `version` ) VALUES ( '$NAME', '$VERSION' )"
                } else {
                    set oldver [ ::SQLdb::firstcellSQLdb $handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$NAME')" ]
                    if { [ expr { $oldver > $VERSION } ] } {
                        error "The current version of $NAME ($VERSION) is older that the previous one ($oldver), downgrade unsupported!"
                    } elseif { [ expr { $oldver < $VERSION } ] } {
                        puts "[ ::Custom::LogPrefix ]$NAME: Current version ($VERSION) is newer than the previous one ($oldver)."
                        ::SQLdb::querySQLdb $handle "UPDATE `$SQLdb::NAME` SET\
                            `version` = '$VERSION', `previous` = '$oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$NAME')"
                    }
                }
                return "Pickpocket system database created and registered succesfully"
            } else {
                return "Table pickpocket already exists"
            }
        }
        "upgrade" {
            if { [ ::SQLdb::existsSQLdb $handle `pickpocket` ] } {
                # upgrade routines
                
                # register to SQLdb table
                if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT * FROM `$::SQLdb::NAME` WHERE ( `name` = '$NAME' ) LIMIT 1" ] } {
                    ::SQLdb::querySQLdb $handle "INSERT INTO `$::SQLdb::NAME` ( `name`, `version` ) VALUES ( '$NAME', '$VERSION' )"
                } else {
                    set oldver [ ::SQLdb::firstcellSQLdb $handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$NAME')" ]
                    if { [ expr { $oldver > $VERSION } ] } {
                        error "The current version of $NAME ($VERSION) is older that the previous one ($oldver), downgrade unsupported!"
                    } elseif { [ expr { $oldver < $VERSION } ] } {
                        puts "[ ::Custom::LogPrefix ]$NAME: Current version ($VERSION) is newer than the previous one ($oldver)."
                        ::SQLdb::querySQLdb $handle "UPDATE `$SQLdb::NAME` SET\
                            `version` = '$VERSION', `previous` = '$oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$NAME')"
                    }
                }
                return "Pickpocket system database upgraded succesfully"
            } else {
                return "Table pickpocket not found"
            }  
        }
        "drop" {
            if { [ ::SQLdb::existsSQLdb $handle `pickpocket` ] } {
                ::SQLdb::querySQLdb $handle "DROP TABLE `pickpocket`"
                ::SQLdb::querySQLdb $handle "DELETE FROM `$SQLdb::NAME` WHERE (`name` = '$NAME')"    
                return "Pickpocket system database droped and unregistered succesfully"
            } else {
                return "Table pickpocket not found"
            }
        }
        default {
            return "USAGE: .pickpocketdb <create|drop|upgrade>"
        }
    }
}

########################################
#
# procedure ::Pickpocket
#
#
namespace eval ::Pickpocket {
    # Add the .pickpocketdb command
    ::Custom::AddCommand {
        "pickpocketdb" ::Pickpocket::db 6
    }
    
    ::Custom::HookProc "::AI::ModAgro" {
        if { [ ::GetQFlag $victim stealth ] } {
            if { [ ::GetLevel $npc ] - [ ::GetLevel $victim ] > 3 } {
                ::ClearQFlag $victim stealth
            } else {
                return 0
            }
        }
    }

    ::Custom::HookProc "::WoWEmu::DamageReduction" {
        ::ClearQFlag $player stealth
    }

    ::Custom::AddLegacySpellScript {
        921 { ::Pickpocket::doPick $from $to }
        1784 { ::SetQFlag $from stealth }
        1785 { ::SetQFlag $from stealth }
        1786 { ::SetQFlag $from stealth }
        1787 { ::SetQFlag $from stealth }
        8461 { ::SetQFlag $from stealth }
    }

    ::StartTCL::Provide

    # Debugging info (copy and paste from spirit's honor system =P)
    if { $DEBUG } {
        puts "\n[namespace tail [namespace current]]: *** DEBUG MODE ENABLED ***\n"
        # .eval ::Custom::GetBenchData 1
        foreach proc [lsort [info procs]] {
            if { [string match -nocase "*" $proc] } {
                if { [string first "timestamp" $proc] >= 0 } {
                    puts "Skipped proc: $proc"
                    continue
                }
                ::Custom::TraceCmd [namespace current]::$proc 0
                # Looking for more debugging? Set DEBUG to 2
                if { $DEBUG > 1 } {
                    ::Custom::BenchCmd [namespace current]::$proc 1
                 }
            }
        }
    }
    
}


#
# Name:		ngChanneling.tcl
#
# Version:	0.2.1
#
# Date:		2006-08-31
#
# Description:	NextGen Channeling and Autorepeat Spells System
#
# Authors:	Spirit <thehiddenspirit@hotmail.com>
#		Lazarus Long <lazarus.long@bigfoot.com>
#
#



# variables
namespace eval ::ngChanneling {
	variable VERSION 0.2.1

	# delay last_time duration pos target spellid
	variable Data

	variable Time 0

	variable TriggerSpells
	array set TriggerSpells {
		5143 7268
		5144 7269
		5145 7270
		8416 8419
		8417 8418
		10211 10273
		10212 10274
		25345 25346
	}
}

# trigger channeling spell
proc ::ngChanneling::Trigger { to from spellid } {
	variable Data
	variable TriggerSpells
	set target [ ::GetSelection $from ]

	if { $target } {
		set duration [ lindex $::AI::SpellData($spellid) 2 ]
		set Data($from) [ list 1 [ clock seconds ] $duration [ ::GetPos $from ] $target $TriggerSpells($spellid) ]
	}
}

# maintain channeling spell
proc ::ngChanneling::Maintain { to from spellid } {
	variable Data

	if { ! [ info exists Data($from) ] || [ lindex $Data($from) 5 ] != $spellid } {
		set duration [ expr { [ lindex $::AI::SpellData($spellid) 2 ] - 1 } ]
		set Data($from) [ list 1 [ clock seconds ] $duration [ ::GetPos $from ] $to $spellid ]
	}
}

# maintain area spell every 1s
proc ::ngChanneling::MaintainArea1 { to from spellid } {
	variable Data

	if { ! [ info exists Data($from) ] || [ lindex $Data($from) 5 ] != $spellid } {
		set duration [ expr { [ lindex $::AI::SpellData($spellid) 2 ] - 1 } ]
		set Data($from) [ list 1 [ clock seconds ] $duration [ ::GetPos $from ] $from $spellid ]
	}
}

# maintain area spell every 2s
proc ::ngChanneling::MaintainArea2 { to from spellid } {
	variable Data
puts "**********TRANQUILLITA'***********"
	if { ! [ info exists Data($from) ] || [ lindex $Data($from) 5 ] != $spellid } {
		set duration [ expr { [ lindex $::AI::SpellData($spellid) 2 ] - 2 } ]
		set Data($from) [ list 2 [ clock seconds ] $duration [ ::GetPos $from ] $from $spellid ]
	}
}

# autorepeat spells (autoshot and shoot)
proc ::ngChanneling::AutoRepeat { to from spellid } {
	variable Data

	if { ! [ info exists Data($from) ] || [ lindex $Data($from) 5 ] != $spellid } {
		set Data($from) [ list 2 [ clock seconds ] 3600 [ ::GetPos $from ] $to $spellid ]
	}
}

# global channeling handler
 proc ::ngChanneling::Handler {} {
 	set time [ clock seconds ]

 	if { $time != $::ngChanneling::Time } {
 		set ::ngChanneling::Time $time

 		foreach caster [ array names ::ngChanneling::Data ] {
 			foreach { delay last_time duration pos target spellid } $::ngChanneling::Data($caster) {}

 			if { $delay > $time - $last_time } {
 				continue
 			}

 			if { $duration > 0 && [ ::GetObjectType $caster ] && $pos == [ ::GetPos $caster ] && [ ::GetObjectType $target ] && [ ::GetHealthPCT $target ] } {
 				::CastSpell $caster $target $spellid
 				lset ::ngChanneling::Data($caster) 1 $time
 				lset ::ngChanneling::Data($caster) 2 [ expr { $duration - $delay } ]
 			} else {
 				unset ::ngChanneling::Data($caster)
 			}
 		}
 	}
 }

# ".channeling" command
proc ::ngChanneling::CommandUpdate { player cargs } {
	variable Data

	if { [ info exists Data($player) ] } {
		foreach { delay last_time duration pos target spellid } $Data($player) {}

		if { $delay > [ set time [ clock seconds ] ] - $last_time } {
			return "SPELLCAST_CHANNEL_START,$delay"
		}

		if { $duration > 0 && $pos == [ ::GetPos $player ] && [ ::GetObjectType $target ] && ! [ string is false [ ::GetHealthPCT $target ] ] } {
			lset Data($player) 1 $time
			lset Data($player) 2 [ expr { $duration - $delay } ]
			::CastSpell $player $target $spellid

			return
		} else {
			unset Data($player)
		}
	}

	return "SPELLCAST_CHANNEL_STOP"
}

# ".channeling_auto" command
proc ::ngChanneling::CommandAuto { player cargs } {
	if { [ set class [ ::GetClass $player ] ] == 3 } {
		::ngChanneling::AutoRepeat [ ::GetSelection $player ] $player 75
	} elseif { [ lsearch { 5 8 9 } $class ] >= 0 } {
		::ngChanneling::AutoRepeat [ ::GetSelection $player ] $player 5019
	}

	return
}

# ".channeling_stop" command
proc ::ngChanneling::CommandStop { player cargs } {
	variable Data

	unset -nocomplain Data($player)

	return
}

# ".channeling_addon" command
proc ::ngChanneling::CommandAddOn { player cargs } {
	# todo
	#::ngChanneling::SetAddOn $player $cargs

	return
}

# initialization
proc ::ngChanneling::Init {} {

	# hook the handler
	#foreach proc { ::AI::CanUnAgro ::WoWEmu::DamageReduction } {
	#	::Custom::HookProc $proc [ info body ::ngChanneling::Handler ]
	#}

	# register the commands for the addon
	::Custom::AddCommand "channeling" "::ngChanneling::CommandUpdate"
	::Custom::AddCommand "channeling_auto" "::ngChanneling::CommandAuto"
	::Custom::AddCommand "channeling_stop" "::ngChanneling::CommandStop"
	::Custom::AddCommand "channeling_addon" "::ngChanneling::CommandAddOn"

	# decrease duration when hit
	::Custom::HookProc "::WoWEmu::DamageReduction" {
		if { [ info exists ::ngChanneling::Data($player) ] } {
			lset ::ngChanneling::Data($player) 2 [ expr { [ lindex $::ngChanneling::Data($player) 2 ] - 1 } ]
		}
	}

	# Arcane Missiles
	::Custom::AddSpellScript "::ngChanneling::Trigger" [ array names ::ngChanneling::TriggerSpells ]

	# Arcane Missile, Starshards, Mind Flay, Drain Mana, Drain Life
	::Custom::AddSpellScript "::ngChanneling::Maintain" {
		7268 7269 7270 8419 8418 10273 10274 25346
		10797 19296 19299 19302 19303 19304 19305
		15407 17311 17312 17313 17314 18807
		5138 6226 11703 11704 689
	        699 709 7651 11699 11700
	}

	# Hurricane, Blizzard, Evocation
	::Custom::AddSpellScript "::ngChanneling::MaintainArea1" {
		16914 17401 17402
		10 6141 8427 10185 10186 10187
		12051
	}

	# Tranquility, Rain of Fire
	::Custom::AddSpellScript "::ngChanneling::MaintainArea2" {
		740 8918 9862 9863
		5740 6219 11677 11678
	}

	# Auto Shot, Shoot
	::Custom::AddSpellScript "::ngChanneling::AutoRepeat" { 75 5019 }

	::StartTCL::Provide
}


::ngChanneling::Init




namespace eval Teleporter {
proc GossipSelect { npc player option } {
set teleporter [GetEntry $npc]
switch $option {
0 { switch $teleporter {
129 {Teleport $player 0 -8960.140625 516.265686 96.356819;}
130 {Teleport $player 0 -5032 -819 495;}
131 {Teleport $player 1 1552.499268 -4420.658691 8.948024;}
132 {Teleport $player 0 1819.708374 238.789505 60.532143;}
133 {Teleport $player 1 9951.792969 2145.915771 1327.724854;}
134 {Teleport $player 1 -1391.0 140.0 22.478;}
}
}
1 {}
}
SendGossipComplete $player
}
proc QuestStatus { npc player } {
set frac [Custom::GetPlayerSide $player]
set teleporter [GetEntry $npc];
if {[Distance $npc $player]>=10} {return 0;}
switch $teleporter {
129 {if {$frac==1} { return }}
130 {if {$frac==1} { return }}
131 {if {$frac==2} { return }}
132 {if {$frac==2} { return }}
133 {if {$frac==1} { return }}
134 {if {$frac==2} { return }}
}
SendSwitchGossip $player $npc 1
SendGossip $player $npc { text 0 "Yes" } { text 0 "No" }
return 0
}
} 

# ====================================
#
# Additional Spells & Effects script v2.1 (c) Delfin 
# creds: seatleson, BAD, DayDream
#
# ====================================
#
# 07-10-2006 Reorganised by AceIndy
#
# Start-TCL 0.9.4 compatible
#
# Fully Autonomous
#

##########
#
# defined namespace
#

### Script Namespaces ###
namespace eval ::Judgement {
	StartTCL::Provide

	variable ::Judgement::Spells
	array set ::Judgement::Spells {
		20154	20187
		20287	20280
		20288	20281
		20289	20282
		20290	20283
		20291	20284
		20292	20285
		20293	20286
		20375	20467	
		20915	20963
		20918	20964
		20919	20965
		20920	20966
		20165	50090
		20347	50091
		20348	50092
		20349	50093
		20166	50094
		20356	50095
		20357	50096
		21082	21183
		21062	21088
		20305	20300
		20306	20301
		20307	20302
		20308	20303
		20271	0		
	}
}
#
# Judgement
#
	proc ::Judgement::OnCastJudgement { to from spellid } {
		variable Seal
		if { $spellid == 20271 } {
			if { [ info exists Seal($from) ] && [expr ($Seal($from) > 0) ] } {
			  if { [expr ($Seal($from) < 50000 ) ] } {
					::CastSpell $from $to $Seal($from)
				} else {
					::CastSpell $from $from $Seal($from)
				}
				set Seal($from) 0
				return
			}
			return
		}
		set Seal($from) $::Judgement::Spells($spellid)
	}


#
# Init Procedure
#
proc ::Judgement::Init { } {
	if { [ info exists "::StartTCL::VERSION" ] } {
		::Custom::AddSpellScript "::Judgement::OnCastJudgement" [ array names ::Judgement::Spells ]
	} else {
		# setup the system to deal with these spells as usual
	}
}

::Judgement::Init


# ====================================
#
# Additional Spells & Effects script v2.1 (c) Delfin 
# creds: seatleson, BAD, DayDream
#
# ====================================
#
# 07-10-2006 Reorganised by AceIndy
#
# Start-TCL 0.9.4 compatible
#
# Fully Autonomous
#

##########
#
# defined namespace
#

### Script Namespaces ###
namespace eval ::HunterTraps {
	StartTCL::Provide
}

if { [ info procs "::HunterTraps::DismissTrap" ] == "" } {
	proc ::HunterTraps::DismissTrap { from } {
		# just ignore for now
		#::Custom::Error "::HunterTraps::DismissTrap undefined"
	}
}

# Hunter traps dismiss:
::Custom::AddLegacySpellScript {
	13797 { HunterTraps::DismissTrap $from }
	14298 { HunterTraps::DismissTrap $from }
	14299 { HunterTraps::DismissTrap $from }
	14300 { HunterTraps::DismissTrap $from }
	14301 { HunterTraps::DismissTrap $from }
	 3355 { HunterTraps::DismissTrap $from }
	14308 { HunterTraps::DismissTrap $from }
	14309 { HunterTraps::DismissTrap $from }
	13810 { HunterTraps::DismissTrap $from }
	13812 { HunterTraps::DismissTrap $from }
	14314 { HunterTraps::DismissTrap $from }
	14315 { HunterTraps::DismissTrap $from }
}


#
# Name: DruidForms.tcl
#
# Description: 3rd party commands and procedures
#
#
# Created by MESTER
# FileServing Now \/\/0\/\/ Services,
# - The Devolepment On Bugs
#

namespace eval DruidFormLoader {
set loadinfo "\nStarting Load Druid Form Script..."
puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo"
}

# Aquatic Form - Alliance
# Level 16
# Price: 18000
# Info: Shapeshift into aquatic form, increasing swim speed by 50% and allowing the druid to breath underwater.
namespace eval DruidFormAquatic_A {
proc QueryQuest { npc player questid } {
set Glasse [GetClass $player]
set GLevel [GetLevel $player]
set GRaces [GetRace $player]
if { ($Glasse == 11)&&($GLevel >= 16) } {
if { ($GRaces == "1") || ($GRaces == "3") || ($GRaces == "4") || ($GRaces == "7") } { CastSpell $player $player 1066 }
}
}
puts "- Loaded: Aquatic Form (Alliance)"
}

# Aquatic Form - Horde
# Level 16
# Price: 18000
# Info: Shapeshift into aquatic form, increasing swim speed by 50% and allowing the druid to breath underwater.
namespace eval DruidFormAquatic_H {
proc QueryQuest { npc player questid } {
set Glasse [GetClass $player]
set GLevel [GetLevel $player]
set GRaces [GetRace $player]
if { ($Glasse == 11)&&($GLevel >= 16) } {
if { ($GRaces == "2") || ($GRaces == "5") || ($GRaces == "6") || ($GRaces == "8") } { CastSpell $player $player 1066 }
}
}
puts "- Loaded: Aquatic Form (Horde)"
}

# Tree Form - Alliance
# Level 44
# Price: 1540000
# Info: Shapeshift into a tree form, removing all harmful physical effects and protecting from all physical attacks for 8 sec, but during that time you cannot attack, move or cast spells.
namespace eval DruidFormTree_A {
proc QueryQuest { npc player questid } {
set Glasse [GetClass $player]
set GLevel [GetLevel $player]
set GRaces [GetRace $player]
if { ($Glasse == 11)&&($GLevel >= 44) } {
if { ($GRaces == "1") || ($GRaces == "3") || ($GRaces == "4") || ($GRaces == "7") } { CastSpell $player $player 775 }
}
}
puts "- Loaded: Tree Form (Alliance)"
}

# Tree Form - Horde
# Level 44
# Price: 1540000
# Info: Shapeshift into a tree form, removing all harmful physical effects and protecting from all physical attacks for 8 sec, but during that time you cannot attack, move or cast spells.
namespace eval DruidFormTree_H {
proc QueryQuest { npc player questid } {
set Glasse [GetClass $player]
set GLevel [GetLevel $player]
set GRaces [GetRace $player]
if { ($Glasse == 11)&&($GLevel >= 44) } {
if { ($GRaces == "2") || ($GRaces == "5") || ($GRaces == "6") || ($GRaces == "8") } { CastSpell $player $player 775 }
}
}
puts "- Loaded: Tree Form (Horde)"
}

namespace eval DruidFormFinish {
set finishinfo1 "Completed Loading Druid Transform Script"
set finishinfo2 "Created by Tha-Doctor"
puts "$finishinfo1\n$finishinfo2\n"
}


# Name:		ShamanForms.tcl
#
# Description:	3rd party commands and procedures
#
#
# Created by Tha-Doctor
# FileServing Now WoW Services,
# - The Devolepment On Bugs
#

namespace eval ShamanFormLoader {
  set loadinfo "\nStarting Load Shaman Form Script..."
  puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo" 
}

# Furbolg Form
# Level 16
# Price: 18000
# Info: Transforms you into a Furbolg for 3 min.
namespace eval ShamanFormFurbolg {
  proc QueryQuest { npc player questid } {
    set Glasse [GetClass $player]
    set GLevel [GetLevel $player]
    set GRaces [GetRace $player]
    if { ($Glasse == 7)&&($GLevel >= 16) } {
      if { ($GRaces == "2") || ($GRaces == "5") || ($GRaces == "6") || ($GRaces == "8") } { CastSpell $player $player 6405 }
    }
  }
  puts "- Loaded: Furbolg Form"
}

# Owl Form
# Level 20
# Price: 124000
# Info: Transforms you into an Owl.
namespace eval ShamanFormOwl {
  proc QueryQuest { npc player questid } {
    set Glasse [GetClass $player]
    set GLevel [GetLevel $player]
    set GRaces [GetRace $player]
    if { ($Glasse == 7)&&($GLevel >= 20) } {
      if { ($GRaces == "2") || ($GRaces == "5") || ($GRaces == "6") || ($GRaces == "8") } { CastSpell $player $player 8153 }
    }
  }
  puts "- Loaded: Owl Form"
}

namespace eval ShamanFormFinish {
  set finishinfo1 "Completed Loading Shaman Transform Script"
  set finishinfo2 "Created by Tha-Doctor"
  puts "$finishinfo1\n$finishinfo2\n" 
}







namespace eval ChargeSkills { 
	proc Charge { to from } { 
		CastSpell $from $from 12695
	}
	proc ChargeStun { from } {
		set to [GetSelection $from]
		CastSpell $from $to 7922
	}
	
	proc Intercept1 { to from } { 
		CastSpell $from $from 14530
	}
	proc Intercept2 { to from } { 
		CastSpell $from $from 17498
	}
	proc Intercept3 { to from } { 
		CastSpell $from $from 22863
	}
	proc InterceptStun1 { from } {
		set to [GetSelection $from]
		CastSpell $from $to 20253
	}
	proc InterceptStun2 { from } {
		set to [GetSelection $from]
		CastSpell $from $to 20614
	}
	proc InterceptStun3 { from } {
		set to [GetSelection $from]
		CastSpell $from $to 20615
	}
} 



variable ::SpellEffects::LegacySpellScripts
array set ::SpellEffects::LegacySpellScripts {

	  100 { ChargeSkills::Charge $to $from }
	 6178 { ChargeSkills::Charge $to $from }	
	11578 { ChargeSkills::Charge $to $from }
	12695 { ChargeSkills::ChargeStun $from }
	20252 { ChargeSkills::Intercept1 $to $from }
	20616 { ChargeSkills::Intercept2 $to $from }	
	20617 { ChargeSkills::Intercept3 $to $from }
	14530 { ChargeSkills::InterceptStun1 $from }
	17498 { ChargeSkills::InterceptStun2 $from }
	22863 { ChargeSkills::InterceptStun3 $from }

}


proc ::SpellEffects::AddLegacySpellScripts {} {
	foreach { spellid commands } [ array get ::SpellEffects::LegacySpellScripts ] {
		eval "proc ::SpellEffects::LegacySpellScript$spellid { to from spellid } { $commands }"
		::Custom::AddSpellScript "::SpellEffects::LegacySpellScript$spellid" $spellid
	}
}

::SpellEffects::AddLegacySpellScripts











#
# Additional Spells & Effects script v2.1 (c) Delfin 
# creds: seatleson, BAD, DayDream
#
# ====================================

# 11.10.06 v2.3
# - Added windfury auras other missing auras for rogue ,then polumorph by Iceman
# ----------------
# 29.08.06 v2.2
# - Added Aura
# - Added Judgement 
# ----------------
# 25.05.06 v2.1
# - Used Spirit's new custom "AddLegacySpellScript" procedure
# - Added Polymorph (commented)
# 19.05.06 v2.0
# - Added spell arrays
# - Made ExtraSpells script autonomous (thnx Lazarus & Spirit)
# - Reorganized Taunt
# ----------------
# 12.05.06 v1.2
# - Added FinishingMoves
# - Added Charge & Intercept
# ----------------
# 11.05.06 v1.1
# - Added Trinkets
# - Added Taunt
# ----------------
# 10.05.06 v1.0
# - First release / Cast Fear
# ____________________________________
#
#
# Start-TCL 0.9.4 compatible
#
# Fully Autonomous
#
#

##########
#
# defined namespaces
#
## Script Namespaces ##
namespace eval ::ExtraSpells { }

### Spells Namespaces ###
namespace eval ::ChargeSkills { }
namespace eval ::Fear { }
namespace eval ::FinishingMoves { }
namespace eval ::Polymorph { }
namespace eval ::Taunt { }
namespace eval ::Trinkets { }
namespace eval ::Aura { }
namespace eval ::Judgement { }
#########


#
# namespace ::ChargeSkills
#
 proc ::ChargeSkills::Charge { to from } { 
	::CastSpell $from $from 12695
 }

 proc ::ChargeSkills::ChargeStun { from } {
	set to [ ::GetSelection $from ]
	::CastSpell $from $to 7922
 }

 proc ::ChargeSkills::Intercept1 { to from } { 
	::CastSpell $from $from 14530
 }

 proc ::ChargeSkills::Intercept2 { to from } { 
	::CastSpell $from $from 17498
 }

 proc ::ChargeSkills::Intercept3 { to from } { 
	::CastSpell $from $from 22863
 }

 proc ::ChargeSkills::InterceptStun1 { from } {
	set to [ ::GetSelection $from ]
	::CastSpell $from $to 20253
 }

 proc ::ChargeSkills::InterceptStun2 { from } {
	set to [ ::GetSelection $from ]
	::CastSpell $from $to 20614
 }

 proc ::ChargeSkills::InterceptStun3 { from } {
	set to [ ::GetSelection $from ]
	::CastSpell $from $to 20615
 }


#
# namespace ::Fear
#
 proc ::Fear::OnCastFear { from to } {
	variable feartarget

	if { ! [info exists feartarget($from)] } {
		set feartarget($from) $to
	} elseif { $feartarget($from)!=$to || rand() > 0.4 } {
		::CastSpell $from $feartarget($from) 22891
		set feartarget($from) $to
	}
 }

#
# namespace ::FinishingMoves
#
 proc ::FinishingMoves::WrathHammer { to from spell } { 
	set hp [ ::GetHealthPCT $to ]
	if { $hp <= 20 } { 
		::CastSpell $from $to $spell 
	}
 }

 proc ::FinishingMoves::Execute { to from spell } { 
	set hp [ ::GetHealthPCT $to ]
	if { $hp <= 20 } {
		::CastSpell $from $to $spell 
	}
 }



#
# namespace ::Polymorph
#
# proc ::Polymorph::OnCastPolymorph { from to } {
#	global polymorphtarget
#	if { ! [info exists polymorphtarget($from)] } {
#		set polymorphtarget($from) $to
#	} elseif { $polymorphtarget($from)!= $to || rand() > 0.4 } {
#		::CastSpell $from $polymorphtarget($from) 22891
#		set polymorphtarget($from) $to
#	}
# }

# Here is poly with crowd control
# But is a copy of what is in SpellProcs.tcl
# do not use both.
namespace eval ::OnCrowdControl {
	proc UndoCrowdControl { to from spellid } {
		variable OnCrowdControl
		variable CrowdControlled
		if { [ info exists OnCrowdControl($from) ] && !( $CrowdControlled == $to ) } { 
			::CastSpell $CrowdControlled $CrowdControlled 22890
			set OnCrowdControl($from) 0 
		}
		set OnCrowdControl($from) 1
		set CrowdControlled $to
		return
	}
	proc Polymorph { to from spellid } { CastSpell $to $to 12939 }
}
variable CrowdControlSpells { 2878 5627 10326 339 1062 5195 5196 9852 9853 118 12824 12825 12826 6770 2070 11297 5782 6213 6215 9484 9485 10955 }
::Custom::AddSpellScript "::OnCrowdControl::UndoCrowdControl" $CrowdControlSpells
variable PolymorphSpells { 118 12824 12825 12826 }
::Custom::AddSpellScript "::OnCrowdControl::Polymorph" $PolymorphSpells


# END POLY WITH CROWD CONTROL
#

#
# namespace ::Taunt
#
proc ::Taunt::OnCast { to from spellid } {
	::CastSpell $to $from 20508
}


#
# namespace ::Trinkets
#
 proc ::Trinkets::SixDemonBag { to from } {	
	set spell_list "23102 21402 15117 23103 15534 14642 "
	set spellid [lindex $spell_list [expr {int(rand()*[llength $spell_list])}]]
	::CastSpell $from $to $spellid
 }

 proc ::Trinkets::PiccoloOfTheFlamingFire { to from } {
	::Emote $to 10
 }		


#
# namespace ::Aura
#
 proc ::Aura::Cast { from spellid } { 
	::CastSpell $from $from $spellid
 }


#
# namespace ::Judgement
#
 proc ::Judgement::ClearAura { player } {            
	::ClearQFlag $player "auraright01"
	::ClearQFlag $player "auraright02"
	::ClearQFlag $player "auraright03"
	::ClearQFlag $player "auraright04"
	::ClearQFlag $player "auraright05"
	::ClearQFlag $player "auraright06"
	::ClearQFlag $player "auraright07"
	::ClearQFlag $player "auraright08"
	::ClearQFlag $player "auracommand01" 
	::ClearQFlag $player "auracommand02"
	::ClearQFlag $player "auracommand03" 
	::ClearQFlag $player "auracommand04"
	::ClearQFlag $player "auracommand05"
	::ClearQFlag $player "auralight01" 
	::ClearQFlag $player "auralight02" 
	::ClearQFlag $player "auralight03"
	::ClearQFlag $player "auralight04" 
	::ClearQFlag $player "aurawisd01"
	::ClearQFlag $player "aurawisd02"
	::ClearQFlag $player "aurawisd03" 
	return 0          
 }

 proc ::Judgement::Judge { player ennemy } {
	if {[::GetQFlag $player "auraright01"]} {
		::CastSpell $player $ennemy 20187
		Judgement::ClearAura $player   
		return 0        
	}  

	if {[::GetQFlag $player "auraright02"]} {
		::CastSpell $player $ennemy 20280
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "auraright03"]} {
		::CastSpell $player $ennemy 20281
		Judgement::ClearAura $player 
		return 0
	}

	if {[::GetQFlag $player "auraright04"]} {
		::CastSpell $player $ennemy 20282
		Judgement::ClearAura $player  
		return 0
	}

	if {[::GetQFlag $player "auraright05"]} {
		::CastSpell $player $ennemy 20283
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "auraright06"]} {
		::CastSpell $player $ennemy 20284
		Judgement::ClearAura $player   
		return 0
	}

	if {[::GetQFlag $player "auraright07"]} {
		::CastSpell $player $ennemy 20285
		Judgement::ClearAura $player  
		return 0
	}

	if {[::GetQFlag $player "auraright08"]} {
		::CastSpell $player $ennemy 20286
		Judgement::ClearAura $player  
		return 0
	}

	if {[::GetQFlag $player "auracommand01"]} {
		::CastSpell $player $ennemy 20467
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "auracommand02"]} {
		::CastSpell $player $ennemy 20963
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "auracommand03"]} {
		::CastSpell $player $ennemy 20964
		Judgement::ClearAura $player  
		return 0
	}

	if {[::GetQFlag $player "auracommand04"]} {
		::CastSpell $player $ennemy 20965
		Judgement::ClearAura $player 
		return 0
	}

	if {[::GetQFlag $player "auracommand05"]} {
		::CastSpell $player $ennemy 20966
		Judgement::ClearAura $player 
		return 0
	}

	if {[::GetQFlag $player "auralight01"]} {
		::CastSpell $player $player 50090
		Judgement::ClearAura $player 
		return 0
	}

	if {[::GetQFlag $player "auralight02"]} {
		::CastSpell $player $player 50091
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "auralight03"]} {
		::CastSpell $player $player 50092
		Judgement::ClearAura $player 
		return 0
	} 

	if {[::GetQFlag $player "auralight04"]} {
		::CastSpell $player $player 50093
		Judgement::ClearAura $player
		return 0
	}

	if {[::GetQFlag $player "aurawisd01"]} {
		::CastSpell $player $player 50094
		Judgement::ClearAura $player 
		return 0
	}

	if {[::GetQFlag $player "aurawisd02"]} {
		::CastSpell $player $player 50095
		Judgement::ClearAura $player   
		return 0
	}

	if {[::GetQFlag $player "aurawisd03"]} {
		::CastSpell $player $player 50096
		Judgement::ClearAura $player 
		return 0
	}

}   


###########

proc ::ExtraSpells::Init { } {
	if { [ info exists "::StartTCL::VERSION" ] } {
	
		::Custom::AddSpellScript "::Taunt::OnCast" 355 694 1161 4092 4101 4507 5209 6795 7400 7402 9741 20559 20560 21008 21860 23790

		::Custom::AddLegacySpellScript {


13931  { Enchanting::OnEnchant $from $to $spellid }
20008  { Enchanting::OnEnchant $from $to $spellid }
13846  { Enchanting::OnEnchant $from $to $spellid }
13945  { Enchanting::OnEnchant $from $to $spellid }
23802  { Enchanting::OnEnchant $from $to $spellid }
13646  { Enchanting::OnEnchant $from $to $spellid }
7859  { Enchanting::OnEnchant $from $to $spellid }
13501  { Enchanting::OnEnchant $from $to $spellid }
13536  { Enchanting::OnEnchant $from $to $spellid }
23801  { Enchanting::OnEnchant $from $to $spellid }
7428  { Enchanting::OnEnchant $from $to $spellid }
7766  { Enchanting::OnEnchant $from $to $spellid }
7782  { Enchanting::OnEnchant $from $to $spellid }
13661  { Enchanting::OnEnchant $from $to $spellid }
20009  { Enchanting::OnEnchant $from $to $spellid }
20011  { Enchanting::OnEnchant $from $to $spellid }
20010  { Enchanting::OnEnchant $from $to $spellid }
13939  { Enchanting::OnEnchant $from $to $spellid }
13822  { Enchanting::OnEnchant $from $to $spellid }
13622  { Enchanting::OnEnchant $from $to $spellid }
7779  { Enchanting::OnEnchant $from $to $spellid }
7418  { Enchanting::OnEnchant $from $to $spellid }
7457  { Enchanting::OnEnchant $from $to $spellid }
13642  { Enchanting::OnEnchant $from $to $spellid }
13648  { Enchanting::OnEnchant $from $to $spellid }


25086  { Enchanting::OnEnchant $from $to $spellid }
13746  { Enchanting::OnEnchant $from $to $spellid }
25081  { Enchanting::OnEnchant $from $to $spellid }
25082  { Enchanting::OnEnchant $from $to $spellid }
20014  { Enchanting::OnEnchant $from $to $spellid }
13882  { Enchanting::OnEnchant $from $to $spellid }
13522  { Enchanting::OnEnchant $from $to $spellid }
13419  { Enchanting::OnEnchant $from $to $spellid }
13794  { Enchanting::OnEnchant $from $to $spellid }
25083  { Enchanting::OnEnchant $from $to $spellid }
25084  { Enchanting::OnEnchant $from $to $spellid }
20015  { Enchanting::OnEnchant $from $to $spellid }
13635  { Enchanting::OnEnchant $from $to $spellid }
13657  { Enchanting::OnEnchant $from $to $spellid }
7861  { Enchanting::OnEnchant $from $to $spellid }
13421  { Enchanting::OnEnchant $from $to $spellid }
7771  { Enchanting::OnEnchant $from $to $spellid }
7454  { Enchanting::OnEnchant $from $to $spellid }


20025  { Enchanting::OnEnchant $from $to $spellid }
7776  { Enchanting::OnEnchant $from $to $spellid }
20026  { Enchanting::OnEnchant $from $to $spellid }
20028  { Enchanting::OnEnchant $from $to $spellid }
7443  { Enchanting::OnEnchant $from $to $spellid }
13941  { Enchanting::OnEnchant $from $to $spellid }
13640  { Enchanting::OnEnchant $from $to $spellid }
13663  { Enchanting::OnEnchant $from $to $spellid }
7857  { Enchanting::OnEnchant $from $to $spellid }
13538  { Enchanting::OnEnchant $from $to $spellid }
7748  { Enchanting::OnEnchant $from $to $spellid }
13700  { Enchanting::OnEnchant $from $to $spellid }
13607  { Enchanting::OnEnchant $from $to $spellid }
7426  { Enchanting::OnEnchant $from $to $spellid }
7420  { Enchanting::OnEnchant $from $to $spellid }
13626  { Enchanting::OnEnchant $from $to $spellid }
13858  { Enchanting::OnEnchant $from $to $spellid }
13917  { Enchanting::OnEnchant $from $to $spellid }


13868  { Enchanting::OnEnchant $from $to $spellid }
13841  { Enchanting::OnEnchant $from $to $spellid }
25078  { Enchanting::OnEnchant $from $to $spellid }
13620  { Enchanting::OnEnchant $from $to $spellid }
25074  { Enchanting::OnEnchant $from $to $spellid }
20012  { Enchanting::OnEnchant $from $to $spellid }
20013  { Enchanting::OnEnchant $from $to $spellid }
25079  { Enchanting::OnEnchant $from $to $spellid }
13617  { Enchanting::OnEnchant $from $to $spellid }
13612  { Enchanting::OnEnchant $from $to $spellid }
13948  { Enchanting::OnEnchant $from $to $spellid }
13947  { Enchanting::OnEnchant $from $to $spellid }
25073  { Enchanting::OnEnchant $from $to $spellid }
13698  { Enchanting::OnEnchant $from $to $spellid }
25080  { Enchanting::OnEnchant $from $to $spellid }
25072  { Enchanting::OnEnchant $from $to $spellid }
13815  { Enchanting::OnEnchant $from $to $spellid }
13887  { Enchanting::OnEnchant $from $to $spellid }


13935  { Enchanting::OnEnchant $from $to $spellid }
20023  { Enchanting::OnEnchant $from $to $spellid }
20020  { Enchanting::OnEnchant $from $to $spellid }
13687  { Enchanting::OnEnchant $from $to $spellid }
7867  { Enchanting::OnEnchant $from $to $spellid }
13890  { Enchanting::OnEnchant $from $to $spellid }
20024  { Enchanting::OnEnchant $from $to $spellid }
13637  { Enchanting::OnEnchant $from $to $spellid }
13644  { Enchanting::OnEnchant $from $to $spellid }
7863  { Enchanting::OnEnchant $from $to $spellid }
13836  { Enchanting::OnEnchant $from $to $spellid }


22750  { Enchanting::OnEnchant $from $to $spellid }
22749  { Enchanting::OnEnchant $from $to $spellid }
23800  { Enchanting::OnEnchant $from $to $spellid }
20034  { Enchanting::OnEnchant $from $to $spellid }
13915  { Enchanting::OnEnchant $from $to $spellid }
13898  { Enchanting::OnEnchant $from $to $spellid }
20029  { Enchanting::OnEnchant $from $to $spellid }
13653  { Enchanting::OnEnchant $from $to $spellid }
13655  { Enchanting::OnEnchant $from $to $spellid }
20032  { Enchanting::OnEnchant $from $to $spellid }
23804  { Enchanting::OnEnchant $from $to $spellid }
23803  { Enchanting::OnEnchant $from $to $spellid }
7786  { Enchanting::OnEnchant $from $to $spellid }
23799  { Enchanting::OnEnchant $from $to $spellid }
20031  { Enchanting::OnEnchant $from $to $spellid }
20033  { Enchanting::OnEnchant $from $to $spellid }
21931  { Enchanting::OnEnchant $from $to $spellid }
13943  { Enchanting::OnEnchant $from $to $spellid }
13503  { Enchanting::OnEnchant $from $to $spellid }
7788  { Enchanting::OnEnchant $from $to $spellid }
13693  { Enchanting::OnEnchant $from $to $spellid }


27837  { Enchanting::OnEnchant $from $to $spellid }
13937  { Enchanting::OnEnchant $from $to $spellid }
7793  { Enchanting::OnEnchant $from $to $spellid }
13380  { Enchanting::OnEnchant $from $to $spellid }
20036  { Enchanting::OnEnchant $from $to $spellid }
20035  { Enchanting::OnEnchant $from $to $spellid }
20030  { Enchanting::OnEnchant $from $to $spellid }
13695  { Enchanting::OnEnchant $from $to $spellid }
13529  { Enchanting::OnEnchant $from $to $spellid }
7745  { Enchanting::OnEnchant $from $to $spellid }

13933  { Enchanting::OnEnchant $from $to $spellid }
13905  { Enchanting::OnEnchant $from $to $spellid }
20017  { Enchanting::OnEnchant $from $to $spellid }
13689  { Enchanting::OnEnchant $from $to $spellid }
13464  { Enchanting::OnEnchant $from $to $spellid }
13817  { Enchanting::OnEnchant $from $to $spellid }
20016  { Enchanting::OnEnchant $from $to $spellid }
13485  { Enchanting::OnEnchant $from $to $spellid }
13631  { Enchanting::OnEnchant $from $to $spellid }
13378  { Enchanting::OnEnchant $from $to $spellid }
13659  { Enchanting::OnEnchant $from $to $spellid }




                         
			 5782 { Fear::OnCastFear $from $to }
			 6213 { Fear::OnCastFear $from $to }
			 6215 { Fear::OnCastFear $from $to }


			17512 { Trinkets::PiccoloOfTheFlamingFire $to $from}
			14537 { Trinkets::SixDemonBag $to $from}


			24275 { FinishingMoves::WrathHammer $to $from 11976 }
			24274 { FinishingMoves::WrathHammer $to $from 13584 }
			24239 { FinishingMoves::WrathHammer $to $from 12057 }	

			5308  { FinishingMoves::Execute $to $from 13446 }
			20658 { FinishingMoves::Execute $to $from 14516 }
			20660 { FinishingMoves::Execute $to $from 15580 }
			20661 { FinishingMoves::Execute $to $from 18368 }
			20662 { FinishingMoves::Execute $to $from 22591 }


			100   { ChargeSkills::Charge $to $from }
			6178  { ChargeSkills::Charge $to $from }
			11578 { ChargeSkills::Charge $to $from }

			12695 { ChargeSkills::ChargeStun $from }

			20252 { ChargeSkills::Intercept1 $to $from }
			20616 { ChargeSkills::Intercept2 $to $from }
			20617 { ChargeSkills::Intercept3 $to $from }

			14530 { ChargeSkills::InterceptStun1 $from }
			17498 { ChargeSkills::InterceptStun2 $from }
			22863 { ChargeSkills::InterceptStun3 $from }

			
			465   { Aura::Cast $from 50037 }
			10290 { Aura::Cast $from 50038 }
			643   { Aura::Cast $from 50039 }
			10291 { Aura::Cast $from 50040 }
			1032  { Aura::Cast $from 50041 }
			10292 { Aura::Cast $from 50042 }
			10293 { Aura::Cast $from 50043 }
			7294  { Aura::Cast $from 50044 }
      10298 { Aura::Cast $from 50045 }
      10299 { Aura::Cast $from 50046 }
      10300 { Aura::Cast $from 50047 }
      10301 { Aura::Cast $from 50048 }
			19876 { Aura::Cast $from 50049 }
			19895 { Aura::Cast $from 50050 }
			19896 { Aura::Cast $from 50051 }
			19888 { Aura::Cast $from 50052 }
			19897 { Aura::Cast $from 50053 }
			19898 { Aura::Cast $from 50054 }
			19891 { Aura::Cast $from 50055 }
			19899 { Aura::Cast $from 50056 }
			19900 { Aura::Cast $from 50057 }

			1130  { Aura::Cast $from 50058 }
			14323 { Aura::Cast $from 50059 }
			14324 { Aura::Cast $from 50060 }
			14325 { Aura::Cast $from 50061 }

			6673  { Aura::Cast $from 50062 }
			5242  { Aura::Cast $from 50063 }
			6192  { Aura::Cast $from 50064 }
			11549 { Aura::Cast $from 50065 }
			11550 { Aura::Cast $from 50066 }
			11551 { Aura::Cast $from 50067 }

			50024 { Aura::Cast $from 50068 }
			50025 { Aura::Cast $from 50069 }

			19506 { Aura::Cast $from 50109 }
			20905 { Aura::Cast $from 50110 }
			20906 { Aura::Cast $from 50111 }

			20043 { Aura::Cast $from 50118 }
			20190 { Aura::Cast $from 50119 }

			6940  { Aura::Cast $from 50120 }
			20729 { Aura::Cast $from 50121 }

                         

			50123 { Aura::Cast $from 20167 }
			50124 { Aura::Cast $from 20333 }
			50125 { Aura::Cast $from 20334 }
			50126 { Aura::Cast $from 20340 }

                       

			50147 { Aura::Cast $from 20168 }
			50148 { Aura::Cast $from 20350 }
			50149 { Aura::Cast $from 20351 }
			14278 { Aura::Cast $from 50127 }
		  8233  { Aura::Cast $from 50128 }
		  8236  { Aura::Cast $from 50129 }
		  10484 { Aura::Cast $from 50130 }
		  16361 { Aura::Cast $from 50131 }
		  8516  { Aura::Cast $from 50132 }
		  10608 { Aura::Cast $from 50133 }
		  10610 { Aura::Cast $from 50134 }
		  17364 { Aura::Cast $from 18941 }
		  20178 { Aura::Cast $from 18941 }
		  16459 { Aura::Cast $from 18941 }
		  12964 { Aura::Cast $from 50135 }
		  23602 { Aura::Cast $from 50135 }
			13797 { HunterTraps::DismissTrap $from }
			14298 { HunterTraps::DismissTrap $from }
			14299 { HunterTraps::DismissTrap $from }
			14300 { HunterTraps::DismissTrap $from }
			14301 { HunterTraps::DismissTrap $from }
			3355  { HunterTraps::DismissTrap $from }
			14308 { HunterTraps::DismissTrap $from }
			14309 { HunterTraps::DismissTrap $from }
			13810 { HunterTraps::DismissTrap $from }
			13812 { HunterTraps::DismissTrap $from }
			14314 { HunterTraps::DismissTrap $from }
			14315 { HunterTraps::DismissTrap $from }

			20187 {
			Judgement::ClearAura $from
			SetQFlag $from "auraright01"
			} 
			20287 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright02"
			} 
			20288 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright03"
			} 
			20289 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright04"
			} 
			20290 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright05"
			} 
			20291 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright06"
			} 
			20292 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright07"
			} 
			20293 { 
			Judgement::ClearAura $from
			SetQFlag $from "auraright08"
			} 
			20375 {
			Judgement::ClearAura $from
			SetQFlag $from "auracommand01"
			} 
			20915 {
			Judgement::ClearAura $from
			SetQFlag $from "auracommand02"
			} 
			20918 {
			Judgement::ClearAura $from
			SetQFlag $from "auracommand03"
			} 
			20919 {
			Judgement::ClearAura $from
			SetQFlag $from "auracommand04"
			} 
			20920 {
			Judgement::ClearAura $from
			SetQFlag $from "auracommand05"
			} 
			20165 {
			Judgement::ClearAura $from
			SetQFlag $from "auralight01"
			} 
			20347 {
			Judgement::ClearAura $from
			SetQFlag $from "auralight02"
			} 
			20348 {
			Judgement::ClearAura $from
			SetQFlag $from "auralight03"
			} 
			20349 {
			Judgement::ClearAura $from
			SetQFlag $from "auralight04"
			} 
			20166 {
			Judgement::ClearAura $from
			SetQFlag $from "aurawisd01"
			}
			20356 {
			Judgement::ClearAura $from
			SetQFlag $from "aurawisd02"
			}
			20357 {
			Judgement::ClearAura $from
			SetQFlag $from "aurawisd03"
			}
			20271 { Judgement::Judge $from $to }


		}

	} else {
		# setup the system to deal with these spells as usual
	}
}

::ExtraSpells::Init


# ====================================
#
#    Tame System By GriffonHeart & LCF       #
# Modified by Savage, +checks & translated   #
# Please preserve the credits & do not steal #
# the work of other scripters.               #
#
# ====================================
#
# Modified by Delfin
#
# 25.05.06
# - Used Spirit's new custom "AddLegacySpellScript" procedure
# 19.05.06
#
# Start-TCL 0.9.4 compatible
#

##########
#
# defined namespace
#

namespace eval ::Tame {
	StartTCL::Provide
}

##########


#
# namespace ::Tame
#
 proc ::Tame::Taming { player target } {
	if { [ ::Distance $player $target ] > 30 } {
		::Say $player 0 "Failed. You have to be closer to the target."
		return
	}
	if { [ ::GetCreatureType $target ] != 1 } {
		::Say $player 0 "Failed. You have to select a target first."
		return
	}
	if { [ ::GetCreatureType $target ] == 7 } {
		::Say $player 0 "Failed. You cannot tame a NPC."
		return
	}
	if { [ ::GetCreatureType $target ] == 8 } {
		::Say $player 0 "Failed. You cannot tame a critter."
		return
	}
	if { [ ::GetLevel $player ] < [ ::GetLevel $target ] } {
		::Say $player 0 "Failed. You cannot tame targets with a higher level then yourself."
		return
	}
	set entry [ ::GetEntry $target ]
	set elite [ ::GetScpValue creatures.scp "creature $entry" elite ]
	if {$elite != "{}"} {
		::Say $player 0 "Failed. You cannot tame an elite."
		return
	}
	::CastSpell $player $target 13481
	::Say $player 0 "Success! You have tamed a beast."
 }

 proc ::Tame::Quests { player target quest_mob quest item } {
	set mob [GetEntry $target]
	if { [ ::GetClass $player ] == 3 } {
		if { $mob==$quest_mob } {
			::CastSpell $player $target 13481
			::SendQuestComplete $player $quest
			::ConsumeItem $player $item
			puts "$quest"
		} else {
			::Say $player 0 "Failed. You have not tamed the correct beast for this taming quest!"
		}
	} else {
		Say $player 0 "You are not a hunter!"
	}
 }

 proc ::Tame::Init { } {
	if { [ info exists "::StartTCL::VERSION" ] } {

		::Custom::AddLegacySpellScript {

			 1515 { Tame::Taming $from $to }

			19548 { Tame::Quests $from $to 1196 6085 15908 }
			19674 { Tame::Quests $from $to 1126 6064 15911 }
			19687 { Tame::Quests $from $to 1201 6084 15913 }
			19688 { Tame::Quests $from $to 2956 6061 15914 }
			19689 { Tame::Quests $from $to 2959 6087 15915 }
			19692 { Tame::Quests $from $to 2970 6088 15916 }
			19693 { Tame::Quests $from $to 1998 6063 15921 }
			19694 { Tame::Quests $from $to 3099 6062 15917 }
			19696 { Tame::Quests $from $to 3107 6083 15919 }
			19697 { Tame::Quests $from $to 3126 6082 15920 }
			19699 { Tame::Quests $from $to 2043 6101 15922 }
			19700 { Tame::Quests $from $to 1996 6102 15923 }

		}

	} else {
		# setup the system to deal with these spells as usual
	}
 }

 ::Tame::Init

