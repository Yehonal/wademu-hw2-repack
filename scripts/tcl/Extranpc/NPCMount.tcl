# StartTCL: n
#
#
# This file is part of the StartTCL Startup System
#
# StartTCL is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
# StartTCL is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# StartTCL is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# StartTCL is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
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
# Name:		Mount.tcl
#
# Version:	0.3.1
#
# Date:		2006-09-04
#
# Description: NPC Mounts using waypoints.
#
# Authors:	Spirit <thehiddenspirit@hotmail.com>
#		Lazarus Long <lazarus.long@bigfoot.com>
#
#
# Changelog:
# v0.3.1 (2006-09-04) - The "peon and spirit healer" version
#			Added Peon sleeping and Spirit Healer ghost into
#			MountArray thanks to Neverdie.
#
# v0.3.0 (2006-04-26) - The "mount command" version
#			Mount command that mounts NPCs by scanning through world
#			objects. Thanks to mLaPL for the idea.
#
# v0.2.0 (2006-04-13) - The "no cleanup needed" version
#			Waypoint keys also added to spawned NPCs on
#			installation.
#
# v0.1.0 (2006-04-12) - The "let's try it" version
#			Implemented the mount method described by smartwork.
#
#
# Instructions:
#
# New installation:
# 1) Make a backup of world.save and waypoints.scp.
# 2) Copy this file to the tcl directory.
# 3) If the world.save file is locked, unlock it with ".ws unlock".
# 4) Start the server or reload the scripts with ".retcl".
# 5) Lock the world.save with ".ws lock".
# 6) Reboot the server.
#
# Upgrading / Adding NPC Mounts:
# 1) Spawn new NPCs and/or edit MountArray.
# 2) Delete waypoints_mounts.scp.
# 3) If the world.save file is locked, unlock it with ".ws unlock".
# 4) Start the server or reload the scripts with ".retcl".
# 5) Lock the world.save with ".ws lock".
# 6) Reboot the server.
#
#


namespace eval ::Mount {

	variable VERSION 0.3.1

	variable AUTO_INSTALL 1
	variable AUTO_SCAN 1
	variable POINT_START 20000

	variable USE_CONF 1
	variable WAY_FILE "scripts/waypoints_mounts.scp"
	variable WORLD_FILE "saves/world.save"
	variable MIN_CUSTOM 2.07

	variable MountArray

	# creature entry -> mount spell
	array set MountArray {
		464 16083
		466 16083
		469 458
		1121 16081
		1279 6898
		1515 5784
		2149 16056
		2151 16056
		2612 6648
		2738 6648
		3836 6898
		4752 6653
		5682 458
		5724 5784
		5725 5784
		5797 16055
		5798 16056
		5799 16055
		5800 16083
		6388 17465
		6390 17465
		10604 16055
		10605 22723
		10606 16055
		10676 578
		10682 6654
		12790 6898
		12864 16080
		12996 6898
		13577 6898
		14376 578
		14377 23251
		14378 16055
		14379 16055
		14380 16055
		15857 13819
		15862 22720

		6491 6408
		10556 17743
	}

	# mount script used in waypoints_mounts.scp
	proc Waypoint { npc } {
		variable MountArray
		set entry [::GetEntry $npc]

		if { [info exists MountArray($entry)] && ![::GetQFlag $npc Mounted] && [::CastSpell $npc $npc $MountArray($entry)] } {
			::SetQFlag $npc Mounted
		}
	}

