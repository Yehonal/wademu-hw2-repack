# StartTCL: a
#
# Custom Procedures
#
# This program is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
# This program is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
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

namespace eval ::Custom {

	variable VERSION 2.10
	variable DEBUG 0

	# registers a command to call a given procedure
	proc AddCommand { args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { command proc plevel } $args {
			if { ![string is integer -strict $plevel] } { set plevel 0 }
			set ::WoWEmu::Commands($command) [list $proc $plevel]
		}
	}

	# links a procedure to a given spell effect
	proc AddSpellScript { proc args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { spellid } $args {
			if { ![string is integer -strict $spellid] } {
				uplevel ::Custom::Error \{"Invalid spell: $spellid."\}
			} elseif { ![info exists ::SpellEffects::ScriptEffects($spellid)] || [lsearch $::SpellEffects::ScriptEffects($spellid) $proc] < 0 } {
				lappend ::SpellEffects::ScriptEffects($spellid) $proc
			}
		}
	}

	# links spell scripts to specified commands using a switch-like syntax
	proc AddLegacySpellScript { array } {
		foreach { spellid commands } $array {
			if { [ info procs "::SpellEffects::LegacySpellScript$spellid" ] == "" } {
				proc ::SpellEffects::LegacySpellScript$spellid { to from spellid } $commands
				::Custom::AddSpellScript "::SpellEffects::LegacySpellScript$spellid" $spellid
			} else {
				::Custom::HookProc "::SpellEffects::LegacySpellScript$spellid" $commands
			}
		}
	}

	# unregisters a command
	proc DelCommand { args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { command } $args {
			array unset ::WoWEmu::Commands $command
		}
	}

	# unlinks a spell script
	proc DelSpellScript { proc args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { spellid } $args {
			set pos [lsearch $::SpellEffects::ScriptEffects($spellid) $proc]
			set ::SpellEffects::ScriptEffects($spellid) [lreplace $::SpellEffects::ScriptEffects($spellid) $pos $pos]
		}
	}

