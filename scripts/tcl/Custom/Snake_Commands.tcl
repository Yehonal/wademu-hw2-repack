#
# Snake Functions Script File
# Vercion: 0.5.1
# Author: Snake
# Contact: admin@uniwow.com
# ------------------------------------------------
#
# This script includes some functions for scripters to use.
#
# Has:
# - Jail
# - Jail Check
# - Free Jail
# - Increase Warns
# - Decrease Warns
# - Warns Check
#
# ------------------------------------------------
#
# Changelog:
# v0.5.1: Like i did with JailFree, now Increase/Decrease Warn proc it will only
#       do his function, all other checks must be done before using it. You can
#       see an example in Snake Commands Gm.tcl. Added SayGm proc.
#
# v0.5: Added RollItem proc.
#
# v0.4: JailFree proc has changed. Now it will ONLY free the player, you have
#       to add all other checks (if is in jail or not, etc).
#
# v0.3: First release. Jail and warn checks.
#

package require sqlite3
sqlite3 snk "saves/snk.db3"

namespace eval sc_func {
	
variable VERSION 0.5.1

proc Jail { player time } {
	set name [GetName $player]
	set date [clock seconds]
	set pos [GetPos $player]
	snk eval { INSERT INTO `jail` (`name`, `jaildate`, `jailtime`, `lastpos`) VALUES($name, $date, $time, $pos) }
	Teleport $player 13 0 0 0
	Say $player 0 "I have been jailed"
}

proc JailCheck { name } {
	if { [ string length [ snk eval { SELECT `name` FROM `jail` WHERE (`name` = $name) } ] ] } {
		return 1
	} else {
		return 0
	}
}

proc JailFree { player } {
	set name [GetName $player]
	snk eval { SELECT `lastpos` FROM `jail` WHERE (`name` = $name) } {
		set map [lindex $lastpos 0]
		set x [lindex $lastpos 1]
		set y [lindex $lastpos 2]
		set z [lindex $lastpos 3]
		Teleport $player $map $x $y $z
	}
	snk eval { DELETE FROM `jail` WHERE (`name` = $name) }
}

proc IncreaseWarn { player cargs } {
	set name [GetName $player]
	set space "- "
		snk eval { SELECT `warns`, `why` FROM `warns_board` WHERE (`name` = $name) } {
			set newwarn [expr ($warns + 1)]
			set newwhy "$why\n$space$cargs"
		}
		snk eval { DELETE FROM `warns_board` WHERE (`name` = $name) }
		snk eval { INSERT INTO `warns_board` (`name`, `warns`, `why`) VALUES($name, $newwarn, $newwhy) }
		Say $player 0 "I now have $newwarn warns for $cargs"
		return "$name now has $newwarn warns"
}

proc DecreaseWarn { player } {
	set name [GetName $player]
	snk eval { SELECT `warns` FROM `warns_board` WHERE (`name` = $name) } {
		set newwarn [expr ($warns - 1)]
	}
	snk eval { DELETE FROM `warns_board` WHERE (`name` = $name) }
	snk eval { INSERT INTO `warns_board` (`name`, `warns`) VALUES($name, $newwarn) }
	Say $player 0 "I now have $newwarn warns"
	return "$name now has $newwarn warns"
}

proc CheckWarns { player } {
	set name [GetName $player]
	if { ![ string length [ snk eval { SELECT `name` FROM `warns_board` WHERE (`name` = $name) } ] ] } { return 0 }
	snk eval { SELECT `warns`, `why` FROM `warns_board` WHERE (`name` = $name) } {
		return $warns
	}
}

proc HasWarns { player } {
	set name [GetName $player]
	if { [ string length [ snk eval { SELECT `name` FROM `warns_board` WHERE (`name` = $name) } ] ] } { return 1 }
}

proc SayGm { text } {
	snk eval { SELECT `number` FROM `gm_store` } {
		foreach gm $number {
			if { [GetPlevel $gm] > 1 } { Say $gm 0 "$text" }
		}
	}
}

proc RollItem { pnumber players } {
	switch $pnumber {
		2 {
			set player1 [lindex $players 0]
			set player2 [lindex $players 1]
			set p1 [expr int([expr rand() * 100])]
			set p2 [expr int([expr rand() * 100])]
			set p1 [expr {$p1-100} ]
			set p2 [expr {$p2-100} ]
			if { $p1 > $p2 } { return $player1 }
			if { $p2 > $p1 } { return $player2 }
		}
		3 {
			set player1 [lindex $players 0]
			set player2 [lindex $players 1]
			set player3 [lindex $players 2]
			set p1 [expr int([expr rand() * 100])]
			set p2 [expr int([expr rand() * 100])]
			set p3 [expr int([expr rand() * 100])]
			set p1 [expr {$p1-100} ]
			set p2 [expr {$p2-100} ]
			set p3 [expr {$p3-100} ]
			if { $p1 > $p2  &&  $p1 > $p3 } { return $player1 }
			if { $p2 > $p1 && $p2 > $p3 } { return $player2 }
			if { $p3 > $p1 && $p3 > $p2 } { return $player3 }
		}
		4 {
			set player1 [lindex $players 0]
			set player2 [lindex $players 1]
			set player3 [lindex $players 2]
			set player4 [lindex $players 3]
			set p1 [expr int([expr rand() * 100])]
			set p2 [expr int([expr rand() * 100])]
			set p3 [expr int([expr rand() * 100])]
			set p4 [expr int([expr rand() * 100])]
			set p1 [expr {$p1-100} ]
			set p2 [expr {$p2-100} ]
			set p3 [expr {$p3-100} ]
			set p4 [expr {$p4-100} ]
			if { $p1 > $p2 && $p1 > $p3 && $p1 > $p4 } { return $player1 }
			if { $p2 > $p1 && $p2 > $p3 && $p2 > $p4 } { return $player2 }
			if { $p3 > $p1 && $p3 > $p2 && $p3 > $p4 } { return $player3 }
			if { $p4 > $p1 && $p4 > $p2 && $p4 > $p3 } { return $player4 }
		}
		5 {
			set player1 [lindex $players 0]
			set player2 [lindex $players 1]
			set player3 [lindex $players 2]
			set player4 [lindex $players 3]
			set player5 [lindex $players 4]
			set p1 [expr int([expr rand() * 100])]
			set p2 [expr int([expr rand() * 100])]
			set p3 [expr int([expr rand() * 100])]
			set p4 [expr int([expr rand() * 100])]
			set p5 [expr int([expr rand() * 100])]
			set p1 [expr {$p1-100} ]
			set p2 [expr {$p2-100} ]
			set p3 [expr {$p3-100} ]
			set p4 [expr {$p4-100} ]
			set p5 [expr {$p5-100} ]
			if { $p1 > $p2 && $p1 > $p3 && $p1 > $p4 && $p1 > $p5 } { return $player1 }
			if { $p2 > $p1 && $p2 > $p3 && $p2 > $p4 && $p2 > $p5 } { return $player2 }
			if { $p3 > $p1 && $p3 > $p2 && $p3 > $p4 && $p3 > $p5 } { return $player3 }
			if { $p4 > $p1 && $p4 > $p2 && $p4 > $p3 && $p4 > $p5 } { return $player4 }
			if { $p5 > $p1 && $p5 > $p2 && $p5 > $p3 && $p5 > $p4 } { return $player5 }
		}
	}
}

set prefix [Custom::LogPrefix]
puts "$prefix Snake Functions v$VERSION Loaded"
}





