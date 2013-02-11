namespace eval ::Coold4 {
	proc Check4 { player } {
		variable SAY 1
		variable LastUsedTime
		variable ItemSpellData
		set time [clock seconds]

		set cooldown 120
		set cooldown_group 4

		if { ![info exists LastUsedTime($player,$cooldown_group)] || [set timeleft [expr { $cooldown - $time + $LastUsedTime($player,$cooldown_group) }]] < 0 } {
			set can_use 1
			set LastUsedTime($player,$cooldown_group) $time
			return 1
		} else {
			set can_use 0
			if { $SAY } { Say $player 0 [::Texts::Get "|cfff10000Cant use, $timeleft seconds left|r" [::Custom::SecondsToTime $timeleft]] }
			return 0
		}
	}
}

proc ::WoWEmu::Commands::HealthStone { player cargs } {

	if {[GetClass $player] != 9} { return "I am not a warlock" } 
	set hst [::Coold4::Check4 $player]
	if {$hst == 0} { return }
	if {[GetLevel $player] < 12 && [ConsumeItem $player 5512 1]} {
		CastSpell $player $player 6262
		return "Used Minor Healthstone"
	}
	if {[GetLevel $player] >= 12 && [GetLevel $player] < 24} {
	if {[ConsumeItem $player 5511 1]} {
		CastSpell $player $player 6263
		return "Used Lesser Healthstone"
	}
	if {[ConsumeItem $player 5512 1]} {
		CastSpell $player $player 6262
		return "Used Minor Healthstone"
	}
	}

	if {[GetLevel $player] >= 24 && [GetLevel $player] < 36} {
	if {[ConsumeItem $player 5509 1]} {
		CastSpell $player $player 5720
		return "Used Healthstone"
	}
	if {[ConsumeItem $player 5511 1]} {
		CastSpell $player $player 6263
		return "Used Lesser Healthstone"
	}
	if {[ConsumeItem $player 5512 1]} {
		CastSpell $player $player 6262
		return "Used Minor Healthstone"
	}
	}
	
	if {[GetLevel $player] >= 36 && [GetLevel $player] < 48} {
	if {[ConsumeItem $player 5510 1]} {
		CastSpell $player $player 5723
		return "Used Greater Healthstone"
	}
	if {[ConsumeItem $player 5509 1]} {
		CastSpell $player $player 5720
		return "Used Healthstone"
	}
	if {[ConsumeItem $player 5511 1]} {
		CastSpell $player $player 6263
		return "Used Lesser Healthstone"
	}
	if {[ConsumeItem $player 5512 1]} {
		CastSpell $player $player 6262
		return "Used Minor Healthstone"
	}
	}
	
	if {[GetLevel $player] >= 48} {
	if {[ConsumeItem $player 9421 1]} {
		CastSpell $player $player 11732
		return "Used Major Healthstone"
	}
	if {[ConsumeItem $player 5510 1]} {
		CastSpell $player $player 5723
		return "Used Greater Healthstone"
	}
	if {[ConsumeItem $player 5509 1]} {
		CastSpell $player $player 5720
		return "Used Healthstone"
		}
	if {[ConsumeItem $player 5511 1]} {
		CastSpell $player $player 6263
		return "Used Lesser Healthstone"
	}
	if {[ConsumeItem $player 5512 1]} {
		CastSpell $player $player 6262
		return "Used Minor Healthstone"
	}
	}
	
	return "No healthstones in my backpack"
}


proc ::WoWEmu::Commands::trollblood { player cargs } {
	if {[GetRace $player] == 8} {
		CastSpell $player $player 20555
	} else { return "This is only for troll race" }
}


proc ::WoWEmu::Commands::loot { player cargs } {
	Loot $player [GetSelection $player] 33000 2
	}

proc ::WoWEmu::Commands::heal { player cargs } {
	if {[GetClass $player] == 5} {
		LearnSpell $player 21745
	}
	ClearQFlag $player icerank1
	ClearQFlag $player icerank2
	ClearQFlag $player icerank3
	ClearQFlag $player icerank4
	CastSpell [GetSelection $player] [GetSelection $player] 12939
	}

proc ::WoWEmu::Commands::change { player cargs } {
	while {[ConsumeItem $player 18841 1]} {
	AddItem $player 13443
	}
	return
	}

proc ::WoWEmu::Commands::guards { player cargs } {
	#Say $player 0 "|cfff10000GUARDS!!!|r"
	Say $player 0 "GUARDS!!!"
	return [::Defense::Request $player]
	}




#
# player level 0
#

# +++
# Mod by Delfin
# 27.05.06
# 

#
#	proc ::WoWEmu::Commands::getout { player cargs }
#
proc ::WoWEmu::Commands::getout { player cargs } {
 if { [ ::ngjail::IsJailed  [::GetName $player] ] == 1 } {
		 set msg " You are jailed, no unstuck for you" 
           } else {
	set pos [ ::GetPos $player ]
	set z [ lindex $pos 3 ]
	if { $z < -1000 || $z > 2000} {
		set bp [ ::GetBindpoint $player ]
		set m [lindex $bp 0]
		set x [lindex $bp 1]
		set y [lindex $bp 2]
		set z [lindex $bp 3]
		::Teleport $player $m $x $y $z
	}
	return "You probably don't need to get out. If you are - contact any GM!"
}
}

# End of mod
# ===



#
#    proc ::WoWEmu::Commands::arena { player cargs }
#    alternativa al pvp enter
#   PVP needs variable to be set before loading
#      default 1 [open] on startup
namespace eval ::WoWEmu::Commands {
        variable PVP_stat 1
}
proc ::WoWEmu::Commands::arena { player cargs } {

    #   PVP needs variable to be set before loading default 0 [closed] on startup
    variable PVP_stat

    set option [lindex $cargs 0]
    if { [ ::ngjail::IsJailed  [::GetName $player] ] == 1 } {
         set msg " You are jailed, no pvp for you"
    } else {
        switch $cargs {
    "close" {
                    if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use 
this command" }
           set PVP_stat 0
           set msg "\nGurubashi arena is now Closed!!!"
                }

    "enter" {
        if { ![::GetQFlag $player garena] } {

                    if { $PVP_stat == 0 } {
                   set msg "\nGurubashi PVP Arena: \nArena is closed now, please wait unitil an 
event takes place"
               } else {
                   if { [GetHealthPCT $player] != 100 } {
                       set msg "You arent fully healed, heal first, PvP later."
                   } else {

if {[ConsumeItem $player 17031 3] == 0 } { return "|cFFFFA333 To be teleported, you need  3 Runes of Teleportation" }

                   ::SetQFlag $player garena
                   Teleport $player 0 -13152.900391 342.729004 52.132801
                          }
                   }
        } else { return "|cFFFFA333You are in The Arena type .arena leave to exit" }
           }

    "leave" {
          if { [::GetQFlag $player garena] } {

                    if { $PVP_stat == 0 } {
               set msg "\nGurubashi PVP Arena: \nArena is closed now, use heartstone to get 
home!"
           } else {

               ::Custom::GoHome $player
                ::ClearQFlag $player garena
           }
              } else { return "|cFFFFA333You are not in The Arena" }
           }


  "open" {

                    if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use 
this command" }
               if { $PVP_stat == 1 } {
           set msg "\nGurubashi Arena was already opened!"
           } else {
               set PVP_stat 1
               set msg "\nGurubashi arena is now Open!!!"
           }
       }

   "info" {
                   set msg "\n Battles take place inside the BATTLE RING only! \nviolators will 
be jailed! \nPlease report abuses to GM's"
                }
    default {
                    if { $PVP_stat == 0 } {
                        set PVPtxt "closed"
                    } else {
                        set PVPtxt "open"
                    }
                    if { [GetPlevel $player] < 2 } {
                        set msg "\nGurubashi PVP Arena: \nTo ENTER the pvp arena type .arena enter 
\nTo LEAVE the pvp arena type .arena leave \nFor information type .arena info\nArena is currently 
$PVPtxt"
                    } else {
                        set msg "\nGurubashi PVP Arena: \nTo OPEN the pvp arena type .arena open 
\nTo CLOSE the pvp arena type .arena close \nFor information type .arena info \nArena is 
currently $PVPtxt"
                    }
            }
        }
    }
}



#
#	proc ::WoWEmu::Commands::problem { player cargs }
#
proc ::WoWEmu::Commands::problem { player cargs } {
	set file "logs/problem_players.log"
	set selection [ ::GetSelection $player ]

	if { [ ::GetObjectType $selection ] != 4 } {
		return [ ::Texts::Get "target_player" ]
	}

	::Custom::Log "[ ::GetName $player ] [ ::Texts::Get "is_reporting" ] [ ::GetName $selection ]. [ ::Texts::Get "reason" ]: $cargs." $file
	return [ ::Texts::Get "thank_for_report" ]
}


#
#	proc ::WoWEmu::Commands::dismiss { player cargs }
#
variable ::WoWEmu::Commands::pbasedir "extra"

proc ::WoWEmu::Commands::dismiss { player cargs } {
	variable pbasedir
	set pname [ ::GetName $player ]
	set plevel [ ::GetLevel $player ]
	set pet [ ::GetSelection $player ]
	set pguid [ ::GetGuid $player ]
	set petid [ ::GetEntry $pet ]
	set petguid [ ::GetLinkObject $pet ]

	if { $player != $petguid } {
		return [ ::Texts::Get "select_pet" ]
	}

	set pethp [ ::GetHealthPCT $pet ]

	if { $pethp < 90 } {
		return [ ::Texts::Get "pet_more_life" ]
	}

	set pclass [ ::GetClass $player ]

	if { $pclass != 9 && $pclass!= 3 } {
		return
	}

	if { ! [ file exists "$pbasedir/pets/$pname" ] } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file w+ ]
		puts $id "0 0 0"
		close $id
	}

	#class hunter##########
	if { $pclass == 3 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id

		foreach { pet1 pet2 pet3 } $list {}

		if { $pet1 == 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid 0 0"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet1 0"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 != 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet2 $pet1"
			puts $id $newlist
			close $id
		}

		if { $pet1 != 0 && $pet2 != 0 && $pet3 != 0 } {
			return "PET_DISMISS_ERROR_TOO"
		}
	}

	#class warlock #################
	if { $pclass == 9 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file w+ ]
		set newlist "$petid"
		puts $id $newlist
		close $id
	}
}


#
#	proc ::WoWEmu::Commands::callpet { player cargs }
#
proc ::WoWEmu::Commands::callpet { player cargs } {
	variable pbasedir
	set pclass [ ::GetClass $player ]
	set plevel [ ::GetLevel $player ]
	set pname [ ::GetName $player ]

	if { $pclass == 9 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file r+ ]
		puts $id "0"
		close $id

		if { $pet1 == 416 } {
			::CastSpell $player $player 23503
		}

		if { $pet1 == 417 } {
			::CastSpell $player $player 23500
		}

		if { $pet1 == 1860 } {
			::CastSpell $player $player 23501
		}

		if { $pet1 == 1863 } {
			::CastSpell $player $player 23502
		}

		if { $pet1 == 89 } {
			::CastSpell $player $player 12740
		}

		if { $pet1 == 8616 } {
			::CastSpell $player $player 12740
		}

		if { $pet1 == 14385 } {
			::CastSpell $player $player 22865
		}
	}

	if { $pclass == 3 } {
		set file "$pbasedir/pets/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id

		foreach { pet1  pet2 pet3 } $list {}

		set pet 0

		if { $pet1 != 0 } {
			set pet $pet1
			set pet1 0
		} else {
			if { $pet2 != 0 } {
				set pet $pet2
				set pet2 0
			} else {
				if { $pet3 != 0 } {
				set pet $pet3
				set pet3 0
				}
			}
		}

		set id [ open $file w+ ]
		set newlist "$pet1 $pet2 $pet3"
		puts $id $newlist
		close $id
		set wolf "3823 3824 3825 1258 923 628 118 5449 69 213 299 525 565 704 705 1131 1133 1138 1817 1922 2680 2681 2924 2958 2960 3939 8959 10981 13618 833 834 2727 2728 2729 2730"
		set bear "8956 822 1128 1129 1186 1797 1778 1196 1189 1188 1815 2163 2164 2165 2351 3810 3809 2356 2354 3811 5268 5272 5433 7444"
		set bird "5436 1194 2578 2579 2580 2829 2830 2831 6013"
		set boar "113 524 708 1125 1126 1127 1190 1191 1192 1689 1984 1985 2966 3098 3099 3100 3225 5992 5437"
		set cat "3566 15101 3425 5438 2043 2042 2034 2033 2032 2031 3619 4242 7430 7431 7432 7433 7434 10042 681 682 698 976 1085 3121 2407 2406 2385 2384"
		set crawler "5439 830 831 922 1088 1216 2231 2232 2233 2234 2235 2236 2544 3106 3107 3108 3228 3812 3814 6250 12347"
		set crocolisk "5440 1082 1084 1150 1151 1152 1400 1417 1693 2089 2476 3110 3231 4341 4344 5053"
		set gorilla "5442 1108 1511 1557 2521 6514"
		set raptor "3254 3255 3256 5444 685 686 856 855 1015 1020 4351"
		set scorpid "5445 3124 3125 3126 3127 3226 4139 4140 5422 5423 5424 7078 7405 7803 9691 9695 9698 9701 11735"
		set spider "5446 30 43 217 539 1504 1505 1555 1986 2001 4376 4413 4415 5856 5857 5858 10375 14881"

		foreach x $wolf {
			if { $x == $pet } {
				if { $plevel < 20 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 4946
			}
		}

		foreach x $bear {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7903
			}
		}

		foreach x $bird {
			if { $x == $pet } {
				if { $plevel < 12 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7904
			}
		}

		foreach x $boar {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7905
			}
		}

		foreach x $cat {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7906
			}
		}

		foreach x $crawler {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7907
			}
		}

		foreach x $crocolisk {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7908
			}
		}

		foreach x $gorilla {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7909
			}
		}
		foreach x $raptor {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7910
			}
		}

		foreach x $scorpid {
			if { $x == $pet } {
				if { $plevel < 35 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7911
			}
		}

		foreach x $spider {
			if { $x == $pet } {
				if { $plevel < 30 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}

				::CastSpell $player $player 7912
			}
		}

		if { $pet == 5448 } {
			::CastSpell $player $player 7915
		}

		if { $pet == 5443 } {
			::CastSpell $player $player 7916
		}

		if { $pet == 4535 } {
			::CastSpell $player $player 8274
		}

		if { $pet == 4534 } {
			::CastSpell $player $player 8276
		}
	}
}


#
#	proc ::WoWEmu::Commands::isgm { player cargs }
#
proc ::WoWEmu::Commands::isgm { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "target_player" ]
	}

	if { [ ::GetPlevel $target ] } {
		return [ ::Texts::Get "is_gm" ]
	}

	return [ ::Texts::Get "no_gm" ]
}


