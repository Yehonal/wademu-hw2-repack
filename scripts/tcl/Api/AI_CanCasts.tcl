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
# Name:		AI_CanCasts.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
# Specially based on KingBiggie's AI.tcl, contributions from Ata & Ellessar.
#
#


#
#	proc ::*::CanCast { npc victim }
#

#-Generic Humanoid AI-#

#
#	Generic Hunter AI for:	Hunters, Hideskinners, Headhunters, Beastmasters,
#
#	Note: set bounding radius to 10 or up to 30 for them to use Shots.
#
namespace eval ::HumanoidHunter {
	proc CanCast { npc victim } {
		# Serpent Sting(Rank 1), Arcane Shot(Rank 1)
		# Serpent Sting(Rank 2), Arcane Shot(Rank 2), Distract Shot(Rank 1), Concussive Shot
		# Serpent Sting(Rank 3), Arcane Shot(Rank 3), Distract Shot(Rank 2), Concussive Shot, Aimed Shot(Rank 1), Multi-Shot(Rank 1)
		# Serpent Sting(Rank 4), Arcane Shot(Rank 4), Distract Shot(Rank 3), Concussive Shot, Aimed Shot(rank 2), Multi-shot(Rank 2), Scorpid Sting(Rank 1)
		# Serpent Sting(Rank 5), Arcane Shot(Rank 5), Hunter's Mark(Rank 3), Distract Shot(Rank 4), Concussive Shot, Aimed Shot(Rank 3), Multi-Shot(Rank 2), Scorpid Sting(Rank 2), Viper Sting(Rank 1), Volley(Rank 1)
		# Serpent Sting(Rank 6), Serpent Sting(Rank 7), Arcane Shot(Rank 6), Arcane Shot(Rank 7), Distract Shot(Rank 5),Concussive Shot, Aimed Shot(Rank 4), Multi-Shot(Rank 3), Scorpid Sting(Rank 3), Viper Sting(Rank 2), Volley(Rank 2)
		# Serpent Sting(Rank 8), Arcane Shot(Rank 8), Distract Shot(Rank 6), Concussive Shot, Aimed Shot(Rank 5), Aimed Shot(Rank 6), Multi-Shot(Rank 4), Scorpid Sting(Rank 4), Viper Sting(Rank 3), Volley(Rank 3)
		set spell_lists {
			"1978 3044"
			"13549 14281 20736 5116"
			"13550 14282 14274 5116 19434 2643"
			"3551 14283 15629 5116 20900 14288 3043"
			"13552 14284 15630 5116 20901 14288 14275 3034 1510"
			"13553 13554 14285 14286 15631 5116 20902 14289 14276 14279 14294"
			"13555 14287 15632 5116 20903 20904 14290 14277 14280 14295"
		}

		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

#
#	Generic Shadowhunter AI for:	Shadowhunters, Shadowstalkers
#
#	Note: set bounding radius to 10 or up to 30 for them to use Shots.
#
namespace eval ::HumanoidShadowHunter {
	proc CanCast { npc victim } {
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 1)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 2)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 3)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 4), Scorpid Sting(Rank 1)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 5), Scorpid Sting(Rank 2), Viper Sting(Rank 1)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 7), Scorpid Sting(Rank 3), Viper Sting(Rank 2)
		# Shadow Word: Pain, Shadow Bolt, Serpent Sting(Rank 8), Scorpid Sting(Rank 4), Viper Sting(Rank 3)
		set spell_lists {
			"589 695 1978"
			"594 705 13549"
			"970 1106 13550"
			"992 7641 3551 3043"
			"2767 11659 13552 14275 3034"
			"10892 11660 13554 14276 14279"
			"10893 11661 13555 14277 14280"
		}

		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}


#
#	Generic Mage AI for:	Mages, Magus, Wizards, Spellscribes, Sorcerors, Spellcrafters
#
#
#
namespace eval ::HumanoidMage {
	proc CanCast { npc victim } {
		# Fireball(Rank 1), Frostbolt(Rank 1)
		# Fireball(Rank 2), Fireball(Rank 3), Fireblast(Rank 1), Frostbolt(Rank 2), Frost Nova(Rank 1), Blizzard(Rank 1), Arcane Explosion(Rank 1)
		# Fireball(Rank 4), Fireball(Rank 5), Fireblast(Rank 2), Frostbolt(Rank 3), Frost Nova(Rank 1), Cone of Cold(Rank 1), Blizzard(Rank 2), Arcane Explosion(Rank 2)
		# Fireball(Rank 6), Frostbolt(Rank 4), Frostbolt(Rank 5), Fireblast(Rank 3), Fireblast(Rank 4), Frost Nova(Rank 2), Cone of Cold(Rank 2), Blizzard(Rank 3), Arcane Explosion(Rank 3)
		# Fireball(Rank 8), Frostbolt(Rank 6), Frostbolt(Rank 7), Fireblast(Rank 5), Frost Nova(Rank 3), Cone of Cold(Rank 3), Blast Wave(Rank 2), Blizzard(Rank 4), Arcane Explosion(Rank 4)
		# Fireball(Rank 9), Frostbolt(Rank 8), Frostbolt(Rank 9), Fireblast(Rank 6), Frost Nova(Rank 3), Cone of Cold(Rank 4), Blast Wave(Rank 3), Blizzard(Rank 5), Arcane Explosion(Rank 5)
		# Fireball(Rank 11), Frostbolt(Rank 10), Fireblast(Rank 7), Frost Nova(Rank 4), Cone of Cold(Rank 5), Blast Wave(Rank 4), Blizzard(Rank 6), Arcane Explosion(Rank 6)
		set spell_lists {
			"133 116"
			"143 145 2136 205 122 10 1449"
			"3140 8400 2137 837 122 120 6141 8437"
			"8401 7322 8406 2138 8412 865 8492 8427 8438"
			"10148 8407 8408 8413 6131 10159 13018 10185 8439"
			"10149 10179 10180 10197 6131 10160 13019 10186 10201"
			"10151 10181 10199 10230 10161 13020 10187 10202"
		}

		# Frost Armor / Ice Armor
		set buff_list_armor "168 7300 7301 7302 7320 10219 10220"

		# Mana Shield
		set buff_list_mana_shield "0 1463 8494 8495 10191 10192 10193"

		set mobh [ ::GetHealthPCT $npc ]

		if { $mobh > 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_armor ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_armor $buff_list_mana_shield ]
		}
	}
}

#
#	Generic Warlock AI for:	Soul Eaters, Warlocks, Conjurors, Summoners, Dark Weavers, Adepts, Acolytes
#					Dreadweavers, Occultists
#
#
namespace eval ::HumanoidWarlock {
	proc CanCast { npc victim } {
		# Immolate(Rank 1), Corruption(Rank 1), Shadow Bolt(Rank 1)
		# Shadow Bolt(Rank 2), Life Tap(Rank 1), Curse of Agony(Rank 1), Fear(Rank 1), Immolate(Rank 2), Corruption(Rank 1)
		# Shadow Bolt(Rank 3), Corruption(Rank 2), Curse of Recklesness(Rank 1), Drain Life(Rank 1), Life Tap(Rank 2), Curse of Agony(Rank 2)
		# Immolate(Rank 3), Shadow Bolt(Rank 4), Shadow Bolt(Rank 5), Drain Life(Rank 2), Corruption(Rank 3), Drain Mana(Rank 1), Life Tap(Rank 3), Curse of Agony(Rank 3), Curse of Recklessness(Rank 2)
		# Shadow Bolt(Rank 6), Curse of Exhaustion, Drain Life(Rank 3), Immolate(Rank 4), Fear(Rank 2), Corruption(Rank 4), Drain Mana(Rank 2), Life Tap(Rank 4), Curse of Agony(Rank 4)
		# Shadow Bolt(Rank 7), Immolate(Rank 5), Drain Life(Rank 4), Curse of Recklesness(Rank 3), Death Coil(Rank 1), Corruption(Rank 5), Curse of Shadow(Rank 1), Drain Life(Rank 5), Life Tap(Rank 5), Curse of Agony(Rank 5)
		# Shadow Bolt(Rank 8), Shadow Bolt(Rank 9), Death Coil(Rank 3), Curse of Agony(Rank 6), Fear(Rank 3), Life Tap(Rank 6), Curse of Recklesness(Rank 4), Drain Mana(Rank 4), Drain Life(Rank 6), Corruption(Rank 6), Death Coil(Rank 2), Immolate(Rank 6)
		set spell_lists {
			"348 172 686"
			"695 1454 980 5782 707 172"
			"705 6222 704 689 1455 1014"
			"1094 1088 1106 699 6223 5138 1456 6217 7658"
			"7641 18223 709 2941 6213 7648 6226 11687 11711"
			"11659 11665 7651 7659 6789 11671 17862 11699 11688 11712"
			"11660 11661 17926 11713 6215 11689 11717 11704 11700 11672 17925 11667"
		}

		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

#
#	Generic Priest AI for:	Priests, Mystics, Healers, Oracles, Seers
#
#
#
namespace eval ::HumanoidPriest {
	proc CanCast { npc victim } {
		# Shadow Word: Pain(Rank 1), Smite(Rank 1)
		# Shadow Word: Pain(Rank 2), Smite(Rank 2), Mindblast(Rank 1)
		# Shadow Word: Pain(Rank 3), Smite(Rank 3), Mindblast(Rank 2), Psychic Scream(Rank 1)
		# Shadow Word: Pain(Rank 4), Smite(Rank 4), Mindblast(Rank 3), Mindblast(Rank 4), Psychic Scream(Rank 1)
		# Shadow Word: Pain(Rank 5), Smite(Rank 5), Mindblast(Rank 5), Psychic Scream(Rank 1)
		# Shadow Word: Pain(Rank 6), Smite(Rank 6), Smite(Rank 7), Mindblast(Rank 6), Mindblast(Rank 7), Psychic Scream(Rank 1)
		# Shadow Word: Pain(Rank 7), Shadow Word: Pain(Rank 8), Smite(Rank 8), Mindblast(Rank 8),  Mindblast(Rank 9), Psychic Scream(Rank 1)
		set spell_lists {
			"589 585"
			"594 591 8092"
			"970 598 8102 8122"
			"992 984 8103 8104 8122"
			"2767 1004 8105 8122"
			"10892 6060 10933 8106 10945 8122"
			"10893 10894 10934 10946 10947 8122"
		}

		# Power Word: Shield
		set buff_list_shield "17 592 600 3747 6066 10899 10900"

		# Heal
		set buff_list_heal "2052 2053 9472 9474 10915 10916 10917"

		# Renew
		set buff_list_renew "0 139 6074 6075 6078 10927 10929"

		set mobh [ ::GetHealthPCT $npc ]

		if { $mobh > 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_shield ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_renew $buff_list_heal $buff_list_shield ]
		}
	}
}

#
#	Generic AI for Witch Doctors, Spiritchasers, Soothsayers, Headshrinkers
#
#
#
namespace eval ::HumanoidWitchDoctor {
	proc CanCast { npc victim } {
		# Shadow Word: Pain(Rank 1), Hex, Earth Shock(Rank 1)
		# Shadow Word: Pain(Rank 2), Mindblast(Rank 1), Hex, Earth Shock(Rank 2), Voodoo Hex(Rank 1)
		# Shadow Word: Pain(Rank 3), Mindblast(Rank 2), Hex, Earth Shock(Rank 3)
		# Shadow Word: Pain(Rank 4), Mindblast(Rank 4), Hex, Earth Shock(Rank 4)
		# Shadow Word: Pain(Rank 5), Mindblast(Rank 5), Hex, Earth Shock(Rank 5)
		# Shadow Word: Pain(Rank 6), Mindblast(Rank 7), Hex, Earth Shock(Rank 6)
		# Shadow Word: Pain(Rank 8), Mindblast(Rank 9), Hex, Earth Shock(Rank 7)
		set spell_lists {
			"589 24053 8042"
			"594 8092 24053 8044 8277"
			"970 8102 24053 8045"
			"992 8104 24053 8046"
			"2767 8105 24053 10412"
			"10892 10945 24053 10413"
			"10894 10947 24053 10414"
		}

		# Healing Wave
		set buff_list_heal "331 332 8004 8008 8010 10466 10468"

		set mobh [ ::GetHealthPCT $npc ]

		if { $mobh <= 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_heal ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists ]
		}
	}
}

#
#	Generic Shadowpriest AI for:	Shadow Priests, Necromancers, Shadow Mages, Shadowcasters, Darkcasters, Occultists,
#						Death Speakers
#
#
namespace eval ::HumanoidShadowPriest {
	proc CanCast { npc victim } {
		# Shadow Word: Pain(Rank 1)
		# Mind Flay(Rank 1), Shadow Word: Pain(Rank 2), Mindblast(Rank 1)
		# Mind Flay(Rank 2), Shadow Word: Pain(Rank 3), Mindblast(Rank 2), Psychic Scream(Rank 1)
		# Silence, Mind Flay(Rank 3), Shadow Word: Pain(Rank 4), Mindblast(Rank 3), Mindblast(Rank 4), Psychic Scream(Rank 1)
		# Silence, Mind Flay(Rank 4), Shadow Word: Pain(Rank 5), Mindblast(Rank 5), Psychic Scream(Rank 1)
		# Silence, Mind Flay(Rank 5), Shadow Word: Pain(Rank 6), Mindblast(Rank 6), Mindblast(Rank 7), Psychic Scream(Rank 1)
		# Silence, Mind Flay(Rank 6), Shadow Word: Pain(Rank 7), Shadow Word: Pain(Rank 8), Mindblast(Rank 8),  Mindblast(Rank 9), Psychic Scream(Rank 1)
		set spell_lists {
			"589"
			"15407 594 8092"
			"17311 970 8102 8122"
			"15487 17312 992 984 8103 8104 8122"
			"15487 17313 2767 8105 8122"
			"15487 17314 10892 8106 10945 8122"
			"15487 18807 10893 10894 10946 10947 8122"
		}

		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

#
#	Generic Holy Priest AI for:	Priests, Chaplains, Monks, Diviner
#
#
#
namespace eval ::HumanoidHolyPriest {
	proc CanCast { npc victim } {
		# Smite(Rank 1)
		# Smite(Rank 2)
		# Smite(Rank 3), Holy Nova(Rank 1), Holy Fire(Rank 2)
		# Smite(Rank 4), Holy Nova(Rank 2), Holy Fire(Rank 4)
		# Smite(Rank 5), Holy Nova(Rank 3), Holy Fire(Rank 6)
		# Smite(Rank 7), Holy Nova(Rank 3), Holy Fire(Rank 7)
		# Smite(Rank 8), Holy Nova(Rank 3), Holy Fire(Rank 8)
		set spell_lists {
			"585"
			"591"
			"598 15237 15262"
			"984 15430 15264"
			"1004 15431 15266"
			"10933 15431 15267"
			"10934 15431 15261"
		}

		# Power Word: Shield
		set buff_list_shield "17 592 600 3747 6066 10899 10900"

		# Heal
		set buff_list_heal "2052 2053 9472 9474 10915 10916 10917"

		# Renew
		set buff_list_renew "0 139 6074 6075 6078 10927 10929"

		set mobh [ ::GetHealthPCT $npc ]

		if { $mobh > 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_shield ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_heal $buff_list_shield $buff_list_renew ]
		}
	}
}


#
#	Generic Druid AI for:	Druids
#
#
#
namespace eval ::HumanoidDruid {
		proc CanCast { npc victim } {
		# Wrath(Rank 1), Moonfire(Rank 1)
		# Wrath(Rank 2), Moonfire(Rank 2),
		# Wrath(Rank 3), Moonfire(Rank 3), Faerie Fire(Rank 1), Insect Swarm(Rank 1), Starfire(Rank 1)
		# Wrath(Rank 4), Moonfire(Rank 4), Faerie Fire(Rank 2), Insect Swarm(Rank 2), Starfire(Rank 2)
		# Wrath(Rank 5), Moonfire(Rank 5), Faerie Fire(Rank 3), Insect Swarm(Rank 3), Starfire(rank 3), Hurricane(Rank 1)
		# Wrath(Rank 6), Wrath(Rank 7), Moonfire(Rank 6), Moonfire(Rank 7), Faerie Fire(Rank 4), Insect Swarm(Rank 4), Starfire(Rank 4), Hurricane(Rank 2), Barkskin
		# Wrath(Rank 8), Moonfire(Rank 8), Moonfire(Rank 9), Faerie Fire(Rank 4), Insect Swarm(rank 5), Starfire(rank 5), Starfire(rank 6), Hurricane(Rank 3), Barkskin
		set spell_lists {
			"5176 8921"
			"5177 8924"
			"5178 8925 770 5570 2912"
			"5179 8926 778 24974 8949"
			"5180 8927 9749 24975 8950 16914"
			"6780 8905 8928 8929 9907 24976 8951 17401 22812"
			"9912 9833 9834 9907 24977 9875 9876 17402 22812"
		}

		# Thorns
		set buff_list_thorns "467 782 1075 8914 9756 9910 9910"

		# Nature's Grasp
		set buff_list_grasp "16689 16810 16811 16812 16813 17329"

		# Rejuvenation
		set buff_list_reju "774 1058 1430 2090 2091 3627 8910"

		# Healing Touch
		set buff_list_heal "5185 5186 5187 5188 5189 6778 8903"

		# Entangling Roots
		set spell_list_roots "339 1062 5195 5196 9852 9853"

		set mobh [ ::GetHealthPCT $npc ]

		if { [ ::AI::VictimIsEscaping ] } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $spell_list_roots ]
		} elseif { $mobh > 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_thorns $buff_list_grasp ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_reju $buff_list_heal $buff_list_thorns $buff_list_grasp ]
		}
	}
}

