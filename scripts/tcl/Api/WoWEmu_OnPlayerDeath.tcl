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
# Name:		WoWEmu_OnPlayerDeath.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#    proc ::WoWEmu::OnPlayerDeath { player killer }
#
proc ::WoWEmu::OnPlayerDeath { player killer } {

    ::SetQFlag $player IsDead


##testing soulstone
if { [GetQFlag $player soulstone] == 1 } {
        set PName [GetName $player]
        set currenttime [clock seconds]
        if {([file exists "data/soulstone/$PName"] == 1) } {
            set tfile [open "data/soulstone/$PName" r]
            set lastvol [gets $tfile]
            close $tfile
        }
        set diff [expr $currenttime - $lastvol]
        #if {$diff >1800} {Say $player 0 "Soulstone time expired!"}
        if {$diff <1800} {
            set ps [GetPos $player]
            set Tadd [open "data/soulstone/teleport/$PName" w]
            puts $Tadd $ps
            close $Tadd
            puts "Position saved:"
            puts $ps
            Resurrect $player
            set ds [GetBindpoint $player]
            set map [lindex $ds 0]
            set x [lindex $ds 1]
            set y [lindex $ds 2]
            set z [lindex $ds 3]
            Teleport $player $map $x $y $z
            return
        }
    }
    ::ClearQFlag $killer Attack
    ::ClearQFlag $player Attack
##end soulstone
}