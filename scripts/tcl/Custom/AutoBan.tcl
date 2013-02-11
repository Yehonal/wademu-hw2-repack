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
# Name:		AutoBan.tcl
#
# Version:	0.7.2
#
# Date:		2006-09-11
#
# Description:	Automatically bans players using cheats.
#
# Authors:	Spirit <thehiddenspirit@hotmail.com>
#		Lazarus Long <lazarus.long@bigfoot.com>
#
# Changelog:
#
# v0.7.2 (2006-09-11) - the "register cooldown only if needed" version
#			CheckCooldown is registered only for spells actually
#			having a cooldown.
#
# v0.7.1 (2006-08-28) - the "let scripts cast anything" version
#			Never ban when a spell is cast with the "::CastSpell"
#			command.
#
# v0.7.0 (2006-08-24) - the "new design" version
#			Redesign to only use spell data thanks to ideas from
#			Tha-Doctor and AceIndy. Check for usurped spells.
#
# v0.6.0 (2006-07-26) - The "check for classes and mounts" version
#			Additions from Nefelin to make sure spells are used by
#			the right classes and mounts with the right levels.
#
# v0.5.2 (2006-06-08) - The "improved compatibility" version
#			Remade the spell patch to be more compatible with spell
#			patches from BAD's team. Remove banned ip from memory
#			when using the ".-ban" command from GmTools.
#
# v0.5.1 (2006-06-06) - The "hopefully really check for instances now" version
#			Fixed error that could prevent hooking into Instance
#			Limiter.
#
# v0.5.0 (2006-05-30) - The "check for entering instances" version
#			Cooldown is reset when entering instances. Added an
#			option to kick or jail players instead of banning. Added
#			some spells to cheat list.
#
# v0.4.1 (2006-05-27) - The "stay cool" version
#			Lowered minimum cooldowns before flagging a cheater.
#			"check_cheat" and "check_cooldown" options.
#
# v0.4.0 (2006-05-22) - The "cooldown check" version
#			Checking of cooldown for spells having script effect.
#
# v0.3.0 (2006-05-18) - The "more options" version
#			Added "ban_ip" option, so you can ban accounts and not
#			ban IPs if you prefer. Added "allow_gm" option.
#
# v0.2.2 (2006-05-13) - The "why don't you trigger" version
#			Fixed patch for some cheat spells that failed to trigger
#			the spell script.
#
# v0.2.1 (2006-04-26) - The "they are not all the same" version
#			Fixed GetIPByName that was returning the same ip.
#
# v0.2.0 (2006-04-08) - The "omg it's you again" version
#			Banned IPs can now be read and written to banned.conf.
#			No ".rescp" needed, the IPs are loaded and modified in
#			memory too.
#
# v0.1.0 (2006-04-05) - The "why don't you use custom" version
#			This script was written to demonstrate how
#			"::Custom::AddSpellScript" can be used.
#
#


#
#	StartTCL initialization
#
# StartTCL: n
#


#
# Note: this script requires a spell patch, see the documentation
#


#
#	namespace eval ::AutoBan
#
# AutoBan namespace and variable definitions
#
namespace eval ::AutoBan {
	variable VERSION 0.7.2

	# boolean to use or not the configuration file
	variable USE_CONF 0

	# for loot destruction
	variable DUMMY_LOOT 33000

	# File to log automatic bans in
	variable LOG_FILE "logs/autoban.log"


	# emu.conf should include this file
	variable BAN_FILE "scripts/conf/banned.conf"

	# allow GMs to use cheats
	variable ALLOW_GM 1

	# destroy the loot upon cheating
	variable DESTROY_LOOT 1

	# jail time in seconds if jailing player instead of banning
	variable JAIL_TIME 86400

	# 0 = disabled, 1 = log, 2 = kick, 3 = jail, 4 = ban account, 5 = ban ip
	variable CHECK_FORBIDDEN 4
	variable CHECK_USURPED 1
	variable CHECK_COOLDOWN 0
}


