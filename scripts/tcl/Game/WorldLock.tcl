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
# Name:		WorldLock.tcl
#
# Version:	0.0.7
#
# Date:		2006-03-28
#
# Description:	world.save (Un)Locker
#
# Authors:	Lazarus Long <lazarus.long@bigfoot.com>
#		Spirit <thehiddenspirit@hotmail.com>
#
# Changelog:
#
# v0.0.7 (2006-03-28) - The "standard localization" version
#			Localization strings are no more using variables,
#			so they have a less weird look. Translating should
#			be easier.
#
# v0.0.6 (2006-03-27) -	The "give me a choice" version.
#			Broadcast turned into a configuration.
#			Added ".ws info" command and localization support.
#
# v0.0.5 (2006-03-26) -	The "radio it out" version.
#			Implemented a broadcast as a return from a successfull
#			lock or unlock.
#
# v0.0.4 (2006-03-23) -	The "change the name of your space" version.
#			Corrected the namespace change and init sequence from
#			the errors introduced last change (oops).
#
# v0.0.3 (2006-03-21) -	The "lets get custom" version.
#			Converted to ::Custom namespace for integration with
#			StartTCL, Changed copyright format and authorship.
#
# v0.0.2 (2006-03-02) -	The "pretty print" version.
#			Added coloring to output and StartTCL information.
#
# v0.0.1 (2006-02-03) -	The "lock'em up Johnny" version.
#			Created a procedure to automatically lock the
#			"world.save" to avoid delays when saving.
#
#


#
#	StartTCL initialization
#
# StartTCL: z
#


#
#	namespace eval ::WorldLock
#
# WorldLock namespace and variable definitions
#
namespace eval ::WorldLock {
	variable VERSION "0.0.7"
	variable LOCK_ON_START 1
	variable BROADCAST 1
	variable VERBOSE 0

	variable use_conf_file 1
	variable gm_level 6

	variable file "saves/world.save"
	variable handle
	variable ro 1
	variable rw 0
	variable mode "r"

	variable header "[ Custom::Color "World Locking System (v" blue ][ Custom::Color $VERSION lime ][ Custom::Color ) blue ]"

	variable l_msg01 "[ Custom::Color "You are not allowed to use this command!" red ]"
	variable l_msg02 "The \"[ Custom::Color "world.save" white ]\" is already [ Custom::Color "locked" red ]."
	variable l_msg03 "The \"[ Custom::Color "world.save" white ]\" is already [ Custom::Color "unlocked" lime ]."
	variable l_msg04 "The \"[ Custom::Color "world.save" white ]\" is [ Custom::Color "locked" red ]."
	variable l_msg05 "The \"[ Custom::Color "world.save" white ]\" is [ Custom::Color "unlocked" lime ]."
	variable l_msg06 "Usage:   [ Custom::Color ".ws \[ lock \| exclusive \| unlock \| shared \| info \| help \]" white ]"
	variable l_msg07 "The \"world.save\" file doesn't exist!"
}


#
#	proc ::WorldLock::exclusive { player cargs }
#
# Local procedure to lock the world.save to exclusive readonly access
#
proc ::WorldLock::exclusive { {player 0} } {
	variable BROADCAST
	variable VERBOSE
	variable gm_level
	variable file
	variable handle
	variable ro
	variable mode

	if { ( $player != 0 ) && ( [ ::GetPlevel $player ] < $gm_level ) } {
		return $WorldLock::l_msg01
	}

	if { [ info exists handle ] } {
		return $WorldLock::l_msg02
	}

	if { ! [ file exists $file ] } {
		return $WorldLock::l_msg07
	}

	file attributes $file -readonly $ro
	set handle [ open $file $mode ]

	if { $VERBOSE } {
		puts "[ Custom::LogPrefix ][ Custom::UnColor $WorldLock::l_msg04 ]"
	}

	if { $player && $BROADCAST } {
		return [ ::WoWEmu::Commands::broadcast $player [ format "|r$WorldLock::l_msg04" [ ::GetName $player ] ] ]
	}
}


#
#	proc ::WorldLock::shared { player cargs }
#
# Local procedure to unlock the world.save from exclusive readonly access
#
proc ::WorldLock::shared { {player 0} } {
	variable BROADCAST
	variable VERBOSE
	variable gm_level
	variable file
	variable handle
	variable rw

	if { ( $player != 0 ) && ( [ ::GetPlevel $player ] < $gm_level ) } {
		return $WorldLock::l_msg01
	}

	if { ! [ info exists handle ] } {
		return $WorldLock::l_msg03
	}

	close $handle
	file attributes $file -readonly $rw
	unset handle

	if { $VERBOSE } {
		puts "[ Custom::LogPrefix ][ Custom::UnColor $WorldLock::l_msg05 ]"
	}

	if { $player && $BROADCAST } {
		return [ ::WoWEmu::Commands::broadcast $player [ format "|r$WorldLock::l_msg05" [ ::GetName $player ] ] ]
	}
}


#
# Process the "ws" command
#
if { [ string length [ info procs "::Custom::AddCommand" ] ] } {
	proc ::WorldLock::ws { player cargs } {
		switch [ string tolower [ lindex $cargs 0 ] ] {
			"exclusive" -
			"lock" {
				return [ ::WorldLock::exclusive $player ]
			}
			"shared" -
			"unlock" {
				return [ ::WorldLock::shared $player ]
			}
			"info" {
				return [ expr { [ info exists ::WorldLock::handle ] ? $::WorldLock::l_msg04 : $::WorldLock::l_msg05 } ]
			}
			default {
				return "$::WorldLock::header\n\n$::WorldLock::l_msg06"
			}
		}
	}

	::Custom::AddCommand "ws" "::WorldLock::ws" $::WorldLock::gm_level
} else {
	rename ::WoWEmu::Command ::WoWEmu::Command_ws

	proc ::WoWEmu::Command { args } {
		set args [ string map {\} {} \{ {} \] {} \[ {} \$ {} \\ {}} $args ]
		set player [ lindex $largs 0 ]
		set cargs [ lrange $largs 2 end ]

		switch [ string tolower [ lindex $largs 1 ] ] {
			"ws" {
				switch [ string tolower [ lindex $cargs 0 ] ] {
					"exclusive" -
					"lock" {
						return [ ::WorldLock::exclusive $player ]
					}
					"shared" -
					"unlock" {
						return [ ::WorldLock::shared $player ]
					}
					"info" {
						return [ expr { [ info exists ::WorldLock::handle ] ? $::WorldLock::l_msg04 : $::WorldLock::l_msg05 } ]
					}
					default {
						return "$::WorldLock::header\n\n$::WorldLock::l_msg06"
					}
				}
			}
			default {
				return [ ::WoWEmu::Command_ws $args ]
			}
		}

		return "Bad command"
	}
}


#
#	startup time command execution
#
# Load configuration and localization, lock "world.save" at server start
#
namespace eval ::WorldLock {
	::StartTCL::Provide

	if { $use_conf_file && [ info procs "::Custom::LoadConf" ] != "" } {
		if { [ info exists ::StartTCL::conf_file ] } {
			::Custom::LoadConf "WorldLock" $::StartTCL::conf_file
		} else {
			::Custom::LoadConf
		}
	}

	# load localization if there is one
	foreach { text translate } [ ::Texts::GetAll ] {
		variable $text $translate
	}

	if { $LOCK_ON_START } {
		::WorldLock::exclusive
	} else {
		file attributes $file -readonly $rw
	}
}

