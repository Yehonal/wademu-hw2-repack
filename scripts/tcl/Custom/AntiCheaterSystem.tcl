#
# StartTCL: n
#
#
#



namespace eval Vilereef {
	proc AreaTrigger { player trigger_number } {
			SendQuestComplete $player 578
	}
}


#
#
# Race System v0.1 by Snake
#

package require sqlite3
sqlite3 snk "saves/snk.db3"

namespace eval SnkRace {
	
	variable Enabled 1
	variable Money_Rate 2
		
	variable VERSION 0.1
	variable start 0

	proc GmMenu { player cargs } {
		if { [GetPlevel $player] < 2 } { return "You are not allowed to use this command" }
		set event [lindex $cargs 0]
		set mode [lindex $cargs 1]
		set cargs [lindex $cargs 2 end]
		switch $event {
			"sql" { return [SQL $player $mode $cargs] }
		}
	}
	
	proc GossipHello { npc player } {
		set entry [GetEntry $npc]
		switch $entry {
			4507 {
						if { [RaceIsOn] } { Say $npc 0 "A race has started, please wait until finish"; SendGossipComplete $player $npc } else {
						if { [BetOnThisRace $player] } { Say $npc 0 "You have already bet on this race"; SendGossipComplete $player $npc } else {
						if { [AlreadyBet $player] } { Say $npc 0 "You have an old bet, please claim your reward and then bet again";  SendGossipComplete $player $npc } else {
						SendGossip $player $npc { text 0 "100 Gold" }\
						SendGossip $player $npc { text 0 "10 Gold" }\
						SendGossip $player $npc { text 0 "1 Gold" }\
						SendGossip $player $npc { text 0 "10 Silver" }\
						SendGossip $player $npc { text 0 "1 Silver" }\
						SendGossip $player $npc { text 0 "10 Copper" }\
						SendGossip $player $npc { text 0 "1 Copper" }\
						}}}
					}
			4419 {
						if { [RaceIsOn] } { Say $npc 0 "A race has started, please wait until finish" } else {
						if { [BetOnThisRace $player] } { Say $npc 0 "Race has not started yet"; SendGossipComplete $player $npc } else {
						if { [AlreadyBet $player] != 1 } { Say $npc 0 "You haven't bet on any race" } else {
						SendGossip $player $npc { text 0 "Check my bet" }
						}}}
					}
				}
			}
	
	proc GossipSelect { npc player option } {
		set entry [GetEntry $npc]
		switch $entry {
			4507 {
						set money [GetMoney $option]
						if { ![ChangeMoney $player -$money] } { Say $npc 0 "You don't have enough money"; SendGossipComplete $player $npc } else {
						CreateBet $player $money
						SendGossipComplete $player $npc
						Say $npc 0 "Thanks for beting"
						}
					}
			4419 {
						set name [GetName $player]
						set rn [snk eval { SELECT `racenumber` FROM `bets` WHERE (`madeby` = $name) }]
						if { [GetSide $player] != [GetWinner $rn] } { Say $npc 0 "You have lost, sorry"; DeleteBet $player; SendGossipComplete $player $npc } else {
						snk eval { SELECT * FROM `bets` WHERE (`madeby` = $name) } {
							set money [expr $money * $SnkRace::Money_Rate]
							ChangeMoney $player +$money
							Say $npc 0 "Congratulations, you have won"
						}
							DeleteBet $player
							SendGossipComplete $player $npc 
						}
					}
				}
			}
	
	proc CreateBet { player money } {
		set name [GetName $player]
		snk eval { SELECT `rn` FROM `races` ORDER BY `entry` DESC LIMIT 1 } {
			set rn [expr $rn + 1]
			snk eval { INSERT INTO `bets` (`racenumber`, `money`, `madeby`) VALUES($rn, $money, $name) }
		}
		puts "[Custom::LogPrefix] $name bets on Races $money coppers"
	}
	