#	proc ::WoWEmu::Commands::tame { player cargs }
#
proc ::WoWEmu::Commands::tame { player cargs } {
	set pLvl [ ::GetPlevel $player ]

	if { $pLvl == 6 } {
		set Sel [ ::GetSelection $player ]

		if { $Sel == 0 } {
			return [ ::Texts::Get "select_target_first" ]
		}

		set plevel [ ::GetPlevel $player ]
		set elite [ ::GetScpValue creatures.scp "creature $Sel" elite ]

		if { ( $elite == 1 || $elite == 2 || $elite == 3 || $elite == 4 ) && $plevel < 4} {
			return [ ::Texts::Get "cant_tame_elite" ]
		}

		if { [ ::GetEntry $Sel ] == 0 } {
			return [ ::Texts::Get "cant_tame_player" ]
		}

		if { [ ::GetCreatureType $Sel ] == 7 } {
			return [ ::Texts::Get "cant_tame_npc" ]
		}

		if { [ ::GetCreatureType $Sel ] == 8 } {
			return [ ::Texts::Get "cant_tame_friendly" ]
		}

		if { [ ::GetLevel $Sel ] > [ ::GetLevel $player ] } {
			return [ ::Texts::Get "cant_tame_higher" ]
		}

		if { [ ::Distance $player $Sel] > 10 } {
			return [ ::Texts::Get "closer_to_target" ]
		}

		::CastSpell $player $Sel 13481
		return [ ::Texts::Get "beast_tamed" ]
	} else {
		return [ ::Texts::Get "you_not_gm" ]
	}
}


#
# player level 2
#


#
# player level 4
#

#
#	proc ::WoWEmu::Commands::additem { player cargs }
#
proc ::WoWEmu::Commands::additem { player cargs } {
	if { [ ::GetObjectType [ ::GetSelection $player ] ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set name [ ::GetName [ ::GetSelection $player ] ]
	set iname [ ::GetScpValue "items.scp" "item $cargs" "name" ]

	if {$iname == "{}" } { return [ ::Texts::Get "item_not_found" ] }

	::AddItem [ ::GetSelection $player ] $cargs
	return "|c8f20ff20Item $iname ($cargs) [ ::Texts::Get "added_to" ] $name."
}


#
#	proc ::WoWEmu::Commands::addmoney { player cargs }
#
proc ::WoWEmu::Commands::addmoney { player cargs } {
	if { [ ::GetSelection $player ] == "0" } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetObjectType [ ::GetSelection $player ] ] != "4" } {
		return [ ::Texts::Get "select_player" ]
	}

	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		if { [ lindex $cargs 0 ] > 0 } {
			::ChangeMoney [ GetSelection $player ] +[ lindex $cargs 0 ]
			set copper [ string range [ lindex $cargs 0 ] end-1 end ]
			set silver [ string range [ lindex $cargs 0 ] end-3 end-2 ]
			set gold [ string range [ lindex $cargs 0 ] end-1000 end-4 ]

			if { $copper > 0 } {
				set copper "$copper [ ::Texts::Get "copper" ]"
			} else {
				set copper ""
			}

			if { $silver != "" } {
				if { $silver > 0 } {
					set silver "$silver [ ::Texts::Get "silver" ]"
				} else {
					set silver ""
				}
			}

			if { $gold != "" } {
				set gold "$gold [ ::Texts::Get "gold" ]"
			}

			if { $copper != "" && $silver != "" } {
				set copper ", $copper"
			}

			if { $silver != "" && $gold != "" } {
				set silver ", $silver"
			}

			return "$gold$silver$copper [ ::Texts::Get "added_to" ] [ ::GetName [ ::GetSelection $player ] ]"
		} else {
			return [ ::Texts::Get "invalid_money" ]
		}
	}

	return "[ ::Texts::Get "bad_cmd_args" ] (.addmoney [ ::Texts::Get "amount" ])"
}


#
#	proc ::WoWEmu::Commands::addtele { player cargs }
#
variable ::WoWEmu::Commands::tbasedir "extra"

proc ::WoWEmu::Commands::addtele { player cargs } {
	if { [ string length $cargs ] > 1 } {
		set handle [ open "extra/locations.dat" "a+" ]
		puts $handle "[ string trim $cargs ] [ ::GetPos $player ]"
		close $handle
		return [ ::Texts::Get "location_added" ]
	}

	return [ ::Texts::Get "no_location_name" ]
}


#
#	proc ::WoWEmu::Commands::addswp { player cargs }
#
variable ::WoWEmu::Commands::wbasedir "extra"

proc ::WoWEmu::Commands::addswp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
	} else {
		set latestadded [ open "saves/lastWPoint.txt" r ]
		set firstwayp $latestadded
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint =="" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	if { $latestadded == 0 } {
		set hwaypointout [ open "scripts/waypoints.scp" a ]
	} else {
		set hwaypointout [ open "scripts/extra/ways/Way$pname.scp" a ]
		puts $hwaypointout "next=$lastWP\n"
	}

	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"

	if { $latestadded == 0 } {
		puts $hwaypointout "name=TalkingWP\npos=$x $y $z\nscript=mobspeaking::npcsaywp\n"
	} else {
		puts $hwaypointout "name=TalkingWP\npos=$x $y $z\nscript=mobspeaking::npcsaywp"
	}

	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile

	if { $latestadded == 0 } {
		return "Talking Waypoint $lastWP [ ::Texts::Get "created" ]."
	} else {
		set wayfile [ open "saves/ways/saveway$pname" w ]
		puts $wayfile $lastWP
		puts $wayfile $firstwayp
		close $wayfile
		return "Talking waypoint $lastWP [ ::Texts::Get "created_for_route_and" ] $latestadded ."
	}
}


#
#	proc ::WoWEmu::Commands::addwp { player cargs }
#
proc ::WoWEmu::Commands::addwp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
	} else {
		set latestadded [ open "saves/lastWPoint.txt" r ]
		set firstwayp $latestadded
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint =="" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	if { $latestadded == 0 } {
		set hwaypointout [ open "scripts/waypoints.scp" a ]
	} else {
		set hwaypointout [ open "scripts/extra/ways/Way$pname.scp" a ]
		puts $hwaypointout "next=$lastWP\n"
	}

	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"

	if { $latestadded == 0 } {
		puts $hwaypointout "pos=$x $y $z\n"
	} else {
		puts $hwaypointout "pos=$x $y $z"
	}

	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile

	if { $latestadded == 0 } {
		return "Waypoint $lastWP [ ::Texts::Get "created" ]."
	} else {
		set wayfile [ open "saves/ways/saveway$pname" w ]
		puts $wayfile $lastWP
		puts $wayfile $firstwayp
		close $wayfile
		return "Waypoint $lastWP [ ::Texts::Get "created_for_route_and" ] $latestadded ."
	}
}


#
#	proc ::WoWEmu::Commands::ban { player cargs }
#
proc ::WoWEmu::Commands::ban { player cargs } {
	set ip_file "scripts/conf/banned.conf"

	if { [ ::GetObjectType [ ::GetSelection $player ] ] == 4} {
		return [ ::Texts::Get "plevel_conflict" ]
	}

	if { $cargs == "" } {
		return [ ::Texts::Get "banip_usage" ]
	}

	if { $cargs == "list" } {
		set base_name ""
		set ip [ open $ip_file r ]

		while { [ gets $ip line ] >= 0 } {
			set line [ string trim $line ]

			if { $line != "" && [ string index $line 0 ] != "#" } {
				lappend base_name $line
			}
		}

		close $ip
		return "$base_name"
	}

	if { $cargs == "undo" } {
		if { [ ::GetPlevel $player ] < 6 } {
			return [ ::Texts::Get "not_allowed" ]
		}

		set tcount 0
		set base_name ""
		set ip [ open $ip_file r ]

		while { [ gets $ip line ] >= 0 } {
			set line [ string trim $line ]

			if { $line != "" && [ string index $line 0 ] != "#" } {
				lappend base_name $line
				set tcount [ expr { $tcount + 1 } ]
			}
		}

		close $ip

		# stop [banned] being removed 1st line
		if { $tcount <= 1 } {
			return "[ ::Texts::Get "no_ips_lines_to_remove" ] $base_name"
		}

		Say $player 0 "$tcount"
		set oldcount [ expr { $tcount - 1 } ]
		set tcount 0
		set data " "
		set ip [ open $ip_file w ]

		foreach ipno $base_name {
			set writedata [ lindex $base_name $tcount ]

			if { $tcount == $oldcount } {
				puts $ip $data
			} else {
				puts $ip $writedata
				#Say $player 0 "TO WRITE > $writedata"
			}

			set tcount [ expr { $tcount + 1 } ]
		}

		close $ip
		return "[ ::Texts::Get "undo_done_last_line" ]: $base_name"
	}

	set gmname [ ::GetName $player ]
	set base_name ""
	set log_name ""
	set banip "ip=$cargs/255.255.255.0"
	set logip "ip=$cargs/255.255.255.0 $gmname"
	set iplist ""
	set ip [ open $ip_file r ]

	while { [ gets $ip line ] >= 0 } {
		set line [ string trim $line ]

		if { $line != "" && [ string index $line 0 ] != "#" } {
			if { $line == $banip } {
				close $ip
				return [ ::Texts::Get "ip_already_banned" ]
			}

			lappend base_name $line
			lappend log_name $line
		}
	}

	close $ip
	lappend base_name $banip
	lappend log_name $logip
	#Say $player 0 "read > $base_name"
	set ip [ open $ip_file w ]
	set tcount 0

	foreach ipno $base_name {
		set writedata [ lindex $base_name $tcount ]
		puts $ip $writedata
		#Say $player 0 "TO WRITE > $writedata"
		incr tcount
	}

	close $ip
	set ip_file "logs/banned.log"
	set tcount 0

	foreach ipno $log_name {
		set writedata [ lindex $log_name $tcount ]
		::Custom::Log $writedata $ip_file 0
		#Say $player 0 "TO WRITE > $writedata"
		incr tcount
	}

	::Custom::LogCommit $ip_file
	return "[ ::Texts::Get "ip_list_updated_noerror" ] > $base_name"
}


#
#	proc ::WoWEmu::Commands::bug { player cargs }
#
proc ::WoWEmu::Commands::bug { player cargs } {
	set file "logs/bugs.log"
        set selection [ ::GetSelection $player ]

	if { ! [ ::GetSelection $player ] } {
		return [ ::Texts::Get "bug_select" ]
	} else {
		::Custom::Log "[ ::GetName $player ]: $cargs. -(NPC: [ ::GetEntry $selection ])- Loc: .go [ ::GetPos $selection ]" $file
		return [ ::Texts::Get "thank_for_report" ]
	}
}


#
#	proc ::WoWEmu::Commands::changepassword { player cargs }
#
proc ::WoWEmu::Commands::changepassword { player cargs } {
	set conf "scripts/conf/adminpass.conf"

	if { [ file exists $conf ] } {
		set file [ open $conf ]
		gets $file adminpass
		close $file
	} else { return [ ::Texts::Get "no_adminpass_conf" ] }

	if { $adminpass != $cargs } {
		return [ ::Texts::Get "incorrect_password" ]
	}

	set file [ open $conf w+ ]
	set changepass "resetpassword"
	puts $file $changepass
	close $file
	return [ ::Texts::Get "setpassword_enabled" ]
}


#
#	proc ::WoWEmu::Commands::delitem { player cargs }
#
proc ::WoWEmu::Commands::delitem { player cargs } {
	if { [ ::GetObjectType [ ::GetSelection $player ] ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set name [ ::GetName [ ::GetSelection $player ] ]
	set iname [ ::GetScpValue "items.scp" "item $cargs" "name" ]

	if { $iname == "{}" } {
		return [ ::Texts::Get "item_not_found" ]
	}

	if { [ ::ConsumeItem [ ::GetSelection $player ] $cargs 1 ] } {
		return "|c8f20ff20Item $iname ($cargs) [ ::Texts::Get "deleted_from" ] $name"
	} else {
		return "$iname ($cargs) [ ::Texts::Get "not_in_inventory" ] $name"
	}
}


#
#	proc ::WoWEmu::Commands::delmoney { player cargs }
#
proc ::WoWEmu::Commands::delmoney { player cargs } {
	if { [ ::GetSelection $player ] == "0" } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetObjectType [ ::GetSelection $player ] ] != "4"} {
		return [ ::Texts::Get "invalid_selection" ]
	}

	if { [ llength $cargs ] } {
		if { [ lindex $cargs 0 ] } {
			if { ! [ ::ChangeMoney [ ::GetSelection $player ] -[ lindex $cargs 0 ] ] } {
				return "Not enough money"
			} else {
				set copper [ string range [ lindex $cargs 0 ] end-1 end ]
				set silver [ string range [ lindex $cargs 0 ] end-3 end-2 ]
				set gold [ string range [ lindex $cargs 0 ] end-1000 end-4 ]

				if { $copper > 0 } {
					set copper "$copper [ ::Texts::Get "copper" ]"
				} else {
					set copper ""
				}

				if { $silver != "" } {
					if { $silver > 0 } {
						set silver "$silver [ ::Texts::Get "silver" ]"
					} else {
						set silver ""
					}
				}

				if { $gold != "" } {
					set gold "$gold [ ::Texts::Get "gold" ]"
				}

				if { $copper != "" && $silver != "" } {
					set copper ", $copper"
				}

				if { $silver != "" && $gold != "" } {
					set silver ", $silver"
				}

				return "$gold$silver$copper [ ::Texts::Get "removed_from" ] [ ::GetName [ ::GetSelection $player ] ]"
			}
		} else {
			return [ ::Texts::Get "invalid_money" ]
		}
	}

	return "[ ::Texts::Get "bad_cmd_args" ] (.delmoney [ ::Texts::Get "amount" ])"
}


#
#	proc ::WoWEmu::Commands::deltele { player cargs }
#
variable ::WoWEmu::Commands::tbasedir "extra"

proc ::WoWEmu::Commands::deltele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ] > 4 } {
		if { [ string length $cargs ] > 1} {
			set cargs [ string trim [ string tolower $cargs ] ]

			if { [ file exists "extra/locations.dat" ] } {
				set handle [ open "extra/locations.dat" ]
				set x 0
				set linenum ""

				while { [ gets $handle line ] >= 0 } {
					if { [ string tolower [ lrange $line 0 end-4 ] ] == $cargs } {
						set linenum $x
					}

					incr x
				}

				if { $linenum == "" } {
					return [ ::Texts::Get "location_not_found" ]
				}

				close $handle
				set handle [ open "extra/locations.dat" ]
				set data [ split [ read $handle ] \n ]
				close $handle
				set handle [ open "extra/locations.dat" w+ ]
				puts -nonewline $handle [ join [ lreplace $data $linenum $linenum ] \n ]
				close $handle
				return [ ::Texts::Get "location_deleted" ]
			}

			return [ ::Texts::Get "location_not_found" ]
		}

		return [ ::Texts::Get "specify_location" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::endway { player cargs }
#
proc ::WoWEmu::Commands::endway { player cargs } {
	set pname [ ::GetName $player ]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		set wayfile [ open "saves/ways/saveway$pname" r ]
		set latestadded [ gets $wayfile ]
		set firstwayp [ gets $wayfile ]
		close $wayfile
		set hwaypointout [ open "scripts/extra/ways/Way$pname.scp" "a+" ]
		puts $hwaypointout "next=$firstwayp\n"
		close $hwaypointout
		file delete "saves/ways/saveway$pname"
		return "[ ::Texts::Get "way_saved" ] $latestadded [ ::Texts::Get "linked_to_start" ].\n [ ::Texts::Get "way_starts_on" ] $firstwayp."
	} else {
		return [ ::Texts::Get "start_way_before" ]
	}
}


#
#	proc ::WoWEmu::Commands::imit { player cargs }
#
proc ::WoWEmu::Commands::imit { player cargs } {
	set lang [ lindex $cargs 0 ]
	set msg [ lrange $cargs 1 end ]
	set target [ ::GetSelection $player ]
	::Say $target $lang " $msg "
	return
}


#
#	proc ::WoWEmu::Commands::invisible { player cargs }
#
proc ::WoWEmu::Commands::invisible { player cargs } {
	::CastSpell $player $player 1784
	::WoWEmu::Commands::refresh $player $cargs
	return ".setmodel 13069"
}


#
#	proc ::WoWEmu::Commands::langall { player cargs }
#
proc ::WoWEmu::Commands::langall { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only_gm_learn" ]
	}

	::LearnSpell $target 668
	::SetSkill $target 98 300 300
	::LearnSpell $target 669
	::SetSkill $target 109 300 300
	::LearnSpell $target 672
	::SetSkill $target 111 300 300
	::LearnSpell $target 7340
	::SetSkill $target 313 300 300
	::LearnSpell $target 671
	::SetSkill $target 113 300 300
	::LearnSpell $target 7341
	::SetSkill $target 315 300 300
	::LearnSpell $target 17737
	::SetSkill $target 673 300 300
	::LearnSpell $target 670
	::SetSkill $target 115 300 300
	::LearnSpell $target 17334
	::LearnSpell $target 17608
	::LearnSpell $target 17609
	::LearnSpell $target 17610
	::LearnSpell $target 17611
	::LearnSpell $target 17607
	return [ ::Texts::Get "learned_all_langs" ]
}


