#
#
# This program is (c) 2006 by Raverouk <ravekz@yahoo.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>
#
#
# This program requires interaction with a Lua script known as the StatSystem
# client addon, authored by Raverouk.
#
#
# Name:		Stats.tcl
#
# Version:	1.20RC2
#
# Date:		2006-05-09
#
# Description:	Stats System
#
# Author:	Raverouk <ravekz@yahoo.com>
#

#
#	Start-TCL loading order
#
# StartTCL: n
#

#
#	namespace eval Balance
#
# Balance namespace and variable definitions
#


namespace eval Balance {

	variable ADDONS 1.03
	variable VERSION 1.20
	variable CUSTOM_VERSION 1.95
	variable NAME "StatSystem"
	variable USE_CONF 0
	variable USE_CONF_FILE "scripts/conf/stats.conf"

	# defaults (if you have stats.conf, use it to change values)

	variable security 0
	variable enable_enrage 1
	variable enable_dodge 1
	variable enable_miss 1
	variable enable_power 1
	variable enable_attack 1
	variable crushing_blow 1
	variable resistance 1
	variable bonus_armor 1
	variable factor 5
	variable mob_critical 0
	variable boss_balance 1
	variable mob_regeneration 1
	variable DEBUG 0

	# SQLdb
	variable handle

	proc Resistance { player mob dr } {
		variable DEBUG
		if {[ ::Distance $mob $player ] < 5} { return $dr }
		set dif [expr {[ ::GetLevel $player ]-[ ::GetLevel $mob ]}]
		if { $dif == 0 } {
			set tar 0.04
		} elseif { $dif < 0 } { return $dr }
		if {[ ::GetObjectType $mob ] == 4} {
			set fac 0.8
			set base 0.07
		} else {
			set fac 0.16
			set base 0.11
		}
		switch $dif {
			1 { set tar 0.05 }
			2 { set tar 0.06 }
			default { set tar [expr {($dif*$base)-$fac}] }
		}
		set dr [expr {$dr+$tar}]
		if { $DEBUG } { puts "Bonus Resistence: [expr {int($tar*100)}]%" }
		if { $dr > 0.85 } { set dr 0.85 }
		return $dr
	}

	proc Hit { player mob }	{
		variable DEBUG
		set name [ ::GetName $player ]
		if { $::Balance::enable_dodge } { if {[ Dodge $player $mob ] == 1} {
			if { $DEBUG } { puts "$name Dodge" }
			return 1} }
		if { $::Balance::enable_miss } { if {[ Miss $player $mob ] == 1} {
			if { $DEBUG } { puts "$name Miss" }
			return 1} }
		return 0
	}

	proc Miss { player mob } {
		variable DEBUG
		if {[ ::Distance $mob $player ] < 5} {return 0}
		set mlvl [ ::GetLevel $mob ]
		set plvl [ ::GetLevel $player ]
		set dif [expr {$plvl-$mlvl}]
		set rnd [expr {rand()}]
		set chance 0.96
		if {$dif > 0} {
			if {[ ::GetObjectType $player ] == 4} {
				switch $dif {
					1 {set chance 0.95}
					2 {set chance 0.94}
					default {set chance [expr {0.94-((($dif-2)*7.0)/100.0)}]}
				}
			} else {
				switch $dif {
					1 {set chance 0.95}
					2 {set chance 0.83}
					default {set chance [expr {0.94-((($dif-2)*9.0)/100.0)}]}
				}
			}
		}
		if {$chance <= 0.15} {set chance 0.15}
		if { $DEBUG } { puts "[ ::GetName $player ] Spell Miss Chance: [expr {int((1-$chance)*100)}]%" }
		if {$rnd >= $chance} {return 1}
		return 0
	}

	proc Dodge { player mob } {
		variable handle
		variable DEBUG
		set dodge 0.25
		set rnd [expr {rand()}]
		set mlvl [ ::GetLevel $mob ]
		set name [ ::GetName $player ]
		set Agility 1
		set Defense 1

		foreach row [ ::SQLdb::querySQLdb $handle "SELECT `agility`, `defense` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ] {
			foreach { Agility Defense } $row {
				if { $::DEBUG } {
					puts "Agility=\"$Agility\", Defense=\"$Defense\""
				}
			}
		}

		switch [GetClass $player] {
			3 {set mod 26.5}
			4 {set mod 14.5}
			default {set mod 20.0}
		}
		set agibonus [expr {($Agility*1.0)/$mod}]
		set dodge [expr {(($dodge+(($Defense-$mlvl*5)*0.04)+$agibonus)/100.0)*1.15}]
		if { $DEBUG } {	puts "[ ::GetName $player ] Dodge Chance: [expr {int($dodge*100)}]%" }
		if {$rnd <= $dodge} {return 1}
		return 0
	}