#
# Snake Players Commands Script File
# Vercion: 0.5.1
# Author: Snake
# Contact: admin@uniwow.com
# ------------------------------------------------
#
# This script its to allow players see all what you created with Snake Gm Commands
#
# Be sure what you are editing before do it, you don't want to brake anything
# For info on how to use player commands read Snake Commands Player.txt
# If you think player should have more options or new commands please post it
# in the forum you found this script.
# 
# ------------------------------------------------
#
# Changelog:
# v0.5.1: Some minor fixes here, next vercion possible will have a big update here with addon.
#
# v0.5: First Vercion of Roll Command!
#
# v0.4: Added the ticket command and fixed some jail typos.
#
# v0.3: Added to mycp the jail  command. Finished the poll command for player.
#       I added some checks to pvp, i will change this system next vercion.
#
# v0.2: Added .mycp (my control panel) command to view warns and for future additions.
#       Now players can view with ".news list", last entry and then use ".news see <#>".
#       The same with events. Added pvp command adapted to sql to store coords.
#       I will add more functions to pvp.
#
# v0.1: First Release, players will be able to see news and events.
#

package require sqlite3
sqlite3 snk "saves/snk.db3"

namespace eval sc_pl {

variable VERSION 0.5.1


proc ticket { player cargs } {
	set name [GetName $player]
	set text $cargs
	set status "Not Resolved"
	set date [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
	snk eval { INSERT INTO `gm_ticket` (`text`, `madeby`, `date`, `status`) VALUES($text, $name, $date, $status) }
	snk eval { SELECT `entry` FROM `gm_ticket` ORDER BY `entry` DESC LIMIT 1 } {
		sc_func::SayGm "$name has opened a ticket. Ticket number is $entry"
		return "Ticket Number: $entry. It has been sended to all gms online, wait for an answer, DON'T re-send it."
	}
}

proc roll { player cargs } {
	variable blue
	variable end
	set name [GetName $player]
	set mode [lindex $cargs 0]
	switch $mode {
		"createparty" {
			set pname [lindex $cargs 1]
			if { [ string length [ snk eval { SELECT `name` FROM `party_store` WHERE (`name` = $pname) } ] ] } {	return "That party already exists"	}
			snk eval { INSERT INTO `party_store` (`name`, `leader`, `members`, `numbers`) VALUES($pname, $name, $name, $player) }
			return "Party created"
		}
		"deleteparty" {
			set pname [lindex $cargs 1]
			if { ![ string length [ snk eval { SELECT `name` FROM `party_store` WHERE (`name` = $pname) } ] ] } {	return "That party doesn't exist"	}
			if { ![ string length [ snk eval { SELECT `leader` FROM `party_store` WHERE (`name` = $pname AND `leader` = $name) } ] ] } {	return "You must be the party leader to delete one"	}
			snk eval { DELETE FROM `party_store` WHERE (`name` = $pname) }
			return "Party deleted"
		}
		"addmember" {
			set pname [lindex $cargs 1]
			set sele [GetSelection $player]
			set sname [GetName $sele]
			if { ![ string length [ snk eval { SELECT `name` FROM `party_store` WHERE (`name` = $pname) } ] ] } {	return "That party doesn't exist"	}
			if { ![ string length [ snk eval { SELECT `leader` FROM `party_store` WHERE (`name` = $pname AND `leader` = $name) } ] ] } {	return "You must be the party leader to add members to one"	}
			snk eval { SELECT `leader`, `members` FROM `party_store` } {
				if { [lsearch $leader $sname] >-1 } { return "$sname is leader from another party" }
				if { [lsearch $members $sname] >-1 } { return "$sname is already on another party" }
			}
			snk eval { SELECT `members`, `numbers` FROM `party_store` WHERE (`name` = $pname) } {
				set newnumber "$numbers $sele"
				set newmember "$members $sname"
				if { [llength $newmember] == 6 } { return "Party has reached limit of players (5)" }
			}
			snk eval { UPDATE `party_store` SET `members` = $newmember, `numbers` = $newnumber WHERE (`name` = $pname) }
			Say $sele 0 "I have been added to $pname party"
			return "$sname added to $pname"
		}
		"item" {
			set pname [lindex $cargs 1]
			if { ![ string length [ snk eval { SELECT `name` FROM `party_store` WHERE (`name` = $pname) } ] ] } {	return "That party doesn't exist"	}
			snk eval { SELECT `members`, `numbers` FROM `party_store` WHERE (`name` = $pname) } {
				if { [lsearch $members $name] <-1 } { return "You are not from $pname" }
				set itemname [lrange $cargs 2 end]
				set itemid [Custom::GetID $itemname]
				if { $itemid == 0 } { return "That item doesn't exist" }
				if { ![ConsumeItem $player $itemid 1] } { return "You don't have that item" }
				set winner [sc_func::RollItem [llength $members] $numbers]
				AddItem $winner $itemid
				Say $winner 0 "I have won $blue$itemname$end from roll"
			}
		}
	}
}

proc polls { player cargs } {
	variable black
	variable end
	set name [GetName $player]
	set mode [lindex $cargs 0]
	switch $mode {
		"list" {
			snk eval { SELECT `entry` FROM `polls_board` ORDER BY `entry` DESC LIMIT 1 } {
				return "Last Entry: $entry"
			}
		}
		"vote" {
			set entry [lindex $cargs 1]
			set vote [lindex $cargs 2]
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $entry) } ] ] } {	return "Poll doesn't exist"	}
			snk eval { SELECT `alreadyvote` FROM `polls_board` WHERE (`entry` = $entry) } {
				if { [lsearch $alreadyvote $name] >-1 } { return "You have already voted on this poll" }
			}
			snk eval { SELECT `closed` FROM `polls_board` WHERE (`entry` = $entry) } {
				if { $closed == "yes" } { return "That Poll is closed" }
			}
			if { $vote == "yes" || $vote == "Yes" } {
				snk eval { SELECT `yes`, `alreadyvote` FROM `polls_board` WHERE (`entry` = $entry) } {
					set newyes [expr $yes + 1]
					set newav "$alreadyvote $name"
				}
				snk eval { UPDATE `polls_board` SET `yes` = $newyes, `alreadyvote` = $newav WHERE (`entry` = $entry) }
				return "Thanks for voting"
			}
			if { $vote == "no" || $vote == "No" } {
				snk eval { SELECT `no`, `alreadyvote` FROM `polls_board` WHERE (`entry` = $entry) } {
					set newno [expr $no + 1]
					set newav "$alreadyvote $name"
				}
				snk eval { UPDATE `polls_board` SET `no` = $newno, `alreadyvote` = $newav WHERE (`entry` = $entry) }
				return "Thanks for voting"
			}
		}
		"see" {
			set entry [lindex $cargs 1]
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $entry) } ] ] } {	return "Poll doesn't exist"	}
			snk eval { SELECT * FROM `polls_board` WHERE (`entry` = $entry) } {
				return "$black$question$end\n-------------------\nYes: $yes\nNo: $no"
			}
		}
	}
}

