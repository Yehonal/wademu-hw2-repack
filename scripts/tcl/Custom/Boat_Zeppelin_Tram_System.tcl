
#ZEPPELIN PER UNDERCITY

namespace eval z_undercity {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { return [Say $player 0 "It's for the horde faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in Undecity" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 0 1832.44 236.426 60.4171
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#ZEPPELIN PER ORGRIMMAR

namespace eval z_orgrimmar {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { return [Say $player 0 "It's for the horde faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in Orgrimmar" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 1 1484.36 -4417.03 24.4709
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#ZEPPELIN PER GROM'GOL

namespace eval z_gromgol {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side == 0 } { return [Say $player 0 "It's for the horde faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in Grom'Gol" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 25 } {
Say $npc 0 "you must at least be to level 25 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 0 -12352.8 211.452 4.5846
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER BOOTY BAY

namespace eval n_bootybay {
proc GossipHello { npc player } {
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in Booty Bay." }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 25 } {
Say $npc 0 "you must at least be to level 25 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player .0 -14406.6 419.353 22.3907
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER RATCHET

namespace eval n_ratchet {
proc GossipHello { npc player } {
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in Ratchet ." }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 15 } {
Say $npc 0 "you must at least be to level 15 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 1 -943.935 -3715.49 11.8385
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER DARNASSUS

namespace eval n_darnassus {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Darnassus " }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 1 9948.55 2413.59 1327.23
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER AUBERDINE

namespace eval n_auberdine {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Auberdine " }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 10 } {
Say $npc 0 "you must at least be to level 10 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 1 6432.199219 484.581848 7.106398
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER THERAMORE ISLE

namespace eval n_theramore {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Theramore " }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 25 } {
Say $npc 0 "you must at least be to level 25 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 1 -3729.36 -4421.41 30.4474
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#NAVE PER MENETHIL HARBOR

namespace eval n_menethil {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Menethil " }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 15 } {
Say $npc 0 "you must at least be to level 15 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 0 -3740.29 -755.08 10.9643
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#METROPOLITANA PER STORMWIND

namespace eval m_stormwind {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Stormwind" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 0 -8913.23 554.633 93.7944
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

#METROPOLITANA PER IRONFORGE

namespace eval m_ironforge {
proc GossipHello { npc player } {
set side [::Custom::GetPlayerSide $player]
if { $side != 0 } { return [Say $player 0 "It's for the alliance faction!"] }
SendGossip $player $npc { text 4 "For 60 silver I can carry to you in  Ironforge" }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -6000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
Teleport $player 0 -4920.611816 -955.967468 501.509644 
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}


#GUILD TELEPORTER

namespace eval GuildTeleport {
proc GossipHello { npc player } {
SendGossip $player $npc { text 4 "For 10 silver I can carry to you in the center of yours gild." }
}

proc GossipSelect { npc player option } {
set plevel [GetLevel $player]
set guild [Custom::GetGuildName $player]
if { $guild == "" } {
Say $npc 0 "You do not belong to same guild."
}
if {$plevel < 5 } {
Say $npc 0 "you must at least be to level 5 if you want to have use of of this service."
} else {
SendGossipComplete $player
set money -1000
set playertarget [GetSelection $player]

if { [ChangeMoney $player $money] == 1 } {
if { $guild == "Dark Legion" } {
Teleport $player 1 -456.263 -2652.7 95.615
}
if { $guild == "Guardians of the Old Lion" } {
Teleport $player 0 -8913.23 554.633 93.7944
}
if { $guild == "The Boss" } {
Teleport $player 1 16222.1 16252.1 12.5872
}
} else {
Say $npc 0 "You do not have enough money. Try another time."
Emote $npc 77
}
SendSwitchGossip $player $npc 1
}
proc QuestStatus { npc player } {
return 1
}
}
}