	proc DeleteBet { player } {	set name [GetName $player];	snk eval { DELETE FROM `bets` WHERE (`madeby` = $name) } }
	proc GetWinner { rn } { snk eval { SELECT `winner` FROM `races` WHERE (`rn` = $rn) } { return $winner } }
	proc StartRace { npc } { snk eval { SELECT `rn` FROM `races` ORDER BY `entry` DESC LIMIT 1 } { set rn [expr $rn + 1] }; snk eval { INSERT INTO `races` (`rn`, `finish`) VALUES($rn, "no") };	variable start; set start 1 }
	proc FinishRace { npc } { set finish [snk eval { SELECT `finish` FROM `races` ORDER BY `entry` DESC LIMIT 1 }]; if { $finish == "yes" } { return } else { set entry [GetEntry $npc]; set side [GetNpcSide $entry]; set rn [snk eval { SELECT `rn` FROM `races` ORDER BY `entry` DESC LIMIT 1 }]; snk eval { UPDATE `races` SET `finish` = "yes", `winner` = $side WHERE (`rn` = $rn ) }; variable start; set start 0 } }
	proc RaceIsOn {} { variable start; return $start }
	proc BetOnThisRace { player } {	set name [GetName $player];	snk eval { SELECT `rn` FROM `races` ORDER BY `entry` DESC LIMIT 1 } { set rn [expr $rn + 1]; if { [ string length [ snk eval { SELECT `madeby` FROM `bets` WHERE (`racenumber` = $rn AND `madeby` = $name) } ] ] } { return 1 } }; return 0 }
	proc AlreadyBet { player } { set name [GetName $player]; if { [ string length [ snk eval { SELECT `madeby` FROM `bets` WHERE (`madeby` = $name) } ] ] } { return 1 }; return 0 }	
	
	proc SQL { player mode cargs } {
		switch $mode {
			"reset" { DeleteTables; CreateTables; return "Race Tables reseted" }
			"cleanup" { [CleanupTables]; return "Race db cleaned" }
			default { return "Modes are reset/cleanup" }
		}
	}
	
	proc CreateTables {} {
		if { [ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'races') } ] ] } { return	}
		snk eval { CREATE TABLE `races` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `winner` TEXT NOT NULL DEFAULT '', `rn` TEXT NOT NULL DEFAULT 0, `finish` TEXT NOT NULL DEFAULT 'no') }
		snk eval { CREATE TABLE `bets` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `racenumber` TEXT NOT NULL DEFAULT 0, `money` TEXT NOT NULL DEFAULT 0, `madeby` TEXT NOT NULL DEFAULT '') }
		snk eval { INSERT INTO `races` (`winner`, `rn`, `finish`) VALUES("bla", 0, "no") }
	}
	
	proc DeleteTables {} {
		if { ![ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'races') } ] ] } { return }
		snk eval { DROP TABLE `races` }
		snk eval { DROP TABLE `bets` }
		snk eval { VACUUM }
	}
	
	proc CleanupTables {} {
		snk eval { VACUUM }
	}
	
	proc GetMoney { option } {
		switch $option {
			0 { return 1000000 }
			1 { return 100000 }
			2 { return 10000 }
			3 { return 1000 }
			4 { return 100 }
			5 { return 10 }
			6 { return 1 }
		}
	}
	
	proc GetNpcSide { entry } {
		switch $entry {
			4251 { return "Horde" }
			4252 { return "Alliance" }
		}
	}
	
	proc GetSide { player } {
		set race [GetRace $player]
		switch $race {
			1 { return "Alliance" }
			3 { return "Alliance" }
			4 { return "Alliance" }
			7 { return "Alliance" }
			2 { return "Horde" }
			5 { return "Horde" }
			6 { return "Horde" }
			8 { return "Horde" }
		}
	}
	
	SnkRace::CreateTables
	Custom::AddCommand "race" "SnkRace::GmMenu"
	
	puts "[Custom::LogPrefix] Snk Race System v$VERSION Loaded"	
}