proc pvp { player cargs } {
        variable Arena_stat
	set mode [lindex $cargs 0]
	set name [GetName $player]
	set pos [GetPos $player]
	set l [GetLevel $player]
	if { $l < 40 } { return "You must be level 40+ to enter arena" }
	if { [GetHealthPCT $player] < 100 } { return "You must be fully healed to enter arena" }
	switch $mode {
        

                 
  "open" {

                    if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use 
this command" }

if { $Arena_stat == 1 } {
           set msg "\nPVP Arena was already opened!"
           } else {
               set Arena_stat 1
               set msg "\nPVP arena is now Open!!!"
           }
       }


                "close" {
                    if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use 
this command" }
           set Arena_stat 0
           set msg "\nPVP arena is now Closed!!!"
                }


		"enter" {
                    if { $Arena_stat == 1 } {
			if { [ string length [ snk eval { SELECT `name` FROM `telpos_pvp` WHERE (`name` = $name) } ] ] } { return "You are already in arena or you didn't make a .pvp leave"	}
			if { [ string length [ snk eval { SELECT `name` FROM `banned_pvp` WHERE (`name` = $name) } ] ] } { return "You are banned from Arena" }
			snk eval { INSERT INTO `telpos_pvp` (`name`, `coords`) VALUES($name, $pos) }
      Teleport $player 0 -13152.900391 342.729004 52.132801
      return "Teleported to Arena"
    } else { set msg "\nPVP arena is Closed!!!" } } 
		"leave" {
             if { $Arena_stat == 1 } {
			if { ![ string length [ snk eval { SELECT `name` FROM `telpos_pvp` WHERE (`name` = $name) } ] ] } { return "Before using leave you must have used .pvp enter" }
			snk eval { SELECT `coords` FROM `telpos_pvp` WHERE (`name` = $name ) } {
				set map [lindex $coords 0]
				set x [lindex $coords 1]
				set y [lindex $coords 2]
				set z [lindex $coords 3]
				Teleport $player $map $x $y $z
			}
			snk eval { DELETE FROM `telpos_pvp` WHERE (`name` = $name) }
			return "Returned to last location"
		} else { set msg "\nPVP arena is Closed!!!" }  }  
	} 
}

proc mycp { player cargs } {
	variable red
	variable end
	set name [GetName $player]
	set mode [lindex $cargs 0]
	switch $mode {
		"warns" {
			if { [ string length [ snk eval { SELECT `name` FROM `warns_board` WHERE (`name` = $name) } ] ] } {
				snk eval { SELECT `warns`, `why` FROM `warns_board` WHERE (`name` = $name) } {
					if { $warns == 0 } {
						return "You don't have any warn"
					}
					return "You have $red$warns$end warns for:\n$why"
				}
			}
			return "You don't have any warn"
		}
		"free" {
			set date [clock seconds]
			snk eval { SELECT `jaildate`, `jailtime` FROM `jail` WHERE (`name` = $name) } {
				set timeleft [expr $date - $jaildate ]
				if { $timeleft < $jailtime } { return "You can't be freed yet" }
			}
			if { [sc_func::JailCheck $player] != 1 } { return "You are not jailed" }
			sc_func::JailFree $player
			return "You are now free"
		}
	}
}

