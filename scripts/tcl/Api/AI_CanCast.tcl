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
# Name:		AI_CanCast.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
# Contributions from Ata & Ellessar.
#
#


#
#	array set ::AI::SpellData
#
variable ::AI::SpellData


#
#	variable ::AI::MaxLevel
#
variable ::AI::MaxLevel 60


#
#	variable ::AI::NoSpell
#	spell used to allow mobs to unaggro
#
variable ::AI::NoSpell 6603


#
#	proc ::AI::CanCast { npc victim }
#
proc ::AI::CanCast { npc victim } {
	set entry [ ::GetEntry $npc ]
	set npclvl [ ::GetLevel $npc ]
	set type [ ::GetCreatureType $npc ]
	set family [ ::Custom::GetCreatureScp $entry "family" ]
	set level_cast 0

	## Based on Spell
	set spell_list [ ::Custom::GetCreatureScp $entry "spell" ]

	## Based on Family
	if { ! [ llength $spell_list ] } {
		switch -- $family {
			3 { ## Spider
				if { $type != 3 } {
					set spell_list "4940 15471 4286 16432"
					## Spider Poison, Enveloping Web, Poisonous Spit, Plague Mist
					set level_cast 1
				}
			}
			7 { ## Bird
				if { $type != 7 } {
					set spell_list "5708 23147"
					## Swoop, Dive
					set level_cast 1
				}
			}
			16 {## Voidwalker
				set spell_list "10230 16583"
				## Frost Nova, Shadow Shock, Consuming Shadows
			}
			20 {## Scorpion
				set spell_list "5416 6411 3609"
				## Venom Sting, Scorpid Poison, Paralysing Poison
				set level_cast 1
			}
			1 { ## Wolf
				set spell_list "5781 13692 3150"
				## Threatening Growl, Dire Growl, Rabies
				set level_cast 1
			}
			9 { ## Gorilla
				set spell_list "5568 3604"
				## Trample, Tendon Rip
			}
			8 { ## Crab
				if { $type != 8 } {
					set spell_list "4159 4246"
					## Tight Pinch, Clenched Pinchers
				}
			}
			4 { ## Bear
				set spell_list "5781 17261"
				## Threatening Growl, Bite
				set level_cast 1
			}
			5 { ## Boar
				set spell_list "4102 3385"
				## Gore, Boar Charge
				set level_cast 1
			}
		}
	}

	## Based on Type
	if { ! [ llength $spell_list ] } {
		switch -- $type {
			2 { ## Dragon
				if { [ lindex [ ::GetPos $npc ] 0 ] > 1 } {
					set spell_list "20228"
				} else {
					set spell_list "8873 9573 16390 16396 20712 20712"
				}
				set level_cast 1
			}
			3 { ## Demon
				set spell_list "348 686 172 1454 695 172 707 1120 980 689 6222 705 5676 1094 1088 5740 699 6223 5138 8288 17919 1106 6217 2941 17920 6219 7648 6226 7641 7651 11711 11665 6789 11672 11661 11668 17924 11678"

				if { $npclvl > $::AI::MaxLevel } {
					set npclvl $::AI::MaxLevel
				}

				set end [ expr { int( $npclvl / ( $::AI::MaxLevel + 1. ) * [ llength $spell_list ] ) } ]
				set start [ expr { $end - 10 } ]
				set spell_list [ lrange $spell_list $start $end ]
			}
			7 { ## Humanoid
				if { $::AI::HUMANOID_SAY } {
					set plrlvl [ ::GetLevel $victim ]
					set lvldiff [ expr { $plrlvl - $npclvl } ]

					if { 30 * rand() + $lvldiff < 9 } {
						set sayings [ ::Texts::Get "humanoid_sayings" ]
						::AI::MobSay $npc 0 [ format [ lindex $sayings [ expr { int( [ llength $sayings ] * rand() ) } ] ] [ ::Custom::GetName $victim ] ]
					} else {
						::AI::MobSay $npc 0 ""
					}
				}
				set rnd [ expr { rand() } ]
				if { [ ::Custom::GetCreatureScp $entry "maxmana" ] } {
					if { $rnd < .7 } {
						set spell_list "2136 2136 2137 2138 8412 8413 10197 10199"
						#set spell_list "133 133 143 145 3140 8400 8401 8402 10148 10149 10150 10151"
					} elseif { $rnd < .8 && [ ::Distance $npc $victim ] <= 5 } {
						set spell_list "0 122 865 6131 10230"
					} else {
						set spell_list "0 120 8492 10159 10160 10161"
						#set spell_list "116 116 205 837 7322 8406 8407 8408 10179 10180 10181"
					}
				} else {
					if { $rnd < .1 } {
						set spell_list "12169"
					} elseif { $rnd < .4 && [ ::Distance $npc $victim ] <= 5 } {
						set spell_list "5164"
					} else {
						set spell_list "12170 19130"
					}
				}

				set level_cast 1
			}
			4 { ## Elemental
				if { $npclvl >= 70 } {
					set spell_list "20228 19798"
				} else {
					set spell_list "686 172 1454 695 172 707 1120 980 689 6222 705 5676 1094 1088 5740 699 6223 5138 8288 17919 1106 6217 14532 17920 6219 7648 6226 7641 7651 11711 15091 11665 6789 11672 11661 11668 17924 11678"
				}
			}
			6 { ## Undead
				if { $npclvl > 60 } {
					set spell_list "20603"
				} else {
					set spell_list "686 686 695 705 1088 16583 17439 17234 17289 19460"
					#set spell_list "686 686 695 705 1088 1106 7641 11659 11660 11661"
				}
			}
			9 { ## Mechanical
				set spell_list "9483 91 12021 11837 8277 403 474"
			}
			10 {## Unknown  eliminato trackinghound(9515)
				set spell_list "11975 12001 12038 17009"
			}
			1 { ## Beast
				set spell_list "0 24187 24187 1604"
				set level_cast 1
			}
		}
	}

	if { [ llength $spell_list ] } {
		if { $level_cast } {

			if { $npclvl > $::AI::MaxLevel } {
				set npclvl $::AI::MaxLevel
			}

			set spellid [ lindex $spell_list [ expr { int( $npclvl / ( $::AI::MaxLevel + 1. ) * [ llength $spell_list ]) } ] ]
		} else {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ]) } ] ]
		}

		return [ ::AI::Cast $npc $victim $spellid ]
	}

	return $::AI::NoSpell
}