namespace eval HonorHall {
	proc AreaTrigger { player id } {
		set plevel [GetPlevel $player]
		if {$plevel == 0} {
			SendGossipComplete $player
			set pname [GetName $player]
			if {[file exists "./honor/$pname"] != 1} {
				Say $player 0 "I am not whorty enough .. i need to fight some enemies"
				return 
			}
			set player_file [open "./honor/$pname" r]
			set HonorPoints [gets $player_file]
			set Race [gets $player_file]
			set Class [gets $player_file]
			set Level [gets $player_file]
			set Guild [gets $player_file]
			set HonorableKills [gets $player_file]
			set DishonorableKills [gets $player_file]
			set Defeats [gets $player_file]
			close $player_file
		}
		switch $id {
			2527 {
				if {$plevel == 0} {
					if {$Race == "1" || $Race == "3" || $Race == "4" || $Race == "7"} {
						Say $player 0 "I can´t enter here. This is the PVP-Honor hall for the horde"
						return 0
					}
					if {$HonorPoints <= 100} {
						Say $player 0 "I don't have enough honor to get in..."
						return 0
					}
					if {$DishonorableKills >= 100} {
						Say $player 0 "I have too many dishonorable kills..."
						return 0
					}
				}
				Teleport $player 450 221.535934 74.621155 25.720871
			}
			2532 {
				if {$plevel == 0} {
					if {$Race == "2" || $Race == "5" || $Race == "6" || $Race == "8"} {
						Say $player 0 "I can´t enter here. This is the PVP-Honor hall for the alliance!"
						return 0
					}
					if {$HonorPoints <= 100} {
						Say $player 0 "I don't have enough honor to get in..."
						return 0
					}
					if {$DishonorableKills >= 100} {
						Say $player 0 "I have too many dishonorable kills..."
						return 0
					}
				}
				Teleport $player 449 -0.493064 2.411076 -0.255885
			}
		}
	}
}
#
# used namespaces
#
namespace eval ::FrostmaneHold { }
namespace eval ::FrostmaneHold1 { }
namespace eval ::FrostmaneHold2 { }
namespace eval ::FrostmaneHold3 { }


#
# script for namespace ::FrostmaneHold
#
proc ::FrostmaneHold::QuestCheck {} {
	if {([GetQFlag $player t97] == 1) && ([GetQFlag $player t168] == 1) && ([GetQFlag $player t169] == 1) && ([GetQFlag $player oneTimePass] == 0)} {
		SendQuestComplete $player 287
		ClearQFlag $player t97
		ClearQFlag $player t168
		ClearQFlag $player t169
		SetQFlag $player oneTimePass
	}
}


#
# script for namespace ::FrostmaneHold1
#
proc ::FrostmaneHold1::AreaTrigger { player trigger_number } {
	SetQFlag $player t97
	::FrostmaneHold::QuestCheck
}


#
# script for namespace ::FrostmaneHold2
#
proc ::FrostmaneHold2::AreaTrigger { player trigger_number } {
	SetQFlag $player t168
	::FrostmaneHold::QuestCheck
}


#
# script for namespace ::FrostmaneHold3
#
proc ::FrostmaneHold3::AreaTrigger { player trigger_number } {
	SetQFlag $player t169
	::FrostmaneHold::QuestCheck
}


namespace eval BWLentrance { 

proc QueryQuest { obj player questid } {

set plevel [::GetLevel $player]
if { $plevel > 59 } { 
if {[GetQFlag $player "Q7761"]} {
Teleport $player 469 -7674.47 -1108.38 396.65 0.61
} else { Say $player 0 [::Texts::Get "|cff800080I do not bear the Mark of Drakkisath yet!"] } 
} else { Say $player 0 [::Texts::Get "|cff800080I must be level 60 to enter."] }
}
}