proc news { player cargs } { 
	variable black
	variable end
	set mode [lindex $cargs 0]
	switch $mode {
		"list" {	
			snk eval { SELECT `entry` FROM `news` ORDER BY `entry` DESC LIMIT 1 } {
				return "Last Entry: $entry"
			}
		}
		"see" {
			set entry [lindex $cargs 1]
			snk eval { SELECT `text`, `date`, `madeby` FROM `news` WHERE (`entry` = $entry) } {
				return "$black$date by $madeby$end \n--------------------------------------\n$text\n--------------------------------------"
			}
		}
		default {	
			snk eval { SELECT `text`, `date`, `madeby` FROM `news` ORDER BY `entry` DESC LIMIT 1 } {
				return "$black$date by $madeby$end \n--------------------------------------\n$text\n--------------------------------------"
			}
		}
	}
}

proc events { player cargs } {
	variable black
	variable end
	set mode [lindex $cargs 0]
	switch $mode {
		"list" {
			snk eval { SELECT `entry` FROM `events` ORDER BY `entry` DESC LIMIT 1 } {
				return "Last Entry: $entry"
			}
		}
		"see" {
			set entry [lindex $cargs 1]
			snk eval { SELECT * FROM `events` WHERE (`entry` = $entry) } {
				return "$black$eventday at $eventtime:$end $text\n"
			}
		}
		default {
			snk eval { SELECT * FROM `events` ORDER BY `entry` DESC LIMIT 1 } {
				return "$black$eventday at $eventtime: $end $text\n"
			}
		}
	}
}

Custom::AddCommand "news" "sc_pl::news"
Custom::AddCommand "events" "sc_pl::events"
Custom::AddCommand "mycp" "sc_pl::mycp"
Custom::AddCommand "pvp" "sc_pl::pvp"
Custom::AddCommand "polls" "sc_pl::polls"
Custom::AddCommand "ticket" "sc_pl::ticket"
#Custom::AddCommand "roll" "sc_pl::roll"

variable red |cffFF0000
variable black |cff000000
variable yellow |cffFFFF00
variable blue |cff0000FF
variable grey |cffC0C0C0
variable orange |cffFF8000
variable green  |cff00FF40
variable brown |cff800000
variable violette |cffC400C4
variable end |r
variable Arena_stat 0

set prefix [Custom::LogPrefix]
puts "$prefix Snake Player Commands v$VERSION Loaded"
}





#
# Snake Gm Commands Script File
# Vercion: 0.5.1
# Author: Snake
# Contact: admin@uniwow.com
# ------------------------------------------------
#
# This script its to make gm life easier and to try to expand this command thing
# with administration of news, events, etc.
#
# For info on how to use gm or player command read Snake Commands Gm.txt
# If you have an idea for new command or want new things in the already made 
# please post it in the forum you found this script.
#
# ------------------------------------------------
#
# Changelog:
# v0.5.1: Now when the warn limit is reached, account will be banned and kicked.
#         I changed in SC Func some warns procs so i change here the warns too.
#         Gms don't need anymore to add themselves to gm db if they use Gm Addon.
#
# v0.5: No updates here.
#
# v0.4: First vercion of Gm Ticket System. It can bring problems if
#       gms don't remember to remove them from gm db. Added edit mode
#       for all commands possible.
#
# v0.3: New Command: Jail, is similar the one that gotisch made
#       adapted to sql.
#
# v0.2: New Commands: Broadcasts, Warns, PvP and Polls.
#       Removed Bets.
#       Changed "go" from teleports to "use". Added ".<cmd> list"
#       to all commands to give the last entry and use ".<cmd> see <#>".
#
# v0.1: First Release, including news, events, bets, broadcast
#       players and teleportation. Most of commands only are
#       only create and delete.
#

package require sqlite3
sqlite3 snk "saves/snk.db3"