#
#	proc ::AI::MobSay { npc lang msg args }
#
# prevent mobs from talking too much
#
proc ::AI::MobSay { npc lang msg args } {
	set entry [ ::GetEntry $npc ]
	set time [ clock seconds ]

	if { ! [ info exists ::AI::HasSaid($entry) ] || $time - $::AI::HasSaid($entry) > 300 } {
		if { $msg != "" } {
			::Say $npc $lang $msg
		}

		set ::AI::HasSaid($entry) $time
	}
}


#
#	proc ::AI::GetBaseSpell { spellid }
#
# get rank 1 of a given spell if any
#
proc ::AI::GetBaseSpell { spellid } {
	variable BaseSpells

	if { ! [ info exists BaseSpells($spellid) ] } {
		set basespell $spellid

		while { [ string is digit -strict [ set reqspell [ ::GetScpValue "spellcost.scp" "spell $basespell" "reqspell" ] ] ] } {
			set basespell $reqspell
		}

		set BaseSpells($spellid) $basespell
	}

	return $BaseSpells($spellid)
}


#
#	proc ::AI::VictimIsEscaping { }
#
# determine whether the victim is escaping (for usage in CanCasts)
#
proc ::AI::VictimIsEscaping { } {
	expr { [ uplevel 2 namespace current ] == "" }
}