namespace eval OnyxiaLairEnter { 

proc AreaTrigger { player id } { 

set plevel [::GetLevel $player]
if { $plevel > 59 } { 
if {([GetQFlag $player "Q6602"] || [GetQFlag $player "Q6502"] )} {
Teleport $player 249 30.464 -61.5 -5.219 4.747
} else { Say $player 0 [::Texts::Get "|cff800080I haven't created a Drakefire Amulet yet! The Black Dragonkin's magic won't allow me to pass!"] } 
} else { Say $player 0 [::Texts::Get "|cff800080I must be level 60 to enter."] }
}
}

namespace eval Mazthoril { 

proc AreaTrigger { player id } { 

Teleport $player 1 6084.36 -4122.96 895.145

}
}


::Custom::AddSpellScript "::Emberstrife::Deceive" 19937	

	namespace eval Emberstrife {
	proc Deceive { to from spellid } {
		
		if { [::GetQFlag $from CastedC] } { return [ ClearQFlag $from CastedC ] }
		SetQFlag $from Disguised
		SetQFlag $from CastedC	
	}
	}

::Custom::AddSpellScript "::Marcus::Event" 51033	

	namespace eval Marcus {
	proc Event { to from spellid } {

		set Target [::GetEntry $to]
		set Caster [::GetEntry $from]
		if {($Target == "12739") && (![::GetQFlag $to Aggroed]) } {  if {[::CastSpell $from $to 58]} { SetQFlag $to Aggroed } else { ::CastSpell $from $from 51033} }	
		if {(($Target == 68) || ($Target == 1756)) && ($Caster == 12756)} {  ::CastSpell $to $to 51036 }
		if {(($Target == 68) || ($Target == 1756)) && ([::GetQFlag $from Line13F]) } {  Say $to 0 [::Texts::Get "Hail to Reginald Windsor!"]; ::Emote $to 16;}
		if {$Target == "466"} { 

        if { [::GetQFlag $from Line13F] } { Say $from 0 [::Texts::Get "Follow me, friends. To Stormwind Keep!"]; ::Emote $from 4;
	ClearQFlag $from Line1F
	ClearQFlag $from Line2F
	ClearQFlag $from Line3F
	ClearQFlag $from Line4F
	ClearQFlag $from Line5F
	ClearQFlag $from Line6F
	ClearQFlag $from Line7F
	ClearQFlag $from Line8F
	ClearQFlag $from Line9F
	ClearQFlag $from Line10F
	ClearQFlag $from Line11F
	ClearQFlag $from Line12F
        ClearQFlag $from Line13F; return }
	if { [::GetQFlag $from Line12F] } { Say $from 0 [::Texts::Get "Thank you, old friend. You have done the right thing."]; SetQFlag $from Line13F; return }
	if { [::GetQFlag $from Line11F] } { Say $to 0 [::Texts::Get "Go, Reginald. May the light guide your hand."]; SetQFlag $from Line12F; return }		
	if { [::GetQFlag $from Line10F] } { Say $to 0 [::Texts::Get "|cffff0000Reginald Windsor is not to be harmed! He shall pass through untouched!"]; SetQFlag $from Line11F; return }	
	if { [::GetQFlag $from Line9F] } { Say $to 0 [::Texts::Get "Move aside! Let them pass!"]; SetQFlag $from Line10F; return }	
	if { [::GetQFlag $from Line8F] } { Say $to 0 [::Texts::Get "Stand down! Can you not see that heroes walk among us?"]; SetQFlag $from Line9F; return }
	if { [::GetQFlag $from Line7F] } { Say $from 0 [::Texts::Get "Now, it is time to bring her reign to an end, Marcus. Stand down, friend."]; SetQFlag $from Line8F; return }
	if { [::GetQFlag $from Line6F] } { Say $from 0 [::Texts::Get "Dear friend, you honor them with your vigilant watch. You are steadfast in your allegiance. I do not doubt for a moment that you would not give as great a sacrifice for your people as any of the heroes you stand under."]; SetQFlag $from Line7F; return }
	if { [::GetQFlag $from Line5F] } { Say $to 0 [::Texts::Get "We shame our ancestors. We shame those lost to us... forgive me, Reginald."]; SetQFlag $from Line6F; return }
        if { [::GetQFlag $from Line4F] } { Say $to 0 [::Texts::Get "I am ashamed, old friend. I know not what I do anymore. It is not you that would dare bring shame to the heroes of legend -- it is I. It is I and the rest of these corrupt politicians. They fill our lives with empty promises, unending lies."]; SetQFlag $from Line5F; return }
	if { [::GetQFlag $from Line3F] } { Say $to 0 [::Texts::Get "|cffffff00<General Marcus Jonathan appears lost in contemplation.>"]; SetQFlag $from Line4F; return }
	if { [::GetQFlag $from Line2F] } { Say $from 0 [::Texts::Get "Holding me here is not the right decision, Marcus."]; SetQFlag $from Line3F; return }
        if { [::GetQFlag $from Line1F] } { Say $from 0 [::Texts::Get "You must do what you think is right, Marcus. We served together under Turalyon. He made us both the men that we are today. Did he err with me? Do you truly believe my intent is to cause harm to our alliance? Would I shame our heroes?"]; SetQFlag $from Line2F;
        } else { Say $to 0 [::Texts::Get "Reginald, you know that I can't let you pass."];  SetQFlag $from Line1F }
	}      
	}
	}