namespace eval sc_gm {
	
####----Settings----####

# General Settins
variable Min_Gm_Level 4
variable Max_Warns 5

# 0 = Disabled, 1 = Enabled.
variable SnakeCommands 1

variable News 1
variable Events 1
variable Polls 1
variable Players 1
variable Teleports 1
variable Warns 1
variable Broadcasts 1
variable PvP 1
variable Jail 1
variable Ticket 1

####----End Settings----#####

variable VERSION 0.5.1

proc sc { player cargs } {
	variable el
	if { $sc_gm::SnakeCommands != 1 } { return "$el Snake Commands are disabled" }
	if { [GetPlevel $player] < $sc_gm::Min_Gm_Level } { return "You are not allowed to use this command" }
	set event [lindex $cargs 0]
	set mode [lindex $cargs 1]
	set cargs [lrange $cargs 2 end]
	switch $event {
		"news" { if { $sc_gm::News != 1 } { return "$el News are disabled" }; return [News $player $cargs $mode] }
		"events" { if { $sc_gm::Events != 1 } { return "$el Events are disabled" }; return [Events $player $cargs $mode] }
		"polls" { if { $sc_gm::Polls != 1 } { return "$el Polls are disabled" }; return [Polls $player $cargs $mode] }
		"players" { if { $sc_gm::Players != 1 } { return "$el Players are disabled" }; return [Players $player $cargs $mode] }
		"tels" { if { $sc_gm::Teleports != 1 } { return "$el Teleports are disabled" }; return [Tels $player $cargs $mode] }
		"warns" { if { $sc_gm::Warns != 1 } { return "$el Warns are disabled" }; return [Warns $player $cargs $mode] }
		"broads" { if { $sc_gm::Broadcasts != 1 } { return "$el Broadcasts are disabled" }; return [Broadcasts $player $cargs $mode] }
		"pvp" { if { $sc_gm::PvP != 1 } { return "$el PvP is disabled" }; return [PvP $player $cargs $mode] }
		"jail" { if { $sc_gm::Jail != 1 } { return "$el Jail is disabled" }; return [Jail $player $cargs $mode] }
		"ticket" { if { $sc_gm::Ticket != 1 } { return "$el Ticket are disabled" }; return [Ticket $player $cargs $mode] }
		"help" { return "$el Gm events are news/events/bets/broadcasts/players/tels/warns/broads/pvp/jail \nTo see how to use them please read Snake Commands Gm.txt" }
		default { return "$el Gm events are news/events/bets/broadcasts/players/tels/warns/broads/pvp/jail \nTo see how to use them please read Snake Commands Gm.txt.txt" }
	}
}

proc Ticket { player cargs mode } {
	variable black
	variable end
	variable el
	set name [GetName $player]
	switch $mode {
		"addgm" {
			if { [ string length [ snk eval { SELECT `name` FROM `gm_store` WHERE (`name` = $name) } ] ] } { return "$el You are already added in gm ticket db, if you want to refresh it please use remove mode"	}
			snk eval { INSERT INTO `gm_store` (`number`, `name`) VALUES($player, $name) }
		}
		"removegm" {
			if { ![ string length [ snk eval { SELECT `name` FROM `gm_store` WHERE (`name` = $name) } ] ] } { return "$el You aren't in gm ticket db, use add mode to add it"	}
			snk eval { DELETE FROM `gm_store` WHERE (`name` = $name) }
		}
		"changestatus" {
			set entry [lindex $cargs 0]
			set newstatus [lrange $cargs 1 end]
			if { ![ string length [ snk eval { SELECT `entry` FROM `gm_ticket` WHERE (`entry` = $entry) } ] ] } { return "$el Ticket $entry doesn't exist"	}
			snk eval { UPDATE `gm_ticket` SET `status` = $newstatus WHERE (`entry` = $entry) }
			return "$el Ticket Status changed to $newstatus"
		}
		"see" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `gm_ticket` WHERE (`entry` = $entry) } ] ] } { return "$el Ticket $entry doesn't exist"	}
			snk eval { SELECT * FROM `gm_ticket` WHERE (`entry` = $entry) } {
				return "$el\n$black Ticket number$end $entry:\n$black Problem:$end $text\n$black Status:$end $status\n$black By$end $madeby $black at$end $date"
			}
		}
		"list" {
			snk eval { SELECT `entry` FROM `gm_ticket` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Last Entry: $entry"
			}
		}
		"delete" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `gm_ticket` WHERE (`entry` = $entry) } ] ] } { return "$el Ticket $entry doesn't exist"	}
			snk eval { DELETE FROM `gm_ticket` WHERE (`entry` = $entry) }
			return "$el Ticket deleted"
		}
	}
}

proc Jail { player cargs mode } {
	variable el
	variable red
	variable end
	set sele [GetSelection $player]
	set sname [GetName $sele]
	if { $sele == $player } { return "$el You can't jail yourself" }
	if { $sele == 0 || [GetObjectType $sele] != 4 } { return "$el Please Select a player" }
	switch $mode {
		"for" {
			if { [JailCheck $sname] != 0 } { return "$sname is already jailed" }
			switch [llength $cargs] {
				1 {
					set jsec [expr [lindex $cargs 0] * 60 ]
					sc_func::Jail $sele $jsec
					return "$el $sname is now jailed"
				}
				2 {
					set jsec [expr [lindex $cargs 0] * 60 + [lindex $cargs 1] * 3600 ]
					sc_func::Jail $sele $jsec
					return "$el $sname is now jailed"
				}
				3 {
					set jsec [expr [lindex $cargs 0] * 60 + [lindex $cargs 1] * 3600 + [lindex $cargs 2] * 86400 ]
					sc_func::Jail $sele $jsec
					return "$el $sname is now jailed"
				}
			}
		}
		"free" {
			if { [sc_func::JailCheck $sele] != 1 } { return "$sname is not jailed" }
			sc_func::JailFree $sele
			return "$el $sname is now free"
		}
	}
}

proc PvP { player cargs mode } {
	variable el
	set name [GetName $player]
	set sele [GetSelection $player]
	set sname [GetName $sele]
	if { $sele == $player } { return "$el You can't use this command on yourself" }
	if { $sele == 0 || [GetObjectType $sele] != 4 } { return "$el Please select a player" }
	switch $mode {
		"unban" {
			if { ![ string length [ snk eval { SELECT `name` FROM `banned_pvp` WHERE (`name` = $sname) } ] ] } { return "$el $sname is not banned" }
			snk eval { DELETE FROM `banned_pvp` WHERE (`name` = $sname) }
			Say $sele 0 "I have been unbanned from Arena Events"
			return "$el $sname is now unbanned from Arena Events"			
		}
		"ban" {
			if { [ string length [ snk eval { SELECT `name` FROM `banned_pvp` WHERE (`name` = $sname) } ] ] } { return "$el $sname is already banned"	}
			snk eval { INSERT INTO `banned_pvp` (`name`) VALUES($sname) }
			Say $sele 0 "I have been banned from Arena Events"
			return "$el $sname is now banned from Arena Events"			
		}
		help { return "$el Modes are ban/unban" }
		default { return "$el Modes are ban/unban" }
	}
}