	# logging of commands
	proc LogCommand { args } {
		set args [string map {\} {} \{ {}} $args]
		foreach { command } $args {
			if { ![info exists ::WoWEmu::Commands($command)] } { continue }
			set ::Custom::LogCommand $command
			set ::Custom::LogCommandProc [lindex $::WoWEmu::Commands($command) 0]
			namespace eval ::WoWEmu {
				eval "::Custom::HookProc $::Custom::LogCommandProc {
					::WoWEmu::Commands::Log $::Custom::LogCommand \$player \$cargs
				}"
			}
			unset ::Custom::LogCommand
			unset ::Custom::LogCommandProc
		}
	}

	# returns a string with the guild name for the given player
	proc GetGuildName { player {force_update 0} } {
		variable guild
		if { ![info exists guild] || $force_update } {
			set handle [open "saves/guilds.save"]
			while { [gets $handle line] >= 0 } {
				set line [split $line "="]
				switch [lindex $line 0] {
					"NAME" { set name [lindex $line 1] }
					"MEMBER" { set guild([lindex [lindex $line 1] 0]) $name }
				}
			}
			close $handle
		}
		set guid [::GetGuid $player]
		if { [info exists guild($guid)] } { return $guild($guid) }
	}

	# get a player's total amount of money
	proc GetMoney { player } {
		set total 0

		for { set money [ expr { 1 << 30 } ] } { $money } { set money [ expr { $money >> 1 } ] } {
			if { [ ::ChangeMoney $player -$money ] } {
				incr total $money
			}
		}

		::ChangeMoney $player $total
		return $total
	}

	# return a integer ranged from -3 to 4 depending on the player reputation regarding a NPC faction
	proc GetReputationLevel { player npc } {
		# range: -41999 42999
		set repu [::GetReputation $player $npc]
		if { $repu >= 42000 } { return 4
		} elseif { $repu >= 21000 } { return 3
		} elseif { $repu >= 9000 } { return 2
		} elseif { $repu >= 3000 } { return 1
		} elseif { $repu >= 0 } { return 0
		} elseif { $repu >= -3000 } { return -1
		} elseif { $repu >= -6000 } { return -2 }
		return -3
	}

	# returns the ID of a player or 0 if unknown
	proc GetPlayerID { player_name } {
		set player_name [string tolower $player_name]
		set player_id [::Custom::DbArrayValue ::Custom::PlayerID $player_name]

		if { [::GetObjectType $player_id] == 4 } {
			set name [string tolower [::GetName $player_id]]
			if { $name == $player_name } {
				return $player_id
			} else {
				::Custom::DbArray unset ::Custom::PlayerID $player_name
				::Custom::DbArray set ::Custom::PlayerID [list $name $player_id]
				return 0
			}
		} else {
			::Custom::DbArray unset ::Custom::PlayerID $player_name
			return 0
		}
	}

	# returns a list of all known player IDs (don't use at server start!)
	proc GetKnownPlayers {} {
		set known_players {}

		foreach { player_name player_id } [::Custom::DbArray get ::Custom::PlayerID] {
			if { [::GetObjectType $player_id] != 4 } {
				::Custom::DbArray unset ::Custom::PlayerID $player_name
				continue
			}

			set name [string tolower [::GetName $player_id]]
			if { $name != $player_name } {
				::Custom::DbArray unset ::Custom::PlayerID $player_name
				::Custom::DbArray set ::Custom::PlayerID [list $name $player_id]
			}

			lappend known_players $player_id
		}

		return $known_players
	}

	# returns a string with the name of the game object or target NPC
	proc GetName { obj } { if { [::GetObjectType $obj] == 4 } { ::GetName $obj } else { GetNpcName $obj } }

	# returns a dying scream as a string
	proc DyingScream { {player 0} } {
		set screams "Aaaahhh Aarrh Aaarrh Aaarrgg Aaahh Aahh Ahhh"
		return "[lindex $screams [expr {int(rand()*[llength $screams])}]]..."
	}

	# return a random integer from a given interval
	proc RandInt { a b } { expr {$a+int(rand()*($b-$a+1))} }

	# send the given player to his bind position
	proc GoHome { player } { TeleportPos $player [::GetBindpoint $player] }

	# returns a string with the rounded values of a given position
	proc RoundPos { pos } { return [list [lindex $pos 0] [expr {round([lindex $pos 1])}] [expr {round([lindex $pos 2])}] [expr {round([lindex $pos 3]+.5)}]] }

	# send the player to a given position
	proc TeleportPos { player pos } { Teleport $player [lindex $pos 0] [lindex $pos 1] [lindex $pos 2] [lindex $pos 3] }

	# returns the X and y distance between two positions
	proc DistancePos { a b } {
		if { [lindex $a 0] != [lindex $b 0] } { return -1 }
		expr {hypot([lindex $b 1]-[lindex $a 1],[lindex $b 2]-[lindex $a 2])}
	}

	# returns a string in the format "YYYY-MM-DD HH:MM:SS"
	proc DateString { } { clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S" }

	# returns a string suited to prefix entries in the server console
	proc LogPrefix {} { return "[clock format [clock seconds] -format %k:%M:%S]:M:" }

	# converts a integer to a time string in the form "HHhMMmSSs"
	proc SecondsToTime { seconds {noseconds 0} } {
		set h [expr {$seconds / 3600}]
		set m [expr {$seconds / 60 % 60}]
		set s [expr {$seconds % 60}]
		set time ""

		if { $h > 0 } {
			#if { $h < 10 } { set h "0$h" }
			append time "${h}h"
		}

		if { $m > 0 || ($h > 0 && $s > 0) } {
			if { $m < 10 && $h > 0 } { set m "0$m" }
			append time "${m}m"
		}

		if { !$noseconds && $s > 0 } {
			if { $s < 10 && ($m > 0 || $h > 0) } { set s "0$s" }
			append time "${s}s"
		}

		return $time
	}

	# converts a integer from base 10 to base 16
	proc DecToHex { num } {
		if { ![string is integer -strict $num] || !$num } { return "00" }
		set hex ""
		while { $num } {
			set hex [string index "0123456789ABCDEF" [expr {$num % 16}]]$hex
			set num [expr {$num / 16}]
		}
		return "0$hex"
	}

	# returns the side of a given player, NPC or game object
	proc GetSide { obj } { if { [::GetObjectType $obj] == 4 } { GetPlayerSide $obj } else { GetNpcSide $obj } }

	# returns the side of a given player (0 = Alliance, 1 = Horde)
	proc GetPlayerSide { player } {
		if { ![info exists ::Custom::GetPlayerSide($player)] } {
			set ::Custom::GetPlayerSide($player) [GetPlayerSideByRace [::GetRace $player]]
		}
		return $::Custom::GetPlayerSide($player)
	}

	# returns the side of a given race (0 = Alliance, 1 = Horde)
	proc GetPlayerSideByRace { race } { expr {[string first $race {1347}] < 0} }

	# returns the faction of a given NPC
	proc GetFaction { npc } { GetCreatureScp [::GetEntry $npc] faction }

	# returns the family of a given NPC
	proc GetFamily { npc } { GetCreatureScp [::GetEntry $npc] family }

	# returns the elite status of a given NPC
	proc GetElite { npc } { GetCreatureScp [::GetEntry $npc] elite }

	# returns a boolean value regarding the civilian status of a given NPC
	proc GetCivilian { npc } { GetCreatureScp [::GetEntry $npc] civilian }

	# returns the name of the given NPC
	proc GetNpcName { npc } { GetCreatureScp [::GetEntry $npc] name }

	# returns the side of the given NPC (0 = Alliance, 1 = Horde)
	proc GetNpcSide { npc } { GetNpcSideByFaction [GetCreatureScp [::GetEntry $npc] faction] }

	# already defined by wowemu:
	# GetCreatureType (type)
	# GetNpcflags (npcflags)

	# returns a cached value from the given creature definition
	proc GetCreatureScp { entry key {type ""} } {
		variable CreatureScp

		if { ![info exists CreatureScp($entry,$key)] } {
			set value [join [::GetScpValue "creatures.scp" "creature $entry" $key]]

			switch -- $key {
				"elite" -
				"civilian" -
				"faction" -
				"family" -
				"npcflags" -
				"flags1" -
				"maxhealth" -
				"maxmana" -
				"model" {
					set type "integer"
				}
				"speed" -
				"bounding_radius" -
				"combat_reach" {
					set type "double"
				}
				"damage" -
				"attack" {
					set type "integer integer"
				}
			}

			while { [llength $value] < [llength $type] } {
				lappend value ""
			}

			for { set i 0 } { $i < [llength $type] } { incr i } {
				if { [lindex $type $i] == "integer" } {
					if { [string index [lindex $value $i] 0] == "0" } {
						lset value $i "0x[lindex $value $i]"
					}

					if { ![string is "integer" -strict [lindex $value $i]] && ![regexp {(\.\.|,)} $value] } {
						lset value $i 0
					}
				} else {
					if { ![string is [lindex $type $i] -strict [lindex $value $i]] } {
						if { [string is [lindex $type $i] -strict 0] } { lset value $i 0 } { lset value $i "" }
					}
				}
			}

			set CreatureScp($entry,$key) [join $value]
		}

		return $CreatureScp($entry,$key)
	}

	# returns an integer value from an scp value that can be decimal or hexadecimal and using the ".." or "," syntax
	proc GetIntegerValue { value } {

		proc GetDec { value } {
			if { [string index $value 0] == "0" } {
				set value "0x$value"
			}

			return [expr {[string is integer -strict $value] ? $value : [string is double -strict $value] ? round($value) : 0}]
		}

		if { [string first ".." $value] >= 0 } {
			foreach { a {} b } [split $value "."] {}
			return [RandInt [GetDec $a] [GetDec $b]]
		}

		return [GetDec [lindex [set list [split $value ","]] [expr {int(rand() * [llength $list])}]]]
	}

	# returns the side of a given faction (0 = Alliance, 1 = Horde, -1 = Other)
	proc GetNpcSideByFaction { faction } {
		variable NpcSide
		if { ![info exists NpcSide($faction)] } {
			if { [lsearch {11 12 55 57 64 79 80 84 122 123 124 148 210 371 534 1076 1078 1097 1315 1514 1575 1594 1600} $faction] >= 0 } {
				set NpcSide($faction) 0
			} elseif { [lsearch {29 68 71 83 85 98 104 105 106 118 125 126 714 995 1034 1074 1174 1314 1515 1595} $faction] >= 0 } {
				set NpcSide($faction) 1
			} else {
				set NpcSide($faction) -1
			}
		}
		return $NpcSide($faction)
	}

	# returns a boolean depending if a given player or NPC is dead or alive
	proc IsAlive { obj } { if { [::GetObjectType $obj] == 4 } { PlayerIsAlive $obj } { NpcIsAlive $obj } }

	# returns a boolean depending if a given player is alive
	proc PlayerIsAlive { player } { expr {![::GetQFlag $player IsDead]} }

	# returns a boolean depending if a given NPC is alive
	proc NpcIsAlive { npc } { expr {[::GetHealthPCT $npc] > 0} }

	# returns a boolean depending if the difference of levels results in the victim being "grey leveled" to the killer
	proc IsGreyLevel { victim_level killer_level } {
		if { $killer_level > 60 } {
			return [expr {$victim_level < $killer_level - 12}]
		} elseif { $killer_level > 40 } {
			return [expr {$victim_level < $killer_level - $killer_level / 5}]
		} else {
			return [expr {$victim_level < $killer_level - $killer_level / 10 - 4}]
		}
	}

	# returns a boolean depending if the victim is "grey leveled" to the killer
	proc IsTrivial { victim killer } {
		set victim_level [::GetLevel $victim]
		set killer_level [::GetLevel $killer]

		if { $killer_level > 60 } {
			return [expr {$victim_level < $killer_level-12}]
		} elseif { $killer_level > 40 } {
			return [expr {$victim_level < $killer_level*4/5}]
		} else {
			return [expr {$victim_level < $killer_level-$killer_level/10-4}]
		}
	}

	# add a log message into a given file
	proc Log { msg file {commit 1} } {
		if { ![info exists ::Custom::LogHandle($file)] } {
			set ::Custom::LogHandle($file) [open $file a]
		}
		puts $::Custom::LogHandle($file) "[DateString]: $msg"
		if { $commit } {
			LogCommit $file
		}
	}

	# commit the writing into specified log files
	proc LogCommit { {file_filter *} } {
		foreach file [array names ::Custom::LogHandle $file_filter] {
			close $::Custom::LogHandle($file)
			unset ::Custom::LogHandle($file)
		}
	}

	# outputs to the game console and the error log the given error message
	proc Error { msg } {
		set script [info script]
		if { $script == "" } {
			set script [namespace tail [uplevel namespace current]]
		}
		puts stderr "\n ERROR $script: $msg\n"
		Log "$script: $msg" "logs/errors.log"
	}

	# returns the VERSION variable from the given namespace (-1 if not found)
	proc GetScriptVersion { script } {
		if { [info exists ::${script}::VERSION] } { return [set ::${script}::VERSION] }
		if { [namespace exists ::$script] } { return 0 }
		return -1
	}

	# allows loading TCL files encoded in UTF-8 with BOM
	proc Source { filename } {
		info script $filename

		set handle [open $filename]
		set data [read $handle]
		close $handle

		if { ![string is ascii [string index $data 0]] } {
			uplevel eval \{[string range $data 1 end]\}
		} else {
			uplevel eval \{$data\}
		}
	}

	if { [info procs ::Custom::GetID] == "" } {
		proc GetID { args } {
			uplevel ::Custom::Error \{"This script needs Itemsarray.tcl but it is missing."\}
			return 0
		}
	}
}


