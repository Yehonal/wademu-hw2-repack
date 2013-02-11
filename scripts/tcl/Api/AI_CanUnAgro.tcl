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
# Name:		AI_CanUnAgro.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::AI::CanUnAgro { npc victim }
#
proc ::AI::CanUnAgro { npc victim } {
	if { [ ::Distance [ expr { [ set spawn [ ::GetLinkObject $npc ] ] ? $spawn : $victim } ] $npc ] < $::AI::UNAGGRO_DIST } {
		return 0
	}

	return [ ::AI::ModUnAgro $npc $victim ]
}


#
#	proc ::AI::ModUnAgro { npc victim }
#
# Hook into this procedure to maintain aggro. In your hooked code, you can
# return 0 or have no return, but don't ever return 1.
#
proc ::AI::ModUnAgro { npc victim } {
	return 1
}


#
# cast spells while being in melee range (On UnAgro method)
#
if { $::AI::MELEE_CAST_METHOD >= 2 } {
	set ::AI::MELEE_CAST_RATE [ expr { $::AI::MELEE_CAST_RATE / 4. } ]

	::Custom::HookProc ::AI::CanUnAgro {
		# spell casting in melee range
		if { rand() < $::AI::MELEE_CAST_RATE && [ ::GetHealthPCT $npc ] } {
			set aiscript [ ::Custom::GetCreatureScp [ ::GetEntry $npc ] "aiscript" ]

			if { [ info procs "::${aiscript}::CanCast" ] == "" } {
				set aiscript "AI"
			}

			if { ! [ string is false [ set spellid [ ::${aiscript}::CanCast $npc $victim ] ] ] && ! [ ::CastSpell $npc $victim $spellid ] } {
				set ::AI::CastTime($npc,[ ::AI::GetBaseSpell $spellid ]) 0
			}
		}
	}
}