proc Warns { player cargs mode } {
	variable el
	set pname [GetName $player]
	set sele [GetSelection $player]
	set sname [GetName $sele]
	if { $player == $sele } { return "$el You can't warn yourself!" }
	if { $sele == 0 || [GetObjectType $sele] != 4 } { return "$el Please select a player" }
	switch $mode {
		"inc" {
			if { [sc_func::HasWarns $sele] == 1 } {
				if { ([expr [sc_func::CheckWarns $sele]] + 1) == $sc_gm::Max_Warns } {
					set account [GmTools::gtGetAccount [GetGuid $sele]]
					GmTools::gtUnBan $account
					KickPlayer $sele
					return "$el $sname reached 5 warns, his account ($account) has been banned"
				}
				set fin [sc_func::IncreaseWarn $sele $cargs]
				return "$el $fin"
			}
			set why $cargs
			snk eval { INSERT INTO `warns_board` (`name`, `warns`, `why`) VALUES($sname, 1, $why) }
			Say $player 0 "I now have 1 warn for $cargs"
			return "$el $sname now has 1 warn"
		}
		"dec" {
			if { [sc_func::HasWarns $sele] == 1 } {
				if { [sc_func::CheckWarns $sele] == 0 } {
					return "$el $sname has 0 warns, can't decrease them"
				}
				set fin [sc_func::DecreaseWarn $sele]
				return "$el $fin"
			}
			return "$el $sname has 0 warns, can't decrease them"
		}
		"see" {
			if { ![ string length [ snk eval { SELECT `name` FROM `warns_board` WHERE (`name` = $sname) } ] ] } { return "$el $sname doesn't has any warn" }
			snk eval { SELECT `warns`, `why` FROM `warns_board` WHERE (`name` = $sname) } {
				return "$el $sname has $warns warns for:\n$why"
			}
		}
		"help" { return "$el Modes are: dec/inc/see" }
		default { return "$el Modes are: dec/inc/see" }
	}
}

proc Polls { player cargs mode } {
	variable el
	variable black
	variable end
	set name [GetName $player]
	switch $mode {
		"create" {
			set question $cargs
			snk eval { INSERT INTO `polls_board` (`question`, `madeby`) VALUES($question, $name) }
			snk eval { SELECT `entry` FROM `polls_board` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Poll Entry: $entry"
			}
		}
		"delete" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $entry) } ] ] } {	return "$el Poll doesn't exist"	}
			snk eval { DELETE FROM `polls_board` WHERE (`entry` = $entry) }
			return "$el Poll deleted"
		}
		"see" {
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $cargs) } ] ] } {	return "$el Poll doesn't exist"	}
			snk eval { SELECT * FROM `polls_board` WHERE (`entry` = $cargs) } {
				return "$el Entry $cargs: $question\nYes: $yes\nNo: $no"
			}
		}
		"close" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $entry) } ] ] } {	return "$el Poll doesn't exist"	}
			snk eval { SELECT `closed` FROM `polls_board` WHERE ( `entry` = $entry ) } {
				if { $closed == "yes" } { return "$el Poll is already closed" }
			}
			snk eval { UPDATE `polls_board` SET `closed` = "yes" WHERE (`entry` = $entry) }
			return "$el Poll Closed"
		}
			
		"list" {
			snk eval { SELECT `entry` FROM `polls_board` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Last Entry: $entry"
			}
		}
		"edit" {
			set entry [lindex $cargs 0]
			set newtext [lrange $cargs 1 end]
			if { ![ string length [ snk eval { SELECT `entry` FROM `polls_board` WHERE (`entry` = $entry) } ] ] } {	return "$el Poll doesn't exist"	}
			snk eval { UPDATE `polls_board` SET `question` = $newtext WHERE (`entry` = $entry) }
			return "$el Poll entry $entry edited"
		}
		"help" { return "$el Modes are: create/delete/see/close/list" }
		default { return "$el Modes are: create/delete/see/close/list" }
	}
}

proc Players { player cargs mode } {
	variable el
	set sele [GetSelection $player]
	set sele_name [GetName $sele]
	if { [GetObjectType $player] != 4 } { return "Selection must be a player" }
	switch $mode {
		"setqflag" { 
			SetQFlag $sele $cargs
			return "$el Flag set to $sele_name"
		}
		"getqflags" {
			set f [GetQFlags $sele]
			return "$el $f"
		}
		"getqflag" {
			set f [GetQFlag $sele "$cargs"]
			if { $f == 1 } { return "$el True" }
			if { $f == 0 } { return "$el False" }
				}
		"clearqflag" {
			ClearQFlag $player "$cargs"
			return "$el Flag cleared from $sele_name"
				}
		"additem" { 
			AddItem $sele $cargs
			return "$el Item added to $sele_name" }
		"delitem" {
			if { ![ConsumeItem $sele $cargs 1] } { return "$el $sele_name doesn't has that item" }
			ConsumeItem $sele $cargs 1
			return "$el Item deleted from $sele_name"
		}
		"addmoney" {
			ChangeMoney $sele +$cargs
			return "$el $cargs cooper added to $sele_name"
		}
		"delmoney" {
			if { ![ChangeMoney $sele -$cargs] } { return "$el $sele_name doesn't has that money" }
			ChangeMoney $sele -$cargs
			return "$el $cargs cooper removed from $sele_name"
		}
		"emote" { Emote $sele $cargs }
		"cast" { CastSpell $player $sele $cargs }
		"say" {
			set lang [lindex $cargs 0]
			set text [lrange $cargs 1 end]
			Say $sele $lang ":$text"
		}
	}
}