#
#	proc ::AutoBan::Ban { to from spellid reason action_level }
#
# procedure to ban a player
#
proc ::AutoBan::Ban { to from spellid reason {action_level 5} } {
	variable LOG_FILE
	variable ALLOW_GM
	variable JAIL_TIME
	variable ScriptedCast

	if { $ALLOW_GM && [ ::GetPlevel $from ] >= 4 } {
		return 0
	}

	if { [ info exists ScriptedCast($from) ] && $ScriptedCast($from) == $spellid } {
		unset ScriptedCast($from)
		return 0
	}

	set guid [ ::GetGuid $from ]
	set account_info [ ::GmTools::gtGetAccountInfo [ ::GmTools::gtGetAccount $guid ] ]
	set account [ lindex $account_info 1 ]
	set ip [ lindex $account_info 3 ]
	set name [ ::GetName $from ]
	set target [ ::Custom::GetName $to ]

	if { $account == "" } {
		set account $guid
	}

	if { $ip == "" } {
		set ip [ ::AutoBan::GetIPByName $name ]
	}

	if { $action_level >= 5 } {
		::AutoBan::AddToBanFile $ip
	}

	if { $action_level >= 4 } {
		::GmTools::gtBan $account
	}

	if { $action_level == 3 } {
		::AutoBan::JailPlayer $from $JAIL_TIME "$reason (spell $spellid)" "AutoBan"
	}

	if { $action_level == 2 || $action_level >= 4 } {
		::KickPlayer $from
	}

	if { $action_level >= 1 } {
		::Custom::Log "account=$account ip=$ip name=$name spell=$spellid target=\"$target\" reason=\"$reason\"" $LOG_FILE
	}

	return 1
}


#
#	proc ::AutoBan::OnLogin { to from spellid }
#
# trigger procedure fired when a player logs in
#
proc ::AutoBan::OnLogin { to from spellid } {
	variable ScriptTime${from}
	variable IsBanned

	if { [ ::GetObjectType $from ] != 4 } {
		return
	}

	unset -nocomplain ScriptTime${from}

	set guid [ ::GetGuid $from ]
	set account_info [ ::GmTools::gtGetAccountInfo [ ::GmTools::gtGetAccount $guid ] ]
	set ip [ lindex $account_info 3 ]

	if { $ip == "" } {
		set name [ ::GetName $from ]
		set ip [ ::AutoBan::GetIPByName $name ]
	}

	if { [ info exists IsBanned($ip) ] } {
		::AutoBan::Ban $to $from $spellid "login from banned ip"
	}
}


#
#	proc ::AutoBan::CheckForbidden { to from spellid }
#
# check whether a player is using a forbidden spell
# (for spells whith level = 0 in ::AI::SpellData)
#
proc ::AutoBan::CheckForbidden { to from spellid } {
	variable CHECK_FORBIDDEN
	variable DESTROY_LOOT
	variable DUMMY_LOOT

	if { [ ::GetObjectType $from ] != 4 } {
		return
	}

	if { $DESTROY_LOOT && [ ::GetObjectType $to ] == 3 } {
		::Loot $from $to $DUMMY_LOOT 5
	}

	::AutoBan::Ban $to $from $spellid "forbidden spell" $CHECK_FORBIDDEN
}


#
#	proc ::AutoBan::CheckUsurped { to from spellid }
#
# check whether the player is usurping a spell
# (check for level, race and class from ::AI::SpellData)
#
proc ::AutoBan::CheckUsurped { to from spellid } {
	variable CHECK_USURPED

	if { [ ::GetObjectType $from ] != 4 } {
		return
	}

	foreach { level classes races } [ lrange $::AI::SpellData($spellid) 5 7 ] {}

	if { [ set player_level [ ::GetLevel $from ] ] < $level } {
		::AutoBan::Ban $to $from $spellid "level = $player_level, required = $level" $CHECK_USURPED
	} elseif { [ llength $classes ] && [ lsearch $classes [ set player_class [ ::GetClass $from ] ] ] < 0 } {
		::AutoBan::Ban $to $from $spellid "class = $player_class, allowed = $classes" $CHECK_USURPED
	} elseif { [ llength $races ] && [ lsearch $races [ set player_race [ ::GetRace $from ] ] ] < 0 } {
		::AutoBan::Ban $to $from $spellid "race = $player_class, allowed = $races" $CHECK_USURPED
	}
}


#
#	proc ::AutoBan::CheckCooldown { to from spellid }
#
# check whether spell cooldowns are bypassed
#
proc ::AutoBan::CheckCooldown { to from spellid } {
	variable CHECK_COOLDOWN
	variable ScriptTime${from}

	if { [ ::GetObjectType $from ] != 4 } {
		return
	}

	set time [ clock seconds ]
	set min [ expr { [ lindex $::AI::SpellData($spellid) 1 ] * 3 / 4 - 2 } ]

	if { [ info exists ScriptTime${from}($spellid) ] && $min > [ set elapsed [ expr { $time - [ set ScriptTime${from}($spellid) ] } ] ] } {
		# if elapsed time is very short, it may be some area spell
		if { $elapsed <= 2 } {
			return
		}

		::AutoBan::Ban $to $from $spellid "cooldown = ${elapsed}s, minimum = ${min}s" $CHECK_COOLDOWN
	}

	set ScriptTime${from}($spellid) $time
}