::Custom::AddSpellScript "::Prestor::Event" 51034
::Custom::AddSpellScript "::Prestor::OnyxiaDespawn" 51031
::Custom::AddSpellScript "::Prestor::Despawn" 51035
::Custom::AddSpellScript "::Prestor::Despawn" 51036

	variable aggrocount 0

	namespace eval Prestor {
	proc Event { to from spellid } {

	global aggrocount
	set Target [::GetEntry $to]
		
	if {$Target == "1747"} { 
	if { [::GetQFlag $to CastedA] } { return [ ClearQFlag $to CastedA ] }
	::CastSpell $to $to 51002
	::CastSpell $to $to 51038
	SetQFlag $to CastedA }
	
	if {$Target == "1748"} {if { [::GetQFlag $from Finished] } { if {$aggrocount > 8} {ClearQFlag $from Finished; set aggrocount 0; Say $to 0 [::Texts::Get "Attack the intruders!"]} else { incr aggrocount; ::CastSpell $to $to 51033 }}}
		
	if {$Target == "12756"} { 

	if { [::GetQFlag $to Transformed] } { SetQFlag $from Finished; ClearQFlag $to Transformed; ::CastSpell $to $to 51031; 
	} else { Say $to 0 [::Texts::Get "Curious... Windsor, in this vision, did you survive? I only ask because one thing that I can and will assure is your death. Here and now."]; ::CastSpell $to $to 51033; SetQFlag $to Transformed }}

	if {$Target == "1749"} { 

	if { [::GetQFlag $from Line7Fb] } { Say $from 0 [::Texts::Get "|cffffff00Reginald Windsor reads from the tablets. Unknown, unheard sounds flow through your consciousness."];
	ClearQFlag $from Line1Fb
	ClearQFlag $from Line2Fb
	ClearQFlag $from Line3Fb
	ClearQFlag $from Line4Fb
	ClearQFlag $from Line5Fb
	ClearQFlag $from Line6Fb
	ClearQFlag $from Line7Fb
	::CastSpell $to $to 51035
	return }	

	if { [::GetQFlag $from Line6Fb] } { Say $from 0 [::Texts::Get "Listen, dragon. Let the truth resonate throughout these halls."]; SetQFlag $from Line7Fb; return }
	if { [::GetQFlag $from Line5Fb] } { Say $from 0 [::Texts::Get "The Dark Iron's thought these tablets to be encoded. This is not any form of coding, it is the tongue of an ancient dragon."]; SetQFlag $from Line6Fb; return }
        if { [::GetQFlag $from Line4Fb] } { Say $from 0 [::Texts::Get "You will not escape your fate, Onyxia. It has been prophesied -- a vision resonating from the great halls of Kharazan. It ends now..."]; SetQFlag $from Line5Fb; return }
	if { [::GetQFlag $from Line3Fb] } { Say $from 0 [::Texts::Get "|cffffff00Reginald Windsor reaches into his pack and pulls out the encoded tablets."]; SetQFlag $from Line4Fb; return }
	if { [::GetQFlag $from Line2Fb] } { Say $to 0 [::Texts::Get "And as your limp body dangles from the rafters, I shall take pleasure in knowing that a mad man has been put to death. After all, what proof do you have? Did you expect to come in here and point your fingers at royalty and leave unscathed?"]; SetQFlag $from Line3Fb; return }
        if { [::GetQFlag $from Line1Fb] } { Say $to 0 [::Texts::Get "You will be incarcerated and tried for treason, Windsor. I shall watch with glee as they hand down a guilty verdict and sentence you to death by hanging..."]
        SetQFlag $from Line2Fb
        } else { Say $to 0 [::Texts::Get "|cffffff00Lady Katrana Prestor laughs."]; ::Emote $to 11; SetQFlag $from Line1Fb }

        	}
	}
		proc OnyxiaDespawn {to from spellid} { set Caster [::GetEntry $from];  if {$Caster == "12756"} { ::CastSpell $from $from 51002; ::CastSpell $from $from 51038 } }
		proc Despawn { to from spellid } { ::CastSpell $from $from 51002; ::CastSpell $from $from 51038 }

	}