	# create waypoints_mounts.scp, add include to waypoints.scp, patch world.save
	proc Install {} {
		variable POINT_START
		variable WORLD_FILE
		variable WAY_FILE
		variable MountArray
		variable hWorld

		set world_index -1
		set point $POINT_START

		set world [::Custom::ReadConf $WORLD_FILE]

		set hway [open $WAY_FILE w]
		puts $hway "// Waypoints for NPC Mounts by Spirit\n"
		foreach { section data } $world {
			incr world_index 2

			set spawn_index [lsearch $data "SPAWN"]
			set spawn [expr { $spawn_index < 0 ? 0 : [lindex [lindex $data [expr {$spawn_index+1}]] 0] }]

			if { [info exists MountArray($spawn)] } {
				set xyz_index [lsearch $data "XYZ"]
				if { $xyz_index < 0 } { continue }
				set pos [lrange [lindex $data [expr {$xyz_index+1}]] 0 2]
				lset pos 0 [expr {round([lindex $pos 0])}]
				lset pos 1 [expr {round([lindex $pos 1])}]
				lset pos 2 [expr {round([lindex $pos 2]+.5)}]

				set way_index [lsearch $data "WAYPOINT"]
				if { $way_index < 0 } {
					lappend data "WAYPOINT" $point
					lset world $world_index $data
				} else {
					lset world $world_index [expr {$way_index+1}] $point
				}

				set guid_index [lsearch $data "GUID"]
				set guid [expr { $guid_index < 0 ? 0 : [lindex $data [expr {$guid_index+1}]] }]

				set mount_waypoints($guid) $point

				puts $hway "// [::Custom::GetCreatureScp $spawn name]"
				puts $hway "\[point $point\]\npos=$pos\nscript=Mount::Waypoint"
				puts $hway ""
				incr point
			} else {
				set entry_index [lsearch $data "ENTRY"]
				set entry [expr { $entry_index < 0 ? 0 : [lindex $data [expr {$entry_index+1}]] }]

				if { [info exists MountArray($entry)] } {
					set link_index [lsearch $data "LINK"]
					set link [expr { $link_index < 0 ? 0 : [lindex $data [expr {$link_index+1}]] }]

					if { [info exists mount_waypoints($link)] } {
						set way_index [lsearch $data "WAYPOINT"]
						if { $way_index < 0 } {
							lappend data "WAYPOINT" $mount_waypoints($link)
							lset world $world_index $data
						} else {
							lset world $world_index [expr {$way_index+1}] $mount_waypoints($link)
						}
					}
				}
			}
		}
		close $hway

		AddInclude "scripts/waypoints.scp" $WAY_FILE

		file attributes $WORLD_FILE -readonly 0
		set hworld [open $WORLD_FILE w]
		puts $hworld "// Objects save file with NPC Mounts by Spirit\n"
		foreach { section data } $world {
			puts $hworld "\[$section\]"
			foreach { key value } $data {
				puts $hworld "$key=$value"
			}
			puts $hworld ""
		}
		close $hworld
		file attributes $WORLD_FILE -readonly 1
		set hWorld [open $WORLD_FILE]
		expr {$point-$POINT_START}
	}

	# mount NPCs by scanning through world objects
	proc Scan {} {
		variable MountArray
		set count 0
		set total [GetWorldTotal]
		for { set npc 1 } { $npc <= $total } { incr npc } {
			if { [::GetObjectType $npc] != 3 } {
				continue
			}

			set entry [::GetEntry $npc]

			if { $entry == 1 } {
				continue
			}

			if { [info exists MountArray($entry)] && ![::GetQFlag $npc Mounted] && [::CastSpell $npc $npc $MountArray($entry)] } {
				::SetQFlag $npc Mounted
				incr count
			}
		}
		return $count
	}

	# scan once (on first login)
	proc AutoScan { to from spellid } {
		Scan
		::Custom::DelSpellScript "::Mount::AutoScan" 836
	}

	# ".mount" command
	proc Command { player cargs } {
		set count [Scan]
		return "$count NPCs mounted."
	}

	# get total number of world objects
	proc GetWorldTotal {} {
		variable WORLD_FILE
		set handle [open $WORLD_FILE]
		set total 0
		while { [gets $handle line] >= 0 } {
			set line [split $line "="]
			if { ![string compare -nocase [lindex $line 0] "total"] } {
				set total [lindex $line 1]
				break
			}
		}
		close $handle
		return $total
	}

	# add include line into a file
	proc AddInclude { file include_file } {
		set include "#include $include_file"
		set content {}
		set found_include 0
		set handle [open $file]
		while { [gets $handle line] >= 0 } {
			if { [string trim $line] == $include } {
				incr found_include
				break
			}
			lappend content $line
		}
		close $handle
		if { !$found_include } {
			set count 0
			set added 0
			set handle [open $file w]
			foreach line $content {
				if { !$added && [string is ascii $line] && [string range [string trim $line] 0 1] != "//" } {
					if { !$count } { puts $handle "" }
					puts $handle $include
					if { [string trim $line] != "" } { puts $handle "" }
					set added 1
				}
				puts $handle $line
				incr count
			}
			close $handle
		}
		expr {!$found_include}
	}


	# initialization
	if { $USE_CONF } {
		::Custom::LoadConf "Mount" $::StartTCL::conf_file
	}

	if { [::Custom::GetScriptVersion "Custom"] < $MIN_CUSTOM } {
		::Custom::Error "Your Custom.tcl is too old. You need v$MIN_CUSTOM or higher."
		return
	}

	if { $AUTO_INSTALL && ![file exists $WAY_FILE] } {
		puts "\n[::Custom::LogPrefix]Installation of NPC Mounts, please wait...\n"
		set count [Install]
		puts "[::Custom::LogPrefix]$count NPC Mounts installed. Now you have to reboot.\n"
	}

	if { $AUTO_SCAN } {
		::Custom::AddSpellScript "::Mount::AutoScan" 836
	}

	::Custom::AddCommand "mount" ::Mount::Command 4
	::StartTCL::Provide
}