#
#	proc ::WoWEmu::Commands::learnall { player cargs }
#
proc ::WoWEmu::Commands::learnall { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only_gm_learn" ]
	}

	::LearnSpell $target 9078
	::SetSkill $target 415 1 1
	::LearnSpell $target 9077
	::SetSkill $target 414 1 1
	::LearnSpell $target 8737
	::SetSkill $target 413 1 1
	::LearnSpell $target 16320
	::LearnSpell $target 750
	::SetSkill $target 293 1 1
	::LearnSpell $target 9116
	::SetSkill $target 433 1 1
	::LearnSpell $target 196
	::SetSkill $target 44 1275 1275
	::LearnSpell $target 198
	::SetSkill $target 54 1275 1275
	::LearnSpell $target 201
	::SetSkill $target 43 1275 1275
	::LearnSpell $target 197
	::SetSkill $target 172 1275 1275
	::LearnSpell $target 199
	::SetSkill $target 160 1275 1275
	::LearnSpell $target 202
	::SetSkill $target 55 1275 1275
	::LearnSpell $target 1180
	::SetSkill $target 173 1275 1275
	::LearnSpell $target 264
	::SetSkill $target 45 1275 1275
	::LearnSpell $target 266
	::SetSkill $target 46 1275 1275
	::SetSkill $target 226 1275 1275
	::LearnSpell $target 227
	::SetSkill $target 136 1275 1275
	::LearnSpell $target 5009
	::LearnSpell $target 5019
	::SetSkill $target 228 1275 1275
	::LearnSpell $target 2567
	::SetSkill $target 176 1275 1275
	::LearnSpell $target 203
	::SetSkill $target 162 1275 1275
	::SetSkill $target 95 1275 1275
	::SetSkill $target 148 1 1
	::SetSkill $target 149 1 1
	::SetSkill $target 150 1 1
	::SetSkill $target 152 1 1
	::SetSkill $target 533 1 1
	::SetSkill $target 713 1 1
	::LearnSpell $target 11543
	::LearnSpell $target 11542
	::LearnSpell $target 11544
	::LearnSpell $target 20276
	::LearnSpell $target 24612
	::LearnSpell $target 21655
	::LearnSpell $target 22681
	::LearnSpell $target 23858
	::LearnSpell $target 23860
	return [ ::Texts::Get "learned_gm_spells" ]
}


#
#	proc ::WoWEmu::Commands::listbugs { player cargs }
#
proc ::WoWEmu::Commands::listbugs { player cargs } {
	set file "logs/bugs.log"

	if { $cargs == "" } {
		set cargs 1
	}

	set handle [ open $file r+ ]
	gets $handle pass
	set data [ read $handle ]
	set lines [ split $data \n ]
	set count [ lrange $lines end-$cargs end ]
	close $handle
	return $count
}


#
#	proc ::WoWEmu::Commands::listtele { player cargs }
#
proc ::WoWEmu::Commands::listtele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ] } {
		if { [ file exists "extra/locations.dat" ] } {
			set handle [ open "extra/locations.dat" ]
			set list ""

			while { [ gets $handle line ] >= 0 } {
				set list "$list [ ::Texts::Get "name" ]: [ lrange $line 0 end-4 ] [ ::Texts::Get "target" ]: [ lrange $line end-3 end ]\n"
			}

			close $handle

			if {$list != ""} {
				return "$list"
			}
		}

		return [ ::Texts::Get "no_locations" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::mergewp { player cargs }
#
proc ::WoWEmu::Commands::mergewp { player cargs } {
	variable wbasedir
	set pname [ ::GetName $player ]

	if { [ file exists "scripts/extra/ways/Way$pname.scp" ] } {
		set mainwpfile [ open "scripts/waypoints.scp" "a+" ]
		set wpchainfile [ open "scripts/extra/ways/Way$pname.scp" "r" ]
		set wpchain [ read $wpchainfile ]
		puts $mainwpfile "\n$wpchain\n"
		close $wpchainfile
		close $mainwpfile
		file delete "scripts/extra/ways/Way$pname.scp"
		return "[ ::Texts::Get "file" ] Way$pname.scp [ ::Texts::Get "merged_with_main_file" ]\n[ ::Texts::Get "the_original" ] Way$pname.scp [ ::Texts::Get "deleted_run_rescp" ]"
	} else {
		return "[ ::Texts::Get "missing" ] Way$pname.scp [ ::Texts::Get "file_to_merge" ]"
	}
}


#
#	proc ::WoWEmu::Commands::refresh { player cargs }
#
proc ::WoWEmu::Commands::refresh { player cargs } {
	if { [ ::GetQFlag $player IsDead ] } {
		return [ ::Texts::Get "not_while_dead" ]
	}

	::Custom::TeleportPos $player [ ::GetPos $player ]
}


#
#	proc ::WoWEmu::Commands::setmessage { player cargs }
#
proc ::WoWEmu::Commands::setmessage { player cargs } {
	return ".broadcast $cargs"
}


#
#	proc ::WoWEmu::Commands::setpassword { player cargs }
#
proc ::WoWEmu::Commands::setpassword { player cargs } {
	set conf "scripts/conf/adminpass.conf"

	if { [ file exists $conf ] } {
		set file [ open $conf ]
		gets $file adminpass
		close $file
	} else {
		return [ ::Texts::Get "no_adminpass_conf" ]
	}

	if { $adminpass != "resetpassword" } {
		return [ ::Texts::Get "changepassword_first" ]
	}

	set file [open $conf w+]
	puts $file "$cargs"
	close $file
	return [ ::Texts::Get "password_changed" ]
}


#
#	proc ::WoWEmu::Commands::setwp { player cargs }
#
proc ::WoWEmu::Commands::setwp { player cargs } {
	if { ! [ string is integer $cargs ] } {
		return [ ::Texts::Get "waypoint_doesnt_exist" ]
	}

	set selected [ ::GetSelection $player ]

	if { [ ::GetObjectType $selected ] != 3} {
		return [ ::Texts::Get "select_npc" ]
	}

	::SetWayPoint $selected $cargs
	return "[ ::Texts::Get "ok_waypoint" ] $cargs [ ::Texts::Get "set_for_npc" ]"
}


#
#	proc ::WoWEmu::Commands::showwp { player cargs }
#
proc ::WoWEmu::Commands::showwp { player cargs } {
	set hwaypointfile [ open "saves/lastWPoint.txt" "r" ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint == "" } {
		set lastWP 1
	} else {
		set lastWP $hwaypoint
	}

	for { set i 1 } { $i <= $lastWP } { incr i } {
		set curPos [ lrange [ string trim [ split [ ::GetScpValue "waypoints.scp" "point $i" "pos" ] ] "\\\{\}" ] end-3 end ]
		set x [ expr { round([ lindex $curPos 0 ]) } ]
		set y [ expr { round([ lindex $curPos 1 ]) } ]
		::SendPOI $player 2 $x $y 6 1637 "WayPoint $i"
	}

	return "[ ::Texts::Get "waypoint" ] $hwaipoint [ ::Texts::Get "ok_shown" ]."
}


#
#	proc ::WoWEmu::Commands::startway { player cargs }
#
proc ::WoWEmu::Commands::startway { player cargs } {
	variable wbasedir
	set pname [GetName $player]

	if { [ file exists "saves/ways/saveway$pname" ] } {
		return [ ::Texts::Get "finish_before_new" ]
	}

	set hwaypointfile [ open "saves/lastWPoint.txt" r ]
	set hwaypoint [ gets $hwaypointfile ]
	close $hwaypointfile

	if { $hwaypoint == "" } {
		set lastWP 1
	} else {
		set lastWP [ expr { $hwaypoint + 1 } ]
	}

	foreach { map x y z } [ ::GetPos $player ] {}

	set hwaypointout [ open "scripts/extra/ways/Way$pname.scp" a ]
	set outline1 {[point }
	set outline2 {]}
	puts $hwaypointout "$outline1$lastWP$outline2"
	puts $hwaypointout "pos=$x $y $z"
	close $hwaypointout
	set hwaypointfile [ open "saves/lastWPoint.txt" w ]
	puts -nonewline $hwaypointfile $lastWP
	close $hwaypointfile
	set wayfile [ open "saves/ways/saveway$pname" w ]
	puts $wayfile $lastWP
	puts $wayfile $lastWP
	close $wayfile
	return "[ ::Texts::Get "route_started_waypoint" ] $lastWP [ ::Texts::Get "created" ]."
}


#
#	proc ::WoWEmu::Commands::tele { player cargs }
#
proc ::WoWEmu::Commands::tele { player cargs } {
	variable tbasedir

	if { [ ::GetPlevel $player ]} {
		if { [ string length $cargs ] > 1 } {
			set cargs [ string trim [ string tolower $cargs ] ]

			if { [ file exists "extra/locations.dat" ] } {
				set handle [ open "extra/locations.dat" ]

				while { [ gets $handle line ] >= 0 } {
					set loc [ string tolower [ lrange $line 0 end-4 ] ]

					if { $loc == $cargs } {
						set target [ lrange $line end-3 end ]
						::Custom::TeleportPos $player $target
						return "Teleporting to $target ([ lrange $line 0 end-4 ])"
					}
				}

				close $handle
			}

			return [ ::Texts::Get "location_not_found" ]
		}

		return [ ::Texts::Get "specify_location" ]
	}

	return [ ::Texts::Get "bad_command" ]
}


#
#	proc ::WoWEmu::Commands::visible { player cargs }
#

variable ::WoWEmu::Commands::visiblemodel
array set ::WoWEmu::Commands::visiblemodel {
	1	49
	2	51
	3	53
	4	55
	5	57
	6	59
	7	1563
	8	1478
}

proc ::WoWEmu::Commands::visible { player cargs } {
	variable visiblemodel
	::CastSpell $player $player 12844
	set race [ ::GetRace $player ]

	if { $cargs=="m" } {
		set model $visiblemodel($race)
	} elseif { $cargs=="f" } {
		set model [ expr { $visiblemodel($race) + 1 } ]
	} else {
		return [ ::Texts::Get "specify_gender" ]
	}

	if { $race >= 1 && $race <= 8 } {
		return ".setmodel $model"
	} else {
		return [ ::Texts::Get "now_visible" ]
	}

	return ".refresh"
}


#
# player level 6
#


######### Additional (useless?) procs #########

# proc mapupdate { player args } {
# 	return
# }

# proc autojail {player reason} {
# 	variable jbasedir
# 	set gmname "Server"
# 	set plname [ ::GetName $player ]
# 	set _from [ lindex [ ::GetPos $player ] ]
# 	::Teleport $player 13 0 0 0

# 	if { [ lindex [ ::GetPos $player ] 0 ] == 13 } {
# 		set fh [ open "$jbasedir/jail/$plname" w ]
# 		puts $fh "$reason\n$gmname\n$_from"
# 		close $fh
# 		::SetQFlag $player "jailed"
# 	}
# }

############# End of useless ^^ ################


::Custom::LogCommand {
	"additem"
	"addmoney"
	"ban"
	"delitem"
	"delmoney"
	"jail"
        "imit"
}

::StartTCL::Provide ExtraCommands




# Name:		AOcommands.tcl
# 
# Version:	1.7 beta 2
#
# Description:	some new commands for sets and some spell/skill
#
# Authors: AdonOger
#
# conect: razb13@walla.com(msn or email)
#



#
# player level 4
#
#	proc ::WoWEmu::Commands::learnallform { player cargs }
#
proc ::WoWEmu::Commands::learnallform { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "you have to select player!" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "wtf? he not gm!" ]
	}

	::LearnSpell $target 768
	::LearnSpell $target 775
	::LearnSpell $target 783
	::LearnSpell $target 1066
	::LearnSpell $target 3287
	::LearnSpell $target 3329
	::LearnSpell $target 5142
	::LearnSpell $target 5487
	::LearnSpell $target 6405
	::LearnSpell $target 16421
	::LearnSpell $target 22660
	::LearnSpell $target 9634
	::LearnSpell $target 24858
        return [ ::Texts::Get "Yea! you now learned all Shapeshift skills" ]
}

#	proc ::WoWEmu::Commands::t2warrior { player cargs }
#
proc ::WoWEmu::Commands::t2warrior { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16959
	::AddItem $target 16960
        ::AddItem $target 16961
        ::AddItem $target 16962
	::AddItem $target 16963
	::AddItem $target 16964
        ::AddItem $target 16965
        ::AddItem $target 16966
	return [ ::Texts::Get "you now have the full tier 2 warrior set" ]
}

#	proc ::WoWEmu::Commands::t2paladin { player cargs }
#
proc ::WoWEmu::Commands::t2paladin { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16958
	::AddItem $target 16957
        ::AddItem $target 16956
        ::AddItem $target 16955
	::AddItem $target 16954
	::AddItem $target 16953
        ::AddItem $target 16952
        ::AddItem $target 16951
	return [ ::Texts::Get "you now have the full tier 2 paladin set" ]
}

#	proc ::WoWEmu::Commands::t2shaman { player cargs }
#
proc ::WoWEmu::Commands::t2shaman { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16944
	::AddItem $target 16943
        ::AddItem $target 16950
        ::AddItem $target 16945
	::AddItem $target 16948
	::AddItem $target 16949
        ::AddItem $target 16947
        ::AddItem $target 16946
	return [ ::Texts::Get "you now have the full tier 2 Shaman set" ]
}

#	proc ::WoWEmu::Commands::t2priest { player cargs }
#
proc ::WoWEmu::Commands::t2priest { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16919
	::AddItem $target 16920
        ::AddItem $target 16921
        ::AddItem $target 16922
	::AddItem $target 16923
	::AddItem $target 16924
        ::AddItem $target 16925
        ::AddItem $target 16926
	return [ ::Texts::Get "you now have the full tier 2 priest set" ]
}

#	proc ::WoWEmu::Commands::t2druid { player cargs }
#
proc ::WoWEmu::Commands::t2druid { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16897
	::AddItem $target 16898
        ::AddItem $target 16899
        ::AddItem $target 16900
	::AddItem $target 16901
	::AddItem $target 16902
        ::AddItem $target 16903
        ::AddItem $target 16904
	return [ ::Texts::Get "you now have the full tier 2 druid set" ]
}

#	proc ::WoWEmu::Commands::t2mage { player cargs }
#
proc ::WoWEmu::Commands::t2mage { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16818
	::AddItem $target 16912
        ::AddItem $target 16913
        ::AddItem $target 16915
	::AddItem $target 16916
	::AddItem $target 16917
        ::AddItem $target 16918
        ::AddItem $target 16914
	return [ ::Texts::Get "you now have the full tier 2 mage set" ]
}