proc Tels { player cargs mode } {
	variable el
	set name [GetName $player]
	switch $mode {
		"create" {
			set telname $cargs
			set coords [GetPos $player]
			if { [ string length [ snk eval { SELECT `name` FROM `teleports` WHERE (`name` = $telname) } ] ] } {
				return "$el Teleport Location $telname already exists"
			}
			snk eval { INSERT INTO `teleports` (`madeby`, `name`, `coords`) VALUES($name, $telname, $coords) }
			return "$el Teleport Location $telname added"
		}
		"delete" {
			set telname $cargs
			if { ![ string length [ snk eval { SELECT `name` FROM `teleports` WHERE (`name` = $telname) } ] ] } {
				return "$el Teleport Location $telname doesn't exist"
			}
				snk eval { DELETE FROM `teleports` WHERE (`name` = $telname) }
				return "$el Teleport Location $telname deleted"
			}
		"use" {
			set telname $cargs
			if { ![ string length [ snk eval { SELECT `name` FROM `teleports` WHERE (`name` = $telname) } ] ] } {
				return "$el Teleport Location $telname doesn't exist"
			}
			snk eval { SELECT `coords` FROM `teleports` WHERE (`name` = $telname) } {
				set map [lindex $coords 0]
				set x [lindex $coords 1]
				set y [lindex $coords 2]
				set z [lindex $coords 3]
				Teleport $player $map $x $y $z
				return "$el Teleported to $telname"
			}
		}
		"edit" {
			set telname $cargs
			set pos [GetPos $player]
			if { ![ string length [ snk eval { SELECT `name` FROM `teleports` WHERE (`name` = $telname) } ] ] } {	return "$el Teleport Location $telname doesn't exist"	}
			snk eval { UPDATE `teleports` SET `coords` = $pos WHERE (`entry` = $entry) }
			return "$el Teleport $telname updated to your position"
		}
		"help" { return "$el Modes are: create/delete/use" }
		default { return "$el Modes are: create/delete/use" }
		}
	}

