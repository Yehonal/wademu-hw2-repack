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
# Name:		SpellEffects_Script.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	variable ::SpellEffects::ScriptAddItem
#
# array of spells that add items
#
variable ::SpellEffects::ScriptAddItem
array set ::SpellEffects::ScriptAddItem {
	5699	5509
	6201	5512
	6202	5511
	11729	5510
	11730	9421
}


#
#	proc ::SpellEffects::SPELL_EFFECT_SCRIPT_EFFECT { to from spellid }
#
# modified to allow adding script effects from scripts using the command
# "::Custom::AddSpellScript proc spell_list"
#
proc ::SpellEffects::SPELL_EFFECT_SCRIPT_EFFECT { to from spellid } {
	variable ScriptEffects

	if { [ info exists ScriptEffects($spellid) ] } {
		foreach proc $ScriptEffects($spellid) {
			$proc $to $from $spellid
		}
	} else {
		puts "[ ::Texts::Get "script_without_case" $spellid ]"
	}
}


#
#	proc ::SpellEffects::ScriptAddItem { to from spellid }
#
# proc for spells that add items
#
proc ::SpellEffects::ScriptAddItem { to from spellid } {
	::AddItem $to $::SpellEffects::ScriptAddItem($spellid)
}

::Custom::AddSpellScript "::SpellEffects::ScriptAddItem" [ array names ::SpellEffects::ScriptAddItem ]


#
#	proc ::SpellEffects::ScriptLogin { to from spellid }
#
# this will allow to perform actions at login (a patched spell 836 is
# required).
#
proc ::SpellEffects::ScriptLogin { to from spellid } {
	::Custom::DbArray set ::Custom::PlayerID [ list [ string tolower [ ::GetName $to ] ] $to ]
}

::Custom::AddSpellScript "::SpellEffects::ScriptLogin" 836