#	proc ::WoWEmu::Commands::t2warlock { player cargs }
#
proc ::WoWEmu::Commands::t2warlock { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16927
	::AddItem $target 16928
        ::AddItem $target 16929
        ::AddItem $target 16930
	::AddItem $target 16931
	::AddItem $target 16932
        ::AddItem $target 16933
        ::AddItem $target 16934
	return [ ::Texts::Get "you now have the full tier 2 warlock set" ]
}

#	proc ::WoWEmu::Commands::t2hunter { player cargs }
#
proc ::WoWEmu::Commands::t2hunter { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16935
	::AddItem $target 16936
        ::AddItem $target 16937
        ::AddItem $target 16938
	::AddItem $target 16939
	::AddItem $target 16940
        ::AddItem $target 16941
        ::AddItem $target 16942
	return [ ::Texts::Get "you now have the full tier 2 hunter set" ]
}

#	proc ::WoWEmu::Commands::t2rogue { player cargs }
#
proc ::WoWEmu::Commands::t2rogue { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16832
	::AddItem $target 16905
        ::AddItem $target 16906
        ::AddItem $target 16907
	::AddItem $target 16908
	::AddItem $target 16909
        ::AddItem $target 16910
        ::AddItem $target 16911
	return [ ::Texts::Get "you now have the full tier 2 rogue set" ]
}


#	proc ::WoWEmu::Commands::t3warrior { player cargs }
#
proc ::WoWEmu::Commands::t3warrior { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22418
	::AddItem $target 22422
        ::AddItem $target 22417
        ::AddItem $target 22416
	::AddItem $target 22420
	::AddItem $target 22423
        ::AddItem $target 22421
        ::AddItem $target 22419
	return [ ::Texts::Get "you now have the full tier 3 warrior set" ]
}

#	proc ::WoWEmu::Commands::t3druid { player cargs }
#
proc ::WoWEmu::Commands::t3druid { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22492
	::AddItem $target 22494
        ::AddItem $target 22493
        ::AddItem $target 22490
	::AddItem $target 22489
	::AddItem $target 22491
        ::AddItem $target 22488
        ::AddItem $target 22495
	return [ ::Texts::Get "you now have the full tier 3 druid set" ]
}


#	proc ::WoWEmu::Commands::t3hunter { player cargs }
#
proc ::WoWEmu::Commands::t3hunter { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22440
	::AddItem $target 22442
        ::AddItem $target 22441
        ::AddItem $target 22438 
	::AddItem $target 22437
	::AddItem $target 22439
        ::AddItem $target 22436
        ::AddItem $target 22443
	return [ ::Texts::Get "you now have the full tier 3 hunter set" ]
}

#	proc ::WoWEmu::Commands::t3shaman { player cargs }
#
proc ::WoWEmu::Commands::t3shaman { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22468
	::AddItem $target 22470
        ::AddItem $target 22469
        ::AddItem $target 22466
	::AddItem $target 22465
	::AddItem $target 22467
        ::AddItem $target 22464
        ::AddItem $target 22471
	return [ ::Texts::Get "you now have the full tier 3 Shaman set" ]
}

#	proc ::WoWEmu::Commands::t3paladin { player cargs }
#
proc ::WoWEmu::Commands::t3paladin { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22430
	::AddItem $target 22431
        ::AddItem $target 22426
        ::AddItem $target 22428
	::AddItem $target 22427
	::AddItem $target 22429
        ::AddItem $target 22425
        ::AddItem $target 22424
	return [ ::Texts::Get "you now have the full tier 3 paladin set" ]
}


#	proc ::WoWEmu::Commands::t3warlock { player cargs }
#
proc ::WoWEmu::Commands::t3warlock { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22510
	::AddItem $target 22511
        ::AddItem $target 22506
        ::AddItem $target 22509
	::AddItem $target 22505
	::AddItem $target 22504
        ::AddItem $target 22508
        ::AddItem $target 22507
	return [ ::Texts::Get "you now have the full tier 3 warlock set" ]
}

#	proc ::WoWEmu::Commands::t3mage { player cargs }
#
proc ::WoWEmu::Commands::t3mage { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22502
	::AddItem $target 22503
        ::AddItem $target 22498
        ::AddItem $target 22501
	::AddItem $target 22497
	::AddItem $target 22496
        ::AddItem $target 22500
        ::AddItem $target 22499
	return [ ::Texts::Get "you now have the full tier 3 mage set" ]
}


#	proc ::WoWEmu::Commands::t3priest { player cargs }
#
proc ::WoWEmu::Commands::t3priest { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22515
	::AddItem $target 22516
        ::AddItem $target 22512
        ::AddItem $target 22513
	::AddItem $target 22517
	::AddItem $target 22514
        ::AddItem $target 22519
        ::AddItem $target 22518
	return [ ::Texts::Get "you now have the full tier 3 priest set" ]
}


#	proc ::WoWEmu::Commands::t3rogue { player cargs }
#
proc ::WoWEmu::Commands::t3rogue { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 22483
	::AddItem $target 22476
        ::AddItem $target 22481
        ::AddItem $target 22478
	::AddItem $target 22477
	::AddItem $target 22479
        ::AddItem $target 22480
        ::AddItem $target 22482
	return [ ::Texts::Get "you now have the full tier 3 rogue set" ]
}


#	proc ::WoWEmu::Commands::t1warrior { player cargs }
#
proc ::WoWEmu::Commands::t1warrior { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16867
	::AddItem $target 16868
        ::AddItem $target 16861
        ::AddItem $target 16862
	::AddItem $target 16863
	::AddItem $target 16864
        ::AddItem $target 16865
        ::AddItem $target 16866
	return [ ::Texts::Get "you now have the full tier 1 warrior set" ]
}


#	proc ::WoWEmu::Commands::t1paladin { player cargs }
#
proc ::WoWEmu::Commands::t1paladin { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16858
	::AddItem $target 16859
        ::AddItem $target 16857
        ::AddItem $target 16853
	::AddItem $target 16860
	::AddItem $target 16854
        ::AddItem $target 16855
        ::AddItem $target 16856
	return [ ::Texts::Get "you now have the full tier 1 paladin set" ]
}

#	proc ::WoWEmu::Commands::t1druid { player cargs }
#
proc ::WoWEmu::Commands::t1druid { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16828
	::AddItem $target 16829
        ::AddItem $target 16830
        ::AddItem $target 16833
	::AddItem $target 16831
	::AddItem $target 16834
        ::AddItem $target 16835
        ::AddItem $target 16836
	return [ ::Texts::Get "you now have the full tier 1 druid set" ]
}

#	proc ::WoWEmu::Commands::t1hunter { player cargs }
#
proc ::WoWEmu::Commands::t1hunter { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16851
	::AddItem $target 16849
        ::AddItem $target 16850
        ::AddItem $target 16845
	::AddItem $target 16848
	::AddItem $target 16852
        ::AddItem $target 16846
        ::AddItem $target 16847
	return [ ::Texts::Get "you now have the full tier 1 hunter set" ]
}

#	proc ::WoWEmu::Commands::maxskill { player cargs }
#
proc ::WoWEmu::Commands::maxskill { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}
        
	::LearnSpell $target 201
	::SetSkill $target 43 1275 1275
	::LearnSpell $target 196
	::SetSkill $target 44 1275 1275
	::LearnSpell $target 197
	::SetSkill $target 172 1275 1275
	::LearnSpell $target 202
	::SetSkill $target 55 1275 1275
	::LearnSpell $target 198
	::SetSkill $target 54 1275 1275
	::LearnSpell $target 199
	::SetSkill $target 160 1275 1275
	::LearnSpell $target 200
	::SetSkill $target 229 1275 1275
	::LearnSpell $target 9115
	::LearnSpell $target 227
	::SetSkill $target 136 1275 1275
	::LearnSpell $target 1180
	::SetSkill $target 173 1275 1275
	::LearnSpell $target 5009
	::LearnSpell $target 15590
	::SetSkill $target 473 1275 1275
	::SetSkill $target 95 1275 1275
	::LearnSpell $target 264
	::SetSkill $target 45 1275 1275
	::LearnSpell $target 5011
	::SetSkill $target 226 1275 1275
	::LearnSpell $target 266
	::SetSkill $target 46 1275 1275
	::LearnSpell $target 2567
	::SetSkill $target  176 1275 1275 
	::SetSkill $target 162 1275 1275
	return [ ::Texts::Get "you know learn use all weapon with max skills" ]
}

#	proc ::WoWEmu::Commands::t1mage { player cargs }
#
proc ::WoWEmu::Commands::t1mage { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16802
	::AddItem $target 16799
        ::AddItem $target 16795
        ::AddItem $target 16800
	::AddItem $target 16801
	::AddItem $target 16796
        ::AddItem $target 16797
        ::AddItem $target 16798
	return [ ::Texts::Get "you now have the full tier 1 mage set" ]
}


#	proc ::WoWEmu::Commands::t1priest { player cargs }
#
proc ::WoWEmu::Commands::t1priest { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16811
	::AddItem $target 16813
        ::AddItem $target 16817
        ::AddItem $target 16812
	::AddItem $target 16814
	::AddItem $target 16816
        ::AddItem $target 16815
        ::AddItem $target 16819
	return [ ::Texts::Get "you now have the full tier 1 priest set" ]
}

#	proc ::WoWEmu::Commands::t1rogue { player cargs }
#
proc ::WoWEmu::Commands::t1rogue { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16827
	::AddItem $target 16824
        ::AddItem $target 16825
        ::AddItem $target 16820
	::AddItem $target 16821
	::AddItem $target 16826
        ::AddItem $target 16822
        ::AddItem $target 16823
	return [ ::Texts::Get "you now have the full tier 1 rogue set" ]
}


#	proc ::WoWEmu::Commands::t1shaman { player cargs }
#
proc ::WoWEmu::Commands::t1shaman { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16838
	::AddItem $target 16837
        ::AddItem $target 16840
        ::AddItem $target 16841
	::AddItem $target 16844
	::AddItem $target 16839
        ::AddItem $target 16842
        ::AddItem $target 16843
	return [ ::Texts::Get "you now have the full tier 1 Shaman set" ]
}


#	proc ::WoWEmu::Commands::t1warlock { player cargs }
#
proc ::WoWEmu::Commands::t1warlock { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 4 } {
		return [ ::Texts::Get "only Gm !!" ]
	}

	::AddItem $target 16806
	::AddItem $target 16804
        ::AddItem $target 16805
        ::AddItem $target 16810
	::AddItem $target 16809
	::AddItem $target 16807
        ::AddItem $target 16808
        ::AddItem $target 16803
	return [ ::Texts::Get "you now have the full tier 1 warlock set" ]
}

#
#	proc ::WoWEmu::Commands:res { player cargs }
#
proc ::WoWEmu::Commands::res { player cargs } {
	if { ! $::WoWEmu::ALLOW_RESURRECT_PLAYERS } {
		if { [ ::GetSelection $player ] != $player } {
			return [ ::Texts::Get "not_allowed_players" ]
		}
	}

	return ".resurrect $cargs"
}
#
#	proc ::WoWEmu::Commands::sd { player cargs }
#
proc ::WoWEmu::Commands::sd { player cargs } {
	return ".setspawndist $cargs"
}
#
#	proc ::WoWEmu::Commands::st { player cargs }
#
proc ::WoWEmu::Commands::st { player cargs } {
	return ".setspawntime $cargs"
}
#	proc ::WoWEmu::Commands::apdruid { player cargs }
#
proc ::WoWEmu::Commands::apdruid { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16452
	::AddItem $target 16451
        ::AddItem $target 16449
        ::AddItem $target 16459
	::AddItem $target 16448
	::AddItem $target 16450
	return [ ::Texts::Get "you now have the aliance druid pvp set!" ]
}
#	proc ::WoWEmu::Commands::hpdruid { player cargs }
#
proc ::WoWEmu::Commands::hpdruid { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16554
	::AddItem $target 16555
        ::AddItem $target 16552
        ::AddItem $target 16551
	::AddItem $target 16549
	::AddItem $target 16550
	return [ ::Texts::Get "you now have the horde druid pvp set!" ]
}
#	proc ::WoWEmu::Commands::hphunter { player cargs }
#
proc ::WoWEmu::Commands::hphunter { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16569
	::AddItem $target 16571
        ::AddItem $target 16567
        ::AddItem $target 16565
	::AddItem $target 16566
	::AddItem $target 16568
	return [ ::Texts::Get "you now have the horde hunter pvp set!" ]
}

#	proc ::WoWEmu::Commands::aphunter { player cargs }
#
proc ::WoWEmu::Commands::aphunter { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16466
	::AddItem $target 16465
        ::AddItem $target 16468
        ::AddItem $target 16462
	::AddItem $target 16463
	::AddItem $target 16467
	return [ ::Texts::Get "you now have the aliance hunter pvp set!" ]
}

#	proc ::WoWEmu::Commands::hpmage { player cargs }
#
proc ::WoWEmu::Commands::hpmage { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::well plevel 2 + dude!" ]
	}

	::AddItem $target 16536
	::AddItem $target 16533
        ::AddItem $target 16535
        ::AddItem $target 16539
	::AddItem $target 16540
	::AddItem $target 16534
	return [ ::Texts::Get "you now have the horde mage pvp set!" ]
}

#	proc ::WoWEmu::Commands::apmage { player cargs }
#
proc ::WoWEmu::Commands::apmage { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16441
	::AddItem $target 16444
        ::AddItem $target 16443
        ::AddItem $target 16437
	::AddItem $target 16440
	::AddItem $target 16442
	return [ ::Texts::Get "you now have the aliance mage pvp set!" ]
}

#	proc ::WoWEmu::Commands::pvpaladin { player cargs }
#
proc ::WoWEmu::Commands::pvpaladin { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16473
	::AddItem $target 16474
        ::AddItem $target 16476
        ::AddItem $target 16472
	::AddItem $target 16471
	::AddItem $target 16475
	return [ ::Texts::Get "you now have the paladin pvp set!" ]
}

#	proc ::WoWEmu::Commands::appriest { player cargs }
#
proc ::WoWEmu::Commands::appriest { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 17604
	::AddItem $target 17603
        ::AddItem $target 17605
        ::AddItem $target 17608
	::AddItem $target 17607
	::AddItem $target 17602
	return [ ::Texts::Get "you now have the aliance priest pvp set!" ]
}

#	proc ::WoWEmu::Commands::hppriest { player cargs }
#
proc ::WoWEmu::Commands::hppriest { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 17623
	::AddItem $target 17625
        ::AddItem $target 17622
        ::AddItem $target 17624
	::AddItem $target 17618
	::AddItem $target 17620
	return [ ::Texts::Get "you now have the horde priest pvp set!" ]
}

#	proc ::WoWEmu::Commands::hprogue { player cargs }
#
proc ::WoWEmu::Commands::hprogue { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16563
	::AddItem $target 16561
        ::AddItem $target 16562
        ::AddItem $target 16564
	::AddItem $target 16560
	::AddItem $target 16558
	return [ ::Texts::Get "you now have the horde rogue pvp set!" ]
}


#	proc ::WoWEmu::Commands::aprogue { player cargs }
#
proc ::WoWEmu::Commands::aprogue { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16453
	::AddItem $target 16457
        ::AddItem $target 16455
        ::AddItem $target 16446
	::AddItem $target 16454
	::AddItem $target 16456
	return [ ::Texts::Get "you now have the aliance rogue pvp set!" ]
}