# conf stuff
namespace eval ::Custom {

	# loads the uppercase version of the variables found into the namespace section of the given configuration file
	proc LoadConf { {script ""} {conf_file "scripts/conf/scripts.conf"} {verbose 0} } {

		if { $script == "" } { set script [namespace tail [uplevel namespace current]] }
		set loaded 0
		if { [file exists $conf_file] } {

			variable ConfFileData
			variable ConfFileCheck
			if { ![info exists ConfFileCheck($conf_file)] } { set ConfFileCheck($conf_file) 0 }
			set time [clock seconds]
			if { $time-$ConfFileCheck($conf_file) > 9 } {
				set ConfFileData($conf_file) ""
				set hconfig [open $conf_file]
				while { [gets $hconfig line] >= 0 } {
					set pos [string first "#" $line]
					if { $pos >= 0 } { set line [string range $line 0 [expr {$pos-1}]] }
					set pos [string first "//" $line]
					if { $pos >= 0 } { set line [string range $line 0 [expr {$pos-1}]] }
					set line [string trim $line]
					if { $line == "" } { continue }
					lappend ConfFileData($conf_file) $line
				}
				close $hconfig
				set ConfFileCheck($conf_file) $time
			}
			set in_section 0
			foreach line $ConfFileData($conf_file) {
				if { [string index $line 0] == "\[" } {
					set section [lindex [split $line {[]}] 1]
					if { ![namespace exists ::$section] } {
						set section [string totitle $section]
					}
					if { [string match -nocase $script $section] } {
						set in_section 1
					} else { set in_section 0 }
				} elseif { $in_section } {
					set line [split $line "="]
					set name [string toupper [string trim [lindex $line 0]]]
					if { $name != "" } {
						set value [string trim [lindex $line 1]]
						if { [string index $value 0] == "\"" } {
							set value [string trim [lindex [split $value "\""] 1]]
						}
						set ::${section}::${name} $value
						incr loaded
					}
				}
			}
			if { $loaded } {
				 if { $verbose } { puts "$script: $loaded configuration variable[expr $loaded>1?{s}:{}] loaded." }
			} else {
				if { $verbose } { puts "$script: no configuration variables loaded." }
			}
		} else {
			if { $verbose } { puts "$script: Configuration file not found: $conf_file" }
		}
		return $loaded
	}

