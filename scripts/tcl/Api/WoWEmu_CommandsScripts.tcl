# StartTCL: b
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
# Name:		WoWEmu_Commands.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::WoWEmu::Commands:* { player cargs }
#

#
# player level 0
#

#
#	proc ::WoWEmu::Commands:where { player cargs }
#
proc ::WoWEmu::Commands::where { player cargs } {
	return ".where $cargs"
}


#
#	proc ::WoWEmu::Commands:help { player cargs }
#
proc ::WoWEmu::Commands::help { player cargs } {
	if { $cargs == "" } {
		set plevel [ ::GetPlevel $player ]

		if { $plevel < 2 } {
			return [ ::Texts::Get "help_plvl0" ]
		} elseif { $plevel < 4 } {
			return [ ::Texts::Get "help_plvl2" ]
		} elseif { $plevel < 6 } {
			return [ ::Texts::Get "help_plvl4" ]
		} else {
			return [ ::Texts::Get "help_plvl6" ]
        }
	}

	return ".help $cargs"
}


#
#	proc ::WoWEmu::Commands:dismount { player cargs }
#
proc ::WoWEmu::Commands::dismount { player cargs } {
	if { ! $::WoWEmu::ALLOW_PLAYER_DISMOUNT && [ ::GetPlevel $player ] < 4 } {
		return [ ::Texts::Get "not_allowed" ]
	}
	if { [ ::GetSelection $player ] != $player } {
		return [ ::Texts::Get "select_self" ]
	}

	return ".dismount $cargs"
}


#
# player level 2
#

#
#	proc ::WoWEmu::Commands:del { player cargs }
#
proc ::WoWEmu::Commands::del { player cargs } {
	return ".del $cargs"
}


#
#	proc ::WoWEmu::Commands:go { player cargs }
#
proc ::WoWEmu::Commands::go { player cargs } {
	return ".go $cargs"
}


#
#	proc ::WoWEmu::Commands:gotrigger { player cargs }
#
proc ::WoWEmu::Commands::gotrigger { player cargs } {
	return ".gotrigger $cargs"
}


#
#	proc ::WoWEmu::Commands:resurrect { player cargs }
#
proc ::WoWEmu::Commands::resurrect { player cargs } {
	if { ! $::WoWEmu::ALLOW_RESURRECT_PLAYERS } {
		if { [ ::GetSelection $player ] != $player } {
			return [ ::Texts::Get "not_allowed_players" ]
		}
	}

	return ".resurrect $cargs"
}


#
#	proc ::WoWEmu::Commands::setaura { player cargs }
#
proc ::WoWEmu::Commands::setaura { player cargs } {
	return ".setaura $cargs"
}


#
#	proc ::WoWEmu::Commands::listsp { player cargs }
#
proc ::WoWEmu::Commands::listsp { player cargs } {
	return ".listsp $cargs"
}


#
#	proc ::WoWEmu::Commands::listsk { player cargs }
#
proc ::WoWEmu::Commands::listsk { player cargs } {
	return ".listsk $cargs"
}


#
#	proc ::WoWEmu::Commands::info { player cargs }
#
proc ::WoWEmu::Commands::info { player cargs } {
	return ".info $cargs"
}


#
#	proc ::WoWEmu::Commands::online { player cargs }
#
proc ::WoWEmu::Commands::online { player cargs } {
	return ".online $cargs"
}


#
#	proc ::WoWEmu::Commands::setreststate { player cargs }
#
proc ::WoWEmu::Commands::setreststate { player cargs } {
	return ".setreststate $cargs"
}


#
#	proc ::WoWEmu::Commands::goname { player cargs }
#
proc ::WoWEmu::Commands::goname { player cargs } {
	return ".goname $cargs"
}


#
#	proc ::WoWEmu::Commands::goguid { player cargs }
#
proc ::WoWEmu::Commands::goguid { player cargs } {
	return ".goguid $cargs"
}


#
#	proc ::WoWEmu::Commands::clearqflags { player cargs }
#
proc ::WoWEmu::Commands::clearqflags { player cargs } {
	return ".clearqflags $cargs"
}


#
#	proc ::WoWEmu::Commands::pingmm { player cargs }
#
proc ::WoWEmu::Commands::pingmm { player cargs } {
	return ".pingmm $cargs"
}


#
#	proc ::WoWEmu::Commands::starttimer { player cargs }
#
proc ::WoWEmu::Commands::starttimer { player cargs } {
	return ".starttimer $cargs"
}


#
#	proc ::WoWEmu::Commands::stoptimer { player cargs }
#
proc ::WoWEmu::Commands::stoptimer { player cargs } {
	return ".stoptimer $cargs"
}


