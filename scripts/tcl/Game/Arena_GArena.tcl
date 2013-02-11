#
# StartTCL: n
#
# ====================================
#
# Gurubashi Booty Run Event script by jrtashjan
#
# ====================================
#
# Modified by Delfin
# 10.05.06
#
# Start-TCL 0.9.4 compatible
#

package require sqlite3
sqlite3 pvparena "saves/pvparena.db"
namespace eval ::GArena {
	variable game_started 0
	variable guards_killed 0
	variable pvpon 1
	variable remain
	variable last_event [ clock seconds ]
	variable timediff 80500
}
 proc ::GArena::create_arenadb { player cargs } {
	if { [ ::GetPlevel $player ] < 6 } { return "You are not allowed to use this command!" }
	if { $cargs == "redo" } {
		pvparena eval {DROP TABLE `pvparena`}
		pvparena eval {DROP TABLE 'ban_pvp'}
		return "PVP Arena database deleted."
	}
	pvparena eval {CREATE TABLE IF NOT EXISTS `pvparena` (`name` TEXT, 'coords' TEXT)}
	pvparena eval {CREATE TABLE IF NOT EXISTS 'ban_pvp' ('name' TEXT, 'banned')}
	return "PVP Arena database created."
 }
 proc ::GArena::GuardKilled {} {
	variable game_started
	variable guards_killed
	variable remain
	if { $game_started == 0 } { return 0 
	} else {
		incr guards_killed
		set remain [expr {4-$guards_killed}]
		Say $player 0 "Killed $guards_killed guards. Remain $remain"
	}
 } 

 proc ::GArena::OnOpen { obj player lootid } {
	variable game_started
	variable guards_killed
	variable remain
	variable last_event
	set remain [expr {4-$guards_killed}]
	if { ($game_started == 0) } { 
		Say $player 0 "It's locked, The game has not started yet!" 
		return 0 
	} 
	if { ($guards_killed < 4 ) } { 
		Say $player 0 "You must kill all 4 guards before you can claim your prize. $remain Guards remain" 
		return 0 
	}
	if { $guards_killed >= 4 } { 
		set guards_killed 0
		set game_started 0
		set last_event [ clock seconds ] 
		return 1 
	}
 }

 proc ::GArena::arena { player cargs } {
	variable game_started
	variable guards_killed
	variable pvpon
	variable timediff
	variable last_event
	set now [ clock seconds ]
	set timetogo [expr {($last_event + $timediff)- $now}]
	set name [ ::GetName $player ]
	set pos [ ::GetPos $player ]
	set sele [ ::GetSelection $player ]
	set sname [ ::GetName $sele ]
	set option [ lindex $cargs 0 ]
	if { $option == "" } {
		if { [ ::GetPlevel $player ] < 4 } { set msg ".guru enter --> Enter PVP Arena \n.guru leave --> Leave PVP Arena" }
		set msg "How to use: \n.guru enable --> Enable ARENA Command \n.guru disable --> Disable ARENA Command \n.guru enter --> Enter Arena \n.guru leave --> Leave Arena \n.guru ban --> Ban Selected Player from using ARENA Command \n.guru unban --> UnBan Selected Player from using ARENA Command"
	} else {
		switch $option {
			"info" { return "Next Game in: $timetogo\nNew GAME every: $timediff sec\nCOMMAND ENABLED $pvpon \nGAME STARTED $game_started\nGUARDS KILLED $guards_killed" }
			"enable" { set pvpon 1; return "ARENA COMMAND ENABLED" }
			"disable" { set pvpon 0; return "ARENA COMMAND DISABLED" }
			"enable_game" { set game_started 1; return "GAME IS NOW ENABLED" }
			"disable_game" { set game_started 0; return "GAME HAS NOW BEEN DISABLED" }
			"enter" {
			
				if { $last_event + $timediff <= $now} {
					set game_started 1
					if { $pvpon == 0 } { return "Command Disabled." }
					if { $game_started == 1 } { return "Booty Run event has started!" }
					if { [ string length [ pvparena eval { SELECT `name` FROM `pvparena` WHERE (`name` = $name) } ] ] } { return "You are already in Arena" }
					if { [ string length [ pvparena eval { SELECT `name` FROM `ban_pvp` WHERE (`name` = $name) } ] ] } { return "You are banned from Arena" }
					if { ! [ ::GetQFlag $player "jailed" ] } {
						pvparena eval { INSERT INTO `pvparena` (`name`, `coords`) VALUES($name, $pos) }
						::SetQFlag $player "garena"
						::Teleport $player 0 -13152.900391 342.729004 52.132801
						set msg "$name, Booty Run event has started! .arena leave --> exit arena" 
					} else {
						return [ ::Texts::Get "You cannot enter PVP arena while being jailed!" ]
					}
				} else { return "Next BOOTY RUN in $timetogo sec., sorry $name" }
			}
			"leave" {
				if { ! [ string length [ pvparena eval { SELECT `name` FROM `pvparena` WHERE (`name` = $name) } ] ] } { return "Before using leave you must have used .pvp enter first" }
				if { ! [ ::GetQFlag $player "jailed" ] } {		
					if { ! [ $game_started ] } {
						pvparena eval { SELECT `coords` FROM `pvparena` WHERE (`name` = $name ) } {
							set map [lindex $coords 0]
							set x [lindex $coords 1]
							set y [lindex $coords 2]
							set z [lindex $coords 3]
							::Teleport $player $map $x $y $z
							::ClearQFlag $player "garena"
							pvparena eval { DELETE FROM `pvparena` WHERE (`name` = $name) }
							return "Returned to last location"
						}
					} else { 
						return "Game has not started yet. You can not leave the area without entering it first" }
				} else {
					return [ ::Texts::Get "You are jailed!" ] }
			}
			"ban" {
				if { [ ::GetPlevel $player ] < 4 } { return "You are not allowed to use this command!" }
				if { $sele == $player } { return "You can't use this command on yourself" }
				if { $sele == 0 || [ ::GetObjectType $sele ] != 4 } { return "Please select a player" }
				if { [ string length [ pvparena eval { SELECT `name` FROM `ban_pvp` WHERE (`name` = $sname) } ] ] } { return "$sname is already banned" }
				pvparena eval { INSERT INTO `ban_pvp` (`name`) VALUES($sname) }
				Say $sele 0 "I have been banned from Arena Events"
				return "$sname is now banned from Arena Events"			
			}
			"unban" {
				if { [ ::GetPlevel $player ] < 4 } { return "You are not allowed to use this command!" }
				if { $sele == $player } { return "You can't use this command on yourself" }
				if { $sele == 0 || [ ::GetObjectType $sele ] != 4 } { return "Please select a player" }
				if { ![ string length [ pvparena eval { SELECT `name` FROM `ban_pvp` WHERE (`name` = $sname) } ] ] } { return "$sname is not banned" }
				pvparena eval { DELETE FROM `ban_pvp` WHERE (`name` = $sname) }
				Say $sele 0 "I have been unbanned from Arena Events"
				return "$sname is now unbanned from Arena Events"
			}
			"help" {
				if { [ ::GetPlevel $player ] < 4 } { set msg ".pvp enter --> Enter PVP Arena \n.pvp leave --> Leave PVP Arena" }
				set msg "How to use: \n.pvp enable --> Enable PVP Command \n.pvp disable --> Disable PVP Command \n.pvp enter --> Enter PVP Arena \n.pvp leave --> Leave PVP Arena \n.pvp ban --> Ban Selected Player from using PVP Command \n.pvp unban --> UnBan Selected Player from using PVP Command"
			}
		}
	}
}

Custom::HookProc "::WoWEmu::CalcXP" { if { [ ::GetEntry $victim ] == 25500 } { ::GArena::GuardKilled } }
Custom::AddCommand "guru" "::GArena::arena" 0
Custom::AddCommand "create_arenadb" "::GArena::create_arenadb" 4