	# trims comment tags and spaces from a given string
	proc DropNoise { string {comment_tags {\# //}} } {
		foreach tag $comment_tags {
			set pos [string first $tag $string]
			if { $pos >= 0 } {
				set string [string range $string 0 [expr {$pos-1}]]
			}
		}
		return [string trim $string]
	}

	# return a list of lists organized by section with key/value pairs
	proc ReadConf { file } {
		if { ![file exists $file] } { return }
		set conf {}
		set section {}
		set data {}
		set hconfig [open $file]
		while { [gets $hconfig line] >= 0 } {
			set line [DropNoise $line]
			if { [string index $line 0] == "\[" } {
				if { [llength $data] } { lappend conf $section $data }
				set data {}
				set section [lindex [split $line {[]}] 1]
			} else {
				set line [split $line "="]
				set key [string trim [lindex $line 0]]
				if { [string is false $key] } { continue }
				set value [string trim [lindex $line 1]]
				if { [string index $value 0] == "\"" } {
					set value [string trim [lindex [split $value "\""] 1]]
				}
				lappend data $key $value
			}
		}
		close $hconfig
		if { [llength $data] } { lappend conf $section $data }
		return $conf
	}
}


# proc stuff
namespace eval ::Custom {

	variable BasicCommands {after append array auto_execok auto_import auto_load auto_load_index auto_qualify\
		binary break case catch cd clock close concat continue encoding eof error eval\
		exec exit expr fblocked fconfigure fcopy file fileevent flush for foreach format\
		gets glob global history if incr info interp join lappend lindex linsert list\
		llength load lrange lreplace lsearch lset lsort namespace open package pid proc\
		puts pwd read regexp regsub rename return scan seek set socket source split string\
		subst switch tclLog tell time trace unknown unset update uplevel upvar variable vwait while}

	# returns a boolean depending if the given procedure exists and if the
	# optional code is not already defined in it
	proc CheckProc { proc_name {code ""} } {
		if { [info procs "::$proc_name"] == "" } {
			uplevel ::Custom::Error \{"$proc_name is not defined or loaded too late"\}
			return 0
		} elseif { [string first $code [info body "::$proc_name"]] >= 0 } {
			uplevel ::Custom::Error \{"Redundant \"$code\" code in $proc_name"\}
			return 0
		}
		return 1
	}

	# adds the given code to the beginning of a procedure
	proc HookProc { proc_name body {code_to_check ""} args } {
		set ns [uplevel namespace current]
		if { [info commands ${ns}::${proc_name}] != "" } {
			set proc_name ::[string trim ${ns}::${proc_name} :]
		}
		if { ![uplevel ::Custom::CheckProc \{$proc_name\} \{$code_to_check\}] } { return 0 }

		set args ""
		foreach arg [info args "::$proc_name"] {
			if { [info default "::$proc_name" $arg def] } { lappend arg $def }
			lappend args $arg
		}

		set name "[file root [file tail [info script]]] ($ns)"
		set body "# START - Added by $name\n\t[string trim $body]\n# END - Added by $name\n"
		set proc_body [string trim [info body ::$proc_name]]

		if { [string match -nocase "*Compiled -- no source code available*" $proc_body] } {
			# can't hook to tbc, use ChainCmd instead
			puts "HookProc:: $proc_name is compiled, using ChainCmd."
			uplevel ::Custom::ChainCmd \{::$proc_name\} \{$body\} before
			return 2
		} else {
			set traces [trace info execution "::$proc_name"]
			eval "proc ::$proc_name \{ $args \} \{\n$body\n$proc_body\n\}"
			foreach { trace } $traces { trace add execution "::$proc_name" [lindex $trace 0] [lindex $trace 1] }
			return 1
		}
	}

	# adds the given code to the end of a procedure
	proc HookProcAfter { proc_name body {code_to_check ""} args } {
		set ns [uplevel namespace current]
		if { [info commands ${ns}::${proc_name}] != "" } {
			set proc_name ::[string trim ${ns}::${proc_name} :]
		}
		if { ![uplevel ::Custom::CheckProc \{$proc_name\} \{$code_to_check\}] } { return 0 }

		set args ""
		foreach arg [info args "::$proc_name"] {
			if { [info default "::$proc_name" $arg def] } { lappend arg $def }
			lappend args $arg
		}

		set name "[file root [file tail [info script]]] ($ns)"
		set body "# START - Added by $name\n\t[string trim $body]\n# END - Added by $name\n"
		set proc_body [string trim [info body ::$proc_name]]

		if { [string match -nocase "*Compiled -- no source code available*" $proc_body] } {
			# can't hook to tbc, use ChainCmd instead
			puts "HookProcAfter: $proc_name is compiled, using ChainCmd."
			uplevel ::Custom::ChainCmd \{::$proc_name\} \{$body\} after
			return 2
		} else {
			set traces [trace info execution "::$proc_name"]
			eval "proc ::$proc_name \{ $args \} \{\n$proc_body\n$body\n\}"
			foreach { trace } $traces { trace add execution "::$proc_name" [lindex $trace 0] [lindex $trace 1] }
			return 1
		}
	}

	# executes code before or after a command or procedure, returning the
	# command or procedure value if ran after
	proc ChainCmd { cmd_name body {position "after"} } {
		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		set args ""
		set args_set ""

		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}

		if { [lindex $args_set end] == {$args} } {
			set needs_eval 1
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		} else {
			set needs_eval 0
			set args_set [join $args_set]
		}

		set body [string trim $body]

		set i 1
		while { [info commands [set newname "::${cmd_name}_ChainCmd$i"]] != "" } { incr i }
		set newname ::[string trim $newname :]
		rename "::$cmd_name" "$newname"

		if { $needs_eval } {
			if { $position == "after" } {
				set exec "set return \[eval $newname $args_set\]\n$body"
			} else {
				set exec "$body\neval $newname $args_set"
			}
		} else {
			if { $position == "after" } {
				set exec "set return \[$newname $args_set\]\n$body"
			} else {
				set exec "$body\n$newname $args_set"
			}
		}

		set traces [trace info execution "::$cmd_name"]
		eval "proc ::$cmd_name \{ $args \} \{\n$exec\n\}"
		foreach { trace } $traces { trace add execution "::$cmd_name" [lindex $trace 0] [lindex $trace 1] }
		return 1
	}

	# traces a command or procedure execution and arguments and returns its return value
	variable TraceCmd_indent 0
	proc TraceCmd { cmd_name {verbose 1} {out stdout} } {
		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		if { [info commands [set newname ::[string trim "${cmd_name}_TraceCmd" :]]] != "" } { return 0 }
		set args ""
		set args_set ""
		set args_disp ""
		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
			lappend args_disp "args = $$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				lappend args_disp "$arg = $$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}

		if { [lindex $args_set end] == {$args} } {
			set eval "eval"
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		} else {
			set eval ""
			set args_set [join $args_set]
		}

		set args_disp [join $args_disp ", "]
		rename "::$cmd_name" "$newname"
		eval "proc ::$cmd_name \{ $args \} \{
			puts $out \"Trace: \[string repeat \{ \} \$::Custom::TraceCmd_indent\]$cmd_name $args_disp\"
			incr ::Custom::TraceCmd_indent 2
			set return \[$eval $newname $args_set\]
			incr ::Custom::TraceCmd_indent -2
			if { \$return != \"\" } { puts $out \"Trace: \[string repeat \{ \} \$::Custom::TraceCmd_indent\]<RETURN> $cmd_name = \$return\" }
			return \$return
		\}"
		if { $verbose } { puts $out "Trace: tracing $cmd_name $args_set" }
		return 1
	}