#
#	proc ::AutoBan::GetIPByName { name }
#
# get IP from stat.xml if dbconsole fails (bug with long guids)
#
proc ::AutoBan::GetIPByName { name } {
	set file "www/stat.xml"

	if { ! [ file exists $file ] } {
		return
	}

	set found 0
	set hstat [ open $file ]

	while { [ gets $hstat line ] != -1 } {
		if { [ string match -nocase "*<name>*" $line ] } {
			if { [ lindex [ split $line "<>" ] 2 ] == $name } {
				set found 1
			}
		} elseif { $found && [ string match -nocase "*<ip>*" $line ] } {
			return [ lindex [ split $line "<>" ] 2 ]
		}
	}

	close $hstat
	return ""
}


#
#	proc ::AutoBan::AddToBanFile { ip }
#
# add an IP to the permanent ban list
#
proc ::AutoBan::AddToBanFile { ip } {
	variable BAN_FILE
	variable IsBanned

	if { $ip != "" && ! [ info exists IsBanned($ip) ] } {
		set IsBanned($ip) 1

		if { $BAN_FILE != "" } {
			if { ! [ file exists $BAN_FILE ] } {
				set line "\[banned\]\n"
			}

			# IP entries in "banned.conf" can either take the straight form of
			# "ip=<ip_address>" or "ip=<ip_address>/<mask>". For example, to ban
			# the IP range 123.123.x.x, use "ip=123.123.0.0/255.255.0.0".
			append line "ip=$ip"
			set hban [ open $BAN_FILE a ]
			puts $hban $line
			close $hban
		}
	}
}


#
#	proc ::AutoBan::LoadBanFile {}
#
# read the permanent ban list from file
#
proc ::AutoBan::LoadBanFile {} {
	variable BAN_FILE
	variable IsBanned

	if { $BAN_FILE == "" } { return }

	foreach { section data } [ ::Custom::ReadConf $BAN_FILE ] {
		if { [ string compare -nocase $section "banned" ] } {
			continue
		}

		foreach { key value } $data {
			if { ! [ string compare -nocase $key "ip" ] } {
				set ip [ lindex [ split $value "/" ] 0 ]
				set IsBanned($ip) 1
			}
		}
	}
}


#
#	proc ::AutoBan::JailPlayer { player jail_time reason by }
#
# jail a player using any available jail system
#
proc ::AutoBan::JailPlayer { player { jail_time 3600 } { reason "" } { by "" } } {
	if { [ ::Custom::GetScriptVersion "zJail" ] >= "1.5.0" } {
		::zJail::JailPlayer $player $jail_time $reason $by
	} elseif { [ ::Custom::GetScriptVersion "zJail" ] >= "1.4.0" } {
		::zJail::JailPlayer $player [ expr { $jail_time / 60 } ] $reason
	} elseif { [ ::Custom::GetScriptVersion "ngjail" ] >= "0.1.0" } {
		::ngjail::Jail $player $jail_time $reason $by
	} elseif { [ ::Custom::GetScriptVersion "ngJail" ] >= "0.1.0" } {
		::ngJail::Jail $player $jail_time $reason $by
	} elseif { [ info procs "::gotisch::jail" ] != "" } {
		::gotisch::jail $player $jail_time
	} else {
		::Teleport $player 13 0 0 0
		::Custom::Error "No known jail system available."
	}
}


#
#	proc ::AutoBan::TraceCastSpell { command op }
#
# check when spell is cast from CastSpell command
#
proc ::AutoBan::TraceCastSpell { command op } {
	variable ScriptedCast
	variable ScriptTime[ lindex $command 1 ]

	set ScriptedCast([ lindex $command 1 ]) [ lindex $command 3 ]
	unset -nocomplain ScriptTime[ lindex $command 1 ]([ lindex $command 3 ])
}


#
#	proc ::AutoBan::TraceTeleport { command op }
#
# reset cooldown data when player is teleported by script
#
proc ::AutoBan::TraceTeleport { command op } {
	variable ScriptTime[ lindex $command 1 ]

	unset -nocomplain ScriptTime[ lindex $command 1 ]
}