namespace eval DeadFields {
	proc AreaTrigger { player trigger_number } {
		if {([GetQuestStatus $player 437] == 3) && ([GetQFlag $player "Q437"] == 0)} {
			SendQuestComplete $player 437
		}
	}
}

namespace eval ghostfree {}	
	proc ghostfree::AreaTrigger { player trigger_number } {
			set location [GetPos $player] 		
			set pname [GetName $player]  		
			set level [GetLevel $player]   		
			set trigger $trigger_number	
			switch $trigger {	
					45 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else { 
						SetQFlag $player "enter"
						#SetBindpoint $player 0 2659 -680 113
						Teleport $player 189 1688.57 1052.42 18.68 1.14 }
						}		
					78 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -11081 1526 44
						Teleport $player 36 -16.40 -383.07 61.78 1.86
						}
						}		
					101 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else { 
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -8781.92 833.39 95.50 3.81
						Teleport $player 34 54.23 0.28 -18.34 6.26 }
						}		
					107 {              	
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -8653.45 606.19 91.16 5.37
						Teleport $player 35 -0.91 40.57 -24.23 1.59 }
						}        		
					145 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -234.56 1563.56 76.89 4.36
						Teleport $player 33 -228.19 2110.56 76.89 1.22 }
						}		
					228 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -740.98 -2214.08 15.98 6.16
						Teleport $player 43 -163.49 132.95 -73.66 5.83 }
						}	
					244 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4467.28 -1671.75 81.85 4.42
						Teleport $player 47 1943.00 1544.63 82.00 1.38 }
						}		
					257 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 4113 888 10
						Teleport $player 48 -151.89 106.96 -39.87 4.53 }
						}		
							
					286 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -6092 -3186 256
						Teleport $player 70 -226.80 49.09 -46.03 1.39 }
						}		
						
					324 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -5181 626 401
						Teleport $player 90 -332.22 -2.28 -150.86 2.77 }
						}	
					442 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4376 -1952 90
						Teleport $player 129 2592.55 1107.50 51.29 4.74 }
						}		
							
					446 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -10477 -3816 29
						Teleport $player 109 -319.24 99.90 -131.85 3.19 }
						}		
							
					523 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -5181 626 401
						Teleport $player 90 -736.51 2.71 -249.99 3.14 }
						}		
							
					610 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 2659 -680 113
						Teleport $player 189 855.11 1320.76 18.67 0.30 }
						}		
							
					612 {	
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 2659 -680 113
						Teleport $player 189 1608.38 -320.50 18.67 5.97 }
						}		
							
					614 {	if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 2659 -680 113 
						Teleport $player 189 254.99 -206.82 18.68 5.76 }
						}		
							
					902 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -6092 -3186 256 
						Teleport $player 70 -211.23 385.09 -38.72 1.31 }
						}		
							
					924 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -6797.89 -2891.04 8.88 3.09 
						Teleport $player 209 1213.52 841.59 8.93 6.09 }
						}		
							
					1466 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -7784 -1128 215 
						Teleport $player 230 458.32 26.52 -70.67 4.95 }
						}		
						  	
					1468 {           	
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -7784 -1128 215 
						Teleport $player 229 78.784691 -228.056717 49.692474 4.765266 }
						}	   	
						       
					2216 {           	
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 3366 -3380 146 
						Teleport $player 329 3393.550781 -3390.980713 143.164185 1.554557 }
						}	   	
						       
					2217 {  if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 3366 -3380 146 
						Teleport $player 329 3392.955078 -3366.750488 142.843719 4.692227 }
						}	   	
						
					2214 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 3174 -4039 106
						Teleport $player 329 3593.15 -3646.56 138.50 5.33 }
						}		
							
					2230 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 1814.09 -4416.09 -18.47 1.92
						Teleport $player 389 3.81 -14.82 -17.84 4.39 }
						}		
	
					2567 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 1241 -2591 91 
						Teleport $player 289 196.37 127.05 134.91 6.09 }
						}		
							
					2848 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 -4673 -3706 47
						Teleport $player 249 30.68 -60.80 -5.27 4.58 }
					        }		
							
					2886 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 0 -7784 -1128 215
						Teleport $player 409 1093.46 -469.41 -105.70 3.99 }
						}		
							
					3133 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 -1418 2856 125
						Teleport $player 349 1019.69 -458.31 -43.43 0.31 }
						}		
							
					3134 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 -1418 2856 125
						Teleport $player 349 752.91 -616.53 -33.11 1.37 }
						}		
					3183 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 47.63 -155.27 -2.71 6.01 }
						}		
							
					3184 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else { 
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 -201.11 -328.66 -2.72 5.22 }
						}		
							
					3185 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else { 
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 16.43 -836.91 -31.19 0.07 }
						}		
							
					3186 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 -64.23 160.13 -3.47 2.99 }
						}		
							
					3187 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 34.35 160.70 -3.47 0.72 }
						}		
							
					3189 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -4302 1329 160
						Teleport $player 429 254.79 -17.09 -2.56 5.25 }
						}		
							
					3650 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 1427.72 -1855.53 133.77 6.17
						Teleport $player 489 1452.31 1623.60 356.23 3.93 }
						}		
	
					3654 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"  
						#SetBindpoint $player 1 1034.74 -2094.14 124.62 4.79
						Teleport $player 489 1012.17 1292.09 344.67 0.53 }
						}		
					4008 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -8060 1644 25
						Teleport $player 509 -8429.743164 1512.136475 31.907366 }
						}
					4010 {  if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 -8060 1644 25
						Teleport $player 531 -8231.33007813 2010.59997559 129.860992432 }
						}
					5242 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter" 
						#SetBindpoint $player 1 4561.84912100 -3932.86547900 942.39263900
						Teleport $player 1 4622.72021500 -3844.44921900 943.82086200 }
						}
					5243 {		
						if {[GetQFlag $player IsDead]} { Say $player 0 "Ghosts are not allowed to enter this dungeon."
    						} else {
						SetQFlag $player "enter"
						#SetBindpoint $player 1 4608.27880900 -3865.14868200 944.18463100
						Teleport $player 1 4556.45263700 -3942.53418000 943.07684300 }
						}		
					}
	}