	# benchmarks a command or procedure execution
	proc BenchCmd { args } {
		set milliseconds 0
		set verbose 1
		set out "stdout"

		if { ![string first [lindex $args 0] "-milliseconds"] } {
			set milliseconds 1
			set args [lrange $args 1 end]
		}

		set cmd_name [lindex $args 0]
		if { [string is digit -strict [lindex $args 1]] } {
			set verbose [lindex $args 1]
		}
		if { [lindex $args 2] != "" } {
			set out [lindex $args 2]
		}

		if { [lsearch $::Custom::BasicCommands $cmd_name] >= 0 } { return 0 }
		if { [info commands ::$cmd_name] == "" } { return 0 }
		if { [info commands [set newname ::[string trim "${cmd_name}_BenchCmd" :]]] != "" } { return 0 }
		set args ""
		set args_set ""
		if { [info procs "::$cmd_name"] == "" } {
			lappend args "args"
			lappend args_set "\$args"
		} else {
			foreach arg [info args "::$cmd_name"] {
				lappend args_set "\$$arg"
				if { [info default "::$cmd_name" $arg def] } { lappend arg $def }
				lappend args $arg
			}
		}

		if { [lindex $args_set end] == {$args} } {
			set eval "eval"
			set args_set [concat [lrange $args_set 0 end-1] "\$args"]
		} else {
			set eval ""
			set args_set [join $args_set]
		}

		set output "puts $out \"BenchCmd $cmd_name: time=\$time\, total_time=\$total_time, total_calls=\$total_calls, average=\$average\""
		rename "::$cmd_name" "$newname"
		eval "proc ::$cmd_name \{ $args \} \{
			set start \[clock clicks [expr {$milliseconds ? "-milliseconds" : ""}]\]
			set return \[$eval $newname $args_set\]
			set end \[clock clicks [expr {$milliseconds ? "-milliseconds" : ""}]\]
			set time \[expr \{\$end-\$start\}\]
			::Custom::SetBenchData $cmd_name \$time[expr {$verbose ? " stdout" : ""}]
			return \$return
		\}"
		if { $verbose } { puts $out "Bench: benching $cmd_name $args_set" }
		return 1
	}

	# returns the data gathered by ::Custom::BenchCmd
	proc GetBenchData { {sort_index 0} {out stdout} } {
		variable BenchCmd
		set bench_data {}
		foreach {proc data} [array get BenchCmd] {
			if { [lindex $data 1] } {
				set average [expr {round(double([lindex $data 0])/[lindex $data 1])}]
			} else { set average 0 }
			lappend bench_data [concat $proc $data $average]
		}
		set disp ""
		if { $sort_index } {
			set data [lsort -integer -decreasing -index $sort_index $bench_data]
		} else {
			set data [lsort -index $sort_index $bench_data]
		}
		set total 0
		foreach row $data {
			lappend disp $row
			incr total [lindex $row 1]
		}
		lappend disp "total: [expr $total/1000000.]"
		set disp [join $disp \n]
		puts $out $disp
		return $disp
	}

	# should not be used directly
	proc SetBenchData { cmd_name time {out ""} } {
		if { ![info exists ::Custom::BenchCmd($cmd_name)] } { set ::Custom::BenchCmd($cmd_name) [list 0 0] }
		set total_time [lindex $::Custom::BenchCmd($cmd_name) 0]
		set total_calls [lindex $::Custom::BenchCmd($cmd_name) 1]
		incr total_time $time
		incr total_calls
		set ::Custom::BenchCmd($cmd_name) [list $total_time $total_calls]
		if { $out != "" } {
			set average [expr {round(double($total_time)/$total_calls)}]
			puts $out "Bench $cmd_name: time=$time, total_time=$total_time, total_calls=$total_calls, average=$average"
		}
	}
}


