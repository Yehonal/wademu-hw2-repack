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
# Name:		WoWEmu_OnPlayerResurrect.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#

#
#    proc ::WoWEmu::OnPlayerResurrect { player }
#
proc ::WoWEmu::OnPlayerResurrect { player } {

##testing soulstone
        set ss [GetPos $player]
    if { [GetQFlag $player soulstone] == 1 } {
        set PName [GetName $player]
        if {([file exists "data/soulstone/teleport/$PName"] == 1) } {
            set tfile [open "data/soulstone/teleport/$PName" r]
            set lastvol [gets $tfile]
            close $tfile
        }
        ::ClearQFlag $player IsDead
        set m_r [lindex $lastvol 0]
        set x_r [lindex $lastvol 1]
        set y_r [lindex $lastvol 2]
        set z_r [lindex $lastvol 3]
        Teleport $player $m_r $x_r+1 $y_r+1 $z_r+1
        ::ClearQFlag $player soulstone
        puts "QFlag Cleared!"
        return
    }
##end soulstone

    ::ClearQFlag $player IsDead
}
