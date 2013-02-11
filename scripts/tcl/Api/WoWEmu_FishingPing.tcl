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
# Name:		WoWEmu_FishingPing.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::WoWEmu::FishingPing { player bobber seconds_remaining }
#
proc ::WoWEmu::FishingPing { player bobber seconds_remaining } {
	variable FishingData

	# remove the bobber if the player is too far
	if { [ ::Distance $player $bobber ] > 20 } {
		::BreakSpellLink $player
		::FishNotHooked $player
		::Loot $player $bobber 33000 5
		array unset FishingData $player
		return
	}

	if { [ info exists FishingData($player) ] } {
		foreach { pecktime pbobber } $FishingData($player) {}

		# remove the previous bobber
		if { $pbobber != $bobber } {
			::Loot $player $pbobber 33000 5
			array unset FishingData $player
			return
		}
	} else {
		set pecktime [ expr { rand() * 25 + 5 } ]
		set FishingData($player) [ list $pecktime $bobber ]
	}

	if { $seconds_remaining < $pecktime && $seconds_remaining >= $pecktime - 3 } {
		::SetQFlag $player openfish
		::GO_CustomAnimation $bobber 0
	} else {
		::ClearQFlag $player openfish
	}
}