# online players
namespace eval ::Custom {
	variable OnlinePlayers
	variable OnlinePlayerUpdate 8
	variable OnlinePlayersCheck 0
	variable OnlinePlayerFieldsNum 6

	# get online info for a single player
	proc IsOnline { player {force_update 0} } {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set name [string tolower [::GetName $player]]
		set time [ReadOnline $force_update]
		expr {[info exists OnlinePlayers($name)] && $time-[lindex $OnlinePlayers($name) 6] <= $OnlinePlayerUpdate}
	}

	# get online info for a single player from his name
	proc IsOnlineByName { player_name {force_update 0} } {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set name [string tolower $player_name]
		set time [ReadOnline $force_update]
		expr {[info exists OnlinePlayers($name)] && $time-[lindex $OnlinePlayers($name) 6] <= $OnlinePlayerUpdate}
	}

	# return data from all online players { name race class level map zone } ...
	proc GetAllOnlineData {} {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set ret {}
		set time [ReadOnline]

		foreach { name data } [array get OnlinePlayers] {
			if { $time - [lindex $data 6] <= $OnlinePlayerUpdate } {
				lappend ret [lrange $data 0 end-1]
			}
		}

		return $ret
	}

	# count online players in a map
	proc CountInMap { {map *} {side *} } {
		set count 0

		# go through each entry in stat.xml
		foreach { player_name player_race player_class player_level player_map player_zone } [join [::Custom::GetAllOnlineData]] {
			if { [string match $map $player_map] && [string match $side [::Custom::GetPlayerSideByRace $player_race]] } {
				incr count
			}
		}

		return $count
	}

	# fills the information variable with data about online players
	# use before either a single or multiple calls to ::Custom::GetOnlineData
	proc ReadOnline { {force_update 0} } {
		variable OnlinePlayers
		variable OnlinePlayersCheck
		variable OnlinePlayerUpdate
		variable OnlinePlayerFieldsNum
		set time [clock seconds]

		if { $time-$OnlinePlayersCheck > $OnlinePlayerUpdate || $force_update } {
			set field_index 0
			set handle [open "www/stat.xml"]
			while { [gets $handle line] >= 0 } {
				if { [string match -nocase "*<name>*" $line] } {
					set name [lindex [split $line "<>"] 2]
					if { $name != "" } {
						set pname [string tolower $name]
						if { [info exists OnlinePlayers($pname)] } {
							lset OnlinePlayers($pname) 6 $time
						} else {
							set OnlinePlayers($pname) [list $name 0 0 0 0 0 $time]
						}
						set field_index 1
					}
				} elseif { $field_index } {
					if { $field_index < $OnlinePlayerFieldsNum } {
						lset OnlinePlayers($pname) $field_index [lindex [split $line "<>"] 2]
						incr field_index
					} else {
						set field_index 0
					}
				}
			}
			close $handle
			set OnlinePlayersCheck $time
		}
		return $time
	}

	# gathers the information stored in stats.xml for a given player name
	# ::Custom::ReadOnline must be called before any number of calls to this one
	# information returned: name race class level map zone
	proc GetOnlineData { player_name } {
		variable OnlinePlayers
		variable OnlinePlayerUpdate
		set player_name [string tolower $player_name]

		if { [info exists OnlinePlayers($player_name)] } {
			set data $OnlinePlayers($player_name)
			if { [clock seconds]-[lindex $data 6] <= $OnlinePlayerUpdate } {
				return [lrange $data 0 end-1]
			}
		}

		return 0
	}
}


# persistent arrays using SQLdb
namespace eval ::Custom {

	# ::Custom::DbArray <option> <array_name> [arg]
	proc DbArray { option array {arg "*"} } {
		if { [string range $array 0 1] != "::" } {
			set ns [string trim [uplevel namespace current] :]
			set array ${ns}::${array}
		}
		set array [string trim $array :]

		switch -- [string tolower $option] {
			"get" {
				::Custom::DbArrayGet $array $arg
			}
			"set" {
				::Custom::DbArraySet $array $arg
			}
			"unset" {
				::Custom::DbArrayUnset $array $arg
			}
			"names" {
				::Custom::DbArrayNames $array $arg
			}
			"size" {
				::Custom::DbArraySize $array
			}
		}
	}