#
#	proc ::AI::Check { npc victim spellid }
#
# check spell cool down, number of attackers, range, outdoors
#
proc ::AI::Check { npc victim spellid } {
	set basespell [ ::AI::GetBaseSpell $spellid ]
	foreach { cast_time cooldown duration range self } [ expr { [ info exists ::AI::SpellData($spellid) ] ? [ lrange $::AI::SpellData($spellid) 0 4 ] : { 1 20 0 40 0 } } ] {}

	# check whether this spell is not ready to be cast again
	set recast_time [ expr { $cooldown + $cast_time * 2 + ( $duration < 0 ? 3600 : $duration ) + 1 } ]
	if { [ info exists ::AI::CastTime($npc,$basespell) ] && [ clock seconds ] - [ set ::AI::CastTime($npc,$basespell) ] < ( $recast_time > 10 ? $recast_time : 10 ) } {
		return 0
	}

	# check whether the number of attackers is too high for the cast time
	if { $cast_time > .5 && $cast_time * ( [ ::GetHealthPCT $npc ] > 90 ? 10 : [ array size ::Honor::Attacked::$npc ] ) >= $::AI::CAST_TIME_SENSIVITY } {
		return 0
	}

	# check whether the victim is too far
	if { $range && [ ::Distance $npc $victim ] > $range } {
		return 0
	}

	# check whether the spell is only useable outdoors
	if { [ lsearch { 339 16689 } $basespell ] >= 0 && [ lsearch { 0 1 30 209 309 451 489 529 } [ lindex [ ::GetPos $npc ] 0 ] ] < 0 } {
		return 0
	}

	return $spellid
}


#
#	proc ::AI::Cast { npc victim spellid }
#
# used before casting a spell
#
proc ::AI::Cast { npc victim spellid } {
	if { ! $spellid || ! [ ::AI::Check $npc $victim $spellid ] } {
		return $::AI::NoSpell
	}

	set basespell [ ::AI::GetBaseSpell $spellid ]
	set ::AI::CastTime($npc,$basespell) [ clock seconds ]

	# check and cast spell on self if applicable
	if { [ info exists ::AI::SpellData($spellid) ] && [ lindex $::AI::SpellData($spellid) 4 ] && [ ::CastSpell $npc $npc $spellid ] } {
		return $::AI::NoSpell
	}

	return $spellid
}


#
#	proc ::AI::LevelCast { npc spell_lists priority_list ... }
#
# Determines which spell to use based on level
#
proc ::AI::LevelCast { npc victim spell_lists args } {
	set npclvl [ ::GetLevel $npc ]

	if { $npclvl > $::AI::MaxLevel } {
		set npclvl $::AI::MaxLevel
	}

	foreach spell_list $args {
		set spellid [ lindex $spell_list [ expr { int( $npclvl / ( $::AI::MaxLevel + 1. ) * [ llength $spell_list ] ) } ] ]
		if { [ ::AI::Check $npc $victim $spellid ] } {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}

	set spell_list [ lindex $spell_lists [ expr { int( $npclvl / ( $::AI::MaxLevel + 1. ) * [ llength $spell_lists ] ) } ] ]
	set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]

	return [ ::AI::Cast $npc $victim $spellid ]
}


#
#	proc ::AI::LoadSpellData { npc victim }
#
# load spell data from a file
#
proc ::AI::LoadSpellData { { filename "" } } {
	variable SPELLDATA_FILE
	variable SpellData

	if { ! [ info exists SPELLDATA_FILE ] || $SPELLDATA_FILE == "" } {
		set SPELLDATA_FILE "scripts/spelldata.txt"
	}

	if { $filename == "" } {
		set filename $SPELLDATA_FILE
	}

	unset -nocomplain SpellData
	set handle [ open $filename ]

	while { [ gets $handle line ] >= 0 } {
		foreach { spellid data } [ ::Custom::DropNoise $line ] {
			set SpellData($spellid) $data
		}
	}

	close $handle
}


#
# Initialization
#
::AI::LoadSpellData

