# StartTCL: n
######################
# UnlearnNPC by Rama #
######################
#

namespace eval ::Profch {}
namespace eval ::Profi2 {}
namespace eval ::Profi3 {}

proc ::Profch::GossipHello { npc player } { 

 set option0 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get blacksmithing]]\""
 set option1 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get alchemy]]\""
 set option2 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get enchanting]]\""
 set option3 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get herbalism]]\""
 set option4 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get leatherworking]]\""
 set option5 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get mining]]\""
 set option6 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get skinning]]\""
 set option7 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get tailoring]]\""
 set option8 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get engineering]]\""
 set option9 "text 0 \"[::Texts::Get exit_option]\""
 ::SendGossip $player $npc $option0 $option1 $option2 $option3 $option4 $option5 $option6 $option7 $option8 $option9
 ::Emote $npc 66
 ::Emote $player 66
}

proc ::Profch::GossipSelect { npc player option } {
 		switch $option {
			 
			 0 {  	set sname [::Texts::Get blacksmithing]
				if { [ ::GetSkill $player 164 ] == 0 } {
				::Say $npc 0 [::Texts::Get no_knowskill $sname] 
				::SendGossipComplete $player
				return
				} elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				::SendGossipComplete $player
				return
				} else {
				::LearnSpell $player 1386
				ClearQFlag $player blacksm
				ClearQFlag $player ProfAp164
				ClearQFlag $player ProfJo164
				ClearQFlag $player ProfEx164
				ClearQFlag $player ProfAr164
				if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				} else { ClearQFlag $player prof2}
				::Say $npc 0 [::Texts::Get unlearned $sname]
				::SendGossipComplete $player
				return
				}
			 }
			 
			 1 {
				 set sname [::Texts::Get alchemy]
				 if { [ ::GetSkill $player 171 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 1485 			
				 ClearQFlag $player alchemy
				 ClearQFlag $player ProfAp171
				 ClearQFlag $player ProfJo171
				 ClearQFlag $player ProfEx171
				 ClearQFlag $player ProfAr171
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
			 }
			 
			 2 {
				 set sname [::Texts::Get enchanting]
				 if { [ ::GetSkill $player 333 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 LearnSpell $player 1574 			
				 ClearQFlag $player enchant
				 ClearQFlag $player ProfAp333
				 ClearQFlag $player ProfJo333
				 ClearQFlag $player ProfEx333
				 ClearQFlag $player ProfAr333
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 3 {
 				set sname [::Texts::Get herbalism]
 				if { [ ::GetSkill $player 182 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 1575 			
				 ClearQFlag $player herbalism
				 ClearQFlag $player ProfAp182
				 ClearQFlag $player ProfJo182
				 ClearQFlag $player ProfEx182
				 ClearQFlag $player ProfAr182
   				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			4 {
				 set sname [::Texts::Get leatherworking]
				 if { [ ::GetSkill $player 165 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 1609 			
				 ClearQFlag $player leather
				 ClearQFlag $player ProfAp165
				 ClearQFlag $player ProfJo165
				 ClearQFlag $player ProfEx165
				 ClearQFlag $player ProfAr165
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 5 {
				 set sname [::Texts::Get mining]
				 if { [ ::GetSkill $player 186 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 1645 			
				 ClearQFlag $player mining
				 ClearQFlag $player ProfAp186
				 ClearQFlag $player ProfJo186
				 ClearQFlag $player ProfEx186
				 ClearQFlag $player ProfAr186
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 6 {
				 set sname [::Texts::Get skinning]
				 if { [ ::GetSkill $player 393 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 1648 			
				 ClearQFlag $player skinning
				 ClearQFlag $player ProfAp393
				 ClearQFlag $player ProfJo393
				 ClearQFlag $player ProfEx393
				 ClearQFlag $player ProfAr393
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 7 {
				 set sname [::Texts::Get tailoring]
				 if { [ ::GetSkill $player 197 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 2587 			
				 ClearQFlag $player tailor
				 ClearQFlag $player ProfAp197
				 ClearQFlag $player ProfJo197
				 ClearQFlag $player ProfEx197
				 ClearQFlag $player ProfAr197
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 8 {
				 set sname [::Texts::Get engineering]
				 if { [ ::GetSkill $player 202 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -7500 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 2861 			
				 ClearQFlag $player engineer
				 ClearQFlag $player ProfAp202
				 ClearQFlag $player ProfJo202
				 ClearQFlag $player ProfEx202
 				 ClearQFlag $player ProfAr202
				 if {[GetQFlag $player prof1] == 1} { ClearQFlag $player prof1 
				 } else { ClearQFlag $player prof2} 
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 9 { ::SendGossipComplete $player }
 }
}



proc ::Profi2::GossipHello { npc player } {
 set option0 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get first_aid]]\""
 set option1 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get cooking]]\""
 set option2 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get fishing]]\""
 set option3 "text 0 \"[::Texts::Get exit_option]\""
 ::SendGossip $player $npc $option0 $option1 $option2 $option3
 ::Emote $npc 66
 ::Emote $player 66
}

proc ::Profi2::GossipSelect { npc player option } {
 switch $option {
			 0 {
				 set sname [::Texts::Get first_aid]
				 if { [ ::GetSkill $player 129 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 2866
				 ClearQFlag $player firstaid
				 ClearQFlag $player ProfAp129
				 ClearQFlag $player ProfJo129
				 ClearQFlag $player ProfEx129
 				 ClearQFlag $player ProfAr129
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 1 {
				 set sname [::Texts::Get cooking]
				 if { [ ::GetSkill $player 185 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 3629
				 ClearQFlag $player cooking
				 ClearQFlag $player ProfAp185
				 ClearQFlag $player ProfJo185
				 ClearQFlag $player ProfEx185
 				 ClearQFlag $player ProfAr185
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 2 {
				 set sname [::Texts::Get fishing]
				 if { [ ::GetSkill $player 356 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 5375
				 ClearQFlag $player Fishing
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 3 { ::SendGossipComplete $player }
				}
				}





proc ::Profi3::GossipHello { npc player } {
 set option0 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get horse_ride]]\""
 set option1 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get wolf_ride]]\""
 set option2 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get tiger_ride]]\""
 set option3 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get ram_ride]]\""
 set option4 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get raptor_ride]]\""
 set option5 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get undead_horse_ride]]\""
 set option6 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get kodo_ride]]\""
 set option7 "text 2 \"[::Texts::Get need_unlearn [::Texts::Get mechanostrider_ride]]\""
 set option8 "text 0 \"[::Texts::Get exit_option]\""
 ::SendGossip $player $npc $option0 $option1 $option2 $option3 $option4 $option5 $option6 $option7 $option8
 ::Emote $npc 66
 ::Emote $player 66
}

proc ::Profi3::GossipSelect { npc player option } {
 switch $option {
			0 {
				 set sname [::Texts::Get horse_ride]
				 if { [ ::GetSkill $player 148 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 5739
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
			 	}
				}
			 1 {
				 set sname [::Texts::Get wolf_ride]
				 if { [ ::GetSkill $player 149 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6061
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
				 2 {
				 set sname [::Texts::Get tiger_ride]
				 if { [ ::GetSkill $player 150 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6152
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 3 {
				 set sname [::Texts::Get ram_ride]
				 if { [ ::GetSkill $player 152 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6154
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 4 {
				 set sname [::Texts::Get raptor_ride]
				 if { [ ::GetSkill $player 533 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6159
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 5 {
				 set sname [::Texts::Get undead_horse_ride]
				 if { [ ::GetSkill $player 554 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6160
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 6 {
				 set sname [::Texts::Get kodo_ride]
				 if { [ ::GetSkill $player 713 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6161
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 7 {
				 set sname [::Texts::Get mechanostrider_ride]
				 if { [ ::GetSkill $player 553 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_knowskill $sname]
				 ::SendGossipComplete $player
				 return
				 } elseif { [ ::ChangeMoney $player -5000 ] == 0 } {
				 ::Say $npc 0 [::Texts::Get no_enoughmoney $sname]
				 ::SendGossipComplete $player
				 return
				 } else {
				 ::LearnSpell $player 6162
				 ::Say $npc 0 [::Texts::Get unlearned $sname]
				 ::SendGossipComplete $player
				 return
				 }
				 }
			 8 { ::SendGossipComplete $player }
 				}
				}