#
#	proc ::WoWEmu::Commands::faction { player cargs }
#
proc ::WoWEmu::Commands::faction { player cargs } {
	return ".faction $cargs"
}


#
#	proc ::WoWEmu::Commands::kick { player cargs }
#
proc ::WoWEmu::Commands::kick { player cargs } {
	set selected [ ::GetSelection $player ]

	if { [ ::GetObjectType $selected ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { $player == $selected } {
		return [ ::Texts::Get "cant_kick_self" ]
	}

	if { [ ::GetPlevel $player ] <= [ ::GetPlevel $selected ] } {
		return [ ::Texts::Get "plevel_conflict" ]
	}

	::KickPlayer $selected
}


#
# player level 4
#

#
#	proc ::WoWEmu::Commands::add { player cargs }
#
proc ::WoWEmu::Commands::add { player cargs } {
	return ".add $cargs"
}


#
#	proc ::WoWEmu::Commands::addgo { player cargs }
#
proc ::WoWEmu::Commands::addgo { player cargs } {
	return ".addgo $cargs"
}


#
#	proc ::WoWEmu::Commands::addnpc { player cargs }
#
proc ::WoWEmu::Commands::addnpc { player cargs } {
	return ".addnpc $cargs"
}


#
#	proc ::WoWEmu::Commands::setlevel { player cargs }
#
proc ::WoWEmu::Commands::setlevel { player cargs } {
	return ".setlevel $cargs"
}


#
#	proc ::WoWEmu::Commands::setmodel { player cargs }
#
proc ::WoWEmu::Commands::setmodel { player cargs } {
	return ".setmodel $cargs"
}


#
#	proc ::WoWEmu::Commands::broadcast { player cargs }
#
proc ::WoWEmu::Commands::broadcast { player cargs } {
	if { $::WoWEmu::BROADCAST_WITH_NAME } {
		return ".broadcast $cargs [::Custom::Color "([::GetName $player])" aqua]"
	} else {
		return ".broadcast $cargs"
	}
}


#
#	proc ::WoWEmu::Commands::turn { player cargs }
#
proc ::WoWEmu::Commands::turn { player cargs } {
	return ".turn $cargs"
}


#
#	proc ::WoWEmu::Commands::come { player cargs }
#
proc ::WoWEmu::Commands::come { player cargs } {
	return ".come $cargs"
}


#
#	proc ::WoWEmu::Commands::kill { player cargs }
#
proc ::WoWEmu::Commands::kill { player cargs } {
	if { [ ::GetPlevel $player ] >= 6 } {
		return ".kill $cargs"
	}

	switch -- [ ::GetObjectType [ ::GetSelection $player ] ] {
		0 { return [ ::Texts::Get "object_not_found" ] }
		3 { return ".del $cargs" }
		4 { return ".kill $cargs" }
		default { return [ ::Texts::Get "not_allowed_object" ] }
	}
}


#
#	proc ::WoWEmu::Commands::killallnpc { player cargs }
#
proc ::WoWEmu::Commands::killallnpc { player cargs } {
	return ".killallnpc $cargs"
}


#
#	proc ::WoWEmu::Commands::setsize { player cargs }
#
proc ::WoWEmu::Commands::setsize { player cargs } {
	if { [ string is double -strict [ lindex $cargs 0 ] ] && [ lindex $cargs 0 ] > 8. } {
		return [ ::Texts::Get "number_too_large" ]
	}
	return ".setsize $cargs"
}


#
#	proc ::WoWEmu::Commands::setspeed { player cargs }
#
proc ::WoWEmu::Commands::setspeed { player cargs } {
	if { [ string is double -strict [ lindex $cargs 0 ] ] && [ lindex $cargs 0 ] > 500. } {
		return [ ::Texts::Get "number_too_large" ]
	}
	return ".setspeed $cargs"
}


#
#	proc ::WoWEmu::Commands::setflags { player cargs }
#
proc ::WoWEmu::Commands::setflags { player cargs } {
	return ".setflags $cargs"
}


#
#	proc ::WoWEmu::Commands::addspawn { player cargs }
#
proc ::WoWEmu::Commands::addspawn { player cargs } {
	return ".addspawn $cargs"
}


#
#	proc ::WoWEmu::Commands::setspawnnpc { player cargs }
#
proc ::WoWEmu::Commands::setspawnnpc { player cargs } {
	return ".setspawnnpc $cargs"
}


#
#	proc ::WoWEmu::Commands::setspawngo { player cargs }
#
proc ::WoWEmu::Commands::setspawngo { player cargs } {
	return ".setspawngo $cargs"
}


#
#	proc ::WoWEmu::Commands::setspawndist { player cargs }
#
proc ::WoWEmu::Commands::setspawndist { player cargs } {
	return ".setspawndist $cargs"
}


#
#	proc ::WoWEmu::Commands::setspawntime { player cargs }
#
proc ::WoWEmu::Commands::setspawntime { player cargs } {
	return ".setspawntime $cargs"
}


#
#	proc ::WoWEmu::Commands::setxp { player cargs }
#
proc ::WoWEmu::Commands::setxp { player cargs } {
	if { [ string is double -strict [ lindex $cargs 0 ] ] && [ lindex $cargs 0 ] > 500000. } {
		return [ ::Texts::Get "number_too_large" ]
	}
	return ".setxp $cargs"
}


#
#	proc ::WoWEmu::Commands::setcp { player cargs }
#
proc ::WoWEmu::Commands::setcp { player cargs } {
	return ".setcp $cargs"
}

#
#	proc ::WoWEmu::Commands::sethp { player cargs }
#
proc ::WoWEmu::Commands::sethp { player cargs } {
	return ".sethp $cargs"
}


#
#	proc ::WoWEmu::Commands::paralyse { player cargs }
#
proc ::WoWEmu::Commands::paralyse { player cargs } {
	return ".paralyse $cargs"
}


#
#	proc ::WoWEmu::Commands::exploration { player cargs }
#
proc ::WoWEmu::Commands::exploration { player cargs } {
	return ".exploration $cargs"
}


#
#	proc ::WoWEmu::Commands::learn { player cargs }
#
proc ::WoWEmu::Commands::learn { player cargs } {
	set selected [ ::GetSelection $player ]

	if { [ ::GetObjectType $selected ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	LearnSpell $selected $cargs
}


#
#	proc ::WoWEmu::Commands::unlearn { player cargs }
#
proc ::WoWEmu::Commands::unlearn { player cargs } {
	return ".unlearn $cargs"
}


#
#	proc ::WoWEmu::Commands::learnsk { player cargs }
#
proc ::WoWEmu::Commands::learnsk { player cargs } {
	set selected [ ::GetSelection $player ]

	if { [ ::GetObjectType $selected ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set skillid [ lindex $cargs 0 ]
	set value [ lindex $cargs 1 ]
	set max [ lindex $cargs 2 ]
	SetSkill $selected $skillid $value $max
}


#
#	proc ::WoWEmu::Commands::unlearnsk { player cargs }
#
proc ::WoWEmu::Commands::unlearnsk { player cargs } {
	return ".unlearnsk $cargs"
}


#
#	proc ::WoWEmu::Commands::namego { player cargs }
#
proc ::WoWEmu::Commands::namego { player cargs } {
	return ".namego $cargs"
}


#
#	proc ::WoWEmu::Commands::targetgo { player cargs }
#
proc ::WoWEmu::Commands::targetgo { player cargs } {
	return ".targetgo $cargs"
}


#
#	proc ::WoWEmu::Commands::targetlink { player cargs }
#
proc ::WoWEmu::Commands::targetlink { player cargs } {
	return ".targetlink $cargs"
}


#
#	proc ::WoWEmu::Commands::move { player cargs }
#
proc ::WoWEmu::Commands::move { player cargs } {
	return ".move $cargs"
}


#
#	proc ::WoWEmu::Commands::rotate { player cargs }
#
proc ::WoWEmu::Commands::rotate { player cargs } {
	return ".rotate $cargs"
}


#
#	proc ::WoWEmu::Commands::setnpcflags { player cargs }
#
proc ::WoWEmu::Commands::setnpcflags { player cargs } {
	return ".setnpcflags $cargs"
}


#
#	proc ::WoWEmu::Commands::clearrep { player cargs }
#
proc ::WoWEmu::Commands::clearrep { player cargs } {
	return ".clearrep $cargs"
}


#
#	proc ::WoWEmu::Commands::gflags { player cargs }
#
proc ::WoWEmu::Commands::gflags { player cargs } {
	return ".gflags $cargs"
}


#
#	proc ::WoWEmu::Commands::gtype { player cargs }
#
proc ::WoWEmu::Commands::gtype { player cargs } {
	return ".gtype $cargs"
}


#
# player level 6
#

#
#	proc ::WoWEmu::Commands::save { player cargs }
#
proc ::WoWEmu::Commands::save { player cargs } {
	return ".save $cargs"
}


#
#	proc ::WoWEmu::Commands::rehash { player cargs }
#
proc ::WoWEmu::Commands::rehash { player cargs } {
	return ".rehash $cargs"
}


#
#	proc ::WoWEmu::Commands::flag1 { player cargs }
#
proc ::WoWEmu::Commands::flag1 { player cargs } {
	return ".flag1 $cargs"
}


#
#	proc ::WoWEmu::Commands::ppon { player cargs }
#
proc ::WoWEmu::Commands::ppon { player cargs } {
	return ".ppon $cargs"
}


#
#	proc ::WoWEmu::Commands::ppoff { player cargs }
#
proc ::WoWEmu::Commands::ppoff { player cargs } {
	return ".ppoff $cargs"
}


#
#	proc ::WoWEmu::Commands::delallcorp { player cargs }
#
proc ::WoWEmu::Commands::delallcorp { player cargs } {
	return ".delallcorp $cargs"
}


#
#	proc ::WoWEmu::Commands::cleanup { player cargs }
#
proc ::WoWEmu::Commands::cleanup { player cargs } {
	return ".cleanup $cargs"
}


#
#	proc ::WoWEmu::Commands::exportchar { player cargs }
#
proc ::WoWEmu::Commands::exportchar { player cargs } {
	return ".exportchar $cargs"
}


#
#	proc ::WoWEmu::Commands::importchar { player cargs }
#
proc ::WoWEmu::Commands::importchar { player cargs } {
	return ".importchar $cargs"
}


#
#	proc ::WoWEmu::Commands::exportspawns { player cargs }
#
proc ::WoWEmu::Commands::exportspawns { player cargs } {
	return ".exportspawns $cargs"
}


#
#	proc ::WoWEmu::Commands::exportspawnsxy { player cargs }
#
proc ::WoWEmu::Commands::exportspawnsxy { player cargs } {
	return ".exportspawnsxy $cargs"
}


#
#	proc ::WoWEmu::Commands::importspawns { player cargs }
#
proc ::WoWEmu::Commands::importspawns { player cargs } {
	return ".importspawns $cargs"
}


#
#	proc ::WoWEmu::Commands::delspawns { player cargs }
#
proc ::WoWEmu::Commands::delspawns { player cargs } {
	return ".delspawns $cargs"
}


#
#	proc ::WoWEmu::Commands::delspawnsxy { player cargs }
#
proc ::WoWEmu::Commands::delspawnsxy { player cargs } {
	return ".delspawnsxy $cargs"
}


#
#	proc ::WoWEmu::Commands::adddyn { player cargs }
#
proc ::WoWEmu::Commands::adddyn { player cargs } {
	return ".adddyn $cargs"
}


#
#	proc ::WoWEmu::Commands::byte { player cargs }
#
proc ::WoWEmu::Commands::byte { player cargs } {
	return ".byte $cargs"
}


#
#	proc ::WoWEmu::Commands::test { player cargs }
#
proc ::WoWEmu::Commands::test { player cargs } {
	return ".test $cargs"
}


#
#	proc ::WoWEmu::Commands::test2 { player cargs }
#
proc ::WoWEmu::Commands::test2 { player cargs } {
	return ".test2 $cargs"
}


#
#	proc ::WoWEmu::Commands::movelog { player cargs }
#
proc ::WoWEmu::Commands::movelog { player cargs } {
	return ".movelog $cargs"
}


#
#	proc ::WoWEmu::Commands::setfaction { player cargs }
#
proc ::WoWEmu::Commands::setfaction { player cargs } {
	return ".setfaction $cargs"
}


#
#	proc ::WoWEmu::Commands::shutdown { player cargs }
#
proc ::WoWEmu::Commands::shutdown { player cargs } {
	return ".shutdown $cargs"
}


#
#	proc ::WoWEmu::Commands::respawnall { player cargs }
#
proc ::WoWEmu::Commands::respawnall { player cargs } {
	return ".respawnall $cargs"
}


#
#	proc ::WoWEmu::Commands::retcl { player cargs }
#
proc ::WoWEmu::Commands::retcl { player cargs } {
	return ".retcl $cargs"
}


#
#	proc ::WoWEmu::Commands::rescp { player cargs }
#
proc ::WoWEmu::Commands::rescp { player cargs } {
	return ".rescp $cargs"
}


#
# command errors
#

#
#	proc ::WoWEmu::Commands::WrongPlevel { {player 0} {cargs ""} }
#
proc ::WoWEmu::Commands::WrongPlevel { {player 0} {cargs ""} } {
	return [ ::Texts::Get "not_allowed" ]
}


#
#	proc ::WoWEmu::Commands::BadCommand { {player 0} {cargs ""} }
#
proc ::WoWEmu::Commands::UnknownCommand { {player 0} {command ""} } {
	return [ ::Texts::Get "unknown_command" $command ]
}


#
#	Logging of GM commands affecting players (logs/gmcommands.log)
#
if { $::WoWEmu::LOG_GM } {
	::Custom::LogCommand {
		"clearrep"
		"kick"
		"kill"
		"learn"
		"learnsk"
		"resurrect"
		"setaura"
		"setcp"
		"sethp"
		"setlevel"
		"setspeed"
		"setxp"
		"unlearn"
		"unlearnsk"
	}
}