	if { [catch { package require "SQLdb" }] } {

		#::Custom::Error "DbArray requires SQLdb"

		proc DbArrayValue { array key } {
			if { [string range $array 0 1] != "::" } {
				set ns [string trim [uplevel namespace current] :]
				set array ${ns}::${array}
			}
			set array [string trim $array :]

			return $array($key)
		}

		# normal arrays if no SQLdb
		proc DbArrayGet { array {pattern *} } { array get $array $pattern }
		proc DbArraySet { array list } { array set $array $list }
		proc DbArrayUnset { array {pattern *} } { array unset $array $pattern }
		proc DbArrayNames { array {pattern *} } { array names $array $pattern }
		proc DbArraySize { array } { array size $array }

	} else {
		# arrays using SQLdb

		if { ![info exists ::SQLdb::nghandle] } {
			set ::SQLdb::nghandle [::SQLdb::openSQLdb]
		}
		variable nghandle $::SQLdb::nghandle

		if { ![::SQLdb::existsSQLdb $nghandle `db_arrays`] } {
			::SQLdb::querySQLdb $nghandle "CREATE TABLE `db_arrays` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `array` VARCHAR(255) NOT NULL DEFAULT '', `key` VARCHAR(255) NOT NULL DEFAULT '', `value` TEXT)"
			::SQLdb::querySQLdb $nghandle "CREATE UNIQUE INDEX `db_arrays_index` ON `db_arrays` (`array`, `key`)"
		}

		proc DbArrayValue { array key } {
			variable nghandle
			if { [string range $array 0 1] != "::" } {
				set ns [string trim [uplevel namespace current] :]
				set array ${ns}::${array}
			}
			set array [string trim $array :]

			::SQLdb::firstcellSQLdb $nghandle "SELECT `value` FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` = '[::SQLdb::canonizeSQLdb $key]')"
		}

		proc DbArrayGet { array {pattern *} } {
			variable nghandle
			set pattern [string map {* % ? _ % \\% _ \\_} $pattern]
			join [::SQLdb::querySQLdb $nghandle "SELECT `key`, `value` FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` LIKE '[::SQLdb::canonizeSQLdb $pattern]')"]
		}

		proc DbArraySet { array list } {
			variable nghandle
			foreach { key value } $list {
				if { [::SQLdb::booleanSQLdb $nghandle "SELECT `key` FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` = '[::SQLdb::canonizeSQLdb $key]') LIMIT 1"] } {
					::SQLdb::querySQLdb $nghandle "UPDATE `db_arrays` SET `value` = '[::SQLdb::canonizeSQLdb $value]' WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` = '[::SQLdb::canonizeSQLdb $key]')"
				} else {
					::SQLdb::querySQLdb $nghandle "INSERT INTO `db_arrays` (`array`, `key`, `value`) VALUES('[::SQLdb::canonizeSQLdb $array]', '[::SQLdb::canonizeSQLdb $key]', '[::SQLdb::canonizeSQLdb $value]')"
				}
			}
		}

		proc DbArrayUnset { array {pattern *} } {
			variable nghandle
			set pattern [string map {* % ? _ % \\% _ \\_} $pattern]
			::SQLdb::querySQLdb $nghandle "DELETE FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` LIKE '[::SQLdb::canonizeSQLdb $pattern]')"
		}

		proc DbArrayNames { array {pattern *} } {
			variable nghandle
			set pattern [string map {* % ? _ % \\% _ \\_} $pattern]
			join [::SQLdb::querySQLdb $nghandle "SELECT `key` FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]' AND `key` LIKE '[::SQLdb::canonizeSQLdb $pattern]')"]
		}

		proc DbArraySize { array } {
			variable nghandle
			::SQLdb::firstcellSQLdb $nghandle "SELECT count(*) FROM `db_arrays` WHERE (`array` = '[::SQLdb::canonizeSQLdb $array]')"
		}
	}
}


# color/sound stuff
namespace eval ::Custom {
	namespace eval Color {
		variable AQUA "00ffff"
		variable BLACK "000000"
		variable BLUE "0000ff"
		variable FUCHSIA "ff00ff"
		variable GRAY "808080"
		variable GREEN "008000"
		variable LIME "00ff00"
		variable MAROON "800000"
		variable NAVY "000080"
		variable OLIVE "808000"
		variable PURPLE "800080"
		variable RED "ff0000"
		variable SILVER "c0c0c0"
		variable TEAL "008080"
		variable WHITE "ffffff"
		variable YELLOW "ffff00"
	}

	# returns a colored string suitable to output to the client console
	proc Color { text {color white} } {
		set color_var ::Custom::Color::[string toupper $color]
		if { [info exists $color_var] } {
			set color [set $color_var]
		}
		return "|cff$color$text|r"
	}

	# returns a predefined sound suitable to play on the client
	proc Sound { {sound levelup} } {
		return "|s$sound|r"
	}

	# returns a color striped string
	proc UnColor { text } {
		regsub -all {\|s[^|]*\|r} $text {} text
		regsub -all {\|c\w\w\w\w\w\w\w\w} $text {} text
		regsub -all {\|r} $text {} text
		return $text
	}
}


