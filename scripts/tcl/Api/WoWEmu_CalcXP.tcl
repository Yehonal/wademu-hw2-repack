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
# Name:		WoWEmu_CalcXP.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::WoWEmu::CalcXP { killer victim }
#
# Warning: Don't ever return a negative value, it can make the server crash when
# players are in a group.
#
proc ::WoWEmu::CalcXP { killer victim } {

	# check for group exploit
	variable LastVictim

	set guid [ ::GetGuid $victim ]

	if { [ info exists LastVictim($killer) ] && $LastVictim($killer) == $guid } {
		return 0
	}

	set LastVictim($killer) $guid


	set killer_level [ ::GetLevel $killer ]

	if { $killer_level >= $::WoWEmu::MAX_LEVEL || [ ::Distance $killer $victim ] > $::WoWEmu::MAX_DISTANCE || [ ::GetQFlag $killer IsDead ] } {
		return 0
	}

	set victim_level [ ::GetLevel $victim ]

	if { $::WoWEmu::CHECK_GREY_LEVEL && [ ::Custom::IsGreyLevel $victim_level $killer_level ] || [ ::GetCreatureType $victim ] == 8 || ( [ ::GetNpcflags $victim ] & 0x20 ) } {
		set xp 0
	} else {
		set xp [ expr { $killer_level * 5 + 45 } ]
		set lvldiff [ expr { $victim_level - $killer_level } ]
		set rate [ lindex $::WoWEmu::XP_RATES [ ::Custom::GetElite $victim ] ]

		if { $lvldiff >= 0 } {
			if { $lvldiff > $::WoWEmu::HIGH_LEVEL_DIFF } {
				set lvldiff $::WoWEmu::HIGH_LEVEL_DIFF
			}

			set xp [ expr { ( $xp + $xp * $lvldiff * .05 ) * $rate } ]
		} else {
			set xp [ expr { ( $xp + $xp * $lvldiff / double( [ GetZeroDifference $killer_level ] ) ) * $rate } ]

			if { $xp < 1 } {
				set xp 1
			}
		}
	}

	return [ ::WoWEmu::ModXP $killer $victim $xp ]
}


#
#	proc ::WoWEmu::ModXP { killer victim xp }
#
# Hook into this procedure to modify the experience ($xp)
#
proc ::WoWEmu::ModXP { killer victim xp } {
	set xp [ expr { round( $xp * .5 ) } ]

	return $xp
}


#
#	proc ::WoWEmu::GetZeroDifference { level }
#
proc ::WoWEmu::GetZeroDifference { level } {
	if { $level < 8 } {
		return 5
	}

	if { $level < 10 } {
		return 6
	}

	if { $level < 12 } {
		return 7
	}

	if { $level < 16 } {
		return 8
	}

	if { $level < 20 } {
		return 9
	}

	if { $level < 40 } {
		return [ expr { 9 + int( $level / 10 ) } ]
	}

	return [ expr { 5 + int( $level / 5 ) } ]
}


#
# log specified elite mob types when killed (logs/mob.log)
#
if { [ llength $::WoWEmu::MOB_LOG ] } {
	::Custom::HookProc "::WoWEmu::CalcXP" {
		# log for killed elites
		set entry [ ::GetEntry $victim ]
		set elite [ ::Custom::GetCreatureScp $entry "elite" ]

		if { [ lsearch $::WoWEmu::MOB_LOG $elite ] >= 0 } {
			set mobname [ ::Custom::GetCreatureScp $entry "name" ]
			set moblevel [ ::GetLevel $victim ]
			set mobpos [ ::Custom::RoundPos [ ::GetPos $victim ] ]
			::Custom::Log "mob=\"$mobname\" moblevel=$moblevel entry=$entry pos=\[$mobpos\] name=[ ::GetName $killer ] level=[ ::GetLevel $killer ]" "logs/mob.log"
		}
	}
}