#
#	proc ::AutoBan::Init {}
#
# initialization / registration of the spell scripts to monitor
#
proc ::AutoBan::Init {} {
	variable DUMMY_LOOT
	variable CHECK_FORBIDDEN
	variable CHECK_USURPED
	variable CHECK_COOLDOWN
	variable USE_CONF


	if { ! [ namespace exists [ namespace current ] ] } {
		::Custom::Error "Namespace error, you most likely have duplicates in your scripts folder."
		return
	}

	# check for GmTools, of which AutoBan is fully dependent
	if { [ catch { ::StartTCL::Require "GmTools" } ] || ! [ info exists ::GmTools::ngconsole ] } {
		::Custom::Error "AutoBan requires GmTools and ngConsole"
		namespace delete [ namespace current ]
		return
	}


	# load configuration
	if { $USE_CONF } {
		::Custom::LoadConf "AutoBan" $::StartTCL::conf_file
	}


	# check for zInstanceLimiter
	if { [ catch { ::StartTCL::Require "zInstanceLimiter" } ] && [ catch { ::StartTCL::Require "InstanceLimiter" } ] && $CHECK_COOLDOWN >= 3 } {
		::Custom::Error "check_cooldown = 3 and above requires zInstanceLimiter."
		set CHECK_COOLDOWN 1
	}

	# other scripts having AreaTrigger
	catch { ::StartTCL::Require "Honor" }
	catch { ::StartTCL::Require "Warsong" }

	foreach ns [ namespace children "::" ] {
		if { [ info procs "${ns}::AreaTrigger" ] != "" } {
			::Custom::HookProc "${ns}::AreaTrigger" {
				unset -nocomplain ::AutoBan::ScriptTime${player}
			}
		}
	}

	# reset cooldown when being teleported
	trace add execution ::Teleport enter ::AutoBan::TraceTeleport

	::Custom::HookProc "::WoWEmu::Commands::go" {
		unset -nocomplain ::AutoBan::ScriptTime${player}
	}

	::Custom::HookProc "::WoWEmu::Commands::goguid" {
		unset -nocomplain ::AutoBan::ScriptTime${player}
	}

	::Custom::HookProc "::WoWEmu::Commands::goname" {
		unset -nocomplain ::AutoBan::ScriptTime${player}
	}

	::Custom::HookProc "::WoWEmu::Commands::gotrigger" {
		unset -nocomplain ::AutoBan::ScriptTime${player}
	}

	::Custom::HookProc "::WoWEmu::Commands::namego" {
		unset -nocomplain ::AutoBan::ScriptTime[ ::Custom::GetPlayerID $cargs ]
	}


	# remove banned ip from memory when using the ".-ban" command
	::Custom::HookProc "::GmTools::cUnBan" {
		unset -nocomplain ::AutoBan::IsBanned([ lindex [ ::GmTools::gtGetAccountInfo $cargs ] 3 ])
	}


	# check loot template
	foreach loot [ ::GetScpValue "loottemplates.scp" "loottemplate $DUMMY_LOOT" "loot" ] {
		foreach { item chance } $loot {
			if { ! [ string is double -strict $chance ] || $chance > 1. } {
				::Custom::Error "Loot template $DUMMY_LOOT is wrong."
			}
		}
	}


	if { ! [ info exists chance ] } {
		::Custom::Error "Loot template $DUMMY_LOOT is missing."
	}


	trace add execution ::CastSpell enter ::AutoBan::TraceCastSpell

	::AutoBan::LoadBanFile

	::Custom::AddSpellScript "::AutoBan::OnLogin" 836


	# build spell lists
	set forbid_list {}
	set usurp_list {}
	set cool_list {}

	foreach { spellid data } [ array get ::AI::SpellData ] {
		set level [ lindex $data 5 ]

		if { ! [ string is integer -strict $level ] } {
			continue
		}

		if { $level <= 0 } {
			lappend forbid_list $spellid
		} else {
			lappend usurp_list $spellid
		}
	}


	if { $CHECK_FORBIDDEN } {
		::Custom::AddSpellScript "::AutoBan::CheckForbidden" $forbid_list
	}

	unset forbid_list

	if { $CHECK_USURPED } {
		::Custom::AddSpellScript "::AutoBan::CheckUsurped" $usurp_list
	}

	unset usurp_list

	if { $CHECK_COOLDOWN } {
		foreach spellid [ array names ::AI::SpellData ] {
			if { [ lindex $::AI::SpellData($spellid) 1 ] } {
				lappend cool_list $spellid
			}
		}

		::Custom::AddSpellScript "::AutoBan::CheckCooldown" $cool_list
	}

	unset cool_list

	::StartTCL::Provide
}


#
#	startup time command execution
#
# run the initialization procedure
#
::AutoBan::Init
