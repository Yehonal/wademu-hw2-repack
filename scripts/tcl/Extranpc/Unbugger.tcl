namespace eval unbugger { 
proc GossipHello { npc player } { 
set option0 { text 2 "I need to Unbug Two Handed Axes" } 
set option1 { text 2 "I need to Unbug Two-Handed Maces" }
set option2 { text 2 "I need to Unbug Two-Handed Swords" }
set option3 { text 2 "I need to Unbug Polearms" }
set option4 { text 1 "I need to repair my equipment" }
set option5 { text 0 "No Thanks. I got go. Bye" }

SendGossip $player $npc $option0 $option1 $option2 $option3 $option4 $option5
Emote $npc 66 
Emote $player 66 
} 

proc GossipSelect { npc player option } { 
set playertarget [GetSelection $player] 
set plevel [GetLevel $player]
switch $option { 
		0 {
			::LearnSpell $player 15985
			::Say $npc 0 "You unbugged the Two Handed Axes skill";
			::SendGossipComplete $player;
		}
		1 {
			::LearnSpell $player 15987
			::Say $npc 0 "You unbugged the Two-Handed Maces skill";
			::SendGossipComplete $player;
		}
		2 {
			::LearnSpell $player 15983
			::Say $npc 0 "You unbugged the Two-Handed Swords skill";
			::SendGossipComplete $player;
		}
		3 {
			::LearnSpell $player 15991
			::Say $npc 0 "You unbugged the Polearms skill";
			::SendGossipComplete $player;
		}
		4 {
			::VendorList $player $npc
		}
		5 {
			set msg "Good bye."
			::SendGossipComplete $player
			::Emote $npc 3
		}
	     }
	} 
proc QuestStatus { npc player } { 
set reply 7 
return $reply 
}
 
set loadinfo "Unbug System v1.00 Loaded" 
puts "[clock format [clock seconds] -format %H:%M:%S]:M:$loadinfo"
}