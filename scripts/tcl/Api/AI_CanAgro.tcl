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
# Name:		AI_CanAgro.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::AI::CanAgro { npc victim }
#
proc ::AI::CanAgro { npc victim } {
	if { [ set dist [ ::Distance $npc $victim ] ] >= $::AI::MAX_AGGRO_DIST || $dist >= $::AI::AGGRO_DIST + [ ::GetLevel $npc ] - [ ::GetLevel $victim ] && $dist >= $::AI::MIN_AGGRO_DIST } {
		return 0
	}
	if { [ ::GetQFlag $victim stealth ] } {
	return 0
	}
	return [ ::AI::ModAgro $npc $victim ]
}


#
#	proc ::AI::ModAgro { npc victim }
#
# Hook into this procedure to prevent aggro. In your hooked code, you can
# return 0 or have no return, but don't ever return 1.
#
proc ::AI::ModAgro { npc victim } {
	return 1
}


#
# prevent aggro above specified level difference
#
if { [ llength $::AI::NOAGGRO_LEVELDIFF ] } {
	::Custom::HookProc "::AI::ModAgro" {
		if { [ ::GetLevel $victim ] - [ ::GetLevel $npc ] > $::AI::NOAGGRO_LEVELDIFF } {
			return 0
		}
	}
}