#	proc ::WoWEmu::Commands::pvshaman { player cargs }
#
proc ::WoWEmu::Commands::pvshaman { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16577
	::AddItem $target 16578
        ::AddItem $target 16580
        ::AddItem $target 16573
	::AddItem $target 16574
	::AddItem $target 16579
	return [ ::Texts::Get "you now have the shaman pvp set!" ]
}

#	proc ::WoWEmu::Commands::hpwarlock { player cargs }
#
proc ::WoWEmu::Commands::hpwarlock { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 17586
	::AddItem $target 17588
        ::AddItem $target 17593
        ::AddItem $target 17591
	::AddItem $target 17590
	::AddItem $target 17592
	return [ ::Texts::Get "you now have the horde warlock pvp set!" ]
}

#	proc ::WoWEmu::Commands::apwarlock { player cargs }
#
proc ::WoWEmu::Commands::apwarlock { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 17581
	::AddItem $target 17580
        ::AddItem $target 17583
        ::AddItem $target 17584
	::AddItem $target 17579
	::AddItem $target 17578
	return [ ::Texts::Get "you now have the aliance warlock pvp set!" ]
}

#	proc ::WoWEmu::Commands::hpwarrior { player cargs }
#
proc ::WoWEmu::Commands::hpwarrior { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16541
	::AddItem $target 16542
        ::AddItem $target 16544
        ::AddItem $target 16545
	::AddItem $target 16548
	::AddItem $target 16543
	return [ ::Texts::Get "you now have the horde warrior pvp set!" ]
}


#	proc ::WoWEmu::Commands::apwarrior { player cargs }
#
proc ::WoWEmu::Commands::apwarrior { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "You Need To Select Player" ]
	}

	if { [ ::GetPlevel $target ] < 2 } {
		return [ ::Texts::Get "well plevel 2 + dude!" ]
	}

	::AddItem $target 16477
	::AddItem $target 16478
        ::AddItem $target 16480
        ::AddItem $target 16483
	::AddItem $target 16484
	::AddItem $target 16479
	return [ ::Texts::Get "you now have the aliance warrior pvp set!" ]
}