# compatibility stuff
if { [::Custom::GetScriptVersion "StartTCL"] < "0.9.0" } {

	if { [namespace exists "StartTCL"] } {
		namespace eval ::Custom {
			set level "n"
			set handle [open [info script]]
			set line [gets $handle]
			close $handle
			set line [string trim [string trim [string trim [string trim $line \#]] \#]]
			if { [regexp -nocase {start-?tcl *:} $line] } {
				set level [string tolower [string trim [lindex [split $line :] 1]]]
			}
			if { $level < "c" } {
				::Custom::Error "Custom.tcl should be loaded at level \"c\" with StartTCL before v0.9.0"
			}
			unset level
			unset handle
			unset line
		}
	}


	# dummy definitions for old versions of StartTCL
	namespace eval ::StartTCL {
		if { ![info exists VERSION] } {
			variable VERSION 0
		}
		proc Provide { args } {}
		proc Require { args } {}
	}


	# this allows adding commands from scripts (Custom::AddCommand command proc plevel)
	if { [namespace exists "::WoWEmu"] } {
		namespace eval ::WoWEmu {

			variable Commands

			if { [info procs "Command"] == "" } {
				::Custom::Error "Original Commands.tcl loaded too late!"
			} elseif { [info procs "Command_Original"] == "" } {
				rename Command Command_Original
			}

			proc Command { args } {
				set sargs [string map {\} {} \{ {} \] {} \[ {} \$ {} \\ {}} $args]
				set player [lindex $sargs 0]
				set command [lindex $sargs 1]
				set cargs [lrange $sargs 2 end]
				if { [set proc [GetCommandProc [string tolower $command] [::GetPlevel $player]]] != "" } { $proc $player $cargs
				} else { Command_Original $args }
			}


			proc GetCommandProc { command plevel } {
				if { [info exists ::WoWEmu::Commands($command)] } {
					if { $plevel < [lindex $::WoWEmu::Commands($command) 1] } { return WrongPlevel }
					return [lindex $::WoWEmu::Commands($command) 0]
				}
			}

			proc WrongPlevel { {player 0} {cargs ""} } { return "You are not allowed to use this command." }
		}

		# adding scripts for spell with script effect
		set proc "::SpellEffects::SPELL_EFFECT_SCRIPT_EFFECT"
		if { [info procs $proc] != "" } {
			set hook {
				variable ScriptEffects
				if { [info exists ScriptEffects($spellid)] } {
					foreach proc $ScriptEffects($spellid) {
						$proc $to $from $spellid
					}
				}
			}
			if { [string first [string trim $hook] [info body $proc]] < 0 } {
				::Custom::HookProc $proc $hook
			}
			unset hook
		}
		unset proc

		# add setting/clear the "IsDead" qflag if it is missing. needed for Custom::PlayerIsAlive
		foreach { proc code } {::WoWEmu::OnPlayerDeath {SetQFlag $player IsDead} ::WoWEmu::OnPlayerResurrect {ClearQFlag $player IsDead}} {
			if { [info procs $proc] != "" } {
				if { [string first $code [info body $proc]] < 0 } { ::Custom::HookProc $proc $code $code }
			} else {
				::Custom::Error "$proc is not defined!"
			}
		}

	} else {
		namespace eval ::WoWEmu {
			variable NO_WOWEMU 1
		}
	}
}


# initialization stuff
namespace eval ::Custom {
	if { $DEBUG } {
		foreach proc [lsort [info procs]] {
			::Custom::TraceCmd [namespace current]::$proc 0
		}
	}

	if { [namespace exists ::WoWEmu::Commands] } {
		proc ::WoWEmu::Commands::Log { command player cargs } {
			set selection [::GetSelection $player]
			if { $selection != $player && [::GetObjectType $selection] == 4 && [::GetPlevel $selection] < 2 } {
				set gm_name [::GetName $player]
				set player_name [::GetName $selection]
				set pos [::Custom::RoundPos [::GetPos $player]]
				::Custom::Log "GM=$gm_name player=$player_name command=\"[string trim "$command $cargs"]\" pos=\[$pos\]" "logs/gmcommands.log"
			}
		}
	}

	if { ![file exists "logs"] } {
		proc Error { msg } {
			set script [info script]
			if { $script == "" } {
				set script [namespace tail [uplevel namespace current]]
			}
			puts stderr "\n ERROR $script: $msg\n"
		}
	}

	::StartTCL::Provide

	# duplicate loading detection
	if { [info exists Loaded] } { ::Custom::Error "Duplicated loading detected" }
	variable Loaded 1
}


namespace eval ::Texts {

	variable LANGUAGE "default"
	variable TEXTS_DIR "scripts/conf/texts"

	variable USE_CONF 1
	variable VERSION 1.30

	proc GetEx { lang ns text args } {
		variable Texts
		if { [info exists Texts($lang,$ns,$text)] } {
			set text $Texts($lang,$ns,$text)
		} else {
			set lang [lindex [split $lang "_"] 0]
			if { ![info exists Texts($lang,$ns,$text)] } { set lang "en" }
			if { [info exists Texts($lang,$ns,$text)] } { set text $Texts($lang,$ns,$text) }
		}
		if { [llength $args] } { eval [list format $text] $args } else { set text }
	}

	eval "proc GetNs \{ ns text args \} \{
		set lang \$::Texts::LANGUAGE
		set ns ::\[string trim \$ns :\]
		[info body GetEx]
	\}"

	eval "proc Get \{ text args \} \{
		set lang \$::Texts::LANGUAGE
		set ns \[uplevel namespace current\]
		[info body GetEx]
	\}"

	proc GetAll {} {
		set lang $::Texts::LANGUAGE
		set ns [uplevel namespace current]
		set texts {}
		foreach { key translate } [array get ::Texts::Texts $lang,$ns,*] {
			set text [lindex [split $key ,] 2]
			lappend texts $text $translate
		}
		return $texts
	}

	proc Exists { {text "*"} } {
		set ns [uplevel namespace current]
		expr {[llength [array names ::Texts::Texts *,$ns,$text]] > 0}
	}

	proc Unset { {text "*"} } {
		set ns [uplevel namespace current]
		array unset ::Texts::Texts *,$ns,$text
	}

	proc Locale { {lang ""} } {
		if { $lang == "" } { set ::Texts::LANGUAGE } else { set ::Texts::LANGUAGE $lang }
	}

	proc Set { args } {
		if { [llength $args] < 3 } { return }
		variable Texts
		set lang [lindex $args 0]
		set text [lindex $args 1]
		set translate [join [lrange $args 2 end]]
		set ns [uplevel namespace current]
		if { [info exists Texts($lang,$ns,$text)] } {
			::Custom::Error "$lang ${ns}::${text} defined again."
		}
		set Texts($lang,$ns,$text) $translate
	}

	proc Clear {} { array unset ::Texts::Texts }

	proc Command { player cargs } { Locale $cargs }

	Clear
	if { $USE_CONF } { Custom::LoadConf }
	if { [string match -nocase "default" $LANGUAGE] } {
		if { [info exists ::LANG] } { set LANGUAGE $::LANG }
		if { [string match -nocase "default" $LANGUAGE] } { set LANGUAGE "en" }
	}

	namespace export *

	::StartTCL::Provide
}

namespace eval ::Text { catch { namespace import ::Texts::* } }

if { ![info exists ::WoWEmu::NO_WOWEMU] } {
	# load the text files
	if { $::Texts::TEXTS_DIR != "" } {
		foreach textfile [glob -nocomplain "$::Texts::TEXTS_DIR/*.txt" "$::Texts::TEXTS_DIR/*.tcl"] {
			if { $DEBUG } {
				::Custom::Source $textfile
			} else {
				if { [catch { ::Custom::Source $textfile } err] } {
					::Custom::Error $err
				}
			}
		}
		unset textfile
	}
	Custom::AddCommand "texts" "Texts::Command" 4
}


# do command
proc do { body while condition } {
	if { $while ne "while" } {
		error "required word missing"
	}

	set conditionCmd [list expr $condition]

	while { 1 } {
		uplevel 1 $body
		if { ![uplevel 1 $conditionCmd] } {
			break
		}
	}
}