#
#	Generic Rogue AI for:	Rogues, Stalkers, Swashbucklers, Bandits, Thieves, Assassins, Pathstalkers, Highwaymen,
#					Footpads, Ambushers, Pirates, Betrayers, Scalpers, Trickster
#
#
namespace eval ::HumanoidRogue {
	proc CanCast { npc victim } {
		# Poison(Rank 1), Kick
		# Poison(Rank 2), Kick
		# Poison(Rank 3), Gouge, Kick
		# Sinister Strike(Rank 1), Backstab(Rank 1), Poison(Rank 4), Cheap Shot, Gouge, Kick
		# Sinister Strike(Rank 2), Backstab(Rank 2), Poison(Rank 5), Cheap Shot, Gouge, Snap Kick
		# Sinister Strike(Rank 3), Backstab(Rank 3), Poison(Rank 6), Cheap Shot, Gouge, Snap Kick
		# Sinister Strike(Rank 4), Backstab(Rank 4), Poison(Rank 7), Cheap Shot, Gouge, Snap Kick
		set spell_lists {
			"13518 15614"
			"16400 15614"
			"12540 15614"
			"14873 7159 8313 6409 12540 15614"
			"15581 15657 13298 6409 12540"
			"15667 15582 16401 6409 12540"
			"19472 22416 13298 6409 12540"
		}

		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

#
#	Generic standard Warrior AI for:	Warriors, Infantry, Guards, Scouts, Bodyguards, Vanguards, Enforcers, Guardians, Vindicators, Avengers,
#							Zealot, Captains
#
#
namespace eval ::HumanoidWarrior {
	proc CanCast { npc victim } {
		# Strike(Rank 1), Rend(Rank 1)
		# Strike(Rank 2), Shield Slam(Rank 1), Rend(Rank 2)
		# Strike(Rank 3), Shield Slam(Rank 2), Revenge(Rank 1), Rend(Rank 3)
		# Strike(Rank 4), Shield Bash(Rank 1), Revenge(Rank 2), Rend(Rank 4)
		# Strike(Rank 5), Cleave(Rank 2), Rend(Rank 5)
		# Strike(Rank 5), Cleave(Rank 3), Rend(Rank 6)
		# Strike(Rank 5), Cleave(Rank 4), Mortal Strike, Rend(Rank 7)
		set spell_lists {
			"11998 18078"
			"13446 8242 11977"
			"13446 15655 12170 13443"
			"14516 11972 19130 13738"
			"15580 15623 14087"
			"15580 15613 16406"
			"15580 15584 13737 17504"
		}
		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

#
#	Generic standard Fury Warrior AI for:	Berserkers, Blood Drinkers, Lords, Warmongers, Butchers, Raiders, Slayers, Myrmidons
#
#
#
namespace eval ::HumanoidFuryWarrior {
	proc CanCast { npc victim } {
		# Strike(Rank 1), Rend(Rank 1)
		# Strike(Rank 2), Rend(Rank 2)
		# Strike(Rank 3), Piercing Howl, Rend(Rank 3)
		# Strike(Rank 4), Cleave(Rank 1), Piercing Howl, Rend(Rank 4)
		# Strike(Rank 5), Cleave(Rank 2), Piercing Howl, Rend(Rank 5)
		# Strike(Rank 5), Cleave(Rank 3), Piercing Howl, Rend(Rank 6)
		# Strike(Rank 5), Cleave(Rank 4), Piercing Howl, Rend(Rank 7)
		set spell_lists {
			"11998 18078"
			"13446 11977"
			"13446 23600 13443"
			"14516 5532 23600 13738"
			"15580 15623 23600 14087"
			"15580 15613 23600 16406"
			"15580 15584 23600 17504"
		}
		# Demoralizing Shout
		set buff_list_demoral "0 0 13730 16244 23511 23511 23511"

		return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_demoral ]
	}
}

#
#	Generic standard Unarmed AI for:	Maulers, Brutes, Thug, Knuckledusters, Henchmen, Ruffians, Rumblers, Smashers
#
#
#
namespace eval ::HumanoidUnarmed {
	proc CanCast { npc victim } {
		# Pummel, Kick
		# Pummel, Kick
		# Pummel, Uppercut, Kick
		# Pummel, Uppercut, Kick
		# Pummel, Uppercut, Low Swipe, Snap Kick
		# Pummel, Uppercut, Low Swipe, Snap Kick
		# Pummel, Uppercut, Low Swipe, Snap Kick
		set spell_lists {
			"19639 11978"
			"19639 15610"
			"12555 10966 15614"
			"12555 10966 15614"
			"15615 10966 8716 15618"
			"15615 10966 8716 15618"
			"15615 10966 8716 15618"
		}
		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}


#
#	Generic Shaman AI for:	Shamans, Geopriests, Geomancers, Totemics
#
#
#
namespace eval ::HumanoidShaman {
		proc CanCast { npc victim } {
		# Lightning Bolt(Rank 1), Earth Shock(Rank 1)
		# Lightning Bolt(Rank 2), Earth Shock(Rank 2), Flame Shock(Rank 1)
		# Lightning Bolt(Rank 3), Earth Shock(Rank 3), Flame Shock(Rank 2)
		# Lightning Bolt(Rank 4), Lightning Bolt(Rank 5), Earth Shock(Rank 4), Flame Shock(Rank 3), Frost Shock(Rank 1)
		# Lightning Bolt(Rank 6), Lightning Bolt(Rank 7), Chain Lightning(Rank 1), Earth Shock(Rank 5), Frost Shock(Rank 2)
		# Earth Shock(Rank 6), Chain Lightning(Rank 2), Chain Lightning(Rank 3), Flame Shock(Rank 4), Lightning Bolt(Rank 8), Frost Shock(Rank 3)
		# Earth Shock(Rank 6), Frost Shock(Rank 4), Lightning Bolt(Rank 9), Flame Shock(Rank 5), Chain Lightning(Rank 4), Lightning Bolt(Rank 10)
		set spell_lists {
			"403 8042"
			"529 8044 8050"
			"548 8045 8052"
			"915 943 8046 8053 8056"
			"6041 10391 421 10412 8056"
			"10413 930 2860 10447 10392 10472"
			"10414 10473 15207 10448 10605 15208"
		}

		# Lightning Shield
		set buff_list_lightning "0 324 325 905 8134 10431 10432"

		# Healing Wave
		set buff_list_heal "331 332 8004 8008 8010 10466 10468"

		set mobh [ ::GetHealthPCT $npc ]
		if { $mobh > 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_lightning ]
		} else {
			return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_heal $buff_list_lightning ]
		}
	}
}

#-Pet AI-#

namespace eval ::WarlockPetSuccubus {
	proc CanCast { npc victim } {
		# Lash of Pain, Seduction
		set spell_lists {
			"7815 6358"
			"7815 6358"
			"7815 6358"
			"7816 6358"
			"11778 6358"
			"11779 6358"
			"11780 6358"
		}
		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}

# compatibility with older creatures.scp
namespace eval ::Succubus { proc CanCast { npc victim } { ::WarlockPetSuccubus::CanCast $npc $victim } }
namespace eval ::succubus { proc CanCast { npc victim } { ::WarlockPetSuccubus::CanCast $npc $victim } }

namespace eval ::WarlockPetFelhunter {
	proc CanCast { npc victim } {
		# Devour Magic, Spell Lock, Tainted Blood
		set spell_lists {
			"19731 19244 19478"
			"19731 19244 19478"
			"19731 19244 19478"
			"19731 19244 19478"
			"19731 19244 19478"
			"19734 19244 19656"
			"19736 19647 19660"
		}
		return [ ::AI::LevelCast $npc $victim $spell_lists ]
	}
}


namespace eval ::WarlockPetImp {
	proc CanCast { npc victim } {
		set spell_lists {
			"7799"
			"7799"
			"7800"
			"7801"
			"7802"
			"11762"
			"11763"
		}

		# Blood Pact
		set buff_list_bloodpact "6307 6307 7804 7805 11766 11767 11767"

		# Fire Shield
		set buff_list_fireshield "0 0 2947 8316 8317 11770 11771"

		return [ ::AI::LevelCast $npc $victim $spell_lists $buff_list_bloodpact $buff_list_fireshield ]
	}
}


namespace eval ::WarlockPetVoidWalker {
	proc CanCast { npc victim } {
		set hp [ ::GetHealthPCT $npc ]
		# Consume Shadows
		set spell_lists {
			"17767"
			"17767"
			"17767"
			"17850"
			"17851"
			"17852"
			"17854"
		}
		if { $hp <= 50 } {
			return [ ::AI::LevelCast $npc $victim $spell_lists ]
		} else {
			return $::AI::NoSpell
		}
	}
}



#-Instances-#

#--Dire Maul--#

namespace eval ::AlzzinTheWildshaper {
	proc CanCast { npc victim } {
		set spell_list "22689 22662 19319"
		# Mangle, Wither, Vicious Bite
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::CaptainKromcrush {
	proc CanCast { npc victim } {
		set spell_list "15708 23511"
		# Mortal Strike, Demoralizing Shout
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ChoRushTheObserver {
	proc CanCast { npc victim } {
		set spell_list "10947 10151"
		# Mind Blast, Fireball
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GuardFengus {
	proc CanCast { npc victim } {
		set spell_list "15580 15655 22572 20691"
		# Strike, Shield Bash, Bruising Blow, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GuardMolDar {
	proc CanCast { npc victim } {
		set spell_list "15580 15655 20691"
		# Strike, Shield Bash, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GuardSlipKik {
	proc CanCast { npc victim } {
		set spell_list "15580 17307 20691"
		# Strike, Knockout, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Hydrospawn {
	proc CanCast { npc victim } {
		set spell_list "22419 22420 22421"
		# Riptide, Submersion, Massive Geyser
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MassiveGeyser {
	proc CanCast { npc victim } {
		set spell_list "22422"
		# Water
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Despawn
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


#
#	Note: Give her bounding radius >10 x <30 so she can shoot
#
namespace eval ::IllyanaRavenoak {
	proc CanCast { npc victim } {
		set spell_list "5116 20904 14290 14295"
		# Concussive Shot, Aimed Shot(Rank 6), Multi-Shot(Rank 4), Volley(Rank 3)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Immolthar {
	proc CanCast { npc victim } {
		set spell_list "16128 15550 22899"
		# Infected Bite, Trample, Eye of Immol'thar
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::EyeOfImmolThar {
	proc CanCast { npc victim } {
		set spell_list "22909"
		# Eye of Immol'thar(Debuff)
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Despawn
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KingGordok {
	proc CanCast { npc victim } {
		set spell_list "15708 24375"
		# War Stomp, Mortal Strike
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Lethtendris {
	proc CanCast { npc victim } {
		set spell_list "11668 14887"
		# Immolate, Shadow Bolt Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::LordHelNurath {
	proc CanCast { npc victim } {
		set spell_list "10984"
		# Shadow Word: Pain
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::MagisterKalendris {
	proc CanCast { npc victim } {
		set spell_list "10894 10947 18807"
		# Shadow Word: Pain, Mind Blast, Mind Flay
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PrinceTortheldrin {
	proc CanCast { npc victim } {
		set spell_list "20691 22920"
		# Cleave, Arcane Blast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Pusillin {
	proc CanCast { npc victim } {
		set spell_list "22424 10151 16144"
		# Blast Wave, Fireball, Fire Blast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::SkarrTheUnbreakable {
	proc CanCast { npc victim } {
		set spell_list "20691 24375"
		# Cleave, Mortal Strike
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::TendrisWarpwood {
	proc CanCast { npc victim } {
		set spell_list "15550 22924 22994"
		# Trample, Grasping Vines, Entangle
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ZevrimThornhoof {
	proc CanCast { npc victim } {
		set spell_list "22478 22651"
		# Intense Pain, Sacrifice
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GordokMageLord {
	proc CanCast { npc victim } {
		set spell_list "20832 16102 15530 16170"
		# Fire Blast, Flamestrike, Frostbolt, Bloodlust
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GordokReaver {
	proc CanCast { npc victim } {
		set spell_list "22572 22916"
		# Bruising Blow, Uppercut
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GordokBrute {
	proc CanCast { npc victim } {
		set spell_list "13737 20677 24317"
		# Mortal Strike, Cleave, Sunder Armor
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WildspawnHellcaller {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 19474 ]
		# Rain of Fire
	}
}


namespace eval ::FelLash {
	proc CanCast { npc victim } {
		set spell_list "22460 22272"
		# Arcane Explosion, Arcane Missiles
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--Uldaman--#

namespace eval ::Archaedas {
	proc CanCast { npc victim } {
		set spell_list "6524"
		# Ground Tremor
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Revelosh {
	proc CanCast { npc victim } {
		set spell_list "10392 2860"
		# Lightning Bolt, Chain Lightning
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Grimlok {
	proc CanCast { npc victim } {
		set spell_list "8292 10392 8066"
		# Chain Bolt, Lightning Bolt, Shrink
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Baelog {
	proc CanCast { npc victim } {
		set spell_list "15613 15655"
		# Strike, Shield Slam
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GalgannFirehammer {
	proc CanCast { npc victim } {
		set spell_list "10448 18958 12470"
		# Flame Shock, Flame Lash, Fire Nova
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Ironaya {
	proc CanCast { npc victim } {
		set spell_list "16169 24375"
		# Arcing Smash, War Stomp
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--Mauradon--#
namespace eval ::CelebrasTheCursed {
	proc CanCast { npc victim } {
		set spell_list "21667 21331 21793"
		# Wrath, Entangling Roots, Twisted Tranquility
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LordVyletongue {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 21080 ]
			# Putrid Breath
		}
		if { $spellid == 0 } {
			set spellid 8817
			# Smoke Bomb
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::MeshlokTheHarvester {
	proc CanCast { npc victim } {
		set spell_list "24375 15580"
		# War Stomp, Strike
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PrincessTheradras {
	proc CanCast { npc victim } {
		set spell_list "21909 21832 19128 21869"
		# Dust Field, Boulder, Knockdown, Repulsive Gaze
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Razorlash {
	proc CanCast { npc victim } {
		set spell_list "21911 15584 21749"
		# Puncture, Cleave, Thorn Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::TinkererGizlock {
	proc CanCast { npc victim } {
		set spell_list "21833 22334"
		# Goblin Dragon Gun, Bomb
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Noxxion {
	proc CanCast { npc victim } {
		set spell_list "21687 21547"
		# Toxic Volley, Spore Cloud
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			return [ ::AI::Check $npc $victim 21707 ]
			# Summon Spawns of Noxxion
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


#--Razorfen Downs--#
namespace eval ::AmnennarTheColdbringer {
	proc CanCast { npc victim } {
		set spell_list "10179 22645 13009"
		# Frostbolt, Frost Nova, Amnennar's Wrath
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 12556 ]
			# Frost Armor
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Glutton {
	proc CanCast { npc victim } {
		set spell_list "16345"
		# Disease Cloud
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::MordreshFireEye {
	proc CanCast { npc victim } {
		set spell_list "10148 12470"
		# Fireball, Fire Nova
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PlaguemawTheRotting {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 12947 ]
			# Withered Touch
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 12946 ]
			# Putrid Stench
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Ragglesnout {
	proc CanCast { npc victim } {
		set spell_list "10892 11659"
		# Shadow Word: Pain, Shadow Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::TutenKash {
	proc CanCast { npc victim } {
		set spell_list "12255 12252"
		# Curse of Tuten'kash, Web Spray
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 12254 ]
			# Virulent Poison proc
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--Blackrock Depths--#
namespace eval ::AmbassadorFlamelash {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 15573 ]
			# Fire blast proc buff
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}
namespace eval ::AnubShiah {
	proc CanCast { npc victim } {
		set spell_list "11661 15471"
		# Shadow Bolt, Enveloping Web
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BaelGar {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			return [ ::AI::Check $npc $victim 13879 ]
			# Magma Splash proc buff
		}
		if { $spellid == 0 } {
			return [ ::AI::Check $npc $victim 13895 ]
			# Spawns of Bael'Gar
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::EmperorDagranThaurissan {
	proc CanCast { npc victim } {
		set spell_list "17492 24573 20691"
		# Hand of Thaurissan, Mortal Strike, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Eviscerator {
	proc CanCast { npc victim } {
		set spell_list "14331 20741"
		# Vicious Rend, Shadow Bolt Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::FineousDarkvire {
	proc CanCast { npc victim } {
		set spell_list "15614 13953"
		# Kick, Holy Strike
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GeneralAngerforge {
	proc CanCast { npc victim } {
		set spell_list "14099 9080 20691"
		# Mighty Blow, Hamstring, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GolemLordArgelmach {
	proc CanCast { npc victim } {
		set spell_list "16033 16034 10432"
		# Chain Lightning, Shock, Lightning Shield
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GoroshTheDervish {
	proc CanCast { npc victim } {
		set spell_list "15589 24573"
		# Whirlwind, Mortal Strike
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Grizzle {
	proc CanCast { npc victim } {
		set spell_list "6524 20691"
		# Ground Tremor, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::HedrumTheCreeper {
	proc CanCast { npc victim } {
		set spell_list "15475 15474 3609"
		# Baneful Poison, Web Explosion, Paralyzing Poison
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::HighInterrogatorGerstahn {
	proc CanCast { npc victim } {
		set spell_list "10894 8122 10876"
		# Shadow Word: Pain, Psychic Scream, Mana Burn
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::HoundmasterGrebmar {
	proc CanCast { npc victim } {
		set spell_list "23511 17153"
		# Demoralizing Shout, Rend
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::HurleyBlackbreath {
	proc CanCast { npc victim } {
		set spell_list "17294 15583 14099"
		# Flame Breath, Rupture, Mighty Blow
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::LordIncendius {
	proc CanCast { npc victim } {
		set spell_list "13899 13900 14099"
		# Fire Storm, Fiery Burst, Mighty Blow
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::LordRoccor {
	proc CanCast { npc victim } {
		set spell_list "10448 6524 10414"
		# Flame Shock, Ground Tremor, Earth Shock
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Magmus {
	proc CanCast { npc victim } {
		set spell_list "13900 24375"
		# Fiery Burst, War Stomp
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::OkThorTheBreaker {
	proc CanCast { npc victim } {
		set spell_list "15453 15451"
		# Arcane Explosion, Arcane Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PanzorTheInvincible {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 18116 ]
		# Anti-Stun
	}
}

namespace eval ::Phalanx {
	proc CanCast { npc victim } {
		set spell_list "8732 22425 14099"
		# Thunderclap, Fireball Volley, Mighty Blow
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PrincessMoiraBronzebeard {
	proc CanCast { npc victim } {
		set spell_list "10947 22645"
		# Mind Blast, Frost Nova
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::PyromancerLoregrain {
	proc CanCast { npc victim } {
		set spell_list "10448 15095"
		# Flame Shock, Molten Blast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--Scholomance--#
namespace eval ::MardukBlackpool {
	proc CanCast { npc victim } {
		set spell_list "20741 15584"
		# Shadow Bolt Volley, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 17695 ]
			# Defiling Aura
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::RisenLackey {
	proc CanCast { npc victim } {
		set spell_list "15584"
		# Cleave
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Passive Despawn
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::DoctorTheolenKrastinov {
	proc CanCast { npc victim } {
		set spell_list "18106 15584"
		# Rend, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KirtonosTheHerald {
	proc CanCast { npc victim } {
		set spell_list "20741 18144"
		# Shadow Bolt Volley, Swoop
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::InstructorMalicia {
	proc CanCast { npc victim } {
		set spell_list "11672 12020"
		# Corruption, Call of the Grave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LorekeeperPolkelt {
	proc CanCast { npc victim } {
		set spell_list "16359 3584"
		# Corrosive Acid, Volatile Infection
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Rattlegore {
	proc CanCast { npc victim } {
		set spell_list "24375 18813"
		# War Stomp, Knock Away
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TheRavenian {
	proc CanCast { npc victim } {
		set spell_list "15550 20691"
		# Trample, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LordAlexeiBarov {
	proc CanCast { npc victim } {
		set spell_list "11668 11700"
		# Immolate, Drain Life
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 17467 ]
			# Unholy Aura
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::JandiceBarov {
	proc CanCast { npc victim } {
		set spell_list "24673 18270"
		# Curse of Blood, Dark Plague
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 17773 ]
			# Summon Illusions
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::IllusionOfJandiceBarov {
	proc CanCast { npc victim } {
		set spell_list "15584"
		# Cleave
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Passive Despawn
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LadyIlluciaBarov {
	proc CanCast { npc victim } {
		set spell_list "11713 19460 6215 15487"
		# Curse of Agony, Shadow Shock, Fear, Silence
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkmasterGandling {
	proc CanCast { npc victim } {
		set spell_list "18702 10212"
		# Curse of the Darkmaster, Arcane Missiles
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::RasFrostwhisper {
	proc CanCast { npc victim } {
		set spell_list "8398 18099 20005 16350 26070 21369 23412"
		# Frostbolt Volley, Chill Nova, Chilled, Freeze, Fear, Frostbolt, Frostbolt Area
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--Zul'Farrak--#

namespace eval ::Antusul {
	proc CanCast { npc victim } {
		set spell_list "11306 11894 11891"
		# Fire Nova , Antu'sul's Minion , Antu'sul Blast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::WitchDoctorZumRah {
	proc CanCast { npc victim } {
		set spell_list "20741 11660"
		# Shadow Bolt Volley, Shadow Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GahzRilla {
	proc CanCast { npc victim } {
		set spell_list "11131 11902 11836"
		# Icicle, Gahz'rilla Slam, Freeze Solid
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ChiefUkorzSandscalp {
	proc CanCast { npc victim } {
		set spell_list "15584 11837"
		# Cleave, Wide Slash
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ShadowpriestSezzziz {
	proc CanCast { npc victim } {
		set spell_list "11660 10893 8122"
		# Shadow Bolt, Shadow Word: Pain, Psychic Scream
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--The Temple of Atal'Hakkar--#

namespace eval ::SpawnOfHakkar {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12280 ]
		# Acid of Hakkar
	}
}


namespace eval ::WyrmkinDreamwalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 9256 ]
		# Deep Sleep
	}
}


namespace eval ::ScalebaneCaptain {
	proc CanCast { npc victim } {
		set spell_list "15653 23511"
		# Acid Spit, Demoralizing Shout
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::NightmareScalebane {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12782 ]
		# Shield Spike
	}
}

namespace eval ::NightmareWanderer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15580 ]
		# Strike
	}
}

namespace eval ::NightmareWhelp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15653 ]
		# Acid Spit
	}
}


namespace eval ::NightmareSuppressor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11672 ]
		# Acid Spit
	}
}


namespace eval ::NightmareWyrmkin {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15653 ]
		# Acid Spit
	}
}

namespace eval ::ShadeOfEranikus {
	proc CanCast { npc victim } {
		set spell_list "9256 16359 24375"
		# Deep Slumber, Acid Breath, War Stomp
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Morphaz {
	proc CanCast { npc victim } {
		set spell_list "16359 12882"
		# Acid Breath, Wing Flap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Hazzas {
	proc CanCast { npc victim } {
		set spell_list "16359 12882"
		# Acid Breath, Wing Flap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Weaver {
	proc CanCast { npc victim } {
		set spell_list "16359 12882"
		# Acid Breath, Wing Flap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Dreamscythe {
	proc CanCast { npc victim } {
		set spell_list "16359 12882"
		# Acid Breath, Wing Flap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Jade {
	proc CanCast { npc victim } {
		set spell_list "16359 12882"
		# Acid Breath, Wing Flap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::JammalanTheProphet {
	proc CanCast { npc victim } {
		set spell_list "12468 10893 12480"
		# Flamestrike, Shadow Word: Pain, Hex of Jammal'an
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Zekkis {
	proc CanCast { npc victim } {
		set spell_list "7102 10893"
		# Contagion of Rot, Venom Spit
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Hukku {
	proc CanCast { npc victim } {
		set spell_list "11660 14887"
		# Shadow Bolt, Shadow Bolt Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Loro {
	proc CanCast { npc victim } {
		set spell_list "12782 15655"
		# Shield Spike, Shield Slam
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Gasher {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid 15580
			#Strike
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ZulLor {
	proc CanCast { npc victim } {
		set spell_list "12530 15584"
		# Frailty, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Mijan {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid 10893
			# Shadow Word: Pain
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Zolo {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid 10605
			# Chain Lightning
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AtalAiHighPriest {
	proc CanCast { npc victim } {
		set spell_list "15654 11660"
		# Shadow Word: Pain, Shadow Bolt
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::AtalAiPriest {
	proc CanCast { npc victim } {
		set spell_list "11660 8600"
		# Shadow Bolt, Fevered Plague
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::EnthralledAtalAi {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8600 ]
		# Fevered Plague
	}
}


namespace eval ::MummifiedAtalAi {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8600 ]
		# Fevered Plague
	}
}


namespace eval ::UnlivingAtalAi {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8247 ]
		# Wandering Plague
	}
}

namespace eval ::HakkariBloodkeeper {
	proc CanCast { npc victim } {
		set spell_list "11660 11672"
		# Shadow Bolt, Corruption
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HakkariFrostwing {
	proc CanCast { npc victim } {
		set spell_list "9915 8398"
		# Frost Nova, Frostbolt Volley
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HakkariSapper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10875 ]
		# Mana Burn
	}
}


namespace eval ::HakkariMinion {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11672 ]
		# Corruption
	}
}


namespace eval ::AtalAiWitchdoctor {
	proc CanCast { npc victim } {
		set spell_list "15208 10605"
		# Lightning Bolt, Chain Lightning
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::FungalOoze {
	proc CanCast { npc victim } {
		set spell_list "12002 6917"
		# Plague Cloud, Venom Spit
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SaturatedOoze {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7992 ]
		# Slowing Poison
	}
}


namespace eval ::CursedAtalAi {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12020 ]
		# Call of the Grave
	}
}


namespace eval ::AtalAiCorpseEater {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10893 ]
		# Shadow Word: Pain
	}
}

namespace eval ::AtalAiSkeleton {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10893 ]
		# Shadow Word: Pain
	}
}


namespace eval ::AtalAiDeathWalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10893 ]
		# Shadow Word: Pain
	}
}


namespace eval ::AvatarOfHakkar {
	proc CanCast { npc victim } {
		set spell_list "6607 12888 12889 10893"
		# Lash, Cause Insanity, Curse of Tongues, Shadow Word: Pain
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::AtalAlarion {
	proc CanCast { npc victim } {
		set spell_list "12887 6524"
		# Sweeping Slam, Ground Tremor
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::KazkazTheUnholy {
	proc CanCast { npc victim } {
		set spell_list "11660 14887"
		# Shadow Bolt, Shadow Bolt Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OgomTheWretched {
	proc CanCast { npc victim } {
		set spell_list "15654 11660"
		# Shadow Word: Pain, Shadow Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurkSlitherer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 13298 ]
		# Poison
	}
}

namespace eval ::MurkSpitter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6917 ]
		# Venom Spit
	}
}

namespace eval ::MurkWorm {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7992 ]
		# Slowing Poison
	}
}




#------- Gnomeregan -------#

namespace eval ::ArcaneNullifierX21 {
	proc CanCast { npc victim } {
		set spell_list "1604 11820 6358 10831 18796 21078 17165"
		# Dazed(1604), Electrified Net(11820), Seduction(6358), Reflection Field(10831), Fireball(18796), Corruption(21068), Mind Flay(17165)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaverndeepAmbusher {
	proc CanCast { npc victim } {
		set spell_list "15657 9770 1604 16145 9776"
		# Backstab(15657), Radiation(9770), Dazed(1604), Sunder Armor(16145), Irradiated(9776)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::CaverndeepBurrower {
	proc CanCast { npc victim } {
		set spell_list "9770 16145 1604 9776"
		# Radiation(9770), Sunder Armor(16145), Dazed(1604), Irradiated(9776)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaverndeepInvader {
	proc CanCast { npc victim } {
		set spell_list "9770 1604 12540"
		# Radiation(9770), Dazed(1604), Gouge(12540)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaverndeepLooter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10851 ]
	}
}

namespace eval ::CaverndeepPillager {
	proc CanCast { npc victim } {
		set spell_list "12540 9770 1604 9080 9776"
		# Gouge(12540), Radiation(9770), Dazed(1604), Harmstring(9080), Irradiated(9776)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::CaverndeepReaver {
	proc CanCast { npc victim } {
		set spell_list "16169 9770 22540 1604 16145 9776"
		# Arcing Smash(16169), Radiation(9770), Cleave(22540), Dazed(1604), Sunder Armor(16145), Irradiated(9776)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Chomper {
	proc CanCast { npc victim } {
		set spell_list "1604 6409 3420"
		# Dazed(1604), Cheap Shot(6409), Crippling Poison(3420)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::CorrosiveLurker {
	proc CanCast { npc victim } {
		set spell_list "9459 1604 10341 11638"
		# Corrosive Ooze(9459), Dazed(1604), Radiation Cloud(10341), Radiation Poisoning(11638)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::CrowdPummeler960 {
	proc CanCast { npc victim } {
		set spell_list "16169 5568 10887"
		# Arcing Smash(16169), Trample(5568), Crowd Pummel(10887)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronAgent {
	proc CanCast { npc victim } {
		set spell_list "11802 1604 11820 10734 9034 12024"
		# Dark Iron Land Mine(11802), Dazed(1604), Electrified Net(11820), Hail Storm(10734), Immolate(9034), Net(12024)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronAmbassador {
	proc CanCast { npc victim } {
		set spell_list "3053 16412"
		#FireShield Effect II(3052), Fireball(16412)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Electrocutioner6000 {
	proc CanCast { npc victim } {
		set spell_list "11082 11085 11084"
		#Megavolt(11082), Chain Bolt(11085), Shock(11084)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Ember {
	proc CanCast { npc victim } {
		set spell_list "13551 1510 13812 17174 3600 16412 8056"
		#Serpent Sting Rank 4(13551), Volley Rank 1(1510), Explosive Trap Effect Rank 1(13812), Concussive Shot(17174), Earthbind(3600), Fireball(16412), Frostshock Rank 1(8056)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Grubbis {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::HoldoutTechnician {
	proc CanCast { npc victim } {
		set spell_list "6660 8858"
		#Shoot(6660), Bomb(8858)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HoldoutWarrior {
	proc CanCast { npc victim } {
		set spell_list "2458 19639 19644 15588 18202"
		#Berserker Instance(2458), Pummel(19639), Strike(19644), Thunder Clap(15588), Rend(18202)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::IrradiatedHorror {
	proc CanCast { npc victim } {
		set spell_list "8211 10341 1604 9459"
		#Chain Burn Rank 1(8211), Radiation Cloud(10341), Dazed(1604), Corrosive Ooze(9459)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::IrradiatedInvader {
	proc CanCast { npc victim } {
		set spell_list "9769 9771 9776 1604 12540"
		#Radiation(9769), Radiation Bolt(9771), Irradiate(9776), Dazed(1604), Gouge(12540)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::IrradiatedPillager {
	proc CanCast { npc victim } {
		set spell_list "9769 9771 9776 1604 16145"
		#Radiation(9769), Radiation Bolt(9771), Irradiate(9776), Dazed(1604), Sunder Armor(16145)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::IrradiatedSlime {
	proc CanCast { npc victim } {
		set spell_list "10341 1604 9459"
		#Radiation Cloud(10341), Dazed(1604), Corrosive Ooze(9459)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LeprousAssistant {
	proc CanCast { npc victim } {
		set spell_list "1604 11264 12024"
		#Dazed(1604), Ice Blast(11264), Net(12024)
 		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::LeprousDefender {
	proc CanCast { npc victim } {
		set spell_list "6660 2643 5116"
		#Shoot(6660), Multi-Shot Rank 1(2643), Concussive Shot (5116)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LeprousMachinesmith {
	proc CanCast { npc victim } {
		set spell_list "13398 1604 10734 11264 11820"
		#Throw Wrench(13398), Dazed(1604), Hail Storm(10734), Ice Blast(11264), Electrified Net(11820)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LeprousTechnician {
	proc CanCast { npc victim } {
		set spell_list "13398 1604 12024"
		#Throw Wrench(13398), Dazed(1604), Net(12024)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim 13398 ]
	}
}


namespace eval ::MechanizedGuardian {
	proc CanCast { npc victim } {
		set spell_list "11820 1604"
		#Electrified Net(11820), Dazed(1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MechanizedSentry {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::MechanoFlamewalker {
	proc CanCast { npc victim } {
		set spell_list "11306 10733"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MechanoFrostwalker {
	proc CanCast { npc victim } {
		set spell_list "22519 11264"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MechanoTank {
	proc CanCast { npc victim } {
		set spell_list "10346 1604 17174"
		#Machine Gun(10346), Dazed(1604), Concussive Shot(17174)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MekgineerThermaplugg {
	proc CanCast { npc victim } {
		set spell_list "10101 1604 11820 9143 11085 11084 10831 20545"
		#Knock Away(10101), Dazed(1604), Electrified Net(11820), Bomb(9143), Chain Bolt(11085), Shock(11084), Reflected Field(10831), Lightning Shield(20545)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PeacekeeperSecuritySuit {
	proc CanCast { npc victim } {
		set spell_list "6533 1604 11820 11084"
		#Net(6533), Dazed(1604), Electrified Net(11820), Shock(11084)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Techbot {
	proc CanCast { npc victim } {
		set spell_list "10852 10855 10856 1604 9080"
		#Battle Net(10852), Lag(10855), Link Dead(10856), Dazed(1604), Harmstring(9080)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ViscousFallout {
	proc CanCast { npc victim } {
		set spell_list "10341 1604"
		#Radiation Cloud(10341), Dazed(1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#--- Blackfathom Deeps ---#
namespace eval ::Akumai {
	proc CanCast { npc victim } {
		set spell_list "3815 17261 3242 14897 21861"
		#Cloud Poison (3815), Ravage (3242), Bite(17261) Poison Bolt (21861)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AkumaiFisher {
	proc CanCast { npc victim } {
		set spell_list "1604"
		#Dazed (1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AkumaiServant {
	proc CanCast { npc victim } {
		set spell_list "8398 10230 1604 3242"
		#Frostbolt Volley (8398), Frost Nova (10230), Dazed (1604), Ravage (3242)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AkumaiSnapjaw {
	proc CanCast { npc victim } {
		set spell_list "3242 1604"
		#Ravage (3242), Dazed (1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AquaGuardian {
	proc CanCast { npc victim } {
		set spell_list "23102 1604 22356"
		#Frostbolt(23102), Dazed (1604), Slow (22356)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BarbedCrustacean {
	proc CanCast { npc victim } {
		set spell_list "1604 8398 3242"
		# Dazed (1604), Frostbolt Volley (8398), Ravage (3242)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BaronAquanis {
	proc CanCast { npc victim } {
		set spell_list "8408 10230 10191 18098 16927"
		#Frostbolt (8408) Frost Nova Rank 4 (10230), Mana Shield (10191), Chill Nova (18098), Chilled (16927)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackfathomMyrmidon {
	proc CanCast { npc victim } {
		set spell_list "8379 1604 16927 14907 15976 8552"
		# Disarm (8379), Dazed (1604), Chilled (16927), Frost Nova (14907), Curse of Weakness (8552)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackfathomOracle {
	proc CanCast { npc victim } {
		set spell_list "8363 332 21369 8379"
		# Parasite (8363), Healing Wave rank 3(332), Frostbolt (21369), Disarm (8379)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackfathomSeaWitch {
	proc CanCast { npc victim } {
		set spell_list "6131 7322 16927 1604 8379 8552"
		# Frost Nova (Rank 3), Frost Bolt (Rank 4), Chilled (16927), Dazed (1604), Disarm (8379), Curse of Weakness (8552)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackfathomTidePriestess {
	proc CanCast { npc victim } {
		set spell_list "837 639 3385 5116 8363"
		#Frostbolt Rank 3(837), Holy Light rank 2 (639), Boar Charge (3385), Concussive Shot (5116), Parasite (8363)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
	   	return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlindlightMuckdweller {
	proc CanCast { npc victim } {
		set spell_list "8382 1604 8733"
		# eech Poison (8382), Dazed (1604),Blessing of Blackfathom (8733)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlindlightMurloc {
	proc CanCast { npc victim } {
		set spell_list "6145 71 1604 22691 12024"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlindlightOracle {
	proc CanCast { npc victim } {
		set spell_list "14109 3358 8733 12024"
		# Lightning Bolt(14109), Leech Poison(3358), Blessing of Blackfathom(8733), Net(12024)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeepPoolThreshfin {
	proc CanCast { npc victim } {
		set spell_list "1604 3604 7322"
		# Dazed(1604), Tendon Rip(3604), Frostbolt Rank 4(7322)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FallenrootHellcaller {
	proc CanCast { npc victim } {
		set spell_list "16784 8131 16927 10230 22691 1604 6205 3358 10911"
		#Shadow Bolt(16784), Mana Burn Rank 2(8131), Chilled(16927), Frost Nova Rank 4(10230), Disarm(22691), Dazed(1604), Curse of Weakness Rank 3(6205), Leech Poison(3358), Mind Control Rank 2(10911)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FallenrootRogue {
	proc CanCast { npc victim } {
		set spell_list "6595 1604 7322 22691 8363 14275 8218"
		#Exploit Weakness(8355), Dazed(1604), Frostbolt Rank 4(7322), Disarm(22691), Parasite(8363), Scorpid Sting(14275), sneak(8218)
	  	set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
	 	return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FallenrootSatyr {
	proc CanCast { npc victim } {
		set spell_list "22691 7322 1604 7922 8363"
		#Disarm(22691), rostbolt Rank 4(7322), Dazed(1604), Charge Stun(7922), Parasite(8363)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Gelihast {
	proc CanCast { npc victim } {
		set spell_list "6533 3358 1604"
		#Net(6533), Leech Poison(3358), Dazed(1604)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Ghamoora {
	proc CanCast { npc victim } {
		set spell_list "5568 1604 22691"
		# Trample(5568), Dazed(1604), Disarm(22691)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LadySarevess {
	proc CanCast { npc victim } {
		set spell_list "6131 8406 12549 18972 15547 16907"
		# Frost Nova, Frostbolt, Forked Lightning(12549), Slow(18972), Shoot(15547), Chilled(16907)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LorgusJett {
	proc CanCast { npc victim } {
		set spell_list "14109 20545 11084 1604 22691"
		#Lightning Bolt(14109), Lightning Shield(20545), Shock(11084), Dazed(1604), Disarm(22691)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Morridune {
	proc CanCast { npc victim } {
		set spell_list "8391 1604"
		#Ravage(8391),Dazed(1604)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurkshallowSnapclaw {
	proc CanCast { npc victim } {
		set spell_list "22691 1604 6145"
		#Disarm(22691), Dazed(1604), Sunden Armor(6145)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OldSerrakis {
	proc CanCast { npc victim } {
		set spell_list "8433 3604"
		# Leech Pulse(8433), Tendon Rip(3604)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SkitteringCrustacean {
	proc CanCast { npc victim } {
		set spell_list "6145 4161"
		# Sunder Armor(6145), Quick Snap(4161)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SnappingCrustacean {
	proc CanCast { npc victim } {
		set spell_list "4161 6145 14907 16907"
		# Quick Snap(4161), Sunden Armor(6145), Frost Nova(14907), Chilled(16907)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightAcolyte {
	proc CanCast { npc victim } {
		set spell_list "1094 1088 6205 6223 5138 699 1014"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightAquamancer {
	proc CanCast { npc victim } {
		set spell_list "837 8372 7301 22356 1604"
		# Frostbolt Rank 3(837), Summon Aqua Guardian(8372), Frost Armor Rank 3(7301), Slow(22356), Dazed(1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 8372 } {
			set rnd [ expr { rand() * 10 } ]
				if { $rnd > 8 } {
			 		return [ ::AI::Cast $npc $victim $spellid ]
				} else {
			 		 return $::AI::NoSpell
				}
		} else {
		return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::TwilightElementalist {
	proc CanCast { npc victim } {
		set spell_list "8045 8053 11084 1604 8046"
	  	#Frost Shock Rank 3(8045), Flame Shock Rank 3(8053), Shock(11084), Dazed(1604), Earth Shock Rank 4(8046)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightLordKelris {
	proc CanCast { npc victim } {
		set spell_list "1090 1106 8105 8131 6788 17139 9474"
		# Sleep Rank 2(1090), Shadow Bolt Rank 5(1106), Mind Blast Rank 5(8105), Mana Burn Rank 2(8131), Power Word:Shield(17139), Flash Heal Rank 4(9474)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightLoreseeker {
	proc CanCast {npc victim } {
		set spell_list "7301 22356 1604 7322"
		# Frost Armor Rank 3(7301), Slow(22356), Dazed(1604), Frostbolt Rank 4(7322)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightReaver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8374 ]
	}
}


namespace eval ::TwilightShadowmage {
	proc CanCast { npc victim } {
		set spell_list "18138 10911 1604 8053 20669 23501"
		#Shadowbolt(18138), Mind Control Rank 2(10911), Dazed(1604), Frost Shock Rank 3(8045), Flame Shock Rank 3(8053), Sleep(20669), Summon Voidwalker(23501)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Blackrock Spire---#
namespace eval ::GeneralDrakkisath {
	proc CanCast { npc victim } {
		set spell_list "23462 23023 23931 20691"
		# Fire Nova, Conflagration, Thunderclap, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Gyth {
	proc CanCast { npc victim } {
		set spell_list "20667 20712 18763"
		# Corrosive Acid Breath, Freeze, Flame Breath
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WarchiefRendBlackhand {
	proc CanCast { npc victim } {
		set spell_list "20691 15589 23931"
		# Cleave, Whirlwind, Thunderclap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TheBeast {
	proc CanCast { npc victim } {
		set spell_list "17883 16785 14100"
		# Immolate, Flamebreak, Terrifying Roar
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PyroguardEmberseer {
	proc CanCast { npc victim } {
		set spell_list "23462 23341 17274"
		# Fire Nova, Flame Buffet, Pyroblast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LordVictorNefarius {
	proc CanCast { npc victim } {
		set spell_list "20741 24668"
		# Shadow Bolt Volley, Shadow Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OverlordWyrmthalak {
	proc CanCast { npc victim } {
		set spell_list "20691 23511 23462"
		# Cleave, Demoralizing Shout, Fire Nova
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ShadowHunterVoshGajin {
	proc CanCast { npc victim } {
		set spell_list "16708 24673 20691"
		# Hex, Curse of Blood, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Blackwing Lair---#
namespace eval ::RazorgoretheUntamed {
	proc CanCast { npc victim } {
		set spell_list "23512 23023 24375 20677"
		# Fireball Volley, Conflagration, War Stomp, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::2BroodlordLashlayer {
	proc CanCast { npc victim } {
    		set spell_list "23331 15708 20677"
		# Blast Wave, Mortal Strike, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::VaelastrasztheCorrupt {
	proc CanCast { npc victim } {
	set mobh [ ::GetHealthPCT $npc ]
		set spell_list "23462 18435 20677"
		# Fire Nova, Fire Breath, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Ebonroc {
	proc CanCast { npc victim } {
		set spell_list "23339 18500 22978"
		# Wing Buffet, Wing Buffet, Shadow Flame
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Firemaw {
	proc CanCast { npc victim } {
		set spell_list "23339 18500 22978 22433"
		# Wing Buffet, Wing Buffet, Shadow Flame, Flame Buffet
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Flamegor {
	proc CanCast { npc victim } {
		set spell_list "23462 23339 18500 22978"
		# Fire Nova, Wing Buffet, Wing Buffet, Shadow Flame
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::2Chromaggus {
	proc CanCast { npc victim } {
		set spell_list "23315 20677 23316 23310 23312 23187 23189 23313 23314 23154 23153 23169 23155"
		# Ignite Flesh, Cleave, Time Lapse, Frost Burn, Corrosive Acid, Brood Afflictions: Black,Blue,Green&Red
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Nefarian {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "22972 22981 23364 18431 20677"
		# Shadow Flame, Shadow Flame, Tail Lash, Bellowing Roar, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $mobh >= 80 && $mobh<= 90 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22654 ]
			# Summon Black Drakonids
		}
		if { $mobh >= 70 && $mobh <= 80 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22655 ]
			# Summon Red Drakonids
		}
		if { $mobh >= 60 && $mobh <= 70 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22656 ]
			# Summon Green Drakonids
		}
		if { $mobh >= 50 && $mobh <= 60 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22657 ]
			# Summon Bronze Drakonids
		}
		if { $mobh >= 40 && $mobh <= 50 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22658 ]
			# Summon Blue Drakonids
		}
		if { $mobh >= 30 && $mobh <= 40 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22680 ]
			# Summon Chromatic Drakonids
		}
		if { $mobh <= 20 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 23361 ]
			# Summon Bone Constructs
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BlackDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22287 ]
		#Brood Power: Black
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::RedDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22283 ]
		#Brood Power: Red
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BlueDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22285 ]
		#Brood Power: Blue
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BronzeDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22286 ]
		#Brood Power: Bronze
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::GreenDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22288 ]
		#Brood Power: Green
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ChromaticDrakonid {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 22283 ]
		#Brood Power: Red
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22288 ]
			#Brood Power: Green
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22286 ]
			#Brood Power: Bronze
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22285 ]
			#Brood Power: Blue
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 22287 ]
			#Brood Power: Black
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24307 ]
			# 10 minute kill timer
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoneConstruct {
	proc CanCast { npc victim } {
		set spell_list "14514"
		# Blink
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Passive Despawn(120 second kill timer)
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



#---Molten Core---#

namespace eval ::Ragnaros {
	proc CanCast { npc victim } {
		set spell_list "23341  19780"
		# Flame Buffet, Wrath of Ragnaros, Annihilate, Hand of Ragnaros
		set mobh [ ::GetHealthPCT $npc ]
                set spellid [ ::AI::Check $npc $victim 23341 ]
		if { $mobh <= 50 && $mobh > 49 && $spellid == 0 } {
		set spellid [ ::AI::Check $npc $victim 20563 ]
		# Elemental Fire Buff
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $mobh <= 30 && $mobh > 29 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 21108 ]
			# Sons of Flame
		}
		if { $mobh <= 15 && $mobh > 14 && $spellid == 0 } {
		set spellid [ ::AI::Check $npc $victim 19811 ]
		# annihilate
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}		


namespace eval ::SonOfFlame {
	proc CanCast { npc victim } {
		set spell_list "20228"
		# Pyroblast
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Spawned Mob(24307)(self)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 21857 ]
			# Lava Shield
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Lucifron {
	proc CanCast { npc victim } {
		set spell_list "19702 19703 20603"
		# Impending Doom, Lucifron's Curse, Shadow Shock
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Magmadar {
	proc CanCast { npc victim } {
		set spell_list "19408 19449 19630 23023"
		# Panic, Magma Spit, Cone of Fire, Conflagration
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Gehennas {
	proc CanCast { npc victim } {
		set spell_list "19717 19728"
		# Rain of Fire, Shadow Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MajordomoExecutus {
	proc CanCast { npc victim } {
		set spell_list "23331 20623 19781"
		# Blast Wave, Fire Blast, Flame Spear
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BaronGeddon {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "19659 19695 20475 20478"
		#
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		if { $mobh < 2 } {
			set spellid [ ::AI::Check $npc $victim 20479 ]
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Shazzrah {
	proc CanCast { npc victim } {
		set spell_list "20228 25304 19712 19713 19715 21655"
		# Pyroblast, Frostbolt, Arcane Explosion, Shazzrah's Curse, Area Counterspell, Blink(14514)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Garr {
	proc CanCast { npc victim } {
		set spell_list "19492 19496 19798"
		# Antimagic Pulse, Magma Shackles, Earthquake
		set spellid [ ::AI::Check $npc $victim 20506 ]
		# Magmakin
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SulfuronHarbinger {
	proc CanCast { npc victim } {
		set spell_list "19778 20276 19780 19781"
		# Demoralizing Shout, AoE Knock Down, Hand of Ragnaros, Flame Spear
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Magmakin {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Death Pact(60 second kill timer)
		if { $mobh <= 25 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 19497 ]
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 19798 ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Firesworn {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spellid 0
		# Immolate, Eruption
		if { $mobh <= 25 } {
			set spellid [ ::AI::Check $npc $victim 19497 ]
		}
		if { $spellid == 0 } {
			set spellid 20294
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FlamewakerPriest {
	proc CanCast { npc victim } {
		set spell_list "23952 19776 10961 20294"
		# Shadow Word: Pain (120), (400+), Prayer of Healing, Immolate
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FlamewakerElite {
	proc CanCast { npc victim } {
		set spell_list "23952 19776 10961 20294"
		# Immolate,
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FlamewakerHealer {
	proc CanCast { npc victim } {
		set spell_list "24668 23952 19776 10961 20294"
		# Shadow Bolt, Prayer of Healing (Rank 4), Desperate Prayer (Rank 7)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MoltenGiant {
	proc CanCast { npc victim } {
		set spell_list "18944 18945"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Firelord {
	proc CanCast { npc victim } {
		set spell_list "19393 19396"
		# Summon Lava Spawn(19392)(Disabled), Soul Burn, Incinerate
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LavaSpawn {
	proc CanCast { npc victim } {
		set spell_list "18392"
		# Split(19569)(disabled),Fireball(18392)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LavaReaver {
	proc CanCast { npc victim } {
		set spell_list "19642 19644"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LavaElemental {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 19641 ]
	}
}


namespace eval ::Firewalker {
	proc CanCast { npc victim } {
		set spell_list "19635 19636"
		# Incite Flames, Fire Blossom
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Flameguard {
	proc CanCast { npc victim } {
		set spell_list "19626 19630 19631"
		# Fire Shield, Cone of Fire, Melt Armor
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GolemaggIncinerator {
	proc CanCast { npc victim } {
		set spell_list "19798 20228 13878"
		# Earthquake, Pyroblast, Fire Nova
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CoreRager {
	proc CanCast { npc victim } {
		set spell_list "22689 19820 19319 17683"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 17683 } {
			if { [ expr { rand() * 10 } ] < 2 } {
				return [ ::AI::Cast $npc $victim 17683 ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}

#---Ragefire Chasm---#
namespace eval ::Bazzalan {
	proc CanCast { npc victim } {
		set spell_list "18197 19472 18671 12746"
		#Poison (18197), Sinister Attack (19472), Curse of Agony (18671), Summon Voidwalker (12746)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Earthborer {
	proc CanCast { npc victim } {
		set spell_list "18070 1604"
		#Earthborer Acid (18070), Dazed(1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Jergosh {
	proc CanCast { npc victim } {
		set spell_list "9034 8552 18266 1604 14122 13787 12746"
		#Immolate (9034), Curse of Weakness (8552), Curse of Agony (18266), Dazed (1604), Shadow Bolt (14122), Demon Armor (13787), summon Voidwalker (12746)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MoltenElemental {
	proc CanCast { npc victim } {
		set spell_list "134 1604 18070"
		#Fire Shield (134), Dazed (1604), Earthborer Acid (18070)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Oggleflint {
	proc CancCast { npc victim } {
		set spell_list "22540 1604"
		#Cleave (22540), Dazed (1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RagefireShaman {
	proc CanCast { npc victim } {
		set spell_list "18089 1604 18070 8242"
		#Lightning Bolt (18089), Dazed (1604), Earthborer Acid (18070), Shield Slam (8242)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RagefireTrogg {
	proc CanCast { npc victim } {
		set spell_list "1604 18070"
		# Dazed (1604), Earthborer Acid (18070)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SearingBladeCultist {
	proc CanCast { npc victim } {
		set spell_list "18266 8242 1604 9034 8552 18197"
		#Curse of Agony (18266), Shield Slam (8242), Dazed (1604), Immolate (9034), Curse of Weakness (8552), Poison (18197)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SearingBladeEnforcer {
	proc CanCast { npc victim } {
		set spell_list "8242 1604 18266 8552"
		#Shield Slam (8242), Dazed (1604), Curse of Agony (18266), Curse of Weakness (8552)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SearingBladeWarlock {
	proc CanCast { npc victim } {
		set spell_list "14122 18266 8242 1604 687 12746"
		#Shadow Bolt (14122), Curse of Agony (18266), Shield Slam (8242), Dazed (1604), Demon Skin Rank 1 (687), Summon Voidwalker (12746)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Taragaman {
	proc CanCast { npc victim } {
		set spell_list "11970 10966 8242 1604 18266 8552"
		#Fire Nova (11970), Uppercut (10966), Dazed (1064), Curse of Agony (18266), Curse of Weakness(8552)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}
#---Razorfen Kraul---#
namespace eval ::DeathsHeadSeer {
	proc CanCast { npc victim } {
		set spell_list "8264 4972"
		# Lava Spout Totem (Rank 1), Healing Ward V
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeathsHeadPriest {
	proc CanCast { npc victim } {
		set spell_list "6063 1088"
		# Heal (Rank 3), Shadow Bolt (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeathsHeadGeomancer {
	proc CanCast { npc victim } {
		set spell_list "11436 8401 6725"
		# Slow (11436), Fireball (8401), Flame Spike (6725)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeathsHeadAcolyte {
	proc CanCast { npc victim } {
		set spell_list "6076 8129"
		# Renew (6076), Mana Burn (8129)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeathsHeadAdept {
	proc CanCast { npc victim } {
		set spell_list "8406 113"
		# Frostbolt r5(8406), Chain of Ice (113)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeathsHeadCultist {
	proc CanCast { npc victim } {
		# Shadow bolt (1106)
		return [ ::AI::Cast $npc $victim 1106 ]
	}
}


namespace eval ::DeathsHeadSage {
	proc CanCast { npc victim } {
		# (Totem) Healing Ward (6274)
		return [ ::AI::Cast $npc $victim 6274 ]
	}
}


namespace eval ::DeathSpeakerJargba {
	proc CanCast { npc victim } {
	  set spell_list "1106 6524 1604 20740 8377 23115 8034 15398"
		# Shadow Bolt (1106), Ground Tremor (6524), Dazed(1604), Dominate Mind (20740), Earthgrab (8377), Frost Shock (23115), Frostband Attack (8034), Psychic Scream (15398)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::QuilguardChampion {
	proc CanCast { npc victim} {
		set spell_list "1604 7386 8377 8272 20740 8281"
		# Dazed (1604), Sunder Armor (rank1), Earthgrab (8377), Mind Tremor (8272), Dominate Mind (20740), Sonic Burster (8281)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoarSpirit {
	proc CanCast { npc victim } {
		# Dazed (1604)
		return [ ::AI::Cast $npc $victim 1604]
	}
}


namespace eval ::AgathelostheRaging {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid 8285
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Agamar {
	proc CanCast { npc victim } {
		# Rushing Charge (6268)
		return [ ::AI::Cast $npc $victim 6268 ]
	}
}


namespace eval ::AggemThorncurse {
	proc CanCast { npc victim } {
		set spell_list "8286 6192 15799"
		# Summon Boar Spirit (8286), Battle Shout r3 (self) [6192], Chain Heal (+253 hp self and allies) [15799])
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodofAgamaggan {
	proc CanCast { npc victim } {
		set spell_list "13496 15042 6533"
		# Dazed (13496), curse of blood (15042), net (6533)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CharlgaRazorflank {
	proc CanCast { npc victim } {
		set spell_list "11085 6076 1152"
		# Chain Bolt (11085), Renew r4 (6076), Purify (1152)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Scarlet Monastery---#
namespace eval ::Herod {
	proc CanCast { npc victim } {
		set spell_list "11608 8989 16145 21949 15588 11430"
		# Cleave, Whirlwind, Sunder Armor(16145), Rend(21949), Thunder Clap(15588), Slam(11430)
		set spellid [ ::AI::Check $npc $victim 2458 ]
		# Berserker Stance (2458)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletCommanderMograine {
	proc CanCast { npc victim } {
		set spell_list "1020 10337 5589 3472 20922 1044 10299"
		# Divine Shield (Rank 2), Crusader Strike (Rank 5), Hammer of Justice (Rank 3), Holy Light (rank 6), Consecration (rank 3)
		set mobh [ ::GetHealthPCT $npc ]
		set spellid [ ::AI::Check $npc $victim 10299 ]
		# Retribuiton Aura Rank 3(10299)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 10278 ]
			# Blessing of Protection Rank 3(10278)
		}
		if { $mobh < 50 } {
			set spellid [ ::AI::Check $npc $victim 10916 ]
			# Flash Heal
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HighInquisitorWhitemane {
	proc CanCast { npc victim } {
		set spell_list "9256 7645 17281 13005 9481 15265 8106"
		# Deep Sleep (9256), Dominate Mind (7645), Crusader Strike (17281), Hammer of Justice(13005), Holy Smite (Rank 6), Holy Fire (rank 5), Mind Blast Rank 6(8106)
		set mobh [ ::GetHealthPCT $npc ]
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $mobh < 70 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 6078 ]
			# Renew
		}
		if { $mobh < 50 } {
			set spellid [ ::AI::Check $npc $victim 6065 ]
			# Power Word: Shield
		}
		if { $mobh < 50 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 10916 ]
			# Flash Heal
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HighInquisitorFairbanks {
	proc CanCast { npc victim } {
		set spell_list "1090 16098 6060 2767 9474 6078 19277 8105"
		# Sleep (Rank 2), Curse of Blood, Smite, Shadow word:Pain, Flash Heal (rank 4), Renew (rank 6), Devouring Plague Rank 3(19277), Mind Blast Rank 5(8105)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BloodmageThalnos {
	proc CanCast { npc victim } {
		set spell_list "865 8053 1106 8814 16079"
		#Frost Nova Rank 2(865), Flameshock Rank 3(8053), Shadow Bolt Rank 5(1106), Flame Spike(8814), Fire Nova(16079)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ArcanistDoan {
	proc CanCast { npc victim } {
		set spell_list "8988 8438 8439 1953 21162"
		# AE Silence (Rank 1), Arcane Explosion (Rank 3), Arcane Explosion (Rank 4), Blink(1953), Fireball
		set mobh [ ::GetHealthPCT $npc ]
		set spellid [ ::AI::Check $npc $victim 10191 ]
		# Mana Shield Rank 4(10191)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $mobh <= 20 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 9438 ]
			# Arcane Bubble
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}
#---Shadowfang Keep---#

namespace eval ::CommanderSpringvale {
	proc CanCast { npc victim } {
		set spell_list "1026 7074 3005"
		# Holy Light (1026), Screams of the Past (7074), Hammer of Justice (3005)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BaronSilverlaine {
	proc CanCast { npc victim } {
		set spell_list "22687"
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ArchmageArugal {
	proc CanCast { npc victim } {
		set spell_list "22709 7803 7621 23038 1953 7124 4629 19482 19134"
		# Void Bolt (22709), Thundershock (7803), Arugal's Curse (7621), flameshock (23038), Blink (1953), Arugal's Gift (7124), Rain of Fire (4629), War Stomp (19482), Intimidation Shout (19134)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
	  	return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ArugalsVoidwalker {
	proc CanCast { npc victim } {
		set spell_list "16145"
		# Sunder Armor (16145)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WolfMasterNando {
	proc CanCast { npc victim } {
		set spell_list "7127"
		#Wavering Will (7127)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
	  	return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::DeathswornCaptain {
	proc CanCast { npc victim } {
		set spell_list "20666 9080"
		#Cleave (20666), Hamstring (9080)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FenrusTheDevourer {
	proc CanCast { npc victim } {
		set spell_list "7125"
		#Toxic Salive (7125)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OdotheBlindwatcher {
	proc CanCast { npc victim } {
		set spell_list "7140 16927"
		#Expose Weakness (7140), Chilled (16927)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Rethilgore {
	proc CanCast { npc victim } {
		set spell_list "7295 9915 7127 16927"
		#Soul Drain (7295), Frost Nova (9915), Wavering Will (7127), Chilled (16927)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RazorclawtheButcher {
	proc CanCast { npc victim } {
		set spell_list "7485"
		#Butcher Drain (7485)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SonOfArugal {
	proc CanCast { npc victim } {
		set spell_list "7124 3264"
		#Arugal's Gift (7124), Blood Howl (3264)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SorcererAshcrombe {
		proc CanCast { npc victim } {
		set spell_list "9915 7127 18105"
		#Frost nova rank 4(9915), Wavering Will (7127), Fireball (18105)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



namespace eval ::TormentedOfficer {
	proc CanCast { npc victim } {
		set spell_list "9080"
		# Harmstring (9080)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Stormwind Stockade---#
namespace eval ::BazilThredd {
	proc CanCast { npc victim } {
	  set spell_list "8817 18103 23511 14118 13496 8242"
		# Smoke Bomb (8817), Backhand (18103), Demoralizing Shout (23511), Rend (14118), Dazed (13496), Shield Slam (8242)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasCaptive {
	proc CanCast { npc victim } {
		set spell_list "15657 17230 13496 16509 18103"
		#Backstab (15657), Infected Wound (17230), Dazed (13496), Rend (16509), Backhand (18103)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasConvict {
	proc CanCast { npc victim } {
		set spell_list "6253 16244 8242 16509 13496"
		#Backhand (6253), Demoralizing Shout (16244), Shield Slam (8242), Rend (16509), Dazed (13496)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasInmate {
	proc CanCast { npc victim } {
		set spell_list "6547 2590 6253 16509"
		#Rend (6547), Backstab (2590), Backhand (6253), Rend (16509)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasInsurgent {
	proc CanCast { npc victim } {
		set spell_list "11554 7964 6253 13496 16509 8242"
		#Demoralizing Shout (11554), Smoke Bomb (7964), Backhand (6253), Dazed (13496), Rend (16509), Shield Slam (8242)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim 11554 ]
	}
}


namespace eval ::DefiasPrisoner {
	proc CanCast { npc victim } {
		set spell_list "1768 17230 16509 13496"
		#Kick Rank 3(1768), Infected Wounds (17230), Rend (16509), Dazed (13496)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DextrenWard {
	proc CanCast { npc victim } {
		set spell_list "16509 13496 17230"
		# Rend (16509), Dazed (13496), Infected Wounds (17230)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { [ expr { rand() * 10 } ] > 7 } {
			return [ ::AI::Cast $npc $victim 19134 ]
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::Hamhock {
	proc CanCast { npc victim } {
		set spell_list "11554 16921 12461 16509 13496"
		#Demoralizing Shout (11554), Chain Lightning (16921), Backhand (12461), Rend (16509), Dazed (13496)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KamDeepfury {
	proc CanCast { npc victim } {
		set spell_list "15665 11554 12461 16509 13496"
		#Shield Slam (15665), Demoralizing Shout (11554), Backhand (12461), Rend (16509), Dazed (13496)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TargorrDread  {
	proc CanCast { npc victim } {
		set spell_list "1604"
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Stratholme---#
namespace eval ::EyeOfNaxxramas {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 16381 ]
	}
}


namespace eval ::CrimsonDefender {
	proc CanCast { npc victim } {
		set spell_list "10308 20930 20349"
		# Hammer of Justice (Rank 4), Holy Shock (Rank 3), Seal of Light (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	 }
}


namespace eval ::CrimsonPriest {
	proc CanCast { npc victim } {
		set spell_list "10934 15431 10961"
		# Smite (Rank 8), Holy Nova (Rank 3), Prayer of Healing (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	 }
}


namespace eval ::CrimsonSorcerer {
	proc CanCast { npc victim } {
		set spell_list "10202 10212 12826"
		# Arcane Explosion (Rank 6), Arcane Missles (Rank 7), Polymorph (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	 }
}


namespace eval ::CrimsonBattleMage {
	proc CanCast { npc victim } {
		set spell_list "10202 10187 10161"
		# Arcane Explosion (Rank 6), Blizzard (Rank 6), Cone of Cold (Rank 5)
		set spellid  [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CrimsonGuardsman {
	proc CanCast { npc victim } {
		set spell_list "11972 19471"
		# Shield Bash, Beserker Charge
		set spellid  [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ThuzadinNecromancer {
	proc CanCast { npc victim } {
		set spell_list "11704 11700"
		# Drain Mana (Rank 4), Drain Life (Rank 6)
		set victimclass [ ::GetClass $victim ]
		set spellid  [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11704 } { if { $victimclass == 1 || $victimclass == 4 } { return $::AI::NoSpell } else { return [ ::AI::Cast $npc $victim 11704 ] }
		} else {
		return [ ::AI::Cast $npc $victim $spellid ]
	  }
	}
}

namespace eval ::ArchivistGalford {
	proc CanCast { npc victim } {
		set spell_list "17293 23462 17274"
		# Burning Winds, Fire Nova, Pyroblast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GrandCrusaderDathrohan {
	proc CanCast { npc victim } {
		set spell_list "17286 10337"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		# Crusader's Hammer, Crusader Strike
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Ramstein {
	proc CanCast { npc victim } {
		set spell_list "15550 17307"
		# Trample, Knockout
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Skul {
	proc CanCast { npc victim } {
		set spell_list "21369 22645 15451"
		# Frostbolt, Frost Nova, Arcane Bolt
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::MalekiThePallid {
	proc CanCast { npc victim } {
		set spell_list "21369 17238 16869 22645"
		# Frostbolt, Drain Life, Ice Tomb, Frost Nova
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::BaronessAnastari {
	proc CanCast { npc victim } {
		set spell_list "16565 16867 18327"
		# Banshee Wail, Banshee Curse, Silence
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PostmasterMalown {
	proc CanCast { npc victim } {
		set spell_list "7713 8552"
		# Wailing Dead, Curse of Weakness
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MagistrateBarthilas {
	proc CanCast { npc victim } {
		set spell_list "10887 14099"
		# Crowd Pummel, Mighty Blow
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Stonespine {
	proc CanCast { npc victim } {
		set spell_list "14331 3589"
		# Vicious Rend, Deafening Screech
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CannonMasterWilley {
	proc CanCast { npc victim } {
		set spell_list "18813 20463 10887"
		# Knock Away, Shoot, Crowd Pummel
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TheUnforgiven {
	proc CanCast { npc victim } {
		set spell_list "22645 3589"
		# Frost Nova, Deafening Screech
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Nerubenkan {
	proc CanCast { npc victim } {
		set spell_list "4962 16427 16594"
		# Encasing Webs, Poison Bolt Volley, Crypt Scarabs
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::VenomSpitter {
	proc CanCast { npc victim } {
		set spell_list "16866 16460"
		# Venom Spit, Festering Bites
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BileSpewer {
	proc CanCast { npc victim } {
		set spell_list "16866 16865"
		# Venom Spit, Spawn Bile Slimes
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BaronRivendare {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "24573 21077 20691"
		# Mortal Strike, Shadow Bolt, Cleave
		set spellid [ ::AI::Check $npc $victim 17467 ]
		# Unholy Aura
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 17698 ]
			# Death Pact
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 17475 ]
			# Raise Dead
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::MindlessSkeleton {
	proc CanCast { npc victim } {
		set spell_list "14514"
		# Blink
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Death Pact(60 second kill timer)
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Balnazzar {
		proc CanCast { npc victim } {
		set spell_list "20603 15398 9256 20741"
		# Shadow Shock, Psychic Scream, Deep Sleep, Shadow Bolt Volley
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---The Deadmines---#

namespace eval ::DefiasEvoker {
	proc CanCast { npc victim } {
		set spell_list "5115"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasSquallshaper {
	proc CanCast { npc victim } {
		set spell_list "9915"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasMagician  {
	proc CanCast { npc victim } {
		set spell_list "143 5110"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 5110 } {
			set rnd [ expr { rand() * 10 } ]
			if { $rnd > 7 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::DefiasConjurer {
	proc CanCast { npc victim } {
		set spell_list "143 5172"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasPirate {
	proc CanCast { npc victim } {
		set spell_list "6660 5172"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasTaskmaster {
	proc CanCast { npc victim } {
		set spell_list "6660 6685"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasMiner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6685 ]
	}
}


namespace eval ::DefiasStripMiner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}


namespace eval ::DefiasHenchman {
	proc CanCast { npc victim } {
		set spell_list "5115 6435"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasOverseer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 9915 ]
	}
}


namespace eval ::DefiasWatchman {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5019 ]
	}
}


namespace eval ::DefiasWizard {
	proc CanCast { npc victim } {
		set spell_list "133 205 113"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GoblinShipbuilder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::GoblinWoodcarver {
	proc CanCast { npc victim } {
		set spell_list "6466 5532"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GoblinCraftsman {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5159 ]
	}
}


namespace eval ::GoblinEngineer {
	proc CanCast { npc victim } {
		set spell_list "7919 3605"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 3605 } {
			set rnd [ expr { rand() * 10 } ]
			if { $rnd > 7 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::Gilnid {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5213 ]
	}
}


namespace eval ::ForemanThistlenettle {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5219 ]
	}
}


namespace eval ::MarisaduPaige {
	proc CanCast { npc victim } {
  	set spell_list "18199 228 113"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Brainwashednoble {
	proc CanCast { npc victim } {
		set spell_list "16927 18199 113 228"
		# Chilled (16927), Fireball (rank4), Chain of Ice (113), Polymorph Chicken (228)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Cookie {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6306 ]
	}
}


namespace eval ::RhahkZor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6304 ]
	}
}


namespace eval ::SneedShredder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3603 ]
	}
}


namespace eval ::CaptainGreenskin {
	proc CanCast { npc victim } {
		set spell_list "11608 5208"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MrSmite {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6435 ]
	}
}


namespace eval ::EdwinVanCleef {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "6306"
		#Acid Splash (6306)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $mobh == 100 } {
			set spellid [ ::AI::Check $npc $victim 5200 ]
			#VanCleef's Allies (5200)(self)
		}
		if { $mobh <= 30 } {
			set spellid [ ::AI::Check $npc $victim 5200 ]
			#VanCleef's Allies (5200)(self)
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
     		return [ ::AI::Cast $npc $victim $spellid ]
	}
}
#---Wailing Caverns---#

namespace eval ::LadyAnacondra {
	proc CanCast { npc victim } {
		set spell_list "7965 20664 20790 8040 8148 16782 22127"
		#Cobrahn Serpent Form (7965), Rejuvenation (20664), Healing Touch (20790), Druid's Slumber (8040), Thorns Aura (8148), Lightning Bolt (16782), Entangling Roots (22127)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 20664 } {
			if { $mobh < 70 && rand () < .5 } {
				return [ ::AI::Cast $npc $victim 20664 ]
			} else {
				return [ ::AI::Cast $npc $victim $spellid ]
			}
		} elseif { $spellid == 20790 } {
			if { $mobh < 50 && rand () < .5 } {
				return [ ::AI::Cast $npc $victim 20790 ]
			} else {
				return [ ::AI::Cast $npc $victim 20664 ]
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
	 	}
	}
}


namespace eval ::DruidOfFang {
	proc CanCast { npc victim } {
		set spell_list "11986 8041 8040 20790 22127"
		#Healing Wave (11986), Serpent Form (8041), Druid's Slumber (8040), Healing Touch (20790), Entangling Roots (22127)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Boahn {
	proc CanCast { npc victim } {
		set spell_list "7965 16782 20664 20790 8148 22127"
		#Cobrahn Serpent Form (7965), Lightning Bolt (16782), Rejuvenation (20664), Healing Touch (20790), Thorns Aura (8148), Entangling Roots (22127)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 20664 } {
			if { $mobh < 70 } {
				return [ ::AI::Cast $npc $victim 20664 ]
			} else {
				return [ ::AI::Cast $npc $victim $spellid ]
			}
		} elseif { $spellid == 20790 } {
			if { $mobh < 50 } {
				return [ ::AI::Cast $npc $victim 20790 ]
			} else {
				return [ ::AI::Cast $npc $victim 20664 ]
			}
		} else {
	    		return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::LordCobrahn {
	proc CanCast { npc victim } {
		set spell_list "7965 16782 20664 20790 8148 22127 17511 8040"
		#Cobrahn Serpent Form (7965), Lightning Bolt (16782), Rejuvenation (20664), Healing Touch (20790), Thorns Aura (8148), Entangling Roots (22127), poison (17511), Druid's Slumber (8040)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 20664 } {
			if { $mobh < 70 } {
				return [ ::AI::Cast $npc $victim 20664 ]
			} else {
				return [ ::AI::Cast $npc $victim $spellid ]
			}
		} elseif { $spellid == 20790 } {
			if { $mobh < 50 } {
				return [ ::AI::Cast $npc $victim 20790 ]
			} else {
				return [ ::AI::Cast $npc $victim 20664 ]
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::LordPythas {
	proc CanCast { npc victim } {
		set spell_list "7965 16782 20664 20790 8148 22127 15588 8040"
		#Cobrahn Serpent Form (7965), Lightning Bolt (16782), Rejuvenation (20664), Healing Touch (20790), Thorns Aura (8148), Entangling Roots (22127), Thunderclap (15588), Druid's Slumber (8040)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 20664 } {
			if { $mobh < 70 } {
				return [ ::AI::Cast $npc $victim 20664 ]
			} else {
				return [ ::AI::Cast $npc $victim $spellid ]
			}
		} elseif { $spellid == 20790 } {
			if { $mobh < 50 } {
				return [ ::AI::Cast $npc $victim 20790 ]
			} else {
				return [ ::AI::Cast $npc $victim 20664 ]
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::LordSerpentis {
	proc CanCast { npc victim } {
		set spell_list "7965 16782 20664 20790 8148 22127 7399"
		#Cobrahn Serpent Form (7965), Lightning Bolt (16782), Rejuvenation (20664), Healing Touch (20790), Thorns Aura (8148), Entangling Roots (22127), Terrify (7399)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 20664 } {
			if { $mobh < 70 } {
				return [ ::AI::Cast $npc $victim 20664 ]
			} else {
				return [ ::AI::Cast $npc $victim $spellid ]
			}
		} elseif { $spellid == 20790 } {
			if { $mobh < 50 } {
				return [ ::AI::Cast $npc $victim 20790 ]
			} else {
				return [ ::AI::Cast $npc $victim 20664 ]
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::Skum {
	proc CanCast { npc victim } {
		set spell_list "6254 1540 8040"
		#Chained Bolt (6254), Volley (1540), Druid's Slumber (8040)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Verdan {
  proc CanCast { npc victim } {
		set spell_list "8142 13439"
		# Grasping Vines (8142), Sunder Armor (16145)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ClonedEctoplasm {
  proc CanCast { npc victim } {
		set spell_list "17230 6607"
		# Infected Wound (17230), Lash (6607)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Kresh {
	proc CanCast { npc victim } {
		#Dazed (1604)
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::Mutanus {
	proc CanCast { npc victim } {
		set spell_list "15588 7399 8040"
		#Thunderclap (15588), Terrify (7399), Druid's Slumber (8040)
		set rnd [ expr { rand () * 10 } ]
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 15588 } {
			if { $rnd >= 3 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::MadMagglish {
	proc CanCast { npc victim } {
		#Smoke Bomb (8817)
		return [ ::AI::Cast $npc $victim 8817 ]
	}
}

#---Zul'Gurub---#
namespace eval ::Hakkar {
	proc CanCast { npc victim } {
		set spell_list "24328 24178 20276 20677 23918 24011"
		# Corrupted Blood, Will of Hakkar, Knockdown, Cleave
		set spellid  [ ::AI::Check $npc $victim 24322 ]
		# Blood Siphon(24322)(self)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Renataki {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "24698 24649 24337 24223"
		# Gouge, Thousand Blades, Ambush, Vanish(self)
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		if { $spellid == 24223 } {
			if { $mobh > 10 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}

	}
}


namespace eval ::Wushoolay {
	proc CanCast { npc victim } {
		set spell_list "25033 25034 24680"
		# Lightning Cloud, Forked Lightning, Chain Lightning
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodlordMandokir {
	proc CanCast { npc victim } {
		set spell_list "24236 20677 15708"
		# Whirlwind(self), Cleave, Mortal Strike
		set spellid [ ::AI::Check $npc $victim 24349 ]
		# Summon Ohgan(self)
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::JinDoTheHexxer {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "24306 23600 24053 24375 23952 24308 24262"
		# Delusions of Jin'Do(24306), Piercing Howl(23600), Hex(24053), War Stomp(24375), Shadow Word:Pain(23952), Summon Shade of Jin'Do(24308)(self), Summon Brain Wash Totem(24262)(self),
		set spellid 0
		if { $mobh <= 50 } {
			set spellid [ ::AI::Check $npc $victim 24309 ]
			# Summon Greater Healing Ward (24309)(self)
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ShadeOfJinDo {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Spawned Mob(24307)(self)
		if { $spellid == 0 } {
			set spellid "24458"
			# Shadow Shock
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



namespace eval ::HighPriestessMarli {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "24099 24112"
		# Poison Bolt Volley, Poison Shock
		set transform_spell_list "24099 24112 24110 24111"
		# Poison Bolt Volley, Poison Shock, Enveloping Webs, Corrosive Poison
		set spellid [ ::AI::Check $npc $victim 24081 ]
		# Spawn of Mar'li(24081)(self)
		if { $spellid == 0 } {
			if { $mobh <= 50 } {
				set spellid [ ::AI::Check $npc $victim 24084 ]
				# Transform Spider(24048)(self)
			}
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0} {
			if { $mobh < 50 } {
				set spellid [ lindex $transform_spell_list [ expr { int( rand() * [ llength $transform_spell_list ] ) } ] ]
			} else {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HighPriestessArlokk {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "23952 20677 24236"
		# Shadow Word:Pain(23952), Cleave(20677), Whirlwind(24236)(self)
		set transform_spell_list "20677 23952 24213 24236"
		# Cleave, Shadow Word: Pain, Ravage, Whirlwind(24236)(self)
		set spellid [ ::AI::Check $npc $victim 24247 ]
		# Spawn Zulian Stalkers(Passive)(self)
		if { $spellid == 0 } {
			if { $mobh <= 50 } {
				set spellid [ ::AI::Check $npc $victim 24190 ]
				# Transform Panther(24190)(self)
			}
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			if { $mobh < 55 } {
				set spellid [ lindex $transform_spell_list [ expr { int( rand() * [ llength $transform_spell_list ] ) } ] ]
			} else {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



namespace eval ::HighPriestVenoxis {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "23860 23858 23269"
		# Holy Fire(23860), Holy Nova(23858), Holy Blast(23269)
		set transform_spell_list "24840 25053 22412 23866"
		# Poison Cloud(24840), Venom Spit(25053), Virulent Poison(22412), Summon Parasitic Serpent(23866)(self)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $mobh <= 50 } {
			set spellid [ ::AI::Check $npc $victim 23849 ]
			# Transform Snake(23849)(self)
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			if { $mobh < 50 } {
				set spellid [ lindex $transform_spell_list [ expr { int( rand() * [ llength $transform_spell_list ] ) } ] ]
			} else {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ParasiticSerpent {
	proc CanCast { npc victim } {
		set spell_list "22412 23865"
		# Virulent Poison(22412), Parasitic Serpent(23865)
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Despawn Passive(24307)(self)
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HighPriestThekal {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "20677 22859"
		# Cleave(20677), Mortal Cleave(22859)
		set transform_spell_list "24189 24192 22859 23931 20677"
		# Force Punch(24189), Speed Slash(24192), Mortal Cleave(22859), Thunderclap(23931), Cleave(20667)
		set spellid [ ::AI::Check $npc $victim 24183 ]
		# Summon Zulian Guardians(24183)(self)
		if { $spellid == 0 } {
			if { $mobh <= 50 } {
				set spellid [ ::AI::Check $npc $victim 24169 ]
				# Transform Tiger(24169)(self)
			}
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			if { $mobh <= 50 } {
				set spellid [ lindex $transform_spell_list [ expr { int( rand() * [ llength $transform_spell_list ] ) } ] ]
			} else {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



namespace eval ::HighPriestessJeklik {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "24437 23919 24673 12097"
		# Blood Leech, Swoop, Curse of Blood, Pierce Armor
		set transform_spell_list "24209 23952 23953 15398"
		# Great Heal(Self), Shadow Word: Pain, Mind Flay, Psychic Scream
		set spellid 0
		if { $mobh <= 50 } {
			set spellid [ ::AI::Check $npc $victim 23966 ]
			# Transform Troll Priestess
		}
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18116 ]
			# Anti-Stun
		}
		if { $spellid == 0 } {
			if { $mobh < 50 } {
				set spellid [ lindex $transform_spell_list [ expr { int( rand() * [ llength $transform_spell_list ] ) } ] ]
			} else {
				set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Hazzarah {
	proc CanCast { npc victim } {
		set spell_list "9256 24685 24684"
		# Deep Sleep, Earth Shock, Chain Shock
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Gahzranka {
	proc CanCast { npc victim } {
		set spell_list "24326 21099"
		# Gahz'ranka Slam, Frost Breath
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::Grilek {
	proc CanCast { npc victim } {
		set spell_list "6524 24648"
		# Ground Tremor, Entanging Roots
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HakkariPriest {
	proc CanCast { npc victim } {
		# Shadow Bolt (11661)
		return [ ::AI::Cast $npc $victim 11661 ]
	}
}

#---World Bosses---#

namespace eval ::PrinceThunderaan {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "23011 23009"
		# Tears of the Windseeker, Tendrils of Air
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::2Ysondre {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "20677 24818 9256 15847 24819"
		# Cleave, Noxious Breath(24818), Deep Sleep, Tail Sweep, Lightning Wave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $mobh <= 25 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24795 ]
			# Summon Demented Druids(24795)
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DementedDruid {
	proc CanCast { npc victim } {
		set spell_list "22422"
		# Water
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Despawn
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


# namespace eval ::HumanoidDruid {
# 		proc CanCast { npc victim } {
# 		set spell_list "9912 9834 24977 9876 17402"
# 		# Wrath, Moonfire, Insect Swarm, Starfire, Hurricane
# 		set mobh [ ::GetHealthPCT $npc ]
# 		set spellid [ ::AI::Check $npc $victim 24307 ]
# 		# Passive Despawn
# 		if { $mobh <=50 } {
# 			set spellid [ ::AI::Check $npc $victim 8910 ]
# 			# Rejuvenation
# 		}
# 		if { $mobh <=50 && $spellid == 0 } {
# 			set spellid [ ::AI::Check $npc $victim 8903 ]
# 			# Healing Touch
# 		}
# 		if { [::AI::VictimIsEscaping] && $spellid == 0 } {
# 			set spellid [ ::AI::Check $npc $victim 9853 ]
# 			# Entangling Roots
# 		}
# 		if { $spellid == 0 } {
# 			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
# 		}
# 		return [ ::AI::Cast $npc $victim $spellid ]
# 	}
# }


namespace eval ::Lethon {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "20677 24838 15847"
		# Cleave, Shadow Bolt Whirl, Noxious Breath(24818), Deep Sleep, Tail Sweep
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::2Emeriss {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "20677 15847 24818 9256 22948 24928"
		# Cleave, Tail Sweep, Noxious Breath(24818), Deep Sleep, Spore Cloud, Volatile Infection
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::2Taerar {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "20677 15847 24818 9256 22686 24857"
		# Cleave, Tail Sweep, Noxious Breath(24818), Deep Sleep, Bellowing Roar, Arcane Blast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $mobh <= 25 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 24841 ]
			# Shade of Taerar 1
		}
		if { $spellid == 0 && $mobh <= 25 } {
			set spellid [ ::AI::Check $npc $victim 24842 ]
			# Shade of Taerar 2
		}
		if { $spellid == 0 && $mobh <= 25 } {
			set spellid [ ::AI::Check $npc $victim 24843 ]
			# Shade of Taerar 3
		}
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::ShadeOfTaerar {
	proc CanCast { npc victim } {
		set spellid [ ::AI::Check $npc $victim 24307 ]
		# Passive Despawn
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::LordKazzak {
	proc CanCast { npc victim } {
		set spell_list "21341 21056 22709 8255 23931"
		# Shadow Bolt Volley, Mark of Kazzak, Void Bolt, Strong Cleave, Thunderclap
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Azuregos {
	proc CanCast { npc victim } {
		set spell_list "22479 21099 23187 21097 21098 20677"
		# Frost Breath, Frost Breath (Unmounting), Frost Burn, Manastorm, Chill, Cleave
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TeremustheDevourer {
	proc CanCast { npc victim } {
		set spell_list "20712 12667"
		# Flame Breath, Soul Consumption
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

#---Other---#

namespace eval ::DuneSmasher {
	proc CanCast { npc victim } {
		# Head Crack (3148)
		return [ ::AI::Cast $npc $victim 3148 ]
	}
}


namespace eval ::DiseasedBlackBear {
	proc CanCast { npc victim } {
		# Infected Wound (17230)
		return [ ::AI::Cast $npc $victim 17230 ]
	}
}


namespace eval ::Diemetradon {
	proc CanCast { npc victim } {
		# Dire Growl (13692)
		return [ ::AI::Cast $npc $victim 13692 ]
	}
}


namespace eval ::CursedOoze {
	proc CanCast { npc victim } {
		# Wither Touch (13483)
		return [ ::AI::Cast $npc $victim 13483 ]
	}
}


namespace eval ::CentipaarWasp {
	proc CanCast { npc victim } {
		# Thrash (21919)
		return [ ::AI::Cast $npc $victim 21919 ]
	}
}


namespace eval ::CelebrianDryad {
	proc CanCast { npc victim } {
		# Throw (16000)
		return [ ::AI::Cast $npc $victim 16000 ]
	}
}


namespace eval ::CelebrastheCursed {
	proc CanCast { npc victim } {
		# Wrath (9912)
		return [ ::AI::Cast $npc $victim 9912 ]
	}
}


namespace eval ::CarrionVulture {
	proc CanCast { npc victim } {
		set spell_list "17230 18144"
		# Infected Wound (17230), Swoop (18144)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodscalpAxeThrower {
	proc CanCast { npc victim } {
		set spell_list "22887 15716"
		# Throw (axe) [16075], Enrage (self) [15716]
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodpetalTrapper {
	proc CanCast { npc victim } {
		set spell_list "14111 9852"
		# Bloodpetal Poison (14111), Entangling Roots r5 (9852)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodpetalThresher {
	proc CanCast { npc victim } {
		set spell_list "14111 21919"
		# Thrash (21919), Bloodpetal Poison (14111)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodpetalFlayer {
	proc CanCast { npc victim } {
		set spell_list "14111 14112"
		# Bloodpetal Poison (14111), Flaying Vine (14112)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodfenLashtail {
	proc CanCast { npc victim } {
		# Lash (6607)
		return [ ::AI::Cast $npc $victim 6607 ]
	}
}


namespace eval ::BloodSeeker {
	proc CanCast { npc victim } {
		# Expose Weakness (7140)
		return [ ::AI::Cast $npc $victim 7140 ]
	}
}


namespace eval ::BlazingElemental {
	proc CanCast { npc victim } {
		# Fire Shield IV (11350)
		return [ ::AI::Cast $npc $victim 11350 ]
	}
}


namespace eval ::AngerclawBear {
	proc CanCast { npc victim } {
		# Enrage (15716)
		return [ ::AI::Cast $npc $victim 15716 ]
	}
}


namespace eval ::AnathektheCruel {
	proc CanCast { npc victim } {
		# Head Crack (3148)
		return [ ::AI::Cast $npc $victim 3148 ]
	}
}


namespace eval ::JonJontheCrow {
	proc CanCast { npc victim } {
		# Contagion of Rot (7102)
		return [ ::AI::Cast $npc $victim 7102 ]
	}
}


namespace eval ::JagueroStalker {
	proc CanCast { npc victim } {
		# Sneak (6156)
		return [ ::AI::Cast $npc $victim 6156 ]
	}
}


namespace eval ::JailorBorhuin {
	proc CanCast { npc victim } {
		set spell_list "11879 6533"
		# Disarm (11879), Net (6533)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::JadespineBasilisk {
	proc CanCast { npc victim } {
		set spell_list "3636 20223"
		# Crystalline Slumber (3636), Magic Reflection (20223)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::IronjawBasilisk {
	proc CanCast { npc victim } {
		# Crystal Flash (5106)
		return [ ::AI::Cast $npc $victim 5106 ]
	}
}


namespace eval ::Ironpatch {
	proc CanCast { npc victim } {
		# Shield Bash r2 (1671)
		return [ ::AI::Cast $npc $victim 1671 ]
	}
}


namespace eval ::HammerfallGrunt {
	proc CanCast { npc victim } {
		set spell_list "3019 17230"
		# Berserk (3019), Infected Wound (17230)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HatefuryTrickster {
	proc CanCast { npc victim } {
		set spell_list "15716 13518"
		# Poison (13518),Enrage (15716)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HatefuryShadowstalker {
	proc CanCast { npc victim } {
		set spell_list "15716 8629"
		# Enrage (15716),Gouge r3(8629)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HatefuryRogue {
	proc CanCast { npc victim } {
		set spell_list "15716 6156"
		# Enrage (15716),Sneak (6156)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HatefuryHellcaller {
	proc CanCast { npc victim } {
		set spell_list "15716 2941"
		# Enrage (15716),Immolate (2941)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HatefuryFelsworn {
	proc CanCast { npc victim } {
		# Enrage (15716)
		return [ ::AI::Cast $npc $victim 15716 ]
	}
}


namespace eval ::HatefuryBetrayer {
	proc CanCast { npc victim } {
		# Enrage (15716)
		return [ ::AI::Cast $npc $victim 15716 ]
	}
}


namespace eval ::HarvestGolem {
	proc CanCast { npc victim } {
		# Tetanus (8014)
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::HauntingPhantasm {
	proc CanCast { npc victim } {
		# Summon Illusionary Phantasm (8986)
		return [ ::AI::Cast $npc $victim 8986 ]
	}
}


# todo: find the right spells for the other healing wards
namespace eval ::HealingWard {
	proc CanCast { npc victim } {
		# Healing Aura (5607)
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}

namespace eval ::GreaterHealingWard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}

namespace eval ::PowerfulHealingWard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}

namespace eval ::SuperiorHealingWard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}

namespace eval ::HealingWardIV {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}

namespace eval ::HealingWardV {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5607 ]
	}
}


namespace eval ::Grawmug {
	proc CanCast { npc victim } {
		# Backhand (6253)
		return [ ::AI::Cast $npc $victim 6253 ]
	}
}


namespace eval ::YoungGoretusk {
	proc CanCast { npc victim } {
		# Rushing Charge (6268)
		return [ ::AI::Cast $npc $victim 6268 ]
	}
}


namespace eval ::Goretusk {
	proc CanCast { npc victim } {
		# Rushing Charge (6268)
		return [ ::AI::Cast $npc $victim 6268 ]
	}
}


namespace eval ::Gorlash {
	proc CanCast { npc victim } {
		# Trample (5568)
		return [ ::AI::Cast $npc $victim 5568 ]
	}
}


namespace eval ::Gnawbone {
	proc CanCast { npc victim } {
		# Rend (6547)
		return [ ::AI::Cast $npc $victim 6547 ]
	}
}


namespace eval ::GriknirtheCold {
	proc CanCast { npc victim } {
		set spell_list "6957 8056"
		# Frostmane Strength (6957), Frost Shock r1 (8056)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GiltharesFirebough {
	proc CanCast { npc victim } {
		set spell_list "6268 6268"
		# Rushing Charge R1 (6268, 6268)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GlasshideGazer {
	proc CanCast { npc victim } {
		# Crystal Gaze (3635)
		return [ ::AI::Cast $npc $victim 3635 ]
	}
}


namespace eval ::GiantBuzzard {
	proc CanCast { npc victim } {
		# Infected Wound (17230)
		return [ ::AI::Cast $npc $victim 17230 ]
	}
}


namespace eval ::GiantAshenvaleBear {
	proc CanCast { npc victim } {
		# Growl of Fortitude (self) [4148]
		return [ ::AI::Cast $npc $victim 4148 ]
	}
}


namespace eval ::GhostpawHowler {
	proc CanCast { npc victim } {
		# Blood Howl (3264)
		return [ ::AI::Cast $npc $victim 3264 ]
	}
}


namespace eval ::FrostmaneSnowstrider {
	proc CanCast { npc victim } {
		# Phase Out (3648), Faerie Fire (770)
		set spell_list "3648 770"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FrostmaneNovice {
	proc CanCast { npc victim } {
		# Frostbolt r1 (116)
		return [ ::AI::Cast $npc $victim 116 ]
	}
}


namespace eval ::FreezingSpirit {
	proc CanCast { npc victim } {
		# Frost Nova (9915)
		return [ ::AI::Cast $npc $victim 9915 ]
	}
}


namespace eval ::Feeboz {
	proc CanCast { npc victim } {
		set spell_list "16415 6131"
		# Fireball r (16415), Frost Nova r (6131)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FoulwealdDenWatcher {
	proc CanCast { npc victim } {
		# Corrupted Stamina (6819)
		return [ ::AI::Cast $npc $victim 6819 ]
	}
}


namespace eval ::FoulwealdShaman {
	proc CanCast { npc victim } {
		set spell_list "6818 8160"
		# Corrupted Intellect (6818), (Totem) Strength of earth totem II (8160)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FoulwealdTotemic {
	proc CanCast { npc victim } {
		set spell_list "6818 6363"
		# Corrupted Intellect (6818), (Totem) Searing Totem II (6363)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FoulwealdUrsa {
	proc CanCast { npc victim } {
		set spell_list "6816 9080"
		# Corrupted Strength (6816), Hamstring (9080)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FoulwealdWarrior {
	proc CanCast { npc victim } {
		# Corrupted Strength (6816)
		return [ ::AI::Cast $npc $victim 6816 ]
	}
}


namespace eval ::ForsakenAssassin {
	proc CanCast { npc victim } {
		set spell_list "14897 1785"
		# Slowing Poison (14897), â Stealth r2 (1785)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ForsakenDarkStalker {
	proc CanCast { npc victim } {
		# Throw (22887) knifes
		return [ ::AI::Cast $npc $victim 22887 ]
	}
}


namespace eval ::ForsakenInfiltrator {
	proc CanCast { npc victim } {
		set spell_list "13518 6634"
		# Poison (13518), Phasing Stealth (6634)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ForsakenIntruder {
	proc CanCast { npc victim } {
		set spell_list "1785 2590"
		# Stealth r2 (1785), Backstab r3 (2590)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ForlornSpirit {
	proc CanCast { npc victim } {
		# Curse of Stalvan (13524)
		return [ ::AI::Cast $npc $victim 13524 ]
	}
}


namespace eval ::FetidCorpse {
	proc CanCast { npc victim } {
		# Contagion of Rot (7102)
		return [ ::AI::Cast $npc $victim 7102 ]
	}
}


namespace eval ::FerociousYeti {
	proc CanCast { npc victim } {
		# Enrage (15716)
		return [ ::AI::Cast $npc $victim 15716 ]
	}
}


namespace eval ::Felslayer {
	proc CanCast { npc victim } {
		# Mana Burn (15800)
		return [ ::AI::Cast $npc $victim 15800 ]
	}
}


namespace eval ::IvartheFoul {
	proc CanCast { npc victim } {
		# Foul Odor (7667),Dazed (1604)
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] } else { return [ ::AI::Cast $npc $victim 7667 ] }
	}
}


namespace eval ::KrethisShadowspinner {
	proc CanCast { npc victim } {
		# Shadow Shock (17439)
		return [ ::AI::Cast $npc $victim 17439 ]
	}
}


namespace eval ::GiantGrizzledBear {
	proc CanCast { npc victim } {
		# Dazed
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::SilverpineDeathguard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 0 ]
	}
}


namespace eval ::RavenclawApparition {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 15 } ]
		switch -- $rndSay {
			1	{ ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
			5	{ ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
			10	{ ::AI::MobSay $npc 0 [ ::Texts::Get "msg3" ] }
			15	{ ::AI::MobSay $npc 0 [ ::Texts::Get "msg4" ] }
		}
		return $::AI::NoSpell
	}
}


namespace eval ::RavenclawRaider {
	proc CanCast { npc victim } {
		# Cursed Blade (5271)
		return [ ::AI::Cast $npc $victim 5271 ]
	}
}


namespace eval ::RavenclawServant {
	proc CanCast { npc victim } {
		# Curse of Agony r1(980),Dazed (1604)
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] } else { return [ ::AI::Cast $npc $victim 980 ] }
	}
}


namespace eval ::RavenclawSlave {
	proc CanCast { npc victim } {
		# Shared Bonds (7761)
		return [ ::AI::Cast $npc $victim 7761 ]
	}
}


namespace eval ::PyrewoodElder {
	proc CanCast { npc victim } {
		set spell_list "2053 1604"
		# Lesser Heal r3 (self) (2053),Dazed (1604)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 1604 } {
			if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
		return $::AI::NoSpell
	}
}


namespace eval ::PyrewoodSentry {
	proc CanCast { npc victim } {
		set spell_list "72 2565"
		# Shield Bash r1 (72),Shield Block (self) (2565)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PyrewoodWatcher {
	proc CanCast { npc victim } {
		# Shoot (Shoots at an enemy) (23073)
		return [ ::AI::Cast $npc $victim 23073 ]
	}
}


namespace eval ::MossStalker {
	proc CanCast { npc victim } {
		# Poison (13518)
		return [ ::AI::Cast $npc $victim 13518 ]
	}
}


namespace eval ::MoonrageBloodhowler {
	proc CanCast { npc victim } {
		# Blood Howl (3264)
		return [ ::AI::Cast $npc $victim 3264 ]
	}
}


namespace eval ::MoonrageDarkrunner {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 30 } ]
	if { ($rndSay < 3) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
		return $::AI::NoSpell
	}
}


namespace eval ::MoonrageDarksoul {
	proc CanCast { npc victim } {
		# Enrage (15716)
		return [ ::AI::Cast $npc $victim 15716 ]
	}
}


namespace eval ::MoonrageGlutton {
	proc CanCast { npc victim } {
		# Blood Leech (11898)
		return [ ::AI::Cast $npc $victim 11898 ]
	}
}


namespace eval ::MoonrageWhitescalp {
	proc CanCast { npc victim } {
		# Chilled r1 (7321)
		return [ ::AI::Cast $npc $victim 7321 ]
	}
}


namespace eval ::MistCreeper {
	proc CanCast { npc victim } {
		# Poison (13518),Dazed (1604)
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] } else { return [ ::AI::Cast $npc $victim 13518 ] }
	}
}


namespace eval ::ElderLakeSkulker {
	proc CanCast { npc victim } {
		# Wild Regeneration (self) (9616)
		return [ ::AI::Cast $npc $victim 9616 ]
	}
}


namespace eval ::LakeSkulker {
	proc CanCast { npc victim } {
		# Moss Covered Hands (6867)
		return [ ::AI::Cast $npc $victim 6867 ]
	}
}


namespace eval ::DalaranApprentice {
	proc CanCast { npc victim } {
		set spell_list "205 7321"
		# Frostbolt r2 (205), Chilled r1 (7321)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DalaranConjuror {
	proc CanCast { npc victim } {
		# Shadow Bolt r3(705)
		return [ ::AI::Cast $npc $victim 705 ]
	}
}


namespace eval ::DalaranMage {
	proc CanCast { npc victim } {
		set spell_list "145 134"
		# Fireball r3(145), Fire Shield I (self) (134)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DalaranProtector {
	proc CanCast { npc victim } {
		# Summon Dalaran Serpent (3615)
		return [ ::AI::Cast $npc $victim 3615 ]
	}
}


namespace eval ::DalaranSerpent {
	proc CanCast { npc victim } {
		# Dazed
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::DalaranWarder {
	proc CanCast { npc victim } {
		# Summon Dalaran Serpent (3615)
		return [ ::AI::Cast $npc $victim 3615 ]
	}
}


namespace eval ::DalaranWizard {
	proc CanCast { npc victim } {
		set spell_list "837 122 7321"
		# Frostbolt r3(837),Frost Nova r1 (122), Chilled r1 (7321)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Volchan {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 21333 ]
	}
}


namespace eval ::Shadowclaw {
	proc CanCast { npc victim } {
		set spell_list "8552 11980 12493 12741 17227 18267 21007"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GreymistSeer {
	proc CanCast { npc victim } {
		set spell_list "324"
		# Lightning Shield
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkshoreThresher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12097 ]
	}
}


namespace eval ::RagingMoonkin {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11977 ]
		# Rend
	}
}


namespace eval ::MoonkinOracle {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 9739 ]
		# Wrath
	}
}


namespace eval ::WildGrell {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5915 ]
	}
}


namespace eval ::LordMelenas {
	proc CanCast { npc victim } {
		set spell_list "1822 1823 1824 9904"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MirefinMurloc {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillMurloc {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MarshMurloc {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocScout {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocTidecaller {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocNightcrawler {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocWarrior {
	proc CanCast { npc victim } {
		set spell_list "7357 15656 21463 21543"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FleshGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::CrackedGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::RemoteControlledGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::StoneGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::SiegeGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::WarGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::ObsidianGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::TemperedWarGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::HeavyWarGolem {
	proc CanCast { npc victim } {
		set spell_list "8014 4282 5568"
		# Tetanus, Stomp, Trample
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FaultyWarGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::GangledGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::RagereaverGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::MoltenWarGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::LavaGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::VentureCoEngineer {
	proc CanCast { npc victim } {
		set spell_list "4074 4078"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::VentureCoBuilder {
	proc CanCast { npc victim } {
		set spell_list "4074 4078"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DethryllSatyr {
	proc CanCast { npc victim } {
		set spell_list "3011 17353"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DecrepitDarkhound {
	proc CanCast { npc victim } {
		set spell_list "1604 5101 13496 15571"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RavenousDarkhound {
	proc CanCast { npc victim } {
		set spell_list "1604 5101 13496 15571"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RotHideGnoll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideGladerunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideMystic {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideBrute {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHidePlagueWeaver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideSavage {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideRaging {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideBruiser {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::SupervisorLugwizzle {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 4078 ]
	}
}


namespace eval ::WastewanderRogue {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 23196 ]
	}
}


namespace eval ::RogueFlameSpirit {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11968 ]
	}
}


namespace eval ::BurningRavager {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11968 ]
	}
}


namespace eval ::BurningDestroyer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11968 ]
	}
}


namespace eval ::SilithidSwarm {
	proc CanCast { npc victim } {
		set spellid 0
		# Spells disabled ;p
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BefouledWaterElemental {
	proc CanCast { npc victim } {
		set spell_list "11831 12674"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WailingHighborne {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5884 ]
	}
}

# ----- Original by WoWEmu (Fixed) -----

namespace eval ::EnragedRockElemental {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8269 ]
	}
}


namespace eval ::Eliza {
	proc CanCast { npc victim } {
		set spell_list "8406 865"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ElderStranglethornTiger {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 18078 ]
	}
}


namespace eval ::ElderShadowhornStag {
	proc CanCast { npc victim } {
		set spell_list "6921 6922"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RagingThunderLizard {
	proc CanCast { npc victim } {
		set spell_list "15612 8269"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ElderThunderLizard {
	proc CanCast { npc victim } {
		set spell_list "15612 8269"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::EarthgrabTotem {
	proc CanCast { npc victim } {
	   set rnd [ expr { rand() * 10 } ]
		 if { $rnd <= 2 } {
			  return [ ::AI::Cast $npc $victim 8378 ]
		 } else {
			  return $::AI::NoSpell
		 }
	}
}


namespace eval ::EarthenRocksmasher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11998 ]
	}
}


namespace eval ::EarthenSculptor {
	proc CanCast { npc victim } {
		set spell_list "11350 22433"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::EarthenStonecarver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 23341 ]
	}
}


namespace eval ::DustbelcherOgre {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 17230 ]
	}
}


namespace eval ::DrywhiskerSurveyor {
	proc CanCast { npc victim } {
		set spell_list "865 12486"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DrywhiskerDigger {
	proc CanCast { npc victim } {
		set spell_list "16401 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkmistSilkspinner {
	proc CanCast { npc victim } {
		set spell_list "16401 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkmistRecluse {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2819 ]
	}
}


namespace eval ::DarkmistLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 16401 ]
	}
}


namespace eval ::DarkStrandFanatic {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7098 ]
	}
}


namespace eval ::DaggerspineShorehunter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 16000 ]
	}
}


namespace eval ::DaggerspineScreamer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3589 ]
	}
}


namespace eval ::DaggerspineShorestalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12555 ]
	}
}


namespace eval ::DaggerspineSiren {
	proc CanCast { npc victim } {
		set spell_list "992 8246"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CursedHighborne {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5884 ]
	}
}


namespace eval ::CrystalSpineBasilisk {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3635 ]
	}
}


namespace eval ::CrestingExile {
	proc CanCast { npc victim } {
		set spell_list "12486 865"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GlasshidePetrifier {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11030 ]
	}
}


namespace eval ::Choksul {
	proc CanCast { npc victim } {
		set spell_list "10101 18670 18813 18945 19633 20686 18072"
		# Knock Away (10101,18670,18813,18945,19633,20686), Uppercut(18072)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CarrionRecluse {
	proc CanCast { npc victim } {
		set spell_list "3609 8313"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaptainStillwater {
	proc CanCast { npc victim } {
		set spell_list "10201 8814 6725"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaptainKeelhaul {
	proc CanCast { npc victim } {
		set spell_list "7896 22121"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoulderfistShaman {
	proc CanCast { npc victim } {
		set spell_list "6364 6041"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoulderfistBrute {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 19128 ]
	}
}


namespace eval ::BoulderfistEnforcer {
	proc CanCast { npc victim } {
		set spell_list "4955 11554"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoulderfistLord {
	proc CanCast { npc victim } {
		set spell_list "4955 10291"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoulderfistMagus {
	proc CanCast { npc victim } {
		set spell_list "12486 8407"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BoulderfistMauler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 4955 ]
	}
}


namespace eval ::BoulderfistOgre {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 4955 ]
	}
}


namespace eval ::BloodscalpHunter {
	proc CanCast { npc victim } {
		set spell_list "15607 8269"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodscalpMystic {
	proc CanCast { npc victim } {
		set spell_list "959 8269"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodscalpShaman {
	proc CanCast { npc victim } {
		set spell_list "8505 945 8269 16401 6041"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodscalpWarrior {
	proc CanCast { npc victim } {
		set spell_list "8269 13534 1671"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodscalpScavenger {
	proc CanCast { npc victim } {
		set spell_list "8269 2591 16401"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodsailElderMagus {
	proc CanCast { npc victim } {
		set spell_list "11310 8402 8423"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodsailMage {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8402 ]
	}
}


namespace eval ::BloodsailSeaDog {
	proc CanCast { npc victim } {
		set spell_list "16401 8629 11279"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodsailSwashbuckler {
	proc CanCast { npc victim } {
		set spell_list "1768 13534"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodsailWarlock {
	proc CanCast { npc victim } {
		set spell_list "7641 11707 11939 12746"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { ($spellid == 11939) || ($spellid == 12746) } {
			set rnd [ expr { rand() * 10 } ]
			if { $rnd > 8 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::BleakheartSatyr {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6947 ]
	}
}


namespace eval ::BleakheartHellcaller {
	proc CanCast { npc victim } {
		 set rnd [ expr { rand() * 10 } ]
		 if { $rnd > 8 } {
			  return [ ::AI::Cast $npc $victim 11939 ]
		 } else {
			  return $::AI::NoSpell
		 }
	}
}


namespace eval ::BurningExile {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8317 ]
	}
}


namespace eval ::BoneflayerGhoul {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7369 ]
	}
}


namespace eval ::Bhagthera {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3147 ]
	}
}


namespace eval ::BaronVardus {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8408 ]
	}
}


namespace eval ::BalgarastheFoul {
	proc CanCast { npc victim } {
		set spell_list "17228 11939"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11939 } {
		 set rnd [ expr { rand() * 10 } ]
		 if { $rnd > 8 } {
			  return [ ::AI::Cast $npc $victim $spellid ]
		 } else {
			  return $::AI::NoSpell
		 }
		} else {
		return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::AshlanStonesmirk {
	proc CanCast { npc victim } {
		set spell_list "9009 9004 9003 9002 8333 4061 3931"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AshenvaleOutrunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 20540 ]
	}
}


namespace eval ::ArgusShadowMage {
	proc CanCast { npc victim } {
		set spell_list "4063 1106"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AnguishedDead {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7068 ]
	}
}


namespace eval ::AncientStoneKeeper {
	proc CanCast { npc victim } {
		set spell_list "6524 10092"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AnayaDawnrunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5884 ]
	}
}


namespace eval ::SkullsplitterWarrior {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1671 ]
	}
}


namespace eval ::DevlinAgamand  {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
	switch -- [ ::GetClass $victim ] {
		1  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
		2  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		3  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg3" ] }
		4  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg4" ] }
		5  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg5" ] }
		7  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg6" ] }
		8  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg7" ] }
		9  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg8" ] }
		11 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg9" ] }
	}
	} elseif { ($rndSay > 23) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg10" ] }
		return [ ::AI::Cast $npc $victim 3148 ]
	}
}


namespace eval ::TormentedSpirit {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7713 ]
	}
}


namespace eval ::WailingAncestor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7713 ]
	}
}


namespace eval ::WanderingSpirit {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7713 ]
	}
}


namespace eval ::RottingAncestor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3322 ]
	}
}


namespace eval ::RottingDead {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3234 ]
	}
}


namespace eval ::RattlecageSkeleton {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::RavagedCorpse {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3234 ]
	}
}


namespace eval ::HungeringDead {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3234 ]
	}
}


namespace eval ::DarkeyeBonecaster {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 116 ]
	}
}


namespace eval ::CrackedSkullSoldier {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 589 ]
	}
}


namespace eval ::CursedDarkhound {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1120 ]
	}
}


namespace eval ::RotHideMongrel {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
		} elseif { ($rndSay > 23) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ]
		}
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::RotHideGraverobber {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
		} elseif { ($rndSay > 23) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ]
		}
		return [ ::AI::Cast $npc $victim 3237 ]
	}
}


namespace eval ::GreaterDuskbat {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::VampiricDuskbat {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::Duskbat {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::Deeb {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 529 ]
	}
}


namespace eval ::VileFinMinorOracle {
	proc CanCast { npc victim } {
		set spell_list "403 324 2607"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::VileFinMuckdweller  {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 53 ]
	}
}


namespace eval ::VileFinShredder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3252 ]
	}
}


namespace eval ::VileFinTidehunter {
	proc CanCast { npc victim } {
		set spell_list "122 7321"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BleedingHorror {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3322 ]
	}
}


namespace eval ::ShamblingHorror {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3234 ]
	}
}


namespace eval ::Mugthol {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11554 ]
	}
}


namespace eval ::RedWyrmkin {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10149 ]
	}
}


namespace eval ::Muckrake {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 676 ]
	}
}


namespace eval ::GrelborgMiser {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11677 ]
	}
}


namespace eval ::TheRake {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12166 ]
	}
}


namespace eval ::Mirelow {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12747 ]
	}
}


namespace eval ::FenLord {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::DalBloodclaw {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 676 ]
	}
}


namespace eval ::Felguard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5164 ]
	}
}


namespace eval ::SearingInfernal {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 134 ]
	}
}


namespace eval ::HighlandScytheclaw {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3147 ]
	}
}


namespace eval ::DarkfangLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::InsaneGhoul {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8282 ]
	}
}


namespace eval ::GraveRobber {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6595 ]
	}
}


namespace eval ::MorLadim {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3547 ]
	}
}


namespace eval ::DashelStonefist {
	proc CanCast { npc victim } {
		set spell_list "5164 1604 6713 9128"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ZhevraRunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::FlatlandCougar {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::Swoop {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5708 ]
	}
}


namespace eval ::WirySwoop {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5708 ]
	}
}


namespace eval ::GalakCentaur {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::Gobbler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}


namespace eval ::CorrosiveSwampOoze {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 9640 ]
	}
}


namespace eval ::LightningHide {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6255 ]
	}
}


namespace eval ::ThunderLizard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6255 ]
	}
}


namespace eval ::Felstalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::LieutenantBenedict {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3248 ]
	}
}


namespace eval ::DeathstalkerAdamant {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1777 ]
	}
}


namespace eval ::WarlordKolkanis {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8078 ]
	}
}


namespace eval ::GreaterPlainstrider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::HelcularRemains {
	proc CanCast { npc victim } {
		 set rnd [ expr { rand() * 10 } ]
		 if { $rnd > 8 } {
			  return [ ::AI::Cast $npc $victim 4950 ]
		 } else {
			  return $::AI::NoSpell
		 }
	}
}


namespace eval ::Targ {
	proc CanCast { npc victim } {
		set spell_list "8078 11608"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ShadowforgeSurveyor {
	proc CanCast { npc victim } {
		set spell_list "10230 12486 145"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SyndicateMagus {
	proc CanCast { npc victim } {
		set spell_list "12486 837"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Gutspill {
	proc CanCast { npc victim } {
		set spell_list "3424 744"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BrainEater {
	proc CanCast { npc victim } {
		set spell_list "3429 3436"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SunscaleLashtail {
	proc CanCast { npc victim } {
		set spell_list "1604 6607 8016"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Zalazane {
	proc CanCast { npc victim } {
		set spell_list "332 7289 8066 687"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::YarrogBaneshadow {
	proc CanCast { npc victim } {
		set spell_list "348 172"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SurenaCaledon {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 143 ]
	}
}


namespace eval ::MorgantheCollector {
	proc CanCast { npc victim } {
		set spell_list "1776 53"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LadyMoongazer {
	proc CanCast { npc victim } {
		set spell_list "6533 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::UndeadDynamiter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8800 ]
	}
}


namespace eval ::UndeadExcavator {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5137 ]
	}
}


namespace eval ::UndercityGuardian {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 20 } ]
	if { ($rnd > 3) && ($rnd < 12) } {
		return [ ::AI::Cast $npc $victim 19502 ]
		} else {
		return $::AI::NoSpell
		}
	}
}


namespace eval ::MistHowler {
	proc CanCast { npc victim } {
		set spell_list "6548 3604 8715"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WrithingHighborne {
	proc CanCast { npc victim } {
		set spell_list "5884 1604"
		# Banshee Curse, Dazed
	     set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CarnivoustheBreaker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}


namespace eval ::DustDevil {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6982 ]
	}
}


namespace eval ::Vagash {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3143 ]
	}
}


namespace eval ::Sarkoth {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::SurfCrawler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::PygmySurfCrawlerr {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 10 } ]
		if { $rnd <= 3 } {
			return [ ::AI::Cast $npc $victim 1604 ]
		} else {
			return $::AI::NoSpell
		}
	}
}


namespace eval ::YoungThreshadon {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::MakruraClacker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::Makasgar {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::GreenRecluse {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::PlagueSpreader {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3436 ]
	}
}


namespace eval ::BoneChewer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}


namespace eval ::OrgrimmarGrunt {
	proc CanCast { npc victim } {
		set spell_list "1604 11609"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Bellygrub {
	proc CanCast { npc victim } {
		set spell_list "5568 1604 8260"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RuklartheTrapper {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 22) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		set spell_list "3143 12024"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LepperGnome {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 13 [ ::Texts::Get "msg1" ]
	}
		set spell_list "1604 13496 6951"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Fleshripper {
	proc CanCast { npc victim } {
		set spell_list "1604 12166"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OldIcebeard {
	proc CanCast { npc victim } {
		set spell_list "3145 3146 6788"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::EdanHowler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3129 ]
	}
}


namespace eval ::Vejrek {
	proc CanCast { npc victim } {
		set spell_list "7386 71"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GreatFatherArctikus {
	proc CanCast { npc victim } {
		set spell_list "465 139"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

# widespread typo
namespace eval ::GreatFatherArcticus { proc CanCast { npc victim } { ::GreatFatherArctikus::CanCast $npc $victim } }


namespace eval ::Xabraxxis {
	proc CanCast { npc victim } {
		set spell_list "970 1604"
		# Shadow Word: Pain (Rank 3), Dazed
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GithyssVile {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 526 ]
	}
}


namespace eval ::VileFamiliar {
	proc CanCast { npc victim } {
		set spell_list "133 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WebwoodLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 526 ]
	}
}


namespace eval ::CliffLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 526 ]
	}
}


namespace eval ::TimberlingTrampler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5568 ]
	}
}


namespace eval ::UrsalMauler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6807 ]
	}
}


namespace eval ::DireCondor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5708 ]
	}
}


namespace eval ::Mangeclaw {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::ForestLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::WrathtailSorceress {
	proc CanCast { npc victim } {
		set spell_list "7322 865"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Tharilzun {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3631 ]
	}
}


namespace eval ::MountainBuzzard {
	proc CanCast { npc victim } {
		set spell_list "1604 8014"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BerserkTrogg {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 43 ]
	}
}


namespace eval ::BossGalgosh {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 43 ]
	}
}


namespace eval ::Gnasher {
	proc CanCast { npc victim } {
		set spell_list "3229 3393"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::IronforgeMountaineer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7918 ]
	}
}


namespace eval ::BleakWorg {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7127 ]
	}
}


namespace eval ::BaeldunAppraiser {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2052 ]
	}
}


namespace eval ::RottingSlime {
	proc CanCast { npc victim } {
		 set rnd [ expr { rand() * 10 } ]
		 if { $rnd > 9 } {
			  return [ ::AI::Cast $npc $victim 6464 ]
		 } else {
			  return [ ::AI::Cast $npc $victim 6464 ]
		 }
	}
}


namespace eval ::Buzzard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 17230 ]
	}
}


namespace eval ::WitherbarkTroll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 4974 ]
	}
}


namespace eval ::WitherbarkBerserker {
	proc CanCast { npc victim } {
		set spell_list "43 4974"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WitherbarkShadowHunter {
	proc CanCast { npc victim } {
		set spell_list "1852 594"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WitherbarkShadowcaster {
	proc CanCast { npc victim } {
		set spell_list "695 18708"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WitherbarkWitchDoctor {
	proc CanCast { npc victim } {
		set spell_list "8187 19939"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
	if { $spellid == 8187 } {
	   set rnd [ expr { rand() * 10 } ]
		 if { $rnd <= 2 } {
			  return [ ::AI::Cast $npc $victim $spellid ]
		 } else {
			  return $::AI::NoSpell
		 }
		} else {
		return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::MountainYeti {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2139 ]
	}
}


namespace eval ::GiantYeti {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2139 ]
	}
}


namespace eval ::CrushridgeWarmonger {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 13046 ]
	}
}


namespace eval ::CrushridgeEnforcer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3148 ]
	}
}


namespace eval ::CrushridgePlunderer {
	proc CanCast { npc victim } {
		set spell_list "8858 11608"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CrushridgeMage {
	proc CanCast { npc victim } {
		set spell_list "837 379"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CrushridgeMauler {
	proc CanCast { npc victim } {
		set spell_list "11976 6253"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StonevaultShaman {
	proc CanCast { npc victim } {
		set spell_list "8498 4971"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set rnd [ expr { rand() * 10 } ]
		if { $rnd <= 2 } {
			return [ ::AI::Cast $npc $victim $spellid ]
		} else {
			return $::AI::NoSpell
		}
	}
}


namespace eval ::StonevaultBonesnapper {
	proc CanCast { npc victim } {
		set spell_list "11976 6554"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::LieutenantSanders {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::CaptainVachon {
	proc CanCast { npc victim } {
		set spell_list "72 3248 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaptainMelrache {
	proc CanCast { npc victim } {
		set spell_list "11976 10290"
		# Strike, Devotion Aura (Rank 2)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletBodyguard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2565 ]
		# Shield Block (75% increased chance)
	}
}


namespace eval ::ScarletFriar {
	proc CanCast { npc victim } {
		# Lesser Heal R2 (2052) (allies)
		return [ ::AI::Cast $npc $victim 2052 ]
	}
}


namespace eval ::ScarletInitiate {
	proc CanCast { npc victim } {
		set spell_list "7321 133"
		# Chilled (Rank 1), Fireball (Rank 1)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletNeophyte {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 205 ]
		# Frostbolt (Rank 2)
	}
}


namespace eval ::ScarletVanguard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 72 ]
	}
}


namespace eval ::ScarletWarrior {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3238 ]
	}
}


namespace eval ::ScarletChaplain {
	proc CanCast { npc victim } {
		set spell_list "15264 6076 602 6060 988"
		# Holy Fire (Rank 4), Renew (Rank 4), Inner fire (Rank 3), Smite (Rank 6), Dispel (Rank 2)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 15264 } { if { [ ::Distance $npc $victim ] <= 10 } { return [ ::AI::Cast $npc $victim 15264 ] } else { return $::AI::NoSpell }
		} elseif { $spellid == 6076 } { if { $mobh <= 50 } { return [ ::AI::Cast $npc $victim 6076 ] } else { return $::AI::NoSpell }
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}



namespace eval ::ScarletDiviner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8402 ]
	}
}


namespace eval ::ScarletAdept {
	proc CanCast { npc victim } {
		set spell_list "984 1026"
		# Smite (Rank 4), Holy Light (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 1026 } {
			if { $mobh <= 50 } {
				return [ ::AI::Cast $npc $victim 1026 ]
			} else {
				return [ ::AI::Cast $npc $victim 984 ]
			}
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletConjuror {
	proc CanCast { npc victim } {
		set spell_list "895 8985"
		# Fire Elemental
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletMyrmidon {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		if { $mobh <= 20 } { return [ ::AI::Cast $npc $victim 8269 ] } else { return $::AI::NoSpell }
		# Enrage
	}
}


namespace eval ::ScarletProtector {
	proc CanCast { npc victim } {
		set spell_list "19240 20116 20915 5589"
		# Desperate Prayer (Rank 4), Consecration (Rank 1), Seal of Command (Rank 2), Hammer of Justice (Rank 3)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set mobh [ ::GetHealthPCT $npc ]
		if { $spellid == 19240 } { if { $mobh <= 40 } { return [ ::AI::Cast $npc $victim 19240 ] } else { return $::AI::NoSpell }
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::ScarletWizard {
	proc CanCast { npc victim } {
		set spell_list "8438 2601"
		# Arcane Explosion (Rank 3), Fire Shield III
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 8438 } { if { [ ::Distance $npc $victim ] <= 10 } { return [ ::AI::Cast $npc $victim 8438 ] } else { return $::AI::NoSpell }
		} else {
		return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::ScarletChampion {
	proc CanCast { npc victim } {
		set spell_list "5588 20116 20290 20918 17284"
		# Hammer of Justice (Rank 2), Consecration (Rank 1), Seal of Righteousness (Rank 5), Seal of Command, Holy Strike
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 5588 } { if { [ ::Distance $npc $victim ] <= 10 } { return [ ::AI::Cast $npc $victim 5588 ] } else { return $::AI::NoSpell }
		} elseif { $spellid == 20116 } { if { [ ::Distance $npc $victim ] <= 8 } { return [ ::AI::Cast $npc $victim 20116 ] } else { return $::AI::NoSpell }
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::ScarletAbbot {
	proc CanCast { npc victim } {
		set spell_list "6078 6064"
		# Renew (Rank 6), Heal (Rank 4)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScarletCenturion {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11549 ]
		# Battle Shout (Rank 4)
	}
}


namespace eval ::BlackWidowHatchling {
	proc CanCast { npc victim } {
		set spell_list "744 7367"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackRavagerMastiff {
	proc CanCast { npc victim } {
		set spell_list "3149 6548"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SplinterFistWarrior {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 9128 ]
	}
}


namespace eval ::SplinterFistTaskmaster {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3631 ]
	}
}


namespace eval ::SplinterFistFiremonger {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3053 ]
	}
}


namespace eval ::SplinterFistFireWeaver {
	proc CanCast { npc victim } {
		set spell_list "3140 8423"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::NightbaneVileFang {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3427 ]
	}
}


namespace eval ::NightbaneShadowWeaver {
	proc CanCast { npc victim } {
		set spell_list "992 1088"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::NightbaneTaintedOne {
	proc CanCast { npc victim } {
		set spell_list "3424 744"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SkeletalHealer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1088 ]
	}
}


namespace eval ::SkeletalWarder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8699 ]
	}
}


namespace eval ::SkeletalRaider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7992 ]
	}
}


namespace eval ::SkeletalWarrior {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7373 ]
	}
}


namespace eval ::SkeletalFiend {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3416 ]
	}
}


namespace eval ::SkeletalMage {
	proc CanCast { npc victim } {
		set spell_list "12486 7322"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DeviateStalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1784 ]
	}
}


namespace eval ::DeviateCreeper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3427 ]
	}
}


namespace eval ::HordePeon {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6215 ]
	}
}


namespace eval ::HordeDeforester {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8380 ]
	}
}


namespace eval ::HordeScout {
	proc CanCast { npc victim } {
		set spell_list "2480 14276"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HordeShaman {
	proc CanCast { npc victim } {
		set spell_list "547 10391"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WildthornStalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 745 ]
	}
}


namespace eval ::WildthornLurker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::ThistlefurAvenger {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8602 ]
	}
}


namespace eval ::ThistlefurPathfinder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2480 ]
	}
}


namespace eval ::ThistlefurUrsa {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 284 ]
	}
}


namespace eval ::ThistlefurTotemic {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 10 } ]
	if { $rnd <= 2 } {
		return [ ::AI::Cast $npc $victim 6276 ]
		} else {
		return $::AI::NoSpell
		}
	}
}


namespace eval ::ThistlefurDenWatcher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3490 ]
	}
}


namespace eval ::ThistlefurShaman {
	proc CanCast { npc victim } {
		set spell_list "379 332"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BristlebackInterloper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12166 ]
	}
}


namespace eval ::BristlebackQuilboar {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::BristlebackShaman {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 403 ]
	}
}


namespace eval ::BristlebackBattleboar {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3385 ]
	}
}


namespace eval ::ElderTimberling {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 324 ]
	}
}


namespace eval ::MakruraElder {
	proc CanCast { npc victim } {
		set spell_list "5424 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ElderPlainstrider {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 20 } ]
	if { ($rnd > 3) && ($rnd < 8) } {
		return [ ::AI::Cast $npc $victim 7272 ]
		} else {
		return $::AI::NoSpell
		}
	}
}


namespace eval ::GiantWetlandsCrocolisk {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3604 ]
	}
}


namespace eval ::DreadmawCrocolisk  {
	proc CanCast { npc victim } {
		set spell_list "12166 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ElderSaltwaterCrocolisk {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3604 ]
	}
}


namespace eval ::WindfuryWindWitch {
	proc CanCast { npc victim } {
		set spell_list "529 6982 "
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WindfuryMatriarch {
	proc CanCast { npc victim } {
		set spell_list "529 6748"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WindfurySorceress {
	proc CanCast { npc victim } {
		set spell_list "1869 205"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KodoMatriarch {
	proc CanCast { npc victim } {
		set spell_list "5568 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KodoCalf {
	proc CanCast { npc victim } {
		set spell_list "6268 8260"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KodoBull {
	proc CanCast { npc victim } {
		set spell_list "5568"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PalemaneTanner {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 23) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		return [ ::AI::Cast $npc $victim 5176 ]
	}
}


namespace eval ::PalemanePoacher {
	proc CanCast { npc victim } {
		set spell_list "8995 1516"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PalemaneSkinner {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
		} elseif { ($rndSay > 23) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		return [ ::AI::Cast $npc $victim 774 ]
	}
}


namespace eval ::VentureCoSupervisor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6673 ]
	}
}


namespace eval ::VentureCoTaskmaster {
	proc CanCast { npc victim } {
		set spell_list "1604 5679"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::VentureCoLaborer {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::DarkIronInsurgent {
	proc CanCast { npc victim } {
		set spell_list "7020 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronBombardier {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 19784 ]
	}
}


namespace eval ::DarkIronRifleman {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7918 ]
	}
}


namespace eval ::DarkIronShadowcaster {
	proc CanCast { npc victim } {
		set spell_list "1106 2941"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronSupplier {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7365 ]
	}
}


namespace eval ::DarkIronTunneler {
	proc CanCast { npc victim } {
		set spell_list "7891 7164 7405"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BurningBladeFanatic {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5262 ]
	}
}


namespace eval ::BurningBladeApprentice {
	proc CanCast { npc victim } {
		set spell_list "1604 11939"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11939 } {
			if { [ expr { rand() * 10 } ] > 8 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim $spellid ] }
		}
		return $::AI::NoSpell
	}
}


namespace eval ::BurningBladeSummoner {
	proc CanCast { npc victim } {
		set spell_list "7641 11939"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11939 } {
			set rnd [ expr { rand() * 10 } ]
			if { $rnd > 8 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::DustwindPillager {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3147 ]
	}
}


namespace eval ::DustwindSavage {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::DustwindHarpy {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::KulTirasSailor {
	proc CanCast { npc victim } {
		set spell_list "6268 8260"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KulTirasMarine {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::ShadowfangWhitescalp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6136 ]
	}
}


namespace eval ::ShadowfangMoonwalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7121 ]
	}
}


namespace eval ::FenCreeper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1785 ]
	}
}


namespace eval ::ElderMossCreeper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3396 ]
	}
}


namespace eval ::GiantMossCreeper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3396 ]
	}
}


namespace eval ::MoonstalkerSire {
	proc CanCast { npc victim } {
		set spell_list "6595 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MoonstalkerMatriarch {
	proc CanCast { npc victim } {
		 if { [ expr { rand() * 10 } ] > 7 } {
			return [ ::AI::Cast $npc $victim 8594 ]
		 } else {
			return $::AI::NoSpell
		 }
	}
}


namespace eval ::MottledScytheclaw {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3147 ]
	}
}


namespace eval ::MottledRazormaw {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3427 ]
	}
}


namespace eval ::KolkarStormer {
	proc CanCast { npc victim } {
		set spell_list "548 6535"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KolkarWrangler {
	proc CanCast { npc victim } {
		set spell_list "8995 6533"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KolkarDrudge {
	proc CanCast { npc victim } {
		set spell_list "1604 7272"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::KolkarOutrunner {
	proc CanCast { npc victim } {
		set spell_list "1604 7919"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::HexedTroll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 348 ]
	}
}


namespace eval ::VoodooTroll {
	proc CanCast { npc victim } {
		set spell_list "332 324"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ScorpidWorker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6751 ]
	}
}


namespace eval ::ClatteringScorpid {
	proc CanCast { npc victim } {
		set spell_list "744 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::VenomtailScorpid {
	proc CanCast { npc victim } {
		set spell_list "5416 8257 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodtalonTaillasher {
	proc CanCast { npc victim } {
		set spell_list "6268 8260"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodtalonScythemaw {
	proc CanCast { npc victim } {
		set spell_list "6268 8260"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RazormaneScout {
	proc CanCast { npc victim } {
		set spell_list "2480 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RazormaneQuilboar {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5280 ]
	}
}


namespace eval ::RazormaneBattleguard {
	proc CanCast { npc victim } {
		set spell_list "1604 3248"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RazormaneDustrunner {
	proc CanCast { npc victim } {
		set spell_list "6950 16498 774"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DragonmawRaider {
	proc CanCast { npc victim } {
		set spell_list "1604 6533"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DragonmawBonewarder {
	proc CanCast { npc victim } {
		set spell_list "261 1014"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
	if { $spellid == 261 } {
	   set rnd [ expr { rand() * 10 } ]
			if { $rnd > 7 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::DragonmawCenturion {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1672 ]
	}
}


namespace eval ::DragonmawSwamprunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::DragonmawGrunt {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8242 ]
	}
}


namespace eval ::DragonmawScout {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2480 ]
	}
}


namespace eval ::LeechStalker {
	proc CanCast { npc victim } {
		set spell_list "3358 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::CaveStalker {
	proc CanCast { npc victim } {
		set spell_list "3358 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RedWhelp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11554 ]
	}
}


namespace eval ::LostWhelp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3140 ]
	}
}


namespace eval ::FlamesnortingWhelp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3140 ]
	}
}


namespace eval ::CrimsonWhelp {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3053 ]
	}
}


namespace eval ::CursedSailor {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10651 ]
	}
}


namespace eval ::CursedMarine {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10651 ]
	}
}


namespace eval ::CaptainHalyndor {
	proc CanCast { npc victim } {
		set spell_list "10651 3389"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillMuckdweller {
	proc CanCast { npc victim } {
		set spell_list "1777 6533"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillRaider {
	proc CanCast { npc victim } {
		set spell_list "10177 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillForager {
	proc CanCast { npc victim } {
		set spell_list "744 1707"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillWarrior {
	proc CanCast { npc victim } {
		set spell_list "7372 2457"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BluegillOracle {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 10 } ]
		if { $rnd <= 2 } {
			return [ ::AI::Cast $npc $victim 15869 ]
		} else {
			return $::AI::NoSpell
		}
	}
}


namespace eval ::BlackOoze {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3235 ]
	}
}


namespace eval ::CrimsonOoze {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3235 ]
	}
}


namespace eval ::MonstrousOoze {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3235 ]
	}
}


namespace eval ::MosshideTrapper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3288 ]
	}
}


namespace eval ::MosshideMongrel {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8016 ]
	}
}


namespace eval ::MosshideGnoll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8016 ]
	}
}


namespace eval ::MosshideMistweaver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 205 ]
	}
}


namespace eval ::MosshideMystic {
	proc CanCast { npc victim } {
		set spell_list "547 548"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MogroshEnforcer {
	proc CanCast { npc victim } {
		set spell_list "8198 6190"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MogroshOgre {
	proc CanCast { npc victim } {
		set spell_list "5164 3229"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Mogrosh {
	proc CanCast { npc victim } {
		set spell_list "8198 6190"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MogroshMystic {
	proc CanCast { npc victim } {
		set spell_list "529 331"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MogroshShaman {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 529 ]
	}
}


namespace eval ::LochCrocolisk {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::LochFrenzy {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::BlackrockGrunts {
	proc CanCast { npc victim } {
		set spell_list "10852 15609 13608 14030"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockOutrunners {
	proc CanCast { npc victim } {
		set spell_list "10852 15609 13608 14030"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockTracker {
	proc CanCast { npc victim } {
		set spell_list "3019 6190"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockRenegade {
	proc CanCast { npc victim } {
		set spell_list "8242 3019"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GathIlzogg {
	proc CanCast { npc victim } {
		set spell_list "1671 3019"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockSentry {
	proc CanCast { npc victim } {
		set spell_list "3019 5242"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockGladiator {
	proc CanCast { npc victim } {
		set spell_list "6190 3019"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockSummoner {
	proc CanCast { npc victim } {
		set spell_list "705 11939 145"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11939 } {
			if { [ expr { rand() * 10 } ] > 8 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::BlackrockHunter {
	proc CanCast { npc victim } {
		set spell_list "43 22887"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockShadowcaster {
	proc CanCast { npc victim } {
		set spell_list "992 18647 43 705 5242"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockScout {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15547 ]
	}
}


namespace eval ::BlackwoodUrsa {
	proc CanCast { npc victim } {
		set spell_list "1604 1058"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackwoodShaman {
	proc CanCast { npc victim } {
		set spell_list "548 2606"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackwoodWarrior {
	proc CanCast { npc victim } {
		set spell_list "8204"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackwoodPathfinder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 778 ]
	}
}


namespace eval ::BlackwoodWindtalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6982 ]
	}
}


namespace eval ::BlackwoodTotemic {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 10 } ]
		if { $rnd <= 2 } {
			return [ ::AI::Cast $npc $victim 4971 ]
				# Healing Ward V
		} else {
			return $::AI::NoSpell
		}
	}
}


namespace eval ::StormscaleSorceress {
	proc CanCast { npc victim } {
		set spell_list "7322 12486"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StormscaleMyrmidon {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5164 ]
	}
}


namespace eval ::StormscaleToxicologist {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			switch -- [ ::GetClass $victim ] {
				1  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
				2  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
				3  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg3" ] }
				4  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg4" ] }
				5  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg5" ] }
				6  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg6" ] }
				7  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg7" ] }
				8  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg8" ] }
				9  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg9" ] }
				10 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg10" ] }
				11 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg11" ] }
			}
		}
		return [ ::AI::Cast $npc $victim 15498 ]
		# Holy Smite
	}
}


namespace eval ::StormscaleSiren {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15498 ]
		# Holy Smite
	}
}


namespace eval ::StormscaleWaveRider {
	proc CanCast { npc victim } {
		set spell_list "13586 21790"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GreymistHunter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10277 ]
		# Throw
	}
}


namespace eval ::GreymistWarrior {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5242 ]
	}
}


namespace eval ::TwilightThug {
	proc CanCast { npc victim } {
		set spell_list "5164 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TwilightDisciple {
	proc CanCast { npc victim } {
		set spell_list "6074 598"
		# Renew (Rank 2), Smite (Rank 3)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RedridgeThrasher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3427 ]
	}
}


namespace eval ::RedridgeBasher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5164 ]
	}
}


namespace eval ::RedridgeMystic {
	proc CanCast { npc victim } {
		set spell_list "331 548"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RedridgePoacher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7919 ]
	}
}


namespace eval ::RockjawSkullthumper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3148 ]
	}
}


namespace eval ::RockjawBonesnapper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5164 ]
	}
}


namespace eval ::RockjawAmbusher {
	proc CanCast { npc victim } {
		set spell_list "1604 53"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RockjawBackbreaker {
	proc CanCast { npc victim } {
		set spell_list "1604 5164"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StonesplinterScout {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10277 ]
	}
}


namespace eval ::StonesplinterSeer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 529 ]
	}
}


namespace eval ::StonesplinterSkullthumper {
	proc CanCast { npc victim } {
		set spell_list "1776 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StonesplinterBonesnapper {
	proc CanCast { npc victim } {
		set spell_list "11976 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StonesplinterShaman {
	proc CanCast { npc victim } {
		set spell_list "331 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::StonesplinterGeomancer {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2121 ]
	}
}


namespace eval ::StonesplinterDigger {
	proc CanCast { npc victim } {
		set spell_list "7405 71"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Nightsaber {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::FeralNightsaber {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 12166 ]
	}
}


namespace eval ::RascalSprite {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 770 ]
	}
}


namespace eval ::ShadowSprite {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 686 ]
	}
}


namespace eval ::DarkSprite {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5514 ]
	}
}


namespace eval ::VileSprite {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] <= 5 } { return [ ::AI::Cast $npc $victim 8313 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::GnarlpineMystic {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5177 ]
	}
}


namespace eval ::GnarlpineAugur  {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 702 ]
	}
}


namespace eval ::GnarlpinePathfinder {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5177 ]
	}
}


namespace eval ::GnarlpineAvenger {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5915 ]
	}
}


namespace eval ::FrostmaneShadowcaster {
	proc CanCast { npc victim } {
		set spell_list "702 686"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FrostmaneSeer {
	proc CanCast { npc victim } {
		set spell_list "403 770"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::FrostmaneHideskinner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 465 ]
	}
}


namespace eval ::FrostmaneHeadHunter {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10277 ]
	}
}


namespace eval ::Wendigo {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3129 ]
	}
}


namespace eval ::YoungWendigo {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3129 ]
	}
}


namespace eval ::KoboldGeomancer {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
		} elseif { ($rndSay > 22) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ]
		}
		return [ ::AI::Cast $npc $victim 133 ]
	}
}


namespace eval ::Koboldminer {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 22) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}


namespace eval ::KoboldLaborer {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 22) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		return $::AI::NoSpell
	}
}


namespace eval ::Hogger {
	proc CanCast { npc victim } {
		set spell_list "6730 6016"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RiverpawScout {
	proc CanCast { npc victim } {
		set spell_list "6730 6016"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RiverpawMongrel {
	proc CanCast { npc victim } {
		set spell_list "1604 8016"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::RiverpawBrute {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1160 ]
	}
}


namespace eval ::RiverpawHerbalist {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::RabidShadowhideGnoll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::ShadowhideGnoll {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3150 ]
	}
}


namespace eval ::ShadowhideBrute {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6205 ]
	}
}


namespace eval ::ShadowhideDarkweaver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 705 ]
	}
}


namespace eval ::ShadowhideWarrior {
	proc CanCast { npc victim } {
		set spell_list "71 8380 8629"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ShadowhideAssassin {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::FizzleDarkstorm {
	proc CanCast { npc victim } {
		set spellid 0
		set spell_list "11939 695"
		set rnd [ expr { rand() * 10 } ]
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 11939 } {
			if { $rnd <= 2 } {
				return [ ::AI::Cast $npc $victim $spellid ]
			} else {
				return $::AI::NoSpell
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::RustyHarvestGolem {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8014 ]
	}
}


namespace eval ::TunnelRatGeomancer {
	proc CanCast { npc victim } {
		set spell_list "3052 2136"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TunnelRatDigger {
	proc CanCast { npc victim } {
		set spell_list "7386 71"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::TunnelRatScout  {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7919 ]
	}
}


namespace eval ::TunnelRatForager  {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		switch -- [ ::GetClass $victim ] {
			1  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
			2  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
			3  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg3" ] }
			4  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg4" ] }
			5  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg5" ] }
			6  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg6" ] }
			7  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg7" ] }
			8  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg8" ] }
			9  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg9" ] }
			10 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg10" ] }
			11 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg11" ] }
		}
	} elseif { ($rndSay > 23) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg12" ] }
		return [ ::AI::Cast $npc $victim 7365 ]
	}
}


namespace eval ::TunnelRatVermin {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
		if { ($rndSay < 3) } {
			switch -- [ ::GetClass $victim ] {
				1  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ] }
				2  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
				3  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg3" ] }
				4  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg4" ] }
				5  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg5" ] }
				6  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg6" ] }
				7  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg7" ] }
				8  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg8" ] }
				9  { ::AI::MobSay $npc 0 [ ::Texts::Get "msg9" ] }
				10 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg10" ] }
				11 { ::AI::MobSay $npc 0 [ ::Texts::Get "msg11" ] }
			}
		} elseif { ($rndSay > 23) } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg12" ]
		}
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::BloodfeatherSorceress {
	proc CanCast { npc victim } {
		set spell_list "143 6136"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BloodfeatherWindWitch {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6982 ]
	}
}


namespace eval ::MurlocTidehunter {
	proc CanCast { npc victim } {
		set spell_list "744 865"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocOracle {
	proc CanCast { npc victim } {
		set spell_list "13519 6074"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocHunter {
	proc CanCast { npc victim } {
		set spell_list "10277 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocCoastrunner {
	proc CanCast { npc victim } {
		set spell_list "7357 15656"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocMinorTidecaller {
	proc CanCast { npc victim } {
		set spell_list "205 331"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocLurker {
	proc CanCast { npc victim } {
		set spell_list "1604 2589"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MurlocForager {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3368 ]
	}
}


namespace eval ::MurlocShorestriker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6268 ]
	}
}


namespace eval ::MurlocFlesheater {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3393 ]
	}
}


namespace eval ::WitchwingSlayer {
	proc CanCast { npc victim } {
		set spell_list "2426 13840"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WitchwingHarpy {
	proc CanCast { npc victim } {
		set spell_list "2426 13840"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::WitchwingRoguefeather {
	proc CanCast { npc victim } {
		set spell_list "2426 13840"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasRogueWizard {
	proc CanCast { npc victim } {
		set spell_list "6136 116"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasBodyguard	{
	proc CanCast { npc victim } {
		set spell_list "1604 676 53"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasNightRunner {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 1604 ]
	}
}


namespace eval ::DefiasEnchanter {
	proc CanCast { npc victim } {
		set spell_list "3140 12486 3443"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasNightBlade {
	proc CanCast { npc victim } {
		set spell_list "744 7992 2590"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasBandit {
	proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
		::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 22) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		set spell_list "8646 15618"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasTrapper {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 53 ]
	}
}


namespace eval ::DefiasSmuggler {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 2764 ]
	}
}


namespace eval ::DefiasCutpurse {
  proc CanCast { npc victim } {
		set rndSay [ expr { rand() * 25 } ]
	if { ($rndSay < 3) } {
	   ::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
	} elseif { ($rndSay > 22) } { ::AI::MobSay $npc 0 [ ::Texts::Get "msg2" ] }
		return [ ::AI::Cast $npc $victim 53 ]
}
}


namespace eval ::DefiasPillager {
	proc CanCast { npc victim } {
		set spell_list "133 168 143"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasHighwayman {
	proc CanCast { npc victim } {
		set spell_list "1604 53"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasKnuckleduster {
	proc CanCast { npc victim } {
		set spell_list "1604 1671 71"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasPathstalker {
	proc CanCast { npc victim } {
		set spell_list "1604 6554"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DefiasLooter {
	proc CanCast { npc victim } {
		set spell_list "1604 53"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::NightWebMatriarch {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::VenomWebSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::ForestSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::MineSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::YoungNightWebSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6751 ]
	}
}


namespace eval ::NightWebSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6751 ]
	}
}


namespace eval ::ViciousNightWebSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::WebWoodSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6751 ]
	}
}


namespace eval ::GreaterTarantula {
	proc CanCast { npc victim } {
		set spell_list "744 1604 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::Tarantula {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 744 ]
	}
}


namespace eval ::WebWoodSilkspinner {
	proc CanCast { npc victim } {
		set spell_list "744 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::GiantWebWoodSpider {
	proc CanCast { npc victim } {
		set spell_list "744 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MotherFang {
	proc CanCast { npc victim } {
		set spell_list "744 745"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DurotarTiger {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::HecklefangHyena {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::PrairieWolf {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5781 ]
	}
}


namespace eval ::PrairieWolfAlpha {
	proc CanCast { npc victim } {
		set spell_list "1604 5781"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::PrairieStalker {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::WinterWolf {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::CoyotePackleader {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3149 ]
	}
}


namespace eval ::Coyote {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3149 ]
	}
}


namespace eval ::ThistleBear {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::RabidThistleBear {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 3242 ]
	}
}


namespace eval ::DireMottledBoar {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] < 3 } { return [ ::AI::Cast $npc $victim 1604 ] }
		return $::AI::NoSpell
	}
}


namespace eval ::GrizzledThistleBear {
	proc CanCast { npc victim } {
		set spell_list "1604 3242"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::IceClawBear {
	proc CanCast { npc victim } {
		set spell_list "3130 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::SticklyDeer {
	proc CanCast { npc victim } {
		set rnd [ expr { rand() * 20 } ]
	if { ($rnd > 3) && ($rnd < 7) } {
		return [ ::AI::Cast $npc $victim 19502 ]
		} else {
		return $::AI::NoSpell
		}
	}
}


namespace eval ::GreatGoretusk {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6268 ]
	}
}


namespace eval ::Boars {
	proc CanCast { npc victim } {
		set spell_list "6268 1604"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		set rnd [ expr { rand() * 20 } ]
		if { ($rnd == 7) || ($rnd < 5) } {
			return [ ::AI::Cast $npc $victim $spellid ]
		} else {
			return $::AI::NoSpell
		}
	}
}


# Loch Modan --------------------------------------------

namespace eval ::Magosh {
	proc CanCast { npc victim } {
		set spell_list "2606 915"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		# Shock (Rank 2), Lightning Bolt (Rank 4)
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronSapper {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		if { $mobh <= 10 } {
			::AI::MobSay $npc 0 [ ::Texts::Get "msg1" ]
		}
		# Throw Dynamite
		return [ ::AI::Cast $npc $victim 7978 ]
	}
}


# Ashenvale --------------------------------------------

namespace eval ::WildBuck {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] > 10 } { return [ ::AI::Cast $npc $victim 8260 ] } else { return $::AI::NoSpell }
	}
}


namespace eval ::ShadethicketRaincaller {
	proc CanCast { npc victim } {
		set spell_list "8293 915"
		# Lightning Cloud, Lightning Bolt
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::ShadethicketBarkRipper {
	proc CanCast { npc victim } {
		# Tendon Rip
		return [ ::AI::Cast $npc $victim 3604 ]
	}
}


namespace eval ::ShadethicketWoodShaper {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] >= 10 } { return [ ::AI::Cast $npc $victim 19974 ] } else { return $::AI::NoSpell }
	}
}


namespace eval ::ForsakenSeeker {
	proc CanCast { npc victim } {
		# Smite (Rank 4)
		return [ ::AI::Cast $npc $victim 984 ]
	}
}


namespace eval ::DarkStrandCultist {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 13480 ]
	}
}


namespace eval ::DarkStrandAdept {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 13480 ]
	}
}


namespace eval ::ForsakenHerbalist {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7103 ]
	}
}


namespace eval ::CragBoar {
	proc CanCast { npc victim } {
		if { [ ::Distance $npc $victim ] > 10 } { return [ ::AI::Cast $npc $victim 8260 ] } else { return $::AI::NoSpell }
	}
}

# Darkshore --------------------------------------------

namespace eval ::EncrustedTideCrawler {
	proc CanCast { npc victim } {
		# Infected Wound
		return [ ::AI::Cast $npc $victim 3427 ]
	}
}


namespace eval ::DelmanisTheHated {
	proc CanCast { npc victim } {
		# Frostbolt, Flame Blast
		set spell_list "9672 7101"
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 9672 } {
			if { [ ::Distance $npc $victim ] > 10 } {
				return [ ::AI::Cast $npc $victim 9672 ]
			} else {
				return [ ::AI::Cast $npc $victim 7101 ]
			}
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::ReefCrawler {
	proc CanCast { npc victim } {
		# Muscle Tear
		return [ ::AI::Cast $npc $victim 12166 ]
	}
}


namespace eval ::GreymistOracle {
	proc CanCast { npc victim } {
		# Lighting Bolt
		return [ ::AI::Cast $npc $victim 18089 ]
	}
}


namespace eval ::ElderDarkshoreThresher {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 6016 ]
	}
}

# City Guards

namespace eval ::StormwindGuard {
	proc CanCast { npc victim } {
		set spell_list "12169 12170"
		# Shield Block, Revenge
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


# Searing Gorge ------------------------------

namespace eval ::DarkIronTaskmaster {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 5115 ]
		# Battle Command
	}
}


namespace eval ::DarkIronSlaver {
	proc CanCast { npc victim } {
		set spell_list "6533 14118"
		# Net, Rend
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DarkIronLookout {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 7918 ]
		# Shoot Gun
	}
}


namespace eval ::GreaterLavaSpider {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8400 ]
		# Fireball (Rank 5)
	}
}


namespace eval ::TwilightFireGuard {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 15285 ]
		# Fireball Volley
	}
}


namespace eval ::TwilightDarkShaman {
	proc CanCast { npc victim } {
		set spell_list "15306 10395 13010"
		# Shock, Healing Wave (Rank 8), Shrink
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::MagmaElemental {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11306 ]
		# Fire Nova (Rank 4)
	}
}


# Burning Steppes ----------------------------

namespace eval ::FlamescaleWyrmkin {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 23341 ]
		# Fire Buffet
	}
}


namespace eval ::FlamescaleDragonspawn {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8413 ]
		# Fire Blast (Rank 5)
	}
}


namespace eval ::FiregutOgre {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 23202 ]
		# Torch
	}
}


namespace eval ::BlackrockSorcerer {
	proc CanCast { npc victim } {
		set spell_list "8402 10215"
		# Fireball (Rank 7), Flamestrike (Rank 5)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockSoldier {
	proc CanCast { npc victim } {
		set spell_list "19130 3419"
		# Revenge, Improved Blocking
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockSlayer {
	proc CanCast { npc victim } {
		set spell_list "26141 7160"
		# Hamstring, Execute
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::BlackrockWarlock {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 11659 ]
		# Shadow bolt
	}
}


namespace eval ::WarReaver {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 10966 ]
		# Uppercut
	}
}


namespace eval ::ScaldingBroodling {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 8402 ]
		# Fireball (Rank 7)
	}
}


namespace eval ::ThaurissanFirewalker {
	proc CanCast { npc victim } {
		return [ ::AI::Cast $npc $victim 23341 ]
		# Flame Buffet
	}
}


namespace eval ::ThaurissanAgent {
	proc CanCast { npc victim } {
		set spell_list "6685 12540 7918"
		# Piercing Shot, Gouge, Shoot gun
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}



# Blackrock Mountain -----------------------------

namespace eval ::AnvilrageGuardsman {
	proc CanCast { npc victim } {
		set spell_list "2565 11597 13534"
		# Shield Block, Sunder Armor (Rank 5), Disarm
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AnvilrageFootman {
	proc CanCast { npc victim } {
		set spell_list "21949 15614"
		# Rend, Kick
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::QuarrySlave {
	proc CanCast { npc victim } {
		set spell_list "959 26141 11596 16000 26181"
		# Healing Wave (Rank 6), Hamstring, Sunder Armor (Rank 4), Throw, Strike
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		if { $spellid == 26181 } {
			if { [ ::Distance $npc $victim ] <= 5 } { return [ ::AI::Cast $npc $victim 26181 ] } else { return $::AI::NoSpell }
		} else {
			return [ ::AI::Cast $npc $victim $spellid ]
		}
	}
}


namespace eval ::AnvilrageOverseer {
	proc CanCast { npc victim } {
		set spell_list "11998 13589"
		# Strike, Haste Aura
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::AnvilrageWarden {
	proc CanCast { npc victim } {
		set spell_list "15609 11972"
		# Hooked Net, Shield Bash
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::OvermasterPyron {
	proc CanCast { npc victim } {
		set spell_list "11307 10199"
		# Fire Nova, Fire blast (Rank 7)
		set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


# Dragons ---------------------------------------------

namespace eval ::Onyxia {
	proc CanCast { npc victim } {
		set mobh [ ::GetHealthPCT $npc ]
		set spell_list "18431 20677 18435 20228"
		# Bellowing Roar, Flame Breath, Cleave, Pyroblast
		set spellid [ ::AI::Check $npc $victim 18116 ]
		# Anti-Stun
		if { $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 18435 ]
			# Flame Breath
		}
		if { $mobh <= 30 && $spellid == 0 } {
			Emote $npc 254;
			set spellid [ ::AI::Check $npc $victim 17131 ]
			# Hover
		}
		if { $mobh <= 60 && $mobh > 59 && $spellid == 0 } {
			set spellid [ ::AI::Check $npc $victim 20172 ]
			# Spawn Whelps
		}

		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}

namespace eval ::OnyxianWhelp {
	proc CanCast { npc victim } {
		set spell_list "20228"
		# Pyroblast
		set spellid [ ::AI::Check $npc $victim 17472 ]
		# Death Pact(120 second kill timer)
		if { $spellid == 0 } {
			set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
		}
		return [ ::AI::Cast $npc $victim $spellid ]
	}
}


namespace eval ::DragonWhelp {
	proc CanCast { npc victim } {
		# Fireball r6
		return [ ::AI::Cast $npc $victim 145 ]
	}
}



#
# Ahn'Qiraj by elonar
#

namespace eval ::AnubisathSentinel {
    proc CanCast { npc victim } {
        set spell_list "2147 19643 17547 25778 26046 26555 19595 25777 26554"
        # Mend Wound, Mortal Strike(150%), Mortal Strike(200%), Knock Away, Mana Burn, Shadow Storm, Shadow and Frost Reflect, Thorns, Thunderclap
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::AnubisathWarder {
    proc CanCast { npc victim } {
        set spell_list "24648 26072 23207 26073"
        # Entangling Roots, Dust Cloud, Silence, Fire Nova
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::ObsidianEradicator {
    proc CanCast { npc victim } {
        set spell_list "25671 26458"
        # Drain Mana, Shock Blast
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::ObsidianNulifier {
    proc CanCast { npc victim } {
        set spell_list "26787 25671 27794"
        # Nulify, Drain Mana, Cleave
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::QirajiBrainwasher {
    proc CanCast { npc victim } {
        set spell_list "26049 26143 11446"
        # Mana Burn, Mind Flay, Mind Control
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::QirajiLasher {
    proc CanCast { npc victim } {
        set spell_list "29484 26050 26686"
        #Web Spray, Acid Spit, Whirlwind
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::QirajiChampion {
    proc CanCast { npc victim } {
        set spell_list "27794 25778 20511 28798"
        # Cleave, Knock Away, Intimidatting Shout, Enrage
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::QirajiMindSlayer {
    proc CanCast { npc victim } {
        set spell_list "26143 26048 11446 26049"
        # Mind Blast, Mind Blast, Mind Control, Mana burn(fear effect)
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::VeknissGuardian {
    proc CanCast { npc victim } {
        set spell_list "28405 25788 26025"
        # Knockback, Knock Away, Impale
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval :VeknissCrawler {
    proc CanCast { npc victim } {
        set spell_list "26052 25810 25809"
        # Poison Bolt, Mindnumbing Poison, Crippling Poison
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::VeknissSoldier {
    proc CanCast { npc victim } {
        set spell_list "27794"
        # Cleave
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::VeknissStinger {
    proc CanCast { npc victim } {
        set spell_list "25191 25190"
        # Stinger Charge, Stinger Charge(random)
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::VeknissWasp {
    proc CanCast { npc victim } {
        set spell_list "25185 25187"
        # Itch, Hive Zara Catalist
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

#--Bosses--#

namespace eval ::Viscidus {
    proc CanCast { npc victim } {
        set spell_list "25994 25865"
        # Membrane Of Viscidus, Summon Glob Of Viscidus
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Huhuran {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "26052 26051 26180 26050 24857"
        # Frenzy, Poison Bolt, Wivern Poison, Acid Spit
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh <= 25 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 25991 ]
            # Poison Bolt Volley
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 26053 ]
            # Noxious Posion
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 26068 ]
            # Berserk
        }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Skeram {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "785 25679 24685 12001 15708 24857"
        # True Fulfillment, Arcane Explosion, EarthShock,
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh <= 25 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 747 ]
            # Summon Images
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 747 ]
            # Summon Images
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 747 ]
            # Summon Images
        }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}



namespace eval ::LordKri {
    proc CanCast { npc victim } {
        set spell_list "25812 27794 23861"
        # Toxic Volley, Cleave, Summon Poison Cloud
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::PrincessYauj {
    proc CanCast { npc victim } {
        set spell_list "26641 28315 25812"
        # Fear, Heal, Toxic Volley
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Vem {
    proc CanCast { npc victim } {
        set spell_list "22592 25778 25651 25788 20677"
        # Knockdown, Knockaway, Berserker Rage, Chill, Cleave
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Veknilash {
    proc CanCast { npc victim } {
        set spell_list "800 26662 26007 26613 802"
        # Twin Teleport, Berserk, Uppercut, Unbalancing Strike, Mutate Bug
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Veklor {
    proc CanCast { npc victim } {
        set spell_list "800 26662 26006 26607 804 568"
        # Twin Teleport, Berserk, Blizzard, Explode Bug, Arcane Burst
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Fankriss {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "22937 23861 25646"
        # Poison Bolt, Poison Cloud, Mortal Wound
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh <= 25 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28798 ]
            # Enrage
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 26229 ]
            # Summon Player
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 25725]
            # Paralyse
        }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}


namespace eval ::Ouro {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "26103 26102 26058 26060 26100 26093"
        # Sweep, Sand Blast, Summon Ouro Mounds, Summon Ouro Scarabs, Quaqe
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh <= 25 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 17742 ]
            # Disease Cloud 1
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 19798 ]
            # Earthquaqe
        }
        if { $spellid == 0 && $mobh <= 25 } {
            set spellid [ ::AI::Check $npc $victim 28798 ]
            # Enrage
        }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}


namespace eval ::EyeOfCThun {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "26134 26029 26152 26100 26144  26397 26140"
        # Eye Beam, Void Bolt, Strong Cleave, Thunderclap, Manastorm
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 80 && $mobh<= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 26044 ]
            # Mind Flay
        }
        if { $mobh >= 70 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 24838 ]
            # Shadow Bolt Whirl
        }
        if { $mobh >= 60 && $mobh <= 70 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 23011 ]
            # Tears Of The Windseeker
        }
        if { $mobh >= 50 && $mobh <= 60 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 9256 ]
            # Deep Sleep
                }
                if { $mobh >= 1 && $mobh <= 60 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 26232 ]
            # Transform C'thun
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::CThun {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "26156 26769 26152 26100 26144 26213 26766 26332 26476"
        # Carapace Of C'thun, Summon Eye Tentacles, Summon Eye Tentacles, Summon Giant Flesh Tentacles, Summon Giant Eye Tentacles, Summon Mouth Tentacles, Digestive Acid
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 80 && $mobh<= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 26044 ]
            # Mind Flay
        }
        if { $mobh >= 70 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 24838 ]
            # Shadow Bolt Whirl
        }
        if { $mobh >= 60 && $mobh <= 70 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 23011 ]
            # Tears Of The windseeker
        }
        if { $mobh >= 50 && $mobh <= 60 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 17439 ]
            # Shadow Shock
                }
                if { $mobh >= 1 && $mobh <= 60 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 12787 ]
            # Thrash
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

#
# End of Ahn'Qiraj by elonar
#


#
#Naxxramas_ai
#
  
namespace eval ::Tadius {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 1 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28299 ]
        }
        if { $mobh >= 30 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28293 ]
        }
        if { $mobh >= 20 && $mobh <= 70 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28085 28059 ]
        }
        if { $mobh >= 10 && $mobh <= 20 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28099 ]
                  }
                if { $mobh >= 1 && $mobh <= 5 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28498 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Patchwerk {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "28308 22595 22478 22686 10420"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh <= 5 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28308 ]
                }
         if { $mobh >= 5 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28747 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Grablous {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "24838 26140 10887"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 60 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 10887 ]
        }
        if { $mobh >= 1 && $mobh <= 70 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28137 ]
        }
        if { $mobh >= 20 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28206 ]
                }
        if { $mobh >= 1 && $mobh <= 30 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28747 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Glus {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "28407 28311 28241"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 30 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29685 ]
        }
        if { $mobh >= 1 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28405 ]
        }
        if { $mobh >= 1 && $mobh <= 35 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28374 ]
                  }
                if { $mobh >= 1 && $mobh <= 30 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28798 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}


namespace eval ::Fallina {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 30 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29169 ]
        }
        if { $mobh >= 20 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28794 ]
        }
        if { $mobh >= 1 && $mobh <= 35 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29484 ]
                  }
                if { $mobh >= 1 && $mobh <= 30 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28798 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}


namespace eval ::Maxna {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list " 28621  20542 17197  20677 29211"
        set spellid [ ::AI::Check $npc $victim 28621 ]
        # 
        if { $mobh >= 30 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28621 ]
        }
        if { $mobh >= 20 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28741 ]
        }
        if { $mobh >= 1 && $mobh <= 35 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29484 ]
                  }
                if { $mobh >= 1 && $mobh <= 30 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 28131 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Rajubias {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "29107"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 19820 ]
            # Mind Flay
        }        
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::NaxNos {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list " 19129  20542 17197  20677 29211"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        # Anti-Stun
        if { $mobh >= 20 && $mobh <= 100 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29267 9268 29269 29238 ]
        }
        if { $mobh >= 30 && $mobh <= 80 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29211 ]
        }
        if { $mobh >= 60 && $mobh <= 70 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 24838 ]
        }
        if { $mobh >= 10 && $mobh <= 20 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29213 ]
                  }
                if { $mobh >= 1 && $mobh <= 10 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 29214 ]
                }
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Heygun {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 22709"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 22709 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Kosaz {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 20228"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 20228 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Mograin {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 15708"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 15708 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Palriark {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 19630 22433"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 22433 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Blomer {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 20690"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 20690 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::Arubrecan {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "28785 28786 "
          #  not spell dbc fix 29104 29103 28783 Corpse Scarabs(?)
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 19702 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}

namespace eval ::loateb {
    proc CanCast { npc victim } {
        set mobh [ ::GetHealthPCT $npc ]
        set spell_list "20229 19129 11836 20542 17197 19702 19771 23313"
        set spellid [ ::AI::Check $npc $victim 18116 ]
        if { $mobh >= 30 && $mobh <= 90 && $spellid == 0 } {
            set spellid [ ::AI::Check $npc $victim 19702 ]
            # Mind Flay
        }
                
        if { $spellid == 0 } {
            set spellid [ lindex $spell_list [ expr { int( rand() * [ llength $spell_list ] ) } ] ]
        }
        return [ ::AI::Cast $npc $victim $spellid ]
    }
}


#
# End of nax
#

#
# missing aiscripts found in widespread creatures.scp files
#
foreach missing_ai {
	DarkIronGeologist
	DarkIronLandMine
	DarkIronSteamsmith
	DarkIronWatchman
	FenwickThatros
	Gazban
	HandofRavenclaw
	LavaSurger
	MoltenDestroyer
	Occulus
	Prophet_Skeram
	RagingRotHide
	SicklyDeer
	TalonedSwoop
	VileFinLakestalker
	VileFinOracle
	VileFinShorecreeper
	VileFinTidecaller
	YoungReefCrawler
	MasterScript
} {
	namespace eval ::$missing_ai { proc CanCast { npc victim } { ::AI::CanCast $npc $victim } }
}
unset missing_ai


#
# "ai_" prefixed aiscripts
#
foreach ns [ namespace children :: ] {
	if { [ info procs ${ns}::CanCast ] != "" } {
		set ns [ string trim $ns : ]
		if { [ string range $ns 0 2 ] == "ai_" } { continue }
		eval "namespace eval ::ai_${ns} { proc CanCast { npc victim } { ::${ns}::CanCast \$npc \$victim } }"
	}
}
unset ns