proc Broadcasts { player cargs mode } {
	variable green
	variable end
	variable el
	set name [GetName $player]
	switch $mode {
		"create" {
			set text $cargs
			snk eval { INSERT INTO `broadcasts` (`madeby`, `text`) VALUES($name, $text) }
			snk eval { SELECT `entry` FROM `broadcasts` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Broadcast Entry: $entry" }
			}
		"delete" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `broadcasts` WHERE (`entry` = $entry) } ] ] } { return "$el Broadcast entry $entry doesn't exist" }
			if { [ string length [ snk eval { SELECT `madeby` FROM `broadcasts` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } {
				snk eval { DELETE FROM `broadcasts` WHERE (`entry` = $entry) }
				return "$el $entry deleted"
					} else { return "$el You can't delete other gm broadcasts" }
				}
		"use" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `text` FROM `broadcasts` WHERE (`entry` = $entry ) } ] ] } {
				return "$el Broadcast number $entry doesn't exist" 
			}
			snk eval { SELECT `text` FROM `broadcasts` WHERE (`entry` = $entry) } {
				return ".broadcast $text $green ($name) $end"
			}
		}
		"see" {
			if { ![ string length [ snk eval { SELECT `entry` FROM `broadcasts` WHERE (`entry` = $cargs) } ] ] } { return "$el Broadcast entry $entry doesn't exist" }
			snk eval { SELECT * FROM `broadcasts` WHERE (`entry` = $cargs) } {
				return "$el Entry $cargs: $text by $madeby"
			}
		}
		"list" {
			snk eval { SELECT `entry` FROM `broadcasts` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Last Entry: $entry"
			}
		}
		"edit" {
			set entry [lindex $cargs 0]
			set newtext [lrange $cargs 1 end]
			if { ![ string length [ snk eval { SELECT `entry` FROM `broadcasts` WHERE (`entry` = $entry) } ] ] } { return "$el Broadcast entry $entry doesn't exist" }
			if { ![ string length [ snk eval { SELECT `madeby` FROM `broadcasts` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } { return "You can't edit other gms broadcasts" }
			snk eval { UPDATE `broadcasts` SET `text` = $newtext WHERE (`entry` = $entry) }
			return "$el Broadcast entry $entry edited"
		}
		"help" { return "$el Modes are: create/delete/use/list/use/see" }
		default { return "$el Modes are: create/delete/use/list/use/see" }
	}
}

proc News { player cargs mode } {
	variable black
	variable end
	variable el
	set name [GetName $player]
	switch $mode {
		"create" {
			set text $cargs
			set time [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
			snk eval { INSERT INTO `news` (`madeby`, `text`, `date`) VALUES($name, $text, $time) }
			snk eval { SELECT `entry` FROM `news` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el News Entry: $entry" }
			}
		"delete" {
			set entry $cargs
			if { ![ string length [ snk eval { SELECT `entry` FROM `news` WHERE (`entry` = $entry) } ] ] } { return "$el News entry $entry doesn't exist" }
			if { [ string length [ snk eval { SELECT `madeby` FROM `news` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } {
				snk eval { DELETE FROM `news` WHERE (`entry` = $entry) }
				return "$el Entry: $entry deleted"
			} else { return "$el You can't delete other gms news" }				
		}
		"see" {
			if { ![ string length [ snk eval { SELECT `entry` FROM `news` WHERE (`entry` = $cargs) } ] ] } { return "$el News entry $entry doesn't exist" }
			snk eval { SELECT * FROM `news` WHERE (`entry` = $cargs) } {
				return "$el: $date by $madeby\n$text"
			}
		}
		"list" {
			snk eval { SELECT `entry` FROM `news` ORDER BY `entry` DESC LIMIT 1 } {
			return "$el Last Entry: $entry"
		}
	}
	"list10" {
		set bla [snk eval { SELECT * FROM `news` ORDER BY `entry` DESC LIMIT 10 }]
		set bla 
		return $bla
	}
	"edit" {
		set entry [lindex $cargs 0]
		set newtext [lrange $cargs 1 end]
		if { ![ string length [ snk eval { SELECT `entry` FROM `news` WHERE (`entry` = $entry) } ] ] } { return "$el News entry $entry doesn't exist" }
		if { ![ string length [ snk eval { SELECT `madeby` FROM `news` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } { return "You can't edit other gms news" }
		snk eval { UPDATE `news` SET `text` = $newtext WHERE (`entry` = $entry) }
		return "$el News entry $entry edited"
	}
		"help" { return "$el Modes are: create/delete/see/list" }
		default { return "$el Modes are: create/delete/see/list" }
	}
}

proc Events { player cargs mode } {
	variable el
	set name [GetName $player]
	switch $mode {
		"create" {
			set date [lindex $cargs 0]
			set time [lindex $cargs 1]
			set text [lrange $cargs 2 end]
			snk eval { INSERT INTO `events` (`text`, `eventday`, `eventtime`, `madeby`) VALUES($text, $date, $time, $name) }
			snk eval { SELECT `entry` FROM `events` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Event Entry: $entry" }
			}
		"delete" {
			set entry $cargs
			if { [ string length [ snk eval { SELECT `madeby` FROM `events` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } {
				snk eval { DELETE FROM `events` WHERE (`entry` = $entry) }
				return "$el $entry deleted"
			} else { return "$el You can't delete other gms events" }				
		}
		"see" {
			snk eval { SELECT * FROM `events` WHERE (`entry` = $cargs) } {
				return "$el $eventday at $eventtime:\n$text"
			}
		}
		"list" {
			snk eval { SELECT `entry` FROM `events` ORDER BY `entry` DESC LIMIT 1 } {
				return "$el Last Entry: $entry"
			}
		}
		"edit" {
			set entry [lindex $cargs 0]
			set newtext [lrange $cargs 1 end]
			if { ![ string length [ snk eval { SELECT `entry` FROM `events` WHERE (`entry` = $entry) } ] ] } { return "$el Event entry $entry doesn't exist" }
			if { ![ string length [ snk eval { SELECT `madeby` FROM `events` WHERE (`entry` = $entry AND `madeby` = $name) } ] ] } { return "You can't edit other gms events" }
			snk eval { UPDATE `events` SET `text` = $newtext WHERE (`entry` = $entry) }
			return "$el Event entry $entry edited"
		}
		"help" { return "$el Modes are: create/delete/see/list" }
		default { return "$el Modes are: create/delete/see/list" }
	}
}
		
proc snk_db { player cargs } {
	if { [GetPlevel $player] < $sc_gm::Min_Gm_Level } { return "You are not allowed to use this command" }
	variable vercion
	variable el
	variable upgrade
	switch $cargs {
		"help" { return "$el .scdb cleanup/delete/help/create \n cleanup: Removes wasted space from the database file \n delete: Delets all sc tables \n help: em... \n create: Creates all sc tables if they don't already exist" }
		"cleanup" {
			 snk eval { VACUUM }
			 return "$el DB cleaned"	
			 }
		"delete" {
			if { [ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'news') } ] ] } {
			snk eval { DROP TABLE `news` }
			snk eval { DROP TABLE `events` }
			snk eval { DROP TABLE `teleports` }
			snk eval { DROP TABLE `warns_board` }
			snk eval { DROP TABLE `broadcasts` }
			snk eval { DROP TABLE `polls_board` }
			snk eval { DROP TABLE `telpos_pvp` }
			snk eval { DROP TABLE `banned_pvp` }
			snk eval { DROP TABLE `jail` }
			snk eval { DROP TABLE `gm_store` }
			snk eval { DROP TABLE `gm_ticket` }
			snk eval { DROP TABLE `party_store` }
			snk eval { VACUUM }
			return "$el Tables deleted"
		}
		return "$el Tables don't exist"
	}
		"create" {
			if { [ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'news') } ] ] } {	return "$el Tables already exist, if you want to recreate them use .scdb delete and then .scdb create"	}
			snk eval { CREATE TABLE `news` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `madeby` TEXT NOT NULL DEFAULT '', `text` TEXT NOT NULL DEFAULT '', `date` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `events` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL DEFAULT '', `eventday` TEXT NOT NULL DEFAULT '', `eventtime` TEXT NOT NULL DEFAULT '', `madeby` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `teleports` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `madeby` TEXT NOT NULL DEFAULT '', `name` TEXT NOT NULL DEFAULT '', `coords` TEXT NULL DEFAULT '') }
			snk eval { CREATE TABLE `warns_board` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '', `warns` TEXT NOT NULL DEFAULT '', `why` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `broadcasts` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `madeby` TEXT NOT NULL DEFAULT '', `text` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `polls_board` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `question` TEXT NOT NULL DEFAULT '', `madeby` TEXT NOT NULL DEFAULT '', `yes` TEXT NOT NULL DEFAULT '', `no` TEXT NOT NULL DEFAULT '', `alreadyvote` TEXT NOT NULL DEFAULT '', `closed` TEXT NOT NULL DEFAULT 'no') }
			snk eval { CREATE TABLE `telpos_pvp` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '', `coords` TEXT NULL DEFAULT '') }
			snk eval { CREATE TABLE `banned_pvp` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `jail` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '', `jaildate` TEXT NOT NULL DEFAULT '', `jailtime` TEXT NOT NULL DEFAULT 0, `lastpos` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `gm_store` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `number` TEXT NOT NULL DEFAULT '', `name` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `gm_ticket` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `text` TEXT NOT NULL DEFAULT '', `madeby` TEXT NOT NULL DEFAULT '', `date` TEXT NOT NULL DEFAULT '', `status` TEXT NOT NULL DEFAULT '') }
			snk eval { CREATE TABLE `party_store` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '', `leader` TEXT NOT NULL DEFAULT '', `members` TEXT NOT NULL DEFAULT '', `numbers` TEXT NOT NULL DEFAULT '') }
			return "$el Tables created"
		}
		default { return "$el .scdb cleanup/delete/help/create \n cleanup: Removes wasted space from the database file \n delete: Delets all sc tables \n help: em... \n create: Creates all sc tables if they don't already exist"	}
	}
}

variable red |cffFF0000
variable black |cff000000
variable yellow |cffFFFF00
variable blue |cff0000FF
variable grey |cffC0C0C0
variable orange |cffFF8000
variable green  |cff00FF40
variable brown |cff800000
variable violette |cffC400C4
variable end |r

variable el |cff00FF40Snake.Commands:|r

Custom::AddCommand "sc" "sc_gm::sc"
Custom::AddCommand "scdb" "sc_gm::snk_db"

set prefix [Custom::LogPrefix]
puts "$prefix Snake Gm Commands v$VERSION Loaded"
}