#	proc ::WoWEmu::Commands::learnallsp { player cargs }
#
proc ::WoWEmu::Commands::learnallsp { player cargs } {
        if { [ ::GetClass $player ] == 1 } {
	LearnSpell $player 100
        LearnSpell $player 772
	LearnSpell $player 6673
	LearnSpell $player 1715
	LearnSpell $player 6546
	LearnSpell $player 7384
	LearnSpell $player 5242
	LearnSpell $player 1160
	LearnSpell $player 2687
	LearnSpell $player 71
	LearnSpell $player 7386
	LearnSpell $player 72
	LearnSpell $player 6572
	LearnSpell $player 694
        LearnSpell $player 6547
	LearnSpell $player 20230
	LearnSpell $player 7400
	LearnSpell $player 6178
	LearnSpell $player 7887
	LearnSpell $player 6548
	LearnSpell $player 7372
	LearnSpell $player 7402
	LearnSpell $player 11572
	LearnSpell $player 11584
	LearnSpell $player 20559
	LearnSpell $player 11578
	LearnSpell $player 11573
	LearnSpell $player 7373
	LearnSpell $player 78
	LearnSpell $player 284
	LearnSpell $player 285
	LearnSpell $player 1608
	LearnSpell $player 11564
	LearnSpell $player 11565
	LearnSpell $player 11566
	LearnSpell $player 11567
	LearnSpell $player 20560
	LearnSpell $player 11574
	LearnSpell $player 11585
	LearnSpell $player 6192
	LearnSpell $player 5246
	LearnSpell $player 6190
	LearnSpell $player 11554
	LearnSpell $player 1161
	LearnSpell $player 2458
	LearnSpell $player 5308
	LearnSpell $player 20252
	LearnSpell $player 1464
	LearnSpell $player 11549
	LearnSpell $player 18499
	LearnSpell $player 20658
	LearnSpell $player 1680
	LearnSpell $player 6552
	LearnSpell $player 8820
	LearnSpell $player 20660
	LearnSpell $player 11550
	LearnSpell $player 20616
	LearnSpell $player 11604
	LearnSpell $player 11555
	LearnSpell $player 20661
	LearnSpell $player 1719
	LearnSpell $player 20617
	LearnSpell $player 11551
	LearnSpell $player 11556
	LearnSpell $player 11605
	LearnSpell $player 20662
	LearnSpell $player 6554
	LearnSpell $player 750
	LearnSpell $player 2565
	LearnSpell $player 676
	LearnSpell $player 7405
	LearnSpell $player 6574
	LearnSpell $player 871
	LearnSpell $player 1671
	LearnSpell $player 7379
	LearnSpell $player 8380
	LearnSpell $player 11600
	LearnSpell $player 11596
	LearnSpell $player 1672
	LearnSpell $player 11601
	LearnSpell $player 11597
	LearnSpell $player 12664
	LearnSpell $player 16466
	LearnSpell $player 12659
	LearnSpell $player 12666
	LearnSpell $player 12679
	LearnSpell $player 12697
	LearnSpell $player 12963
	LearnSpell $player 12296
	LearnSpell $player 12867
	LearnSpell $player 16494
	LearnSpell $player 12714
	LearnSpell $player 12292
	LearnSpell $player 12785
	LearnSpell $player 12704
	LearnSpell $player 12704
	LearnSpell $player 12815
	LearnSpell $player 12833
	LearnSpell $player 23695
	LearnSpell $player 12294
	LearnSpell $player 21551
	LearnSpell $player 21552
	LearnSpell $player 21553
	LearnSpell $player 12838
	LearnSpell $player 12856
	LearnSpell $player 12322
	LearnSpell $player 12999
	LearnSpell $player 13000
	LearnSpell $player 13001
	LearnSpell $player 13002
	LearnSpell $player 12324
	LearnSpell $player 12876
	LearnSpell $player 12877
	LearnSpell $player 12878
	LearnSpell $player 12879
	LearnSpell $player 20496
	LearnSpell $player 12323
	LearnSpell $player 16492
	LearnSpell $player 12861
	LearnSpell $player 12318
	LearnSpell $player 13048
	LearnSpell $player 20503
	LearnSpell $player 23588
	LearnSpell $player 20499
	LearnSpell $player 12328
	LearnSpell $player 20505
	LearnSpell $player 20501
	LearnSpell $player 23881
	LearnSpell $player 12974
	LearnSpell $player 12727
	LearnSpell $player 12753
	LearnSpell $player 12297
	LearnSpell $player 12764
	LearnSpell $player 12962
	LearnSpell $player 12818
	LearnSpell $player 12975
	LearnSpell $player 12944
	LearnSpell $player 12800
	LearnSpell $player 12792
	LearnSpell $player 12765
	LearnSpell $player 12807
	LearnSpell $player 12811
	LearnSpell $player 12803
	LearnSpell $player 12958
	LearnSpell $player 12809
	LearnSpell $player 23922
	LearnSpell $player 16542
	LearnSpell $player 23923
	LearnSpell $player 23924
	LearnSpell $player 23925
	LearnSpell $player 845
	LearnSpell $player 7369
	LearnSpell $player 11608
	LearnSpell $player 11609
	LearnSpell $player 20569
	LearnSpell $player 6343
	LearnSpell $player 8198
	LearnSpell $player 8204
	LearnSpell $player 8205
	LearnSpell $player 11580
	LearnSpell $player 11581          

        }
        
        if { [ ::GetClass $player ] == 11 } {
	LearnSpell $player 8921
	LearnSpell $player 467
	LearnSpell $player 5177
	LearnSpell $player 339
	LearnSpell $player 8924
	LearnSpell $player 782
	LearnSpell $player 5178
	LearnSpell $player 8925
	LearnSpell $player 1062
	LearnSpell $player 770
	LearnSpell $player 2637
	LearnSpell $player 2912
	LearnSpell $player 8926
        LearnSpell $player 2908
	LearnSpell $player 5179
	LearnSpell $player 1075
	LearnSpell $player 8949
	LearnSpell $player 5195
	LearnSpell $player 8927
	LearnSpell $player 778
	LearnSpell $player 5180
	LearnSpell $player 8928
	LearnSpell $player 8950
	LearnSpell $player 8914
	LearnSpell $player 5196
	LearnSpell $player 18657
        LearnSpell $player 8955
	LearnSpell $player 6780
	LearnSpell $player 16914
	LearnSpell $player 8929
	LearnSpell $player 9749
	LearnSpell $player 8951
	LearnSpell $player 22812
	LearnSpell $player 9756
	LearnSpell $player 9833
	LearnSpell $player 8905
	LearnSpell $player 9852
	LearnSpell $player 17401
	LearnSpell $player 9875 
	LearnSpell $player 768
	LearnSpell $player 17002
	LearnSpell $player 1082
	LearnSpell $player 5215
	LearnSpell $player 1079
	LearnSpell $player 1822
	LearnSpell $player 5217
	LearnSpell $player 1850
	LearnSpell $player 3029
	LearnSpell $player 8998
	LearnSpell $player 9492
	LearnSpell $player 783
	LearnSpell $player 6785
	LearnSpell $player 22568
	LearnSpell $player 1823
	LearnSpell $player 9005
	LearnSpell $player 9493
	LearnSpell $player 6793
	LearnSpell $player 5201
	LearnSpell $player 9000
	LearnSpell $player 20719
	LearnSpell $player 22827
	LearnSpell $player 6783
	LearnSpell $player 6787
	LearnSpell $player 1824
	LearnSpell $player 9752
	LearnSpell $player 9821
	LearnSpell $player 22895
	LearnSpell $player 9849
	LearnSpell $player 22828
	LearnSpell $player 9845
	LearnSpell $player 9823
	LearnSpell $player 9866
	LearnSpell $player 1126
	LearnSpell $player 774
	LearnSpell $player 5186
	LearnSpell $player 5232
	LearnSpell $player 1058
	LearnSpell $player 8936
	LearnSpell $player 5187
	LearnSpell $player 1430
	LearnSpell $player 8938
	LearnSpell $player 5188
	LearnSpell $player 6756
	LearnSpell $player 20484
	LearnSpell $player 2090
	LearnSpell $player 8939
	LearnSpell $player 2782
	LearnSpell $player 2893
	LearnSpell $player 5189
	LearnSpell $player 2091
	LearnSpell $player 5234
	LearnSpell $player 20739
	LearnSpell $player 8940
	LearnSpell $player 740
	LearnSpell $player 6778
	LearnSpell $player 3627
	LearnSpell $player 8941
	LearnSpell $player 8903
	LearnSpell $player 8907
	LearnSpell $player 20742
	LearnSpell $player 8910
	LearnSpell $player 8918
	LearnSpell $player 9750
	LearnSpell $player 9758
	LearnSpell $player 9839
	LearnSpell $player 9856
	LearnSpell $player 9888
	LearnSpell $player 9884
	LearnSpell $player 20747
	LearnSpell $player 9862
	LearnSpell $player 5487
	LearnSpell $player 16979
	LearnSpell $player 17007
	LearnSpell $player 6795
	LearnSpell $player 6807
	LearnSpell $player 99
	LearnSpell $player 5229
	LearnSpell $player 5211
	LearnSpell $player 779
	LearnSpell $player 6808
	LearnSpell $player 1735
	LearnSpell $player 780
	LearnSpell $player 6809
	LearnSpell $player 5209
	LearnSpell $player 6798
	LearnSpell $player 9490
	LearnSpell $player 8972
	LearnSpell $player 769
	LearnSpell $player 9634
	LearnSpell $player 9635
	LearnSpell $player 9745
	LearnSpell $player 9754
	LearnSpell $player 8983
	LearnSpell $player 9747
	LearnSpell $player 9880
	LearnSpell $player 9834
	LearnSpell $player 9907
	LearnSpell $player 9901
	LearnSpell $player 9910
	LearnSpell $player 9912
	LearnSpell $player 9853
	LearnSpell $player 18658
	LearnSpell $player 9835
	LearnSpell $player 9876
	LearnSpell $player 17402
	LearnSpell $player 9892
	LearnSpell $player 9898
	LearnSpell $player 9894
	LearnSpell $player 9904
	LearnSpell $player 5221
	LearnSpell $player 6800
	LearnSpell $player 8992
	LearnSpell $player 9829
	LearnSpell $player 9830
	LearnSpell $player 9908
	LearnSpell $player 22829
	LearnSpell $player 22896
	LearnSpell $player 9827
	LearnSpell $player 9850
	LearnSpell $player 9881
	LearnSpell $player 9867
	LearnSpell $player 9913
	LearnSpell $player 9896
	LearnSpell $player 9846
	LearnSpell $player 9840
	LearnSpell $player 9857
	LearnSpell $player 9889
	LearnSpell $player 9841
	LearnSpell $player 9885
	LearnSpell $player 20748
	LearnSpell $player 9858
	LearnSpell $player 9863
	LearnSpell $player 22842
	LearnSpell $player 18960
	LearnSpell $player 16689
	LearnSpell $player 16810
	LearnSpell $player 16811
	LearnSpell $player 16812
	LearnSpell $player 16813
	LearnSpell $player 17329
	LearnSpell $player 5570
	LearnSpell $player 24974
	LearnSpell $player 24975
	LearnSpell $player 24976
	LearnSpell $player 24977
	LearnSpell $player 1066
	LearnSpell $player 5421
	LearnSpell $player 16818
	LearnSpell $player 17249
	LearnSpell $player 16906
	LearnSpell $player 16920
	LearnSpell $player 16825
	LearnSpell $player 16835
	LearnSpell $player 16840
	LearnSpell $player 16864
	LearnSpell $player 16820
	LearnSpell $player 16926
	LearnSpell $player 16913
	LearnSpell $player 16880
	LearnSpell $player 16847
	LearnSpell $player 16901
	LearnSpell $player 24858
	LearnSpell $player 16938
	LearnSpell $player 16951
	LearnSpell $player 16941
	LearnSpell $player 16933
	LearnSpell $player 24866
	LearnSpell $player 16944
	LearnSpell $player 16954
	LearnSpell $player 16975
	LearnSpell $player 16968
	LearnSpell $player 16961
	LearnSpell $player 16857
	LearnSpell $player 16999
	LearnSpell $player 24894
	LearnSpell $player 17390
	LearnSpell $player 17391
	LearnSpell $player 17055
	LearnSpell $player 17061
	LearnSpell $player 17073
	LearnSpell $player 17068
	LearnSpell $player 17082
	LearnSpell $player 17108
	LearnSpell $player 17122
	LearnSpell $player 24972
	LearnSpell $player 17113
	LearnSpell $player 17116
	LearnSpell $player 24946
	LearnSpell $player 17124
	LearnSpell $player 17078
	LearnSpell $player 18562
	LearnSpell $player 17392
	LearnSpell $player 16858
	LearnSpell $player 16859
	LearnSpell $player 16860
	LearnSpell $player 16861
	LearnSpell $player 16862

        }
        
        if { [ ::GetClass $player ] == 3 } {        
	LearnSpell $player 19556
	LearnSpell $player 19587
	LearnSpell $player 19558
	LearnSpell $player 24387
	LearnSpell $player 19612
	LearnSpell $player 19575
	LearnSpell $player 19620
	LearnSpell $player 19596
	LearnSpell $player 19560
	LearnSpell $player 19573
	LearnSpell $player 19602
	LearnSpell $player 19592
	LearnSpell $player 19577
	LearnSpell $player 20895
	LearnSpell $player 19625
	LearnSpell $player 19574
	LearnSpell $player 19415
	LearnSpell $player 19420
	LearnSpell $player 19425
	LearnSpell $player 19431
	LearnSpell $player 19434
	LearnSpell $player 19458
	LearnSpell $player 19500
	LearnSpell $player 19468
	LearnSpell $player 19490
	LearnSpell $player 19494
	LearnSpell $player 19503
	LearnSpell $player 24691
	LearnSpell $player 19506
	LearnSpell $player 19511
	LearnSpell $player 24295
	LearnSpell $player 19153
	LearnSpell $player 19300
	LearnSpell $player 19235
	LearnSpell $player 19160
	LearnSpell $player 19390
	LearnSpell $player 19184
	LearnSpell $player 19245
	LearnSpell $player 19259
	LearnSpell $player 19263
	LearnSpell $player 19287
	LearnSpell $player 24283
	LearnSpell $player 19377
	LearnSpell $player 19373
	LearnSpell $player 19306
	LearnSpell $player 19386
	LearnSpell $player 24297
	LearnSpell $player 19168
	LearnSpell $player 13163
	LearnSpell $player 1978
	LearnSpell $player 1494
	LearnSpell $player 13165
	LearnSpell $player 1513
	LearnSpell $player 14318
	LearnSpell $player 5118
	LearnSpell $player 14319
	LearnSpell $player 13161
	LearnSpell $player 14326
	LearnSpell $player 14320
	LearnSpell $player 13159
	LearnSpell $player 20043
	LearnSpell $player 14327
	LearnSpell $player 14321
	LearnSpell $player 8737
	LearnSpell $player 3044
	LearnSpell $player 1130
	LearnSpell $player 5116
	LearnSpell $player 13549
	LearnSpell $player 14281
	LearnSpell $player 20736
	LearnSpell $player 2643
	LearnSpell $player 13550
	LearnSpell $player 14282
	LearnSpell $player 14274
	LearnSpell $player 14323
	LearnSpell $player 3043
	LearnSpell $player 3045
	LearnSpell $player 13551
	LearnSpell $player 20900
	LearnSpell $player 14283
	LearnSpell $player 15629
	LearnSpell $player 14288
	LearnSpell $player 1543
	LearnSpell $player 14275
	LearnSpell $player 13552
	LearnSpell $player 20901
	LearnSpell $player 14284
	LearnSpell $player 3034
	LearnSpell $player 15630
	LearnSpell $player 14324
	LearnSpell $player 1510
	LearnSpell $player 14289
	LearnSpell $player 14276
	LearnSpell $player 13553
	LearnSpell $player 20902
	LearnSpell $player 14285
	LearnSpell $player 14279
	LearnSpell $player 15631
	LearnSpell $player 13554
	LearnSpell $player 20905
	LearnSpell $player 14294
	LearnSpell $player 19883
	LearnSpell $player 2974
	LearnSpell $player 13795
	LearnSpell $player 1495
	LearnSpell $player 19884
	LearnSpell $player 781
	LearnSpell $player 1499
	LearnSpell $player 19885
	LearnSpell $player 14302
	LearnSpell $player 19880
	LearnSpell $player 13809
	LearnSpell $player 5384
	LearnSpell $player 14269
	LearnSpell $player 19878
	LearnSpell $player 14272
	LearnSpell $player 13813
	LearnSpell $player 14303
	LearnSpell $player 14267
	LearnSpell $player 14310
	LearnSpell $player 19882
	LearnSpell $player 20909
	LearnSpell $player 14316
	LearnSpell $player 14270
	LearnSpell $player 14304
	LearnSpell $player 14273
	LearnSpell $player 19879
	LearnSpell $player 20190
	LearnSpell $player 14322
	LearnSpell $player 20903
	LearnSpell $player 14286
	LearnSpell $player 14277
	LearnSpell $player 14290
	LearnSpell $player 14280
	LearnSpell $player 14325
	LearnSpell $player 13555
	LearnSpell $player 14295
	LearnSpell $player 20904
	LearnSpell $player 14287
	LearnSpell $player 15632
	LearnSpell $player 20906
	LearnSpell $player 24132
	LearnSpell $player 20910
	LearnSpell $player 14317
	LearnSpell $player 14305
	LearnSpell $player 14260
	LearnSpell $player 14261
	LearnSpell $player 14262
	LearnSpell $player 14263
	LearnSpell $player 14264
	LearnSpell $player 14265
	LearnSpell $player 14266
	LearnSpell $player 14271
	LearnSpell $player 14311
	LearnSpell $player 14268
	LearnSpell $player 24133
	LearnSpell $player 883
	LearnSpell $player 2641
	LearnSpell $player 1579        

        }

        if { [ ::GetClass $player ] == 8 } {
	LearnSpell $player 1459 
	LearnSpell $player 12842 
	LearnSpell $player 12592 
	LearnSpell $player 16770 
	LearnSpell $player 6085 
	LearnSpell $player 12577 
	LearnSpell $player 12606 
	LearnSpell $player 12469 
	LearnSpell $player 12605 
	LearnSpell $player 12598 
	LearnSpell $player 11255 
	LearnSpell $player 12043 
	LearnSpell $player 15060 
	LearnSpell $player 12042 
	LearnSpell $player 12341 
	LearnSpell $player 12360 
	LearnSpell $player 12342 
	LearnSpell $player 12353 
	LearnSpell $player 12848 
	LearnSpell $player 18460 
	LearnSpell $player 12350 
        LearnSpell $player 11366 
	LearnSpell $player 12351 
	LearnSpell $player 11113 
	LearnSpell $player 11368 
	LearnSpell $player 11115 
	LearnSpell $player 16766 
	LearnSpell $player 15053 
	LearnSpell $player 12475 
	LearnSpell $player 12571 
	LearnSpell $player 12953 
	LearnSpell $player 12472 
	LearnSpell $player 12488 
	LearnSpell $player 12519 
	LearnSpell $player 16758 
	LearnSpell $player 12497 
	LearnSpell $player 11071 
	LearnSpell $player 12985 
	LearnSpell $player 11170 
	LearnSpell $player 12490 
	LearnSpell $player 11958 
	LearnSpell $player 12579 
	LearnSpell $player 11180 
	LearnSpell $player 11426 
	LearnSpell $player 13043 
	LearnSpell $player 12400 
	LearnSpell $player 12873 
	LearnSpell $player 11129 
	LearnSpell $player 5504 
	LearnSpell $player 587 
	LearnSpell $player 7268 
	LearnSpell $player 118 
	LearnSpell $player 5505 
	LearnSpell $player 2136 
	LearnSpell $player 143 
	LearnSpell $player 116 
	LearnSpell $player 205 
	LearnSpell $player 7300 
	LearnSpell $player 122 
	LearnSpell $player 597 
	LearnSpell $player 604 
	LearnSpell $player 1449 
	LearnSpell $player 1460 
	LearnSpell $player 7269 
	LearnSpell $player 2855 
	LearnSpell $player 1008 
	LearnSpell $player 475 
	LearnSpell $player 5506 
	LearnSpell $player 1463 
	LearnSpell $player 12824 
	LearnSpell $player 8437 
	LearnSpell $player 990 
	LearnSpell $player 7270 
	LearnSpell $player 8450 
	LearnSpell $player 1461 
	LearnSpell $player 759 
	LearnSpell $player 8494 
	LearnSpell $player 8455 
	LearnSpell $player 8438 
	LearnSpell $player 6127 
	LearnSpell $player 6129 
	LearnSpell $player 8451 
	LearnSpell $player 8495 
	LearnSpell $player 8439 
	LearnSpell $player 3552 
	LearnSpell $player 8418 
	LearnSpell $player 10138 
	LearnSpell $player 12825 
	LearnSpell $player 10169 
	LearnSpell $player 10156 
	LearnSpell $player 10144 
	LearnSpell $player 10191 
	LearnSpell $player 10201 
	LearnSpell $player 10273 
	LearnSpell $player 10053 
	LearnSpell $player 10173 
	LearnSpell $player 10139 
	LearnSpell $player 10145 
	LearnSpell $player 10192 
	LearnSpell $player 10170 
	LearnSpell $player 10202 
	LearnSpell $player 10274 
	LearnSpell $player 10054 
	LearnSpell $player 10174 
	LearnSpell $player 10193 
	LearnSpell $player 12826 
	LearnSpell $player 145 
	LearnSpell $player 2137 
	LearnSpell $player 2120 
	LearnSpell $player 3140 
	LearnSpell $player 543 
	LearnSpell $player 2138 
	LearnSpell $player 2948 
	LearnSpell $player 8400 
	LearnSpell $player 2121 
	LearnSpell $player 8444 
	LearnSpell $player 8412 
	LearnSpell $player 8457 
	LearnSpell $player 8401 
	LearnSpell $player 8422 
	LearnSpell $player 8445 
	LearnSpell $player 8402 
	LearnSpell $player 8413 
	LearnSpell $player 8458 
	LearnSpell $player 8423 
	LearnSpell $player 8446 
	LearnSpell $player 10148 
	LearnSpell $player 10197 
	LearnSpell $player 10205 
	LearnSpell $player 10149 
	LearnSpell $player 10215 
	LearnSpell $player 10223 
	LearnSpell $player 10206 
	LearnSpell $player 10199 
	LearnSpell $player 10150 
	LearnSpell $player 10216 
	LearnSpell $player 10207 
	LearnSpell $player 10225 
	LearnSpell $player 10151 
	LearnSpell $player 837 
	LearnSpell $player 10 
	LearnSpell $player 7301 
	LearnSpell $player 7322 
	LearnSpell $player 6143 
	LearnSpell $player 120 
	LearnSpell $player 865 
	LearnSpell $player 8406 
	LearnSpell $player 6141 
	LearnSpell $player 7302 
	LearnSpell $player 8461 
	LearnSpell $player 8407 
	LearnSpell $player 8492 
	LearnSpell $player 8427 
	LearnSpell $player 8408 
	LearnSpell $player 6131 
	LearnSpell $player 7320 
	LearnSpell $player 10159 
	LearnSpell $player 8462 
	LearnSpell $player 10185 
	LearnSpell $player 10179 
	LearnSpell $player 10160 
	LearnSpell $player 10180 
	LearnSpell $player 10219 
	LearnSpell $player 10186 
	LearnSpell $player 10177 
	LearnSpell $player 10230 
	LearnSpell $player 10181 
	LearnSpell $player 10161 
	LearnSpell $player 10187 
	LearnSpell $player 10220 
	LearnSpell $player 130 
	LearnSpell $player 6117 
	LearnSpell $player 11416 
	LearnSpell $player 10059 
	LearnSpell $player 11419 
	LearnSpell $player 22783 
	LearnSpell $player 13031 
	LearnSpell $player 13032 
	LearnSpell $player 13033 
	LearnSpell $player 1953 
	LearnSpell $player 3562 
	LearnSpell $player 3561 
	LearnSpell $player 2139 
	LearnSpell $player 3565 
	LearnSpell $player 12505 
	LearnSpell $player 12522 
	LearnSpell $player 13018 
	LearnSpell $player 12523 
	LearnSpell $player 22782 
	LearnSpell $player 12524 
	LearnSpell $player 13019
	LearnSpell $player 12525 
	LearnSpell $player 12526 
	LearnSpell $player 13020 
	LearnSpell $player 13021 
	LearnSpell $player 18809 
	LearnSpell $player 10157 
	LearnSpell $player 12051
	LearnSpell $player 12502
	LearnSpell $player 11232
	LearnSpell $player 18466
	LearnSpell $player 18462
	LearnSpell $player 12344
	LearnSpell $player 11078
	LearnSpell $player 12352
	LearnSpell $player 11083
	LearnSpell $player 12875
	LearnSpell $player 11095
	LearnSpell $player 12573
	LearnSpell $player 11175
	LearnSpell $player 12580
	LearnSpell $player 11180
	LearnSpell $player 11189
	LearnSpell $player 12593
	LearnSpell $player 6088
	LearnSpell $player 6057
	LearnSpell $player 12499
	LearnSpell $player 11071
	LearnSpell $player 18468

        }

        if { [ ::GetClass $player ] == 4 } {
	LearnSpell $player 14164 
	LearnSpell $player 14154 
	LearnSpell $player 14142
	LearnSpell $player 14167 
	LearnSpell $player 14159 
	LearnSpell $player 14161 
	LearnSpell $player 14137 
	LearnSpell $player 14170 
	LearnSpell $player 14179
	LearnSpell $player 16720 
	LearnSpell $player 14177 
	LearnSpell $player 14259 
	LearnSpell $player 14117 
	LearnSpell $player 14176 
	LearnSpell $player 14195 
	LearnSpell $player 14983 
	LearnSpell $player 13791 
	LearnSpell $player 13863 
	LearnSpell $player 13792 
	LearnSpell $player 13866 
	LearnSpell $player 13856 
	LearnSpell $player 13876 
	LearnSpell $player 14251 
	LearnSpell $player 13872 
	LearnSpell $player 13867 
	LearnSpell $player 13807 
	LearnSpell $player 13845 
	LearnSpell $player 13852 
	LearnSpell $player 13969 
	LearnSpell $player 13964 
	LearnSpell $player 13877 
	LearnSpell $player 13803 
	LearnSpell $player 13859 
	LearnSpell $player 13750 
	LearnSpell $player 18429 
	LearnSpell $player 14065 
	LearnSpell $player 13973 
	LearnSpell $player 14061 
	LearnSpell $player 14069 
	LearnSpell $player 14075 
	LearnSpell $player 14278 
	LearnSpell $player 16504 
	LearnSpell $player 14078 
	LearnSpell $player 14080 
	LearnSpell $player 14095 
	LearnSpell $player 14173 
	LearnSpell $player 14092 
	LearnSpell $player 14185 
	LearnSpell $player 14071 
	LearnSpell $player 16511 
	LearnSpell $player 14183 
	LearnSpell $player 14085 
	LearnSpell $player 14083 
	LearnSpell $player 5171 
	LearnSpell $player 1833 
	LearnSpell $player 408 
	LearnSpell $player 6774 
	LearnSpell $player 8643 
	LearnSpell $player 1776 
	LearnSpell $player 5277 
	LearnSpell $player 2983 
	LearnSpell $player 1766 
	LearnSpell $player 1966 
	LearnSpell $player 1777 
	LearnSpell $player 1767 
	LearnSpell $player 6768 
	LearnSpell $player 8629 
	LearnSpell $player 8637 
	LearnSpell $player 1768 
	LearnSpell $player 1285 
	LearnSpell $player 1303 
	LearnSpell $player 1769 
	LearnSpell $player 11286 
	LearnSpell $player 3127 
	LearnSpell $player 107 
	LearnSpell $player 204 
	LearnSpell $player 9116 
	LearnSpell $player 674 
	LearnSpell $player 1804 
	LearnSpell $player 1784 
	LearnSpell $player 921 
	LearnSpell $player 5967 
	LearnSpell $player 6770 
	LearnSpell $player 1785 
	LearnSpell $player 1725 
	LearnSpell $player 2094 
	LearnSpell $player 1786 
	LearnSpell $player 1787 
	LearnSpell $player 8647 
	LearnSpell $player 703 
	LearnSpell $player 8631 
	LearnSpell $player 8649 
	LearnSpell $player 8632 
	LearnSpell $player 8650
	LearnSpell $player 8633 
	LearnSpell $player 11197 
	LearnSpell $player 11289 
	LearnSpell $player 11290 
	LearnSpell $player 11300 
	LearnSpell $player 11198 
	LearnSpell $player 11269 
	LearnSpell $player 11275 
	LearnSpell $player 8696 
	LearnSpell $player 11305 
	LearnSpell $player 11281 
	LearnSpell $player 6510 
	LearnSpell $player 3420 
	LearnSpell $player 3421 
	LearnSpell $player 2835 
	LearnSpell $player 2837 
	LearnSpell $player 11357 
	LearnSpell $player 11358 
	LearnSpell $player 8681 
	LearnSpell $player 8687 
	LearnSpell $player 8691 
	LearnSpell $player 11341 
	LearnSpell $player 11342 
	LearnSpell $player 11343 
	LearnSpell $player 2842 
	LearnSpell $player 5763
	LearnSpell $player 8694 
	LearnSpell $player 11400 
	LearnSpell $player 1856 
	LearnSpell $player 2836 
	LearnSpell $player 2070 
	LearnSpell $player 1842 
	LearnSpell $player 1857 
	LearnSpell $player 11297 
	LearnSpell $player 11294 
	LearnSpell $player 17347 
	LearnSpell $player 1860 
	LearnSpell $player 17348 

        }

        if { [ ::GetClass $player ] == 2 } {
	LearnSpell $player 20208
	LearnSpell $player 20239
	LearnSpell $player 20235
	LearnSpell $player 20242
	LearnSpell $player 20215
	LearnSpell $player 20248
	LearnSpell $player 20332
	LearnSpell $player 20251
	LearnSpell $player 20216
	LearnSpell $player 20256
	LearnSpell $player 20261
	LearnSpell $player 20363
	LearnSpell $player 20218
	LearnSpell $player 20266
	LearnSpell $player 20473
	LearnSpell $player 20142
	LearnSpell $player 20137
	LearnSpell $player 20147
	LearnSpell $player 20175
	LearnSpell $player 20472
	LearnSpell $player 20152
	LearnSpell $player 20110
	LearnSpell $player 20204
	LearnSpell $player 20491
	LearnSpell $player 20169
	LearnSpell $player 20195
	LearnSpell $player 20182
	LearnSpell $player 20200
	LearnSpell $player 20066
	LearnSpell $player 20048
	LearnSpell $player 20105
	LearnSpell $player 20338
	LearnSpell $player 20115
	LearnSpell $player 20059
	LearnSpell $player 20375
	LearnSpell $player 20100
	LearnSpell $player 20064
	LearnSpell $player 20095
	LearnSpell $player 20116
	LearnSpell $player 20193
	LearnSpell $player 20121
	LearnSpell $player 20217
	LearnSpell $player 3127
	LearnSpell $player 204
	LearnSpell $player 639
	LearnSpell $player 1152
	LearnSpell $player 633
	LearnSpell $player 20287
	LearnSpell $player 7328
	LearnSpell $player 19742
	LearnSpell $player 647
	LearnSpell $player 20288
	LearnSpell $player 498
	LearnSpell $player 1022
	LearnSpell $player 20163
	LearnSpell $player 1044
	LearnSpell $player 5573
	LearnSpell $player 19740
	LearnSpell $player 20271
	LearnSpell $player 21082
	LearnSpell $player 853
	LearnSpell $player 19834
	LearnSpell $player 20162
	LearnSpell $player 879
	LearnSpell $player 19750
	LearnSpell $player 1026
	LearnSpell $player 19850
	LearnSpell $player 10322
	LearnSpell $player 2878
	LearnSpell $player 5502
	LearnSpell $player 19939
	LearnSpell $player 20289
	LearnSpell $player 5614
	LearnSpell $player 1042
	LearnSpell $player 2800
	LearnSpell $player 20165
	LearnSpell $player 19852
	LearnSpell $player 19940
	LearnSpell $player 20290
	LearnSpell $player 5615
	LearnSpell $player 10324
	LearnSpell $player 3472
	LearnSpell $player 20166
	LearnSpell $player 5627
	LearnSpell $player 19977
	LearnSpell $player 20347
	LearnSpell $player 4987
	LearnSpell $player 19941
	LearnSpell $player 20291
	LearnSpell $player 19853
	LearnSpell $player 10312
	LearnSpell $player 10328
	LearnSpell $player 20772
	LearnSpell $player 20356
	LearnSpell $player 19978
	LearnSpell $player 19942
	LearnSpell $player 2812
	LearnSpell $player 10310
	LearnSpell $player 20348
	LearnSpell $player 20292
	LearnSpell $player 10313
	LearnSpell $player 10326
	LearnSpell $player 19854
	LearnSpell $player 10329
	LearnSpell $player 19943
	LearnSpell $player 20293
	LearnSpell $player 20357
	LearnSpell $player 19979
	LearnSpell $player 10314
	LearnSpell $player 10318
	LearnSpell $player 20773
	LearnSpell $player 20349
	LearnSpell $player 19746
	LearnSpell $player 20164
	LearnSpell $player 5599
	LearnSpell $player 1038
	LearnSpell $player 20419
	LearnSpell $player 19752
	LearnSpell $player 642
	LearnSpell $player 20421
	LearnSpell $player 10278
	LearnSpell $player 6940
	LearnSpell $player 20422
	LearnSpell $player 1020
	LearnSpell $player 19896
	LearnSpell $player 20729
	LearnSpell $player 19898
	LearnSpell $player 20423
	LearnSpell $player 10293
	LearnSpell $player 19900
	LearnSpell $player 19835
	LearnSpell $player 20305
	LearnSpell $player 5588
	LearnSpell $player 19836
	LearnSpell $player 20306
	LearnSpell $player 5589
	LearnSpell $player 19837
	LearnSpell $player 20307
	LearnSpell $player 19838
	LearnSpell $player 20308
	LearnSpell $player 10308
	LearnSpell $player 10301
	LearnSpell $player 13819
	LearnSpell $player 20929
	LearnSpell $player 20930
	LearnSpell $player 24239
	LearnSpell $player 24274
	LearnSpell $player 24275
	LearnSpell $player 20911
	LearnSpell $player 20912
	LearnSpell $player 20925
	LearnSpell $player 20913
	LearnSpell $player 20927
	LearnSpell $player 20914
	LearnSpell $player 20928
	LearnSpell $player 20915
	LearnSpell $player 20922
	LearnSpell $player 20918
	LearnSpell $player 20923
	LearnSpell $player 20919
	LearnSpell $player 20924
	LearnSpell $player 20920       

        }

        if { [ ::GetClass $player ] == 7 } {
	LearnSpell $player 8042
	LearnSpell $player 2484
	LearnSpell $player 8044
	LearnSpell $player 529
	LearnSpell $player 5730
	LearnSpell $player 8050
	LearnSpell $player 1535
	LearnSpell $player 370
	LearnSpell $player 3599
	LearnSpell $player 8045
	LearnSpell $player 548
	LearnSpell $player 8052
	LearnSpell $player 6390
	LearnSpell $player 8056
	LearnSpell $player 915
	LearnSpell $player 6363
	LearnSpell $player 8498
	LearnSpell $player 8046
	LearnSpell $player 943
	LearnSpell $player 8190
	LearnSpell $player 8053
	LearnSpell $player 6391
	LearnSpell $player 6364
	LearnSpell $player 421
	LearnSpell $player 8499
	LearnSpell $player 6041
	LearnSpell $player 8012
	LearnSpell $player 8058
	LearnSpell $player 10412
	LearnSpell $player 10585
	LearnSpell $player 10391
	LearnSpell $player 6392
	LearnSpell $player 930
	LearnSpell $player 10447
	LearnSpell $player 6365
	LearnSpell $player 11314
	LearnSpell $player 10392
	LearnSpell $player 10472
	LearnSpell $player 10586
	LearnSpell $player 2860
	LearnSpell $player 10413
	LearnSpell $player 10427
	LearnSpell $player 15207
	LearnSpell $player 10437
	LearnSpell $player 11315
	LearnSpell $player 10448
	LearnSpell $player 10605
	LearnSpell $player 15208
	LearnSpell $player 10587
	LearnSpell $player 10473
	LearnSpell $player 10428
	LearnSpell $player 10414
	LearnSpell $player 10438
	LearnSpell $player 8017
	LearnSpell $player 8071
	LearnSpell $player 8018
	LearnSpell $player 8024
	LearnSpell $player 8075
	LearnSpell $player 8154
	LearnSpell $player 8019
	LearnSpell $player 8027
	LearnSpell $player 8033
	LearnSpell $player 2645
	LearnSpell $player 131
	LearnSpell $player 8181
	LearnSpell $player 10399
	LearnSpell $player 8155
	LearnSpell $player 8160
	LearnSpell $player 6196
	LearnSpell $player 8030
	LearnSpell $player 8184
	LearnSpell $player 8227
	LearnSpell $player 8038
	LearnSpell $player 546
	LearnSpell $player 556
	LearnSpell $player 8177
	LearnSpell $player 10595
	LearnSpell $player 8232
	LearnSpell $player 8512
	LearnSpell $player 16314
	LearnSpell $player 6495
	LearnSpell $player 10406
	LearnSpell $player 16339
	LearnSpell $player 15107
	LearnSpell $player 8249
	LearnSpell $player 10478
	LearnSpell $player 10456
	LearnSpell $player 8161
	LearnSpell $player 8235
	LearnSpell $player 10537
	LearnSpell $player 8835
	LearnSpell $player 10613
	LearnSpell $player 10600
	LearnSpell $player 16315
	LearnSpell $player 10407
	LearnSpell $player 16341
	LearnSpell $player 15111
	LearnSpell $player 10526
	LearnSpell $player 16355
	LearnSpell $player 10486
	LearnSpell $player 10442
	LearnSpell $player 10614
	LearnSpell $player 10479
	LearnSpell $player 16316
	LearnSpell $player 10408
	LearnSpell $player 16342
	LearnSpell $player 10627
	LearnSpell $player 15112
	LearnSpell $player 10538
	LearnSpell $player 16387
	LearnSpell $player 16356
	LearnSpell $player 10601
	LearnSpell $player 16362
	LearnSpell $player 8737
	LearnSpell $player 332
	LearnSpell $player 2008
	LearnSpell $player 547
	LearnSpell $player 526
	LearnSpell $player 913
	LearnSpell $player 8143
	LearnSpell $player 8004
	LearnSpell $player 2870
	LearnSpell $player 8166
	LearnSpell $player 5394
	LearnSpell $player 20609
	LearnSpell $player 939
	LearnSpell $player 5675
	LearnSpell $player 8008
	LearnSpell $player 6375
	LearnSpell $player 20608
	LearnSpell $player 959
	LearnSpell $player 20610
	LearnSpell $player 8010
	LearnSpell $player 10495
	LearnSpell $player 8170
	LearnSpell $player 1064
	LearnSpell $player 6377
	LearnSpell $player 8005
	LearnSpell $player 10466
	LearnSpell $player 10622
	LearnSpell $player 10496
	LearnSpell $player 20776
	LearnSpell $player 10395
	LearnSpell $player 10462
	LearnSpell $player 10467
	LearnSpell $player 10623
	LearnSpell $player 10396
	LearnSpell $player 10497
	LearnSpell $player 20777
	LearnSpell $player 10463
	LearnSpell $player 10468
	LearnSpell $player 16108
	LearnSpell $player 16159
	LearnSpell $player 16163
	LearnSpell $player 16112
	LearnSpell $player 16127
	LearnSpell $player 16544
	LearnSpell $player 16116
	LearnSpell $player 16129
	LearnSpell $player 16120
	LearnSpell $player 16133
	LearnSpell $player 16164
	LearnSpell $player 16089
	LearnSpell $player 16166
	LearnSpell $player 16123
	LearnSpell $player 16582
	LearnSpell $player 16229
	LearnSpell $player 16217
	LearnSpell $player 16225
	LearnSpell $player 16242
	LearnSpell $player 16200
	LearnSpell $player 16204
	LearnSpell $player 16209
	LearnSpell $player 16234
	LearnSpell $player 16189
	LearnSpell $player 16221
	LearnSpell $player 16188
	LearnSpell $player 16208
	LearnSpell $player 16190
	LearnSpell $player 17354
	LearnSpell $player 17359
	LearnSpell $player 16301
	LearnSpell $player 17489
	LearnSpell $player 16305
	LearnSpell $player 16287
	LearnSpell $player 16291
	LearnSpell $player 16274
	LearnSpell $player 16269
	LearnSpell $player 16292
	LearnSpell $player 16284
	LearnSpell $player 16296
	LearnSpell $player 16294
	LearnSpell $player 16285
	LearnSpell $player 16268
	LearnSpell $player 16286
	LearnSpell $player 16297
	LearnSpell $player 16288
	LearnSpell $player 16547
	LearnSpell $player 17364
	LearnSpell $player 16309
	LearnSpell $player 16213
	LearnSpell $player 324
	LearnSpell $player 325
	LearnSpell $player 905
	LearnSpell $player 945
	LearnSpell $player 8134
	LearnSpell $player 10431
	LearnSpell $player 10432        
        
        }

        if { [ ::GetClass $player ] == 5 } {
	LearnSpell $player 1243
	LearnSpell $player 17
	LearnSpell $player 10797
	LearnSpell $player 588
	LearnSpell $player 1244
	LearnSpell $player 592
	LearnSpell $player 527
	LearnSpell $player 600
	LearnSpell $player 19296
	LearnSpell $player 2052
	LearnSpell $player 591
	LearnSpell $player 139
	LearnSpell $player 2053
	LearnSpell $player 2006
	LearnSpell $player 528
	LearnSpell $player 6074
	LearnSpell $player 598
	LearnSpell $player 2054
	LearnSpell $player 589
	LearnSpell $player 586
	LearnSpell $player 8092
	LearnSpell $player 594
	LearnSpell $player 8122
	LearnSpell $player 8102
	LearnSpell $player 970
	LearnSpell $player 14791
	LearnSpell $player 14787
	LearnSpell $player 14767
	LearnSpell $player 14769
	LearnSpell $player 14774
	LearnSpell $player 14529
	LearnSpell $player 14528
	LearnSpell $player 18555
	LearnSpell $player 14783
	LearnSpell $player 14772
	LearnSpell $player 14751
	LearnSpell $player 14771
	LearnSpell $player 14779
	LearnSpell $player 14752
	LearnSpell $player 17193
	LearnSpell $player 15011
	LearnSpell $player 15031
	LearnSpell $player 18539
	LearnSpell $player 15356
	LearnSpell $player 15365
	LearnSpell $player 15016
	LearnSpell $player 15012
	LearnSpell $player 15018
	LearnSpell $player 20711
	LearnSpell $player 14914
	LearnSpell $player 18535
	LearnSpell $player 15237
	LearnSpell $player 15338
	LearnSpell $player 15326
	LearnSpell $player 15330
	LearnSpell $player 15407
	LearnSpell $player 17325
	LearnSpell $player 15316
	LearnSpell $player 15311
	LearnSpell $player 15286
	LearnSpell $player 15334
	LearnSpell $player 15448
	LearnSpell $player 15487
	LearnSpell $player 15317
	LearnSpell $player 15322
	LearnSpell $player 15473
	LearnSpell $player 15310
	LearnSpell $player 18550
	LearnSpell $player 15027
	LearnSpell $player 14818
	LearnSpell $player 14819
	LearnSpell $player 15430
	LearnSpell $player 15431
	LearnSpell $player 988
	LearnSpell $player 1706
	LearnSpell $player 2060
	LearnSpell $player 10963
	LearnSpell $player 10964
	LearnSpell $player 10965
	LearnSpell $player 2651
	LearnSpell $player 7128
	LearnSpell $player 9484
	LearnSpell $player 8129
	LearnSpell $player 1245
	LearnSpell $player 3747
	LearnSpell $player 19299
	LearnSpell $player 19289
	LearnSpell $player 602
	LearnSpell $player 6065
	LearnSpell $player 8131
	LearnSpell $player 19302
	LearnSpell $player 2791
	LearnSpell $player 6066
	LearnSpell $player 19291
	LearnSpell $player 1006
	LearnSpell $player 10874
	LearnSpell $player 9485
	LearnSpell $player 2061
	LearnSpell $player 6075
	LearnSpell $player 2055
	LearnSpell $player 2010
	LearnSpell $player 984
	LearnSpell $player 15262
	LearnSpell $player 9472
	LearnSpell $player 6076
	LearnSpell $player 6063
	LearnSpell $player 15263
	LearnSpell $player 596
	LearnSpell $player 1004
	LearnSpell $player 552
	LearnSpell $player 9473
	LearnSpell $player 6077
	LearnSpell $player 6064
	LearnSpell $player 10880
	LearnSpell $player 15264
	LearnSpell $player 9474
	LearnSpell $player 6078
	LearnSpell $player 6060
	LearnSpell $player 996
	LearnSpell $player 9578
	LearnSpell $player 453
	LearnSpell $player 8103
	LearnSpell $player 2096
	LearnSpell $player 992
	LearnSpell $player 8104
	LearnSpell $player 17311
	LearnSpell $player 8124
	LearnSpell $player 9579
	LearnSpell $player 605
	LearnSpell $player 976
	LearnSpell $player 8105
	LearnSpell $player 2767
	LearnSpell $player 17312
	LearnSpell $player 8192
	LearnSpell $player 9592
	LearnSpell $player 8106
	LearnSpell $player 10898
	LearnSpell $player 19303
	LearnSpell $player 10875
	LearnSpell $player 10937
	LearnSpell $player 10899
	LearnSpell $player 19292
	LearnSpell $player 10951
	LearnSpell $player 19304
	LearnSpell $player 15265
	LearnSpell $player 10915
	LearnSpell $player 10927
	LearnSpell $player 10881 
	LearnSpell $player 10933
	LearnSpell $player 15266
	LearnSpell $player 10916
	LearnSpell $player 10960
	LearnSpell $player 10928
	LearnSpell $player 10888
	LearnSpell $player 10957
	LearnSpell $player 10892
	LearnSpell $player 10911
	LearnSpell $player 17313
	LearnSpell $player 10909
	LearnSpell $player 10945
	LearnSpell $player 10941
	LearnSpell $player 10893
	LearnSpell $player 10900
	LearnSpell $player 10876
	LearnSpell $player 19305
	LearnSpell $player 19293
	LearnSpell $player 10952
	LearnSpell $player 10938
	LearnSpell $player 10901
	LearnSpell $player 10955
	LearnSpell $player 15267
	LearnSpell $player 10934
	LearnSpell $player 10917
	LearnSpell $player 10929
	LearnSpell $player 20770
	LearnSpell $player 15261
	LearnSpell $player 10961
	LearnSpell $player 10946
	LearnSpell $player 17314
	LearnSpell $player 10953
	LearnSpell $player 10890
	LearnSpell $player 10958
	LearnSpell $player 10947
	LearnSpell $player 10912
	LearnSpell $player 10894
	LearnSpell $player 10942
	LearnSpell $player 18807

        }

        if { [ ::GetClass $player ] == 9 } {
	LearnSpell $player 172
	LearnSpell $player 702
	LearnSpell $player 1454
	LearnSpell $player 980
	LearnSpell $player 5782
	LearnSpell $player 1120
	LearnSpell $player 1108
	LearnSpell $player 6201
	LearnSpell $player 696
	LearnSpell $player 755
	LearnSpell $player 348
	LearnSpell $player 695
	LearnSpell $player 707
	LearnSpell $player 705
	LearnSpell $player 18178
	LearnSpell $player 17814
	LearnSpell $player 18181
	LearnSpell $player 18372
	LearnSpell $player 18183
	LearnSpell $player 17808
	LearnSpell $player 18288
	LearnSpell $player 17787
	LearnSpell $player 18830
	LearnSpell $player 18219
	LearnSpell $player 18095
	LearnSpell $player 18393
	LearnSpell $player 18223
	LearnSpell $player 18265
	LearnSpell $player 18313
	LearnSpell $player 18275
	LearnSpell $player 18220
	LearnSpell $player 18693
	LearnSpell $player 18696
	LearnSpell $player 18701
	LearnSpell $player 18707
	LearnSpell $player 18704
	LearnSpell $player 18746
	LearnSpell $player 18752
	LearnSpell $player 18708
	LearnSpell $player 18756
	LearnSpell $player 18710
	LearnSpell $player 18773
	LearnSpell $player 18768
	LearnSpell $player 18767
	LearnSpell $player 18788
	LearnSpell $player 18825
	LearnSpell $player 23825
	LearnSpell $player 18775
	LearnSpell $player 19028
	LearnSpell $player 17803
	LearnSpell $player 17782
	LearnSpell $player 18123
	LearnSpell $player 17792
	LearnSpell $player 18129
	LearnSpell $player 18127
	LearnSpell $player 18134
	LearnSpell $player 18130
	LearnSpell $player 17877
	LearnSpell $player 17932
	LearnSpell $player 17918
	LearnSpell $player 18136
	LearnSpell $player 18135
	LearnSpell $player 18073
	LearnSpell $player 18096
	LearnSpell $player 17836
	LearnSpell $player 17815
	LearnSpell $player 17959
	LearnSpell $player 17962
	LearnSpell $player 17958
	LearnSpell $player 688
	LearnSpell $player 18879
	LearnSpell $player 11712
	LearnSpell $player 18880
	LearnSpell $player 18937
	LearnSpell $player 11713
	LearnSpell $player 603
	LearnSpell $player 18881
	LearnSpell $player 18938
	LearnSpell $player 20756
	LearnSpell $player 1122
	LearnSpell $player 20757
	LearnSpell $player 18540
	LearnSpell $player 18930
	LearnSpell $player 6353
	LearnSpell $player 18931
	LearnSpell $player 17924
	LearnSpell $player 18932
	LearnSpell $player 6222
	LearnSpell $player 704
	LearnSpell $player 689
	LearnSpell $player 1455
	LearnSpell $player 1014
	LearnSpell $player 5697
	LearnSpell $player 693
	LearnSpell $player 5676
	LearnSpell $player 706
	LearnSpell $player 3698
	LearnSpell $player 698
	LearnSpell $player 1094
	LearnSpell $player 5740
	LearnSpell $player 1088
	LearnSpell $player 6205
	LearnSpell $player 699
	LearnSpell $player 6223
	LearnSpell $player 5138
	LearnSpell $player 8288
	LearnSpell $player 1714
	LearnSpell $player 1456
	LearnSpell $player 6217
	LearnSpell $player 7658
	LearnSpell $player 709
	LearnSpell $player 7646
	LearnSpell $player 1490
	LearnSpell $player 6213
	LearnSpell $player 7648
	LearnSpell $player 6226
	LearnSpell $player 11687
	LearnSpell $player 11711
	LearnSpell $player 7651
	LearnSpell $player 8289
	LearnSpell $player 5484
	LearnSpell $player 6202
	LearnSpell $player 126
	LearnSpell $player 5500
	LearnSpell $player 132
	LearnSpell $player 710
	LearnSpell $player 6366
	LearnSpell $player 3699
	LearnSpell $player 20752
	LearnSpell $player 1086
	LearnSpell $player 1098
	LearnSpell $player 691
	LearnSpell $player 6229
	LearnSpell $player 5699
	LearnSpell $player 17951
	LearnSpell $player 2362
	LearnSpell $player 3700
	LearnSpell $player 2970
	LearnSpell $player 20755
	LearnSpell $player 11733
	LearnSpell $player 18867
	LearnSpell $player 17919
	LearnSpell $player 1106
	LearnSpell $player 1949
	LearnSpell $player 2941
	LearnSpell $player 18868
	LearnSpell $player 6219
	LearnSpell $player 17920
	LearnSpell $player 7641
	LearnSpell $player 11665
	LearnSpell $player 18869
	LearnSpell $player 11721
	LearnSpell $player 11699
	LearnSpell $player 11688
	LearnSpell $player 11719
	LearnSpell $player 11675
	LearnSpell $player 11700
	LearnSpell $player 17928
	LearnSpell $player 6215
	LearnSpell $player 11689
	LearnSpell $player 11722
	LearnSpell $player 17952
	LearnSpell $player 11729
	LearnSpell $player 18647
	LearnSpell $player 17727
	LearnSpell $player 11734
	LearnSpell $player 11743
	LearnSpell $player 17953
	LearnSpell $player 11730
	LearnSpell $player 17728
	LearnSpell $player 11735
	LearnSpell $player 11677
	LearnSpell $player 18870
	LearnSpell $player 11667
	LearnSpell $player 18871
	LearnSpell $player 11678
	LearnSpell $player 11668
	LearnSpell $player 7659
	LearnSpell $player 11707
	LearnSpell $player 6789
	LearnSpell $player 11671
	LearnSpell $player 17862
	LearnSpell $player 11703
	LearnSpell $player 11739
	LearnSpell $player 11725
	LearnSpell $player 11693
	LearnSpell $player 11683
	LearnSpell $player 17921
	LearnSpell $player 11659
	LearnSpell $player 17925
	LearnSpell $player 11708
	LearnSpell $player 11672
	LearnSpell $player 11704
	LearnSpell $player 11717
	LearnSpell $player 17937
	LearnSpell $player 17926
	LearnSpell $player 11694
	LearnSpell $player 11740
	LearnSpell $player 11726
	LearnSpell $player 11695
	LearnSpell $player 17922
	LearnSpell $player 11660
	LearnSpell $player 11684
	LearnSpell $player 17923
	LearnSpell $player 11661
	LearnSpell $player 697
	LearnSpell $player 712
	LearnSpell $player 8176
	LearnSpell $player 5784
	LearnSpell $player 23161
	LearnSpell $player 172
	LearnSpell $player 6222
	LearnSpell $player 6223
	LearnSpell $player 7648
	LearnSpell $player 11671
	LearnSpell $player 11672
	LearnSpell $player 6229
	LearnSpell $player 11739
	LearnSpell $player 11740
	LearnSpell $player 348
	LearnSpell $player 707
	LearnSpell $player 1094
	LearnSpell $player 2941
	LearnSpell $player 11665
	LearnSpell $player 11667
	LearnSpell $player 11668
	LearnSpell $player 686
	LearnSpell $player 695
	LearnSpell $player 705
	LearnSpell $player 1088
	LearnSpell $player 1089
	LearnSpell $player 1106
	LearnSpell $player 7641
	LearnSpell $player 11659
	LearnSpell $player 11660
	LearnSpell $player 11661
	LearnSpell $player 6358
	LearnSpell $player 6307
	LearnSpell $player 7804
	LearnSpell $player 7805
	LearnSpell $player 11766
	LearnSpell $player 11767
	LearnSpell $player 4511
	LearnSpell $player 2947
	LearnSpell $player 8316
	LearnSpell $player 8317
	LearnSpell $player 11770
	LearnSpell $player 11771
	LearnSpell $player 3716
	LearnSpell $player 7809
	LearnSpell $player 7810
	LearnSpell $player 7811
	LearnSpell $player 11774
	LearnSpell $player 11775
	LearnSpell $player 17767
	LearnSpell $player 17850
	LearnSpell $player 17851
	LearnSpell $player 17852
	LearnSpell $player 17853
	LearnSpell $player 17854
	LearnSpell $player 17735
	LearnSpell $player 17750 
	LearnSpell $player 17751
	LearnSpell $player 17752
	LearnSpell $player 7812
	LearnSpell $player 18887
	LearnSpell $player 19478
	LearnSpell $player 19480
	LearnSpell $player 19505
	LearnSpell $player 19731
	LearnSpell $player 19734
	LearnSpell $player 19736
	LearnSpell $player 6360
	LearnSpell $player 7813
	LearnSpell $player 11784
	LearnSpell $player 11785
	LearnSpell $player 7814
	LearnSpell $player 7815
	LearnSpell $player 7816
	LearnSpell $player 11778
	LearnSpell $player 11779
	LearnSpell $player 17780
        
        }
	return [ ::Texts::Get "|cFFFF0000**yea! learned all spells**|r" ]
}