	proc Dr { player mob dr } {
		variable DEBUG
		if { $DEBUG } { puts "Normal Reduction: [expr {int($dr*100)}]%" }
		if { [::GetQFlag $player IsDead] } { return 1 }
		if { $::Balance::boss_balance } { if { [ ::Custom::GetElite $mob ] == 3 && $dr <= 0 } {set dr 0} }
		if { $::Balance::resistance } { set dr [ Resistance $player $mob $dr ] }
		if { $::Balance::crushing_blow } { set dr [ Crushing $player $mob $dr ] }
		if { $::Balance::enable_enrage } { set dr [ Enrage::Rage $player $mob $dr ] }
		if { $::Balance::enable_power } { set dr [ Power $player $mob $dr ] }
		if { $::Balance::enable_attack } { set dr [ Attack $player $mob $dr ] }
		if { $DEBUG } { puts "Total Reduction: [expr {int($dr*100)}]%" }
		return $dr
	}

	proc Crushing { player mob dr } {
		set plrlvl [ ::GetLevel $player ]
		set moblvl [ ::GetLevel $mob ]
		if {[expr {$moblvl-$plrlvl}] > 2} {
			if {[expr {rand()*100}] <= 15} { set dr [expr {1-(1-$dr)*1.5}] }
		}
		return $dr
	}

	proc Power { player mob dr } {
		variable handle
		set val 1
		if {[ ::GetObjectType $mob ] == 4} {
			set name [ ::GetName $mob ]
			if {[ ::Distance $mob $player ] < 5} { set attack 1 } else { set attack 0 }
			set Agility 1
			set Strength 1

			foreach row [ ::SQLdb::querySQLdb $handle "SELECT `agility`, `strength` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ] {
				foreach { Agility Strength } $row {
					if { $::DEBUG } {
						puts "Agility=\"$Agility\", Strength=\"$Strength\""
					}
				}
			}

			set lvl [ ::GetLevel $player ]
			set bonus [expr {$lvl*10.0+1450.0}]
			switch [ ::GetClass $mob ] {
				3 {
					if {$attack == 1} {
						set val [expr {1+(($Strength+$Agility*1.0)/$bonus)}]
					} else {
						set val [expr {1+(($Strength+$Agility*2.0)/$bonus)}]
					}
				}
				4 {
					if {$attack == 1} {
						set val [expr {1+(($Strength+$Agility*1.0)/$bonus)}]
					}
				}
				default {
					if {$attack == 1} {
						set val [expr {1+($Strength*2.0/$bonus)}]
					}
				}
			}
			set dr [expr {1-(1-$dr)*$val}]
		}
		return $dr
	}

	proc Attack { player mob dr } {
		set rnd [expr {rand()}]
		if {[ ::GetObjectType $mob ] == 4} {
			set name [ ::GetName $mob ]
			if {[ ::Distance $mob $player ] > 5} { set attack 1 } else { set attack 0 }
			switch $attack {
				1 {
					set chance [expr {[ Spell $mob $name ]*1.25}]
					if { $chance == 0 } { return $dr }
					if { $rnd <= $chance } {
						set dr [expr {1-(1-$dr)*1.5}]
					}
				}
				0 {
					set chance [expr {[ Melee $mob $name ]*1.25}]
					if { $rnd <= $chance } {
						set dr [expr {1-(1-$dr)*2.0}]
					}
				}
			}
		} else {
			if { $::Balance::mob_critical } {
				set chance [ Mob $mob ]
				if { $rnd <= $chance } {
					set dr [expr {1-(1-$dr)*1.75}]
				}
			}	
		}
		return $dr
	}

