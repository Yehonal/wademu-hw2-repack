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
# Name:		WoWEmu_CalcReputation.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::WoWEmu::CalcReputation { killer victim }
#
proc ::WoWEmu::CalcReputation { killer victim } {
	::SetQFlag $victim IsDead

	if { [ ::Distance $killer $victim ] > $::WoWEmu::MAX_DISTANCE } {
		return 0
	}

	set repu [ expr { ( [ ::GetLevel $victim ] - [ ::GetLevel $killer ] ) * 10 + 100 } ]

	if { $repu < 0 } {
		set repu 10
	}

	::AddReputation $killer $victim -$repu
}