#
#	proc ::WoWEmu::Commands:aohelp { player cargs }
#
proc ::WoWEmu::Commands::aohelp { player cargs } {
	if { $cargs == "" } {
		set plevel [ ::GetPlevel $player ]

		if { $plevel == 2 } {
			return [ ::Texts::Get "only .res for u" ]

		} elseif { $plevel == 3 } {
			return [ ::Texts::Get "only .res for u" ]

		} elseif { $plevel > 4 } {
			return [ ::Texts::Get "AOcommands: \n .AOhelp \n .learnallsk \n .t1class \n .t2class \n .t3class \n .apclass \n .hpclass \n .pvpaladin \n .pvshaman \n .res \n .st \n .sd \n .learnallform \n .maxskill \n for more info read AOreadme.txt" ]

		} else {
			return [ ::Texts::Get "|cFFFF0000**you cant use AOcommands!!**|r" ]
        }
	}

	return
}

#
::Custom::LogCommand {
	"learnallform"
	"maxskill"
	"t3paladin"
	"t3warrior"
        "t3druid"
        "learnallsp"
        "aohelp"
}

::StartTCL::Provide AOcommands

#
# A Better broadcast by Rama v1.0 #
#

namespace eval broadcastcmd {

 ::Custom::AddCommand "b" "::broadcastcmd::broad"
proc broad { player cargs } {
if { [GetPlevel $player] <4 } { return "You cant use this Command!" }
set cargs [ split $cargs ]
switch [ lindex $cargs 0 ] {
"save" {
 	set fcargs [expr [ lindex $cargs 1 ]]
 	if { $fcargs > "0" && $fcargs < "500" } {
set file [open "extra/broadcast/($fcargs).txt" w+]
set text "[ lrange $cargs 2 end ]"
puts $file $text
close $file
return "|cFFFFA333Message Saved!"
	} else {
		return "This number is too Large!" }
}
"use" {
	set fcargs [ lindex $cargs 1 ]
 	if { $fcargs > "0" || $fcargs < "500" } {
 		if {[file exists "extra/broadcast/($fcargs).txt"]} {
set file [open "extra/broadcast/($fcargs).txt"]
set name [GetName $player]
set data [read $file]
return ".broadcast $data |cFFFFA333($name)"
close $file
} else { return "|cFFFFA333This Message don't exist" }
}
}
"list" {
	set fcargs [ lindex $cargs 1 ]
 	if { $fcargs > "0" || $fcargs < "500" } {
 		if {[file exists "extra/broadcast/($fcargs).txt"]} {
set file [open "extra/broadcast/($fcargs).txt" r+]
set data [read $file]
close $file
return "|cFFF0002FMESSAGE: |cFFFFA333$data"
} else { return "|cFFFFA333This Message don't exist" }
}
}
"listauto" {
	if {[file exists "extra/broadcast/autobroadcast.txt"]} {
set file "extra/broadcast/autobroadcast.txt"
set rfile [open $file r+]
set data [read $rfile]
close $rfile
return "|cFFF0002FMESSAGE: |cFFFFA333$data"
} else { return "|cFFFFA333You havent set any Automessage" }
}
"auto" {
set file [open "extra/broadcast/autobroadcast.txt" w+]
set text "[ lrange $cargs 1 end ]"
puts $file $text
close $file
return "|cFFFFA333Auto Broadcast Created!"
}
}
set name [GetName $player]
return ".broadcast $cargs |cFFFFA333($name)"
}
}