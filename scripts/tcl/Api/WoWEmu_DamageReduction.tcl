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
# Name:		WoWEmu_DamageReduction.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#    proc ::WoWEmu::DamageReduction { player mob armor }
#
# uncomment this one if you use Stats System
#
proc ::WoWEmu::DamageReduction { player mob armor } {
    if {[::Balance::Hit $player $mob] == 1} { return 1 }
    set armor [::Balance::Armor $player $armor]

    set gmlvl 255
    set maxlvl 60
    set maxdif 8
    set mindif 18
    set moblvl [::GetLevel $mob]
    set plrlvl [::GetLevel $player]
    set entry [::GetEntry $mob]
    set object [::GetObjectType $mob]

    if {$maxlvl < 60} {set maxlvl 60}
    if {$plrlvl >= $gmlvl} {return 1}
    if {$plrlvl > $maxlvl} {set plrlvl $maxlvl}
    if {$moblvl > 60} {set moblvl 60}

    set dif [expr {$plrlvl-$moblvl}]
    set bonus [expr {$dif/500.0}]
    if {$bonus < 0 } {set bonus 0}

    if {$object != 4} {
        set damage_list [join [::GetScpValue "creatures.scp" "creature $entry" "damage"]]
        set rnd [expr {int(rand()*2)}]
        if {$damage_list != ""} {
            list $damage_list
            set dmg [lindex $damage_list $rnd]
        } else {
            set dmg 1
        }
        set dr [expr {($armor*1.0)/($armor+400.0+85*$moblvl+($dmg*25))}]
    } else {
        set dr [expr {($armor*1.0)/($armor+400.0+85*$moblvl)}]
    }
    set dr [expr {$dr+$bonus}]

    if {$moblvl >= [expr {$plrlvl + $maxdif}]} {set dr [expr {($dr*1.15)+($plrlvl/200.0)-0.8}]}
    if {$plrlvl >= [expr {$moblvl + $mindif}]} {set dr [expr {($plrlvl/100.0)+($dr*0.25)+0.05}]}

    set dr [::Balance::Dr $player $mob $dr]
    return $dr
}




#
#	proc ::WoWEmu::ModDR { player mob armor dr }
#
# Hook into this procedure to modify the damage reduction ($dr)
#
proc ::WoWEmu::ModDR { player mob armor dr } {
	if { $dr > $::WoWEmu::MAX_DAMAGE_REDUCTION } {
		set dr $::WoWEmu::MAX_DAMAGE_REDUCTION
	}

	return $dr
}




#
# cast spells while being in melee range (On Damage method)
#
if { $::AI::MELEE_CAST_METHOD == 1 } {
	::Custom::HookProc ::WoWEmu::DamageReduction {
		if { [ set entry [ ::GetEntry $mob ] ] && rand() < $::AI::MELEE_CAST_RATE } {
			set aiscript [ ::Custom::GetCreatureScp $entry "aiscript" ]

			if { [ info procs "::${aiscript}::CanCast" ] == "" } {
				set aiscript "AI"
			}

			if { ! [ string is false [ set spellid [ ::${aiscript}::CanCast $mob $player ] ] ] && ! [ ::CastSpell $mob $player $spellid ] } {
				set ::AI::CastTime($mob,[ ::AI::GetBaseSpell $spellid ]) 0
			}
		}
	}
}