	proc Spell { player name } {
		variable handle
		set Intellect [ ::SQLdb::firstcellSQLdb $handle "SELECT `intellect` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ]
		set Intellect [ expr { [ string is digit -strict $Intellect ] ? $Intellect : 1 } ]
		switch [ ::GetClass $player ] {
			1 { return 0 }
			2 { 	set chance [expr {($Intellect*1.0)/30.0}]
				return [expr {$chance/100.0}]
			}
			3 { return 0 }
			4 { return 0 }
			11 {
				set chance [expr {($Intellect*1.0)/30.0}]
				return [expr {$chance/100.0}]
			}
			default {
				set chance [expr {($Intellect*1.0)/59.5}]
				return [expr {$chance/100.0}]
			}
		}
	}

	proc Melee { player name } {
		variable handle
		set Agility [ ::SQLdb::firstcellSQLdb $handle "SELECT `agility` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ]
		set Agility [ expr { [ string is digit -strict $Agility ] ? $Agility : 1 } ]
		switch [::GetClass $player] {
			1 {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
			3 {
				set chance [expr {5.0+($Agility*1.0)/53.0}]
				return [expr {$chance/100.0}]
			}
			4 {
				set chance [expr {5.0+($Agility*1.0)/29.0}]
				return [expr {$chance/100.0}]
			}
			7 {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
			default {
				set chance [expr {5.0+($Agility*1.0)/20.0}]
				return [expr {$chance/100.0}]
			}
		}
	}

	proc Mob { mob } {
		switch [ ::Custom::GetElite $mob ] {
			0 {set bonus 0}
			1 {set bonus 0.03}
			2 {set bonus 0.09}
			3 {set bonus 0.15}
			4 {set bonus 0.12}
		}
		set lvl [ ::GetLevel $mob ]
		if {$lvl > 60 } { set lvl 60 }
		set calc [expr {($lvl*8.0)/1000.0}]
		if {$calc > 0.20} {set calc 0.20}
		set calc [expr {$calc+$bonus}]
		return $calc
	}

	proc Armor { player armor } {
		variable DEBUG
		variable handle
		set Arm $armor
		set Agility 1
		set name [ ::GetName $player ]
		if { $::Balance::security } { Security $player $armor $name }
		if { $DEBUG } {	puts "Default Armor ($name): $armor" }

		foreach row [ ::SQLdb::querySQLdb $handle "SELECT `agility`, `armor` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ] {
			foreach { Agility Arm } $row {
				if { $::DEBUG } {
					puts "Agility=\"$Agility\", Armor=\"$Arm\""
				}
			}
		}

		if { $::Balance::bonus_armor } {
			set plvl [ ::GetLevel $player ]
			set Arm [expr {$Arm+($plvl*$::Balance::factor)}]
			if { $DEBUG } {
				set bonus [expr {$plvl*$::Balance::factor}]	
				puts "Bonus Armor ($name): $bonus" }
		}
		set Arm [expr {$Arm+2.0*$Agility}]
		if { $DEBUG } { puts "Total Armor w/Agi ($name): $Arm" }
		return $Arm
	}
		
	proc Call { player cargs } {
		variable handle
		set name [ ::GetName $player ]
		if {[llength $cargs] < 6} {
			Stat $player 0
		} else {
			set Armor [lindex $cargs 0]
			set Agility [lindex $cargs 1]
			set Intellect [lindex $cargs 2]
			set Defense [lindex $cargs 3]
			set Strength [lindex $cargs 4]
			set Buff [lindex $cargs 5]
			set plvl [ ::GetPlevel $player ]
			set lvl [ ::GetLevel $player ]
			set skill [expr {$lvl*5}]
			if { $Defense > $skill } { set Defense 0 }
			if { [ ::GetLevel $player ] > 254 } {
				if { $Armor > 88000 && $plvl < 3} { set Armor 0 }
				if { $Agility > 2000 && $plvl < 3} { set Agility 0 }
				if { $Intellect > 1900 && $plvl < 3} { set Intellect 0 }
				if { $Strength > 1900 && $plvl < 3} { set Strength 0 }
			} else {
				if { $Armor > 52000 && $plvl < 3} { set Armor 0 }
				if { $Agility > 1600 && $plvl < 3} { set Agility 0 }
				if { $Intellect > 1600 && $plvl < 3} { set Intellect 0 }
				if { $Strength > 1600 && $plvl < 3} { set Strength 0 }
			}
			::SQLdb::querySQLdb $handle "REPLACE INTO `stats` VALUES('[ ::SQLdb::canonizeSQLdb $name ]', $Armor, $Agility, $Intellect, $Defense, $Strength, $Buff)"
		}
	}

	proc Security { player armor name } {
		variable handle
		if { $armor == 0 } {
			return
		} else {
			foreach row [ ::SQLdb::querySQLdb $handle "SELECT `armor`, `buff` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')" ] {
				foreach { A B } $row {
					if {$armor == $A} {
						return
					} elseif {$A > [expr {$armor+$B}]} {
						# set Arm 0
						# set Agility 0
						# set Intellect 0
						# set Defense 0
						# set Strength 0
						# set Buff 0
						# ::SQLdb::querySQLdb $handle "UPDATE `stats` SET `armor` = $Armor, `agility` = $Agility, `intellect` = $Intellect, `defense` = $Defense, `strength` = $Strength, `buff` = $Buff WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $name ]')"
						set time [ ::Custom::DateString ]
						set text "$time $name send have a error: Stat armor:$A Correct armor: $armor"
						set file "logs/stats.log"
						set id [open $file a+]
						puts $id $text
						close $id				
						if { [file size "logs/stats.log"] >= 512000 } {
							file rename -force "logs/stats.log" "logs/stats.old"
						}
						return "You have cheat!"
					}
				}
			}
		}
	}

	proc Ver { player cargs } {
		variable ADDONS
		if {$cargs < $ADDONS} {
			Stat $player 0
			set name [ ::GetName $player ]
			set ver $cargs
			set time [ ::Custom::DateString ]
			set text "$time $name have a Old StatsAddons v$ver"
			set file "logs/stats.log"
			set id [open $file a+]
			puts $id $text
			close $id
			return "Please update StatsAddons"		
		}
	}

	proc Stat { player cargs } {
		variable handle
		set name [ ::GetName $player ]
		if { $cargs == "redo" && [ ::GetPlevel $player ] > 4 } {
			SetDB $cargs
			SetDB
			return "Done..."
		} elseif { $cargs == "info" } {
			set selection [ ::GetSelection $player ]
			if { !$selection } { set selection $player }
			if { [ ::GetObjectType $selection ] != 4 } { return "Please select a player." }
			if { [ ::Custom::GetSide $player ] != [ ::Custom::GetSide $selection ] && [ ::GetPlevel $player ] == 0 } { return "Select a player of your faction." }
			set player_name [ ::GetName $selection ]

			foreach row [ ::SQLdb::querySQLdb $handle "SELECT `armor`, `agility`, `intellect`, `defense`, `strength` FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $player_name ]')" ] {
				foreach { Armor Agility Intellect Defense Strength } $row {
				set Bonus [expr {$Agility*2}]
				set Reduction [Reduction $selection $Armor]
				return "$player_name:\n Str: $Strength Agi: $Agility Int: $Intellect Def: $Defense Armor: $Armor +Bonus: $Bonus\n Damage Absorb: [expr {int($Reduction*100)}]%"
				}
			}
			return "$player_name don't have StatAddons"

		} elseif { $cargs == "del" && [ ::GetPlevel $player ] > 4 } {
			set selection [ ::GetSelection $player ]
			if { !$selection } { return "Please select a player." }
			if { [ ::GetObjectType $selection ] != 4 } { return "Please select a player."}
			set player_name [ ::GetName $selection ]
			::SQLdb::querySQLdb $handle "DELETE FROM `stats` WHERE(`name` = '[ ::SQLdb::canonizeSQLdb $player_name ]')"
			return "Delete...Done."
		} elseif { $cargs == "help" || $cargs == "" } { return "Stats System v$::Balance::VERSION by Raverouk\n .stat redo (to reset the database)\n .stat info (give player stats info)\n .stat del (erase a player stats)\n .stat help (give this help)"
		} elseif { [llength $cargs] > 0 } { return "Command error from StatAddons" }
		::SQLdb::querySQLdb $handle "REPLACE INTO `stats` VALUES('[ ::SQLdb::canonizeSQLdb $name ]', 0, 0, 0, 0, 0, 0)"
		return "Error! in your StatsAddons"
	}

	proc Reduction { player armor } {
		set level [ ::GetLevel $player ]
		set dr [ expr { $armor / double( $armor + 400 + 85 * $level ) } ]
		return $dr
	}

	proc CheckCustomVersion {} {
		variable CUSTOM_VERSION
		::StartTCL::Require Custom $CUSTOM_VERSION
		if { [info exists ::Custom::VERSION] } {
			set current_version $::Custom::VERSION
			if { $current_version < $CUSTOM_VERSION } {
				if { [info procs ::Custom::Error] != "" } {
					::Custom::Error "Custom v$current_version loaded but v$CUSTOM_VERSION or newer needed!"
				} else {
					error "StatSystem: Error in \"Custom\" script!"
				}
			}
		} else {
			error "StatSystem: \"Custom\" script is missing!"
		}
	}

	proc SQLdb_CheckPackage {} {
		if { [lsearch [package names] "SQLdb"] < 0 } {
			puts "SQLdb is not installed, the option \"use_sqldb\" will be ignored."
			return 0
		}
		package require SQLdb
		return 1
	}
	
	proc handleSQLdb {} {
		variable handle
		if { ![info exists ::SQLdb::handle] } {
			set ::SQLdb::nghandle [::SQLdb::openSQLdb]
		}
		return $::SQLdb::nghandle
	}

	proc Init {} {

		if { ![SQLdb_CheckPackage] } {
			puts "¡Error! - Need SQLdb database system"
		}

		variable handle [handleSQLdb]
		setSQLdb

		CheckCustomVersion
		::Custom::HookProc ::WoWEmu::CalcXP {::ClearQFlag $victim Rage;::ClearQFlag $victim Health}
		::Custom::HookProc ::AI::CanAgro {if {[::GetQFlag $victim IsDead]} { return 0 }}
		::Custom::HookProc ::WoWEmu::OnPlayerDeath {::ClearQFlag $killer Rage;::ClearQFlag $killer Health}
		::Custom::AddCommand "ver" "Balance::Ver" 0
		::Custom::AddCommand "call" "Balance::Call" 0
		::Custom::AddCommand "stat" "Balance::Stat" 0
		::Balance::MobRegen
		set loadinfo "$::Balance::NAME v$::Balance::VERSION by Raverouk loaded - SQLdb"
		puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
	}

	#	proc SetDB { args }
	#
	# Procedure to setup/convert the current database to SQLdb
	#
	proc SetDB { args } {
		variable handle

		switch [ lindex $args 0 ] {
			"redo" {
				if { [ ::SQLdb::existsSQLdb $handle `stats` ] } {
					::SQLdb::querySQLdb $handle "DROP TABLE `stats`"
				}

				::SQLdb::cleanupSQLdb $handle
			}
			"upgrade" {
				set data 0

				if { [ ::SQLdb::existsSQLdb $handle `stats` ] } {
					::SQLdb::querySQLdb $handle "CREATE TEMPORARY TABLE `stats_t` (`name` VARCHAR(16) NOT NULL DEFAULT '' PRIMARY KEY, `armor` INTEGER NOT NULL DEFAULT 0, `agility` INTEGER NOT NULL DEFAULT 0, `intellect` INTEGER NOT NULL DEFAULT 0, `defense` INTEGER NOT NULL DEFAULT 0, `strength` INTEGER NOT NULL DEFAULT 0, `buff` INTEGER NOT NULL DEFAULT 0)"

					foreach row [ ::SQLdb::querySQLdb $handle "SELECT * FROM `stats`" ] {
						foreach { name armor agility intellect defense strength buff } $row {
							# `name` `armor` `agility` `intellect` `defense` `strength` `buff`
							::SQLdb::querySQLdb $handle "INSERT INTO `stats_t` VALUES('[ ::SQLdb::canonizeSQLdb $name ]', $armor, $agility, $intellect, $defense, $strength, $buff)"
						}
					}

					incr data
				}

				SetDB redo

				if { $data } {
					::SQLdb::querySQLdb $handle "INSERT INTO `stats` SELECT * FROM `stats_t`"
					::SQLdb::querySQLdb $handle "DROP TABLE `stats_t`"
					return
				}
			}
			"update" {
				set data 0

				if { [ ::SQLdb::existsSQLdb $handle `stats` ] } {
					::SQLdb::querySQLdb $handle "CREATE TEMPORARY TABLE `stats_t` (`name` VARCHAR(16) NOT NULL DEFAULT '' PRIMARY KEY, `armor` INTEGER NOT NULL DEFAULT 0, `agility` INTEGER NOT NULL DEFAULT 0, `intellect` INTEGER NOT NULL DEFAULT 0, `defense` INTEGER NOT NULL DEFAULT 0, `strength` INTEGER NOT NULL DEFAULT 0, `buff` INTEGER NOT NULL DEFAULT 0)"
					::SQLdb::querySQLdb $nghandle "INSERT INTO `stats_t` SELECT * FROM `stats`"
					incr data
				}

				SetDB redo

				if { $data } {
					::SQLdb::querySQLdb $handle "INSERT INTO `stats` SELECT * FROM `stats_t`"
					::SQLdb::querySQLdb $handle "DROP TABLE `stats_t`"
					return
				}
			}
		}

		if { ! [ ::SQLdb::existsSQLdb $handle `stats` ] } {
			::SQLdb::querySQLdb $handle "CREATE TABLE `stats` (`name` VARCHAR(16) NOT NULL DEFAULT '' PRIMARY KEY, `armor` INTEGER NOT NULL DEFAULT 0, `agility` INTEGER NOT NULL DEFAULT 0, `intellect` INTEGER NOT NULL DEFAULT 0, `defense` INTEGER NOT NULL DEFAULT 0, `strength` INTEGER NOT NULL DEFAULT 0, `buff` INTEGER NOT NULL DEFAULT 0)"
		}

	}

	#	proc setSQLdb { }
	#
	# Procedure to set, check and update the SQLdb database entry
	#
	proc setSQLdb { } {
		variable handle

		if { ! [ info exists ::SQLdb::NAME ] } {
			error "SQLdb library not found, aborting!"
		}

		# "NAME" is the script name (this MUST be consistent accross
		#      versions)
		# "version" is the script current version
		if { ! [ ::SQLdb::booleanSQLdb $handle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::Balance::NAME')" ] } {
			SetDB upgrade
			# Whatever commands you need to get a first time run
			# working, but it must contain:
			::SQLdb::querySQLdb $handle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::Balance::NAME', '$::Balance::VERSION')"
		} else {
			set oldver [ ::SQLdb::firstcellSQLdb $handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::Balance::NAME')" ]

			if { [ expr { $oldver > $::Balance::VERSION } ] } {
				# Whatever commands needed to downgrade, or if
				# downgrading isn't allowed something like:
				error "The current version of $::Balance::NAME ($::Balance::VERSION) is older that the previous one ($oldver), downgrade unsupported!"
				# If downgrading is allowed it must end with:
				#::SQLdb::querySQLdb $handle "UPDATE `$SQLdb::NAME` SET `version` = '$::Balance::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::Balance::NAME')"
			} elseif { [ expr { $oldver < $::Balance::VERSION } ] } {
				SetDB update
				# Whatever command to upgrade (for instance a
				# switch cycle if different steps are needed to
				# upgrade from different versions) but the
				# batch of commands must end with:
				::SQLdb::querySQLdb $handle "UPDATE `$SQLdb::NAME` SET `version` = '$::Balance::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::Balance::NAME')"
			}
		}
	}
}

namespace eval Enrage {
	proc Rage { player mob dr } {
		if {[ ::GetObjectType $player ] != 4} {
			set elite [ ::Custom::GetElite $mob ]
			set type [ ::GetCreatureType $mob ]
			set mobh [ ::GetHealthPCT $mob ]
			set rnd [expr {int(rand()*100)}]
			switch $type {
				7 {
					if {($rnd <= 20) && ($mobh <= 25) && ($elite != 0) && ($elite != 3) && (![ ::GetQFlag $mob Rage ])} {
						::Say $mob 0 "Arrggg"
						::SetQFlag $mob Rage
						::CastSpell $mob $mob 5229
						::Emote $mob 16
					}
					if {($rnd <= 5) && (![ ::GetQFlag $mob Health ]) && ($mobh <= 40) && ($elite == 0)} {
						::SetQFlag $mob Health
						::CastSpell $mob $mob 23965
					}
				}
				1 {
					if {($rnd <= 10) && ($mobh <= 30)} {
						::SetQFlag $mob Rage
						::CastSpell $mob $player 24187
					}
				}
			}
		}
		if {[ ::GetQFlag $mob Rage ]} {set dr [expr {1-(1-$dr)*1.25}]}
		return $dr
	}
}

namespace eval Balance {
	proc MobRegen {} {
		if {$::Balance::mob_regeneration} {
			::Custom::HookProc ::WoWEmu::CalcXP {
				::ClearQFlag $victim Killer
			}
			::Custom::HookProc ::WoWEmu::OnPlayerDeath {
				if {[ ::GetObjectType $killer ] != 4} {
					::SetQFlag $killer Killer
				}
			}
			::Custom::HookProc ::AI::CanCast {
				if {[ ::GetQFlag $npc Killer ]} {
					if {[ ::GetHealthPCT $npc ] < 40 && rand() > 0.6} {
						::CastSpell $npc $npc 18386
					} else {
						::ClearQFlag $npc Killer
					}
				}
			}
			::Custom::HookProc ::WoWEmu::DamageReduction {
				if {[ ::GetObjectType $mob ] != 4 && ![ ::GetQFlag $mob Killer ]} {
					::SetQFlag $mob Killer
				}
			}
		}
	}
}

#
#	startup time command execution
#
# Run the "init" procedure at server start
#

::Balance::Init
