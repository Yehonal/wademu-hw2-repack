# start-tcl: n
#

# 500_Relocator.tcl
#
## TELEPORT MASTER TEMPLATE
# [creature 40001]
# name=Tele Tubby
# questscript=Relocator
# guild=Teleport Masters
# npcflags=11
# attack=1560 1716
# bounding_radius=0.306
# combat_reach=2.31
# damage=59 85
# equipmodel=0 1600 2 10 2 17 2 0 0 0
# loottemplate=11040
# faction=35
# level=45
# maxhealth=2766
# maxmana=1124
# model=7036
# speed=1.17
# type=7
# civilian=1
# money=5640

namespace eval ::Relocator {
	
	proc ::Relocator::GossipHello { npc player } {
		set ::Relocator::side [ ::Relocator::GetSide $player]
		if { $::Relocator::side == "Alliance" } {
			set Telepos0 { text 3 "Stormwind - Alliance 60 silver" }
			set Telepos2 { text 3 "Ironforge - Alliance 60 silver" }
			set Telepos1 { text 3 "Darnassus - Alliance 60 silver" }
			set Telepos3 { text 3 "Theramore - Alliance 60 silver" }
		} else {
			set Telepos0 { text 3 "Orgimmar - Horde 60 silver" }
			set Telepos1 { text 3 "Thunder Bluff - Horde 60 silver" }
			set Telepos2 { text 3 "Undercity - Horde 60 silver" }
			set Telepos3 { text 3 "Grom`Gol - Horde 60 silver"  }
		}
	set Telepos4 { text 3 "Booty Bay - Neutral" }
	set Telepos5 { text 3 "Ratchet - Neutral" }
	set Telepos6 { text 3 "Gadgetzan - Neutral" }

#	Note you can create maximum 11 rows!
#	SendGossip $player $npc \ $Telepos0 $Telepos1 $Telepos2 $Telepos3 $Telepos4 $Telepos5 $Telepos6
	SendGossip $player $npc \ $Telepos0 $Telepos1 $Telepos2
	}

	proc ::Relocator::GossipSelect { npc player option } {
		if {[ChangeMoney $player -6000] == 0} { 
			Say $npc 0 "Tu non hai 60 argenti per il teleporto" 
			SendGossipComplete $player 
 		return 
		}
		set ::Relocator::side [ ::Relocator::GetSide $player]
		switch $option {
			0 { if { $::Relocator::side == "Alliance" } { Teleport $player 0 -8913.23 554.633 93.7944 } else { Teleport $player 1 1484.36 -4417.03 24.4709 }}
			1 { if { $::Relocator::side == "Alliance" } { Teleport $player 1 9948.55 2413.59 1327.23 } else { Teleport $player 1 -1283.525084 134.305954 131.097031 }}
			2 { if { $::Relocator::side == "Alliance" } { Teleport $player 0 -4981.25 -881.542 501.66 } else { Teleport $player 0 1832.44 236.426 60.4171 }}
			3 { if { $::Relocator::side == "Alliance" } { Teleport $player 1 -3677.171631 -4387.562988 10.452909 } else { Teleport $player 0 -12352.8 211.452 4.5846 }}
			4 { Teleport $player 0 -14468.706055 457.485626 15.997005 }
			5 { Teleport $player 1 -989.908813 -3691.291992 9.089474 }
			6 { Teleport $player 1 -7120.975586 -3768.822021 9.160513 }
		}
	}

	proc ::Relocator::QuestStatus { npc player } {
	set reply 2
	return $reply
	}
	
	proc ::Relocator::GetSide { player } {
		set ::Relocator::race [::GetRace $player]
		switch $::Relocator::race {
			1 - 3 - 4 - 7 {return "Alliance"}
			default {return "Horde"}
		}
	}
	set loadinfo "Re-locator script loaded"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
}
